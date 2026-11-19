
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_Scream extends GearSpecialMove;

var GearPawn.BodyStance BS_Animation;

/** cooldown after the scream is used before it can be used again */
var config float Cooldown;

/** last time the scream was used (for cooldown tracking) */
var float LastScreamTime;

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_LocustWretchBase Wretch;
	local GearPawn P;

	if (!PawnOwner.IsHumanControlled())
	{
		return true;
	}
	else if (PawnOwner.WorldInfo.TimeSeconds - LastScreamTime < Cooldown)
	{
		return false;
	}
	else
	{
		Wretch = GearPawn_LocustWretchBase(PawnOwner);
		foreach Wretch.VisibleCollidingActors(class'GearPawn', P, Wretch.SiegeModeScreamExplosion.CringeRadius, Wretch.Location + vect(0,0,2) * Wretch.GetCollisionHeight())
		{
			if ((P.PlayerReplicationInfo != None || P.DrivenVehicle != None) && !P.IsDBNO() && !PawnOwner.WorldInfo.GRI.OnSameTeam(P, PawnOwner))
			{
				return true;
			}
		}

		return false;
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2 / SpeedModifier, 0.2 / SpeedModifier, false, true);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, true);

	GearPawn_LocustWretchBase(PawnOwner).PlayScreamSound();

	// if Siege mode, do the cringing, etc
	if (GearPC_Siege(PCOwner) != None)
	{
		GearPawn_LocustWretchBase(PawnOwner).DoSiegeScream();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, false);

	PawnOwner.ClearTimer('LoopScreamEffect');

	LastScreamTime = PawnOwner.WorldInfo.TimeSeconds;
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Scream")))

	bLockPawnRotation=true
	bBreakFromCover=true
	bDisableCollision=false
	bDisableMovement=true
	bDisablePhysics=true
	bCanFireWeapon=false

	Action={(
		ActionName=Scream,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=284,V=346,UL=104,VL=91)))	),
	)}
}
