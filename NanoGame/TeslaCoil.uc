/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class TeslaCoil extends Actor
	native
	implements( NanoInterface_Targetable,  NanoInterface_OrbitalTarget )
	config(Weapon)
	placeable;

var SkeletalMeshComponent Mesh;
var AnimNodeSlot MainSlot;

var bool bDeployed;
var Name DeployAnimName;

var bool bExtended;
var Name ExtendAnimName;

var byte TeamNum;

var ParticleSystem DeployedPS;
var ParticleSystem BoltPS;
var ParticleSystem FencePS;

/** After landing, Tesla Stick extends to full height and deploys shocker.  This sound is a composite for the current extension animation; if this animation gets more complicated we can add more cues to match the movement. **/
var SoundCue DeploySound;

/** Tesla Stick starts its electrical effect.  The Tesla_Single_LoopCue starts at the same time. **/
var SoundCue ActivateElectricitySound;

/** Telsa Stick ambient electrical field loop. **/
var SoundCue ElectricityLoopingSound;
var transient AudioComponent AC_ElectricityLoopingSound;

/** 'Dual Tesla Sticks starts their electrical forcefield effect.   **/
var SoundCue ActivateFenceSound;

var SoundCue FenceLoopingSound;
var transient AudioComponent AC_FenceLoopingSound;


struct native LinkedCoilDatum
{
	var SpawnedNanoEmitter FenceEmitter;
	var vector LocEmitterHas;
	var TeslaCoil CoilWhichMightMove;
};


var transient SpawnedNanoEmitter DeployedEmitter;
var transient array<LinkedCoilDatum> FenceEmitters;
var transient array<TeslaCoil> LinkedCoils;

/** Amount of damge to do when zapping **/
var config float ZapDamage;

/** Amount of damage to do when the fences hit the player **/
var config float LinkedDamage;

var config int Health;

/** This is how long the TeslaCoil will live before it self decays **/
var config float TimeToDecay;


var protected ParticleSystem HitAndKilledByRicochetMoon;

var protected MaterialInterface SpawnedDecalMaterial;

var transient NanoDecal TeslaCoilDeployedDecal;


/** These are the orbital attractors currently on this actor.  They get turned on and off by the NanoWeap_Orbitals_Base **/
var transient array<NxForceField> OrbitalsAttractList;

/** This is the distance to link tesla coils up at **/
var float LinkDistance;

/** AI to notify when we are destroyed **/ 
var transient array<NanoAI> AIWhoCaresAboutThisBeingDestroyed;

/** Ignore these pawns for damage **/
var transient array<NanoPawn> IgnoreForDamage;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MainSlot = AnimNodeSlot(Mesh.FindAnimNode('MainSlot'));
	SetTimer(1.f,FALSE,nameof(ExtendCoil));

	NanoGRI(WorldInfo.GRI).RegisterTargetableActor( self );
	NanoGRI(WorldInfo.GRI).ActorsToAvoid.AddItem(self);

	Lifespan = TimeToDecay;
}

function Destroyed()
{
	local NxForceField FF;
	local int Idx;

	Super.Destroyed();

	NanoGRI(WorldInfo.GRI).ActorsToAvoid.RemoveItem(self);
	for (Idx = 0; Idx < FenceEmitters.Length; Idx++)
	{
		FenceEmitters[Idx].FenceEmitter.Destroy();
	}
	FenceEmitters.Length = 0;

	for (Idx = 0; Idx < LinkedCoils.Length; Idx++)
	{
		LinkedCoils[Idx].NotifyCoilToRemoveSelf(self);
	}
	LinkedCoils.Length = 0;

	if( DeployedEmitter != none )
	{
		DeployedEmitter.ParticleSystemComponent.DeActivateSystem();
	}

	if( TeslaCoilDeployedDecal != none )
	{
	    TeslaCoilDeployedDecal.ResetToDefaults();
	}

	if( AC_ElectricityLoopingSound != none )
	{
		AC_ElectricityLoopingSound.FadeOut( 0.1f, 0.0f );
		AC_ElectricityLoopingSound = none;
	}

	if( AC_FenceLoopingSound != none )
	{
		AC_FenceLoopingSound.FadeOut( 0.1f, 0.0f );
		AC_FenceLoopingSound = none;
	}

	foreach OrbitalsAttractList(FF)
	{
		FF.Destroy();
	}

	ClearTimer(nameof(ExtendCoil));
	ClearTimer(nameof(DeployCoil));
	ClearTimer(nameof(FinishedDeploying));
}

