/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_NPCUnarmed extends GearAI_NPC;

/** Distance from the squad leader this AI should stay within */
var() config float TetherToLeaderDist;

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget);

function float GetTetherToLeaderDist()
{
	return TetherToLeaderDist;
}


defaultproperties
{
	DefaultCommand=class'AICmd_Base_NPCUnarmed'
	MeleeCommand=None
}