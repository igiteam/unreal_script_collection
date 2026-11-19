/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_RunAway_Flee extends NanoAIAction_RunAwayBase within NanoAI_Trooper;


static static function int InternalGetUtility( NanoAIBase InAI )
{
	return 0;  // we never flee atm
}



defaultproperties
{

}