/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Trooper_Death_WaitingToDie extends NSM_StopAndPlayAnAnimationLooping;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.ZeroMovementVariables();

}

defaultproperties
{
	//WaitingToAttackAnimList.Add( "Orbitals_GetThemOffMe_Loop" )
}
