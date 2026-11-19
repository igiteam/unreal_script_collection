/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTShouldAttackOnProximityTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.EnemyPawn.Modifiers.bAttackOnProximity;
}

defaultproperties
{
}