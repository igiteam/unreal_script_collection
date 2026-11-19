/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class Nano_KActor extends KActor
	implements( NanoInterface_PowerAffect, NanoInterface_Attraction, NanoInterface_Targetable, NanoInterface_CanAffectChaos, NanoInterface_BoulderedInto)
	native;

var()	bool	bCanBeDensed;
var()	float	DenseMassScale;
var()	float	DenseGravScale;
var()	float	DenseDampingScale;

var()	bool	bCanBeDusted;
var()	float	DustMassScale;
var()	float	DustGravScale;
var()	float	DustDampingScale;

var		repnotify ENanoState	CurrentState;

var()	float	ReturnToDefaultDelay;

var		transient MaterialInstanceConstant	MatInst;

/** If TRUE, this can only be moved by a dense playing colliding with it at speed */
var()	bool	bOnlyMovedWithDenseShove;
/** How fast this object moves after collision. 1.0 is same speed as player, >1.0 will move it faster than player */
var()	float	DenseShoveResultSpeed;
/** How far a target must be to have car try and hit them */
var()	float	MaxBoulderTargetDist;
/** If TRUE, kactor will 'home-in' on targets when bouldered into */
var()	bool	bBoulderWeaponisable;
/** How high the arc will go when flying at target (fraction of 2d distance) */
var()	float	BoulderLaunchHeightFactor;
/** Avoid getting multiple impulses  */
var		float	MinTimeBetweenBoulderImpulse;
/**  */
var		transient float	LastBoulderImpulseTime;

/** Scale how much force pawns apply to actor when standing on */
var()	float	PawnStandForceScale;

/** If TRUE, will switch physics to PHYS_RigidBody and take velocity from player when a player hits it whilst 'dropping hammer' */
var()	bool	bMakePhysicsOnHammerDrop;

/** How fast this object needs to be travelling before it will bust through BustableActors */
var()	float	BustSpeedThreshold;
var		bool	bInBustingMode;

var()	bool	bAttractPawns;

/** If TRUE, this actor will cause chaos when bashed into when dense (bouldered) */
var()	bool	bCauseChaosOnBoulderBash;

/** Draws a debug line to show when this is a targeted bash */
var()	bool	bDebugBoulderTargeting;

/** How fast object has to be going to hurt pacbot */
var()	float	PacBotImpactDamageSpeedThresh;
/** How much damage this object does when it hits a pacbot above PacBotImpactDamageSpeedThresh */
var()	int		PacBotImpactDamage;
/** Type of damage done when hitting a pacbot */
var()	class<NanoDamageType> PacBotImpactDamageType;

/** This is the current Chaos Zone this is in **/
var transient NanoVolume_ChaosZone CurrChaosZone;


cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual UBOOL CanCauseFractureOnTouch();
}

replication
{
	if (Role == ROLE_Authority)
		CurrentState;
}

simulated event ReplicatedEvent(Name VarName)
{
	switch( VarName )
	{
	case nameof(CurrentState):
		SetNanoState( CurrentState, None );
		break;
	}

	Super.ReplicatedEvent(VarName);
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	InitMatInstForPowers();

	// If this can be a weapon, make sure its doing checks for targets
	if(bBoulderWeaponisable)
	{
		bNoEncroachCheck = FALSE;
	}
}

/** Makes new instance from current material, and sets to default nano state */
simulated function InitMatInstForPowers()
{
	local int i;

	// Clear all applied material instances
	for(i=0; i<StaticMeshComponent.Materials.Length; i++)
	{
		StaticMeshComponent.SetMaterial(i, none);
	}
		
	// Create new one
	MatInst = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( MatInst );
}