simulated event vector GetTargetedLocation()
{
	local float Radius, Height;
	GetBoundingCylinder(Radius,Height);
	return Mesh.GetBoneLocation('Object09') - vect(0,0,1) * Height * 0.75;
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
	return Mesh.Bounds;
}


simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}
 	else 
	if( (Askee.Pawn != none) && ( ClassIsChildOf( Askee.Pawn.Class, class'NanoPawn_MetaCorpBase' ) == TRUE ) )
	{
		return INDEX_NONE;
	}
	else
	{
		// default priority
		//@todo - config property?
		return 10.f;
	}
}
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (`TimeSince(LastRenderTime) < 1.f) && (Health > 0);
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


simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 1.f);
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook )
{
	RicochetMoonImpact();
	return FALSE;
}

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return TRUE;
}

simulated function ExtendCoil()
{
	local float AnimTime;
	AnimTime = MainSlot.PlayCustomAnim(ExtendAnimName,0.5f,0.1f,-1.f,FALSE);
	SetTimer(AnimTime,FALSE,nameof(DeployCoil));
	PlaySound( DeploySound );
}

simulated function DeployCoil()
{
	local float AnimTime;
	AnimTime = MainSlot.PlayCustomAnim(DeployAnimName,1.f,0.1f,-1.f,FALSE);
	SetTimer(AnimTime,FALSE,nameof(FinishedDeploying));
}

simulated function FinishedDeploying()
{
	DeployedEmitter = Spawn(class'SpawnedNanoEmitter');
	DeployedEmitter.SetTemplate(DeployedPS);
	DeployedEmitter.ParticleSystemComponent.ActivateSystem();
    //DeployedEmitter.SetHardAttach( TRUE );
	DeployedEmitter.SetBase( self );

	TeslaCoilDeployedDecal = NanoGRI(WorldInfo.GRI).LeaveADecalWorld( DecalTrace_StraightDown, DecalChoice_Default, DecalTimeVaryingParams_Default, Location );

	PlaySound( ActivateElectricitySound );

	AC_ElectricityLoopingSound = new(self) class'AudioComponent';
	if( AC_ElectricityLoopingSound != none )
	{
	    AC_ElectricityLoopingSound.SoundCue = ElectricityLoopingSound;
		AttachComponent( AC_ElectricityLoopingSound );
		AC_ElectricityLoopingSound.FadeIn( 0.2f, 1.0f );
	}

	GotoState('Deployed');
}


protected simulated delegate DecalTrace_StraightDown( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	out_TraceStart = ForceStartLocation + ( Vect(0,0,15));
	out_TraceDest =  out_TraceStart - ( Vect(0,0,100));
}

/** This is the Delegate for the Decal Choice Policy for LeaveADecal **/
protected simulated delegate DecalChoice_Default( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	local DecalData DD;

	DD.Width=360.0f;
	DD.Height=360.0f;

	DD.DecalMaterial = SpawnedDecalMaterial;

	out_DecalData = DD;	
}

/** This is the Delegate for the MITV Params Policy for LeaveADecal **/
protected simulated delegate DecalTimeVaryingParams_Default( out MaterialInstance MI_Decal )
{
}


simulated function Tick(float DeltaTime)
{
	local vector BaseBoneLoc;

	// interpolate the translation based on the bottom bone position
	if (IsTimerActive(nameof(DeployCoil)))
	{
		BaseBoneLoc = Mesh.GetBoneLocation('Box03',1);
		Mesh.SetTranslation(vect(0,0,-1) * BaseBoneLoc.Z);
	}

	UpdateFenceEmitters();
}


simulated function UpdateFenceEmitters()
{
	local int Idx;
	local NanoGRI NGRI;
	local Actor PossibleTeslaCoil;
	local LinkedCoilDatum LCD;
	local TeslaCoil TC;

	// update the location of the moving teslas
    NGRI = NanoGRI(WorldInfo.GRI);
	foreach NGRI.ActorsToAvoid( PossibleTeslaCoil )
	{
		TC = TeslaCoil(PossibleTeslaCoil);

		if( ( TC != none ) && ( TC != self ) )
		{
			Idx = TC.LinkedCoils.Find( self );
			if( Idx == INDEX_NONE )
			{
				if( VSize(Location - PossibleTeslaCoil.Location) < LinkDistance )
				{
					CreateFenceEmitter( TC );
				}
			}
		}
	}

	// and check to see if we are out of the link up distance
	foreach FenceEmitters( LCD )
	{
		if( VSize(Location - LCD.CoilWhichMightMove.Location) > LinkDistance )
		{
			//`log( "Removing:" @ self @ LCD.CoilWhichMightMove );
			LCD.CoilWhichMightMove.NotifyCoilToRemoveSelf( self );
			NotifyCoilToRemoveSelf( LCD.CoilWhichMightMove );
			LCD.FenceEmitter.ParticleSystemComponent.DeactivateSystem();
		}
	}


	// and check to see if we are out of the link up distance
	foreach FenceEmitters( LCD )
	{
		if( LCD.LocEmitterHas != LCD.CoilWhichMightMove.Location )
		{
			LCD.FenceEmitter.SetVectorParameter( 'ArcDest', LCD.CoilWhichMightMove.Location );
		}
	}

}


