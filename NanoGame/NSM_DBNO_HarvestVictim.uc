/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_HarvestVictim extends NSM_DBNO_InteractionVictimBase;


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.Died( MyNP.ControllerWhoPutMeDBNO, class'NDT_Harvested', MyNP.Location );
	NanoGRI(MyNP.WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'Butterfly', MyNP, MyNP.Location, MyNP.MomentumThatPutMeDBNO, TRUE );

	MyNP.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Harvested', MyNP, 0 );

	Super.SpecialMoveEnded( PrevMove, NextMove );
}



defaultproperties
{
	VictimGrabSuccessStartAnim="DBNO_Harvest_Start"
	VictimGrabSuccessLoopAnim="DBNO_Harvest_Loop"
	VictimGrabReleaseAnim="DBNO_Harvest_End"
	VictimGrabEscapeAnim=""

	bShouldKillOnEndOfSpecialMove=TRUE
}
