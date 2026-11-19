/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Holds the matchmaking stats when searching for sessions. 
 * These are converted to XML and uploaded to MCP.
 */
class GearOnlineMatchmakingStats extends OnlineMatchmakingStats
	config(Game)
	native(Online);

/** Maximum number of attempts to store while matchmaking to avoid overflow */
var const config int MaxAttempts;
/** Maximum number of search loops to store within each attempt to avoid overflow */
var const config int MaxSearchLoops;
/** Current version of XML data */
var const int MMStatsVersion;

/** Ranked,Social,etc mode used for this matchmaking pass */
var EGearVersusMatchType MatchMode;
/** Playlist selected for matchmaking */
var int PlaylistId;
/** Dedicated server data center id for the player */
var int ClientDataCenterId;
/** If more than one player is playing locally */
var bool bIsSplitscreen;
/** If the player is allowed to search for dedicated servers (based on the current match mode) */
var bool bIsUsingDedicatedSearches;
/** Quit demerits currently in player's profile */
var int QuitCount;
/** Standby demerits currently in player's profile */
var int StandbyCount;
/** Ratio of successfully hosted matches currently in player's profile */
var float GoodHostRatio;

/** Skill values read for a player */
struct native MMStats_Skill
{
	/** XP based level progress for player */
	var int XpLevel;
	/** The skill of the player */
	var int Skill;
	/** The raw skill value */
	var double Mu;
	/** The uncertainty of that raw skill value */
	var double Sigma;	
};
/** Stats for a single member of a party */
struct native MMStats_PartyMember
{
	/** Unique id of party member */
	var UniqueNetId NetId;
	/** Skill for party member */
	var MMStats_Skill PlayerSkill;
	/** TRUE if party member disconnected during matchmaking */
	var bool bDisconnected;
};
/** Stats for group of players in a party */
struct native MMStats_PartyGroup
{
	/** Timer for the skill read task */
	var MMStats_Timer SkillReadTimer;
	/** Avg skill for the entire party */
	var MMStats_Skill PartySkill;
	/** Members of the party including the party host */
	var array<MMStats_PartyMember> Members;
};
/** The party of the player currently matchmaking */
var const MMStats_PartyGroup PartyGroup;

/** Action taken on a session search result */
enum EMMStats_JoinAction
{
	/** Session was skipped and no join attempt was made */
	MMS_JoinAction_NoAttempt,
	/** Attempted a join and succeeded via client beacon request */
	MMS_JoinAction_JoinSucceeded,
	/** Attempted a join failed on the client beacon */
	MMS_JoinAction_JoinFailed_Client,
	/** Attempted a join failed due to host being full */
	MMS_JoinAction_JoinFailed_Full,
	/** Attempted a join failed due to timeout */
	MMS_JoinAction_JoinFailed_Timeout,
	/** Attempted a join failed due to host not currently accepting new requests */
	MMS_JoinAction_JoinFailed_Denied,
	/** Attempted a join failed due to some other reason */
	MMS_JoinAction_JoinFailed_Other
};

/** Reasons for session getting culled from search results */
enum EMMStats_SessionCull
{
	/** Was not culled */
	MMS_SessionCull_None,
	/** Culled due to QoS not coming back from session being unreachable */
	MMS_SessionCull_Unreachable,
	/** Culled due to ping being higher than MaxPing */
	MMS_SessionCull_MaxPing,
	/** Culled due to match quality being higher than the max quality threshold */
	MMS_SessionCull_MatchQuality,
};

/** Session returned from a search */
struct native MMStats_SearchResult
{
	/** Net id for owner of the remote session */
	var UniqueNetId OwnerNetId;
	/** Locale of player hosting the remote session. Only valid for ded servers */
	var int LocaleId;
	/** Id of remote session that was found */
	var QWORD SessionId;
	/** Ping from QoS */
	var int PingMs;
	/** MatchQuality based on skill of players in session */
	var float MatchQuality;
	/** Timer to track a join attempt if this session was selected to be joined */
	var MMStats_Timer JoinTimer;
	/** Result of a join attempt on this session */
	var EMMStats_JoinAction JoinAction;
	/** Result of why this session was culled or if it wasn't */
	var EMMStats_SessionCull SessionCull;
};

