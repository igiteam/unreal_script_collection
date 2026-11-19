/**
 * CQC Move (Close Quarter Combat) PunchFace
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_PunchFace extends GSM_CQC_Killer_Base;

/** Should we wait for the weapon to be holstered before starting the execution. */
var bool	bWaitForWeaponHolstered;

/** set if victim was a hostage before being executed; we treat it somewhat differently in that case */
var bool bVictimWasHostage;
/** set while playing the ending anim, so end the special move when we get the animation end notify */
var bool bPlayingEnding;
/** how many times we've looped the punching anim due to button presses */
var int PunchLoops;

/** the maximum amount of punches allowed */
var config int MaxPunchLoops;

/** which punch camera anim we decided on at the beginning */
var int CameraAnimIndex;

/** HUD icon for loop button */
var ActionInfo LoopActionInfo;

/* The execution structure to use */
var transient CQC_Long_Execution ExecutionToUse;

/** Server execution that client can't use, this means host that can't play as well **/
var transient CQC_Long_Execution ServerExecution;

/** Server execution that client can't use, this means host that can't play as well **/
var CQC_Long_Execution DefaultNonGoreExecution;

/**Whether to use execution camera or not - this is needed because for looping animation, there is delay between playing camera anims**/
var transient bool bUseExecutionCamera;

/** How big the camera collision scale should be - we are generous about collision here to have more chance to play otherwise it won't happen due to AABB box check **/
var float CameraCollisionCheckScale;

simulated function bool ShouldThrowWeapon()
{
	// if carrying heavy weapon and holster is true, then throw weapon (since you can't holster heavy weapon)
	return ( PawnOwner.IsCarryingAHeavyWeapon() && ExecutionToUse.CQC_Long_bHolsterWeapon==TRUE );
}

simulated function bool CanDoExecution()
{
	// if long execution exists, still do execution
	return (!PawnOwner.IsCarryingAHeavyWeapon() || PawnOwner.MyGearWeapon.LongExecutions.Length > 1);
}

protected function bool InternalCanDoSpecialMove()
{
	// we can't do this move with a heavy weapon since we can't holster it
	// we can do heavy weapon if we have long executions
	return ( CanDoExecution() && Super.InternalCanDoSpecialMove());
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// Reset variables
	bWaitForWeaponHolstered = false;
	bPlayingEnding = false;
	PunchLoops = 0;
	MarkerRelOffset = default.MarkerRelOffset;
	ModifiedAnimScale = default.ModifiedAnimScale;

	if (PawnOwner.MyGearWeapon == None)
	{
		// Gears 3 final execution, you only have the knife attachment out, force face punch for now
		ExecutionToUse = class'GearWeapon'.default.LongExecutions[0];
		ServerExecution = ExecutionToUse;
	}
	else
	{
		ExecutionToUse = PawnOwner.MyGearWeapon.LongExecutions[PawnOwner.SpecialMoveFlags];

		// If we have GoreExecution on , but this client does not like to see it,
		// we need to back out, and will need to calculated correct scale to play it.
		if ( ExecutionToUse.GoreExecution && !PawnOwner.WorldInfo.GRI.ShouldShowGore() )
		{
			ServerExecution = ExecutionToUse;
			// if non gore execution is specificed, use it
			if (ExecutionToUse.NonGoreExecutionIndex!=-1)
			{
				ExecutionToUse = PawnOwner.MyGearWeapon.LongExecutions[ExecutionToUse.NonGoreExecutionIndex];
			}
			else // otherwise, use default one, but need to copy some data
			{
				ExecutionToUse = DefaultNonGoreExecution;
				ExecutionToUse.AwardRequired = ServerExecution.AwardRequired;
				ExecutionToUse.CQC_Long_DamageType = ServerExecution.CQC_Long_DamageType;
				ExecutionToUse.CQC_Long_EffortID = ServerExecution.CQC_Long_EffortID;
			}
		}
		else
		{
			ServerExecution = ExecutionToUse;
		}
	}

	// See if we should override marker offset.
	if( ExecutionToUse.MarkerRelOffset != vect(1,2,3) )
	{
		MarkerRelOffset = ExecutionToUse.MarkerRelOffset;
	}

	// Set execution damage type.
	ExecutionDamageType = ExecutionToUse.CQC_Long_DamageType;
	// Setup the timer to execute. Delay if we have an 'End' animation
	VictimDeathTime = ExecutionToUse.CQC_Long_VictimAnim_End != '' ? 0.f : ExecutionToUse.CQC_Long_VictimDeathTime;

	if (PawnOwner.MyGearWeapon != None)
	{
		// See if Killer should Holster his weapon.
		bWaitForWeaponHolstered = ExecutionToUse.CQC_Long_bHolsterWeapon && PawnOwner.HolsterWeapon();
	}

	// init as not to use - it might mess up camera anims
	bUseExecutionCamera = FALSE;

	if (ExecutionToUse.bDisableDeathScreams)
	{
		Follower.bDisableDeathScreams = TRUE;
	}

	Super.SpecialMoveStarted(bForced, PrevMove);
}