/** 
 * This sets a timer to restore the car to a non Densed State so it will fly around again
 **/
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	local RB_BodySetup BS;

	// Do nothing if already in correct state
	if(NewState == CurrentState)
	{
		return TRUE;
	}

	if(NewState == ENS_Normal || (NewState == ENS_Dust && CurrentState == ENS_Dense) || (NewState == ENS_Dense && CurrentState == ENS_Dust))
	{
		RestoreDefaultNanoState();
	}
	else
	{
		BS = StaticMeshComponent.StaticMesh.BodySetup;

		if(NewState == ENS_Dust)
		{
			if(!bCanBeDusted)
			{
				return FALSE;
			}

			StaticMeshComponent.BodyInstance.InstanceMassScale = DustMassScale;
			StaticMeshComponent.BodyInstance.InstanceDampingScale = DustDampingScale;
			StaticMeshComponent.BodyInstance.CustomGravityFactor = DustGravScale;

			// When dusting, turn off collision
			SetCollision(bCollideActors, FALSE, bIgnoreEncroachers);
			// Turn off collision with dust volumes
			StaticMeshComponent.SetRBChannel(RBCC_Untitled1);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, FALSE);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, FALSE);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled2, FALSE);

			class'NanoTypes'.static.SetMaterialInstanceToDusted( MatInst );
		}
		else if(NewState == ENS_Dense)
		{
			if(!bCanBeDensed)
			{
				return FALSE;
			}

			StaticMeshComponent.BodyInstance.InstanceMassScale = DenseMassScale;
			StaticMeshComponent.BodyInstance.InstanceDampingScale = DenseDampingScale;
			StaticMeshComponent.BodyInstance.CustomGravityFactor = DenseGravScale;

			// When densing, ensure collision is on
			SetCollision(bCollideActors, TRUE, bIgnoreEncroachers);

			StaticMeshComponent.SetRBChannel(RBCC_GameplayPhysics);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, TRUE);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, TRUE);
			StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled2, TRUE);

			class'NanoTypes'.static.SetMaterialInstanceToDensed( MatInst );
		}

		StaticMeshComponent.BodyInstance.UpdateMassProperties(BS);
		StaticMeshComponent.BodyInstance.UpdateDampingProperties();

		SetTimer(ReturnToDefaultDelay, FALSE, nameof(RestoreDefaultNanoState));

		// Wake things up when changing mass
		StaticMeshComponent.WakeRigidBody();

		// Update current state
		CurrentState = NewState;
		
		// Fire any kismet events
		class'NanoTypes'.static.FireNanoStateChangeEvent(self, InInstigator, NewState);
	}
	return TRUE;
}

simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool CanBeDusted()
{
	return bCanBeDusted && CurrentState != ENS_Dust;
}

simulated function bool CanBeDensed()
{
	return bCanBeDensed && CurrentState != ENS_Dense;
}

simulated function bool IsDensed()
{
	return (CurrentState == ENS_Dense);
}

simulated function bool IsDusted()
{
	return (CurrentState == ENS_Dust);
}

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction )
{
	SetNanoState( InAction.NanoStateToBe, None );
}

simulated function RestoreDefaultNanoState()
{
	local RB_BodySetup BS;

	BS = StaticMeshComponent.StaticMesh.BodySetup;

	// you can't set defaults for instances on a static mesh (no default BodyInstance), so restore to class defaults
	StaticMeshComponent.BodyInstance.InstanceMassScale = class'RB_BodyInstance'.default.InstanceMassScale;
	StaticMeshComponent.BodyInstance.InstanceDampingScale = class'RB_BodyInstance'.default.InstanceDampingScale;
	StaticMeshComponent.BodyInstance.CustomGravityFactor = class'RB_BodyInstance'.default.CustomGravityFactor;

	StaticMeshComponent.BodyInstance.UpdateMassProperties(BS);
	StaticMeshComponent.BodyInstance.UpdateDampingProperties();

	// Turn collision back on
	SetCollision(bCollideActors, TRUE, bIgnoreEncroachers);

	StaticMeshComponent.SetRBChannel(RBCC_GameplayPhysics);
	StaticMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, TRUE);
	StaticMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, TRUE);
	StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled2, TRUE);

	class'NanoTypes'.static.SetMaterialInstanceToDefault( MatInst );

	// Set current state var back to normal
	CurrentState = ENS_Normal;
	
	// Fire any kismet events
	class'NanoTypes'.static.FireNanoStateChangeEvent(self, self, ENS_Normal);
}

