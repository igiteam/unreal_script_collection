/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_PatDownEnemy extends NSM_DBNO_InteractionEnemyBase
	config(Pawn);



defaultproperties
{
	bShouldHolsterCurrentWeapon=TRUE

	FollowerSpecialMoveName="NSM_DBNO_PatDownVictim"

	AttackerGrabSuccessStartAnim="CTRL_Pat_Down"
	AttackerGrabSuccessLoopAnim=""
	AttackerGrabReleaseAnim=""
	AttackerGrabEscapeAnim=""

	SeqEvtClassToFire_OnEnd=class'SeqEvt_NanoPawn_DBNO_PattedDown'
}
