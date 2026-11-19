/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Trooper_IdleBreak_Spectator extends NSM_Trooper_IdleBreak;

defaultproperties
{
	WaitingToAttackAnimList.Add( "Interact_A" )
	WaitingToAttackAnimList.Add( "Nod" )
	//WaitingToAttackAnimList.Add( "Orbitals_Swarm" )
	WaitingToAttackAnimList.Add( "Shake_Fist" )
	WaitingToAttackAnimList.Add( "Wave" )
	// adding in list more than once to increase chance of playing
	WaitingToAttackAnimList.Add( "Baton_Idle_Ready_B" )
	WaitingToAttackAnimList.Add( "Baton_Idle_Ready_B" )

	WaitingToAttackAnimList.Add( "Shake_Fist" )
	WaitingToAttackAnimList.Add( "Baton_Taunt" )
}
