/**
 *
 * so we want to have a number of states that exist for this guy
 *
 * -shooting them out and landing on ground for slip and slide  (alsways sliding whenever they are out)
 *
 * -shooting out and attracting to thing I have targeted / things that are in the area  (time period for them to go dormant?)
 * -shooting out and controlling (weapon still active)   (not in air.  need to be on ground and rolling around)
 * -shooting them out and then targeting them (weapon still active)
 *
 * -player NEEDs to be able to orbital the ground and then run and do "shoot em up" style shooting.  HELL YEAH
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Orbitals_Base extends NanoWeapon
	abstract
	native(Weapon);

//Nano_Phys_FX.Effects.P_Phys_NanoSpray <- Spraying nano crap into the world.
//Nano_Phys_FX.Effects.P_FX_MarbleSpray_1 <- Sprays 'marbles' into the world.   t


var name SocketToSpawnParticleFrom;

var ParticleSystem PS_Orbitals;
var transient ParticleSystemComponent PSC_Orbitals;

var ParticleSystem PS_ExplodeEffect;


/** Used to push physics when explosion goes off. */
var protected RB_RadialImpulseComponent	OrbitalsImpulse;
/** event Landed is not being triggered on clients and probably won't have all of the correct bVars.  So for Hammer effects we just replicate out a byte **/

var config protected float OrbitalsDamage;

var config protected float OrbitalsDamageRadius;

var config protected float OrbitalsThrowRadius;

var config protected float OrbitalsThrowSpeed;

var config protected float OrbitalsBreakFracturedMeshesRadius;

var config protected float OrbitalsAffectFlyingCarsRadius;

var config protected float OrbitalsSmashDownTeslaCoilsRadius;


var transient protected array<Vector4> LocationsOfAllOrbitals;

var transient protected NanoForceField_OrbitalAttractorBox OrbitalsAttractor;

/** Over the coarse of this many seconds the indiv orbital explosions will occur **/
var config float DurationForOrbitalExplosions;

/** This is the explosion delay window that we use to make the explosions not just a fuse effect.  But instead a popping explosion along the orbitals**/
var config float ExplosionDelayWindow;

/** Whether or not the orbitals are in play.  This used to determine if the fire button should explode them or should spawn them. **/
var transient bool bOrbitalsInPlay;


var config float DistanceOfOrbitalControl;

var config float DistanceOfOrbitalPassiveHoldInAir;


var config float DurationBeforeControllingForcesDissipate;

var transient array<NanoInterface_OrbitalTarget> PawnsThatHaveHadOrbitalAttractionTurnedOn;


var protected SoundCue FiringStartSound;
var protected SoundCue FiringLoopSound;
var protected transient AudioComponent AC_FiringLoop;
var protected SoundCue FiringStopSound;


var protected SoundCue ImpactsLoopSound;
var protected transient AudioComponent AC_ImpactsLoop;
var protected SoundCue ImpactsStopSound;

/** This is the time at which the last visual explosion will occurr **/
var protected transient float LastVisualExplosionTime;

var protected SoundCue ExplosionStartSound;
var protected SoundCue ExplosionLoopSound;
var protected transient AudioComponent AC_ExplosionLoop;
var protected SoundCue ExplosionStopSound;


cpptext
{
    void CreateBoundingBoxAndDoDamage2( const TArray<FVector>& PointsToCreateBoxFrom );
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	//PS_ExplodeEffect.Delay = 0.500;
	//PS_ExplodeEffect.bUseDelayRange = true;

}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, SocketName);
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();
}



simulated event Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

	DoForceFieldAttractor();
}


simulated function DoForceFieldAttractor()
{
	// just dirty hack for now
	local vector Start, End, HitLoc, HitNorm;
	local rotator Rot;
	local Actor HitActor;
	//local TraceHitInfo HitInfo;
    local NanoInterface_OrbitalTarget OT;


    if( Instigator.Controller == none )
    {
		return;
    }


	Instigator.GetActorEyesViewPoint( Start, Rot );
	Start = Start + vector(Instigator.Controller.Rotation) * 16.0f; // to get out of lyrik's body
	End = Start + (vector(Instigator.Controller.Rotation) * DistanceOfOrbitalControl);  

	HitActor = Trace( HitLoc, HitNorm, End, Start, TRUE );


	OT = NanoInterface_OrbitalTarget(HitActor);
    if( OT != none )
    {
		if( PawnsThatHaveHadOrbitalAttractionTurnedOn.Find( OT ) == INDEX_NONE )
		{
			PawnsThatHaveHadOrbitalAttractionTurnedOn.AddItem( OT );
		}
     	OT.ActivateOrbitalAttractors();
    }
	

	if( IsInState( 'Active' ) == TRUE )
	{
		if( HitActor != none )
		{
			// offset above the ground slightly so the forcefield can work nicely
			HitLoc = HitLoc + vect(0,0,20);
		}
		else
		{
			HitLoc = Start + (vector(Instigator.Controller.Rotation) * DistanceOfOrbitalPassiveHoldInAir); 
		}
	}

}




