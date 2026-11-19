/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_Counter_Victim extends NSM_PlaySingleAnim_Base;



function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.TakeDamage( 1000, None, vect(0,0,0), vect(0,0,0), class'NDT_Melee' );
}



defaultproperties
{
	AnimName="Orbitals_Swarm"

	BlendInTime=0.1f
	BlendOutTime=0.1f

	bDisableMovement=TRUE
	bDisableAllBoids=TRUE
}