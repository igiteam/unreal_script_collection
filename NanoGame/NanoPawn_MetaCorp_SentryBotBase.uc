/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_SentryBotBase extends NanoPawn_MetaCorp_MechsBase
	implements( NanoInterface_JuggleCollision, NanoInterface_JuggleTarget )
	native(Pawn)
	abstract;

var PointLightComponent AlertLightComp;
var transient AudioComponent AlertAudioComp;

var protected SoundCue SummonDropPodWarningCue;
var protected transient AudioComponent AC_SummonDropPodWarning;
var protected transient ParticleSystemComponent PSC_SummonDropPodBeacon;
var protected ParticleSystem PS_SummonDropPodBeacon;

var bool bResetPhysicsWeight;

var Emitter ScannerEmitter;
var bool bScannerIsAlert;

var bool bSpikesDeployed;

var SkeletalMesh BrokenMesh;
var PhysicsAsset BrokenAsset;


var protected SoundCue ReleasedFromHousingCue;

var protected SoundCue DeathCue;

var protected SoundCue DeadBotImpactingGroundCue;

var protected SoundCue AlarmCue;
var transient protected AudioComponent AC_AlarmSound;

var protected SoundCue ScanningCue;
var transient protected AudioComponent AC_ScanningSound;


/** Used to push physics when explosion goes off. */
var protected RB_RadialImpulseComponent	DyingTattlerBotImpulse;

var protected ParticleSystem PS_DeathEffect;

/** This the distance at which distance based performance will occur. **/
var protected float DistanceBasedPerformance;

/** This stores whether or not we have distance based PerformanceSettings on or not.  We use this so we don't constantly set Performance values which may reattach and replicate. **/
var transient bool bCurrDistanceBasedPerformanceOn;

/** These are the orbital attractors currently on this actor.  They get turned on and off by the NanoWeap_Orbitals_Base **/
var transient array<NxForceField> OrbitalsAttractList;

/** This is the name of the socket where we will target the tattlers **/
var name TargetLocationSocketName;

var bool bIsDocked;


cpptext
{
	virtual void TickSpecial( FLOAT DeltaSeconds );

    /**
	 * This will look to see if the player is near the car and then update the collision settings for it.
	 * We just use distance at the moment.  The assumption is that cars always need to run run run otherwise they
	 * can get into traffic jams or other crazy situations.  But there is no need for them to be encroach checking constantly.
	 **/
	virtual void UpdatePerformanceSettingsBasedOnPlayer();
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	GetGRI().RegisterTargetableActor(self);
}

simulated function Destroyed()
{
	Super.Destroyed();

	StopCallDropPodEffects();
}

simulated function bool CanBeJuggled()
{
	return TRUE;
}


simulated function JuggleCollisionWithJuggledActor(NanoPawnBase NPCollider)
{
	NPCollider.bJuggleForceKnockDown = TRUE;
	PlayDying( class'NanoDamageType', vect(0,0,0) );
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// don't kill off a sentry bot when juggling
	if( `TimeSince(LastJuggleTime) < 1.0f )
	{
		if( Health - Damage <= 0 )
		{
			Damage = 0;
		}
	}

	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}


function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	local NanoPRI PRI;
	local NanoWeapon Wpn;
	local class<NanoAmmoModifier> AmmoMod;
	local int AmmoModLvl;

	if( InstigatedBy != None && InstigatedBy.Pawn != None )
	{
		Wpn = NanoWeapon(InstigatedBy.Pawn.Weapon);
		PRI = NanoPRI(InstigatedBy.PlayerReplicationInfo);
		if( Wpn != None && PRI != None )
		{
			AmmoMod = PRI.GetAmmoModClass( Wpn.Class, AmmoModLvl );
			if( ( AmmoMod != None ) && ( AmmoModLvl > -1 ) )
			{
				AmmoMod.static.HandleAmmoImpact( AmmoModLvl, self, InstigatedBy, inDamage, HitLocation, HitInfo );
			}
		}
	}
}


event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local NanoInterface_JuggleCollision JuggleCollisionInterface;

	Super.Bump( Other, OtherComp, HitNormal );

	if( bJuggled )
	{
		// Call notify function if it implements interface
		JuggleCollisionInterface = NanoInterface_JuggleCollision(Other);
		if(JuggleCollisionInterface != none)
		{
			JuggleCollisionInterface.JuggleCollisionWithJuggledActor(self);
		}
	}
}


/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	local Vector TargetLocation;
	local rotator TargetRotation;

	Mesh.GetSocketWorldLocationAndRotation( TargetLocationSocketName, TargetLocation, TargetRotation );

	return TargetLocation;
}


simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health>0 && Physics != PHYS_None && `TimeSince(LastRenderTime) < 1.f );
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	// ignore if dead
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}
	return 10.f;
}

