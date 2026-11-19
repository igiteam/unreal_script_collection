/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIsInMatineeTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.EnemyPawn.bUsedByMatinee;
}

defaultproperties
{
}