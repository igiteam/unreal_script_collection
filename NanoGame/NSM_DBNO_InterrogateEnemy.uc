/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_InterrogateEnemy extends NSM_DBNO_InteractionEnemyBase
	config(Pawn);



var name Interrogate_Hit;
var name Interrogate_Threaten;
var name Interrogate_BeNice;

/** This is the reward that we give out for this interrogate (NOTE: should move to pawn) **/
var RewardDatum Reward;

var transient int NumIterrogationsDone;

var config int NumIterrogationsNeeded;

var transient SoundCue SoundCueToPlayVictim;

/** Whether to allow another interrogation button press or not. **/
var transient bool bAllowAnotherInterrogationButtonPress;



function StartInteraction()
{
	Super.StartInteraction();

	AllowAnotherInterrogationButtonPress();

	MyNP.FullBodySlot.PlayCustomAnim( 'CTRL_Interrogate_Idle' , GetSpeedModifier(), 0.1f, 0.1f, TRUE, TRUE );
	//PlayCameraAnim(MyNP, CameraAnim'REB_Owen_Anims.DBNO_Interrogate_Idle',,, 0.25f, -1.0f);		
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(AllowAnotherInterrogationButtonPress), self );

	MyNP.ClearTimer( nameof(KillOffFollowerFromSuccessfulInterrogation), self );

	MyNP.ClearTimer( nameof(PlaySoundCueToPlayVictim), self );

	MyNP.ClearTimer( nameof(HACK_BlendBackToIdle), self );
	Follower.ClearTimer( 'HACK_BlendBackToIdle', Follower.ActiveSpecialMove );
	

	Super.SpecialMoveEnded( PrevMove, NextMove );
}






