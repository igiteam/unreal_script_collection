/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_StopAndPlayAnAnimationLooping extends NSM_Trooper_IdleBreak;


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	CachedSlot.StopCustomAnim( 0.3f );

	Super.SpecialMoveEnded( PrevMove, NextMove );
}



defaultproperties
{
	// to use this you will want to set OverrideAnimNameToPlay and then DoSpecialMove( 'NSM_StopAndPlayAnAnimation' );
	bLooping=TRUE
}


