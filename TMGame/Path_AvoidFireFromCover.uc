/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class Path_AvoidFireFromCover extends PathConstraint
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var TGAI AI;

struct native EnemyCoverInfo
{
	var TGPawn Enemy;
	var CoverInfo Cover;
};

var array<EnemyCoverInfo> EnemyList;

static function bool AvoidFireFromCover( Pawn P )
{
	local Path_AvoidFireFromCover Con;
	local TGAI TheAI;
	local TGPawn Enemy;
	local EnemyCoverInfo EnemyInfo;

	TheAI = TGAI(P.Controller);
	if (TheAI != None && TheAI.Squad != None)
	{
		Con = Path_AvoidFireFromCover(P.CreatePathConstraint(default.class));
		Con.AI = TheAI;
		foreach TheAI.Squad.AllEnemies(class'TGPawn', Enemy, TheAI)
		{
			if (Enemy.IsPlayerOwned() && TheAI.GetPlayerCover(Enemy, EnemyInfo.Cover, false))
			{
				EnemyInfo.Enemy = Enemy;
				Con.EnemyList.AddItem(EnemyInfo);
			}
		}
		if (Con.EnemyList.length > 0)
		{
			P.AddPathConstraint(Con);
		}
		return TRUE;
	}

	return FALSE;
}

function Recycle()
{
	Super.Recycle();
	AI = None;
	EnemyList.length = 0;
}
