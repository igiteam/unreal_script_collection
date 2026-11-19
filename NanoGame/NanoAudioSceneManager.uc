/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAudioSceneManager extends Actor;



enum EPhases
{
	EP_None,
	EP_Normal,
	EP_Danger,
	EP_Chaos,
};

var transient EPhases CurrPhase;

var transient NanoAudioSceneBankDatum CurrDatum;


var transient AudioComponent AC_LoopingSound;

var transient float TimeToPlayNextNonLoopingSound;



var NanoAudioSceneBank ActiveBank;


/** For now just hammer this home **/
var transient bool bPlayerInsideAttackRadius;


var bool bActive;



simulated function Tick( float DeltaTime )
{
	local EPhases Phase;

	Super.Tick( DeltaTime );

	if( bActive == TRUE )
	{
		Phase = DetermineCurrPhase();

		if( Phase != CurrPhase )
		{
			//`log( "NanoAudioSceneManager Switching Phase!" @ `showvar(CurrPhase) @ `showvar(Phase) );

			CurrDatum = GetCorrectDatum( Phase ) ;
			CurrPhase = Phase;

			PlayNewLoopingSound();

			TimeToPlayNextNonLoopingSound = WorldInfo.AudioTimeSeconds + 4.0f; // don't play right away.  Let the new "AudioScene" establish itself

		}


		PossiblyPlayANewNonLoopingSound();
	}

}


function PlayNewLoopingSound()
{
	if( AC_LoopingSound != None )
	{
		AC_LoopingSound.bAutoDestroy = TRUE;
		AC_LoopingSound.bIgnoreForFlushing = FALSE;
		AC_LoopingSound.FadeOut( CurrDatum.AudioScene_FadeOutTime, 0.0f );
	}

	AC_LoopingSound = CreateNewAudioComponent();

	AC_LoopingSound.SoundCue = CurrDatum.Looping_SoundCue;
	AC_LoopingSound.FadeIn( CurrDatum.AudioScene_FadeInTime, 1.0f );


	//`log( "NanoAudioSceneManager" @ `showvar(CurrDatum.Looping_SoundCue) );

}


function PossiblyPlayANewNonLoopingSound()
{
	local SoundCue ToPlay;

	local vector LocationToPlay;

	local Vector2D VolumeRange;
	local float VolumeMultiplier;

	local Vector2D DelayRange;
	local float Delay;

	// here we need to determine if we should play a new NonLooping sound

	if( TimeToPlayNextNonLoopingSound > WorldInfo.TimeSeconds )
	{
		return;
	}

	if( CurrDatum.NonLoopingSounds.Length == 0 )
	{
		return;
	}


	ToPlay = CurrDatum.NonLoopingSounds[ Rand(CurrDatum.NonLoopingSounds.Length) ].TheSound;


	////
	LocationToPlay = DetermineLocationToPlaySound();

	//DrawDebugLine(LocationToPlay+vect(0,0,4000),LocationToPlay,255,0,0,TRUE);

	// just use Default for now
	VolumeRange = CurrDatum.DefaultMetaData.VolumeMultiplierRange;
	VolumeMultiplier = RandRange( VolumeRange.X, VolumeRange.Y );

	ToPlay.VolumeMultiplier *= VolumeMultiplier;


	PlaySound( ToPlay, TRUE, TRUE, TRUE, LocationToPlay, TRUE );

	//// set up when we next should play a sound

	// just use Default for now
	DelayRange = CurrDatum.DefaultMetaData.DelayBeforePlayingRange;
	Delay = RandRange( DelayRange.X, DelayRange.Y );

	TimeToPlayNextNonLoopingSound = WorldInfo.TimeSeconds + ToPlay.Duration + Delay;



	//`log( "NanoAudioSceneManager" @ `showvar(ToPlay) @ `showvar(LocationToPlay) @ `showvar(VolumeMultiplier) @ `showvar(Delay) @ `showvar(TimeToPlayNextNonLoopingSound) );

}



function vector DetermineLocationToPlaySound()
{
	local vector Retval;

	local vector PlayerLocation;
	local Vector2D DistanceRange;


	PlayerLocation = NanoGRI(WorldInfo.GRI).GetPlayerPawn().Location;

	// just use Default for now
	DistanceRange = CurrDatum.DefaultMetaData.DistanceToPlayRange;
	 
	Retval = PlayerLocation + ( VRand() * RandRange( DistanceRange.X, DistanceRange.Y ) );


	return Retval;
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
		AC.bIgnoreForFlushing = FALSE;
	}

	return AC;
}



function EPhases DetermineCurrPhase()
{
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
	{
		return EP_Chaos;
	}

	UpdateIsInsideUnderAttackRadius();
	
	// danger
	if( bPlayerInsideAttackRadius == TRUE )
	{
		return EP_Danger;
	}
	// normal
	else
	{
		return EP_Normal;
	}
}



function NanoAudioSceneBankDatum GetCorrectDatum( const EPhases InPhase )
{

	// determine what phase we are in

	// chaos
	if( InPhase == EP_Chaos )
	{
		return ActiveBank.Chaos;
	}
	// danger
	else if( InPhase == EP_Danger )
	{
		return ActiveBank.Danger;
	}
	// normal
	else
	{
		return ActiveBank.Normal;
	}
}




function UpdateIsInsideUnderAttackRadius()
{
	local vector PlayerLocation;
	local NanoDefensivePoint NDP;

	PlayerLocation = NanoGRI(WorldInfo.GRI).GetPlayerPawn().Location;

	foreach WorldInfo.AllActors(class'NanoDefensivePoint', NDP)
	{
		if( VSize(PlayerLocation - NDP.Location) < NDP.UnderAttackRadius )
		{
			// now check to see if there are AI here as the Player is within the radius
			if( NDP.AreAIWithinDefendRadius() == FALSE )
			{
				continue;
			}

			bPlayerInsideAttackRadius = TRUE;
			break;
		}
		else
		{
			bPlayerInsideAttackRadius = FALSE;
		}
	}

}





defaultproperties
{
	ActiveBank=NanoAudioSceneBank'AudioScenes.DefaultAudioScene'
	bActive=FALSE
}