
/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/** The class that writes the DM general stats */

class TMLeaderboardWriteDM extends TMLeaderboardWriteBase;





















































































































































































































































































































































































































































































































































































































































































































































































































































#linenumber 10

/** Grouping of stats for the category MULTIKILL */
var array<name> MultiKill;

/** Grouping of stats for the category SPREE */
var array<name> Spree;

/** Class that holds the stats mapping/info for weapons */
var class<TMLeaderboardWriteBase> WeaponsStatsClass;

/** Class that holds the stats mapping/info for vehicles */
var class<TMLeaderboardWriteBase> VehicleStatsClass;

/** Class that holds the stats mapping/info for vehicle weapons */
var class<TMLeaderboardWriteBase> VehicleWeaponsStatsClass;

//Copies all relevant PRI game stats into the Properties struct of the OnlineStatsWrite
//There can be many more stats in the PRI than what is in the Properties table (on Xbox for example)
//If the Properties table does not contain the entry, the data is not written
function CopyAllStats(TMPlayerReplicationInfo PRI)
{
	local IntStat tempIntStat;
	local TimeStat tempTimeStat;
	local int NumKills;

	NumKills = PRI.Kills;
	SetIntStat(0x10000005 ,NumKills);
	// Make sure to create a non-zero rating value
	if (NumKills == 0)
	{
		NumKills = -1;
	}
	SetIntStat(PROPERTY_LEADERBOARDRATING,NumKills);
	SetIntStat(0x10000006 ,PRI.Deaths);

	//Kill stats
	foreach PRI.KillStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Death stats
	foreach PRI.DeathStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Suicide stats
	foreach PRI.SuicideStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Event Stats such as Multikill, Spree, Reward
	foreach PRI.EventStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Number of node events accomplished (capture/destroy/etc)
	foreach PRI.NodeStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Number of things picked up
	foreach PRI.PickupStats(tempIntStat)
	{
		SetIntStatFromMapping(tempIntStat.StatName, tempIntStat.StatValue);
	}

	//Time under a powerup
	foreach PRI.PowerupTimeStats(tempTimeStat)
	{
		SetIntStatFromMapping(tempTimeStat.StatName, int(tempTimeStat.TotalTime));
	}

	Super.CopyAllStats(PRI);
}

//Calls CopyAllStats() on relevant stat tables and then writes the data out to the online interface
function CopyAndWriteAllStats(UniqueNetId UniqId, TMPlayerReplicationInfo PRI, bool bIsPureServer, OnlineStatsInterface StatsInterface)
{
	local TMLeaderboardWriteWeaponsDM WeaponStats;
	local TMLeaderboardWriteVehiclesDM VehicleStats;
	local TMLeaderboardWriteVehicleWeaponsDM VehicleWeaponsStats;
	if (StatsInterface != None)
	{
		//Copy all stats out of the PRI
		//and copy them into the online subsystem where they will be
		//sent via the network in EndOnlineGame()

		SetPureServerMode(bIsPureServer);
		CopyAllStats(PRI);
		StatsInterface.WriteOnlineStats('Game',UniqId, self);

		if (WeaponsStatsClass != none)
		{
			WeaponStats = TMLeaderboardWriteWeaponsDM(new WeaponsStatsClass);
			WeaponStats.SetPureServerMode(bIsPureServer);
			WeaponStats.CopyAllStats(PRI);
			StatsInterface.WriteOnlineStats('Game',UniqId, WeaponStats);
		}

		if (VehicleStatsClass != none)
		{
			VehicleStats = TMLeaderboardWriteVehiclesDM(new VehicleStatsClass);
			VehicleStats.SetPureServerMode(bIsPureServer);
			VehicleStats.CopyAllStats(PRI);
			StatsInterface.WriteOnlineStats('Game',UniqId, VehicleStats);
		}

		if (VehicleWeaponsStatsClass != none)
		{
			VehicleWeaponsStats = TMLeaderboardWriteVehicleWeaponsDM(new VehicleWeaponsStatsClass);
			VehicleWeaponsStats.SetPureServerMode(bIsPureServer);
			VehicleWeaponsStats.CopyAllStats(PRI);
			StatsInterface.WriteOnlineStats('Game',UniqId, VehicleWeaponsStats);
		}
	}
}