simulated function Tick(float DeltaTime)
{
	if (bResetPhysicsWeight)
	{
		Mesh.PhysicsWeight = FInterpTo(Mesh.PhysicsWeight,0.f,DeltaTime,4.f);
		if (Mesh.PhysicsWeight <= 0.f)
		{
			Mesh.PhysicsWeight = 0.f;
			bResetPhysicsWeight = FALSE;
		}
	}
	Super.Tick(DeltaTime);
}

function ActivateIdle()
{
	GroundSpeed = 200;
	RotationRate.Yaw = 5000;
	AlertLightComp.SetEnabled(FALSE);
	SetScannerAlert(FALSE);
}

function EnableScanner()
{
	local Vector SocketLoc;
	local rotator SocketRot;

	ClearTimer(nameof(DestroyScanner));

	if (ScannerEmitter == None)
	{
		//`log(`location);
		Mesh.GetSocketWorldLocationAndRotation( TargetLocationSocketName, SocketLoc, SocketRot );

		ScannerEmitter = Spawn(class'SpawnedNanoEmitter',,,SocketLoc,Rotation);
		ScannerEmitter.LifeSpan = 0.0f;
		ScannerEmitter.SetBase(self,SocketLoc);
		ScannerEmitter.SetTemplate(ParticleSystem'Nano_FX.Effects.P_FX_LaserCone_Startup');
		SetScannerAlert(bScannerIsAlert);
		SetTimer(2.f,FALSE,nameof(SwitchScannerToConstant));
	}

	if( AC_ScanningSound == None )
	{
		AC_ScanningSound = new(self) class'AudioComponent';
		AttachComponent( AC_ScanningSound );
		AC_ScanningSound.SoundCue = ScanningCue;
	}
	//`log( "scanner alert" );
	AC_ScanningSound.FadeIn( 0.100f, 1.0f );
}

function SetScannerAlert(bool bAlert)
{
	local Actor DockActor;
	bScannerIsAlert = bAlert;
	if (ScannerEmitter != None)
	{
		if (bAlert)
		{
			ScannerEmitter.SetVectorParameter('LaserColor',vect(255,0,0));
			if( AC_AlarmSound == None && NanoAI_SentryBot(Controller).Dock != None )
			{
				DockActor = NanoAI_SentryBot(Controller).Dock.GetInterfaceActor();
				if( DockActor != None )
				{
					AC_AlarmSound = new(DockActor) class'AudioComponent';
					DockActor.AttachComponent( AC_AlarmSound );
					AC_AlarmSound.SoundCue = AlarmCue;
				}
			}

			if( AC_AlarmSound != None && AC_AlarmSound.IsPlaying() == FALSE )
			{
				//`log( "alert alert" );
				AC_AlarmSound.FadeIn( 0.100f, 1.0f );
			}

		}
		else
		{
			if (ScannerEmitter != None)
			{
				ScannerEmitter.SetVectorParameter('LaserColor',vect(128,128,128));
			}
			if (AC_AlarmSound != None)
			{
				AC_AlarmSound.FadeOut( 0.100f, 0.0f );
			}
		}
	}
}

