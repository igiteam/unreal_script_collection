/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_PatDownVictim extends NSM_DBNO_InteractionVictimBase;


/** This is the reward that we give out for this patdown (NOTE: should move to pawn) **/
var RewardDatum Reward;

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	NanoGRI(MyNP.WorldInfo.GRI).GiveReward( Reward, MyNP.InteractionPawn );

	MyNP.PendingSpecialMoveStruct = MyNP.FillSpecialMoveStructFromParams( 'NSM_DBNO' );

	// kill off for now
	NanoPawn_Infantry(MyNP).DBNO_DurationTilBleedOutDeath = 0.001f;
}


defaultproperties
{
	VictimGrabSuccessStartAnim="DBNO_Pat_Down"
	VictimGrabSuccessLoopAnim=""
	VictimGrabReleaseAnim=""
	VictimGrabEscapeAnim=""

	Reward=(CurrencyGained=500,NanoPowerBucketsGained=0,RebelMindShareGained=0,XPGained=0,DataPlan=None,bShouldUnlockPlan=FALSE)
}
