/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_CowerInFear extends NSM_PlaySingleAnim_Base;


var array<SoundCue> CowerSoundList;

var transient float NextCowerSoundTime;


var float MinTimeForCower;

var transient float TimeStartedCowering;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	TimeStartedCowering = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.DoSpecialMove( 'NSM_ShakeItOff', TRUE );
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	PossiblyPlayCowerSound();


	// so if we are hurt then we need to End this SpecialMove and
	// let the AI ticking take over again
	if( ( MyNP.Health < (MyNP.default.DefaultHealth * 0.70f) ) 
		&& ( `TimeSinceEx(MyNP,TimeStartedCowering) > MinTimeForCower )
		)
	{
		`log( "END END SPECIAL MOVE!" );
		MyNP.EndSpecialMove();
	}
}


function PossiblyPlayCowerSound()
{
	local SoundCue CueToPlay;
	local float CueLength;

	if( NextCowerSoundTime < MyNP.WorldInfo.TimeSeconds )
	{
		CueToPlay = CowerSoundList[ Rand( CowerSoundList.Length ) ];
		MyNP.PlaySound( CueToPlay );
		//`log( "Played" @ `showvar(CueToPlay) );

		CueLength = CueToPlay.GetCueDuration();

		NextCowerSoundTime = MyNP.WorldInfo.TimeSeconds + CueLength + Rand(5);

	}
}





DefaultProperties
{
	bAutoPlayAnimation=TRUE

	AnimName="NW_Summon_Generic_Loop"
	bLooping=TRUE
	EndTime=0.0f

	bDisableMovement=TRUE
	RootMotionScaleFactor=0.0f

	CowerSoundList.Add( SoundCue'Mission_Audio.Nightclub.club_person_onknees_plead_cue' )


	MinTimeForCower=0.500f
}
