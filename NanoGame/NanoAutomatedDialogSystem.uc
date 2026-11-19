/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAutomatedDialogSystem extends Actor;



enum EDialogueLine
{
	EDLine_None,

	EDLine_NanoPowerWitness,
	EDLine_StopPlayer,

	EDLine_OpenFire,

	EDLine_TrooperKilled,

	EDLine_SightPlayerFromDistance, // Soldier spots player from distance in the city, orders them to stop. 
	EDLine_LostSightOfPlayerFromDistance, // Soldier loses player from distance in the city, calls out to squad. 
	EDLine_PursuePlayerInCombat, // The player runs away from combat, and the troopers move to chase.

	EDLine_Search_LookingForPlayer, // Troopers cannot find player, and begin looking for her.
	EDLine_Search_FoundPlayer, // Troopers find player after losing contact with them, determined to continue the fight.
	EDLine_Search_GiveUpSearch,  // Troopers cannot find player, call in status to HQ.
	EDLine_ChallengePlayer, // Soldier moves to stop player, tells them they're under arrest.  


	EDLine_Combat_DodgeSprint,// React to Player Dodge sprint, any Circle

	EDLine_Combat_SwitchToFireArms, // Stun batons/melee isn't working, commands squad to use firearms.
	EDLine_Combat_SwitchingToBatons, // Switching to Batons at 2048 units, entering circle



	EDLine_Combat_MeleeCircle_Commence, // Time to make an insolent criminal pay for their disobedience.  This is going to hurt.
	EDLine_Combat_MeleeCircle_SustainedBattle, // Mildly surprised that they haven't won yet;
	EDLine_Combat_MeleeCircle_GhostWhiff, // Hostile swings baton at player, gets only air due to Ghost.
	EDLine_Combat_MeleeCircle_DodgeWhiff, // Hostile swings baton at player, gets only air due to Dodge.
	EDLine_Combat_MeleeCircle_HoldPlayer, // Troopers manage to restrain player.  Player tries to break free.
	EDLine_Combat_MeleeCircle_ThrownByPlayer, // Player escapes by throwing enemy holding them.

	EDLine_Combat_MeleeCircle_PlayerDied, // Player is defeated, Inner Circle The fight is over, their target is neutralized.


	EDLine_Combat_StandbyCircle_SustainedBattle,  // // Mildly surprised that they haven't won yet;

	EDLine_Combat_StandbyCircle_SawBuddyGetHit,  // Saw buddy get Hit, Middle Circle
	EDLine_Combat_StandbyCircle_SawBuddyGetTackled, // Saw buddy get tackled, Middle circle
	EDLine_Combat_StandbyCircle_EnteringMeleeCircle, // Trooper is "around the fighting circle", but only just now became an active participant i.e. was waiting for his turn to jump in
	EDLine_Combat_StandbyCircle_LastTrooperFromStandByEnteringMelee,  // Call for backup, last enemy in Middle Circle enters Inner Circle

	EDLine_Combat_SpectatorCircle_TauntPlayer, // Taunt Player, from outer circle
	EDLine_Combat_SpectatorCircle_SeesBuddyDie,  // React to Man Down, Outer Circle Trooper sees a buddy die; he is angry and a little afraid, promises retribution.
	EDLine_Combat_SpectatorCircle_PlayerDied, // Player is defeated, Outer Circle The fight is over, their target is neutralized.
	EDLine_Combat_Fleeing, // Flee, Last Surviving Combatant Very worried after seeing their buddies die; they try to get away until backup arrives.

	EDLine_Combat_ChargeAttack, // when the charge attack is initiated

	EDLine_PoliceCar_ReportIn, // when a cop car reports in while on patrol
	EDLine_PoliceCar_SpotPawn, // when a cop car spots the pawn and begins pursuit
	EDLine_PoliceCar_SpotPawnNotInCombat, // when a cop car spots the player and combat is not already active
	EDLine_PoliceCar_LostPawn, // when a cop car loses sight of the target
	EDLine_PoliceCar_ShotAt,   // when a cop car gets shot by a player
	EDLine_PoliceCar_ShotDown, // when a cop car is killed by the player



	EDLine_NDP_AttackRadius_Enter,
	EDLine_NDP_AttackRadius_StandingIn,
	EDLine_NDP_AttackRadius_Leave,

	EDLine_NDP_AttackRadius_UnderAttack_Triggered,

	EDLine_PlayerAttacks_MetaCorp_WhenNoChaos,


