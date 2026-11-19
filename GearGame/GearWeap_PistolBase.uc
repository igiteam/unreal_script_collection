/**
 * Pistol Base Class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_PistolBase extends GearWeapon
	native(Weapon)
	abstract;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float ZoomFOV;

var() float FireAnimRateScale;

/** Override animations for Shield Reloads */
var BodyStance	ShieldReloadOverride, ShieldReloadFailedOverride;

/** Reference to duel grenade weapon */
var GearWeap_GrenadeBase	GrenWeap;

/** Weapons get a crack at handling controls */
simulated function bool HandleButtonPress( coerce Name ButtonName )
{
	local GearPC PC;
	local GearPawn InstigatorGP;

	if( super.HandleButtonPress( ButtonName ) == FALSE )
	{
		if( InputCanZoom(ButtonName) )
		{
			PC = GearPC(GetWeaponController());
			InstigatorGP = GearPawn(Instigator);

			//@todo should be able to click on R3 and zoom in target instantly
			if ( (PC != None) && (InstigatorGP != None) && (PC.bIsTargeting || InstigatorGP.IsDeployingShield()) )
			{
				SetZoomed(!GearPawn(Instigator).bIsZoomed);

				if( GearPawn(Instigator).bIsZoomed == TRUE )
				{
					GearWeaponPlaySoundLocal(ZoomActivatedSound,,, TRUE);
				}
				else
				{
					GearWeaponPlaySoundLocal(ZoomDeactivatedSound,,, TRUE);
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
	if( GearPawn(Instigator).bIsZoomed == TRUE )
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
	local GearPawn InstigatorGP;

	if (GearPawn(Instigator).bIsZoomed)
	{
		InstigatorGP = GearPawn(Instigator);
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
	if( GearPawn(Instigator).bIsZoomed == TRUE )
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
	if (GearAIController != None && GearAIController.MyGearPawn != None && GearAIController.MyGearPawn.IsAKidnapper())
	{
		return 10.0;
	}
	return 0.4f;
}

simulated state Active
{
	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;

		Global.TargetingModeChanged(P);

		if( (Instigator != none) && GearPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = GearPC(GetWeaponController());
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

simulated function TargetingModeChanged(GearPawn P)
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
// 	local GearPawn P;
// 
// 	P = GearPawn(Instigator);
// 
// 	// When left hand should be IK'd
// 	// When doing 360 aiming, when targeting, when reloading weapon
// 	if( P.IsAKidnapper() || P.bDoing360Aiming || P.bIsTargeting || P.IsReloadingWeapon() )
// 	{
// 		bDisableLeftHandIK = FALSE;
// 		P.UpdateBoneLeftHandIK();
// 	}
// 	else
// 	{
// 		bDisableLeftHandIK = TRUE;
// 		P.UpdateBoneLeftHandIK();
// 	}
}

simulated function TimeWeaponEquipping()
{
	SetZoomed(FALSE,FALSE);

	Super.TimeWeaponEquipping();

	// weapon equipped, update status of left hand ik
	UpdatePistolLeftHandIK();
}

simulated function TimeWeaponPutDown()
{
	SetZoomed(FALSE,FALSE);
	Super.TimeWeaponPutDown();
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
	local GearPawn PawnOwner;
	local GSM_InteractionPawnLeader_Base LeaderInteractionSM;
	local GSM_InteractionPawnFollower_Base FollowerInteractionSM;

	PawnOwner = GearPawn(Instigator);

	// Override reload animations with shield override if carrying shield
	BS_PawnWeaponReload = default.BS_PawnWeaponReload;
	if( PawnOwner != None )
	{
		if( PawnOwner.IsCarryingShield() )
		{
			BS_PawnWeaponReload = ShieldReloadOverride;
		}

		if( PawnOwner.IsDoingASpecialMove() )
		{
			LeaderInteractionSM = GSM_InteractionPawnLeader_Base(PawnOwner.SpecialMoves[PawnOwner.SpecialMove]);
			if( LeaderInteractionSM != None && LeaderInteractionSM.BS_PistolReload.Stance.Length > 0 )
			{
				BS_PawnWeaponReload = LeaderInteractionSM.BS_PistolReload;
			}
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

	// Support playing animations for sync'd InteractionPawn.
	if( PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsDoingASpecialMove() )
	{
		FollowerInteractionSM = GSM_InteractionPawnFollower_Base(PawnOwner.InteractionPawn.SpecialMoves[PawnOwner.InteractionPawn.SpecialMove]);
		if( FollowerInteractionSM != None && FollowerInteractionSM.BS_PistolReload.Stance.Length > 0 )
		{
			PawnOwner.InteractionPawn.BS_Play(FollowerInteractionSM.BS_PistolReload, 1.f, 0.25f, 0.33f, FALSE, TRUE, 'WeaponReload');
		}
	}
}

/** 
 * If this is TRUE, play simpler version for kidnapper and shield carrying state.
 * Less fancy.
 */
simulated final function bool ShouldPlaySimplePistolReload()
{
	local GearPawn	PawnOwner;
	local GSM_InteractionPawnLeader_Base LeaderInteractionSM;

	PawnOwner = GearPawn(Instigator);
	if( PawnOwner != None )
	{
		if( PawnOwner.IsDoingASpecialMove() )
		{
			// Interactions can have custom reload animations, sometimes they need to be simplified.
			LeaderInteractionSM = GSM_InteractionPawnLeader_Base(PawnOwner.SpecialMoves[PawnOwner.SpecialMove]);
			if( LeaderInteractionSM != None && LeaderInteractionSM.bPlaySimplePistolReload )
			{
				return TRUE;
			}
		}
		// Shield has simplified pistol reload animation.
		return PawnOwner.IsCarryingShield();
	}

	return FALSE;
}

/** Stop Weapon reload animations */
simulated function EndReloadAnimations()
{
	local GearPawn PawnOwner;
	local GSM_InteractionPawnFollower_Base FollowerInteractionSM;
	local GSM_InteractionPawnLeader_Base LeaderInteractionSM;

	Super.EndReloadAnimations();

	PawnOwner = GearPawn(Instigator);

	// Support for Interactions.
	if( PawnOwner.IsDoingASpecialMove() )
	{
		LeaderInteractionSM = GSM_InteractionPawnLeader_Base(PawnOwner.SpecialMoves[PawnOwner.SpecialMove]);
		if( LeaderInteractionSM != None )
		{
			if( LeaderInteractionSM.BS_PistolReload.Stance.Length > 0 )
			{
				PawnOwner.InteractionPawn.BS_Stop(LeaderInteractionSM.BS_PistolReload, 0.33f);
			}
			if( LeaderInteractionSM.BS_PistolReloadFail.Stance.Length > 0 )
			{
				PawnOwner.BS_Stop(LeaderInteractionSM.BS_PistolReloadFail, 0.33f);
			}
		}
	}

	// Support for InteractionPawns.
	if( PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsDoingASpecialMove() )
	{
		FollowerInteractionSM = GSM_InteractionPawnFollower_Base(PawnOwner.InteractionPawn.SpecialMoves[PawnOwner.InteractionPawn.SpecialMove]);
		if( FollowerInteractionSM != None )
		{
			if( FollowerInteractionSM.BS_PistolReload.Stance.Length > 0 )
			{
				PawnOwner.InteractionPawn.BS_Stop(FollowerInteractionSM.BS_PistolReload, 0.33f);
			}
			if( FollowerInteractionSM.BS_PistolReloadFail.Stance.Length > 0 )
			{
				PawnOwner.InteractionPawn.BS_Stop(FollowerInteractionSM.BS_PistolReloadFail, 0.33f);
			}
		}
	}
}

simulated function ScaleWeaponAnimPlayRate(float Scale)
{
	local GearPawn PawnOwner;
	local GSM_InteractionPawnFollower_Base FollowerInteractionSM;

	PawnOwner = GearPawn(Instigator);
	if( PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsDoingASpecialMove() )
	{
		FollowerInteractionSM = GSM_InteractionPawnFollower_Base(PawnOwner.InteractionPawn.SpecialMoves[PawnOwner.InteractionPawn.SpecialMove]);
		if( FollowerInteractionSM != None && FollowerInteractionSM.BS_PistolReload.Stance.Length > 0 )
		{
			// Scale player reload animation
			PawnOwner.InteractionPawn.BS_ScalePlayRate(FollowerInteractionSM.BS_PistolReload, Scale);
		}
	}

	Super.ScaleWeaponAnimPlayRate(Scale);
}

simulated function PlayActiveReloadFailed()
{
	local GearPawn PawnOwner;
	local GSM_InteractionPawnFollower_Base FollowerInteractionSM;
	local GSM_InteractionPawnLeader_Base LeaderInteractionSM;

	PawnOwner = GearPawn(Instigator);

	// Override reload animations with shield override if carrying shield
	BS_PawnWeaponReloadFail = default.BS_PawnWeaponReloadFail;
	if( PawnOwner != None )
	{
		if( PawnOwner.IsCarryingShield() )
		{
			BS_PawnWeaponReloadFail = ShieldReloadFailedOverride;
		}
		else if( PawnOwner.IsDoingASpecialMove() )
		{
			LeaderInteractionSM = GSM_InteractionPawnLeader_Base(PawnOwner.SpecialMoves[PawnOwner.SpecialMove]);
			if( LeaderInteractionSM != None && LeaderInteractionSM.BS_PistolReloadFail.Stance.Length > 0 )
			{
				BS_PawnWeaponReloadFail = LeaderInteractionSM.BS_PistolReloadFail;
			}
		}
	}

	// Support playing animations for sync'd InteractionPawn.
	if( PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsDoingASpecialMove() )
	{
		FollowerInteractionSM = GSM_InteractionPawnFollower_Base(PawnOwner.InteractionPawn.SpecialMoves[PawnOwner.InteractionPawn.SpecialMove]);
		if( FollowerInteractionSM != None && FollowerInteractionSM.BS_PistolReloadFail.Stance.Length > 0 )
		{
			PawnOwner.InteractionPawn.BS_Override(FollowerInteractionSM.BS_PistolReloadFail);
		}
	}

	Super.PlayActiveReloadFailed();
}

function bool VerifyGrenadeWeapon();
function ForceThrowGrenade( GearAI AI );

simulated function float PlayMeleeAttackAnimation(GearPawn P)
{
	local GSM_InteractionPawnLeader_Base LeaderInteractionSM;
	local GSM_InteractionPawnFollower_Base FollowerInteractionSM;

	if( P.IsDoingASpecialMove() )
	{
		LeaderInteractionSM = GSM_InteractionPawnLeader_Base(P.SpecialMoves[P.SpecialMove]);
		if( LeaderInteractionSM != None && LeaderInteractionSM.BS_PistolMelee.Stance.Length > 0 )
		{
			// Support playing animations for sync'd InteractionPawn.
			if( P.InteractionPawn != None && P.InteractionPawn.IsDoingASpecialMove() )
			{
				FollowerInteractionSM = GSM_InteractionPawnFollower_Base(P.InteractionPawn.SpecialMoves[P.InteractionPawn.SpecialMove]);
				if( FollowerInteractionSM != None && FollowerInteractionSM.BS_PistolMelee.Stance.Length > 0 )
				{
					P.InteractionPawn.BS_Play(FollowerInteractionSM.BS_PistolMelee, 1.f, 0.1f, 0.25f, FALSE, TRUE);
				}
			}

			return P.BS_Play(LeaderInteractionSM.BS_PistolMelee, 1.f, 0.1f, 0.25f, FALSE, TRUE);
		}
	}

	return Super.PlayMeleeAttackAnimation(P);
}

/** 
 * TRUE if reloading weapon takes out of TargetingMode, TRUE for most weapons. 
 * When deploying shield, allow to reload in that position.
 */
simulated event bool ShouldReloadingPreventTargeting()
{
	local GearPawn GPOwner;

	GPOwner = GearPawn(Instigator);
	return bReloadingWeaponPreventsTargeting && GPOwner != None && !GPOwner.IsDeployingShield();
}

defaultproperties
{
	FiringStatesArray(0)="WeaponFiring"

	WeaponType=WT_Holster
	WeaponAnimType=EWAT_Pistol

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Pistol'
	CustomAnimSets(1)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_Overlay_Pistol'
	AimOffsetProfileNames(0)="Pistol"

	BS_PawnWeaponReload={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_Pistol_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Pistol_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Pistol_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_Pistol_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Pistol_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Pistol_Cov_Std_Reload_Fail"))
		)}

	HolsterShoulderRight={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_Pistol_Holster_Rt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Pistol_Cov_Std_Holster_Rt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Pistol_Cov_Mid_Holster_Rt"))
	)}

	EquipShoulderRight={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_Pistol_Equip_Rt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Pistol_Cov_Std_Equip_Rt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Pistol_Cov_Mid_Equip_Rt"))
	)}

	BS_MeleeAttack.Empty()
	BS_MeleeAttack(0)=(Stance=((Slot=BS_Layer1,AnimName="ADD_Pistol_Melee_Smack_A")))
	BS_MeleeAttack(1)=(Stance=((Slot=BS_Layer1,AnimName="ADD_Pistol_Melee_Smack_B")))

	/** Special overrides for shield */
	ShieldReloadOverride=(Stance=((Slot=BS_Std_Up,AnimName="BS_Pistol_Reload"),(Slot=BS_Shield_Hunkered,AnimName="BS_Deployed_Pistol_Reload")))
	ShieldReloadFailedOverride=(Stance=((Slot=BS_Std_Up,AnimName="BS_Pistol_Reload_Fail"),(Slot=BS_Shield_Hunkered,AnimName="BS_Deployed_Pistol_Reload_Fail")))
	
	// Weapon Animation
	Begin Object Class=AnimNodeSequence Name=WeaponAnimNode
	    AnimSeqName=""
	End Object
	WeaponFireAnim="HG_Fire"
	WeaponReloadAnim=""
	WeaponReloadAnimFail=""

	ZoomActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomIn_Cue'
	ZoomDeActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomOut_Cue'

	EquipTime=0.425f
	PutDownTime=0.425f

	bCanDisplayReloadTutorial=TRUE

	bCanEquipWithShield=TRUE

	bAllowTracers=TRUE

	TracerType=WTT_SnubPistol
	TracerTypeAR=WTT_SnubPistol_AR
}


