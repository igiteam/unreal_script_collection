/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_ThrownWeapon extends NanoProjectile
	config(Weapon);

/** The skel mesh comp for the sword */
var SkeletalMeshComponent MeshComp;

/** This is the orig controller that fired this projectile **/
var NanoPC OrigController;
var NanoPawn OrigViewTarget;


// for all of the throwing stuff we maybe want an animation
// or we want to interp to the "final FollowCameraOffset" from the current location of the action 
// so it looks like you are chasing and catching up with the thrown weapon
// 

/** Camera offset when weapon is thrown and followed */
var config vector FollowCameraOffset;

/** Sound to play when shattering **/
var protected SoundCue ShatteringFromHittingAnImmovableObjectSound;

/** This is the effect that is played when a sword impacts something and shatters **/
var protected ParticleSystem PS_ShatteringFromHittingAnImmovableObject;

/** This is played when you are following the thrown weapon. **/
var const protected NanoCameraShake FollowingSwordScreenShake;


/** How much to apply post-process effect when following a weapon. */
var config float FollowingWeaponSpeedPPAmount;

/** This is the FOV that we should use for when following a weapon **/
var config float FollowingWeaponFOV;



simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( OrigController != none && OrigController.FollowedThrownWeapon != none )
	{
		DoFollowingThrownWeaponScreenEffects();
	}
}



simulated function RestoreOrigViewtarget()
{
	local ViewTargetTransitionParams Params;

	if( OrigController != none )
	{
		// restore FOV
		if( OrigController.Pawn.IsLocallyControlled() == TRUE )
		{
			// Update post process
			NanoPawn(OrigController.Pawn).SpeedPPEffect.bShowInGame = FALSE;

			OrigController.FOV( class'NanoPlayerCamera'.default.DefaultFOV );
		}
	
		Params.BlendTime = 0.5;
		Params.BlendFunction = VTBlend_Cubic;
		OrigController.SetViewTarget(OrigViewTarget, Params);
		OrigController = None;
	}
}


/** When the ThrownWeapon hits an imomovable object then it should blow up **/
simulated function DestroyedFromHittingAnImmovableObjectEffects()
{
	local ParticleSystemComponent PSC_ShatteredEffect;

	PlaySound( ShatteringFromHittingAnImmovableObjectSound,TRUE );
	PSC_ShatteredEffect = WorldInfo.MyEmitterPool.SpawnEmitter( PS_ShatteringFromHittingAnImmovableObject, Location, rot(0,0,0) );
	PSC_ShatteredEffect.SetScale( 5.0f );
}


/** This will do the effects for this thrown weapon.  Mostly screen effects to make it feel like you are really flying! **/
simulated function DoFollowingThrownWeaponScreenEffects()
{
	OrigController.ClientPlayCameraShake( FollowingSwordScreenShake );

	// just re use the dashing speed effect for now
	NanoPawn(OrigController.Pawn).SpeedPPEffect.bShowInGame = TRUE;
	NanoPawn(OrigController.Pawn).SpeedPPMatInst.SetScalarParameterValue( 'UseEffect', FollowingWeaponSpeedPPAmount );

	OrigController.FOV( FollowingWeaponFOV );
}




defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=WeaponMeshComp
		HiddenGame=FALSE
		CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bDisableAllRigidBody=TRUE
		Scale=1.0
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=FALSE
		bUpdateSkelWhenNotRendered=FALSE
	End Object
	MeshComp=WeaponMeshComp
	Components.Add(WeaponMeshComp)

	ShatteringFromHittingAnImmovableObjectSound=SoundCue'Weapon_Sword.Sword.Sword_Impact_Sword_Cue'
	PS_ShatteringFromHittingAnImmovableObject=ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_Nano_Sword_BlockSparks'

	Begin Object Class=NanoCameraShake Name=FollowingSwordScreenShake0
		OscillationDuration=0.1f
		RotOscillation={(Pitch=(Amplitude=5.f,Frequency=5.f),
						Yaw=(Amplitude=5.f,Frequency=5.f),
						Roll=(Amplitude=5.f,Frequency=5.f))}
		FOVOscillation=(Amplitude=5.f,Frequency=5.f)
	End Object
	FollowingSwordScreenShake=FollowingSwordScreenShake0
}