/** Take into account weapon holstering */
function bool IsReadyToStartInteraction()
{
	// Client has thrown a heavy weapon and hasn't told us which one is active yet
	if (PawnOwner.MyGearWeapon == None)
	{
		return FALSE;
	}

	// If we've thrown the previous MyGearWeapon, verify that the new one doesn't need to be set up to holstered
	if (!ShouldThrowWeapon() && !PawnOwner.IsWeaponHolstered())
	{
		// See if Killer should Holster his weapon.
		bWaitForWeaponHolstered = ExecutionToUse.CQC_Long_bHolsterWeapon && PawnOwner.HolsterWeapon();
	}

	return !bWaitForWeaponHolstered && Super.IsReadyToStartInteraction();
}

function WeaponTemporarilyHolstered()
{
	bWaitForWeaponHolstered = FALSE;

	// Check if we're ready now
	CheckReadyToStartInteraction();
}

function StartInteraction()
{
	// Make sure only the kidnapper kills the victim now.
	Follower.SpecialMoves[Follower.SpecialMove].bOnlyInteractionPawnCanDamageMe = TRUE;

	// Make sure Pawns are placed on their markers
	PlaceOnMarkers();
	PlayExecution();
	AlignMesh();
	SplashBloodOnScreen(ExecutionToUse.CameraLensEffect);
}

// Do I need execution camera - if you're not playing camera animation, yes we do
function bool NeedExecutionCamera()
{
	return bUseExecutionCamera;
}

// when client needs to play AnimToPlay -i.e. gore disabled
// when server is playing other animation
// it needs to calculate correct scale, so that it matches server's length
function float GetAnimScale( name AnimToPlay, name AnimThatShouldPlay )
{
	local FLOAT CurrentAnimLength, BaseAnimLength;
	local AnimSequence  CurrentAnim, BaseAnim;

	if (PawnOwner.Mesh!=none)
	{
		CurrentAnim = PawnOwner.Mesh.FindAnimSequence(AnimToPlay);
		BaseAnim = PawnOwner.Mesh.FindAnimSequence(AnimThatShouldPlay);

		if ( CurrentAnim!=none && BaseAnim!=none )
		{
			CurrentAnimLength = CurrentAnim.SequenceLength;
			BaseAnimLength = BaseAnim.SequenceLength;
			if ( BaseAnimLength > 0 && CurrentAnimLength > 0 )
			{
				return CurrentAnimLength/BaseAnimLength;
			}
		}
	}

	return 1.f;
}

