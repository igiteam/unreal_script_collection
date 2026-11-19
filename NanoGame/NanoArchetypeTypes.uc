/**
 * This will hold our all NON native types.  Mostly for archetypes.  But makes it a nice place to dump things
 * where you don't want to constantly recompile C++
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoArchetypeTypes extends Object
	dependson( NanoAutomatedDialogSystem )
	abstract;

enum EMusicEvents
{
	EME_None,
	EME_TrooperSpotAndMoveToIntercept, // Combat Intro
	EME_CombatStarts, // so slick!!  So this is our "generic event"  which will more than likely be "set" by one of the EME_CombatStarts_<tier> data from the ChaosPacifismManager
	EME_PlayerStartsAttackingWithSword,
	EME_PlayerIsHeldByTrooper,
	EME_TrooperArrivesToEngage,
	EME_SlowMotionDeath,
	EME_SlowMotionAttack,
	EME_CombatEnds,

	// add new ones here

	EME_DangerousSituation,

	EME_PlayerEscaping, // looping
	EME_PlayerHiding, // looping
	EME_PlayerRediscovered, // stinger, found by enemies 
	EME_PlayerEscaped, // stinger, player is free from enemies

	EME_CombatStarts_ChaosLevelOne,
	EME_CombatStarts_ChaosLevelTwo,
	EME_CombatStarts_ChaosLevelThree,
	EME_CombatStarts_ChaosLevelFour,
	EME_CombatStarts_ChaosLevelFive,

	EME_PlayerIsRunning,  // inside the HZ but not fighting?

};


// weak here  but we do not want to make N classes all with like one item in it
enum ENanoResponseSystemEvents
{
	ENRS_None,

	ENRS_AttackRadius_Enter,

	ENRS_AttackRadius_StandingIn,

	ENRS_AttackRadius_Leave,


	ENRS_DefenseRadius_Enter,

	ENRS_DefenseRadius_StandingIn,

	ENRS_DefenseRadius_Leave,


	ENRS_ConfrontRadius_Enter,

	ENRS_ConfrontRadius_StandingIn,

	ENRS_ConfrontRadius_Leave,


	ENRS_Chaos_Starts,

	ENRS_Chaos_Increases,

	ENRS_Chaos_Looping_Tier1,
	ENRS_Chaos_Looping_Tier2,

	ENRS_Chaos_Decreases,

	ENRS_Chaos_Ends,


	ENRS_Player_ShouldFleeTheScene,


	ENRS_Dispatcher_FirstResponse,

	ENRS_Dispatcher_SendingReinforcements,

	ENRS_Dispatcher_RebelIsEscaping,

	ENRS_Dispatcher_RebelHasBeenReacquired,

	ENRS_Dispatcher_RebelHasEscaped,

	// add new ones here

	ENRS_NDP_UnderAttack_Triggered,

	ENRS_Dispatcher_RepeatedWarningOfIllicitActivity,

	ENRS_PlayerAttacks_MetaCorp_WhenNoChaos,

};




struct MusicEventDatum
{
	var EMusicEvents EventID;

	// music data
	/** Play only once per event **/
	var() SoundCue Hit;
	/** Music Track to play for this event **/
	var() SoundCue Track;

	var() float TrackFadeInTime;
	var() float TrackFadeOutTime;

	//// constraints for when this event can actually fire

	// time between hits
	var() float DurationBetweenHits;
	var transient float LastTimePlayed;

	// events that can not be fired when this event is active (NOTE:  there needs to be something that will force a fire
	var array<EMusicEvents> DoNotFireTheseEventsWhenActive;

	// some Events want to not play their normal hit but instead play a different one
	var float DurationAfterWhichToPlayOverrideHit; 
	var SoundCue OverrideHit;

	// so we have lots of events coming in.  The issue is that we don't want to constantly ping pong back and forth as it sounds lame
	var array<EMusicEvents> EventsTimeLimitedFromSwitchingOn;
	var float DurationOfNoSameEventsBeforeChangingToAnotherEvent;
	var transient float LastTimeSameEventFired;


	structdefaultproperties
	{
		TrackFadeInTime=2.000f
		TrackFadeOutTime=2.000f
	}

};


struct NanoResponseSystemAudioBankDatum extends MusicEventDatum
{
	// do we need some magic "stops looping when this occurs?"

	/** Sound Mode to enable when this Event is triggered **/
	var Name SoundModeToEnable;

	/** How long to wait after the hit sound plays before playing the dialog lines **/
	var() float DelayAfterHitPlays;

	/** Dispatcher is separate so it can "speak" and then then normal dialog line will play **/
	var() EDialogueLine DispatcherDialogLineID;

	/** How long to wait after dispatcher says something for the DialogLine to be played **/
	var() float ReplyToDispatcherWaitTime;

	/** What a metacorp guy will say.  (Game will find the "best" guy to say the line. **/
	var() EDialogueLine DialogLineID;

};

enum EIconType
{
	EIT_MiniMap,
	EIT_PauseMenuMap,
	EIT_InGameHUDIconFloating,
	EIT_DebugInfo,
	EIT_IRIS,
};



defaultproperties
{

}