	EDLine_Dispatch_ChallengeReminder,
	EDLine_Dispatch_RebelIsEscaping,
	EDLine_Dispatch_RebelHasEscaped,
	
	EDLine_Dispatcher_ChaosTierOne,
	EDLine_Dispatcher_ChaosTierTwo,
	EDLine_Dispatcher_ChaosTierThree,
	EDLine_Dispatcher_ChaosTierFour,
	EDLine_Dispatcher_ChaosTierFive,

	EDLine_ChallengePlayer_DropYourWeapon,
	EDLine_Combat_RequestingBackup,

	EDLine_MAX
};

struct DialogueInfo
{
	var() EDialogueLine Line;
	/** List of sound cues to pick for this line */
	var() array<SoundCue> Cues;
	/** Duration to prevent this cue from being played again on this component */
	var() float LockoutDuration;
	/** Last time this cue was successfully played */
	var transient float LastPlayTime;

	/** So for this guy we are going to have to reset the sound mode. **/
	var bool bIsDispatcher;
};
var() editinline array<DialogueInfo> DialogueLines;

struct SpeakerInfo
{
	var Actor Speaker;
	var float TimeWhenFinishedSpeaking;

	// next line to speak as we were still speaking when a request came in
	//var() EDialogueLine NextLine;
};
// NOTE:  this seems to keep people around in the list even if they are killed off  So we have to depend on GC to clean it up
var transient array<SpeakerInfo> DialogueSpeakers;


struct SharedDialogueInfo
{
	var() array<EDialogueLine> Lines;
};
var() editinline array<SharedDialogueInfo> SharedDialogueLines;



function bool AttemptToPlayLine(EDialogueLine LineToPlay, Actor ActorToPlayOn)
{
	local SharedDialogueInfo SDI;
	local EDialogueLine EDL;

	local int LineIdx, SpeakerIdx;
	local SoundCue CueToPlay;
	local bool bValidFromSharedDialogueLines;
	local bool bValidLastPlayTime;
	local bool bFoundLineInSharedDialogueLines;


	if( ActorToPlayOn == None )
	{
		ActorToPlayOn = NanoGRI(WorldInfo.GRI).GetNanoPC();
	}


	bValidFromSharedDialogueLines = TRUE;

	// here we need to check to see if we have a "shared" LockoutDuration between multiple lines
	// so we just look at all of the shared lines and then for each EDLine_ we look it up and see when it was last played
	// if any of the shared EDLines_ for a specific shared line fail then we do not allow the LineToPlay to play
	foreach SharedDialogueLines( SDI )
	{
		// look for the passed in LineToPlay in this SharedDialogueLines's Lines
		foreach SDI.Lines( EDL )
		{
			if( EDL == LineToPlay ) 
			{
				bFoundLineInSharedDialogueLines = TRUE;
				break;;
			}
		}

		// now test all of this SharedDialogueLines's Lines (since the LineToPlay is a member) to see if any of them can't be played
		if( bFoundLineInSharedDialogueLines == TRUE )
		{
			foreach SDI.Lines( EDL )
			{
				LineIdx = DialogueLines.Find('Line',EDL);

				// if this line exists in this EDL
				if( LineIdx != INDEX_NONE ) 
				{
					if( DialogueLines[LineIdx].LastPlayTime == 0.0f || `TimeSince(DialogueLines[LineIdx].LastPlayTime) > DialogueLines[LineIdx].LockoutDuration )
					{
					}
					else
					{
						`loginfo('Nano_NADS', `showvar(LineToPlay) @ "       Not being allowed to play as" @ EDL @ "is locked out." @ `TimeSince(DialogueLines[LineIdx].LastPlayTime)  @ DialogueLines[LineIdx].LockoutDuration );
						bValidFromSharedDialogueLines = FALSE;
						break;
					}
				}
			}
		}

		bFoundLineInSharedDialogueLines = FALSE;
	}

	// So now go ahead and grab the LineIdx we are going to use
	LineIdx = DialogueLines.find('Line',LineToPlay);

	// we didn't find the line in the SharedDialog lines so we still need to actually check it
	if( bValidFromSharedDialogueLines == TRUE )
	{
		if (LineIdx != INDEX_NONE && (DialogueLines[LineIdx].LastPlayTime == 0.0f || `TimeSince(DialogueLines[LineIdx].LastPlayTime) > DialogueLines[LineIdx].LockoutDuration))
		{
			bValidLastPlayTime = TRUE;
		}
	}


	// so if we passed!  Let's go ahead and play the line
	if( ( LineIdx != INDEX_NONE ) && ( bValidLastPlayTime == TRUE ) )
	{
		SpeakerIdx = DialogueSpeakers.Find('Speaker',ActorToPlayOn);
		if (SpeakerIdx != INDEX_NONE && WorldInfo.TimeSeconds < DialogueSpeakers[SpeakerIdx].TimeWhenFinishedSpeaking )
		{
			// still talking, no luck
			`loginfo('Nano_NADS', "Not playing: " @ `showvar(LineToPlay) @ `showvar(ActorToPlayOn) @ "As still speaking for:" @ DialogueSpeakers[SpeakerIdx].TimeWhenFinishedSpeaking - WorldInfo.TimeSeconds );
			return FALSE;
		}
		else if (SpeakerIdx != INDEX_NONE)
		{
			DialogueSpeakers.Remove(SpeakerIdx,1);
		}
	
		// pick a cue to play
		CueToPlay = DialogueLines[LineIdx].Cues[Rand(DialogueLines[LineIdx].Cues.Length)];
		if (CueToPlay != None)
		{
			// play the cue
			`loginfo('Nano_NADS', `showvar(LineToPlay) @ `showvar(ActorToPlayOn) @ `showvar(CueToPlay) @ "TimeSince:" @`TimeSince(DialogueLines[LineIdx].LastPlayTime) @  `showvar(DialogueLines[LineIdx].LockoutDuration) );
			ActorToPlayOn.PlaySound(CueToPlay);
			// mark the last time this line was played
			DialogueLines[LineIdx].LastPlayTime = WorldInfo.TimeSeconds;
		
			// and save the speaker to prevent them from talking again
			SpeakerIdx = DialogueSpeakers.Length;
			DialogueSpeakers.Length = SpeakerIdx + 1;
			DialogueSpeakers[SpeakerIdx].Speaker = ActorToPlayOn;
			DialogueSpeakers[SpeakerIdx].TimeWhenFinishedSpeaking = WorldInfo.TimeSeconds + CueToPlay.GetCueDuration();
			// hack
			if( DialogueLines[LineIdx].bIsDispatcher == TRUE )
			{
				NanoGRI(WorldInfo.GRI).GetNanoPC().SetTimer( CueToPlay.GetCueDuration(), FALSE, nameof(NanoGRI(WorldInfo.GRI).GetNanoPC().RestoreFromChaosAnnounceSoundMode) , NanoGRI(WorldInfo.GRI).GetNanoPC() );
			}

			return TRUE;
		}
	}

	// we didn't play the line
	return FALSE;
}




