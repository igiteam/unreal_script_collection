/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_RunAwayBase extends NanoAIAction within NanoAI
	abstract;


simulated function Texture2D GetDebugIcon() 
{
	return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Retreat'; 
}


static function int InternalGetUtility( NanoAIBase InAI )
{
	return 0;  // we never flee atm
}




defaultproperties
{
	UtilityStartVal=390
	UtilityEndVal=500
}