simulated state WeaponFiring
{
    simulated function EndState( Name NextStateName )
    {
		ClearTimer( nameof(ActivateParticles) );

		if( PSC_Orbitals != none )
		{
			PSC_Orbitals.DeactivateSystem();
		}

		NanoPawn(Instigator).RunningFullBodySlot.StopCustomAnim( 0.1f );

    	Super.EndState( NextStateName );
    }


	/** This is empty, as we don't want auto-refire */
	simulated function RefireCheckTimer()
	{
		// Force player to wait before re-firing
		//GotoState('MakePlayerPullTrigger');
	}


	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		local float AnimTimeForStartBoom;

		`loginfo( 'Nano_Melee', WorldInfo.TimeSeconds@`location@GetStateName() );
		//`log( "orbitals: "  );

       if( CurrentFireMode == 0 )
       {
			if( ( IsTimerActive( nameof(DeActivateParticles) ) == FALSE ) 
				&& ( bOrbitalsInPlay == TRUE )
				&& ( PSC_Orbitals != none )
			  )
			{			
				// then deactivate so we are no longer spraying.  If we deactivate and then try to gather we will not get any points
				// as there are no "active" particles
				// NOTE: need to try and figure out why physx doesn't think they are active
				//PSC_Orbitals.DeactivateSystem();
				//NanoPawn(Instigator).RunningFullBodySlot.StopCustomAnim( 0.1f );

				// looks bad if we are already playing the prepare_loop
				if( NanoPawn(Instigator).PreAimFullBodySlot.GetCustomAnimNodeSeq().AnimSeqName != 'NW_Orbitals_Detonate_Prepare_Loop' )
				{
					AnimTimeForStartBoom = NanoPawn(Instigator).PreAimFullBodySlot.PlayCustomAnim('NW_Orbitals_Detonate_Prepare', 0.5f, 0.05f, 0.1f, FALSE, TRUE);
				}

				SetTimer( AnimTimeForStartBoom - 0.1f, FALSE, nameof(DeActivateParticles) );
			}
	      	else if( ( IsTimerActive( nameof(ActivateParticles) ) == FALSE ) && ( IsTimerActive( nameof(DeActivateParticles) ) == FALSE )  )
	        {
				CommenceFiringParticles();
	       	}
       }
	}

  
	simulated function StopFire(byte FireModeNum)
	{
		Super.StopFire( FireModeNum );

		if( ( FireModeNum == 0 ) && ( IsTimerActive( nameof(DeActivateParticles) ) == FALSE )  && PSC_Orbitals != none )
		{
			bOrbitalsInPlay = TRUE;
			PSC_Orbitals.DeactivateSystem();

			NanoPawn(Instigator).PreAimFullBodySlot.PlayCustomAnim('NW_Orbitals_Detonate_Prepare_Loop', 1.0f, 0.5f, 0.1f, TRUE, TRUE);			
	
			Instigator.PlaySound( FiringStopSound );
	
			if( AC_FiringLoop != none )
			{
				AC_FiringLoop.FadeOut( 0.25f, 0.0f );
			}
	
			if( AC_ImpactsLoop != none )
			{
				AC_ImpactsLoop.FadeOut( 2.0f, 0.0f );
			}


			GotoState('Active');
		}	
	}
}


simulated function CommenceFiringParticles()
{
	local NanoPawn NP;
	local float AnimTimeForStartSummoning;

	NP = NanoPawn(Instigator);

	AnimTimeForStartSummoning = NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Start', 1.0f, 0.05f, 0.1f, FALSE, TRUE);
	NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Loop', 1.0f, AnimTimeForStartSummoning, 0.1f, TRUE, TRUE);

	Instigator.PlaySound( FiringStartSound );

	if( AC_FiringLoop == none )
	{
		AC_FiringLoop = new(self) class'AudioComponent';
		AC_FiringLoop.bStopWhenOwnerDestroyed = TRUE;
		AC_FiringLoop.SoundCue = FiringLoopSound;
		Instigator.AttachComponent( AC_FiringLoop );
	}

	if( AC_FiringLoop != none )
	{
		AC_FiringLoop.FadeIn( 0.25f, 1.0f );
	}


	if( AC_ImpactsLoop == none )
	{
		AC_ImpactsLoop = new(self) class'AudioComponent';
		AC_ImpactsLoop.bStopWhenOwnerDestroyed = TRUE;
		AC_ImpactsLoop.SoundCue = ImpactsLoopSound;
		Instigator.AttachComponent( AC_ImpactsLoop );
	}

	if( AC_ImpactsLoop != none )
	{
		AC_ImpactsLoop.FadeIn( AnimTimeForStartSummoning + 0.2f, 1.0f ); // allow a lil time for the balls to start falling
	}


	// Delay before actually spawning projectile as the anim above lasts this long
	SetTimer( AnimTimeForStartSummoning, FALSE, nameof(ActivateParticles) );
}


