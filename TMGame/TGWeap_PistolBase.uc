/**
 * Pistol Base Class
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGWeap_PistolBase extends TGWeapon
	native(TGWeapon)
	abstract;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float ZoomFOV;

/** Zoom in / out sounds **/
var protected const SoundCue ZoomActivatedSound;
var protected const SoundCue ZoomDeActivatedSound;

var() float FireAnimRateScale;

/** Override animations for Shield Reloads */
var BodyStance	ShieldReloadOverride, ShieldReloadFailedOverride, CrateCarryReloadOverride, CrateCarryReloadFailedOverride;
var BodyStance	BS_MeleeAttackKidnapper, BS_MeleeAttackHostage;

/** Reference to duel grenade weapon */
var TGWeap_GrenadeBase	GrenWeap;

/** Weapons get a crack at handling controls */
simulated function bool HandleButtonPress( coerce Name ButtonName )
{
	local TGPC PC;
	local TGPawn InstigatorGP;

	if( super.HandleButtonPress( ButtonName ) == FALSE )
	{
		if( InputCanZoom(ButtonName) )
		{
			PC = TGPC(Instigator.Controller);
			InstigatorGP = TGPawn(Instigator);

			//@todo should be able to click on R3 and zoom in target instantly
			if ( (PC != None) && (InstigatorGP != None) && (PC.bIsTargeting || InstigatorGP.IsDeployingShield()) )
			{
				SetZoomed(!TGPawn(Instigator).bIsZoomed);

				if( TGPawn(Instigator).bIsZoomed == TRUE )
				{
					TGWeaponPlaySoundLocal(ZoomActivatedSound,, TRUE);
				}
				else
				{
					TGWeaponPlaySoundLocal(ZoomDeactivatedSound,, TRUE);
				}

				return TRUE;
			}
		}
	}

	return FALSE;
}


/**
 * Returns FOV, in deg, of this weapon when it is in targeting mode.
 */
simulated function float GetTargetingFOV( float BaseFOV )
{
	if( TGPawn(Instigator).bIsZoomed == TRUE )
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV( BaseFOV );
	}
}

simulated function float GetAdjustedFOV(float BaseFOV)
{
	local TGPawn InstigatorGP;

	if (TGPawn(Instigator).bIsZoomed)
	{
		InstigatorGP = TGPawn(Instigator);
		if ( (InstigatorGP != None) && InstigatorGP.IsDeployingShield() )
		{
			// deploying shield isn't "targeting" mode, so we need to support the zoom fov during that
			// action in here
			return ZoomFOV;
		}
	}

	return super.GetAdjustedFOV(BaseFOV);
}


/** Returns the value to scale the cross hair by */
simulated function float GetCrossHairScale()
{
	if( TGPawn(Instigator).bIsZoomed == TRUE )
	{
		return 0.5f;
	}
	else
	{
		return 0.7f;
	}
}


simulated function float GetWeaponRating()
{
	// always equip pistol when kidnapping
	if (TGAIController != None && TGAIController.MyTGPawn != None && TGAIController.MyTGPawn.IsAKidnapper())
	{
		return 10.0;
	}
	return 0.4f;
}

simulated state Active
{
	simulated function TargetingModeChanged(TGPawn P)
	{
		local TGPC PC;

		Global.TargetingModeChanged(P);

		if( (Instigator != none) && TGPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = TGPC(Instigator.Controller);
			if ( PC != None && !PC.bIsTargeting && !IsReloading() )
			{
				SetZoomed(FALSE);
			}
		}
	}
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	Super.FireModeUpdated(FiringMode, bViaReplication);

	// Reloading status may have changed, check if we should update IK or not.
	UpdatePistolLeftHandIK();
}

simulated function TargetingModeChanged(TGPawn P)
{
	Super.TargetingModeChanged(P);

	// targeting mode changed, see if left hand ik should be toggled.
	UpdatePistolLeftHandIK();
}

