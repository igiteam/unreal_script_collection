/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_BeingAimedAt_Base extends NSM_PlaySingleAnim_Base
	abstract;


var array<SoundCue> AimedAtSoundList;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local SoundCue CueToPlay;

	Super.SpecialMoveStarted( bForced, PrevMove );


	if( AimedAtSoundList.Length > 0 )
	{
		CueToPlay = AimedAtSoundList[ Rand( AimedAtSoundList.Length ) ];
		MyNP.PlaySound( CueToPlay );
	}
}


defaultproperties
{
	bAutoPlayAnimation=TRUE

	bLooping=FALSE
	EndTime=0.0f


	//AimedAtSoundList.Add( None )
}