function PlayExecution()
{
	local GearPC FollowerPC;
	local float AnimScale;

	// if client/server isn't playing same execution, need to scale and match up
	if ( ExecutionToUse.CQC_Long_KillerAnim != ServerExecution.CQC_Long_KillerAnim )
	{
		// calculate the scale for it
		ModifiedAnimScale = GetAnimScale( ExecutionToUse.CQC_Long_KillerAnim, ServerExecution.CQC_Long_KillerAnim );
	}

	AnimScale = SpeedModifier*ModifiedAnimScale;

	bVictimWasHostage = Follower.IsAHostage() || Follower.PreviousSpecialMove == SM_Hostage;

	// Play execution Camera Animation.
	if (!bVictimWasHostage && ExecutionToUse.CQC_Long_CameraAnims.Length > 0)
	{
		// if we are doing a button mash looping execution, we need to do things a bit differently to match all the pieces correctly
		if( ExecutionToUse.CQC_Long_VictimAnim_End == '' )
		{
			if ( PlayExecutionCameraAnim(ExecutionToUse.CQC_Long_CameraAnims) == false )
			{
				// if failed to play camera anim, use execution camera
				bUseExecutionCamera = TRUE;
			}
		}
		else
		{
			CameraAnimIndex = ChooseRandomCameraAnim(ExecutionToUse.CQC_Long_CameraAnims, PawnOwner, CameraCollisionCheckScale);
			if ( CameraAnimIndex!=INDEX_NONE )
			{
				PlayCameraAnim(PawnOwner, ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], AnimScale,, 0.1,,,,,, TRUE);
			}
			else
			{
				bUseExecutionCamera = TRUE;
			}

			// If Follower is human controlled, have him spectate his death from the killer's perspective
			if (Follower.IsHumanControlled())
			{
				FollowerPC = GearPC(Follower.Controller);
				FollowerPC.SetViewTarget(PawnOwner);
				if ( CameraAnimIndex!=INDEX_NONE )
				{
					PlayCameraAnim(Follower, ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], AnimScale,, 0.1,,,,,,  TRUE);
				}
			}

			if (PCOwner != None && PawnOwner.IsLocallyControlled())
			{
				PCOwner.MyGearHUD.SetActionInfo(AT_SpecialMove, LoopActionInfo);
			}
		}
	}

	PawnOwner.SoundGroup.PlayEffort(PawnOwner, ExecutionToUse.CQC_Long_EffortID, true);

	// Setup animation, parent function will play it
	BS_KillerAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_KillerAnim.Stance[0].Slot = BS_FullBody;
	BS_KillerAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_KillerAnim;
	if (!bVictimWasHostage)
	{
		if ( ExecutionToUse.CQC_Long_VictimAnim != '' )
		{
			BS_VictimAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
			BS_VictimAnim.Stance[0].Slot = BS_FullBody;
			BS_VictimAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_VictimAnim;
		}
	}

	// If the weapon has an animation, play it
	if( ExecutionToUse.CQC_Long_KillerWeaponAnim != '' )
	{
		PawnOwner.MyGearWeapon.PlayWeaponAnim(ExecutionToUse.CQC_Long_KillerWeaponAnim, AnimScale, BlendInTime/AnimScale, BlendOutTime/AnimScale, FALSE, TRUE);
	}

	Super.PlayExecution();
}