/** Gives the special move a chance to intercept and trap input.  Returns TRUE if the input should NOT be passed on */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local name AnimToPlay;
	local name AnimToPlayVictim;
	local CameraAnim CameraAnimToPlay;

	// ughh we need a guds type system for this
	local SoundCue SoundCueToPlay;
	local float TimeToPlaySoundCueToPlayVictim;

	local float SpeedMod;

	local float Hack_TimeToPlaySoundCueToPlayVictimStepBack;

	`log( `showvar(NumIterrogationsDone) );


	// kk need to find some temp anims!
	if( bPressed )
	{
		if( bAllowAnotherInterrogationButtonPress == FALSE )
		{
			`log( "Still doing an action.  Input disallowed" );
			return FALSE;
		}



		//`log( ButtonName );
		SpeedMod = 1.0f;


		if( ButtonName == 'Y' )
		{
			AnimToPlay = Interrogate_Hit;
			AnimToPlayVictim = 'DBNO_Interrogate_Torture';
			CameraAnimToPlay = CameraAnim'REB_Owen_Anims.DBNO_Interrogate_Torture';

			SoundCueToPlayVictim = GetInterrogateSoundCue_Victim_Angry();

			Hack_TimeToPlaySoundCueToPlayVictimStepBack = 0.200f;

			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_Hit', MyNP, 0 );
		}
		else if( ButtonName == 'X' )
		{
			AnimToPlay = Interrogate_Threaten;
			AnimToPlayVictim = 'DBNO_Interrogate';
			//SpeedMod = 0.5f;

			SoundCueToPlay = GetInterrogateSoundCue_Threaten();
			SoundCueToPlayVictim = GetInterrogateSoundCue_Victim_Threaten();

			Hack_TimeToPlaySoundCueToPlayVictimStepBack = 0.010f;

			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_Threaten', MyNP, 0 );
		}
		else if( ButtonName == 'B' )
		{
			//AnimToPlay = Interrogate_BeNice;
			SpeedMod = 1.0f;

			//SoundCueToPlay = GetInterrogateSoundCue_Nice();
			//SoundCueToPlayVictim = GetInterrogateSoundCue_Victim_Nice();

			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_BeNice', MyNP, 0 );
		}
		else if( ButtonName == 'A' )
		{
			// drop
			//PlayGrabReleaseAnimation( FALSE );
			Follower.EndSpecialMove();
			MyNP.EndSpecialMove();

			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_Drop', MyNP, 0 );	

			return TRUE;
		}
		else if( ButtonName == 'R2' )
		{
			// execute
			Follower.Died( Follower.ControllerWhoPutMeDBNO, class'NDT_DBNO_Death', Follower.Location );
			NanoGRI(Follower.WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'HeadShot_LyingProne', Follower, Follower.Location, Follower.MomentumThatPutMeDBNO, TRUE );
			MyNP.EndSpecialMove();
			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_Execute', MyNP, 0 );

			return TRUE;
		}


		if( AnimToPlay != '' )
		{
			NumIterrogationsDone++;
			// we store off how long the Player's anim is for cases where we are just going to play a Victim sound
			// this value is overwritten below if there is a Player sound to play
			TimeToPlaySoundCueToPlayVictim = MyNP.FullBodySlot.PlayCustomAnim( AnimToPlay, GetSpeedModifier() * SpeedMod, 0.1f, 0.1f, FALSE, TRUE );
		}

		if( AnimToPlayVictim != '' )
		{
			Follower.FullBodySlot.PlayCustomAnim( AnimToPlayVictim, GetSpeedModifier() * SpeedMod, 0.1f, 0.1f, FALSE, TRUE );
		}
		
		if( CameraAnimToPlay != None )
		{
			//`log( "PLAYING PLAYING" );
			//MyNP.FullBodySlot.PlayCustomAnim( 'CTRL_Interrogate_Torture' , GetSpeedModifier(), 0.1f, 0.1f, FALSE, TRUE );
		//	PlayCameraAnim(MyNP, CameraAnimToPlay,,, 0.25f, 0.25f,,,,, TRUE);			
		}




		// only after we do the last one do we do this and we don't play any audio as the guy is doing to die / give up
		if( NumIterrogationsDone > NumIterrogationsNeeded )
		{
			bAllowAnotherInterrogationButtonPress = FALSE;
			MyNP.SetTimer( TimeToPlaySoundCueToPlayVictim-0.2f, FALSE, nameof(KillOffFollowerFromSuccessfulInterrogation), self );

			return TRUE;
		}


		//// sounds to play!
		if( SoundCueToPlay != None )
		{
			MyNP.PlaySound( SoundCueToPlay );
			TimeToPlaySoundCueToPlayVictim = SoundCueToPlay.GetCueDuration();

			// we don't have a nice guds respond to some event's meta data so we just use a timer for now
			Follower.SetTimer( TimeToPlaySoundCueToPlayVictim, FALSE, nameof(PlaySoundCueToPlayVictim), self );
		}
		// if the victim is just responding
		else if( SoundCueToPlayVictim != None )
		{
			Follower.SetTimer( TimeToPlaySoundCueToPlayVictim, FALSE, nameof(PlaySoundCueToPlayVictim), self );
		}

		// allow for next button press
		bAllowAnotherInterrogationButtonPress = FALSE;
		MyNP.SetTimer( TimeToPlaySoundCueToPlayVictim, FALSE, nameof(AllowAnotherInterrogationButtonPress), self );

		MyNP.SetTimer( TimeToPlaySoundCueToPlayVictim-Hack_TimeToPlaySoundCueToPlayVictimStepBack, FALSE, nameof(HACK_BlendBackToIdle), self );
		Follower.SetTimer( TimeToPlaySoundCueToPlayVictim-Hack_TimeToPlaySoundCueToPlayVictimStepBack, FALSE, 'HACK_BlendBackToIdle', Follower.ActiveSpecialMove );


		return TRUE;
	}


	return FALSE;
}


function KillOffFollowerFromSuccessfulInterrogation()
{
	NanoGRI(MyNP.WorldInfo.GRI).GiveReward( Reward, MyNP.InteractionPawn );

	//`log( "Killing the Follower" @ `showvar(Follower) @ `showvar(Follower.DamageTypeThatPutMeDBNO) );
	//Follower.Died( Follower.ControllerWhoPutMeDBNO, Follower.DamageTypeThatPutMeDBNO, Follower.Location ); // interrogations are always fatal (you killed him with kindness!)
	NanoPawn_Infantry(Follower).DBNO_DurationTilBleedOutDeath = 0.1f;


	MyNP.EndSpecialMove();
	Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Interrogated_Success', MyNP, 0 );

}

