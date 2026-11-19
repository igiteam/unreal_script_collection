/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyNanoSkill extends SequenceAction;

/** Which skill we want to modify **/
var() class<NanoSkill> NanoSkillToModify;

/** Skill Level to set on the skill**/
var() int SkillLevel;

/** If this is set, the current skill level will be incremented by one. (This is an override and will disregard the SkillLevel value) **/
var() bool bUpgradeCurrentSkill;



defaultproperties
{
	ObjName="Modify Nano Skill"
	ObjCategory="Nano Skill Resources"
}