// If one of them are lower than the other, increase the lower person to match up height level
// Otherwise, the animation won't work together
// This used to be less problem, but now with so many execution, this is becoming major issue.
function AlignMesh()
{
	local vector ToVictim;

	ToVictim = Follower.Location - PawnOwner.Location;
	if ( ToVictim.Z != 0 )
	{
		ToVictim.X = 0;
		ToVictim.Y = 0;
		if (ToVictim.Z > 0 )
		{
			// if attacker is lower, increase attacker mesh offset
			PawnOwner.MTO_SpecialMoveOffset = ToVictim;
		}
		else
		{
			// if follower is lower, increase follower mesh offset
			Follower.MTO_SpecialMoveOffset = -ToVictim;
		}
	}
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local float AnimScale;

	if (bPlayingEnding)
	{
		Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
	}
	else if (PawnOwner.SpecialMoveFlags > PunchLoops && ExecutionToUse.CQC_Long_VictimAnim_Loop != '' && PunchLoops < MaxPunchLoops)
	{
		// if still looping, spawn the lens effect here
		SplashBloodOnScreen(ExecutionToUse.CameraLensEffect_Loop);

		PunchLoops = PawnOwner.SpecialMoveFlags; // instead of ++ so that client will skip some if it falls behind for some reason

		// if client/server isn't playing same execution, need to scale and match up
		if ( ExecutionToUse.CQC_Long_KillerAnim_Loop != ServerExecution.CQC_Long_KillerAnim_Loop )
		{
			// calculate the scale for it
			ModifiedAnimScale = GetAnimScale( ExecutionToUse.CQC_Long_KillerAnim_Loop, ServerExecution.CQC_Long_KillerAnim_Loop );
		}

		AnimScale = SpeedModifier*ModifiedAnimScale;

		// switch to the loopable anim and call the normal code
		if (!bVictimWasHostage &&
			CameraAnimIndex!=INDEX_NONE &&
			(ExecutionToUse.CQC_Long_CameraAnims_Loop.length > CameraAnimIndex) &&
			(ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex] != None) )
		{
			if (PCOwner != None && PawnOwner.IsLocallyControlled())
			{
				PCOwner.PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], true);
				PCOwner.PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], true);
			}
			if (Follower.IsLocallyControlled() && Follower.IsHumanControlled())
			{
	 			PlayerController(Follower.Controller).PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], true);
				PlayerController(Follower.Controller).PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], true);
			}
			PlayCameraAnim(PawnOwner, ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], AnimScale,,,,,,,, true);
			PlayCameraAnim(Follower, ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], AnimScale,,,,,,,, true);
		}

		BS_KillerAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_KillerAnim_Loop;
		if (!bVictimWasHostage)
		{
			BS_VictimAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_VictimAnim_Loop;
		}

		Super.PlayExecution();
	}
	else
	{
		// if client/server isn't playing same execution, need to scale and match up
		if ( ExecutionToUse.CQC_Long_KillerAnim_End != '' && ExecutionToUse.CQC_Long_KillerAnim_End != ServerExecution.CQC_Long_KillerAnim_End )
		{
			// calculate the scale for it
			ModifiedAnimScale = GetAnimScale( ExecutionToUse.CQC_Long_KillerAnim_End, ServerExecution.CQC_Long_KillerAnim_End );
		}

		// there are some execution that does not have ending execution
		// so use previous scale value if this happens
		AnimScale = SpeedModifier*ModifiedAnimScale;

		// switch to ending anim and call the normal code one last time
		if (!bVictimWasHostage)
		{
			if (CameraAnimIndex!=INDEX_NONE && ExecutionToUse.CQC_Long_CameraAnims_Loop.length > CameraAnimIndex)
			{
				if (PCOwner != None && PawnOwner.IsLocallyControlled())
				{
					PCOwner.PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], true);
					PCOwner.PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], true);
				}
				if (Follower.IsLocallyControlled() && Follower.IsHumanControlled())
				{
					PlayerController(Follower.Controller).PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims[CameraAnimIndex], true);
					PlayerController(Follower.Controller).PlayerCamera.StopAllCameraAnimsByType(ExecutionToUse.CQC_Long_CameraAnims_Loop[CameraAnimIndex], true);
				}
			}

			if ( CameraAnimIndex!=INDEX_NONE && (ExecutionToUse.CQC_Long_CameraAnims_End.length > CameraAnimIndex) && (ExecutionToUse.CQC_Long_CameraAnims_End[CameraAnimIndex] != None) )
			{
				PlayCameraAnim(PawnOwner, ExecutionToUse.CQC_Long_CameraAnims_End[CameraAnimIndex], AnimScale,,,,,,,, true);
				PlayCameraAnim(Follower, ExecutionToUse.CQC_Long_CameraAnims_End[CameraAnimIndex], AnimScale,,,,,,,, true);
			}
		}

		if( ExecutionToUse.CQC_Long_KillerAnim_End != '' )
		{
			// ending, spawn it again
			SplashBloodOnScreen(ExecutionToUse.CameraLensEffect_End);

			// we have an end anim, do that
			BS_KillerAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_KillerAnim_End;
			if (!bVictimWasHostage)
			{
				BS_VictimAnim.Stance[0].AnimName = ExecutionToUse.CQC_Long_VictimAnim_End;
			}

			bPlayingEnding = TRUE;
			// Setup proper kill timer now!
			VictimDeathTime = ExecutionToUse.CQC_Long_VictimDeathTime;

			Super.PlayExecution();
		}
		else
		{
			Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
		}
	}
}

