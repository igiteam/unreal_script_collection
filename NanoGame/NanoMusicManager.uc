/**
 *
 *
 * we probably want a "null" sound to play that will end things (like the combat end)
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoMusicManager extends Actor
	config(Game);

/** Whether or not the music manager is enabled (nice to turn off when you want to listen to your own music) **/
var config bool bMusicManagerEnabled;

var config bool bMusicManagerLoggingEnabled;





var() array<MusicEventDatum> MusicEventData;


/** There are the play one time right as the track starts.  Need to be separate atm due to the sound cue not correctly looping **/
//var array<SoundCue> MusicTrackHits;

/** Actual tracks **/
//var array<SoundCue> MusicTracks;


var transient AudioComponent AC_Track1;
var transient AudioComponent AC_Track2;
var transient SoundCue CurrPlayingTrack;
var transient SoundCue LastPlayedHit;

/** Constantly playing tracks **/
//var transient AudioComponent AC_EnemyTrack;
//var transient AudioComponent AC_PlayerTrack;


var transient EMusicEvents CurrMusicEventID;


`define music_log(msg) `if(`notdefined(FINAL_RELEASE)) `loginfo('Nano_Music',WorldInfo.TimeSeconds@`msg) `endif


function PostBeginPlay()
{
	Super.PostBeginPlay();

	AC_Track1 = CreateNewAudioComponent();
	AC_Track2 = CreateNewAudioComponent();
}


/** Creates a new MusicTrack Audio Component **/
function AudioComponent CreateNewAudioComponent()
{
	local AudioComponent AC;

	AC = new(self) class'AudioComponent';

	if( AC != None )
	{
		AC.bStopWhenOwnerDestroyed = TRUE;
		AC.bAllowSpatialization = FALSE;
		AC.bShouldRemainActiveIfDropped = TRUE;
		AC.bIsMusic = TRUE;
		AC.bAlwaysPlay = TRUE;
		//AC.bIgnoreForFlushing = TRUE;
		AttachComponent( AC );
	}

	return AC;
}


function ClearLastPlayedHit()
{
	LastPlayedHit = none;
}

final function DebugTracks()
{
	`music_log( `showvar(AC_Track1.IsPlaying()) @ `showvar(AC_Track1.SoundCue) @ `showvar(AC_Track2.IsPlaying()) @ `showvar(AC_Track2.SoundCue) );
}


/** The game will call this function with the event it wants to have music played for **/
// @todo:  fix up the crazy [] operator usage
function HandleMusicEvent( EMusicEvents InEvent, optional SoundCue CustomHit, optional SoundCue CustomTrack )
{
	local SoundCue Hit;
	local SoundCue Track;
	local bool bShouldPlayHit;
	local AudioComponent AC_HitSound;

	if( bMusicManagerEnabled == FALSE )
	{
		return;
	}

	// check to see if the worldstate settings wants this off
	if( NanoGRI(WorldInfo.GRI).WorldStateSettings.bMusicManagerEnabled == FALSE )
	{
		return;
	}

	// if the CurrMusicEventID does not allow the new event to fire then just return
	if( MusicEventData[ CurrMusicEventID ].DoNotFireTheseEventsWhenActive.Find( InEvent ) != INDEX_NONE )
	{
		`music_log( `showvar(CurrMusicEventID) @ "does not allow" @ InEvent @ "to fire" );
		DebugTracks();
		return;
	}


	// set if this same event is being fired while we are actively fulfilling it
	if( ( CurrMusicEventID == InEvent ) && ( MusicEventData[ CurrMusicEventID ].Track == CurrPlayingTrack ) )
	{
		MusicEventData[ CurrMusicEventID ].LastTimeSameEventFired = WorldInfo.TimeSeconds;
	}


	// so if we keep getting the same events over and over we don't want to switch to another event as that is ping ponging
	// so wait until we have not received any new events before allowing a switch
	if( ( MusicEventData[ CurrMusicEventID ].DurationOfNoSameEventsBeforeChangingToAnotherEvent > 0.0f )
		&& ( `TimeSince(MusicEventData[ InEvent ].LastTimeSameEventFired) < MusicEventData[ CurrMusicEventID ].DurationOfNoSameEventsBeforeChangingToAnotherEvent )
		&& ( MusicEventData[ CurrMusicEventID ].EventsTimeLimitedFromSwitchingOn.Find( InEvent ) != INDEX_NONE )
		)
	{
		`music_log( `showvar(CurrMusicEventID) @ "does not allow" @ InEvent @ "to fire due to not long enough time has passed!" );
		return;
	}

	// check for custom hit and use that
	if( CustomHit != none )
	{
		Hit = CustomHit;
	}
	else
	{
		if( ( InEvent == CurrMusicEventID )
			&& ( `TimeSince(MusicEventData[ InEvent ].LastTimePlayed) < MusicEventData[ InEvent ].DurationAfterWhichToPlayOverrideHit )
			&& ( MusicEventData[ InEvent ].OverrideHit != none )
			)
		{
			`music_log( "Playing override for Event:" @ `showvar(InEvent) @ `showvar(MusicEventData[ InEvent ].OverrideHit) );
			Hit = MusicEventData[ InEvent ].OverrideHit;
		}
		else
		{
			Hit = MusicEventData[ InEvent ].Hit;
		}
	}


	// check for custom track and use that
	if( CustomTrack != none )
	{
		Track = CustomTrack;
	}
	else
	{
		Track = MusicEventData[ InEvent ].Track;
	}



	if( bMusicManagerLoggingEnabled == TRUE )
	{
		`music_log( "  HandleMusicEvent" @ `showvar(InEvent) @ `showvar(Hit) @ `showvar(Track) @ `showvar(AC_Track1.IsPlaying()) @ `showvar(AC_Track1.SoundCue) @ `showvar(AC_Track1.VolumeMultiplier) @ `showvar(AC_Track2.IsPlaying()) @ `showvar(AC_Track2.SoundCue) @ `showvar(AC_Track2.VolumeMultiplier)  );
		//ScriptTrace();
	}

	// always play the hit if it exists
	if( Hit != none )
	{
		bShouldPlayHit = TRUE;

		// if we should wait between hits
		if( MusicEventData[ InEvent ].DurationBetweenHits > 0.0f )
		{
			// and enough time has not passed then mark as do not play hit
			if( `TimeSince(MusicEventData[ InEvent ].LastTimePlayed) < MusicEventData[ InEvent ].DurationBetweenHits )
			{
				bShouldPlayHit = FALSE;
			}
		}
		// always register the "hit" so if we are constantly getting a specific hit (e.g. from a player sword attack) we
		// don't just play hits over and over and over  (the actual combat efforts and hits should be amazing enough to hear and
		// not need constant music)
		MusicEventData[ InEvent ].LastTimePlayed = WorldInfo.TimeSeconds;

		if( bShouldPlayHit == TRUE )
		{
			if( bMusicManagerLoggingEnabled == TRUE )
			{
				`music_log( "----> PLAYING HIT: " @ Hit );
			}

			// we have to make our own AC here as PlaySound can get dropped and this HitSound is sort of "music" and it should never be dropped
			AC_HitSound = CreateNewAudioComponent();
			AC_HitSound.bAutoDestroy = TRUE;
			AC_HitSound.SoundCue = Hit;
			AC_HitSound.Play();
			//PlaySound( Hit );
			LastPlayedHit = Hit;
		}
	}


	// don't allow same event track switching
	if( ( CurrMusicEventID == InEvent ) && ( MusicEventData[ CurrMusicEventID ].Track == CurrPlayingTrack ) )
	{
		`music_log( "=======> CurrMusicEventID == InEvent  && MusicEventData[ CurrMusicEventID ].Track == CurrPlayingTrack    Returning" @ InEvent );
		return;
	}

	
	// now go ahead and flip flop between tracks with the track if there is one
	// otherwise keep playing the current one
	if( Track != none )
	{
		// we are going to play or already playing this event now so go ahead and set it
		CurrMusicEventID = InEvent;

		// fade out the main music
		if( CurrMusicEventID != EME_CombatEnds )
		{
			//AC_EnemyTrack.VolumeMultiplier = 0.0f;
			//AC_PlayerTrack.VolumeMultiplier = 0.0f;
		}


		// we are playing a new track so go ahead and cross fade
		if( ( AC_Track1.IsPlaying() == FALSE ) || ( AC_Track1.FadeOutStopTime != -1.0f ) )
		{
			AC_Track1 = CreateNewAudioComponent();
			AC_Track1.SoundCue = Track;
			AC_Track1.FadeIn( MusicEventData[ InEvent ].TrackFadeInTime, 1.0f );
			CurrPlayingTrack = AC_Track1.SoundCue;
			`music_log( "----> Playing AC_Track1" @ AC_Track1.SoundCue );

			AC_Track2.FadeOut( MusicEventData[ InEvent ].TrackFadeOutTime, 0.0f );
		}
		else if( ( AC_Track2.IsPlaying() == FALSE ) || ( AC_Track2.FadeOutStopTime != -1.0f ) )
		{
			AC_Track2 = CreateNewAudioComponent();
			AC_Track2.SoundCue = Track;
			AC_Track2.FadeIn( MusicEventData[ InEvent ].TrackFadeInTime, 1.0f );
			CurrPlayingTrack = AC_Track2.SoundCue;
			`music_log( "----> Playing AC_Track2" @ AC_Track2.SoundCue );


			AC_Track1.FadeOut( MusicEventData[ InEvent ].TrackFadeOutTime, 0.0f );
		}
		else
		{
			`warn( "Badness both AC tracks are playing" );
		}
	}

}