/** Type of search being performed by a query */
enum EMMStats_SearchType
{
	/** Searching for a session with perfect fit for party size */
	MMS_SearchType_Best,
	/** Searching for a session that can accomodate party but not perfectly */
	MMS_SearchType_Any,
	/** Dedicated only search for a server that has not been configured with a playlist yet */
	MMS_SearchType_Empty,
};

/** Contains a single search attempt and the results returned by it */
struct native MMStats_Search
{
	/** Times only the search task and not the processing of the sessions (ie. join attempts, etc) */
	var MMStats_Timer Timer;
	/** Search type for this step */
	var EMMStats_SearchType Type;
	/** If the search is for a dedicated server */
	var bool bDedicated;
	/** List of results from the search task */
	var array<MMStats_SearchResult> Results;
};

/** Grouping of a loop through all search types */
struct native MMStats_SearchGroup
{
	/** Timing for a single loop through a set of searches */
	var MMStats_Timer Timer;
	/** Set of search tasks run */
	var array<MMStats_Search> Searches;	
};

/** Results of a bandwidth test run once in a gathering state once a remote party joined */
enum EMMStats_BandwidthTestResult
{
	/** No bandwidth testing was run as it wasn't necessary */
	MMS_BandwidthTest_NoAttempt,
	/** Bandwidth test ran and succeeded */
	MMS_BandwidthTest_Success,
	/** Bandwidth test ran and succeeded, but it was incomplete */
	MMS_BandwidthTest_SuccessIncomplete,
	/** Bandwidth test timedout before completing */
	MMS_BandwidthTest_Timeout,
	/** Bandwidth test could not be initiated due to error */
	MMS_BandwidthTest_Error,
};

/** Result of a remote joined party being selected as the new optimal host */
enum EMMStats_OptimalHostSelection
{
	/** Remote party was not selected for optimal host */
	MMS_OptimalHost_NotSelected,
	/** Selected as optimal host and successfuly migrated game to that remote party */
	MMS_OptimalHost_Success,
	/** Selected as optimal host but failed to migrate game to that remote party */
	MMS_OptimalHost_Failed,
};

/** Party reservations held by a gathering host */
struct native MMStats_PartyReservation
{
	/** Leader of the party */
	var UniqueNetId LeaderNetId;
	/** Members of the party including the leader */
	var array<MMStats_PartyMember> Members;
	/** Result of a bandwidth test run on a remote party host */
	var EMMStats_BandwidthTestResult BandwidthTestResult;
	/** Result of a remote joined party being selected as the new optimal host */
	var EMMStats_OptimalHostSelection OptimalHostSelection;
	/** If the remote party disconnected during the gathering stage */
	var bool bDisconnected;
	/** Timer for tracking total time this reservation was active before disconnecting or match starting */
	var MMStats_Timer Timer;
};

/** Host state that is advertising a session for others to find */
struct native MMStats_Gather
{
	/** Timer for tracking total time in a single gathering state */
	var MMStats_Timer Timer;
	/** Id of session that was created */
	var QWORD SessionId;
	/** Reservations for remote parties as well as the local host */
	var array<MMStats_PartyReservation> Reservations;
	/** Aggregate of skill for players that have found the match */
	var MMStats_Skill PlayersSkill;
};

/** Result of a single matchmaking attempt */
enum EMMStats_AttemptResult
{
	/** No result */
	MMS_AttemptResult_None,
	/** Successfully joined a host as a client. Gathering host can also do this if another player was selected as the new optimal host */
	MMS_AttemptResult_SuccessJoin,
	/** Successfully joined a new optimal host but was gathering*/
	MMS_AttemptResult_SuccessJoinAsGatherer,
	/** Successfully traveled as a host that was gathering */
	MMS_AttemptResult_SuccessTravelGatherHost,
	/** Successfully traveled as a new host that was selected as the optimal host */
	MMS_AttemptResult_SuccessTravelOptimalHost,
	/** Cancellation by the local user */
	MMS_AttemptResult_LocalCancel,
	/** Cancellation by a remote host that we have joined with a reservation */
	MMS_AttemptResult_RemoteCancel,
	/** Gathering attempt ended because nobody was joining the host */
	MMS_AttemptResult_HostIdle,
	/** Dedicated host restarted. All players left */
	MMS_AttemptResult_DedicatedRestart,
};

