/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AIReactCond_EnemyCanBeMeleed_Kamikaze extends AIReactCond_EnemyCanBeMeleed;

function bool ShouldMeleeCharge(Actor EventInstigator, float RangeToEnemy)
{
	return IsEnemyWithinCombatZone(EventInstigator);
}