/** Notification called when Pawn.bDoing360Aiming flag changes. */
simulated function On360AimingChangeNotify()
{
	Super.On360AimingChangeNotify();

	// 360 aiming changed, see if left hand ik should be toggled.
	UpdatePistolLeftHandIK();
}

/**
 * Updates Left Hand IK
 * sees if it should be on or off depending on context.
 */
simulated function UpdatePistolLeftHandIK()
{
	local TGPawn P;

	P = TGPawn(Instigator);

	// When left hand should be IK'd
	// When doing 360 aiming, when targeting, when reloading weapon
	if( P.IsAKidnapper() || P.bDoing360Aiming || P.bIsTargeting || P.IsReloadingWeapon() )
	{
		bDisableLeftHandIK = FALSE;
		P.UpdateBoneLeftHandIK();
	}
	else
	{
		bDisableLeftHandIK = TRUE;
		P.UpdateBoneLeftHandIK();
	}
}

simulated function TimeWeaponEquipping()
{
	Super.TimeWeaponEquipping();

	// weapon equipped, update status of left hand ik
	UpdatePistolLeftHandIK();
}

simulated function EjectClip();

simulated function CockOpen();

simulated function CockClose();

simulated function InsertClip();

simulated function Jammed();

simulated function HandSlam();

simulated function ClipImpact();

/** Add support for Shield and MeatShield specific reloads */
simulated function PlayWeaponReloading()
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);

	// Override reload animations with shield override if carrying shield
	BS_PawnWeaponReload = default.BS_PawnWeaponReload;
	if( PawnOwner != None )
	{
		if( PawnOwner.CarriedCrate != None )
		{
			OverrideBodyStance(BS_PawnWeaponReload, CrateCarryReloadOverride);
		}
		else if( PawnOwner.IsCarryingShield() )
		{
			OverrideBodyStance(BS_PawnWeaponReload, ShieldReloadOverride);
		}
	}

	// Clear weapon reload animations if a kidnapper or carrying shield.
	// We have simplified animations for those.
	if( ShouldPlaySimplePistolReload() )
	{
		WeaponReloadAnim = '';
		WeaponReloadAnimFail = '';
	}
	else
	{
		WeaponReloadAnim = default.WeaponReloadAnim;
		WeaponReloadAnimFail = default.WeaponReloadAnimFail;
	}

	Super.PlayWeaponReloading();

	// If we're a kidnapper, have the hostage play those animations too!
	if( PawnOwner.IsAKidnapper() )
	{
		PawnOwner.InteractionPawn.BS_Play(BS_PawnWeaponReload, 1.f, 0.25f, 0.33f, FALSE, TRUE, 'WeaponReload');
	}

}


/**
 * If this is TRUE, play simpler version for kidnapper and shield carrying state.
 * Less fancy.
 */
simulated final function bool ShouldPlaySimplePistolReload()
{
	local TGPawn	PawnOwner;

	PawnOwner = TGPawn(Instigator);
	if( PawnOwner != None && (PawnOwner.IsAKidnapper() || PawnOwner.IsCarryingShield()) )
	{
		return TRUE;
	}

	return FALSE;
}

/** Utility function to override a given body stance with another one. */
simulated function OverrideBodyStance(out BodyStance BaseStance, out BodyStance OverrideStance)
{
	local int OverrideIndex;

	// Empty base stance.
	BaseStance.AnimName.Length = 0;
	for(OverrideIndex=0; OverrideIndex<OverrideStance.AnimName.Length; OverrideIndex++)
	{
		if( OverrideStance.AnimName[OverrideIndex] != '' )
		{
			BaseStance.AnimName[OverrideIndex] = OverrideStance.AnimName[OverrideIndex];
		}
	}
}

simulated function EndReloadAnimations()
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);

	// Stop hostage reload animations too!
	if( PawnOwner.IsAKidnapper() )
	{
		PawnOwner.InteractionPawn.BS_Stop(BS_PawnWeaponReload, 0.33f);
		PawnOwner.InteractionPawn.BS_Stop(BS_PawnWeaponReloadSuccess, 0.33f);
		PawnOwner.InteractionPawn.BS_Stop(BS_PawnWeaponReloadFail, 0.33f);
	}
}

