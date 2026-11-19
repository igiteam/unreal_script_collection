/**
 * Special move to swipe with the cleaver
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_CleaverSwipe extends GearSpecialMove;

/** The swipe start animation */
var()	GearPawn.BodyStance	BS_StartAnimation;

/** The swipe right animation */
var()	GearPawn.BodyStance	BS_SwipeRightAnimation;

/** The swipe left animation */
var()	GearPawn.BodyStance	BS_SwipeLeftAnimation;

/** The swipe end right animation */
var()	GearPawn.BodyStance	BS_EndRightAnimation;

/** The swipe end left animation */
var()	GearPawn.BodyStance	BS_EndLeftAnimation;

/** Whether the ending animation is playing */
var protected bool bPlayingEnding;

/** Whether the player pushed B to continue the combo */
var protected transient int LoopSwipeCount;

/** Since replication issue, I'm changing to current, max count idea, so that we can replicate via SpecialMoveFlags **/
var protected transient int CurrentLoopSwipeCount;

/** Whether we're swiping left or right */
var protected bool bSwipeRight;

/** The delay to cause damage after the swipe animation has started */
var config const float SwipeFireDelay;

/** The sound to play while swinging */
var SoundCue SwingSound;

/** The sound to play on the first swing */
var SoundCue SwingStartSound;

/** The sound to play when the swing has completed */
var SoundCue SwingEndSound;

/** Cached weapon - does not exists unless host or ownining player **/
var transient GearWeap_CleaverBase CleaverWeap;

/**
 * Start the body animation when the special move starts.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{	
	Super.SpecialMoveStarted(bForced,PrevMove);

	bPlayingEnding = FALSE;
	LoopSwipeCount = 2;
	CurrentLoopSwipeCount = 0;
	bSwipeRight = FALSE;

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Play start animation
	PawnOwner.BS_Play(BS_StartAnimation, SpeedModifier, 0.2f/SpeedModifier, 0.1f, FALSE, TRUE, 'CleaverSwing');

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_StartAnimation, TRUE);
	
	PlaySwingSound(SwingStartSound);

	// cache cleaverweap	
	CleaverWeap = GearWeap_CleaverBase(PawnOwner.MyGearWeapon);	
}

function SaveSwipeLocation()
{
	// in host, set weapon SwipeLoc
	if ( CleaverWeap != none )
	{
		CleaverWeap.SaveSwipeLocation();
	}
}

simulated function DoSwipeFire()
{
	if ( CleaverWeap != none )
	{
		CleaverWeap.DoSwipeFire();
	}
}

function PlaySwingSound(SoundCue SwingSoundCue)
{
	local AudioComponent AC;

	AC = PawnOwner.CreateAudioComponent(SwingSoundCue, false, true);
	if (AC != None)
	{
		AC.bAllowSpatialization = TRUE;
		AC.bAutoDestroy = TRUE;
		SkeletalMeshComponent(PawnOwner.MyGearWeapon.Mesh).AttachComponent(AC, 'Cleaver_Tip');
		AC.Play();
	}
}

/**
 * Remove the end of animation notification that was set in SpecialMoveStarted.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
		
	PawnOwner.StopMeleeAttack();

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_SwipeRightAnimation, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_SwipeLeftAnimation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_StartAnimation, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_SwipeRightAnimation, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_SwipeLeftAnimation, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_EndRightAnimation, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_EndLeftAnimation, FALSE);
}

/** 
 * Loop the animation or play the ending animation as necessary
 * 
 * @param SeqNode - the animation that just ended
 * 
 * @param PlayedTime - the length of the animation that just ended
 * 
 * @param ExcessTime - the amount of time passed the animation length
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (bPlayingEnding)
	{
		// need to stop this. Otherwise, it will add swipe bottom + idle_core + additive AR_Idle_Ready_AIm, causing pop
		//PawnOwner.BS_StopAll(0.2f);

		Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
			
		if (PawnOwner.IsLocallyControlled())
		{
			PawnOwner.LocalEndSpecialMove(SM_CleaverSwipe);
		}
	}
	else 
	{
		if ( LoopSwipeCount < PawnOwner.SpecialMoveFlags )
		{
			// update loopSwipecount
			LoopSwipeCount = PawnOwner.SpecialMoveFlags;
		}

		if ( CurrentLoopSwipeCount < LoopSwipeCount)
		{
			if (PawnOwner.IsLocallyControlled() && PawnOwner.MyGearWeapon.ShouldMeleeKick())
			{
				PawnOwner.LocalEndSpecialMove(SM_CleaverSwipe);
				PawnOwner.MyGearWeapon.ClientForceEndFire(PawnOwner.MyGearWeapon.CurrentFireMode);
				PawnOwner.ClientStartMeleeAttack();
			}
			else
			{
				PawnOwner.BS_SetAnimEndNotify(BS_StartAnimation, FALSE);
				PawnOwner.BS_SetAnimEndNotify(BS_SwipeRightAnimation, FALSE);
				PawnOwner.BS_SetAnimEndNotify(BS_SwipeLeftAnimation, FALSE);

				if (bSwipeRight)
				{
					// for loop, do not blend, if you do, it will cut animation too short
					PawnOwner.BS_Play(BS_SwipeRightAnimation, SpeedModifier, 0.1f, 0.02f, FALSE, TRUE, 'CleaverSwingRight');
					PawnOwner.BS_SetAnimEndNotify(BS_SwipeRightAnimation, TRUE);
					// Have animation forward root motion.
					PawnOwner.BS_SetRootBoneAxisOptions(BS_SwipeRightAnimation, RBA_Translate, RBA_Translate);
				}
				else
				{
					// for loop, do not blend, if you do, it will cut animation too short		
					PawnOwner.BS_Play(BS_SwipeLeftAnimation, SpeedModifier, 0.1f, 0.02f, FALSE, TRUE, 'CleaverSwingLeft');
					PawnOwner.BS_SetAnimEndNotify(BS_SwipeLeftAnimation, TRUE);
					// Have animation forward root motion.
					PawnOwner.BS_SetRootBoneAxisOptions(BS_SwipeLeftAnimation, RBA_Translate, RBA_Translate);
				}

				bSwipeRight = !bSwipeRight;
				CurrentLoopSwipeCount++;

				PlaySwingSound(SwingSound);
			}
		}
		else
		{
			bPlayingEnding = true;

			PawnOwner.BS_SetAnimEndNotify(BS_SwipeRightAnimation, FALSE);
			PawnOwner.BS_SetAnimEndNotify(BS_SwipeLeftAnimation, FALSE);
			PawnOwner.BS_StopAll(0.f);

			if (bSwipeRight)
			{
				// blending causes jerkiness because there is so much up/down motion in this animations
				PawnOwner.BS_Play(BS_EndLeftAnimation, SpeedModifier, 0.1f, 0.1f, FALSE, TRUE, 'CleaverSwingLeftEnd');
				PawnOwner.BS_SetAnimEndNotify(BS_EndLeftAnimation, TRUE);
				PawnOwner.BS_SetRootBoneAxisOptions(BS_EndLeftAnimation, RBA_Translate, RBA_Translate);
			}
			else
			{
				// blending causes jerkiness because there is so much up/down motion in this animations
				PawnOwner.BS_Play(BS_EndRightAnimation, SpeedModifier, 0.1f, 0.1f, FALSE, TRUE, 'CleaverSwingRightEnd');
				PawnOwner.BS_SetAnimEndNotify(BS_EndRightAnimation, TRUE);
				PawnOwner.BS_SetRootBoneAxisOptions(BS_EndRightAnimation, RBA_Translate, RBA_Translate);
			}

			PlaySwingSound(SwingEndSound);
		}
	}
}

/** 
 * Allow the player to constantly swipe
 * 
 * @param ButtonName - the button pushed
 * 
 * @return true if we processed the button
 */
