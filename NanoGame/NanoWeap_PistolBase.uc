/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_PistolBase extends NanoWeap_MP7
	abstract;



var StaticMesh TargetingLaser;
var StaticMesh TargetingLaser_AI;
var transient StaticMeshComponent TargetingLaserComp;

var ParticleSystem TargetLaserEndoint;
var ParticleSystem TargetLaserEndoint_AI;
var transient SpawnedNanoEmitter TargetLaserEndointEmitter;

var ParticleSystem TargetLaserEndoint_ValidTarget;
var ParticleSystem TargetLaserEndoint_ValidTarget_AI;
var transient SpawnedNanoEmitter TargetLaserEndointEmitter_ValidTarget;

var float TargetLaserNudgeDist;

var transient bool bTargetLaserOn;


var transient NanoDynamicPointLight LightTargetingEndPoint;



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


// we override so we can turn on/off the targeting laser
simulated state Reloading
{
	ignores ForceReload;

	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState( PreviousStateName );

		TurnOffTargetingLaser();
	}

	simulated function EndState(Name NextStateName)
	{
		// delay a bit as we end the reload state and still have to put the gun back down
		SetTimer( 1.0f, FALSE, nameof(TurnOnTargetingLaser) );

		Super.EndState( NextStateName );
	}

}


simulated function Tick( float DeltaTime )
{
	local NanoPawn NP;
	local bool bAIIsTargeting;


	NP = NanoPawn(Instigator);

	if( ( NP.IsHumanControlled() == TRUE ) || ( TRUE ) )
	{

		if( Instigator.IsHumanControlled() == FALSE ) 
		{
			if( ( NP.Controller != None )
				&& ( NanoAIBase(NP.Controller).FindCommandOfClass( class'NanoAIAction_EngageThreat_Trooper_Ranged' ) != None )
				)
			{
				bAIIsTargeting = TRUE;
			} 
		}


		if( ( ( NP.bIsTargeting == TRUE ) || ( bAIIsTargeting == TRUE ))
			//&& ( IsTimerActive( nameof(TurnOnTargetingLaser) ) == FALSE ) 
			&& ( IsInState( 'Reloading' ) == FALSE )
			)
		{
			if( bTargetLaserOn == FALSE )
			{
				TurnOnTargetingLaser();
			}

			UpdateTargetingParticleEffects();
		}
		else
		{
			if( bTargetLaserOn == TRUE )
			{
				TurnOffTargetingLaser();
			}
		}
	}


	Super.Tick( DeltaTime );
}



protected function UpdateTargetingParticleEffects()
{
	local vector StartTrace, EndTrace;
	local rotator StartRotation;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo		RealImpact;
	local bool bHit;
	local vector NudgeLocation;
	local vector TargetingLaserScale;


	SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation( MuzzleSocketName, StartTrace, StartRotation );

	EndTrace = StartTrace + vector(StartRotation) * GetTraceRange();

	// Perform shot
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

	bHit = (RealImpact.HitLocation != EndTrace);
	if( bHit == TRUE )
	{
		// nudge outward a little bit
		NudgeLocation = RealImpact.HitLocation + (Normal(StartTrace - RealImpact.HitLocation) * TargetLaserNudgeDist);


		// scale the targeting mesh
		TargetingLaserScale = vect( 1.0f, 1.0f, 1.0f );
		TargetingLaserScale.X = VSize(RealImpact.HitLocation - StartTrace); // remove before submitting
		TargetingLaserComp.SetScale3D( TargetingLaserScale );


		// check for valid targetable actor
		if( NanoPawn_MetaCorpBase(RealImpact.HitActor) == None )
		{
			if( TargetLaserEndointEmitter != None )
			{
				TargetLaserEndointEmitter.SetLocation( NudgeLocation );
				TargetLaserEndointEmitter.SetHidden( FALSE );
			}

			if( TargetLaserEndointEmitter_ValidTarget != None )
			{
				TargetLaserEndointEmitter_ValidTarget.SetHidden( TRUE );
			}

			LightTargetingEndPoint.LightComponent.SetEnabled( TRUE );
			LightTargetingEndPoint.SetHidden( FALSE );
		}
		else
		{
			if( TargetLaserEndointEmitter_ValidTarget != None )
			{
				TargetLaserEndointEmitter_ValidTarget.SetLocation( NudgeLocation );
				TargetLaserEndointEmitter_ValidTarget.SetHidden( FALSE );
			}

			if( TargetLaserEndointEmitter != None )
			{
				TargetLaserEndointEmitter.SetHidden( TRUE );
			}


			LightTargetingEndPoint.LightComponent.SetEnabled( TRUE );
			LightTargetingEndPoint.SetHidden( FALSE );
			LightTargetingEndPoint.SetLocation( NudgeLocation );

			NanoPawn_MetaCorpBase(RealImpact.HitActor).LastTimeBeingAimedAt = WorldInfo.TimeSeconds;
		}
	}
	else
	{
		TurnOffTargetingLaser();
	}
}


