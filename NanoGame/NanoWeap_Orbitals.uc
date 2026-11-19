/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Orbitals extends NanoWeap_Orbitals_Base;




/**
* State Active
* When a weapon is in the active state, it's up, ready but not doing anything. (idle)
*/
simulated state Active
{
    /** So we are no longer using the Orbitals weapon now.  Turn off everything we should.  And spawn our Orbitals in world manager. **/
    simulated function EndState( Name NextStateName )
    {
    	Super.EndState( NextStateName );
    }

	/** 
 	 *  We override this so we know when we are "changing" away from this weapon.  
 	 *  When we change away we need to turn off any "controling" forces we had ocurring. (i.e. auto turned on force fields, and force fields in the 
 	 *  the world that we had turned on)
 	 *  
 	 **/
	simulated function bool TryPutDown()
	{
		local NanoOrbitalsRestingInWorld OrbitalsInWorld;
    	local NanoInterface_OrbitalTarget OT;

		OrbitalsInWorld = Spawn( class'NanoOrbitalsRestingInWorld',,, Instigator.Location,,, TRUE );
    	OrbitalsInWorld.Init( PSC_Orbitals );
        PSC_Orbitals = none;
	
		//ScriptTrace();


		foreach PawnsThatHaveHadOrbitalAttractionTurnedOn(OT)
		{
			//`log( OT @ " had SetTimer called!" );
     	   SetTimer( DurationBeforeControllingForcesDissipate, FALSE, nameof(OT.DeactivateOrbitalAttractors), OT );
		}


        //OrbitalsAttractor.bForceActive = FALSE;


   	    return Super.TryPutDown();
	}
}



// TODO:  make this use GameExplosion system
simulated event DoDamageFromThisLocation( const vector SpawnLocation, float InDamageScalar, float InThrowSpeedScalar )
{ 
	local NanoPawnBase OrbitalsVictim;
	local vector ThrowDir;
	local float VictimDist;

	//DrawDebugCoordinateSystem( SpawnLocation, rot(0,0,0), 10.0f, TRUE );

	AttachComponent( OrbitalsImpulse );
	NanoGRI(WorldInfo.GRI).BreakFracturedMeshes( SpawnLocation, class'NDT_Orbitals', OrbitalsBreakFracturedMeshesRadius, FALSE );
	OnBustNanoBustableActors( SpawnLocation, class'NDT_Orbitals', OrbitalsBreakFracturedMeshesRadius );
	NanoGRI(WorldInfo.GRI).AffectFlyingCars( SpawnLocation, class'NDT_Orbitals', OrbitalsAffectFlyingCarsRadius );
	NanoGRI(WorldInfo.GRI).SmashDownTeslaCoils( SpawnLocation, class'NDT_Orbitals', OrbitalsSmashDownTeslaCoilsRadius );
	OrbitalsImpulse.FireImpulse( SpawnLocation ); //@todo - explosive damage that damages on hammer!


	// quick hack to get this prototyped.  (need to convert to using GameExplosion and modifying it to have AffectFlyingCars)
	foreach CollidingActors( class'NanoPawnBase', OrbitalsVictim, FMax(OrbitalsDamageRadius, OrbitalsThrowRadius), SpawnLocation, TRUE )
	{
		if( ( OrbitalsVictim != none ) && ( OrbitalsVictim != Instigator ) )
		{
			VictimDist = VSize(SpawnLocation - OrbitalsVictim.Location);

			// First see if pawn is within damage radius
			if(VictimDist <= OrbitalsDamageRadius)
			{
				// If so, do damage
				OrbitalsVictim.TakeRadiusDamage( (Instigator != None ? Instigator.Controller : None), OrbitalsDamage, OrbitalsDamageRadius, class'NDT_Orbitals', 1.f, SpawnLocation, TRUE, self);
			}

			// Now see if they are still alive, and within throw radius
			if((OrbitalsVictim.Health >= 0) && (VictimDist <= OrbitalsThrowRadius))
			{
				OrbitalsVictim.SetPhysics(PHYS_Falling);

				// Set velocity away from landing location
				ThrowDir = Normal(OrbitalsVictim.Location - SpawnLocation);
				ThrowDir.Z = 0.0;
				OrbitalsVictim.Velocity = (ThrowDir * OrbitalsThrowSpeed) + vect(0,0,600);

				// When they land after this they will be knocked down
				OrbitalsVictim.bKnockDownOnLanding = TRUE;
			}
		}
	}
}




defaultproperties
{
	bAllowTracers=FALSE

	SocketToSpawnParticleFrom="OrbitalsSpawn"
	PS_Orbitals=ParticleSystem'Nano_Phys_FX.Effects.P_FX_MarbleSpray_1'


	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	FireInterval(0)=0.100

	// RELOAD
	FiringStatesArray(1)="Reloading"
	WeaponFireTypes(1)=EWFT_InstantHit	// this is not actually a firing mode, but this avoids an access None log spam

	PS_ExplodeEffect=ParticleSystem'Nano_FX.Effects.P_FX_Explosion_Small_01'


	Begin Object Class=RB_RadialImpulseComponent Name=OrbitalsImpulseComp
		ImpulseRadius=256.0f
		ImpulseStrength=768.0f
		bVelChange=TRUE
		ImpulseFalloff=RIF_Constant
	End Object
	OrbitalsImpulse=OrbitalsImpulseComp

	FiringStartSound=SoundCue'Weapon_Orbital.Orbital.Orbital_LaunchStartCue'
	FiringLoopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_LaunchLoopCue'
	FiringStopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_LaunchStopCue'

	ImpactsLoopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_ImpactsLoopCue'
	ImpactsStopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_ImpactsLoopEndCue'// 2.51s

	ExplosionStartSound=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionTriggerCue'
	ExplosionLoopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionLoopCue'
	ExplosionStopSound=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionLoopEndCue' // 2.31s
}