////// NanoInterface_Targetable
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 10.0;
}

simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return TRUE;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}


simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated event vector GetTargetedLocation()
{
	// use middle of mesh bounds
	return StaticMeshComponent.Bounds.Origin;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return StaticMeshComponent.Bounds;
}


simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

//////

event Detach( Actor Other )
{
	// Avoid changing physics when in PHYS_Interpolating when you get off them! (code in DynamicSMActor)
}

/** Called when a pawn lands on this actor when dropping the hammer */
event HammerDropHit(NanoPawn HammerPawn)
{
	if((Physics != PHYS_RigidBody) && bMakePhysicsOnHammerDrop)
	{
		SetPhysics(PHYS_RigidBody);
		StaticMeshComponent.WakeRigidBody();
		StaticMeshComponent.SetRBLinearVelocity(HammerPawn.Velocity);
	}
}

simulated function bool ShouldAttractActor(Actor TestActor)
{
	if (bAttractPawns && NanoPawn(TestActor) != None)
	{
		return TRUE;
	}
	return FALSE;
}

simulated function Actor GetAttractionActor()
{
	return self;
}

simulated event vector GetAttractionLocationOffset();

simulated function bool AttractingPawn(NanoPawn NP);

/** This is just a click way to fire off any kismet notifies that need occur from when things are dense bashed**/
simulated event DenseBashFireOffKismetNotifies( NanoPawn ThePawn )
{
	// fire off event for kismet usage
	TriggerEventClass( class'SeqEvt_DenseBash', ThePawn, 0 );
}


simulated function vector CalcGoodLaunchVel(vector TargetPos)
{
	local float Grav, Dist2D, TossHeight, Launch2DVel, FlightTime;
	local vector LaunchVel, ToTarget2D;

	Grav = GetGravityZ();

	ToTarget2D = (TargetPos - Location);
	ToTarget2D.Z = 0.0;

	Dist2D = VSize(ToTarget2D);

	// Desired height to toss (with a min)
	TossHeight = FMax(Dist2D * BoulderLaunchHeightFactor, 100.0);

	// Based on conservation of energy - mv^2 (at launch) -> mgh (at apex), so v = sqrt(gh)
	LaunchVel.Z = sqrt(Abs(Grav) * TossHeight);
	// Calc time for vel to drop to zero, and double it (for down part as well)
	FlightTime = 2.0 * (LaunchVel.Z/Abs(Grav));
	// Figure out vel to reach target in that time along ground
	Launch2DVel = Dist2D/FlightTime;
	LaunchVel += (Normal(ToTarget2D) * Launch2DVel);
	
	return LaunchVel;
}

/** Find the best target  */
simulated function actor BestTargetInDir(NanoPawn LaunchingPawn, vector TargetDir)
{
	local NanoPC NPC;
	local Actor A, Best;
	local float Weight, BestWeight, ViewDot, Dist, Priority;
	local vector ToA;

	local array<Actor> TargetableWithinMaxRange;

	NPC = NanoPC(LaunchingPawn.Controller);

	if(NPC != None)
	{
		TargetableWithinMaxRange = NanoGRI(WorldInfo.GRI).FindAllNanoInterface_TargetableAroundPlayerPawn( NPC.MyNP, 4096 );

		// Iterate over potential targets
		foreach TargetableWithinMaxRange(A)
		{
			// If its not me..
			if (A != None && (A != LaunchingPawn) && (A != self))
			{
				Weight = -1.0;

				// Get base priority..
				Priority = NanoInterface_Targetable(A).GetBasePriority(NPC, LaunchingPawn);

				// If it has some priority and is visible..
				if(Priority > 0.0)
				{
					ToA = (A.Location - Location);
					Dist = VSize(ToA);
					ViewDot = (ToA/Dist) dot TargetDir;
					// If its fairly ahead and within range..
					if((Dist < MaxBoulderTargetDist) && (ViewDot > 0.3))
					{
						// ..set its priority based on this
						Weight = (Priority * ViewDot) + (Priority * (1.f - Dist/MaxBoulderTargetDist) * 0.5);
					}
				}

				// If this is best so far - remember it
				if ((Weight > 0.f) && (Weight > BestWeight))
				{
					Best = A;
					BestWeight = Weight;
				}
			}
		}
	}

	return Best;
}

