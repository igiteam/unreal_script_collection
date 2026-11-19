
/**
 * GSM_SilverbackLoaderCratePickup
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SilverbackLoaderCratePickup extends GearSpecialMove;

var GearPawn_SilverbackLoaderBase	SilverbackLoader;
var BodyStance PickupAnimation;
var float BlendInTime;

protected function bool InternalCanDoSpecialMove()
{
	return GearPawn_SilverbackLoaderBase(PawnOwner).CanLiftCrate();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	SilverbackLoader = GearPawn_SilverbackLoaderBase(PawnOwner);
	PlayPickupAnimation();
}

function PlayPickupAnimation()
{
	SilverbackLoader.BS_Play(PickupAnimation, 1.f, BlendInTime, BlendInTime);
	SilverbackLoader.Driver.BS_Play(PickupAnimation, 1.f, BlendInTime, BlendInTime);
	SilverbackLoader.SetTimer(BlendInTime, FALSE, 'AttachCrate');
	PawnOwner.BS_SetAnimEndNotify(PickupAnimation, TRUE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Attach the crate now, in case we were forced out of the special move early
	if( !SilverbackLoader.bAttachedCrate )
	{
		SilverbackLoader.AttachCrate();
	}

	// Clear timer if it's been set.
	PawnOwner.ClearTimer('AttachCrate', Self);
	// Disable end of animation notification, so it doesn't interfere with future special moves
	// using that same animation channel.
	PawnOwner.BS_SetAnimEndNotify(PickupAnimation, FALSE);

	if( PawnOwner.MyGearAI != None )
	{
		PawnOwner.MyGearAI.ClearTether();
		PawnOwner.MyGearAI.SilverbackCrateAction.ActivateOutputLink(0);
		PawnOwner.MyGearAI.SilverbackCrateAction = None;
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	PickupAnimation=(Stance=((Slot=BS_FullBody,AnimName="Loader_LIftPayload")))
	BlendInTime=0.33f
	bDisableMovement=TRUE

	Action={(
		ActionName=SilverbackLoaderPickup,
		ActionIconDatas=( (ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
						  (ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=291,V=46,UL=138,VL=89)))
						))
		}	

	bShowHUDActions=TRUE

}

