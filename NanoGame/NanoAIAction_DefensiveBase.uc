/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_DefensiveBase extends NanoAIAction within NanoAI
	abstract;

simulated function Texture2D GetDebugIcon() 
{
	return Texture2D'UI_HUD.AI.T_UI_Debug_Defensive';
}


static function int InternalGetUtility( NanoAIBase InAI )
{
	return 0; //
}



state GuardLocation
{
	function BeginState(Name PrevStateName)
	{
		NanoPawn(Pawn).DestroyCurrentWeapon();
		SetMood(AIMood_DefendingLocation);

		// @todo:  we will want to formalize this so we get `AILogs from it
		// since we are defending something our Confront Query needs to be modified
		Outer.ConfrontPossibleThreatQuery = Outer.default.DefensiveQuery; 

		PassiveQueries.AddItem(DefensiveQuery);
	}

	function EndState(Name NextStateName)
	{
		RemoveQuery(DefensiveQuery);

		// since we are defending something our Confront Query needs to be modified
		Outer.ConfrontPossibleThreatQuery = Outer.default.ConfrontPossibleThreatQuery;

		Super.EndState(NextStateName);
	}

	delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
	{
		if (!bIsScripted)
		{
			//`log( "ZOOP!" @ AIPlansRatingToIncrease.Length );
			//ModifyAIPlansRating( AIPlansRatingToIncrease );
			//TransitionTo('Alert');
		}
		else
		{
			//`log( "getting assfucked by" @ `showvar(bIsScripted) );
		}
	}

}


defaultproperties
{
	UtilityStartVal=90
	UtilityEndVal=200

}