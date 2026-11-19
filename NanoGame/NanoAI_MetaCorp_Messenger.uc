/**
 * NanoAI_MetaCorp_Messenger
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAI_MetaCorp_Messenger extends NanoAI;


var float AlertToIdleTime, ScaredToAlertTime;
var StimulusQuery VisibleArmedEnemyQuery, HeardArmedEnemyQuery, ReceivedDamageQuery;

delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease );
delegate AlertToScaredQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease );



state Idle
{
	function BeginState(Name PrevStateName)
	{
		SetMood(AIMood_Unaware);
		AddQuery(VisibleArmedEnemyQuery);
		AddQuery(HeardArmedEnemyQuery);
		AddQuery(ReceivedDamageQuery);
	}

	function EndState(Name NextStateName)
	{
		RemoveQuery(VisibleArmedEnemyQuery);
		RemoveQuery(HeardArmedEnemyQuery);
		RemoveQuery(ReceivedDamageQuery);
	}

	function ReturnToIdle()
	{
		`AILog(`location);
		SetMood(AIMood_Unaware);
	}

	function ReturnToAlert()
	{
		`AILog(`location);
		SetMood(AIMood_Alert);
		SetTimer(AlertToIdleTime,FALSE,nameof(ReturnToIdle));
	}

	delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
	{
		`AILog(`location);
		if (CurrentAIMood < AIMood_Alert)
		{
			SetMood(AIMood_Alert);
		}
		SetTimer(AlertToIdleTime,FALSE,nameof(ReturnToIdle));
	}

	delegate AlertToScaredQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
	{
		`AILog(`location);
		if (CurrentAIMood < AIMood_Scared)
		{
			SetMood(AIMood_Scared);
			ClearTimer(nameof(ReturnToIdle));
		}
		SetTimer(ScaredToAlertTime,FALSE,nameof(ReturnToAlert));
	}
}

defaultproperties
{
	VisibleArmedEnemyQuery=(QueryLabel="Visible and armed",Visibility=QO_Require,bAllowNonFriendly=TRUE,MinFOV=0.2,MaxFOV=-1.f,MaxDist=2048,DistanceAboveUsToIgnoreStimuli=1024.0f,bRequireCombative=QO_Require,StimulusPassed=NanoAI_AssassinationTarget.IdleQueryTripped)
	HeardArmedEnemyQuery=(QueryLabel="Heard armed",bAllowNonFriendly=TRUE,MinFOV=-1.f,MaxFOV=-1.f,MaxDist=1024,bRequireCombative=QO_Require,StimulusPassed=NanoAI_AssassinationTarget.IdleQueryTripped);
	ReceivedDamageQuery=(QueryLabel="Received damage",bAllowNonFriendly=TRUE,MinFOV=-1.f,MaxFOV=-1.f,MaxDist=-1.f,bRequireDamaged=TRUE,StimulusPassed=NanoAI_AssassinationTarget.AlertToScaredQueryTripped);

	AlertToIdleTime=3.f
	ScaredToAlertTime=3.f


	ListOfAIActionsThisAICanDo.Empty()
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_MetaCorp_Messenger' )
}


