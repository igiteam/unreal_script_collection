/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction extends NanoAICmd within NanoAI
	abstract;

/**
 * This is interface function that is meant to allow indiv actions to have a tick on the basemost "cmd" (which is an action) in the stack.
 * This will allow us to have the AIAction choose a new AICmd and then AbortComman and then push that new AICmd onto the stack!
 **/
function TickAction( float DeltaTime )
{
	local class<NanoAICmd> CmdToRun;
	local string UtilityString;
	local bool bUpdated;


	// this will now do our logic to determine which AICmd to do:
	CmdToRun = GetBestSubCmd( UtilityString );

	bUpdated = DoCommandIniting( UtilityString, CmdToRun );
	if( !bUpdated && NanoAIAction(ChildCommand) != None )
	{
		NanoAIAction(ChildCommand).TickAction( DeltaTime );
	}
}

function bool DoCommandIniting( out string UtilityString, class<NanoAICmd> CmdToRun )
{
	if( ( ListOfCmdsCanDo.Length > 0 ) && ( CmdToRun == none ) )
	{
		`AILog( "TickAction found no best SubCmd to run!" )
	}

	// so if we are currently not doing the same cmd
	if( CmdToRun != None && 
		(ChildCommand == None || CmdToRun != ChildCommand.Class) )
	{
		`AILog( "TickAction Doing new Action" @ "Previous Action was:" @ ChildCommand );
		`AILog( UtilityString );
		`AILog( "DoTopRatedCmd: " @ CmdToRun );

		if( ChildCommand != None )
		{
			`AILog( GetFuncName() @ "Aborting!" @ `showvar(ChildCommand) );
			AbortCommand( ChildCommand );
		}

		// these are "simple" commands and should not need a huge list of special parameters so we can use the GameAICommand "init" function
		// if we need to start having specialized params we should have  yet another base class!
		CmdToRun.static.InitCommand( Outer );
		return TRUE;
	}

	return FALSE;
}


defaultproperties
{

}