function SwitchScannerToConstant()
{
	if (ScannerEmitter != None)
	{
		//`log(`location);
		ScannerEmitter.SetTemplate(ParticleSystem'Nano_FX.Effects.P_FX_LaserCone_Constant');
	}
}

function DisableScanner()
{
	if (ScannerEmitter != None && !IsTimerActive(nameof(DestroyScanner)))
	{
		//`log(`location);
		ScannerEmitter.SetTemplate(ParticleSystem'Nano_FX.Effects.P_FX_LaserCone_Shutdown');
		SetTimer(2.f,FALSE,nameof(DestroyScanner));
	}

	if( AC_ScanningSound != None )
	{
		AC_ScanningSound.FadeOut( 0.100f, 0.0f );
	}
}

function DestroyScanner()
{
	if (ScannerEmitter != None)
	{
		//`log(`location);
		ClearTimer(nameof(SwitchScannerToConstant));
		ClearTimer(nameof(DisableScanner));
		ScannerEmitter.Destroy();
		ScannerEmitter = None;
	}
}

function ActivateAlert()
{
	GroundSpeed = 600;
	RotationRate.Yaw = 15000;
	AlertLightComp.SetEnabled(TRUE);
	EnableScanner();
	SetScannerAlert(TRUE);

}

function Undock(vector UndockDir);

auto state Docked
{
	function Undock(vector UndockDir)
	{
		PlaySound( ReleasedFromHousingCue );
		CollisionComponent = Mesh;
		SetPhysics(PHYS_RigidBody);
		Mesh.PhysicsWeight = 1.f;
		Mesh.AddImpulse(UndockDir * 256.f,Location + VRand() * 16.f,,TRUE);
		GotoState('Docked','Undock');
	}

Begin:
	// idling
	Stop;

Undock:
	Sleep(2.5f); //SetTimer(2.5f,FALSE,nameof(BounceUp));
BounceUp:
	Mesh.AddImpulse(vect(0,0,192),Location,,FALSE);
	bResetPhysicsWeight = TRUE;
	Sleep(0.5f); //SetTimer(0.5,FALSE,nameof(PlayDeployAnim));
PlayDeployAnim:
	SetPhysics(PHYS_None);
	bSpikesDeployed = TRUE;
	Mesh.PlayAnim('Spikes_Deploy');
	Sleep(0.5f); //SetTimer(0.5f,FALSE,nameof(RecoverFromUndock));
RecoverFromUndock:
	CollisionComponent = CylinderComponent;
	Velocity = vect(0,0,0);
	SetPhysics(PHYS_Falling);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	// so here tell our dock that we died
	if(  NanoAI_SentryBot(Controller).Dock != none )
	{
		NanoAI_SentryBot(Controller).Dock.BotHasBeenKilled();
	}


	GotoState('Dying');

	bReplicateMovement = FALSE;
	bTearOff = TRUE;
	Velocity += TearOffMomentum;
	DestroyScanner();

	// death by sword should split in half
	if( (DamageType == class'NDT_NanoSword') || (DamageType == class'NDT_NanoSwordThrown') || (DamageType == class'NDT_RicochetMoonThrown') || (DamageType == class'NDT_DenseDash') )
	{
		Mesh.SetSkeletalMesh(BrokenMesh);
		Mesh.SetPhysicsAsset(BrokenAsset);
	}
	else if (bSpikesDeployed)
	{
		Mesh.PlayAnim('Spikes_Retract');
	}

	SetPushesRigidBodies(FALSE);
	InitRagdoll();
	PlaySound( DeathCue );

	if( ( AlertAudioComp != none ) && ( AlertAudioComp.IsPlaying() == TRUE ) )
	{
		AlertAudioComp.FadeOut( 0.100f, 1.0f );
	}

	if( ( AC_AlarmSound != none ) &&( AC_AlarmSound.IsPlaying() == TRUE ))
	{
		AC_AlarmSound.FadeOut( 0.100f, 1.0f );
	}

	if( ( AC_ScanningSound != none ) &&( AC_ScanningSound.IsPlaying() == TRUE ) )
	{
		AC_ScanningSound.FadeOut( 0.100f, 1.0f );
	}

    WorldInfo.MyEmitterPool.SpawnEmitter( PS_DeathEffect, Location, Rotation );

	AttachComponent( DyingTattlerBotImpulse );
	DyingTattlerBotImpulse.FireImpulse( Location );

	DeactivateOrbitalAttractors();

	bPlayedDeath = TRUE;
}


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
//	local class<NanoAbsorbOrb> DroppedOrbClass;


	if( Super.Died(Killer,DamageType,HitLocation) )
    {
		StopCallDropPodEffects();
    	DeactivateOrbitalAttractors();

// 		foreach DroppedOrbClasses( DroppedOrbClass )
// 		{
// 			Orbs.AddItem( NanoGRI(WorldInfo.GRI).SpawnANanoOrb( DroppedOrbClass, self, FALSE ) );
// 		}

		return TRUE;
    }

    return FALSE;
}