defaultproperties
{

	//DialogueLines.Add((Line=EDLine_NanoPowerWitness,LockoutDuration=6.0f,Cues=()))
	//DialogueLines.Add((Line=EDLine_StopPlayer,LockoutDuration=3.0f,Cues=()))

	//DialogueLines.Add((Line=EDLine_OpenFire,LockoutDuration=15.0f,Cues=()))

	//DialogueLines.Add((Line=EDLine_TrooperKilled,LockoutDuration=2.0f,Cues=()))

	DialogueLines.Add((Line=EDLine_SightPlayerFromDistance,LockoutDuration=5.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_SightFromDistance_Cue')))
	DialogueLines.Add((Line=EDLine_LostSightOfPlayerFromDistance,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_LostFromDistance_Cue')))
	DialogueLines.Add((Line=EDLine_PursuePlayerInCombat,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_PursueClose_Cue')))
	DialogueLines.Add((Line=EDLine_Search_LookingForPlayer,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_SearchClose_Cue')))
	DialogueLines.Add((Line=EDLine_Search_FoundPlayer,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_FoundClose_Cue')))
	DialogueLines.Add((Line=EDLine_Search_GiveUpSearch,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_GiveUpClose_Cue')))


	DialogueLines.Add((Line=EDLine_ChallengePlayer_DropYourWeapon,LockoutDuration=15.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_TrooperB.MetaCorpsB_DropYourWeaponCue')))

	DialogueLines.Add((Line=EDLine_Combat_RequestingBackup,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_TrooperB.MetaCorpsB_RequestingBackupCue')))

	DialogueLines.Add((Line=EDLine_ChallengePlayer,LockoutDuration=15.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_Challenge_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_DodgeSprint,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatReactSprint_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_SwitchToFireArms,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatUsingFirearms_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_SwitchingToBatons,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatSwitchToBatons_Cue')))

	SharedDialogueLines.Add((Lines=(EDLine_Combat_SwitchToFireArms,EDLine_Combat_SwitchingToBatons)))


	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_Commence,LockoutDuration=5.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatBegin_Inner_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_SustainedBattle,LockoutDuration=15.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatSustain_Inner_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_GhostWhiff,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatWhiffGhost_Inner_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_DodgeWhiff,LockoutDuration=1.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatWhiffDodge_Inner_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_HoldPlayer,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatHoldPlayer_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_ThrownByPlayer,LockoutDuration=0.5f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatThrown_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_MeleeCircle_PlayerDied,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatDefeatPlayer_Inner_Cue')))

	SharedDialogueLines.Add((Lines=(EDLine_Combat_MeleeCircle_Commence,EDLine_Combat_StandbyCircle_SawBuddyGetHit,EDLine_Combat_MeleeCircle_SustainedBattle,EDLine_Combat_SpectatorCircle_TauntPlayer)))


	DialogueLines.Add((Line=EDLine_Combat_StandbyCircle_SustainedBattle,LockoutDuration=15.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatSustain_Middle_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_StandbyCircle_SawBuddyGetHit,LockoutDuration=7.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatSawHit_Middle_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_StandbyCircle_SawBuddyGetTackled,LockoutDuration=4.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatReactTackle_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_StandbyCircle_EnteringMeleeCircle,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatEnter_Middle_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_StandbyCircle_LastTrooperFromStandByEnteringMelee,LockoutDuration=5.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatCallBackup_Middle_Cue')))

	SharedDialogueLines.Add((Lines=(EDLine_Combat_StandbyCircle_SawBuddyGetHit,EDLine_Combat_SpectatorCircle_TauntPlayer)))

	SharedDialogueLines.Add((Lines=(EDLine_Combat_MeleeCircle_SustainedBattle,EDLine_Combat_StandbyCircle_SustainedBattle,EDLine_Combat_SpectatorCircle_TauntPlayer)))	

	DialogueLines.Add((Line=EDLine_Combat_SpectatorCircle_TauntPlayer,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatTaunt_Outer_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_SpectatorCircle_SeesBuddyDie,LockoutDuration=7.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatReactDown_Outer_Cue')))
	DialogueLines.Add((Line=EDLine_Combat_SpectatorCircle_PlayerDied,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatDefeatPlayer_Outer_Cue')))

	DialogueLines.Add((Line=EDLine_Combat_Fleeing,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatFlee_Cue')))

	DialogueLines.Add((Line=EDLine_Combat_ChargeAttack,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatCharge_Cue')))

	DialogueLines.Add((Line=EDLine_PoliceCar_ReportIn,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_ReportIn_Cue')))
	DialogueLines.Add((Line=EDLine_PoliceCar_SpotPawn,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.PoliceCar.PoliceCar_PA_Challenge_Cue')))
	DialogueLines.Add((Line=EDLine_PoliceCar_SpotPawnNotInCombat,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.PoliceCar.PoliceCar_PA_ChallengeVO_Cue')))

	DialogueLines.Add((Line=EDLine_PoliceCar_LostPawn,LockoutDuration=10.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_PleaseReportLost_Cue')))
	DialogueLines.Add((Line=EDLine_PoliceCar_ShotAt,LockoutDuration=5.0f,Cues=(SoundCue'Dialog_Temp.PoliceCar.PoliceCar_PA_FiredOnChallenge_Cue')))
	DialogueLines.Add((Line=EDLine_PoliceCar_ShotDown,LockoutDuration=5.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_SquadCarDown_Cue')))


	//// new new
	DialogueLines.Add((Line=EDLine_NDP_AttackRadius_Enter,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_NC_Challenge_Cue')))
	DialogueLines.Add((Line=EDLine_NDP_AttackRadius_StandingIn,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_NC_ChallengeRemind_Cue')))
	DialogueLines.Add((Line=EDLine_NDP_AttackRadius_Leave,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_NC_ChallengeObeyed_Cue')))
	DialogueLines.Add((Line=EDLine_NDP_AttackRadius_UnderAttack_Triggered,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_NC_ChallengeWarn_Cue')))
	
	SharedDialogueLines.Add((Lines=(EDLine_NDP_AttackRadius_Enter,EDLine_NDP_AttackRadius_StandingIn,EDLine_NDP_AttackRadius_Leave)))
	
	DialogueLines.Add((Line=EDLine_PlayerAttacks_MetaCorp_WhenNoChaos,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_PlayerAttacksNeutral_Cue')))



//	DialogueLines.Add((Line=,LockoutDuration=3.0f,Cues=()))
//	DialogueLines.Add((Line=,LockoutDuration=3.0f,Cues=()))
//	DialogueLines.Add((Line=,LockoutDuration=3.0f,Cues=()))
//	DialogueLines.Add((Line=,LockoutDuration=3.0f,Cues=()))


    // Non-Combat Challenge Reminder Radio (quiet follow-up-reminder to leave the area; should play frequently until combat or player leaves; OK to play while other dialog is playing)
	DialogueLines.Add((Line=EDLine_Dispatch_ChallengeReminder,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_NC_ChallengeRemind_Cue')))
	//Player Escaping/Running from MetaCorps (other trooper dialog should probably wait for this:
	DialogueLines.Add((Line=EDLine_Dispatch_RebelIsEscaping,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_Combat_PlayerEscaping_Cue')))
	//Player Has Escaped (Free from pursuing troops):
	DialogueLines.Add((Line=EDLine_Dispatch_RebelHasEscaped,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.PoliceDispatch_Combat_PlayerEscaped_Cue')))



	DialogueLines.Add((Line=EDLine_Dispatcher_ChaosTierOne,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelOneStart_Cue'),bIsDispatcher=TRUE))
	DialogueLines.Add((Line=EDLine_Dispatcher_ChaosTierTwo,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelTwoStart_Cue'),bIsDispatcher=TRUE))
	DialogueLines.Add((Line=EDLine_Dispatcher_ChaosTierThree,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelThreeStart_Cue'),bIsDispatcher=TRUE))
	DialogueLines.Add((Line=EDLine_Dispatcher_ChaosTierFour,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelThreeStart_Cue'),bIsDispatcher=TRUE))
	DialogueLines.Add((Line=EDLine_Dispatcher_ChaosTierFive,LockoutDuration=3.0f,Cues=(SoundCue'Dialog_Temp.PoliceDispatch.Dispatch_Combat_ChaosLevelThreeStart_Cue'),bIsDispatcher=TRUE))


	 SharedDialogueLines.Add((Lines=(EDLine_Dispatcher_ChaosTierOne,EDLine_Dispatcher_ChaosTierTwo,EDLine_Dispatcher_ChaosTierThree,EDLine_Dispatcher_ChaosTierFour,EDLine_Dispatcher_ChaosTierFive,EDLine_PoliceCar_ReportIn,EDLine_PoliceCar_SpotPawn,EDLine_PoliceCar_SpotPawnNotInCombat,EDLine_PoliceCar_LostPawn)))




	// mega semaphore lock to stop crazy amount of lines playing
    SharedDialogueLines.Add((Lines=(EDLine_SightPlayerFromDistance,EDLine_LostSightOfPlayerFromDistance,EDLine_PursuePlayerInCombat,EDLine_Search_LookingForPlayer,EDLine_Search_FoundPlayer,EDLine_Search_GiveUpSearch,EDLine_Combat_DodgeSprint,EDLine_Combat_SwitchToFireArms,EDLine_Combat_SwitchingToBatons,EDLine_Combat_MeleeCircle_Commence,EDLine_Combat_MeleeCircle_GhostWhiff,EDLine_Combat_MeleeCircle_DodgeWhiff,EDLine_Combat_MeleeCircle_HoldPlayer,EDLine_Combat_StandbyCircle_EnteringMeleeCircle,EDLine_Combat_StandbyCircle_LastTrooperFromStandByEnteringMelee,EDLine_Combat_Fleeing)))

	// taunts
	SharedDialogueLines.Add((Lines=(EDLine_ChallengePlayer,EDLine_Combat_MeleeCircle_SustainedBattle,EDLine_Combat_StandbyCircle_SustainedBattle,EDLine_Combat_SpectatorCircle_TauntPlayer,EDLine_ChallengePlayer_DropYourWeapon)))

	// see pain / death / dismemberment
	SharedDialogueLines.Add((Lines=(EDLine_Combat_MeleeCircle_ThrownByPlayer,EDLine_Combat_StandbyCircle_SawBuddyGetHit,EDLine_Combat_StandbyCircle_SawBuddyGetTackled,EDLine_Combat_SpectatorCircle_SeesBuddyDie,)))




}
