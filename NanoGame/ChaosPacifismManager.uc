/**
 * This guy is spawned on the server and then replicated out to the clients.
 * so we will want to have simulated and other replicated out variables
 *
 *
 * The way this works is you have tiers of 100 pts each.  You are in Tier N if you do (pts / 100)
 *
 * 000-99  1
 * 100-199 2
 * 200-299 3
 * 300-399 4
 * 400-    5
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ChaosPacifismManager extends Actor
	native
	dependson(NanoTypes, NanoArchetypeTypes, NanoCausingChaosValues, NanoPRI)
	config(Game);



/** This determines whether or not the events from the world will affect the chaos level or not **/
var transient bool bWorldEventsAffectChaos;

/** This is the current chaos level **/
var transient protected int ChaosLevel;

var transient protected float TimeChaosLevelLastIncreased;

/** Store off when we last returned to Threat Level Zero **/
var transient float TimeChaosLevelLastWasThreatLevelZero;

/** The amount of time between chaos causing events before it will decrease **/
var protected config float ChaosLevelDecreaseQuietPeriod;

/** Time period to check for chaos reductions **/
var protected config float TimeBetweenChaosReductions;

/** Time stamp of when player was inside of any AIs' Threat Query **/
var transient float TimeOfInsideAIThreatQueryView;


/** If all rebels are in cooldown volumes, how quickly chaos level goes down */
var protected config float ChaosCooldownVolumeRate;

/** If TRUE, all rebels are in a cooldown volume */
var protected transient bool bAllRebelsInCooldownVolumes;

/** If TRUE, all rebels are in a ChaosEventsDoNothing volume */
var protected transient bool bAllRebelsInChaosEventsDoNothingVolume;


/** When dropping back to chaos tier 0 from this tier you gain this much rebel mind share **/
var config array<int> AmountOfMindShareGainedFromThisChaosTier;


struct native ChosAnnouncementDatum
{
	var Name SoundModeToEnable;

	/** Play only once per event **/
	var() SoundCue Hit;

	/** Dispatcher is separate so it can "speak" after the Hit has played.  Basically Hit.Duration **/
	var() EDialogueLine DispatcherDialogLineID;

	/** How long to wait after dispatcher says something for the DialogLine to be played **/
	var() float DialogLineWaitTime;

	/** What a metacorp guy will say.  (Game will find the "best" guy to say the line. **/
	var() EDialogueLine DialogLineID;

};

var ChosAnnouncementDatum TierAnnouncements[6];




/** Array of changes in chaos history - oldest to newest */
var	transient array<ChaosChangeHistoryInfo>	ChaosHistory;
/** Maximum length of chaos history */
var int								MaxChaosHistorySize;
/** How long a message sticks around for */
var float							ChaosHistoryDecayTime;

/** Name for the the chaos zones this manager handles **/
var transient name ChaosZoneName;

/** How much of an offset after the tier announcement's cue duration for playing dispatch**/
var config float DispatchOffset;


replication
{
	if( Role == ROLE_Authority )
		ChaosLevel;
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	//`log( "ChaosPacifismManager " @ "ChaosLevelDecreasePerTimePeriodAmount: " @ ChaosLevelDecreasePerTimePeriodAmount @ " ChaosLevelDecreaseQuietPeriod: " @ ChaosLevelDecreaseQuietPeriod @ " TimeBetweenChaosReductions: " @ TimeBetweenChaosReductions );

	if( Role == ROLE_Authority )
	{
		// For now, no auto-chaos-down, to make debugging easier
		SetTimer( TimeBetweenChaosReductions, TRUE, nameof(PossiblyDecreaseChaosLevel) );
	}
}



simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// If all rebels are in cooldown volumes, chaos cools down more quickly
	if(bAllRebelsInCooldownVolumes)
	{
		ModifyChaosLevel( self, class'NanoCausingChaosValues'.default.CoolDownVolumeDecreaseAmount );
	}

	// Remove old entries from start of ChaosHistory
	while(ChaosHistory.length > 0 && `TimeSince(ChaosHistory[0].ChaosChangeTime) > ChaosHistoryDecayTime)
	{
		ChaosHistory.remove(0,1);
	}
}

/**
 * This is the function which should be used to increase / decrease chaos. 
 **/
final function ModifyChaosLevel( const Actor InInstigator, const NanoCausingChaosValueDatum Datum )
{
	local NanoGRI NGRI;
	local EChaosTier ChaosTier;
	local EChaosTier PrevChaosTier;
	local int ChaosChange;
	local ChaosChangeHistoryInfo HistInfo;

	local NanoDefensivePoint NDP;

	
	if( Datum.bSpecialChaosCausingEventOverrideableWorldEventsAffectChaos == FALSE )
	{
		// if we are not responding to WoldEvents causing chaos
		if( bWorldEventsAffectChaos == FALSE )
		{
			return;
		}
	}

	if( bAllRebelsInChaosEventsDoNothingVolume == TRUE )
	{
		return;
	}



	NGRI = NanoGRI(WorldInfo.GRI);

	ChaosTier = GetChaosTier();
	PrevChaosTier = ChaosTier;

	//`log( "CurrChaosTier" @ ChaosTier @ "AutoJump:" @ Datum.AutoJumpToTier @ "Incre:" @ Datum.ChaosAmount.Values[0] @ Datum.ChaosAmount.Values[1] @ Datum.ChaosAmount.Values[2] @ Datum.ChaosAmount.Values[3] @ Datum.ChaosAmount.Values[4] @ `showvar(bAllRebelsInChaosEventsDoNothingVolume));


	//`log(`showvar(ChaosTier) @ `showvar(Datum.AutoJumpToTier-1) );

	if( ChaosTier != (Datum.AutoJumpToTier-1) && ( Datum.AutoJumpToTier != -1) )
	{
		SetChaosLevel(((Datum.AutoJumpToTier-1) * 100) );
		ChaosChange = -1; // hack
	}
	else
	{
		ChaosChange = DetermineProRatedChaosAmount( Datum );
		ModifyChaosLevelByAmount( ChaosChange );
	}


	if( ChaosChange != 0 )
	{
		// Add to end of history log
		HistInfo.ChaosZoneName = ChaosZoneName;
		HistInfo.ChaosChange = ChaosChange;
		HistInfo.ChaosChangeCause = Datum.ChaosDesc;
		HistInfo.ChaosChangeTime = WorldInfo.TimeSeconds;
		ChaosHistory[ChaosHistory.length] = HistInfo;

		TimeOfInsideAIThreatQueryView = WorldInfo.TimeSeconds; // set this as a chaos even has been generated

		// so if this chaos causing event has occurred then we want to send all of the AI to a place to despawn
		if( Datum.bSendAIHome == TRUE )
		{
			NGRI.NPES.SendAllAIToANonVisibleSpotToDespawn();
		}

		if( Datum.bSetAllDefensivePointsToNotBeUnderAttack == TRUE )
		{
			// hurts us
			foreach WorldInfo.AllActors( class'NanoDefensivePoint', NDP )
			{
				NDP.bUnderAttack = FALSE;
				NDP.ActualTimeToSendReinforcements = 0;
			}
		}

		if( GetChaosLevel() > 0 )
		{
			NGRI.NPES.FindAllNearbyMetaCorpCrowdMembersAndSpawnAI();
		}
	}


	//`log( "lalallalalalalala" @ `showvar(PrevChaosTier) @ `showvar(GetChaosTier()) @ PrevChaosTier < GetChaosTier() );

	if( PrevChaosTier < GetChaosTier() )
	{
		NGRI.NPES.UpdateHotZoneLocation();
		NGRI.NPES.AddCloudBurstPoints( NGRI.NPES.ChaosTierSpawnData[GetChaosTier()].BurstSpawnAmount );
		NGRI.NPES.TimeToDoCloudManagement = WorldInfo.TimeSeconds; // might be a bug for when chaos is going up
		NGRI.GetNanoPC().ChaosStarted();

		if( GetChaosTier() == ECT_Tier3 )
		{
			// set a timer here to call this in 10 seconds after chaos 3 otherwise we get SOUUUNNDDD and text event overload
			// EXECREVIEW REMOVE ME AFTER
			//NGRI.SetTimer( 10.0f, FALSE, nameof(NGRI.SendForMobileHelp) );
		}
	}


	if( ( GetChaosTier() < PrevChaosTier ) && ( GetChaosTier() == ECT_Tier0 ) )
	{
		NGRI.NPES.CloudBurstPoints = 0;
		NGRI.GetNanoPC().ChaosStopped();

		NGRI.GetMusicManager().HandleMusicEvent( EME_CombatEnds );
		NGRI.GetNanoPC().SetSoundMode( 'Default' );

		// if we are not denying reward then give reward
		if( Datum.bDoNOTRewardRebelMindShare == FALSE )
		{
			NGRI.GetCurrentRebelMindShareManager().AddRebelMindShareLevel( AmountOfMindShareGainedFromThisChaosTier[PrevChaosTier] );

			if( PrevChaosTier == ECT_Tier5 )
			{
				NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_ReachedChaosTier5AndEscaped );
			}
		}


		// so we have reset chaos here.
		// we need to reset all our crazy mobile vars
		NGRI.ResetMobileHelp();
	}


	// Ensure log not too long
	while(ChaosHistory.length > MaxChaosHistorySize)
	{
		ChaosHistory.remove(0,1);
	}

}