function bool ButtonPress(name ButtonName)
{
	if (ButtonName == 'B' || ButtonName == 'R2')
	{
		PCOwner.DoSpecialMove(PawnOwner.SpecialMove, false, PawnOwner.InteractionPawn, LoopSwipeCount+1);
		return true;
	}
	else
	{
		return Super.ButtonPress(ButtonName);
	}
}

/** @return TRUE to turn off aim offsets */
event bool DisableAimOffset()
{
	return TRUE;
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	if (NotifyObject.Info == 'AttackStart')
	{
		// after swipe, record it again
		SaveSwipeLocation();
	}
	else if (NotifyObject.Info == 'AttackMid')
	{
		DoSwipeFire();
		SaveSwipeLocation();
	}
	else if (NotifyObject.Info == 'AttackEnd')
	{
		DoSwipeFire();
	}
}

defaultproperties
{
	BS_StartAnimation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Swing_Step_Start")))
	BS_SwipeRightAnimation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Swing_Step_Right")))
	BS_SwipeLeftAnimation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Swing_Step_Left")))
	BS_EndRightAnimation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Swing_Step_Right_End")))
	BS_EndLeftAnimation=(Stance=((Slot=BS_FullBody,AnimName="Cleaver_Swing_Step_Left_End")))

	bCanFireWeapon=FALSE

	SwingStartSound=SoundCue'Weapon_Cleaver.Cleaver.Cleaver_SwingStart_Cue'
	SwingSound=SoundCue'Weapon_Cleaver.Cleaver.Cleaver_SwingMain_Cue'
	SwingEndSound=SoundCue'Weapon_Cleaver.Cleaver.Cleaver_SwingBack_Cue'
}