simulated function PlaySpikeRetract()
{
	Mesh.PlayAnim('Spikes_Retract');
}


/**  When bot hits the ground play a sound and then turn off the RB collision notifications **/
event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
						 const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	PlaySound( DeadBotImpactingGroundCue, TRUE, TRUE, TRUE, Location );

	Mesh.SetNotifyRigidBodyCollision( FALSE );
	SetTimer( 1.0f, FALSE, nameof(ReenableRigidBodyCollision) );
}


simulated function ReenableRigidBodyCollision()
{
	Mesh.SetNotifyRigidBodyCollision( TRUE );
}


/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.TattlerBotKilled;
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook )
{
	TakeDamage(100000, Hook.Instigator.Controller, Hook.Location, Hook.Velocity, class'NanoGame.NDT_RicochetMoonThrown',,Hook);
	return FALSE;
}

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return !bIsDocked;
}

simulated function bool StopsProjectile(Projectile P)
{
	if( P.Instigator == Base )
		return FALSE;

	return Super.StopsProjectile(P);
}



simulated function SetUpOrbitalAttractor()
{
	AddAnOrbitalAttractorRadial( 512.0f, -50.0f );
}

simulated function AddAnOrbitalAttractorRadial( float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorRadial OrbitalsAttact;

	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorRadial', self,,Location );
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
	return Location;
}

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage()
{
	return 128.0f;
}

simulated function PlayCallDropPodEffects()
{
	if( AC_SummonDropPodWarning == None  )
	{
		AC_SummonDropPodWarning = new(self) class'AudioComponent';
		AttachComponent( AC_SummonDropPodWarning );
		AC_SummonDropPodWarning.SoundCue = SummonDropPodWarningCue;
	}

	if( AC_SummonDropPodWarning != None && AC_SummonDropPodWarning.IsPlaying() == FALSE )
	{
		AC_SummonDropPodWarning.FadeIn( 0.100f, 1.0f );
	}

	if( PSC_SummonDropPodBeacon == None )
	{
		PSC_SummonDropPodBeacon = new(self) class'NanoParticleSystemComponent';
		PSC_SummonDropPodBeacon.bAutoActivate = FALSE;
		PSC_SummonDropPodBeacon.SetTemplate( PS_SummonDropPodBeacon );
		Mesh.AttachComponentToSocket( PSC_SummonDropPodBeacon, TargetLocationSocketName );
	}
	if( PSC_SummonDropPodBeacon != None )
	{
		PSC_SummonDropPodBeacon.ActivateSystem();
	}
}

simulated function StopCallDropPodEffects()
{
	if( AC_SummonDropPodWarning != None )
	{
		AC_SummonDropPodWarning.FadeOut( 0.100f, 0.0f );
	}
	if( PSC_SummonDropPodBeacon != None )
	{
		PSC_SummonDropPodBeacon.DeactivateSystem();
	}
}

simulated event BoxSphereBounds GetTargetableBounds()
{
	return Mesh.Bounds;
}


defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0030.000000
		CollisionHeight=+0088.000000
	End Object
}
