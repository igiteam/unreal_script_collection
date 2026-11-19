
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageIdle extends GSM_Engage;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local BodyStance IdleStance;

	Super.SpecialMoveStarted(bForced,PrevMove);

	if( PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.ENGAGE_AnimName_Idle != '' )
	{
		if( PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy )
		{
			// Create the stance
			IdleStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			IdleStance.Stance[0].Slot = BS_FullBody;
			IdleStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Idle;

			// Play Looping Idle animation
			PawnOwner.BS_Play(IdleStance, SpeedModifier, 0.2f/SpeedModifier, 0.f, TRUE, TRUE);

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(IdleStance, PawnOwner.EngageTrigger.RootBoneMotion_Idle, PawnOwner.EngageTrigger.RootBoneMotion_Idle, PawnOwner.EngageTrigger.RootBoneMotion_Idle);
		}
	}
}

/** Stop the START animation and call the IDLE special move if there is one, else call the END move */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance IdleStance;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// See if we're finished and play the idle if not
	CheckForFinishEngage();

	// Turn off Root motion on animation node
	IdleStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
	IdleStance.Stance[0].Slot = BS_FullBody;
	IdleStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Idle;
	PawnOwner.BS_SetRootBoneAxisOptions(IdleStance, RBA_Discard, RBA_Discard, RBA_Discard);
}

/**
 * Handle the ENGAGE_bRequireButtonHold case
 * 
 * @param DeltaTime - the length of the last frame
 */
function Tick(float DeltaTime)
{
	local GearPlayerInput GPI;
	
	Super.Tick(DeltaTime);

	if( PCOwner != None )
	{
		GPI = GearPlayerInput(PCOwner.PlayerInput);

		// If we're supposed to hold the button and we've let go, tell the server to quit the move
		if (PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.ENGAGE_bRequireButtonHold && PawnOwner.IsLocallyControlled() && !GPI.IsButtonActive(GB_X))
		{
			PCOwner.ServerHandleButtonPress('X');
		}
	}
}