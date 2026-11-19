/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoResponseSystemAudioManager extends Actor;

// QUESTIONS:
//
// No idea how this works with music??!?!  
//
//
//
//



var NanoResponseSystemAudioBank ActiveBank;



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
		AC.bIgnoreForFlushing = TRUE;
	}

	return AC;
}


function PlaySingleSound( const SoundCue ToPlay )
{
	local AudioComponent AC;

	AC = CreateNewAudioComponent();
	AC.bAutoDestroy = TRUE;
	AC.bIgnoreForFlushing = FALSE;
	AC.SoundCue = ToPlay;
	AC.Play();
}




function PlayEvent( ENanoResponseSystemEvents ID, Actor ActorToPlayOn )
{

	//`log( "PlayEvent: " @ `showvar(ID) @ `showvar(ActiveBank.Events[ ID ].Hit) @ `showvar(ActiveBank.Events[ ID ].DispatcherDialogLineID) @ `showvar(ActiveBank.Events[ ID ].ReplyToDispatcherWaitTime) @ `showvar(ActiveBank.Events[ ID ].DialogLineID) );


	if( (  ActiveBank.Events[ ID ].LastTimePlayed != 0.0f )
		&& `TimeSince(ActiveBank.Events[ ID ].LastTimePlayed) < ActiveBank.Events[ ID ].DurationBetweenHits )
	{
		//`log( "Not enough time has passed.  Only" @ `TimeSince(ActiveBank.Events[ ID ].LastTimePlayed) @ " but needed:" @ `showvar(ActiveBank.Events[ ID ].DurationBetweenHits) );
		return;
	}



	if( ActiveBank.Events[ ID ].Hit != None )
	{
		PlaySingleSound( ActiveBank.Events[ ID ].Hit );
	}



	// NOTE:  non funtional for certain case
	// so this will not work if there is are two delays.
	// as then we need to have the DelayedComp also do the the same trick :-(


	if( ActiveBank.Events[ ID ].DispatcherDialogLineID != EDLine_None )
	{
		if( ActiveBank.Events[ ID ].DelayAfterHitPlays > 0.0f )
		{
			CreateAndSpawnADelayedComp( ActiveBank.Events[ ID ].DelayAfterHitPlays, ActiveBank.Events[ ID ].DispatcherDialogLineID, ActorToPlayOn );
		}
		else
		{
			NanoGRI(WorldInfo.GRI).NADS.AttemptToPlayLine( ActiveBank.Events[ ID ].DispatcherDialogLineID, ActorToPlayOn );
		}		
	}


	if( ActiveBank.Events[ ID ].DialogLineID != EDLine_None )
	{
		if( ActiveBank.Events[ ID ].ReplyToDispatcherWaitTime > 0.0f )
		{
			CreateAndSpawnADelayedComp( ActiveBank.Events[ ID ].ReplyToDispatcherWaitTime, ActiveBank.Events[ ID ].DialogLineID, ActorToPlayOn );
		}
		else
		{
			NanoGRI(WorldInfo.GRI).NADS.AttemptToPlayLine( ActiveBank.Events[ ID ].DialogLineID, ActorToPlayOn );
		}				
	}

	ActiveBank.Events[ ID ].LastTimePlayed = WorldInfo.TimeSeconds;

}


function CreateAndSpawnADelayedComp( float Delay, EDialogueLine ID, Actor ActorToPlayOn )
{
	local DelayedResponseAudioSystemComponent DelayedComp;

	DelayedComp = new(self) class'DelayedResponseAudioSystemComponent';

	DelayedComp.DialogLineID = ID;
	DelayedComp.ActorToPlayOn = ActorToPlayOn;
	AttachComponent( DelayedComp );

	SetTimer( FMax(Delay,0.001f), FALSE, nameof(DelayedComp.DoIt), DelayedComp );

	//`log( WorldInfo.TimeSeconds @ "waiting" @ FMax(Delay,0.001f) @ " to fire" @ DelayedComp.DialogLineID @ "on" @ DelayedComp.ActorToPlayOn );

}



defaultproperties
{
	ActiveBank=NanoResponseSystemAudioBank'ResponseSystemBanks.DefaultBank'

}