final private function ModifyChaosLevelByAmount( int Amount )
{
	//`log( "--> ModifyChaosLevelByAmount:" @ `showvar(Amount) );
	SetChaosLevel(ChaosLevel + Amount);
}

/** Internal method of changing ChaosLevel, handles clamping and generating notifications for chaos tier changes */
protected function SetChaosLevel(int NewLevel)
{
	local int PrevTier, CurrentTier;
	local HUD PC_HUD;
	local NanoGRI NGRI;

	PrevTier = GetChaosTier();
	if (NewLevel > ChaosLevel)
	{
		TimeChaosLevelLastIncreased = WorldInfo.TimeSeconds;
	}
	ChaosLevel = Clamp(NewLevel,0,600); // 600 is max as we have 5 tiers of chaos and each tier has 100 pts in it
	// send out notifications for tier changes
	CurrentTier = GetChaosTier();

	if(CurrentTier != PrevTier)
	{
		PlayChaosTierAnnouncement(CurrentTier > PrevTier);

		NGRI = NanoGRI(WorldInfo.GRI);

		PC_HUD = NGRI.GetNanoPC().myHUD;
		NanoHUD_Base(PC_HUD).SlideChaosLevelMessage(CurrentTier, 1.5);

		//ScriptTrace();
		NGRI.NPES.NotifyChaosTierChange( CurrentTier ) ;
		NGRI.NED.NotifyChaosTierChange( CurrentTier ) ;

		if( GetChaosTier() == ECT_Tier0 )
		{
			TimeChaosLevelLastWasThreatLevelZero = WorldInfo.TimeSeconds;
		}
	}

	while (PrevTier < CurrentTier)
	{
		ChaosTierIncremented(++PrevTier);
	}

	while (PrevTier > CurrentTier)
	{
		ChaosTierDecremented(--PrevTier);
	}
}

/** Play a chime and then an announcement stating new chaos tier */
protected simulated function PlayChaosTierAnnouncement(bool bTierRaised)
{
	local NanoPC NPC;
	local SoundCue TierSound;
	local int CurrentTier;

	CurrentTier = GetChaosTier();


	NanoGRI(WorldInfo.GRI).GetNanoPC().ChaosAnnounceSoundMode( 0.0f );

	TierSound = TierAnnouncements[CurrentTier].Hit;

	if( TierSound != None )
	{
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			NPC.PlaySound(TierSound);
			break;
		}

		SetTimer( TierSound.GetCueDuration()+DispatchOffset, FALSE, nameof(PlayChaosTierDelayed));
	}
}

