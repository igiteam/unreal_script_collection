/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustBoomerGatlingBase extends GearPawn_LocustBoomerBase
	abstract
	config(Pawn);

var				BodyStance		BS_AttackTelegraphAnim;
var repnotify	byte			AttackTelegraphCount;

replication
{
	if( Role == ROLE_Authority )
		AttackTelegraphCount;
}

simulated event ReplicatedEvent(name VarName)
{
	Super.ReplicatedEvent(VarName);

	if( VarName == 'AttackTelegraphCount' )
	{
		TelegraphAttack();
	}
}

simulated function TelegraphAttack()
{
	if (Role == ROLE_Authority)
	{
		// replicate to clients
		AttackTelegraphCount++;

		// the audio replicates on its own as most boomers don't need our special anim replication, so server only
		Super.TelegraphAttack();
	}

	if (FullBodyNode != None && !FullBodyNode.bIsPlayingCustomAnim && !IsReloadingWeapon())
	{
		// Play attack telegraph additive animation.
		BS_Play(BS_AttackTelegraphAnim, 1.f, 0.2f, 0.2f);
	}
}
