/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GetNanoSkillLevel extends SequenceAction;

/** Skill we want to chek level of **/
var() class<NanoSkill> Skill;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


defaultproperties
{
	ObjName="Get Nano Skill Level"
	ObjCategory="Nano Skill Resources"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Player",MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="SkillLevel",bWriteable=TRUE)
}