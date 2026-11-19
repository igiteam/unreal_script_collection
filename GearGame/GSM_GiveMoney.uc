/**
 * Give money coop interaction
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_GiveMoney extends GearSpecialMove;

/** The pawn that we are sharing money with */
var GearPawn MoneyReceiver;

/** The animation to play */
var() GearPawn.BodyStance BS_Animation;

/** How much to give per interaction */
var config int MoneyTransferAmount;

/**
 * Allow sharing money while holding a shield
 *
 * @param InMove - the move to be overridden
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	if (InMove == SM_DeployShield)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * We need to be in horde and have enough money
 *
 * @return true if can interact
 */
protected function bool InternalCanDoSpecialMove()
{
	if (PawnOwner.IsInCover() || PawnOwner.IsDBNO() || PawnOwner.IsFiring())
	{
		return FALSE;
	}

	if (!ClassIsChildOf(PawnOwner.WorldInfo.GRI.GameClass, class'GearGameHorde_Base') || PawnOwner.PlayerReplicationInfo.Score < MoneyTransferAmount)
	{
		return FALSE;
	}

	// trust remote pawns can do this move
	if (!PawnOwner.IsLocallyControlled())
	{
		return TRUE;
	}

	return CanShareMoney();
}

/**
 * Can we give money to the targeted pawn?
 *
 * @return true if the targeted pawn is acceptable
 */
private function bool CanShareMoney()
{
	local GearPawn GP;
	local GearPRI PRI;

	if (GearPC(PawnOwner.Controller) != None)
	{
		GP = GearPC(PawnOwner.Controller).TargetedPawn;
	}

	if (GP != None && VSize(GP.Location - PawnOwner.Location) < PawnOwner.CoopInteractionDistance)
	{
		PRI = GearPRI(GP.PlayerReplicationInfo);

		if (PRI == None && GP.DrivenVehicle != None)
		{
			PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
		}

		if (!GP.bCanBeBaseForPawns && PRI != none && !PRI.bBot && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Start the body animation when the special move starts.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn GP;
	local GearPRI PRI;
	local float BestGPDot;

	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.InterpolatePawnRotation();

	// Only the server needs to run this logic.
	if (PawnOwner.Role == ROLE_Authority)
	{
		MoneyReceiver = none;

		// Find the best candidate to share with
		foreach PawnOwner.VisibleCollidingActors(class'GearPawn', GP, PawnOwner.CoopInteractionDistance, PawnOwner.Location, TRUE)
		{
			PRI = GearPRI(GP.PlayerReplicationInfo);

			if (PRI == None && GP.DrivenVehicle != None)
			{
				PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
			}

			if (!GP.bCanBeBaseForPawns && PRI != none && !PRI.bBot && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
			{
				if (MoneyReceiver == none || vector(PawnOwner.Rotation) dot Normal(GP.Location - PawnOwner.Location) > BestGPDot)
				{
					MoneyReceiver = GP;
					// The angle between our forward vector and the vector to the candidate can be used to determine fitness of the candidate.
					BestGPDot = vector(PawnOwner.Rotation) dot Normal(GP.Location - PawnOwner.Location);
				}
			}
		}
	}

	AlignToActor = MoneyReceiver;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE );
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// notify guds
	if (PawnOwner.WorldInfo.Game != None)
	{
		GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_GiveMoney, PawnOwner);
	}
}

/**
 * Remove the end of animation notification that was set in SpecialMoveStarted.
 *
 * @param PrevMove - the previous special move to run
 *
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local vector ToReceiver;
	local PlayerReplicationInfo ReceiverPRI;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Only the server needs to run this logic.
	if (PawnOwner.Role == ROLE_Authority && MoneyReceiver != none && !MoneyReceiver.IsDBNO())
	{
		// Make sure that the receiver is still in the right place.
		ToReceiver = MoneyReceiver.Location - PawnOwner.Location;

		// Allow the player to move out of the radius just a bit.
		if (vector(PawnOwner.Rotation) dot Normal(ToReceiver) > 0 && VSize(ToReceiver) <= PawnOwner.CoopInteractionDistance * 1.7f)
		{
			ReceiverPRI = MoneyReceiver.PlayerReplicationInfo;

			if (ReceiverPRI == None && MoneyReceiver.DrivenVehicle != None)
			{
				ReceiverPRI = MoneyReceiver.DrivenVehicle.PlayerReplicationInfo;
			}

			if (ReceiverPRI != None)
			{
				PawnOwner.PlayerReplicationInfo.Score -= MoneyTransferAmount;
				ReceiverPRI.Score += MoneyTransferAmount;

				PawnOwner.PlayerReplicationInfo.bForceNetUpdate = TRUE;
				ReceiverPRI.bForceNetUpdate = TRUE;

				if ( GearGRI_Horde(PawnOwner.WorldInfo.GRI).bCanPlaceFortifications &&
					(PawnOwner.IsLocallyControlled() || MoneyReceiver.IsLocallyControlled()) )
				{
					GearGRI_Horde(PawnOwner.WorldInfo.GRI).UpdateFortificationGhostImages();
				}
			}
		}
	}

	PawnOwner.InterpolatePawnRotation();

	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);
}

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE

	BS_Animation=(Stance=((Slot=BS_Std_Up,AnimName="AR_Melee_Smack_A"),(Slot=BS_Std_Idle_Lower,AnimName="AR_Melee_Smack_A")))
}