/** Called using timer after PlayChaosTierAnnouncement, to play the dialog for new tier */
protected simulated function PlayChaosTierDelayed()
{
	local NanoPC NPC;
	local int CurrentTier;
	local NanoMusicManager NAM;
	local MusicEventDatum MED;

	CurrentTier = GetChaosTier();

	NAM = NanoGRI(WorldInfo.GRI).GetMusicManager();

	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		// here we do trickiness, where we set the CombatStarts event to the CombatStarts_Level
		if( CurrentTier == ECT_Tier2 )
		{
			MED = NAM.MusicEventData[EME_CombatStarts_ChaosLevelOne];
		}
		else if( CurrentTier == ECT_Tier3 )
		{
			MED = NAM.MusicEventData[EME_CombatStarts_ChaosLevelTwo];
		}
		else if( CurrentTier == ECT_Tier4 )
		{
			MED = NAM.MusicEventData[EME_CombatStarts_ChaosLevelThree];
		}
		else if( CurrentTier == ECT_Tier5 )
		{
			MED = NAM.MusicEventData[EME_CombatStarts_ChaosLevelFour];
		}
		else
		{
			MED = NAM.MusicEventData[EME_CombatStarts_ChaosLevelOne];
		}

		NAM.UpdateMusicEvent( EME_CombatStarts, MED.Hit, MED.Track, MED.TrackFadeInTime, MED.TrackFadeOutTime );


		break;
	}

	NanoGRI(WorldInfo.GRI).NADS.AttemptToPlayLine( TierAnnouncements[CurrentTier].DispatcherDialogLineID, None );
}



/** Called each time we progress to a new chaos tier (may be called multiple times in a row) */
protected function ChaosTierIncremented(int NewTierLevel)
{
	local NanoAI_SentryBot SentryBot;
	//`log(`location@`showvar(NewTierLevel));
	switch (NewTierLevel)
	{
	case 0:
		break;
	case 1:
		// deploy all tattler bots
		foreach WorldInfo.AllControllers(class'NanoAI_SentryBot',SentryBot)
		{
			SentryBot.Undock();
		}
		break;
	case 2:
		// redock any bots
		foreach WorldInfo.AllControllers(class'NanoAI_SentryBot',SentryBot)
		{
			SentryBot.ReturnToDock();
		}
		break;
	}
}

/** Called each time we regress to a previous chaos tier (may be called multiple times in a row) */
protected function ChaosTierDecremented(int NewTierLevel)
{
	//`log(`location@`showvar(NewTierLevel));
}

private final function int DetermineProRatedChaosAmount( const out NanoCausingChaosValueDatum Datum )
{
	local int Retval;

	local float AmountToIncrease;
	local int CurrChaosTier;

	local int NewChaosLevel;
	local int NewChaosTier;

	local float AmountToFillCurrentLevel;
	local float PercentToProRate;

	// okie here we need to do our pro rating of points based on the chaos level which we end up in
	// the idea here is not take away work players have already done in a tier but still give them credit in the next tier up

	AmountToIncrease = Datum.ChaosAmount.Values[Min( ((ChaosLevel/100)), 5)];

	CurrChaosTier = Min( ((ChaosLevel/100)), 5);

	NewChaosLevel = ChaosLevel + AmountToIncrease;

	NewChaosTier = Min( ((NewChaosLevel/100)), 5);


	// we need to pro rate
	if( CurrChaosTier != NewChaosTier )
	{
		// amount needed to fill out this current level
		AmountToFillCurrentLevel = 100 - (ChaosLevel % 100);

		if( AmountToIncrease > AmountToFillCurrentLevel )
		{
			PercentToProRate = (AmountToIncrease - AmountToFillCurrentLevel) / AmountToIncrease;
			
			Retval = AmountToFillCurrentLevel + Datum.ChaosAmount.Values[NewChaosTier] * PercentToProRate;

		}
		// just add the AmountToIncrease
		else
		{
			Retval = AmountToIncrease;
		}
	}
	else
	{
		Retval = AmountToIncrease;
	}

	//`log( "CurrChaosTier" @ CurrChaosTier @ "NewChaosTier" @ NewChaosTier @ "Retval" @ Retval @ "PercentToProRate" @ PercentToProRate @ "AmountToIncrease" @ AmountToIncrease @ "AmountToFillCurrentLevel" @ AmountToFillCurrentLevel );

	return Retval;
}

static final function int GetChaosLevel()
{
	local NanoGRI NGRI;
	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	return NGRI.GetCurrentChaosManager().ChaosLevel;
}


final event EChaosTier GetChaosTier()
{
	return EChaosTier( Min( FFloor(ChaosLevel/100.0), class'NanoProceduralEnemySpawner'.default.ChaosTierSpawnData.Length-1) );
}


