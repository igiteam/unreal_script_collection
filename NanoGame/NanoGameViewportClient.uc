/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGameViewportClient extends GameViewportClient
	native;


function DrawTransition(Canvas Canvas)
{
	// if the current transition is loading see if we should make the screen black
	if( Outer.TransitionType != TT_Paused )
	{
		super.DrawTransition(Canvas);	
	}
}