function HACK_BlendBackToIdle()
{
	MyNP.FullBodySlot.PlayCustomAnim( 'CTRL_Interrogate_Idle', GetSpeedModifier(), 0.0f, 0.1f, TRUE, TRUE );
}



function PlaySoundCueToPlayVictim()
{
	if( SoundCueToPlayVictim != None )
	{
		Follower.PlaySound( SoundCueToPlayVictim );
		SoundCueToPlayVictim = None;
	}
}


function AllowAnotherInterrogationButtonPress()
{
	bAllowAnotherInterrogationButtonPress = TRUE;
	//MyNP.FullBodySlot.PlayCustomAnim( 'CTRL_Interrogate_Idle' , GetSpeedModifier(), 0.1f, 0.1f, TRUE, TRUE );
	//PlayCameraAnim(MyNP, CameraAnim'REB_Owen_Anims.DBNO_Interrogate_Idle',,, 0.1f, -1.0f, TRUE,,,, TRUE );		
}


/** Animations occur over time and we want hit reactions to occur on hits.  So this is how we handle that! **/
function HandleNanoAnimNotify_DBNO_InterrogationHitReaction()
{
	if( NumIterrogationsDone >= NumIterrogationsNeeded )
	{
		Follower.PlaySound( Follower.DBNOAudio.Impact_Fatal );
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		Follower.PlaySound( Follower.DBNOAudio.Impact_Level3 );
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		Follower.PlaySound( Follower.DBNOAudio.Impact_Level2 );
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		Follower.PlaySound( Follower.DBNOAudio.Impact_Level1 );
	}
}



function SoundCue GetInterrogateSoundCue_Threaten()
{
	if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		return Follower.DBNOAudio.Interrogate_Threaten_Level3;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		return Follower.DBNOAudio.Interrogate_Threaten_Level2;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		return Follower.DBNOAudio.Interrogate_Threaten_Level1;
	}

	return None;
}


function SoundCue GetInterrogateSoundCue_Nice()
{
	if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		return Follower.DBNOAudio.Interrogate_Nice_Level3;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		return Follower.DBNOAudio.Interrogate_Nice_Level2;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		return Follower.DBNOAudio.Interrogate_Nice_Level1;
	}

	return None;
}




function SoundCue GetInterrogateSoundCue_Victim_Angry()
{
	if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Angry_Level3;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Angry_Level2;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Angry_Level1;
	}

	return None;
}



function SoundCue GetInterrogateSoundCue_Victim_Threaten()
{
	if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Threaten_Level3;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Threaten_Level2;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Threaten_Level1;
	}

	return None;
}


function SoundCue GetInterrogateSoundCue_Victim_Nice()
{
	if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.66f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Normal_Level3;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.33f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Normal_Level2;
	}
	else if( NumIterrogationsDone >= ( NumIterrogationsNeeded * 0.00f ) )
	{
		return Follower.DBNOAudio.InterrogateReaction_Normal_Level1;
	}

	return None;
}





defaultproperties
{
	bShouldHolsterCurrentWeapon=TRUE

	FollowerSpecialMoveName="NSM_DBNO_InterrogateVictim"

	AttackerGrabSuccessStartAnim="CTRL_Interrogate_Enter"
	AttackerGrabSuccessLoopAnim="CTRL_Interrogate_Idle"
	AttackerGrabReleaseAnim="CTRL_Interrogate_Idle"
	AttackerGrabEscapeAnim="CTRL_Interrogate_Idle"

	Interrogate_Hit="CTRL_Interrogate_Torture"
	Interrogate_Threaten="CTRL_Interrogate"
	Interrogate_BeNice="Orbitals_Swarm"

	Reward=(CurrencyGained=500,NanoPowerBucketsGained=0,RebelMindShareGained=0,XPGained=0,DataPlan=None,bShouldUnlockPlan=FALSE)


	SeqEvtClassToFire_OnEnd=class'SeqEvt_NanoPawn_DBNO_Interrogated'
}


