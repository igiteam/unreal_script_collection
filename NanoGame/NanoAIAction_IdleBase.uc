/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_IdleBase extends NanoAIAction within NanoAI
	abstract;



simulated function Texture2D GetDebugIcon() 
{ 
	return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Idle'; 
}


state Idle
{
	function BeginState(Name PrevStateName)
	{
		DestoryCurrentWeapon();
		SetMood(AIMood_Unaware);
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
	}

// 	delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
// 	{
// 	}
}

function DestoryCurrentWeapon()
{
	NanoPawnBase(Pawn).DestroyCurrentWeapon();
}


defaultproperties
{
	UtilityStartVal=1
	UtilityEndVal=100
}