simulated function TurnOnTargetingLaser()
{
	//`log( "ON" );

	if( TargetingLaserComp == None )
	{
		// set up the targeting laser mesh
		TargetingLaserComp = new(self) class'StaticMeshComponent';
		if( NanoPawn(Instigator).IsHumanControlled() == TRUE )
		{
			TargetingLaserComp.SetStaticMesh( TargetingLaser );
		}
		else
		{
			TargetingLaserComp.SetStaticMesh( TargetingLaser_AI );
		}

		SkeletalMeshComponent(Mesh).AttachComponentToSocket( TargetingLaserComp, MuzzleSocketName );
	}


	TargetingLaserComp.SetHidden( FALSE );

	if( TargetLaserEndointEmitter == None )
	{
		// set up the targeting laser end point PSCs
		TargetLaserEndointEmitter = Spawn(class'SpawnedNanoEmitter', self,, Location);

		if( NanoPawn(Instigator).IsHumanControlled() == TRUE )
		{
			TargetLaserEndointEmitter.SetTemplate( TargetLaserEndoint );
		}
		else
		{
			TargetLaserEndointEmitter.SetTemplate( TargetLaserEndoint_AI );
		}

		TargetLaserEndointEmitter.ParticleSystemComponent.bAutoActivate = FALSE;
	}


	if( TargetLaserEndointEmitter_ValidTarget == None )
	{
		TargetLaserEndointEmitter_ValidTarget = Spawn(class'SpawnedNanoEmitter', self,, Location);
		if( NanoPawn(Instigator).IsHumanControlled() == TRUE )
		{
			TargetLaserEndointEmitter_ValidTarget.SetTemplate( TargetLaserEndoint_ValidTarget );
		}
		else
		{
			TargetLaserEndointEmitter_ValidTarget.SetTemplate( TargetLaserEndoint_ValidTarget_AI );
		}
		TargetLaserEndointEmitter_ValidTarget.ParticleSystemComponent.bAutoActivate = FALSE;
	}



	if( LightTargetingEndPoint == None )
	{
		LightTargetingEndPoint = Spawn(class'NanoDynamicPointLight', self,, Location);

		if( NanoPawn(Instigator).IsHumanControlled() == TRUE )
		{
			LightTargetingEndPoint.LightComponent.SetLightProperties( 2, MakeColor(25, 255, 0, 255) );
		}
		else
		{
			LightTargetingEndPoint.LightComponent.SetLightProperties( 2, MakeColor(255, 0, 0, 255) );
		}
		PointLightComponent(LightTargetingEndPoint.LightComponent).Radius = 64;

		LightTargetingEndPoint.LightComponent.SetEnabled( TRUE );
		LightTargetingEndPoint.SetHidden( FALSE );
	}


	TargetLaserEndointEmitter.ParticleSystemComponent.ActivateSystem();
	TargetLaserEndointEmitter.SetHidden( FALSE );
	TargetLaserEndointEmitter_ValidTarget.ParticleSystemComponent.ActivateSystem();
	TargetLaserEndointEmitter_ValidTarget.SetHidden( FALSE );


	bTargetLaserOn = TRUE;
}



simulated function TurnOffTargetingLaser()
{
	//`log( "OFF" );

	if( TargetLaserEndointEmitter != None )
	{
		TargetLaserEndointEmitter.LifeSpan = 0.1;
		TargetLaserEndointEmitter.ParticleSystemComponent.DeactivateSystem();
		TargetLaserEndointEmitter.SetHidden( TRUE );
		TargetLaserEndointEmitter = None;
	}


	if( TargetLaserEndointEmitter_ValidTarget != None )
	{
		TargetLaserEndointEmitter_ValidTarget.LifeSpan = 0.1;
		TargetLaserEndointEmitter_ValidTarget.ParticleSystemComponent.DeactivateSystem();
		TargetLaserEndointEmitter_ValidTarget.SetHidden( TRUE );
		TargetLaserEndointEmitter_ValidTarget = None;
	}

	if( TargetingLaserComp != None )
	{
		TargetingLaserComp.SetHidden( TRUE );
	}

	LightTargetingEndPoint.LightComponent.SetEnabled( FALSE );
	LightTargetingEndPoint.SetHidden( TRUE );

	bTargetLaserOn = FALSE;
}




 
defaultproperties
{
	bFireSoundIsLooping=FALSE
	FireNoAmmoSound=SoundCue'Weapon_Pistols.Misc.Pistol_DryFire_Cue'

	bAllowTracers=TRUE
	TargetingLaser=StaticMesh'Weap_Addons.LaserSight.Meshes.SM_LaserSight_Beam_01'
	TargetingLaser_AI=StaticMesh'Weap_Addons.LaserSight.Meshes.SM_LaserSight_Beam_AI_01'

	TargetLaserEndoint=ParticleSystem'Weap_Addons.LaserSight.Effects.PFX_LaserEndpoint_01'
	TargetLaserEndoint_AI=ParticleSystem'Weap_Addons.LaserSight.Effects.PFX_LaserEndpoint_AI_01'

	TargetLaserEndoint_ValidTarget=ParticleSystem'Weap_Addons.LaserSight.Effects.PFX_LaserEndpoint_03'
	TargetLaserEndoint_ValidTarget_AI=ParticleSystem'Weap_Addons.LaserSight.Effects.PFX_LaserEndpoint_AI_03'



	TargetLaserNudgeDist=20


//scale the static mesh by distance  as it is a 1 unit mesh
//01 back off from the impact point by 2-3 units
//and then 03 is a "valid" target

//light component on the end point of the gun
//64 radius
//bright 2
//0.1 red  1 green 0 blue

}






