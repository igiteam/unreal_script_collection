/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearLambentPodSeedBase extends Actor
	config(Game);

/** Timestamp of state start */
var transient float StateTime;
/** Current pod state */
var transient name SeedState;
/** Calculated velocity to eject the seed */
var transient vector LandingVelocity;

/** Time to grow pod from 0 to full scale (secs) */
var() float TimeToGrow;
/** Size of the seed at grow start */
var() float MinSeedScale;
/** Size of the seed at ejection time */
var() float EjectSeedScale;
/** Max size to grow pod (1.0 is mesh default) */
var() float MaxSeedScale;
var transient float CurrentGrowScale;

/** Units to push the pod forward after spawn before dropping */
var() float PodEjectionLength;

/** Speed to eject the pod in the ejection direction */
var() float PodEjectionSpeed;

/** Position of the pod on attach */
var transient vector PodStartPosition;
/** Position of pod when ready to eject */
var transient vector PodEjectFinalPosition;

/** Seed mesh */
var() StaticMeshComponent SeedMesh;
/** Seed explosion archetype */
var() GearExplosion	ExplosionTemplate;
/** Seed ground impact effect */
var() GearExplosion GroundHitTemplate;

/** Time to hit the ground */
var repnotify transient float TimeToFall;

/** Time from hitting ground until exploding and emerging an enemy */
var() float TimeToEmerge;
/** Normal at the point of seed impact */
var transient vector SeedHitNormal;
/** Notification of landing */
var repnotify bool bLanded;
/** Did we finish the emerge */
var bool bEmergeComplete;
/** Current interp of the splat vertex effect */
var float CurrentSplatRamp;
/** Time to full splat compression */
var float SeedSplatRampUpTime;
/** Time to full splat uncompression */
var float SeedSplatRampDownTime;
/** MIC for the splat material effect */
var array<MaterialInstanceConstant> SeedMaterials;
/** The light environment for the seed */
var DynamicLightEnvironmentComponent LightEnvironment;

replication
{
	if (Role == ROLE_Authority)
		SeedHitNormal, bLanded, TimeToFall;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'TimeToFall')
	{
		GotoState('Ejecting');
	}
	else if (VarName == 'bLanded')
	{
		GotoState('OnGround');
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
}

/** 
 * Function to replace the materials with material instances so they can be changed independently
 */
simulated function ConstructSeedMaterialInstances()
{
	local int i, NumMaterials;
	local MaterialInstanceConstant MIC;
	if (SeedMesh != None && SeedMesh.StaticMesh != None)
	{
		NumMaterials = SeedMesh.GetNumElements();
		SeedMaterials.length = NumMaterials;
		for (i=0; i<NumMaterials; i++)
		{
			MIC = SeedMesh.CreateAndSetMaterialInstanceConstant(i);
			SeedMaterials[i] = MIC;
		}
	}
}

/**
 * Setup the seed spawn
 * @param MyOwner - pod that is dropping the seed
 * @param EjectionSpeed - pod ejection speed
 * @param AnimTimeToGrow - pod anim time to fully open
 * @param SeedScale - max size the seed will grow to
 */
function Init(GearSpawner MyOwner, float EjectionSpeed, float AnimTimeToGrow, float SeedScale)
{
	TimeToGrow = AnimTimeToGrow;
	PodEjectionSpeed = EjectionSpeed;
	MaxSeedScale = SeedScale;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ConstructSeedMaterialInstances();
}

function Grow()
{
	GotoState('Growing');
}

/** Seed spawned but doing nothing */
auto state Inactive
{
	function BeginState(Name PreviousStateName)
	{
		SeedState = GetStateName();
		if (Role == ROLE_Authority)
		{
			SetCollision(false, false, false);

			PodStartPosition = Location;
			PodEjectFinalPosition = Location + (Vector(Rotation) * PodEjectionLength);
			SetLocation(PodStartPosition);
		}
	}
}

