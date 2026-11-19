/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Defensive_MemberOfAFormation extends NanoAIAction_DefensiveBase within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;


	// if we are the leader of the formation
	if( InAI.FindCommandOfClass( class'NanoAIAction_EngageThreat_FormAPhalanx' ) != None )
	{
		return 0;
	}


	if( NanoAI_Trooper(InAI).bInFormation == TRUE )
	{
		Retval = default.UtilityStartVal + 21345; 
	}

	return Retval;
}



function Pushed()
{ 
	Super.Pushed();
}



function bool IsInFormationPosition()
{
	if( Formation != none )
	{
		return Formation.IsMemberInPosition( Formation.FindMyMemberIdx(Outer) );
	}

	return FALSE;
}




state MemberOfAFormation
{
	


Begin:

	`AILog( GetStateName()@"Begin TAG" );

	if( IsInFormationPosition() == FALSE )
	{
		MoveToFormationPosition();
	}

	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="MemberOfAFormation"
}