
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ReviveTeammate extends GearSpecialMove
	config(Pawn);

/** Pawn To Revive */
var GearPawn PawnToRevive;

/** Weapon pickup body stance animation */
var() GearPawn.BodyStance BS_Pickup;

/** Revive Search radius */
var() config float ReviveSearchRadius;

protected function bool InternalCanDoSpecialMove()
{
	return (!PawnOwner.IsDBNO() && FindPawnToRevive());
}

function bool FindPawnToRevive()
{
	local GearPawn FoundPawn;

	PawnToRevive = None;
	foreach PawnOwner.VisibleCollidingActors(class'GearPawn', FoundPawn, ReviveSearchRadius, PawnOwner.Location, true)
	{
		// prioritize leader; otherwise select first found
		if (PawnToRevive == None || (GearPRI(FoundPawn.PlayerReplicationInfo) != None && GearPRI(FoundPawn.PlayerReplicationInfo).bIsLeader))
		{
			// Cannot revive hostages.
			if (FoundPawn.bCanRecoverFromDBNO && FoundPawn.IsDBNO(true) && PawnOwner != FoundPawn && PawnOwner.IsSameTeam(FoundPawn))
			{
				PawnToRevive = FoundPawn;
			}
		}
	}

	return (PawnToRevive != None);
}


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.InterpolatePawnRotation(0.6f);

	// Revive Pawn we found on the server.
	if (PawnOwner.Role == Role_Authority)
	{
		if (AIOwner != None)
		{
			// sanity check that the AI got a target, since this move doesn't do it through InteractionPawn
			FindPawnToRevive();
		}
		if (PawnToRevive != None)
		{
			GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_Revived, PawnOwner, PawnToRevive);
			PawnToRevive.DoRevival(PawnOwner, false);
		}
	}

	AlignToActor = PawnToRevive;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Pickup, SpeedModifier, 0.5f/SpeedModifier, 0.33f/SpeedModifier, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Pickup, TRUE);

	// Trigger the revive delegates in the GearPC
	if ( PCOwner != None )
	{
		PCOwner.TriggerGearEventDelegates( eGED_Revive );
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.InterpolatePawnRotation(0.6f);

	PawnOwner.BS_SetAnimEndNotify(BS_Pickup, false);
}

defaultproperties
{
	bShouldAbortWeaponReload=true
	bCanFireWeapon=false
	bDisableMovement=true
	bBreakFromCover=true

	BS_Pickup=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Ready_Pickup")))

	Action={(
			ActionName=ReviveTeammate,
			ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=175,V=239,UL=136,VL=75)))	),
	)}
}