/** If TelsaCoil is hit by RicochetMoon, it is destroyed **/
simulated function RicochetMoonImpact()
{
	DestroyAndPlayExplosion();
}


/** If TelsaCoil is hit by DropTheHammer, it is destroyed **/
simulated function DropTheHammerImpact()
{
	DestroyAndPlayExplosion();
}


/** If TelsaCoil is hit by SwordSuperMoveImpact, it is destroyed **/
simulated function SwordSuperMoveImpact()
{
	DestroyAndPlayExplosion();
}



/** If TelsaCoil is hit by RicochetMoon, it is destroyed **/
private simulated function DestroyAndPlayExplosion()
{
	local SpawnedNanoEmitter Explosion;

	Explosion = Spawn(class'SpawnedNanoEmitter',,,Location);
	Explosion.SetTemplate( HitAndKilledByRicochetMoon, FALSE );
	Explosion.Lifespan = 5.f;
	Explosion.ParticleSystemComponent.ActivateSystem();

	Destroy();
}

function NotifyCoilToRemoveSelf(TeslaCoil LinkedCoil)
{
	local int Idx;
	Idx = LinkedCoils.Find(LinkedCoil);
	if (Idx != INDEX_NONE)
	{
		LinkedCoils.Remove(Idx,1);
		FenceEmitters.Remove(Idx,1);
	}
}


/** This will create a fence emitter with the passed in TeslaCoil. **/
function SpawnedNanoEmitter CreateFenceEmitter( TeslaCoil LinkedCoil )
{
	local SpawnedNanoEmitter FenceEmitter;
	local LinkedCoilDatum LCD;

	FenceEmitter = Spawn(class'SpawnedNanoEmitter',,,Location);
    FenceEmitter.SetTemplate(FencePS,FALSE);
	FenceEmitter.SetVectorParameter('ArcDest',LinkedCoil.Location);
	FenceEmitter.ParticleSystemComponent.ActivateSystem();
	FenceEmitter.LifeSpan = 0.0f;
    FenceEmitter.SetBase( self );


	LCD.FenceEmitter = FenceEmitter;
	LCD.LocEmitterHas = LinkedCoil.Location;
    LCD.CoilWhichMightMove = LinkedCoil;
				
    FenceEmitters.AddItem( LCD );
    LinkedCoils.AddItem( LinkedCoil );

	LinkedCoil.FenceEmitters.AddItem( LCD );
	LinkedCoil.LinkedCoils.AddItem( self );

	return FenceEmitter;
}



