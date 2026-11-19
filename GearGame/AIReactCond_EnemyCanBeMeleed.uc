/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** will trigger when an AI is able to be meleed **/
class AIReactCond_EnemyCanBeMeleed extends AIReactCond_Conduit_Base;

// used for considering whether a guy can see us or not
var() float VisibleDotThresh;

/** maximum chance to melee charge (scaled based on range to target) */
var() float ChanceToMeleeMax;
/** min chance to melee charge (scaled based on range to target) */
var() float ChanceToMeleeMin;
/** exponent to use for range chance scaling */
var() float RangeScaleExponent;
/** coefficient to use for range chance scaling */
var() float RangeScaleCoefficient;

/** @return whether we should charge to an enemy outside normal melee range but inside melee range, based on distance
 * whether the enemy is looking at us, etc
 */
function bool ShouldMeleeCharge(Actor EventInstigator, float RangeToEnemy)
{
	local GearPawn GP;
	local vector EnemyLookDir, DirToEnemy;
	local float PctRangeVal, Chance;

	GP = GearPawn(EventInstigator);

	// if we have a combat zone assigned make sure the enemy is within our combat zone before charging
	if(!IsEnemyWithinCombatZone(EventInstigator))
	{
		return false;
	}


	// don't melee charge an enemy who's right next to one of his buddies
	if( IsEnemyNearSquadMate(GP) )
	{
		//MessagePlayer("near team mate, don't do it");
		return false;
	}

	// otherwise, scale our chance value by range to enemy, and roll the dice
	// most likely in the middle of the range, least likely when too close (enemy can't react, bad for SP) or when too far (dumb tactic)
	PctRangeVal = Abs(Sin(Pi * FClamp(RangeToEnemy / EnemyDistance_MeleeCharge, 0.0, 1.0)));
	PctRangeVal = FClamp((RangeScaleCoefficient * PctRangeVal ** RangeScaleExponent), 0.f, 1.0f);
	Chance = ChanceToMeleeMin + (ChanceToMeleeMax - ChanceToMeleeMin) * PctRangeVal;
	if (FRand() < Chance)
	{
		// if the enemy is a player, make sure he can see us before charging him
		if(GP != none && GP.IsHumanControlled())
		{
			EnemyLookDir = vector(GP.GetBaseAimRotation());
			DirToEnemy = Normal(MyGearPawn.Location - GP.Location);
			if (EnemyLookDir dot DirToEnemy < VisibleDotThresh)
			{
				//MessagePlayer("Player can't see me");
				return false;
			}

		}

		//MessagePlayer("ACTIVATING!");
		return true;
	}

	return false;
}

function bool IsEnemyNearSquadmate(Gearpawn GP)
{
	local GearAI GAI;
	local GearPC GPC;
	local Controller C;
	local GearSquad HisSquad;

	GAI = GearAI(GP.Controller);
	if (GAI == None)
	{
		GPC = GearPC(GP.Controller);
		if (GPC != None)
		{
			HisSquad = GPC.Squad;
		}
	}
	else
	{
		HisSquad = GAI.Squad;
	}

	if (HisSquad != None)
	{
		foreach HisSquad.AllMembers(class'Controller',C)
		{
			if ( C != None && C.Pawn != None && C.Pawn != GP &&
				VSizeSq(C.Pawn.Location - GP.Location) < EnemyDistance_MeleeCharge * EnemyDistance_MeleeCharge )
			{
				return true;
			}
		}
	}

	return false;

}

event bool ShouldActivate( Actor EventInstigator, AIReactChannel OrigChan )
{
	local float RangeToEnemy;

	if( !Super.ShouldActivate(EventInstigator,OrigChan) )
	{
		return false;
	}

	RangeToEnemy = VSize(EventInstigator.Location - MyGearPawn.Location);
	//MessagePlayer(GetFuncName()@`showvar(EventInstigator)@`showvar(OrigChan.ChannelName)@`showvar(RangeToEnemy)@`showvar(EnemyDistance_Melee)@`showvar(EnemyDistance_MeleeCharge));

	// if we're within the inner radius, then go!
	if (RangeToEnemy < EnemyDistance_Melee)
	{
		return true;
	}
	else if (EnemyDistance_MeleeCharge < 1.0f || !AllowedToMove()) // if we aren't the charging type, then stop here
	{
		return false;
	}

	return ShouldMeleeCharge(EventInstigator, RangeToEnemy);
}

defaultproperties
{
	RangeScaleExponent=0.4f
	RangeScaleCoefficient=1.0f
	ChanceToMeleeMax=0.65f
	ChanceToMeleeMin=0.01f // make sure there is always SOME chance it will trigger
	VisibleDotThresh=0.707f // 45 degree arc on either side of the dir, making 90 degree viewable arc
	MinTimeBetweenActivations=-1
	AutoSubscribeChannels(0)=EnemyWithinMeleeDistance
	OutputChannelName=EnemyCanBeMeleed

}
