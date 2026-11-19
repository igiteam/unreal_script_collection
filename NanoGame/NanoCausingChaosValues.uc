/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoCausingChaosValues extends Object
	abstract
	config(Game);

// make this a struct to have constraints on when this can actually give pts.
// e.g. only tier 3 and below

/**
* We need a struct to wrap our array of values as the ImportText code path is whack.
**/
struct ChaosAmountStruct
{
	var() Array<float> Values;
};



struct NanoCausingChaosValueDatum
{
	/** Struct for holding the amount of chaos that each tier will increase by **/
	var() ChaosAmountStruct ChaosAmount;
	/** If the current chaos tier is less than this value then we immediately jump to this value. **/
	var() int AutoJumpToTier;
	/** Should we NOT reward rebelmindshare (defautl case is to always reward)**/
	var() bool bDoNOTRewardRebelMindShare;
	/** Description for HUD display */
	var() string ChaosDesc;

	/** If this bool is set then the AI will head on home immediately.  They will stop fighting the rebels and just bug out. **/
	var() bool bSendAIHome;

	/** This chaos affecting value will cause all defensive points to not be under attack. **/
	var() bool bSetAllDefensivePointsToNotBeUnderAttack;

	/** When we are not responding to world events, this event will pass through and actually affect chaos **/
	var() bool bSpecialChaosCausingEventOverrideableWorldEventsAffectChaos;

	structdefaultproperties
	{
		AutoJumpToTier=-1
		bDoNOTRewardRebelMindShare=FALSE;
	}
};


var config NanoCausingChaosValueDatum AutoDecreaseAmount;

var config NanoCausingChaosValueDatum InstantDecreaseToTier1;

var config NanoCausingChaosValueDatum InstantDecreaseToTier1NoReward;

var config NanoCausingChaosValueDatum BarricadePassedThrough;

var config NanoCausingChaosValueDatum BreachedSoftContainmentZone;

var config NanoCausingChaosValueDatum BullRamKilled;

var config NanoCausingChaosValueDatum CoolDownVolumeDecreaseAmount;

var config NanoCausingChaosValueDatum NanoDefensivePointUnderAttack;

var config NanoCausingChaosValueDatum Shooting;

var config NanoCausingChaosValueDatum AssassinationTargetDied;

var config NanoCausingChaosValueDatum CrowdCopAttacked;

var config NanoCausingChaosValueDatum DamageInflicted;

var config NanoCausingChaosValueDatum DestroyedFuelTank;

var config NanoCausingChaosValueDatum DragosKilled;

var config NanoCausingChaosValueDatum GenericPawnDeath;

var config NanoCausingChaosValueDatum NoChaosIncrease;

var config NanoCausingChaosValueDatum TattlerBotAquired;

var config NanoCausingChaosValueDatum TattlerBotLost;

var config NanoCausingChaosValueDatum TattlerBotKilled;

var config NanoCausingChaosValueDatum CitizenKilled;

var config NanoCausingChaosValueDatum ScaringCitizen;

var config NanoCausingChaosValueDatum PoliceCarKilled;

var config NanoCausingChaosValueDatum RiotTrooperKilled;

var config NanoCausingChaosValueDatum RiotTrooperCaptainKilled;

var config NanoCausingChaosValueDatum RiotTrooperGrabberKilled;

var config NanoCausingChaosValueDatum RiotTrooperAgentKilled;

var config NanoCausingChaosValueDatum SkywayPatrolEliteKilled;

var config NanoCausingChaosValueDatum PacificationBotKilled;

var config NanoCausingChaosValueDatum MetaCorpExecKilled;

var config NanoCausingChaosValueDatum LowLevelDisturbance;

var config NanoCausingChaosValueDatum BlowUpLowLevelTarget;

var config NanoCausingChaosValueDatum DroppingTheHammer;

var config NanoCausingChaosValueDatum CarNanoStateChanged;

var config NanoCausingChaosValueDatum CarDestroyed;

var config NanoCausingChaosValueDatum KActorBoulderBashed;


defaultproperties
{

}