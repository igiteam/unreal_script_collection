/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearGameplayEventsWriter extends GameplayEventsWriter
	config(Game)
	native;

`define INCLUDE_GEARS_STATS(dummy)
`include(GearGame\GearStats.uci);
`undefine(INCLUDE_GEARS_STATS)

cpptext
{
	/** 
	 * Turns a controller into a player index, possibly adding new information to the player array 
	 * overridden to add Gears specific team names
	 *  @param TeamInfo - TeamInfo class to resolve an index for
	 *	@return Index of the team in the team metadata array
	 */
	virtual INT ResolveTeamIndex(class ATeamInfo *TeamInfo);
};

/** 
 *   Creates the archive that we are going to write to
 * @param Filename - name of the file that will be open for serialization
 * @return TRUE if successful, else FALSE
 */
native function bool OpenStatsFile(string Filename);

/*
 * Get the Id for the gametype the game is using
 * @return Id related to the game specific game type being played
 */
event int GetGameTypeId() 
{ 
	local WorldInfo WI;
	local EGearMPTypes GameType;

	WI = class'WorldInfo'.static.GetWorldInfo();
	if (WI.GRI != None)
	{
		GameType = class'GearUIManager'.static.GetMPGameTypeStatic(GearGRI(WI.GRI));
		return int(GameType);
	}

	return 0;
}

/**
 * Logs a Gears specific player special move event
 *
 * @param EventId the event that should be written
 * @param Player the player that triggered the event
 * @param SpecialMove the move that is being performed
 * @param Target the player that was the recipient
 */
native function LogPlayerSpecialMoveEvent(int EventID, Controller Player, int SpecialMove, Controller Target);

/**
 * Logs a Horde fortification event
 *
 * @param EventId the event that should be written
 * @param Player the player that triggered the event
 * @param EventType the type of event that happened
 * @param Fortification the fortification actor that was interacted with
 */
native function LogFortificationEvent(int EventID, Controller Player, EGearFortificationEventType EventType, Actor Fortification);

/**
 * Logs a GUDS event
 *
 * @param EventId the event that should be written
 * @param ID the GUD that was played
 * @param Instigator the player that triggered the event
 * @param Recipient who the event was intended for
 */
native function LogGudsEvent(int EventID, int ID, Controller Instigator, Controller Recipient);

/**
 * Logs a GUDS effort
 *
 * @param EventId the event that should be written
 * @param Speaker the player that speaks the effort
 * @param Cue the sound cue played
 */
native function LogGudsEffort(int EventID, Controller Speaker, SoundCue Cue);

/**
 * Logs a GUDS effort
 *
 * @param EventId the event that should be written
 * @param Line the sound cue played
 * @param Speaker the player that speaks the line
 * @param Addressee who is being addressed
 * @param ReferringTo who the line is about
 */
native function LogGudsAction(int EventID, SoundCue Line, Controller Speaker, Controller Addressee, Controller ReferringTo);

function RecordAITakeCover(Controller AI, vector CoverLoc)
{
`if(`notdefined(FINAL_RELEASE))
	local GenericParamListStatEntry  PLE;
	
	PLE = GetGenericParamListEntry();
	PLE.AddInt('EventID',`GAMEEVENT_AI_TAKECOVER);
	PLE.AddVector('HeatmapPoint',CoverLoc);
	PLE.AddInt('PlayerIndex',ResolvePlayerIndex(AI));
	PLE.CommitToDisk();
`endif 
}

function RecordAICantFindCover(Controller AI)
{
`if(`notdefined(FINAL_RELEASE))
	local GenericParamListStatEntry  PLE;
	
	if(AI.Pawn == none)	
	{
		return;
	}
	
	PLE = GetGenericParamListEntry();
	PLE.AddInt('EventID',`GAMEEVENT_AI_CANTFINDCOVER);	
	PLE.AddVector('HeatmapPoint',AI.Pawn.Location);
	PLE.AddInt('PlayerIndex',ResolvePlayerIndex(AI));
	PLE.CommitToDisk();
