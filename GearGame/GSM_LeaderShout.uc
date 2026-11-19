/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LeaderShout extends GSM_BasePlaySingleAnim;

/* Team body stances for leader**/
var GearPawn.BodyStance COGLeader;
var GearPawn.BodyStance LOCLeader;

protected function bool InternalCanDoSpecialMove()
{
	return true;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearGameCTL_Base CTLGame;
	local SoundCue Cue;

	CTLGame = GearGameCTL_Base(PawnOwner.WorldInfo.Game);

	// If index == 0, it's COG team
	if ( PawnOwner.GetTeamNum() == 0 )
	{
		if (CTLGame != none)
		{	
			Cue = CTLGame.Sound_LeaderRoundStart[0];
		}
		BS_Animation = COGLeader;
	}
	else
	{
		if (CTLGame != none)
		{	
			Cue = CTLGame.Sound_LeaderRoundStart[1];
		}
		BS_Animation = LOCLeader;
	}

	Super.SpecialMoveStarted(bForced, PrevMove);

	if (PCOwner != none && PCOwner.IsLocalPlayerController())
	{
		PCOwner.TutorialMgr.AddTutorial(GEARTUT_Leader);
		PCOwner.TutorialMgr.StartTutorial(GEARTUT_Leader);
	}

	if (Cue != none)
	{	
		PawnOwner.SpeakLine(None, Cue, "", 0.0, Speech_Immediate);
	}
}

defaultproperties
{
	COGLeader=(Stance=((Slot=BS_Std_Up,AnimName="Leader_Shout_Prescott"), (Slot=BS_Std_Idle_Lower,AnimName="Leader_Shout_Prescott")))
	LOCLeader=(Stance=((Slot=BS_Std_Up,AnimName="Leader_Shout_Myrrah"), (Slot=BS_Std_Idle_Lower,AnimName="Leader_Shout_Myrrah")))

	BlendInTime=0.25

	bShouldAbortWeaponReload=true
	bCanFireWeapon=false
	bDisableMovement=false
	bDisableLook=false
	bLockPawnRotation=false
	bDisablePOIs=false

	bDisableLeftHandIK = true
}