/**
 * Action to reference GFx assets in a level to ensure cooking
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_LoadGFxAssets extends SequenceAction;


var() class<GFxMoviePlayer> MoviePlayerClass;

defaultproperties
{
	ObjName="Load GFx Assets"
	ObjCategory="GFx UI"
	VariableLinks.Empty
}
