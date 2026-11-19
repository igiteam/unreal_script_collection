/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_ExecuteEnemy extends NSM_DBNO_InteractionEnemyBase
	config(Pawn);



defaultproperties
{
	FollowerSpecialMoveName="NSM_DBNO_HarvestVictim"

	AttackerGrabSuccessStartAnim="CTRL_Harvest_Start"
	AttackerGrabSuccessLoopAnim="CTRL_Harvest_Loop"
	AttackerGrabReleaseAnim="CTRL_Harvest_End"
	AttackerGrabEscapeAnim="CTRL_Harvest_End"


}