/** A single matchmaking attempt ending in with an EMMStats_AttemptResult type */
struct native MMStats_Attempt
{
	/** Total time for the attempt including all searching and gathering */
	var MMStats_Timer Timer;
	/** Result of a single matchmaking attempt */
	var EMMStats_AttemptResult Result;
	/** List of groupinging of a loop through all search types */
	var array<MMStats_SearchGroup> SearchGroups;
	/** Total searches run. Might be more than the size of the SearchGroups list to avoid too many entries */
	var int TotalSearchGroups;
	/** State while switchign to a gathering host */
	var MMStats_Gather GatheringHost;
};
/** All the attempts that were done for a single matchmaking session */
var const array<MMStats_Attempt> Attempts;
/** Number of total attempts. Might be more than the size of the Attempts list to avoid too many entries */
var const int TotalSearchAttempts;

/**
 * Mark party skill read as started.  Begin timing it
 */
native function BeginPartySkillRead();

/**
 * Mark party skill read as ended.  Finish timing it. Store off players and their skills
 * 
 * @param bWasSuccessful TRUE if the skill read finished successfully
 * @param Players list of players in the party with their skill info
 * @param PRIArray list of GearPRI entries for reading player XP level
 * @param AggregateMu - aggregate Mu for all players in party
 * @param AggregateSigma - aggregate Sigma for all players in party
 */
native function EndPartySkillRead(bool bWasSuccessful, array<PlayerReservation> Players, array<PlayerReplicationInfo> PRIArray, double AggregateMu, double AggregateSigma);

/**
 * Mark player in the party as disconnected
 * 
 * @param PlayerNetId id for player that logged out
 */
native function PlayerLogout(UniqueNetId PlayerNetId);

/**
 * Mark new matchmaking attempt as started.  Begin timing it
 */
native function BeginAttempt();

/**
 * Mark attempt as ended.  Finish timing it. Finalize any pending search/gather
 * 
 * @param AttemptResult EMMStats_AttemptResult type for the result of this last attempt
 */
native function EndAttempt(EMMStats_AttemptResult AttemptResult);

/**
 * Mark new search loop as started.  Begin timing it
 */
native function BeginSearchGroup();

/**
 * Mark last search loop as ended.  Finish timing it
 */
native function EndSearchGroup();

/**
 * Mark new search query as started.  Begin timing it
 *
 * @param SearchType EMMStats_SearchType for type of search that is about to run
 * @param bIsDedicated TRUE if searching for a dedicated server
 */
native function BeginSearch(EMMStats_SearchType SearchType,bool bIsDedicated);

/**
 * Mark search query as ended.  Finish timing it
 * 
 * @param SearchResult search object that is filled in by the query
 */
native function EndSearch(OnlineGameSearch SearchResult);

/**
 * Mark joining of an existing search result as started.  Begin timing it
 *
 * @param SessionIdx index of search result that is being joined
 */
native function BeginJoin(int SessionIdx);

/**
 * Mark joining of an existing search result as ended.  Finish timing it
 *
 * @param SessionIdx index of search result that is being joined
 * @param ReservationResult EPartyReservationResult beacon result of the reservation attempt
 * @param bFailedLocal TRUE if reservation attempt failed to initialize locally
 */
native function EndJoin(int SessionIdx, EPartyReservationResult ReservationResult,optional bool bFailedLocal=false);

/**
 * Mark an existing search result as being culled.  It won't be joined
 *
 * @param SessionIdx index of search result that is being culled
 * @param bReachableOk TRUE if session is reachable via QoS
 * @param bMaxPingOk TRUE if session has a ping within our max threshold
 * @param bMatchQualityOk TRUE if session has a match quality within our max threshold
 */
native function CullSession(int SessionIdx,bool bReachableOk,bool bMaxPingOk,bool bMatchQualityOk);

/**
 * Mark a new gathering host attempt as started.  Begin timing it
 *
 * @param SessionName name of host game session that was created for gathering
 */
