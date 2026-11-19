/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class AIcmd_Brumak_Action_Melee extends AICmd_Base_UtilitySelectedCmd
	within GearAI_Brumak;


/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation( GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData )
{
	local Pawn	NearEnemy;
	local float NearestEnemyDist;
	local GearAI_Brumak BrumakAI;

	BrumakAI = GearAI_Brumak(AI);
	// Find the nearest enemy
	NearestEnemyDist = BrumakAI.GetNearEnemyDistance(BrumakAI.Pawn.Location, NearEnemy);

	// If nearest enemy is melee target...
	if( /*!BrumakAI.Brumak.HasAnyWeaponsAlive() ||*/ NearestEnemyDist <= BrumakAI.EnemyDistance_Melee)
	{
		return 1.1f;
	}


	return -1.f;
}



function Pushed()
{
	local Pawn	NearEnemy;

	Super.Pushed();

	GetNearEnemyDistance(Pawn.Location, NearEnemy);
	SetEnemy(NearEnemy);

	GotoState('DoMelee');

}


state DoMelee
{
Begin:
	class'AICmd_Attack_Brumak_Melee'.static.InitCommand(outer);
	Sleep(1.f);
	PopCommand(self);
};