/** This will possibly decrease the chaos level.  Based on if there have been any chao causing events recently.  If there have been then no decrease. **/
final function PossiblyDecreaseChaosLevel()
{
	local bool bNotWithinConfrontPossibleThreatQuery;

	// this is always based on guys
	bNotWithinConfrontPossibleThreatQuery = ThereAreNoAIWithinConfrontPossibleThreatQuery();

	// so if the AI can see you then we timestamp
	if( bNotWithinConfrontPossibleThreatQuery == FALSE )
	{
		TimeOfInsideAIThreatQueryView = WorldInfo.TimeSeconds;
	}


	if( Role == ROLE_Authority )
	{
		if( ( ChaosLevel > 0 )
			&& ( (WorldInfo.TimeSeconds - TimeChaosLevelLastIncreased) > ChaosLevelDecreaseQuietPeriod )
		    && ( ThereAreNoTattlerBotsFollowingPlayer() == TRUE ) 
			&& ( ThereAreNoPlayersInCombat() == TRUE )
			&& ( bNotWithinConfrontPossibleThreatQuery == TRUE )
			)
		{
			//`log( "Decreasing Chaos!" );
			// we are not doing this atm due to slow thinking
			//ModifyChaosLevel( self, class'NanoCausingChaosValues'.default.AutoDecreaseAmount );
		}

		// if you are out side of the view of AIs then then we have instant decrease
		if( ( ChaosLevel > 0 )
			&& ( bNotWithinConfrontPossibleThreatQuery == TRUE )
			&& ( `TimeSince(TimeChaosLevelLastIncreased) > NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos )
			&& ( `TimeSince(TimeOfInsideAIThreatQueryView) > NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos )
			)
		{
			ModifyChaosLevel( self, class'NanoCausingChaosValues'.default.InstantDecreaseToTier1 );
		}
	}
}


/** 
 * Looks to see if there are no players in combar
 **/
simulated function bool ThereAreNoPlayersInCombat()
{
	local PlayerController	PC;

	ForEach LocalPlayerControllers( class'PlayerController', PC )
	{
		if(( NanoPawnBase(PC.Pawn) != none ) && ( NanoPawnBase(PC.Pawn).bIsInCombat == TRUE ) )
		{
			return FALSE;
		}
	}

	return TRUE;
}


/** 
 * This will look at all of the bots within our ChaosZones and see if they have an active focus. 
 * Right now this just uses WorldInfo.AllPawns.  We could do something a little better to track the player when focus is lost gained.
 **/
simulated function bool ThereAreNoTattlerBotsFollowingPlayer()
{
    local NanoPawn_MetaCorp_SentryBotBase Tattler;

	//`log( "ThereAreNoTattlerBotsFollowingPlayerThereAreNoTattlerBotsFollowingPlayerThereAreNoTattlerBotsFollowingPlayer");
	// check all tattlers that have a focus and are in in a zone who is controlled by this ChaosManager
	foreach WorldInfo.AllPawns( class'NanoPawn_MetaCorp_SentryBotBase', Tattler )
	{
       // `log( "Focus:" @ NanoPawn_RebelsBase(Tattler.Controller.Focus) @ Tattler.GetChaosZone().MyNanoChaosZoneInfo.ChaosManager );
		if( 
			( NanoPawn_RebelsBase(Tattler.Controller.Focus) != none ) 
            && ( Tattler.Controller.IsInState( 'Alert' ) == TRUE )
			&& (Tattler.GetChaosZone() != none ) 
			&& (Tattler.GetChaosZone().MyNanoChaosZoneInfo.ChaosManager == self ) 
			)
		{
			//`log( "-> Return FALSE" );
            return FALSE; // return false here as we have a tattler that is active
		}
	}
	//`log( "-> Return TRUE" );
	return TRUE;
}


simulated function bool ThereAreNoAIWithinConfrontPossibleThreatQuery_AI()
{
	local NanoAI AI;
	local vector PlayerLocation;


	PlayerLocation = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != None )
		{
			// so we want to not count any AI that are inside the pacman
			if( ( VSize(AI.Pawn.Location-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() ) )
			{
				continue;
			}

			// if this AI belongs to a NDP then we need to check the NDP's data and not the AIs
			if( AI.CurrNanoDefensivePoint != None )
			{
				if( AI.CurrNanoDefensivePoint.IsPlayerWithinUnderDefendRadius() == TRUE )
				{
					return FALSE;
				}
			}

			// if the AI is not at a NDP then check it's Confront Query
			if( ( AI.CurrNanoDefensivePoint == None )
				&& ( VSize(PlayerLocation-AI.Pawn.Location) < AI.ConfrontPossibleThreatQuery.MaxDist )
				)
			{
				return FALSE;
			}
		}
	}

	return TRUE;
}

