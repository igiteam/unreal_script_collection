/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_SmashDownRabbleRousers extends NanoAIAction_EngageThreat_Trooper within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	return default.UtilityStartVal;
}




function MoveOut()
{

//	class'NanoAICmd_BattlionMove'.static.BattlionMoveOut( TroopLeader, MissionLocation, TrooperSpawnLoc, TargetsToApprehend, RewardToGive );

	class'NanoAICmd_BattlionMove'.static.BattlionMoveOut( Outer, MissionPart.MissionLocation, Pawn.Location, MissionPart.Mission.Spawned_Rebels, Spawn( MissionPart.Mission.RewardType ) );
}


state SmashDownRabbleRousers
{


Begin:
	MoveOut();
}


defaultproperties
{
	StartingStateName="SmashDownRabbleRousers"
}