simulated function ActivateParticles()
{
	//PSC_Orbitals = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_Orbitals, NanoPawn(Instigator).Mesh, SocketToSpawnParticleFrom, TRUE );

    // sigh the engine emitter pool does not correctly reset pscs to their defaults
    //PSC_Orbitals.SetHidden( FALSE );

	PSC_Orbitals = new(self) class'NanoParticleSystemComponent';
	PSC_Orbitals.SetTemplate( PS_Orbitals );
	NanoPawn(Instigator).Mesh.AttachComponentToSocket( PSC_Orbitals, SocketToSpawnParticleFrom );	
	//`log( "ActivateParticles Activate"  @ PSC_Orbitals );
}


simulated function DeActivateParticles()
{
	//`log( "turning off orbitals" );
	//`log( "ActivateParticles Deactivate"  @ PSC_Orbitals );

	PSC_Orbitals.SetHidden( TRUE );
    CreateOrbitalExplosionPoints();  // we gather locations here
    //`log( LocationsOfAllOrbitals.Length );
    DoOrbitalExplosion();
	PSC_Orbitals.KillParticlesForced();
	//PSC_Orbitals.DeactivateSystem();

	Instigator.PlaySound( ExplosionStartSound );
    NanoPawn(Instigator).PreAimFullBodySlot.PlayCustomAnim('NW_Orbitals_Detonate_Boom', 0.25f, 0.05f, 0.1f, FALSE, TRUE);

	Instigator.PlaySound( ExplosionStartSound );


	// if the time is longer than the ExplosionEnd sound then do the looping.
   if( LastVisualExplosionTime > 1.0f )
   {
	   if( AC_ExplosionLoop == none )
	   {
	      AC_ExplosionLoop = new(self) class'AudioComponent';
	      AC_ExplosionLoop.bStopWhenOwnerDestroyed = TRUE;
	      AC_ExplosionLoop.SoundCue = ExplosionLoopSound;
	      Instigator.AttachComponent( AC_ExplosionLoop );
	   }

   	   if( AC_ExplosionLoop != none )
	   {
	      AC_ExplosionLoop.FadeIn( 0.25f, 1.0f );
       }

	   SetTimer( LastVisualExplosionTime, FALSE, nameof(TurnOffExplosionSound) );
    }
	// else just play the 2.31 seconds long explosion
	else
	{
	    Instigator.PlaySound( ExplosionStopSound );
	}
	
	bOrbitalsInPlay = FALSE;

	//ScriptTrace();

	PSC_Orbitals = none;

	// Destroy weapon!
	NanoPawn(Instigator).DiscardCurrentWeapon();
	GotoState('Active');
}


simulated function TurnOffExplosionSound()
{
	if( AC_ExplosionLoop != none )
	{
		AC_ExplosionLoop.FadeOut( 0.25f, 0.0f );
	}

}

/** This will gather all of the particle locations **/
native simulated function CreateOrbitalExplosionPoints();

/** This will utilize all of the particle locations and then spawn the Orbital explosion **/
native simulated function DoOrbitalExplosion();


native simulated function CreateBoundingBoxAndDoDamage();


/** 
 *  InDelay is based off the RelativeTime of the particle system. So we multiply that time DurationForOrbitalExplosions to
 *  get the delay of each indiv explosion.
 *  
 **/
simulated event SpawnAnExplosionEffect( vector SpawnLocation, float InDelay )
{
	local ParticleSystem WithDelay;

	WithDelay = PS_ExplodeEffect;
	WithDelay.Delay = InDelay; //DurationForOrbitalExplosions - (InDelay * DurationForOrbitalExplosions);
	WithDelay.DelayLow = Max( (InDelay - ExplosionDelayWindow), 0.0f);
	WithDelay.bUseDelayRange = TRUE;
	//`log( WithDelay.Delay @ SpawnLocation );

    WorldInfo.MyEmitterPool.SpawnEmitter( WithDelay, SpawnLocation );
   // DrawDebugCoordinateSystem( SpawnLocation, rot(0,0,0), 10.0f, TRUE );

	LastVisualExplosionTime = Max( LastVisualExplosionTime, InDelay );
}


// TODO:  make this use GameExplosion system
simulated event DoDamageFromThisLocation( const vector SpawnLocation, float InDamageScalar, float InThrowSpeedScalar );


/** Look for FSMAs in radius and break parts off. */
simulated function OnBustNanoBustableActors(vector ExploOrigin, class<DamageType> DmgType, float FractureRadius )
{
	local NanoBustableActor FracActor;

	foreach CollidingActors( class'NanoBustableActor', FracActor, FractureRadius, ExploOrigin, TRUE )
	{
		FracActor.OnBust();
		FracActor.bBusted = true; // this should not have to be set this way
		FracActor.DeactivateOrbitalAttractors();
	}
}





defaultproperties
{

}






