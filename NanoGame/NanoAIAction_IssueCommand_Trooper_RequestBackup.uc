/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_IssueCommand_Trooper_RequestBackup extends NanoAIAction_IssueCommand_Base within NanoAI_Trooper;

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	if( `TimeSinceEx(InAI, InAI.GetBlackBoard().LastRequestedBackupTime) < 200.f )
	{
		return 0;
	}

	if( NanoAI(InAI).ConsidersSelfOutNumbered() )
	{
		Retval = default.UtilityStartVal + 500;
	}
	
	return Retval;
}

function Pushed()
{
	Super.Pushed();

	GetBlackBoard().LastRequestedBackupTime = WorldInfo.TimeSeconds;
}

defaultproperties
{
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_RadioForBackup')
}