/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Aggregates data from a game session stored on disk
 */
class GearGameStatsAggregator extends GameStatsAggregator
	native(GameStats)
	config(GearGame);

`include(GearGame\GearStats.uci)

/** Used so that game specific ones can start here */
//const GAMEEVENT_AGGREGATED_GAME_SPECIFIC = 11000; //from GameStatsAggregator

//////////////////////////////////////////////////////////////////////////
// Player Top Level Stats
const GAMEEVENT_AGGREGATED_PLAYER_SCORE						= 11000;
const GAMEEVENT_AGGREGATED_PLAYER_AWARD_GIVEN				= 11001;
const GAMEEVENT_AGGREGATED_PLAYER_AMMO_PICKUP				= 11002;
const GAMEEVENT_AGGREGATED_PLAYER_SHIELD_PICKUP				= 11003;
const GAMEEVENT_AGGREGATED_PLAYER_KNOCKDOWNS				= 11004;
const GAMEEVENT_AGGREGATED_PLAYER_CRINGE					= 11005;
const GAMEEVENT_AGGREGATED_PLAYER_ASSIST					= 11006;
const GAMEEVENT_AGGREGATED_PLAYER_DBNO						= 11007;
const GAMEEVENT_AGGREGATED_PLAYER_WASDBNO					= 11008;
const GAMEEVENT_AGGREGATED_PLAYER_REVIVES					= 11009;
const GAMEEVENT_AGGREGATED_PLAYER_WASREVIVED				= 11010;
const GAMEEVENT_AGGREGATED_PLAYER_EXECUTION					= 11011;
const GAMEEVENT_AGGREGATED_PLAYER_WASEXECUTED				= 11012;
const GAMEEVENT_AGGREGATED_PLAYER_TEAMKILLED				= 11013;
const GAMEEVENT_AGGREGATED_PLAYER_WASTEAMKILLED				= 11014;
const GAMEEVENT_AGGREGATED_PLAYER_GIBS						= 11015;
const GAMEEVENT_AGGREGATED_PLAYER_WASGIBBED					= 11016;
const GAMEEVENT_AGGREGATED_PLAYER_HEADSHOT					= 11017;
const GAMEEVENT_AGGREGATED_PLAYER_WASHEADSHOT				= 11018;
const GAMEEVENT_AGGREGATED_PLAYER_BLEDOUT					= 11019;
const GAMEEVENT_AGGREGATED_PLAYER_WASBLEDOUT				= 11020;
const GAMEEVENT_AGGREGATED_PLAYER_SUICIDE					= 11021;
const GAMEEVENT_AGGREGATED_PLAYER_GRENADETAGS				= 11022;
const GAMEEVENT_AGGREGATED_PLAYER_WASGRENADETAGGED			= 11023;
const GAMEEVENT_AGGREGATED_PLAYER_GRENADEMINESPLANTED		= 11024;
const GAMEEVENT_AGGREGATED_PLAYER_GRENADEMINESTRIPPED		= 11025;
const GAMEEVENT_AGGREGATED_PLAYER_GRENADEMINESTRIPPEDBYME   = 11026;
const GAMEEVENT_AGGREGATED_PLAYER_MARTYR					= 11027;
const GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWKILLS				= 11028;
const GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDEATHS			= 11029;
const GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSWON			= 11030;
const GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSLOST			= 11031;
const GAMEEVENT_AGGREGATED_PLAYER_MELEEKILLS				= 11032;
const GAMEEVENT_AGGREGATED_PLAYER_MELEEDEATHS				= 11033;
const GAMEEVENT_AGGREGATED_PLAYER_MELEEKNOCKDOWNS			= 11034;
const GAMEEVENT_AGGREGATED_PLAYER_WASMELEEKNOCKEDDOWN		= 11035;
const GAMEEVENT_AGGREGATED_PLAYER_MELEEHITS					= 11036;
const GAMEEVENT_AGGREGATED_PLAYER_WASMELEEHIT				= 11037;
const GAMEEVENT_AGGREGATED_PLAYER_ROADIERUNTIME				= 11038;
const GAMEEVENT_AGGREGATED_PLAYER_TIMEINCOVER				= 11039;
const GAMEEVENT_AGGREGATED_PLAYER_HOSTAGE_TAKEN				= 11040;
const GAMEEVENT_AGGREGATED_PLAYER_TAKEN_HOSTAGE				= 11041;
const GAMEEVENT_AGGREGATED_PLAYER_KILLSTREAK				= 11042;
const GAMEEVENT_AGGREGATED_PLAYER_BAGTAG					= 11043;
const GAMEEVENT_AGGREGATED_PLAYER_WASBAGTAG					= 11044;
const GAMEEVENT_AGGREGATED_PLAYER_SPOTTEDENEMY				= 11045;
const GAMEEVENT_AGGREGATED_PLAYER_WASSPOTTED				= 11046;
const GAMEEVENT_AGGREGATED_PLAYER_GIVEMONEY			    	= 11047;
const GAMEEVENT_AGGREGATED_PLAYER_GETMONEY				    = 11048;
const GAMEEVENT_AGGREGATED_PLAYER_GIVEAMMO			    	= 11049;
const GAMEEVENT_AGGREGATED_PLAYER_GETAMMO		    		= 11050;
const GAMEEVENT_AGGREGATED_PLAYER_WEAPONTRADER				= 11051;
const GAMEEVENT_AGGREGATED_PLAYER_WEAPONRECEIVER			= 11052;


/** XP Tracking */
const GAMEEVENT_AGGREGATED_PLAYER_XP_KILLS					= 11080;
const GAMEEVENT_AGGREGATED_PLAYER_XP_REVIVES				= 11081;
const GAMEEVENT_AGGREGATED_PLAYER_XP_OBJ					= 11082;
const GAMEEVENT_AGGREGATED_PLAYER_XP_EXECUTIONS				= 11083;
const GAMEEVENT_AGGREGATED_PLAYER_XP_RIBBONS				= 11084;
const GAMEEVENT_AGGREGATED_PLAYER_XP_WINBONUS				= 11085;
const GAMEEVENT_AGGREGATED_PLAYER_XP_PARTICIPATION			= 11086;
const GAMEEVENT_AGGREGATED_PLAYER_XP_PENALTIES				= 11087;


/** Team aggregates */

/** Damage class aggregates */
const GAMEEVENT_AGGREGATED_DAMAGE_DEALT_WEAPON_DBNO			= 11200;
const GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_WEAPON_DBNO		= 11201;

/** Weapon class aggregates */
const GAMEEVENT_AGGREGATED_WEAPON_SUPER_RELOAD				= 11300;
const GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SUCCESS			= 11301;
const GAMEEVENT_AGGREGATED_WEAPON_RELOAD_FAILURE			= 11302;
const GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SKIPPED			= 11303;
const GAMEEVENT_AGGREGATED_WEAPON_PICKUP					= 11304;

/** Pawn class aggregates */

/** Projectile class aggregates */
const GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAG				= 11500;
const GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAGGED			= 11501;
const GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_PLANTED		= 11502;
const GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED		= 11503;
const GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED_BYME	= 11504;


/** Reference to state object as the stream is parsed */
var GearGameStateObject GearGameState;

/** Container for all Gears sound events (GUDS/Efforts) */
struct native SoundEvents
{
	var GameEvents SoundsTotals;
	var array<GameEvents> AllGUDSEvents;
	var array<GameEvents> AllGUDSActionsBySoundCue;
	var array<GameEvents> AllEffortsPlayedBySoundCue;

	structcpptext
	{
		FSoundEvents()
		{}
		
		/* 
		 *   Accumulate a GUDS event's data
		 * @param EventID - the event to record
		 * @param GameEventData - the events data
		 * @param TimePeriod - a given time period (0 - game total, 1+ round total) 
		 */
		void AddGUDEvent(INT EventID, struct FGudsEvent* GameEventData, INT TimePeriod);
		/* 
		 *   Accumulate a GUDS action event's data
		 * @param EventID - the event to record
		 * @param GameEventData - the events data
		 * @param TimePeriod - a given time period (0 - game total, 1+ round total) 
		 */
		void AddGUDAction(INT EventID, struct FGudsAction* GameEventData, INT TimePeriod);
		/* 
		 *   Accumulate a sound effort event's data
		 * @param EventID - the event to record
		 * @param GameEventData - the events data
		 * @param TimePeriod - a given time period (0 - game total, 1+ round total) 
		 */
		void AddSoundEffort(INT EventID, struct FGudsEffort* GameEventData, INT TimePeriod);
	}
};

/** Aggregates of all recorded sound events */
var SoundEvents AllSoundEvents;

cpptext
{
	/** 
	 * The function that does the actual handling of data
	 * Makes sure that the game state object gets a chance to handle data before the aggregator does
	 * @param GameEvent - header of the current game event from disk
	 * @param GameEventData - payload immediately following the header
	 */
	virtual void HandleEvent(struct FGameEventHeader& GameEvent, class IGameEvent* GameEventData);

	/*
	 *   Set the game state this aggregator will use
	 * @param InGameState - game state object to use
	 */
	virtual void SetGameState(class UGameStateObject* InGameState);

	/*
	 *   GameStatsFileReader Interface (handles parsing of the data stream)
	 */
	virtual void HandleGameIntEvent(struct FGameEventHeader& GameEvent, FGameIntEvent* GameEventData);

	virtual void HandlePlayerIntEvent(struct FGameEventHeader& GameEvent, struct FPlayerIntEvent* GameEventData);

	virtual void HandleGudsEvent(struct FGameEventHeader& GameEvent, struct FGudsEvent* GameEventData);
	virtual void HandleGudsAction(struct FGameEventHeader& GameEvent, struct FGudsAction* GameEventData);
	virtual void HandleGudsEffort(struct FGameEventHeader& GameEvent, struct FGudsEffort* GameEventData);

	/** 
	 * Cleanup for a given player at the end of a round
	 * @param PlayerIndex - player to cleanup/record stats for
	 */
	void AddPlayerEndOfRoundStats(INT PlayerIndex);
}

/** A chance to do something before the stream starts */
native event PreProcessStream();

defaultproperties
{
	// Aggregate description metadata
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_SCORE,EventName="Score",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_KILLSTREAK,EventName="Kill Streak",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_AWARD_GIVEN,EventName="Awards",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_AMMO_PICKUP,EventName="Ammo Crate Pickups",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_SHIELD_PICKUP,EventName="Shield Pickups",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_KNOCKDOWNS,EventName="Knockdowns",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_CRINGE,EventName="Cringes",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_ASSIST,EventName="Assists",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_DBNO,EventName="DBNO Player",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASDBNO,EventName="Was DBNO'd",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_REVIVES,EventName="Revives",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASREVIVED,EventName="Was Revived",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))		
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_EXECUTION,EventName="Executions",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASEXECUTED,EventName="Was Executed",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))		
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_TEAMKILLED,EventName="Team Kills",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASTEAMKILLED,EventName="Was Team Killed",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_GIBS,EventName="Gibs",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASGIBBED,EventName="Was Gibbed",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_HEADSHOT,EventName="Headshots",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASHEADSHOT,EventName="Was Headshot",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_BLEDOUT,EventName="Bled Out",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASBLEDOUT,EventName="Was Bled Out",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_SUICIDE,EventName="Suicide",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_MARTYR,EventName="Grenade Martyrs",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWKILLS,EventName="Chainsaw Kills",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDEATHS,EventName="Chainsaw Deaths",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSWON,EventName="Chainsaw Duels Won",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSLOST,EventName="Chainsaw Duels Lost",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_MELEEKILLS,EventName="Melee Kills",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_MELEEDEATHS,EventName="Melee Deaths",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_MELEEKNOCKDOWNS,EventName="Melee Knockdowns",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASMELEEKNOCKEDDOWN,EventName="Was Melee Knocked Down",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_MELEEHITS,EventName="Melee Hits",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASMELEEHIT,EventName="Was Melee Hit",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_ROADIERUNTIME,EventName="Roadie Run Time",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_TIMEINCOVER,EventName="Time In Cover",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_HOSTAGE_TAKEN,EventName="Hostage Taken",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_TAKEN_HOSTAGE,EventName="Taken Hostage",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_FIRED,EventName="Weapon Fired",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_SUPER_RELOAD,EventName="Reload Super Success",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))			
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SUCCESS,EventName="Reload Success",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_FAILURE,EventName="Reload Failed",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SKIPPED,EventName="Reload Skipped",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_WEAPON_PICKUP,EventName="Weapon Pickup",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_WeaponAggregate))	
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_DAMAGE_DEALT_WEAPON_DBNO,EventName="Weapon DBNO",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_DamageAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_WEAPON_DBNO,EventName="DBNO By Weapon",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_DamageAggregate))		
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAG,EventName="Grenade Tags",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_ProjectileAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAGGED,EventName="Grenade Tagged",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_ProjectileAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_PLANTED,EventName="Mines Planted",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_ProjectileAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED,EventName="Mines Tripped",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_ProjectileAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED_BYME,EventName="Mines I've Tripped",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_ProjectileAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_BAGTAG,EventName="Bag Tags",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASBAGTAG,EventName="Was Bag Tagged",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_SPOTTEDENEMY,EventName="Spotted Enemy",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WASSPOTTED,EventName="Was Spotted",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_GIVEMONEY,EventName="Give Money",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_GETMONEY,EventName="Get Money",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_GIVEAMMO,EventName="Give Ammo",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_GETAMMO,EventName="Get Ammo",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WEAPONTRADER,EventName="Traded Weapon",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_WEAPONRECEIVER,EventName="Received Weapon",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))

	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_KILLS,EventName="Kills XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_REVIVES,EventName="Revives XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_OBJ,EventName="Objective XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_EXECUTIONS,EventName="Executions XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_RIBBONS,EventName="Ribbons XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_WINBONUS,EventName="WinBonus XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_PARTICIPATION,EventName="Participation XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
	AggregateEvents.Add((EventID=GAMEEVENT_AGGREGATED_PLAYER_XP_PENALTIES,EventName="Penalty XP",StatGroup=(Group=GSG_Aggregate,Level=1),EventDataType=`GET_PlayerAggregate))
														  
	// Mapping from stream stat ID to aggregate stat ID
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_EXECUTION,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_EXECUTION,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASEXECUTED))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_HEADSHOT,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_HEADSHOT,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASHEADSHOT))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_GIB,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_GIBS,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASGIBBED))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_BLEDOUT,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_BLEDOUT,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASBLEDOUT))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_TEAMKILL,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_TEAMKILLED,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASTEAMKILLED))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_SUICIDE,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_SUICIDE,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_SUICIDE))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_GRENADE_MARTYR,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_MARTYR))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_SCORE_UPDATE,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_SCORE))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KILL_STREAK,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_KILLSTREAK))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_AWARD_GIVEN,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_AWARD_GIVEN))				
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_AMMOCRATE_PICKUP,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_AMMO_PICKUP))				
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_SHIELD_PICKUP,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_SHIELD_PICKUP))				
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_KNOCKDOWN,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_KNOCKDOWNS))				
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_CRINGE,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_CRINGE))					
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_ASSIST,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_ASSIST))					
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_DBNO,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_DBNO,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASDBNO))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_REVIVED,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_REVIVES,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASREVIVED))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_CHAINSAW_DUEL_WON,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSWON))			
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_CHAINSAW_DUEL_LOST,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_CHAINSAWDUELSLOST))				
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_HOSTAGE_TAKEN,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_HOSTAGE_TAKEN,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_TAKEN_HOSTAGE))
	AggregatesList.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SUPER_SUCCESS,AggregateID=GAMEEVENT_AGGREGATED_WEAPON_SUPER_RELOAD))				
	AggregatesList.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SUCCESS,AggregateID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SUCCESS))			
	AggregatesList.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_FAILED,AggregateID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_FAILURE))			
	AggregatesList.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SKIPPED,AggregateID=GAMEEVENT_AGGREGATED_WEAPON_RELOAD_SKIPPED))			
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_PICKUP,AggregateID=GAMEEVENT_AGGREGATED_WEAPON_PICKUP))								
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_DBNO,AggregateID=GAMEEVENT_AGGREGATED_DAMAGE_DEALT_WEAPON_DBNO,TargetAggregateID=GAMEEVENT_AGGREGATED_DAMAGE_RECEIVED_WEAPON_DBNO))	
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_GRENADE_TAG,AggregateID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAG))
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_GRENADE_TAGGED,AggregateID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_TAGGED))			
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_PLANTED,AggregateID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_PLANTED))	
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_TRIPPED,AggregateID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED))	
	AggregatesList.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_TRIPPEDBYME,AggregateID=GAMEEVENT_AGGREGATED_PROJECTILE_GRENADE_MINE_TRIPPED_BYME))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_BAGTAG,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_BAGTAG,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASBAGTAG))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_SPOTTEDENEMY,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_SPOTTEDENEMY,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WASSPOTTED))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_GIVEMONEY,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_GIVEMONEY,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_GETMONEY))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_GIVEAMMO,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_GIVEAMMO,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_GETAMMO))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_TRADEWEAPONS,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_WEAPONTRADER,TargetAggregateID=GAMEEVENT_AGGREGATED_PLAYER_WEAPONRECEIVER))

	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_KILLS,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_KILLS))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_REVIVES,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_REVIVES))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_OBJ,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_OBJ))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_EXECUTIONS,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_EXECUTIONS))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_RIBBONS,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_RIBBONS))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_WINBONUS,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_WINBONUS))	
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_PARTICIPATION,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_PARTICIPATION))
	AggregatesList.Add((EventID=GAMEEVENT_PLAYER_XP_PENALTIES,AggregateID=GAMEEVENT_AGGREGATED_PLAYER_XP_PENALTIES))	
	
		
}