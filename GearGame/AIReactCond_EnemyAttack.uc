/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Enemy Attack Reaction - listens for attack warnings from Corpser, Berserker, etc **/
class AIReactCond_EnemyAttack extends AIReactCondition_Base;

event bool ShouldActivate( Actor DmgInst, AIReactChannel OrigChan )
{
	if(!Super.ShouldActivate(DmgInst,OrigChan))
	{
		return FALSE;
	}

	if( MyGearPawn == None ||
		MyGearPawn.IsDoingASpecialMove() ||
		MyGearPawn.Health <= 0 ||
		MyGearPawn.IsDBNO() ||
		IsFriendlyPawn(DmgInst.Instigator) ||
		!bAllowCombatTransitions ||
		Pawn(MyGearPawn.Base) != None )
	{
		return FALSE;
	}

	return TRUE;
}

event Activate(Actor EventInstigator, AIReactChannel OriginatingChannel)
{
	local float DistSq;
	local vector WarnAttackLocation;
	local Pawn Attacker;
	local Interface_AIAttackWarning AttackerInterface;

	Super.Activate(EventInstigator, OriginatingChannel);

	Attacker = Pawn(EventInstigator);
	AttackerInterface = Interface_AIAttackWarning(EventInstigator);
	if( AttackerInterface != None )
	{
		WarnAttackLocation = AttackerInterface.GetWarnAttackLocation();
		DistSq = VSizeSq2D(MyGearPawn.Location - WarnAttackLocation);
		if( DistSq < 512.f*512.f &&
			(FastTrace(MyGearPawn.Location, WarnAttackLocation) || 
    		 FastTrace(MyGearPawn.Location - vect(0,0,1) * MyGearPawn.GetCollisionHeight(), WarnAttackLocation)) )
		{
			EvadeAwayFromPoint( WarnAttackLocation, Attacker, AttackerInterface.GetEnemyEvadeDir() );
		}
	}
}


defaultproperties
{
	AutoSubscribeChannels(0)=WarnEnemyAttack
}