`endif 
}

defaultproperties
{
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_EXECUTION,EventName="Executed",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_HEADSHOT,EventName="Headshot",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_GIB,EventName="Gibbed",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_BLEDOUT,EventName="Bled Out",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_TEAMKILL,EventName="Team Kill",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KILL_SUICIDE,EventName="Suicide",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_MELEE,EventName="Melee",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerKillDeath))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_CHAINSAW_DUEL_WON,EventName="Chainsaw Duel Won",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_CHAINSAW_DUEL_LOST,EventName="Chainsaw Duel Lost",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_ENTERED_COVER,EventName="Entered Cover",StatGroup=(Group=GSG_Player,Level=10),EventDataType=`GET_PlayerInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_LEFT_COVER,EventName="Left Cover",StatGroup=(Group=GSG_Player,Level=10),EventDataType=`GET_PlayerInt)))

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_BAGTAG,EventName="Bag & Tag",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_GRENADE_TAG,EventName="Grenade Tag",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_ProjectileInt))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_GRENADE_TAGGED,EventName="Grenade Tagged",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_ProjectileInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_PLANTED,EventName="Grenade Mine Planted",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_ProjectileInt))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_TRIPPED,EventName="Grenade Mine Tripped",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_ProjectileInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_GRENADE_MINE_TRIPPEDBYME,EventName="Grenade Mine Tripped By Me",StatGroup=(Group=GSG_Player,Level=2),EventDataType=`GET_ProjectileInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_GRENADE_MARTYR,EventName="Martyred",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_HOSTAGE_TAKEN,EventName="Hostage Taken",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_SPECIAL_MOVE,EventName="Special Move",StatGroup=(Group=GSG_Player,Level=10),EventDataType=`GET_SpecialMove))
	SupportedEvents.Add((EventID=GAMEEVENT_WAVE_COMPLETED,EventName="Wave Complete",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_DIFFICULTY,EventName="Player Difficulty Set",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_PlayerInt)))
	
	SupportedEvents.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SUCCESS,EventName="Reload Success",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_WeaponInt))
	SupportedEvents.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SUPER_SUCCESS,EventName="Super Reload Success",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_WeaponInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_FAILED,EventName="Reload Failed",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_WeaponInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_ACTIVE_RELOAD_SKIPPED,EventName="Reload Skipped",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_WeaponInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_ASSIST,EventName="Player Assist",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt)))

	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_PICKUP,EventName="Weapon Pickup",StatGroup=(Group=GSG_Weapon,Level=1),EventDataType=`GET_WeaponInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_AMMOCRATE_PICKUP,EventName="Ammo Pickup",StatGroup=(Group=GSG_Weapon,Level=1),EventDataType=`GET_PlayerInt)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_SHIELD_PICKUP,EventName="Shield Pickup",StatGroup=(Group=GSG_Weapon,Level=1),EventDataType=`GET_PlayerInt)))

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_ROADIE_RUN_START,EventName="Roadie Run Start",StatGroup=(Group=GSG_Player,Level=10),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_ROADIE_RUN_END,EventName="Roadie Run End",StatGroup=(Group=GSG_Player,Level=10),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_KNOCKDOWN,EventName="Knockdown",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_DBNO,EventName="DBNO'd Player",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerPlayer))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_REVIVED,EventName="Player Revived",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerPlayer)))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_CRINGE,EventName="Player Cringe",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPON_DBNO,EventName="Weapon DBNO",StatGroup=(Group=GSG_Weapon,Level=1),EventDataType=`GET_DamageInt))

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_SCORE_UPDATE,EventName="Player Score Updated",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerFloat))
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_NEW_LEADER,EventName="New Leader assigned",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	
	SupportedEvents.Add((EventID=GAMEEVENT_CHECKPOINT_SAVE,EventName="Checkpoint Save",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameString))
	SupportedEvents.Add((EventID=GAMEEVENT_CHECKPOINT_FAILURE,EventName="Checkpoint Force Failure",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameString))

	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_WAVE_KILLS,EventName="Score Wave Kills",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_RING_POSITION,EventName="Ring Position",StatGroup=(Group=GSG_Game,Level=5),EventDataType=`GET_GamePosition))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_RING_POINTS,EventName="Score Ring Points",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_RING_CAPS,EventName="Score Ring Caps",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_RING_BREAKS,EventName="Score Ring Breaks",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_LEADERCAP,EventName="Score Leader Cap",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_LEADERRELEASE,EventName="Score Leader Release",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))
	SupportedEvents.Add((EventID=GAMEEVENT_SCORE_LEADERSAVE,EventName="Score Leader Save",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerInt))

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_AWARD_GIVEN,EventName="Award Given",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))

	SupportedEvents.Add((EventID=GAMEEVENT_FORTIFICATION_EVENT,EventName="Fortification Event",StatGroup=(Group=GSG_GameSpecific,Level=5),EventDataType=`GET_FortificationEvent))

	SupportedEvents.Add((EventID=GAMEEVENT_GUDS_EVENT,EventName="GUDS Event",StatGroup=(Group=GSG_EngineStats,Level=10),EventDataType=`GET_GudsEvent))
	SupportedEvents.Add((EventID=GAMEEVENT_GUDS_ACTION,EventName="GUDS Action",StatGroup=(Group=GSG_EngineStats,Level=10),EventDataType=`GET_GudsAction))
	SupportedEvents.Add((EventID=GAMEEVENT_GUDS_EFFORT,EventName="GUDS Effort",StatGroup=(Group=GSG_EngineStats,Level=10),EventDataType=`GET_GudsEffort))
	SupportedEvents.Add((EventID=`GAMEEVENT_AI_TAKECOVER,EventName="AI Cover Selection",StatGroup=(Group=GSG_Game,Level=10),EventDataType=`GET_GenericParamList))
	SupportedEvents.Add((EventID=`GAMEEVENT_AI_CANTFINDCOVER,EventName="AI Can't Find Cover",StatGroup=(Group=GSG_Game,Level=10),EventDataType=`GET_GenericParamList))

	SupportedEvents.Add((EventID=GAMEEVENT_FRIENDLY_FIRE,EventName="Friendly Fire Enabled",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))			
	SupportedEvents.Add((EventID=GAMEEVENT_ROUND_TIME,EventName="Round Time",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))				
	SupportedEvents.Add((EventID=GAMEEVENT_ROUNDSTOWIN,EventName="Rounds To Win",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))				
	SupportedEvents.Add((EventID=GAMEEVENT_BLEEDOUTTIME,EventName="Bleed Out Time",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))			
	SupportedEvents.Add((EventID=GAMEEVENT_NUMBOTS,EventName="Num Bots",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))					
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPONSWAP_MODE,EventName="Weapon Swap Mode",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))		
	SupportedEvents.Add((EventID=GAMEEVENT_WEAPONSWAP,EventName="Weapon Swap",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameString))	
	SupportedEvents.Add((EventID=GAMEEVENT_ROUNDSCORE_NEWB,EventName="Round Score TDM",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))			
	SupportedEvents.Add((EventID=GAMEEVENT_ROUNDSCORE_KOTH,EventName="Round Score KOTH",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))			
	SupportedEvents.Add((EventID=GAMEEVENT_WINGMAN_GOALSCORE,EventName="Wingman Goalscore",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))		
	SupportedEvents.Add((EventID=GAMEEVENT_BOTDIFFICULTY,EventName="Bot Difficulty",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_EXECUTIONRULES,EventName="Execution Rules",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_HOSTMIGRATION,EventName="Host Migration",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYLISTID,EventName="Playlist ID",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_PARTYOWNER,EventName="Party Owner",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerPlayer))	
	SupportedEvents.Add((EventID=GAMEEVENT_MATCHMODE,EventName="Match Mode",StatGroup=(Group=GSG_Game,Level=1),EventDataType=`GET_GameInt))	

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_KILLS,EventName="Kills XP",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_REVIVES,EventName="Revives XP",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_OBJ,EventName="Objectives XP",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_EXECUTIONS,EventName="Executions XP",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_RIBBONS,EventName="Ribbons XP",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_WINBONUS,EventName="XP Win Bonus",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_PARTICIPATION,EventName="XP Participation",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_XP_PENALTIES,EventName="XP Participation",StatGroup=(Group=GSG_Player,Level=1),EventDataType=`GET_PlayerInt))	
	
         
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_SPOTTEDENEMY,EventName="Spotted",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))	

	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_GIVEMONEY,EventName="Give Money",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_GIVEAMMO,EventName="Give Ammo",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))	
	SupportedEvents.Add((EventID=GAMEEVENT_PLAYER_TRADEWEAPONS,EventName="Trade Weapons",StatGroup=(Group=GSG_Player,Level=5),EventDataType=`GET_PlayerPlayer))	
}