/**
 * Looks at all of the AI controllers and check that none of them are withing the ConfrontPossibleThreadQuery 
 *
 * NOTE:  instead of O(n) across all controllers we should probably do an octree query around us
 *
 **/
simulated function bool ThereAreNoAIWithinConfrontPossibleThreatQuery()
{
	local vector PlayerLocation;

	PlayerLocation = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location;


	// now check the PacMan location / and Cloud_MinSpawnDistance
	// to see if the Player is inside that
	if( ( VSize(PlayerLocation-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() ) )
	{
		return FALSE;
	}

	return ThereAreNoAIWithinConfrontPossibleThreatQuery_AI();
}


/** See if all rebels are in chaosEventsDoNothing  volumes */
simulated function UpdateChaosEventsDoNothing()
{
	local NanoPawn_RebelsBase Rebel;

	// Start by assuming they are not all in volumes
	bAllRebelsInChaosEventsDoNothingVolume = FALSE;

	// Iterate over each rebel
	foreach WorldInfo.AllPawns(class'NanoPawn_RebelsBase', Rebel)
	{
		if( Rebel.IsHumanControlled() == TRUE )
		{
			if(!Rebel.IsInChaosEventsDoNothingVolume())
			{
				`log( "There is a rebel NOT in the ChaosEventsDoNothingVolume volume!!" @ `showvar(Rebel) );
				// We found one rebel not in a volume - we can exit now leaving it FALSE
				return;
			}
		}

	}

	// All rebels are in volumes  - set bool to TRUE
	bAllRebelsInChaosEventsDoNothingVolume = TRUE;
}



/** See if all rebels are in cooldown volumes */
simulated function UpdateChaosCooldownStatus()
{
	local NanoPawn_RebelsBase Rebel;

	// Start by assuming they are not all in volumes
	bAllRebelsInCooldownVolumes = FALSE;

	// Iterate over each rebel
	foreach WorldInfo.AllPawns(class'NanoPawn_RebelsBase', Rebel)
	{
		if( Rebel.IsHumanControlled() == TRUE )
		{
			if(!Rebel.IsInChaosCooldownVolume())
			{
				`log( "There is a rebel NOT in the ChaosCooldownVolume volume!!" @ `showvar(Rebel) );
				// We found one rebel not in a volume - we can exit now leaving it FALSE
				return;
			}
		}
	}

	// All rebels are in volumes  - set bool to TRUE
	bAllRebelsInCooldownVolumes = TRUE;
}


final function float GetTimeChaosLevelLastIncreased()
{
	return TimeChaosLevelLastIncreased;
}




defaultproperties
{
	TickGroup=TG_DuringAsyncWork
	//TimeBetweenUpdates=3.f


	TierAnnouncements[0]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelEliminated_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatch_RebelHasEscaped) // this is our "chaos has reset to zero / player has escaped"


	TierAnnouncements[1]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_One_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatcher_ChaosTierOne)
	TierAnnouncements[2]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_Two_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatcher_ChaosTierTwo)
	TierAnnouncements[3]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_Three_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatcher_ChaosTierThree)
	TierAnnouncements[4]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_Four_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatcher_ChaosTierFour)
	TierAnnouncements[5]=(SoundModeToEnable="Combat_ChaosAnnounce",Hit=SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_Five_Cue',DialogLineWaitTime=1.0f,DispatcherDialogLineID=EDLine_Dispatcher_ChaosTierFive)



/*
1.	SoundMode SoundMode'SoundClassesAndModes.Combat_ChaosAnnounce' is engaged
2.	SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_One_Cue' is played
3.	Wait 1 second to play the trooper's "Hold it right there" challenge line
4.	Wait until SoundCue'Gameplay_Audio.ChaosLevel.ChaosLevelHit_One_Cue' is done playing, then play SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelOneStart_Cue'
5.	SoundMode SoundMode'SoundClassesAndModes.Combat_ChaosAnnounce' is disengaged
*/




	MaxChaosHistorySize=6
	ChaosHistoryDecayTime=6.

	bWorldEventsAffectChaos=TRUE
}