/** Seed is growing in size and pushing its way out of the pod */
state Growing
{
	function BeginState(Name PreviousStateName)
	{
		SeedState = GetStateName();
		StateTime = WorldInfo.TimeSeconds;
		CurrentGrowScale = 0.0;
	}

	function Tick(float DeltaTime)
	{
		local vector NewPosition;
		local float CurrentAlpha;

		if (Role == ROLE_Authority)
		{
			CurrentAlpha = FClamp((WorldInfo.TimeSeconds - StateTime) / TimeToGrow, 0.0, 1.0);
			// Grow the pod, while pushing it out
			CurrentGrowScale = Lerp(MinSeedScale, EjectSeedScale, CurrentAlpha);
			SetDrawScale(CurrentGrowScale);
			NewPosition = VLerp(PodStartPosition, PodEjectFinalPosition, CurrentAlpha);
			SetLocation(NewPosition);
		}
	}

Begin:
	// We are coming out
	Sleep(TimeToGrow);
	if(Role==ROLE_Authority)
 	{
		// Ready to eject from the pod
 		GotoState('Ejecting');
 	}
};

/** Seed is falling from the pod toward the ground */
state Ejecting
{
	simulated function BeginState(Name PreviousStateName)
	{
		SeedState = GetStateName();
		StateTime = WorldInfo.TimeSeconds;
		if (Role == ROLE_Authority)
		{
			DropSeed(Location);
		}
	}

	simulated function Tick(float DeltaTime)
	{
		local float TimeFalling, TimeToHitGround;
		local float CurrentAlpha;
		local MaterialInstanceConstant MIC;

		TimeFalling = `TimeSince(StateTime);
		CurrentAlpha = FClamp(TimeFalling / (0.5*TimeToFall), 0.0, 1.0);

		// Grow the pod to its final size
		CurrentGrowScale = Lerp(EjectSeedScale, MaxSeedScale, CurrentAlpha);
		SetDrawScale(CurrentGrowScale);

		TimeToHitGround = TimeToFall - TimeFalling;
		if (TimeToHitGround <= SeedSplatRampUpTime)
		{			
			CurrentSplatRamp = FClamp(Lerp(0,1,(1.0 - TimeToHitGround/SeedSplatRampUpTime)), 0, 1);
			foreach SeedMaterials(MIC)
			{
				if (MIC != None)
				{
					MIC.SetScalarParameterValue('Squash', CurrentSplatRamp);
				}
			}

			if (TimeToHitGround <= 0.033)
			{
				if (!bLanded)
				{
					DoLandingEffects();
				}
			}
		}
	}
};

/** Pod hit the ground and is ready to spawn a pawn */
state OnGround
{
	simulated function BeginState(Name PreviousStateName)
	{
		SeedState = GetStateName();
		StateTime = WorldInfo.TimeSeconds;
	}

	simulated function Tick(float DeltaTime)
	{
		local float TimeSinceHitGround;
		local MaterialInstanceConstant MIC;

		TimeSinceHitGround = `TimeSince(StateTime);
		CurrentSplatRamp = Clamp(Lerp(1,0,TimeSinceHitGround/SeedSplatRampDownTime), 0, 1);
 		if (!bEmergeComplete && CurrentSplatRamp <= 0.1)
 		{
 			bEmergeComplete = true;
 			Emerge();
 		}

		foreach SeedMaterials(MIC)
		{
			if (MIC != None)
			{
				MIC.SetScalarParameterValue('Squash', CurrentSplatRamp);
			}
		}
	}

	simulated function Emerge()
	{
		// Tell pod that we've hit the ground
		if (Role == ROLE_Authority)
		{   
			GearSpawner_LambentPodBase(Owner).SetSeedLocation(Location);
		}
		
		DoExplosion();
	}

Begin:
	//Sleep(TimeToEmerge);
	//Emerge();
};

/** Drop the seed to the ground with a specific velocity */
function DropSeed(vector DropPoint)
{
	local vector	HitLocation, HitNormal, StartTrace, EndTrace, VecRot;
	local Rotator	AdditionalRot;
	local float		TotalRotation, HeightToFall;
	local Rotator	EjectVectorNoZ;
	local vector2d  outVector;

	VecRot = Vector(Rotation);
	StartTrace = DropPoint + VecRot * PodEjectionSpeed; 
	EndTrace = StartTrace + vect(0,0,-5000);

	Trace(HitLocation, HitNormal, EndTrace, StartTrace, false, vect(0,0,0));

	HeightToFall = DropPoint.Z - HitLocation.Z - CollisionComponent.Bounds.BoxExtent.Z; 

	// Time to fall from height (Unreal is twice gravity?)  t = sqrt(2*height/2*gravity)
	TimeToFall = Sqrt(abs(HeightToFall/GetGravityZ()));

	// Specific xy plane starting velocity
	// Straight up isn't handled and straight down needs no extra velocity
	// it will only mess up the above TimeToFall calculation
	if (VecRot.Z > -0.9 && VecRot.Z < 0.9)
	{
		EjectVectorNoZ.Yaw = Rotation.Yaw;
		LandingVelocity = Vector(EjectVectorNoZ) * PodEjectionSpeed; 
	}

	// Calc rotation rate (rotation to move seed to horizontal position)
	AdditionalRot.Pitch = Rotation.Pitch;
	GetAngularDistance(outVector, Vector(AdditionalRot), vect(1,0,0), vect(0,1,0), vect(0,0,1));
	if (outVector.Y > 0)
	{
	   	TotalRotation = RadToDeg * outVector.Y; 
	}
	else
	{
	   	TotalRotation = (180.0 - RadToDeg * -outVector.Y); 
	}

	Velocity = LandingVelocity;
	// Negative pitch when spinning out
	RotationRate.Pitch = int((TotalRotation/TimeToFall)*-182.04);
	SetPhysics(PHYS_Falling);
	bForceNetUpdate = true;
}

