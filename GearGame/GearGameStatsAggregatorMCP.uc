/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Aggregates data from a game session stored on disk and packages it for MCP
 */
class GearGameStatsAggregatorMCP extends GearGameStatsAggregator
	native(GameStats)
	perobjectconfig
	config(GearGame);

/** EventIDs to display as columns for player stats */
var array<int> PlayerStatsAggregates;
/** EventIDs to display as columns for weapon stats */
var array<int> WeaponStatsAggregates;
/** EventIDs to display as columns for damage stats */
var array<int> DamageStatsAggregates;
/** EventIDs to display as columns for projectile stats */
var array<int> ProjectileStatsAggregates;
/** EventIDs to display as columns for pawn stats */
var array<int> PawnStatsAggregates;

cpptext
{
    /** 
	 * Top Level Function that kicks off the serialization for MCP
	 * @param Ar - archive to write out
	 */
	void WriteToMCPStream(FArchive& Archive);

	/** 
	 * Write the player stats data to MCP 
	 * @param Ar - archive to write out
	 */	
	virtual void WritePlayerValues(FArchive& Ar);

	/** 
	 * Fill out the information for a single player
	 * @param Ar - archive to write out
	 * @param PlayerIndex - player currently being written out
	 */	
	virtual void WritePlayerValue(FArchive& Ar, INT PlayerIndex);

	/*
	 *   Get all the weapon events for a given time period (uses WeaponStatsAggregates)
	 * @param Archive - archive to serialize to
	 * @param PlayerIndex - player we are serializing (-1 for global)
	 * @param TimePeriod - TimePeriod (0 game, 1+ round)
	 * @param WeaponEvents - the aggregate events structure to get the data from
	 * @param StatsReader - the file reader containing the weapon metadata
	 */
	void GetWeaponValuesForTimePeriod(FArchive& Archive, INT PlayerIndex, INT TimePeriod, const FWeaponEvents& WeaponEvents, const UGameplayEventsReader* StatsReader);

	/*
	 *   Get all the damage events for a given time period (uses DamageStatsAggregates)
	 * @param Archive - archive to serialize to
	 * @param PlayerIndex - player we are serializing (-1 for global)
	 * @param TimePeriod - TimePeriod (0 game, 1+ round)
	 * @param DamageEvents - the aggregate events structure to get the data from
	 * @param StatsReader - the file reader containing the weapon metadata
	 */
	void GetDamageValuesForTimePeriod(FArchive& Archive, INT PlayerIndex, INT TimePeriod, const FDamageEvents& DamageEvents, const UGameplayEventsReader* StatsReader);

	/*
	 *   Get all the projectile events for a given time period (uses ProjectileStatsAggregates)
	 * @param Archive - archive to serialize to
	 * @param PlayerIndex - player we are serializing (-1 for global)
	 * @param TimePeriod - TimePeriod (0 game, 1+ round)
	 * @param ProjectileEvents - the aggregate events structure to get the data from
	 * @param StatsReader - the file reader containing the weapon metadata
	 */
	void GetProjectileValuesForTimePeriod(FArchive& Archive, INT PlayerIndex, INT TimePeriod, const FProjectileEvents& ProjectileEvents, const UGameplayEventsReader* StatsReader);
   
	/*
	 *   Get all the pawn events for a given time period (uses PawnStatsAggregates)
	 * @param Archive - archive to serialize to
	 * @param PlayerIndex - player we are serializing (-1 for global)
	 * @param TimePeriod - TimePeriod (0 game, 1+ round)
	 * @param PawnEvents - the aggregate events structure to get the data from
	 * @param StatsReader - the file reader containing the weapon metadata
	 */
	void GetPawnValuesForTimePeriod(FArchive& Archive, INT PlayerIndex, INT TimePeriod, const FPawnEvents& PawnEvents, const UGameplayEventsReader* StatsReader);
}

defaultproperties
{
	// Player stats to upload
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_MATCH_WON)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_ROUND_WON)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_SCORE)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_AWARD_GIVEN)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_KILLS)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_DEATHS)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_SUICIDE)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_NORMALKILL)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_EXECUTION)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_TEAMKILLED)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GIBS)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_HEADSHOT)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_BLEDOUT)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_KILLSTREAK)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASNORMALKILL)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASEXECUTED)	
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASTEAMKILLED)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASGIBBED)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASHEADSHOT)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASBLEDOUT)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_ASSIST)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_HOSTAGE_TAKEN)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_TAKEN_HOSTAGE)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSWON)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSLOST)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_MARTYR)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_TIMEALIVE)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_ROADIERUNTIME)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_TIMEINCOVER)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_AMMO_PICKUP)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_SHIELD_PICKUP)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_DBNO)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASDBNO)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_REVIVES)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASREVIVED)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_KNOCKDOWNS)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_CRINGE)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_BAGTAG)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASBAGTAG)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_SPOTTEDENEMY)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASSPOTTED)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GIVEMONEY)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GETMONEY)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GIVEAMMO)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GETAMMO)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WEAPONTRADER)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WEAPONRECEIVER)

	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_KILLS)			
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_REVIVES)		
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_OBJ)			
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_EXECUTIONS)		
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_RIBBONS)		
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_WINBONUS)		
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_PARTICIPATION)
	PlayerStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_XP_PENALTIES)
	
	// Weapon stats to upload
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_FIRED)
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_SUPER_RELOAD)
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SUCCESS)
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_RELOAD_FAILURE)
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SKIPPED)
	WeaponStatsAggregates.Add(GAMEEVENT_AGGREGATED_WEAPON_PICKUP)

	// Damage stats to upload
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_KILLS)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_DEATHS)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_SUICIDE)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_DEALT_WEAPON_DAMAGE)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_DEALT_MELEE_DAMAGE)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_WEAPON_DAMAGE)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_MELEE_DAMAGE)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_DEALT_WEAPON_DBNO)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_WEAPON_DBNO)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_NORMALKILL)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_EXECUTION)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_BLEDOUT)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_TEAMKILLED)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_GIBS)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_HEADSHOT)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASNORMALKILL)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASEXECUTED)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASBLEDOUT)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASTEAMKILLED)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASGIBBED)
	DamageStatsAggregates.Add(GAMEEVENT_AGGREGATED_PLAYER_WASHEADSHOT)	

	// Projectile stats to upload
	ProjectileStatsAggregates.Add(GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAG)
	ProjectileStatsAggregates.Add(GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAGGED)
	ProjectileStatsAggregates.Add(GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_PLANTED)
	ProjectileStatsAggregates.Add(GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED)
	ProjectileStatsAggregates.Add(GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED_BYME)

	// Pawn stats to upload
	PawnStatsAggregates.Add(GAMEEVENT_AGGREGATED_PAWN_SPAWN)

}