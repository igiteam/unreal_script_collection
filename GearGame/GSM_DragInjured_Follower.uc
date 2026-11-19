
/**
 * Dragging Injured People: Follower.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DragInjured_Follower extends GSM_InteractionPawnFollower_Base;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// if pawn is on fire or smoldering, put him out
	PawnOwner.ExtinguishPawn();

	PawnOwner.InteractionPawn.StartBloodTrail( 'SpawnABloodTrail_MeatBag' );

	if( PawnOwner.WorldInfo.NetMode != NM_Client )
	{
		// if carrying a heavy weapon, drop it
		if( PawnOwner.IsCarryingAHeavyWeapon() )
		{
			PawnOwner.ThrowActiveWeapon();
		}

		// if carrying a shield, drop it
		if( PawnOwner.IsCarryingShield() )
		{
			PawnOwner.DropShield();
		}
	}

	// Detach weapon if it hasn't been already.
	if( PawnOwner.MyGearWeapon != None )
	{
		PawnOwner.MyGearWeapon.DetachWeapon();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.InteractionPawn.StopBloodTrail( 'SpawnABloodTrail_MeatBag' );

	// if we were released alive, then reattach our weapon
	// non-owning client only, since the server and owning client do the full weapon selection logic elsewhere
	if( PawnOwner.WorldInfo.NetMode == NM_Client && !PawnOwner.bTearOff && PawnOwner.MyGearWeapon != None &&
		!PawnOwner.IsLocallyControlled() )
	{
		PawnOwner.AttachWeapon();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	bDisableLook=False
	bCameraFocusOnPawn=False

	BS_PistolReload=(Stance=((Slot=BS_Std_Up,AnimName="injured_reload")))
	BS_PistolReloadFail=(Stance=((Slot=BS_Std_Up,AnimName="injured_reload_fail")))
	BS_PistolMelee=(Stance=((Slot=BS_Std_Up,AnimName="injured_melee")))
}