/** Separate function, so other executions can implement their variations. */
function SetVictimRotation()
{
	Super.SetVictimRotation();

	if (bVictimWasHostage)
	{
		bVictimRotInterp = FALSE; // disable rotation in that case
	}
	else
	{
		// Get parameters from Weapon.
		VictimRotStartTime		= ExecutionToUse.CQC_Long_VictimRotStartTime;
		VictimRotInterpSpeed	= ExecutionToUse.CQC_Long_VictimRotInterpSpeed;
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Stop all animation. Otherwise, it will continue play.
	// put this before UnHolsterWeapon() as it will start an animation.
	PawnOwner.BS_StopAll(0.2f);

	// Unholster weapon after execution finishes.
	if( PawnOwner.IsWeaponHolstered() )
	{
		PawnOwner.UnHolsterWeapon();
	}

	if (PCOwner != None && PawnOwner.IsLocallyControlled())
	{
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_SpecialMove);
	}

	// clear mesh offset when finishes up
	PawnOwner.MTO_SpecialMoveOffset = (vect(0, 0, 0));
	Follower.MTO_SpecialMoveOffset = (vect(0, 0, 0));

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function bool ButtonPress(name ButtonName)
{
	if (ButtonName == 'Y')
	{
		PCOwner.DoSpecialMove(PawnOwner.SpecialMove, false, PawnOwner.InteractionPawn, PunchLoops + 1);
		return true;
	}
	else
	{
		return Super.ButtonPress(ButtonName);
	}
}

//Determines which execution variant should be used for the current weapon
static function int DetermineExecutionVariant( GearPawn GP, optional GearPC GPC = none )
{
	local int Idx, ExeIdx;
	local GearWeapon Weap;
	local bool bHasWeaponSpecial;
	local array<int> AvailableExecutions;

	//If we are missing any of these things, go with the default and pray.
	if (GP == None || GP.MyGearWeapon == None || (GPC != None && (GPC.AwardManager == None || GPC.StatManager == None)))
	{
		return 0;
	}

	Weap = GP.MyGearWeapon;

	ExeIdx = 0;

	//Otherwise, going from highest to lowest, check to see if we can use the variants for this weapon.
	for (Idx = Weap.LongExecutions.Length-1; Idx > 0; Idx--)
	{
		// if team index required is specified, make sure pawn is same team
		if ( (Weap.LongExecutions[Idx].TeamIndexRequired == -1 || Weap.LongExecutions[Idx].TeamIndexRequired == GP.LastTeamNum) &&
			// if award isn't required or not Player controller or make sure award has been earned
			(Weap.LongExecutions[Idx].AwardRequired == '' || GPC == None || GPC.AwardManager.HasEarnedAwardByName(Weap.LongExecutions[Idx].AwardRequired)) &&
			// if gore is required, make sure gore setting exists
			(!Weap.LongExecutions[Idx].GoreExecution || GP.GoreSettings != None) )
		{
			// to allow alternative, we save available items and pick random below.
			// if weapon specific, prefer them
			// weapon specials should be at the end, so if we found weapon special, do not add non weapon special
			if (Weap.LongExecutions[Idx].WeaponSpecial)
			{
				bHasWeaponSpecial = TRUE;
				AvailableExecutions[ExeIdx] = Idx;
				ExeIdx++;
			}
			// if not weapon special, add it if we didn't find any weapon special
			else if (!bHasWeaponSpecial)
			{
				AvailableExecutions[ExeIdx] = Idx;
				ExeIdx++;
			}
		}
	}

	if (AvailableExecutions.Length > 0)
	{
		ExeIdx = Rand(AvailableExecutions.Length);
		return AvailableExecutions[ExeIdx];
	}

	//The 0th option is always valid, so go with that.
	return 0;
}

defaultproperties
{
	bDisableLook=true
	ExecutionDamageType=class'GDT_Execution_Default'
	MarkerRelOffset=(X=84.57,Y=27.19,Z=0.0)
	BlendInTime=0.1
	BlendOutTime=0.1
	bImmediateXPDisplay=true

	// Y Button
	LoopActionInfo={(
		ActionName=PunchFace,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64),
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))))
		)}

	CameraCollisionCheckScale = 0.8f

	DefaultNonGoreExecution={(CQC_Long_KillerAnim="CTRL_BurstPistol",
					CQC_Long_KillerAnim_Loop="",
					CQC_Long_KillerAnim_End="",
					CQC_Long_VictimAnim="DBNO_BurstPistol",
					CQC_Long_VictimAnim_Loop="",
					CQC_Long_VictimAnim_End="",
					CQC_Long_bHolsterWeapon=false,
					CQC_Long_VictimDeathTime=2.f,
					CQC_Long_VictimRotStartTime=0.f,
					CQC_Long_VictimRotInterpSpeed=8.f,
					CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam01',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam02',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam03'),
					MarkerRelOffset=(X=85.670,Y=33.657,Z=0),
					CameraLensEffect=class'Emit_CameraBlood_LongExecution_BurstPistol')}
}
