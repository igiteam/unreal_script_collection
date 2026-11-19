/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ArcadeScore extends SequenceAction;

/** number of points to award the players */
var() int Score;
/** multiplier change to give the players */
var() float Multiplier;

event Activated()
{
	local GearPC PC;
	local GearPRI_SP PRI;
	local GearGRI_SP_Arcade GRI;
	local int FinalAmount;

	GRI = GearGRI_SP_Arcade(GetWorldInfo().GRI);

	// a little bit of trickiness here so that all players get the same score and the multiplier is only affected once
	FinalAmount = Score * GRI.TeamMultiplier;
	foreach GetWorldInfo().AllControllers(class'GearPC', PC)
	{
		PRI = GearPRI_SP(PC.PlayerReplicationInfo);
		if (PRI != None)
		{
			PRI.Score += FinalAmount;
			PRI.bForceNetUpdate = true;
		}
	}
	GRI.NotifyPointsAwarded(Score);
	// finally apply seperate multiplier boost set by LD
	GRI.ModifyMultiplier(Multiplier);
}

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Award Arcade Score"
	VariableLinks.Empty
	VariableLinks[0]=(ExpectedType=class'SeqVar_Int',LinkDesc="Score",PropertyName=Score,MaxVars=1)
	VariableLinks[1]=(ExpectedType=class'SeqVar_Float',LinkDesc="Multiplier",PropertyName=Multiplier,MaxVars=1)
}
