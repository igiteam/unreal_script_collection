
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageForceOff extends GSM_Engage;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local BodyStance EndStance;
	local ERootBoneAxis RootBoneMotion;

	Super.SpecialMoveStarted(bForced,PrevMove);

	if( PawnOwner.EngageTrigger != None )
	{
		if( (PawnOwner.EngageTrigger.ENGAGE_AnimName_End != '' || PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff != '') &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			// Create the STOP stance
			if( PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff == '' )
			{
				RootBoneMotion = PawnOwner.EngageTrigger.RootBoneMotion_End;
				EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				EndStance.Stance[0].Slot = BS_FullBody;
				EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_End;
			}
			else
			{
				RootBoneMotion = PawnOwner.EngageTrigger.RootBoneMotion_ForceOff;
				EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				EndStance.Stance[0].Slot = BS_FullBody;
				EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff;
			}

			// Play body stance animation.
			PawnOwner.BS_Play(EndStance, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(EndStance, RootBoneMotion, RootBoneMotion, RootBoneMotion);

			// Enable end of animation notification. This is going to call SpecialMoveEnded()
			PawnOwner.BS_SetAnimEndNotify(EndStance, TRUE);
		}
		else
		{
			PawnOwner.SetTimer(0.1f, FALSE, 'EndInteraction', Self);
		}

		PawnOwner.EngageTrigger.EngagedPawn = None;
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance EndStance;
	local Array<AnimSet> AnimSetsToAdd;

	if( PawnOwner.EngageTrigger != None )
	{
		if( (PawnOwner.EngageTrigger.ENGAGE_AnimName_End != '' || PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff != '') &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			// Create the STOP stance
			if( PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff == '' )
			{
				EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				EndStance.Stance[0].Slot = BS_FullBody;
				EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_End;
			}
			else
			{
				EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				EndStance.Stance[0].Slot = BS_FullBody;
				EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_ForceOff;
			}
		}
		PawnOwner.BS_SetAnimEndNotify(EndStance, FALSE);

		// Turn off Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(EndStance, RBA_Discard, RBA_Discard, RBA_Discard);

		// unholster the weapon
		PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);
	}

	if( PCOwner != None )
	{
		PCOwner.SetRumbleScale(1.f);
	}

	// Clear the anim set from the pawn
	if (PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base != None)
	{
		AnimSetsToAdd.AddItem(PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base);
		PawnOwner.RemoveLocalCustomAnimSets(AnimSetsToAdd);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}
