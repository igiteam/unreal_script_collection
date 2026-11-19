/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreatBase extends NanoAIAction within NanoAI
	abstract;


function Pushed()
{ 
	Super.Pushed();

	SetMood(AIMood_Alert);
}



// this is our close function
// we want to push this into 
state Combat `DEBUGSTATE
{
	function BeginState( name PreviousState )
	{
		Super.BeginState( PreviousState );
	}

	function int PrioritizeStimulus( Actor StimulusActor, vector StimulusLocation, bool bVisible, bool bIsFriendly, bool bCombative )
	{
		if (!bVisible)
		{
			return 0;
		}
		else
		{
			return Outer.PrioritizeStimulus(Stimulusactor,StimulusLocation,bVisible,bIsFriendly, bCombative );
		}
	}

	function bool IsPointWithinRange(vector Pt)
	{
		return VSize(Pt - Pawn.Location) < 512.f;
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" );
	PickNewAction();
	Sleep(5.f);
	Goto('Begin');

MoveToFireTarget:
	class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor(Outer,FireTarget,FALSE,10.f);

	Goto('Begin');
}




defaultproperties
{
	UtilityStartVal=290
	UtilityEndVal=400

}