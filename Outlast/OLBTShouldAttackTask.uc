/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTShouldAttackTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.EnemyPawn.Modifiers.bShouldAttack;
}

defaultproperties
{
}