native function BeginGather(name SessionName);

/**
 * Mark a new gathering host attempt as ended.  Finish timing it
 */
native function EndGather();

/**
 * Add/remove/update reservations while in gathering host state
 *
 * @param BeaconReservations reservation array from the host beacon
 * @param AggregateMu - aggregate Mu for all players that have found the match
 * @param AggregateSigma - aggregate Sigma for all players that have found the match
 */
native function UpdateReservations(const array<PartyReservation> BeaconReservations, double AggregateMu, double AggregateSigma);

/**
 * Update the bandwidth test results for an existing gathering host reservation
 *
 * @param PlayerNetId id for leader of remote party. Used to find reservation
 * @param TestResult EMeshBeaconBandwidthTestResult returned by the bandwidth beacon
 * @param BandwidthStats stats returned about the bandwidth test
 */
native function UpdateBandwidthTest(UniqueNetId PlayerNetId,EMeshBeaconBandwidthTestResult TestResult,ConnectionBandwidthStats BandwidthStats);

/**
 * Mark a remote party as being selected as the new optimal host for the game
 *
 * @param PlayerNetId id for leader of remote party. Used to find reservation
 */
native function OptimalHostSelected(UniqueNetId PlayerNetId);

/**
 * Mark a remote party that was selected as optimal host as successfully creating new session for the game
 *
 * @param PlayerNetId id for leader of remote party. Used to find reservation
 */
native function OptimalHostSuccess(UniqueNetId PlayerNetId);

/**
 * Initialize the matchmaking stats state
 */
final function Init(EGearVersusMatchType InMatchMode,int InPlaylistId,int InClientDataCenterId,bool InbIsSplitscreen,bool InbIsUsingDedicatedSearches,GearProfileSettings Profile)
{
	MatchMode = InMatchMode;
	PlaylistId = InPlaylistId;
	ClientDataCenterId = InClientDataCenterId;
	bIsSplitscreen = InbIsSplitscreen;
	bIsUsingDedicatedSearches = InbIsUsingDedicatedSearches;
	if (Profile != None)
	{
		QuitCount = Profile.GetQuitCount();
		StandbyCount = Profile.GetStandByDemerits();
		GoodHostRatio = Profile.GetGoodHostRatio();
	}
}

/**
 * Finalize matchmaking state. End all timers
 */
native function Finalize();

cpptext
{
	/**
	 * Convert this matchmaking stats object to an XML string
	 *
	 * @param OutXmlStr [out] resulting XML string
	 * @param UniqueId id for local player that initiated matchmaking
	 * @param XmlPlatformStr platform specific XML data to merge into the MMStats tag
	 * @param bShouldIndent TRUE if tabbed indenting should be added for readability
	 */
	virtual void ToXML(FString& OutXmlStr,const FUniqueNetId& UniqueId,const FString& XmlPlatformStr,UBOOL bShouldIndent);

private:

	/**
	 * @return last attempt that is still active. create if none available
	 */
	FMMStats_Attempt& GetCurrentAttempt();
	/**
	 * @return last search group that is still active. create if none available
	 */
	FMMStats_SearchGroup& GetCurrentSearchGroup();
	/**
	 * @return last search query that is still active. create if none available
	 */
	FMMStats_Search& GetCurrentSearch();
	/**
	 * Finalize the timing for an attempt and all of its sub items
	 *
	 * @param Attempt struct to finalize
	 */
	void FinalizeAttempt(FMMStats_Attempt& Attempt);
	/**
	 * Finalize the timing for a search group and all of its sub items
	 *
	 * @param SearchGroup struct to finalize
	 */
	void FinalizeSearchGroup(FMMStats_SearchGroup& SearchGroup);
	/**
	 * Finalize the timing for a search query and all of its sub items
	 *
	 * @param Search struct to finalize
	 */
	void FinalizeSearch(FMMStats_Search& Search);
	/**
	 * Finalize the timing for gathering and all of its reservations
	 *
	 * @param Gather struct to finalize
	 */
	void FinalizeGather(FMMStats_Gather& Gather);
};

defaultproperties
{
	MMStatsVersion=5
}