/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 *
 */
class TMDmgType_RanOver extends TMDamageType
	abstract;

var int NumMessages;

static function int IncrementKills(TMPlayerReplicationInfo KillerPRI)
{
	local int KillCount;

	KillCount = super.IncrementKills(KillerPRI);
	if ( (KillCount != Default.RewardCount)  && (TMPlayerController(KillerPRI.Owner) != None) )
	{
		SmallReward(TMPlayerController(KillerPRI.Owner), KillCount);
	}
	return KillCount;
}

static function SmallReward(TMPlayerController Killer, int KillCount)
{
	Killer.ReceiveLocalizedMessage(class'TMVehicleKillMessage', KillCount % 4);
}

static function SpawnHitEffect(Pawn P, float Damage, vector Momentum, name BoneName, vector HitLocation)
{
	Super.SpawnHitEffect(P,Damage,Momentum,BoneName,HitLocation);
	if(TMPawn(P) != none)
	{
		TMPawn(P).SoundGroupClass.Static.PlayCrushedSound(P);
	}
}