/** Called when seed hits the ground */
event Landed( vector HitNormal, actor FloorActor )
{
	// spawn particle effect
	SeedHitNormal = HitNormal;
	if (!bLanded)
	{
		DoLandingEffects();
	}
	GotoState('OnGround');
}

simulated function DoLandingEffects()
{
	local GearExplosionActor GroundHitActor;

	bLanded = true;

	GroundHitTemplate.InitFromContentTemplate();
	// Orient particle effect with X up
	GroundHitActor = Spawn(class'GearExplosionActor',,, Location, Rotator(vect(0,0,1)));
	GroundHitActor.Explode(GroundHitTemplate);
	GroundHitActor.LifeSpan = 1.0;
}

/** Explode the seed on impact */
simulated function DoExplosion()
{
	local GearExplosionActor ExplosionActor;

	SetHidden(true);
	ExplosionTemplate.InitFromContentTemplate();
	// Orient particle effect with X up
	ExplosionActor = Spawn(class'GearExplosionActor',,, Location, Rotator(SeedHitNormal));
	ExplosionActor.Explode(ExplosionTemplate);
	ExplosionActor.LifeSpan=0.5;
	Lifespan=1.0;
	GotoState('');
}

defaultproperties
{
	Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=40.0
		CollisionHeight=5.0

		BlockNonZeroExtent=true	 // players can't walk through 
		BlockZeroExtent=false	 // bullets don't collide
		BlockActors=false
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=TRUE
		ModShadowFadeoutTime=0.75f
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=TheMesh
		CollideActors=true
		BlockActors=false			// players collide with cylinder component above
		BlockZeroExtent=true		// bullets collide against visible mesh
		BlockNonZeroExtent=false	// players collide against cylinder component above
		BlockRigidBody=false
		LightEnvironment=MyLightEnvironment
	End Object
	SeedMesh=TheMesh
	Components.Add(TheMesh)

    // Will be set to PHYS_Falling when its time
	Physics=PHYS_None
	RemoteRole=ROLE_SimulatedProxy
	bReplicateMovement=true
	bUpdateSimulatedPosition=true
	bAlwaysRelevant=true
	bGameRelevant=true
	LifeSpan=0

	bCollideActors=true	 // Collision is on for world geometry
	bProjTarget=true
	bBlockActors=false   // Actor penetration doesn't matter yet
	bCollideWorld=true	 // Always collide with the world

	MinSeedScale=.3
	EjectSeedScale=.5
	MaxSeedScale=.6
	TimeToGrow=1.25
	TimeToEmerge=0.05
	PodEjectionLength=60
	PodEjectionSpeed=550

	SeedSplatRampUpTime=0.2
	SeedSplatRampDownTime=0.6

	// explosion when the pod opens
	Begin Object Class=GearExplosion Name=ExploTemplate0
	    MyDamageType=class'GDT_EmergenceHoleOpening'
		MomentumTransferScale=0.f	// Scale momentum defined in DamageType
		ActorClassToIgnoreForDamage=class'GearGame.GearPawn_LocustBase'
		ActorClassToIgnoreForKnockdownsAndCringes=class'GearGame.GearPawn_LocustBase'

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		Damage=700
		DamageRadius=256
		DamageFalloffExponent=1.0f

		KnockDownRadius=0
		CringeRadius=512
	End Object
	ExplosionTemplate=ExploTemplate0	
}