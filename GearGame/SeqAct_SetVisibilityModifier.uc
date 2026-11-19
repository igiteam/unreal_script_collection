/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetVisibilityModifier extends SequenceAction;

var() float NewVisibilityModifier;

event Activated()
{
	local GearMapSpecificInfo MapInfo;

	MapInfo = GearMapSpecificInfo(GetWorldInfo().GetMapInfo());
	if (MapInfo == None)
	{
		ScriptLog("SetVisibilityModifier: Missing GearMapSpecificInfo!");
	}
	else
	{
		MapInfo.VisibilityModifier = NewVisibilityModifier;
	}
}

defaultproperties
{
	NewVisibilityModifier=1.0
	ObjName="Set Visibility Modifier"
	ObjCategory="AI"
	VariableLinks.Empty()
	VariableLinks[0]=(ExpectedType=class'SeqVar_Float',LinkDesc="Visibility Modifier",PropertyName=NewVisibilityModifier)
}
