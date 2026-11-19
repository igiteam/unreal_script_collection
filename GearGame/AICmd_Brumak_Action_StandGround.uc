/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class AIcmd_Brumak_Action_StandGround extends AICmd_Base_UtilitySelectedCmd
	within GearAI_Brumak;


/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation( GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData )
{
	local GearAI_Brumak BrumakAI;
	
	BrumakAI = GearAI_Brumak(AI);

	if( !BrumakAI.HasAnyEnemies() || BrumakAI.MoveAction != None )
	{
		`AILog_Ext("Have no enemies, or moveaction is non null("$BrumakAI.MoveAction$")",,AI);
		return 1.f;
	}

	if(BrumakAI.bHijackedByLD)
	{
		return 1.f;
	}

	// this is base behavior
	return 0.f;
}



function Pushed()
{
	Super.Pushed();
	GotoState('DoStandHereAndLookCool');
}


state DoStandHereAndLookCool
{
Begin:
	// If someone is nearby, scream!
	if( FRand() < 0.33f )
	{
		if( `TimeSince(LastRoarTime) > MinTimeBetweenRoars && FRand() < 0.50f)
		{
			DoRoar();
		}
	}
	Sleep(1.f);
	PopCommand(self);
};