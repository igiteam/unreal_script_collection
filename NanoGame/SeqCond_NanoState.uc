/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqCond_NanoState extends SequenceCondition
	native;

cpptext
{
	virtual void Activated()
	{
		eventActivated();
	}
}

var() Actor Target;

event Activated()
{
	local NanoInterface_PowerAffect NPAI;
	NPAI = NanoInterface_PowerAffect(Target);
	if (NPAI == None && Controller(Target) != None)
	{
		NPAI = NanoInterface_PowerAffect(Controller(Target).Pawn);
	}
	if (NPAI != None)
	{
		if (NPAI.IsDusted())
		{
			ActivateOutputLink(1);
		}
		else if (NPAI.IsDensed())
		{
			ActivateOutputLink(2);
		}
		else
		{
			ActivateOutputLink(0);
		}
	}
}

defaultproperties
{
	ObjName="Nano State"
	ObjCategory="Nano"

	VariableLinks(0)=(LinkDesc="Target",ExpectedType=class'SeqVar_Object',PropertyName=Target)

	OutputLinks(0)=(LinkDesc="Normal")
	OutputLinks(1)=(LinkDesc="Dusted")
	OutputLinks(2)=(LinkDesc="Densed")

	bAutoActivateOutputLinks=FALSE
}