function Tick(float DeltaTime)
{
	Super.Tick( DeltaTime );

	// check to see if we are ending combat.  If we are then fade out the 2 main tracks
	if( ( CurrMusicEventID == EME_CombatEnds ) && ( ( AC_Track1.VolumeMultiplier > 0.0f ) || ( AC_Track2.VolumeMultiplier > 0.0f ) ) )
	{
		AC_Track1.VolumeMultiplier = FInterpTo( AC_Track1.VolumeMultiplier, 0.0f, DeltaTime, 2 );
		AC_Track2.VolumeMultiplier = FInterpTo( AC_Track2.VolumeMultiplier, 0.0f, DeltaTime, 2 );
		`music_log( "EME_CombatEnds" @ `showvar(AC_Track1.VolumeMultiplier) @ `showvar(AC_Track2.VolumeMultiplier) );
	}

	//`music_log( "TRACK 1" @ `showvar(AC_Track1) @ `showvar(AC_Track1.SoundCue) @ `showvar(AC_Track1.IsPlaying()) @`showvar(AC_Track1.VolumeMultiplier)  );
	//`music_log( "TRACK 2" @ `showvar(AC_Track2) @`showvar(AC_Track2.SoundCue) @ `showvar(AC_Track2.IsPlaying()) @ `showvar(AC_Track2.VolumeMultiplier) );

}



/** The game will call this function with the event it wants to have music played for **/
function UpdateMusicEvent( EMusicEvents InEvent, optional SoundCue NewHit, optional SoundCue NewTrack, optional float NewTrackFadeInTime, optional float NewTrackFadeOutTime, optional bool bResetToDefaults )
{

	//`log( "AHHHHH  InEvent" @ `showvar(InEvent) );

	if( bResetToDefaults == TRUE )
	{
		MusicEventData[InEvent].Hit = default.MusicEventData[InEvent].Hit;
		MusicEventData[InEvent].Track =  default.MusicEventData[InEvent].Track;
		MusicEventData[InEvent].TrackFadeInTime =  default.MusicEventData[InEvent].TrackFadeInTime;
		MusicEventData[InEvent].TrackFadeOutTime =  default.MusicEventData[InEvent].TrackFadeOutTime;
	}
	else
	{
		MusicEventData[InEvent].Hit = NewHit;
		MusicEventData[InEvent].Track = NewTrack;
		MusicEventData[InEvent].TrackFadeInTime = NewTrackFadeInTime;
		MusicEventData[InEvent].TrackFadeOutTime = NewTrackFadeOutTime;


		//`log( `showvar(InEvent) @ `showvar(NewHit) @ `showvar(NewTrack) @ `showvar(NewTrackFadeInTime) @ `showvar(NewTrackFadeOutTime) );

		// for "ending' we always need a cue that will fade to nothing to set it if 
		// user has made an error
		if( ( InEvent == EME_CombatEnds ) && ( NewTrack == none ) )
		{
			MusicEventData[InEvent].Track = SoundCue'Music_Temp2.NullSoundCue';
		}
	}
}



defaultproperties
{
	RemoteRole=ROLE_None
	bHidden=TRUE


/*
	MusicTrackHits(EME_None)=None
	MusicTrackHits(EME_TrooperSpotAndMoveToIntercept)=None
	MusicTrackHits(EME_CombatStarts)=SoundCue'Music_Temp.Combat.Combat_01_PlayerStarts_HitCue'
	MusicTrackHits(EME_PlayerStartsAttackingWithSword)=SoundCue'Music_Temp.Combat.Combat_01_Begin_HitCue' 
	MusicTrackHits(EME_PlayerIsHeldByTrooper)=SoundCue'Music_Temp.Combat.Combat_01_Held_HitCue'
	MusicTrackHits(EME_TrooperArrivesToEngage)=SoundCue'Music_Temp.Combat.Combat_01_MoreEnemiesCue' 
	MusicTrackHits(EME_SlowMotionAttack)=SoundCue'Music_Temp.Combat.Combat_01_SlomoCue' // Slow motion hit (begins at start of slow motion, when slow motion ends play SoundCue'Music_Temp.Combat.Combat_01_Begin_HitCue' or Combat ends cue
	MusicTrackHits(EME_CombatEnds)=SoundCue'Music_Temp.Combat.Combat_01_EndCue' 

	MusicTracks(EME_None)=None
	MusicTracks(EME_TrooperSpotAndMoveToIntercept)=SoundCue'Music_Temp.Combat.Combat_01_IntroCue'
	MusicTracks(EME_CombatStarts)=SoundCue'Music_Temp.Combat.Combat_01_Starts_LoopCue' 
	MusicTracks(EME_PlayerStartsAttackingWithSword)=SoundCue'Music_Temp.Combat.Combat_01_PlayerStarts_LoopCue'
	MusicTracks(EME_PlayerIsHeldByTrooper)=SoundCue'Music_Temp.Combat.Combat_01_Held_LoopCue' 
	MusicTracks(EME_TrooperArrivesToEngage)=None
	MusicTracks(EME_SlowMotionAttack)=SoundCue'Music_Temp2.NullSoundCue'
	MusicTracks(EME_CombatEnds)=SoundCue'Music_Temp2.NullSoundCue'
*/


	// music data
	MusicEventData(EME_None)=(Hit=None, Track=SoundCue'Music_Temp2.NullSoundCue', DurationBetweenHits=5.0f, DoNotFireTheseEventsWhenActive=())
	
	//Track=SoundCue'Music_Temp.Combat.Combat_01_IntroCue'
	MusicEventData(EME_TrooperSpotAndMoveToIntercept)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())
	
	//Track=SoundCue'Music_Temp.Combat.Combat_01_Starts_LoopCue'
	MusicEventData(EME_CombatStarts)=(Hit=None, Track=None, DurationBetweenHits=5.0f, DoNotFireTheseEventsWhenActive=(), DurationAfterWhichToPlayOverrideHit=5.0f, OverrideHit=None)

	//Track=SoundCue'Music_Temp.Combat.Combat_01_Starts_LoopCue'
	MusicEventData(EME_PlayerStartsAttackingWithSword)=(Hit=None, Track=None, DurationBetweenHits=5.0f, DoNotFireTheseEventsWhenActive=(), DurationAfterWhichToPlayOverrideHit=5.0f, OverrideHit=None) // (Hit=SoundCue'Music_Temp.Combat.Combat_01_PlayerStarts_HitCue', Track=SoundCue'Music_Temp.Combat.Combat_01_PlayerStarts_LoopCue', DurationBetweenHits=5.0f, DoNotFireTheseEventsWhenActive=(), EventsTimeLimitedFromSwitchingOn=(EME_CombatStarts), DurationOfNoSameEventsBeforeChangingToAnotherEvent=10.0f )

	//Track=SoundCue'Music_Temp.Combat.Combat_01_Held_HitCue'
	MusicEventData(EME_PlayerIsHeldByTrooper)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=(EME_TrooperSpotAndMoveToIntercept,EME_CombatStarts,EME_TrooperArrivesToEngage))

	MusicEventData(EME_TrooperArrivesToEngage)=() //(Hit=SoundCue'Music_Temp.Combat.Combat_01_MoreEnemiesCue', Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())
	
	//Hit=SoundCue'Music_Temp.Combat.Combat_01_SlomoCue'
	MusicEventData(EME_SlowMotionDeath)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=(), EventsTimeLimitedFromSwitchingOn=(EME_CombatStarts), DurationOfNoSameEventsBeforeChangingToAnotherEvent=0.0f )
	
	//SoundCue'Music_Temp.Combat.Combat_01_SlomoWorldCue'
	MusicEventData(EME_SlowMotionAttack)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=(), EventsTimeLimitedFromSwitchingOn=(EME_CombatStarts), DurationOfNoSameEventsBeforeChangingToAnotherEvent=0.0f )

	//Hit=SoundCue'Music_Temp.Combat.Combat_01_EndCue'
	MusicEventData(EME_CombatEnds)=(Hit=None, Track=SoundCue'Music_Temp2.NullSoundCue', DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())
	

	MusicEventData(EME_DangerousSituation)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_PlayerEscaping)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_PlayerHiding)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_PlayerRediscovered)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_PlayerEscaped)=(Hit=None, Track=SoundCue'Music_Temp2.NullSoundCue', DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())
	
	
	MusicEventData(EME_CombatStarts_ChaosLevelOne)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_CombatStarts_ChaosLevelTwo)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_CombatStarts_ChaosLevelThree)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_CombatStarts_ChaosLevelFour)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_CombatStarts_ChaosLevelFive)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())

	MusicEventData(EME_PlayerIsRunning)=(Hit=None, Track=None, DurationBetweenHits=0.0f, DoNotFireTheseEventsWhenActive=())


}