simulated event vector CalcBoulderedLaunchVel(NanoPawn LaunchingPawn)
{
	local NanoGRI GRI;
	local Vector TargetDir;
	local Actor Best;

	GRI = NanoGRI(WorldInfo.GRI);

	// Increase chaos level on boulder launch (if desired)
	if(bCauseChaosOnBoulderBash)
	{
		GRI.ModifyChaosLevel( GetChaosZone(), LaunchingPawn, class'NanoCausingChaosValues'.default.KActorBoulderBashed );
	}

	// Find something to target in the direction we (launching pawn) is moving
	TargetDir = Normal(LaunchingPawn.Velocity);
	Best = BestTargetInDir(LaunchingPawn, TargetDir);
	if(Best != None)
	{
		// Show debug indicating this is a auto-targeted launch
		if(bDebugBoulderTargeting)
		{
			DrawDebugLine(Location, Best.Location, 255,255,0, TRUE);
		}
		return CalcGoodLaunchVel(Best.Location);
	}

	return LaunchingPawn.Velocity * DenseShoveResultSpeed;
}

/** Called when bouldered into by a pawn */
simulated function BoulderedIntoBy(NanoPawn NP)
{
	local Vector LaunchVel;

	// if we are really running at the kactor, and its been long enough since last impulse
	if( (WorldInfo.TimeSeconds - LastBoulderImpulseTime) > MinTimeBetweenBoulderImpulse )
	{
		// Let the kactor calc its launch vel
		LaunchVel = CalcBoulderedLaunchVel(NP);
		StaticMeshComponent.AddImpulse(LaunchVel, Location, '', TRUE);
		DenseBashFireOffKismetNotifies(NP);
		
		// Update last boulder time
		LastBoulderImpulseTime = WorldInfo.TimeSeconds;
	}
}

simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	CurrChaosZone = InChaosZone;
}



defaultproperties
{
	CurrentState=ENS_Normal

	ReturnToDefaultDelay=10.0

	DenseMassScale=10.0
	DenseDampingScale=0.0
	DenseGravScale=2.0

	DustMassScale=0.1
	DustDampingScale=10.0
	DustGravScale=0.2

	bCanBeDensed=TRUE
	bCanBeDusted=TRUE

	bPawnCanBaseOn=TRUE
	bSafeBaseIfAsleep=FALSE
	bCanStepUpOn=FALSE

	bMakePhysicsOnHammerDrop=TRUE
	PawnStandForceScale=1.0
	DenseShoveResultSpeed=1.5
	MaxBoulderTargetDist=2500.0
	BoulderLaunchHeightFactor=0.2
	MinTimeBetweenBoulderImpulse=0.5

	bCauseChaosOnBoulderBash=TRUE

	SupportedEvents.Add(class'SeqEvt_NanoStateChanged')
	SupportedEvents.Add(class'SeqEvt_DenseBash')

	Begin Object Name=StaticMeshComponent0
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
	End Object

	PacBotImpactDamageType=class'NDT_PhysCrushed'
	PacBotImpactDamageSpeedThresh=100.0
	PacBotImpactDamage=1000

	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

}