simulated function PlayActiveReloadSuperSuccess()
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);
	if( PawnOwner.IsAKidnapper() )
	{
		// If we have a player reload success animation, play it
		if( BS_PawnWeaponReloadSuccess.AnimName.Length > 0 )
		{
			// Override normal reload animation with success one
			PawnOwner.InteractionPawn.BS_Override(BS_PawnWeaponReloadSuccess);
		}
	}

	Super.PlayActiveReloadSuperSuccess();
}

simulated function ScaleWeaponAnimPlayRate(float Scale)
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);
	if( PawnOwner.IsAKidnapper() )
	{
		// If we have a player reload success animation, play it
		if( BS_PawnWeaponReloadSuccess.AnimName.Length == 0 )
		{
			// Scale player reload animation
			PawnOwner.InteractionPawn.BS_ScalePlayRate(BS_PawnWeaponReload, Scale);
		}
	}

	Super.ScaleWeaponAnimPlayRate(Scale);
}

simulated function PlayActiveReloadSuccess()
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);
	if( PawnOwner.IsAKidnapper() )
	{
		// If we have a player reload success animation, play it
		if( BS_PawnWeaponReloadSuccess.AnimName.Length > 0 )
		{
			// Override normal reload animation with success one
			PawnOwner.InteractionPawn.BS_Override(BS_PawnWeaponReloadSuccess);
		}
	}

	Super.PlayActiveReloadSuccess();
}

simulated function PlayActiveReloadFailed()
{
	local TGPawn PawnOwner;

	PawnOwner = TGPawn(Instigator);
	if( PawnOwner.IsAKidnapper() )
	{
		// Play active reload failed animation
		if( BS_PawnWeaponReloadFail.AnimName.Length > 0 )
		{
			PawnOwner.InteractionPawn.BS_Override(BS_PawnWeaponReloadFail);
		}
	}

	// Override reload animations with shield override if carrying shield
	BS_PawnWeaponReloadFail = default.BS_PawnWeaponReloadFail;
	if( PawnOwner != None )
	{
		if( PawnOwner.CarriedCrate != None )
		{
			OverrideBodyStance(BS_PawnWeaponReloadFail, CrateCarryReloadFailedOverride);
		}
		else if( PawnOwner.IsCarryingShield() )
		{
			OverrideBodyStance(BS_PawnWeaponReloadFail, ShieldReloadFailedOverride);
		}
	}

	Super.PlayActiveReloadFailed();
}

function bool VerifyGrenadeWeapon();
function ForceThrowGrenade( TGAI AI );

simulated function float PlayMeleeAttackAnimation(TGPawn P)
{
	if( P.IsAKidnapper() )
	{
		P.InteractionPawn.BS_Play(BS_MeleeAttackHostage, 1.f, 0.1f, 0.25f, FALSE, TRUE);
		return P.BS_Play(BS_MeleeAttackKidnapper, 1.f, 0.1f, 0.25f, FALSE, TRUE);
	}

	return Super.PlayMeleeAttackAnimation(P);
}

/**
 * TRUE if reloading weapon takes out of TargetingMode, TRUE for most weapons.
 * When deploying shield, allow to reload in that position.
 */
simulated event bool ShouldReloadingPreventTargeting()
{
	local TGPawn GPOwner;

	GPOwner = TGPawn(Instigator);
	return bReloadingWeaponPreventsTargeting && GPOwner != None && !GPOwner.IsDeployingShield();
}

/** Give you infinite pistol ammo when carrying crate */
simulated function bool HasInfiniteSpareAmmo()
{
	local TGPawn GPOwner;

	GPOwner = TGPawn(Instigator);
	if(GPOwner != None && GPOwner.CarriedCrate != None)
	{
		return TRUE;
	}
	else
	{
		return Super.HasInfiniteSpareAmmo();
	}
}


