/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGameCrowdBehavior_RunFromPanic extends GameCrowdBehavior_RunFromPanic
	placeable;

/** The set of sound cues that will be used to randomly choose a cue to play. **/
var() array<SoundCue> SoundListToPlayOnFirstPanic;

/** How often we will play a sound when a crowd first become panicked **/
var() float TimeBetweenSoundOnFirstPanic;

/** So we can get lots of panicked crowd guys.  We only really want to play a sound if we are close to a player tho. **/
var float DistanceToPlayerToAllowForSoundToPlay;


function InitBehavior(GameCrowdAgent Agent)
{
	local SoundCue CueToPlay;
	local NanoGRI NGRI;
	local float DistToPlayer;

	Super.InitBehavior(Agent);


	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);

	DistToPlayer = VSize(NGRI.GetPlayerPawn().Location - MyAgent.Location);


	// check to see if we should play a sound when first becoming panicked
	if( ( SoundListToPlayOnFirstPanic.Length > 0 )
		&& ( `TimeSinceEx(NGRI, NGRI.LastCrowdPanicSoundOnFirstPanic) > TimeBetweenSoundOnFirstPanic )
		&& ( DistToPlayer < DistanceToPlayerToAllowForSoundToPlay )
		)
	{
		CueToPlay = SoundListToPlayOnFirstPanic[ Rand( SoundListToPlayOnFirstPanic.Length ) ];

		MyAgent.PlaySound ( CueToPlay );

		NGRI.LastCrowdPanicSoundOnFirstPanic = NGRI.WorldInfo.TimeSeconds;
	}

}



DefaultProperties
{
	TimeBetweenSoundOnFirstPanic=3.0f
	DistanceToPlayerToAllowForSoundToPlay=1500.0f


	SoundListToPlayOnFirstPanic.Add( SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_Plead_01_Cue' )
	SoundListToPlayOnFirstPanic.Add( SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_Plead_02_Cue' )
	SoundListToPlayOnFirstPanic.Add( SoundCue'Mission_Audio.Nightclub.club_person_gunout_plead_cue' )
	SoundListToPlayOnFirstPanic.Add( SoundCue'Mission_Audio.Nightclub.club_person_onknees_plead_cue' )
}

