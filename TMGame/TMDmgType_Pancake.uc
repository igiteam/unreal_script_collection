/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMDmgType_Pancake extends TMDmgType_RanOver
	abstract;


static function SmallReward(TMPlayerController Killer, int KillCount)
{
	Killer.ReceiveLocalizedMessage(class'TMVehicleKillMessage', 4);
}

