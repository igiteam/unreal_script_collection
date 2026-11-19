/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoGuardPoint extends NanoTargetPoint;

/** This keeps track of the number of AI that we have spawned from this point **/
var transient int NumAIGuardedFromHere;


function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	Super.GetDebugOverheadText( PC, OutText );

	OutText.AddItem( "NumAIGuardedFromHere" @ NumAIGuardedFromHere );
}




defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.ResponseSystem.GuardPoint'
	End Object
}