state Deployed
{
	function BeginState(Name PrevStateName)
	{
		SetupLinkedCoils();
		SetTimer(1.f,FALSE,nameof(ZapSomeFools));
	}

	function SetupLinkedCoils()
	{
		local TeslaCoil Coil;
		local float DistanceBetweenCoils;
		local Vector LocationToSpawnFenceSound;

		foreach AllActors(class'TeslaCoil',Coil)
		{
			DistanceBetweenCoils = VSize(Coil.Location - Location);

			if (Coil != self && DistanceBetweenCoils < LinkDistance && Coil.LinkedCoils.Find(self) == INDEX_NONE)
			{
				`log("linking"@self@"to"@Coil);

				CreateFenceEmitter( Coil );

				PlaySound( ActivateFenceSound );
				AC_FenceLoopingSound = new(self) class'AudioComponent';
				if( AC_FenceLoopingSound != none )
				{
	                AC_FenceLoopingSound.SoundCue = FenceLoopingSound;
		            AttachComponent( AC_FenceLoopingSound );
				
					LocationToSpawnFenceSound = Location + ( ( Normal(Coil.Location - Location) * DistanceBetweenCoils/2) ) + vect(0,0,64);
					//DrawDebugCoordinateSystem( LocationToSpawnFenceSound, rot(0,0,0), 20.0f, TRUE );
					//DrawDebugLine( Location, Location + LocationToSpawnFenceSound, 255, 0, 0, TRUE );

	                AC_FenceLoopingSound.Location = LocationToSpawnFenceSound;

		            AC_FenceLoopingSound.FadeIn( 0.2f, 1.0f );
				}

			}
		}
		if (LinkedCoils.Length > 0)
		{
			SetTimer(0.25f,FALSE,nameof(CheckLinkedCoils));
		}
	}

	function CheckLinkedCoils()
	{
		local int Idx;
		local vector HitL, HitN;
		local Actor HitA;
		for (Idx = 0; Idx < LinkedCoils.Length; Idx++)
		{
			if (LinkedCoils[Idx] != None)
			{
				// need to offset the trace location as the origin of the tesla coil is in the ground
				HitA = Trace(HitL,HitN,LinkedCoils[Idx].Location+vect(0,0,48),Location+vect(0,0,48),TRUE,vect(32,32,32));
				if( ( NanoPawn_RebelsBase(HitA) != None ) && ( ShouldDoDamage( NanoPawn(HitA) ) == TRUE ) )
				{
					HitA.TakeDamage(LinkedDamage, None, HitA.Location, vect(0,0,0), class'NDT_TeslaCoil_Fence',, self );
				}
			}
			else
			{
				LinkedCoils.Remove(Idx--,1);
			}
		}
		if (LinkedCoils.Length > 0)
		{
			SetTimer(0.25f,FALSE,nameof(CheckLinkedCoils));
		}
	}

	function EndState(Name NextStateName)
	{
		ClearTimer(nameof(CheckLinkedCoils));
		ClearTimer(nameof(ZapSomeFools));
	}

	function ZapSomeFools()
	{
		local NanoPawn_RebelsBase Pawn;
		local vector ZapLocation;
		local SpawnedNanoEmitter BoltEmitter;
		ZapLocation = Mesh.GetBoneLocation('Object09');
		foreach VisibleCollidingActors(class'NanoPawn_RebelsBase',Pawn,256.f)
		{
			if (/*Pawn.GetTeamNum() != TeamNum &&*/ Pawn.Health > 0)
			{
				BoltEmitter = Spawn(class'SpawnedNanoEmitter');
				BoltEmitter.SetTemplate(BoltPS,FALSE);
				BoltEmitter.SetVectorParameter('ArcDest',Pawn.Location);
				BoltEmitter.SetVectorParameter('ArcSource',ZapLocation);
				BoltEmitter.ParticleSystemComponent.ActivateSystem();
				BoltEmitter.Lifespan = 5.f;
				if( ShouldDoDamage( Pawn ) == TRUE )
				{
					`log("zapping"@`showvar(Pawn)@`showvar(Pawn.GetTeamNum())@`showvar(Pawn.Health));
				    Pawn.TakeDamage(ZapDamage, None, Pawn.Location, vect(0,0,0), class'NDT_TeslaCoil',, self);
				}
			}
		}
		SetTimer(RandRange(0.5,1.f),FALSE,nameof(ZapSomeFools));
	}
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local NanoPawn NP;

	Health -= Damage;

	NP = NanoPawn(InstigatedBy.Pawn);
	if( NP != None )
	{
		NP.DoBlockedByEffects(HitLocation,NP.Rotation,ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_Nano_Sword_BlockSparks',SoundCue'Weapon_Sword.Sword.Sword_Impact_Metal_Cue');
	}	

	if (Health < 0)
	{
		NotifyAIThatCare( InstigatedBy );
		DestroyAndPlayExplosion();
	}
}




simulated function SetUpOrbitalAttractor()
{
	AddAnOrbitalAttractorRadial( 256.0f, -50.0f );
}

simulated function AddAnOrbitalAttractorRadial( float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorRadial OrbitalsAttact;

	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorRadial', self,,Location+Vect(0,0,50) ); // prob want to do a box shape here
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeSphere';

    OrbitalsAttact.bForceActive = FALSE;

    OrbitalsAttact.ForceRadius = InRadius;
	OrbitalsAttact.ForceStrength = InStrength;
	OrbitalsAttact.ForceFalloff = RIF_Linear;

    OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttractList.AddItem( OrbitalsAttact );
}


/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors()
{
	local NxForceField FF;

	// make certain we have some force fields
	if( OrbitalsAttractList.Length == 0 )
	{
		//SetUpOrbitalAttractor();
	}

	foreach OrbitalsAttractList(FF)
	{
		//`log( "ActivateOrbitalAttractors" @ self @ FF );
		FF.bForceActive = TRUE;
		//FF.DoInitRBPhys();
	}
}

/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors()
{
	local NxForceField FF;

    //`log( "DeactivateOrbitalAttractorsDeactivateOrbitalAttractorsDeactivateOrbitalAttractors" @ self );

	foreach OrbitalsAttractList(FF)
	{
		FF.bForceActive = FALSE;
		//FF.DoInitRBPhys();
	}
}

/** This is needed to find the location of this OrbitalTarget **/
simulated event vector GetOrbitalTargetLocation()
{    
	return Location+Vect(0,0,50);
}

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage()
{
	return 128.0f;
}

/** How many orbitals need to be touching this pawn for damage to occur (where touching is being within range **/
simulated event int GetNumOrbitalsTouchingForDamage()
{
	return 5;
}

function Knockback( vector Dir,  bool InbKnockDownOnLanding, optional name StunDesc );

/** Will register an AI that cares what happens to this telsa coil **/
simulated function RegisterAIThatCares( NanoAI AI )
{
	AIWhoCaresAboutThisBeingDestroyed.AddItem( AI );
}

/** **/
simulated function NotifyAIThatCare( Controller InstigatedBy )
{
	local NanoAI AI;
	foreach AIWhoCaresAboutThisBeingDestroyed( AI )
	{
		if( AI != none )
		{
		    AI.TeslaCoilWeCareAboutWasDestroyed( self, InstigatedBy );
		}
	}
}


/** checks to see if we should do damage to this pawn **/
simulated function bool ShouldDoDamage( NanoPawn NP )
{
	if( IgnoreForDamage.Find( NP) != INDEX_NONE )
	{
		return FALSE;
	}

	return TRUE;
}

/** Will add a NanoPawn that we should not damage **/
simulated function AddIgnoreDamage( NanoPawn NP )
{
	IgnoreForDamage.AddItem( NP );
}

/** Will remove a NanoPawn that we should not damage **/
simulated function RemoveIgnoreDamage( NanoPawn NP )
{
	IgnoreForDamage.RemoveItem( NP );
}



defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=MeshComp
		SkeletalMesh=SkeletalMesh'MET_TeslaStick.SK_MET_TeslaStick'
		AnimTreeTemplate=AnimTree'MET_TeslaStick.AT_MET_TeslaStick'
		AnimSets(0)=AnimSet'MET_TeslaStick.SK_MET_TeslaStick_Anims'
		PhysicsAsset=PhysicsAsset'MET_TeslaStick.SK_MET_TeslaStick_Physics'
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
        bUpdateSkelWhenNotRendered=FALSE
	End Object
	Mesh=MeshComp
	CollisionComponent=MeshComp
	Components.Add(MeshComp)


	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)


	bBlockActors=TRUE
	bCollideActors=TRUE
	bProjTarget=TRUE

	DeployAnimName=Deploy
	ExtendAnimName=Extend

	TeamNum=255

	DeployedPS=ParticleSystem'Nano_WeaponFX.Tesla.Effects.P_Nano_Weapon_TeslaDeployed'
	BoltPS=ParticleSystem'Nano_WeaponFX.Tesla.Effects.P_Nano_Weapon_TeslaBolt'
	FencePS=ParticleSystem'Nano_WeaponFX.Tesla.Effects.P_Nano_Weapon_TeslaFence'

	HitAndKilledByRicochetMoon=ParticleSystem'COG_Mortar.Effects.P_Mortar_Ground_Explosion_Stone'

	SpawnedDecalMaterial=MaterialInterface'Nano_WeaponFX.Tesla.Decals.D_Tesla_Base_Decal'

	LinkDistance=768.0f

	DeploySound=SoundCue'Weapon_Tesla.Stick.Tesla_ExtendCue'
	ActivateElectricitySound=SoundCue'Weapon_Tesla.Stick.Tesla_StartCue'
	ElectricityLoopingSound=SoundCue'Weapon_Tesla.Stick.Tesla_LoopCue'
	ActivateFenceSound=SoundCue'Weapon_Tesla.Stick.Tesla_Dual_StartCue'
	FenceLoopingSound=SoundCue'Weapon_Tesla.Stick.Tesla_Dual_LoopCue'
}