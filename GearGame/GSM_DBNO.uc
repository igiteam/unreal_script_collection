
/**
 * DBNO Special Move
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DBNO extends GearSpecialMove
	native(SpecialMoves);

/** Animations */
var	transient GearPawn.BodyStance		BS_CurrentStumbleAnim;

enum EDBNODropType
{
	EDTDefault,
	EDTSpin,
	EDTRoadieRun
};

// Stumble animations
var	GearPawn.BodyStance		            BS_StumbleAnims[3];

/** Blend time between dbno idle and guard animations. */
var	float					GuardToggleBlendTime;
var ParticleSystemComponent PSC_DBNO_BloodCrawlSpurt;

/** Location PawnOwner went down. */
var protected transient vector	DBNOStartLocation;
var protected transient bool	bTriggeredCrawlingGUDS;
var protected transient bool    bTriggeredNeedsRevivedGUDS;

cpptext
{
	virtual void PostProcessPhysics(FLOAT DeltaTime);
}

/** GearPawn::EnterDBNO() already handles special queueing of the DBNO move for the cases where we can't do it immediately,
 * so never reject it here
 */
protected function bool InternalCanDoSpecialMove()
{
	return true;
}
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return true;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local rotator AimRot;
	local GearPC PC;
	local GearPawn_Infantry GPI;
	local GearGRI GRI;

	//If the pawn DBNO is locally controlled, has a player controller and a hud, pop up taccom locators
	PC = GearPC(PawnOwner.Controller) ;
	if (PC != none && PC.IsLocalPlayerController() &&  PC.MyGearHud != none)
	{
		PC.MyGearHud.ConstructTaccomLocators();
	}

	GPI = GearPawn_Infantry(PawnOwner);
	if (GPI != None)
	{
		if (GPI.DBNO_POI == None && GPI.WorldInfo.GRI != None)
		{
			foreach GPI.LocalPlayerControllers(class'GearPC', PC)
			{
				if (GPI.WorldInfo.GRI.OnSameTeam(PC, PawnOwner))
				{
					GPI.DBNO_POI = GPI.Spawn(class'GearPointOfInterest_DBNO', GPI);
					break;
				}
			}
		}
		if (GPI.DBNO_POI != None)
		{
			GPI.DBNO_POI.EnablePOI();
		}
	}

	// Get aim rotation before pulling pawn out of cover
	AimRot = PawnOwner.GetBaseAimRotation();

	Super.SpecialMoveStarted(bForced, PrevMove);

	// Set the bleed out time
	PawnOwner.TimeOfDBNO = PawnOwner.WorldInfo.TimeSeconds;
	PawnOwner.DBNOTimeExtensionCnt = 0;

	PlayStumbleAnimation();

	// turn off the near death
	PawnOwner.FadeOutAudioComponent(PawnOwner.NearDeathBreathSound,1.f);
	// everybody gets to hear you breathing hard
	PawnOwner.ReviveBreathSound = PawnOwner.SoundGroup.PlayEffortEx(PawnOwner, GearEffort_DeathBreathe);

	if (PawnOwner.WorldInfo.GRI != None && PawnOwner.WorldInfo.GRI.ShouldShowGore())
	{
		if ( PawnOwner.EffectIsRelevant(PawnOwner.Location, false, 3000) )
		{
			GRI = GearGRI(PawnOwner.WorldInfo.GRI);
			// note that this effect loops, but we'll disable it manually which will cause it to die and return itself to the pool
			PSC_DBNO_BloodCrawlSpurt = PawnOwner.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PawnOwner.DBNO_BloodCrawlSpurtTemplate, PawnOwner.Mesh, PawnOwner.MeleeDamageBoneName);
			PSC_DBNO_BloodCrawlSpurt.SetLODLevel(GRI.GetLODLevelToUse( PawnOwner.DBNO_BloodCrawlSpurtTemplate, PawnOwner.Location ));
		}

		PawnOwner.StartBloodTrail('SpawnABloodTrail_DBNO');
	}

	// Owning client gets some more goodness
	if( PCOwner != None )
	{	
		// Reset our active reload level
		PawnOwner.ActiveReload_CurrTier = 0;
		// Make sure we leave cover
		PCOwner.LeaveCover();
		// Send PC controller to proper state
		PCOwner.GoToReviving();

		if( PCOwner.IsLocalPlayerController() )
		{
			PawnOwner.PlaySound(SoundCue'Interface_Audio.Interface.DeathModeEnter01Cue', true);
			PawnOwner.ReviveHeartbeatSound = PawnOwner.SoundGroup.PlayFoleySoundEx(PawnOwner, GearFoley_SlowHeartbeat);
			PawnOwner.FlatLiningSound = PawnOwner.SoundGroup.PlayFoleySoundEx(PawnOwner, GearFoley_RevivingFlatliningSound);

			// scale the camera color based on the revival time
			//GearPlayerCamera(PCOwner.PlayerCamera).SetDesiredColorScale(vect(0.8f,0.3f,0.3f), GRI.InitialRevivalTime);

			// point camera downward
			GearPlayerInput(PCOwner.PlayerInput).ForcePitchCentering(TRUE, TRUE, -2500);
		}

		PCOwner.GuardianAngelWasDowned();
	}

	// Send AI to proper state.
	if( AIOwner != None )
	{
		AIOwner.SetDesiredRotation( AimRot, TRUE, TRUE, 0.15f );
		AIOwner.GoDBNO( AimRot );
	}

	PawnOwner.AddToLocalDBNOList();
	PawnOwner.bIsCrawling = TRUE;

	DBNOStartLocation = PawnOwner.Location;
	bTriggeredCrawlingGUDS = FALSE;

	// Skip playing the locational needs revive GUDs if a teammate was around to hear the ones when we went down
	bTriggeredNeedsRevivedGUDS = PawnOwner.IsNearATeammate(256.0f);

	if (PawnOwner.ControllerWhoPutMeDBNO != None)
	{
		// Notify Kismet of DBNO
		PawnOwner.TriggerEventClass( class'SeqEvt_EnteredRevivalState', PawnOwner.ControllerWhoPutMeDBNO.Pawn, 0 );
	}

	// simulate down time on clients for execution move checks
	if (PawnOwner.WorldInfo.NetMode == NM_Client)
	{
		PawnOwner.TimeStampEnteredRevivingState = PawnOwner.WorldInfo.TimeSeconds;
	}

	// clear the variables
	PawnOwner.bPlayingSelfReviving = FALSE;
	PawnOwner.bFinishedSelfReviving = FALSE;
}

function PlayStumbleAnimation()
{
	local float StumbleAnimLength;

	BS_CurrentStumbleAnim = BS_StumbleAnims[PawnOwner.SpecialMoveFlags];

	// Play body stance animation.
	StumbleAnimLength = PawnOwner.BS_Play(BS_CurrentStumbleAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

	// Get notification when stumble animation is done playing
	PawnOwner.BS_SetAnimEndNotify(BS_CurrentStumbleAnim, TRUE);
	// Turn on root motion on animation node
	// @LD - Disabled root motion for OXM demo 8/31/10
	//PawnOwner.BS_SetRootBoneAxisOptions(BS_CurrentStumbleAnim, RBA_Discard, RBA_Discard, RBA_Discard);
	//PawnOwner.BS_SetRootRotationOption(BS_CurrentStumbleAnim, RRO_Discard);
 	PawnOwner.BS_SetRootBoneAxisOptions(BS_CurrentStumbleAnim, RBA_Translate, RBA_Translate, RBA_Translate);
 	PawnOwner.BS_SetRootRotationOption(BS_CurrentStumbleAnim, RRO_Extract);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;

	// Only do this where PawnOwner is locally controller.
	// So we don't get rotation mismatch between client and server.
	if( PawnOwner.IsLocallyControlled() )
	{
		CheckForClipping();
	}

	// There's a chance that we're going to lose our anim tree due to network ordering and never complete the stumble anim properly
	// It's hard to find a good heuristic to use the timer, Base isn't always set while we're getting into a Silverback
	if (PawnOwner.Role != ROLE_Authority)
	{
		PawnOwner.SetTimer(StumbleAnimLength + 0.1f, FALSE, nameof(StumbleEnded), Self);
	}
}

/** Clean up from the stumble anim and set root motion up to crawl */
function StumbleEnded()
{
	local BasedPosition BP;

	PawnOwner.ClearTimer(nameof(StumbleEnded), Self);

	CleanUpStumbleAnimation();

	// Location is not replicated when root motion is in play, make sure clients know to get back on moving bases
	// Forcing a client update here generally is a bad idea because in high ping situations, the client will be moved while still doing root motion
	if (InterpActor_GearBasePlatform(PawnOwner.Base) != None)
	{
		PawnOwner.Vect2BP( BP, PawnOwner.Location, PawnOwner.Base );
		PawnOwner.ClientSetPawnLocationAndRotation( BP, PawnOwner.Rotation);
	}

	// Pawn is now going to move with Root Motion on.
	PawnOwner.Mesh.RootMotionMode = RMM_Velocity;

	// Stop Pawn
	PawnOwner.Velocity		= Vect(0,0,0);
	PawnOwner.Acceleration	= Vect(0,0,0);

	// Allow player to move at this point.
	SetMovementLock(FALSE);

	// Unlock Pawn rotation.
	SetLockPawnRotation(FALSE);

	PawnOwner.HolsterWeapon();
}

native final function CheckForClipping();

function CleanUpStumbleAnimation()
{
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_CurrentStumbleAnim, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootRotationOption(BS_CurrentStumbleAnim, RRO_Discard);
	// Turn off anim end notification
	PawnOwner.BS_SetAnimEndNotify(BS_CurrentStumbleAnim, FALSE);
	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local BodyStance AnimToPlay;
	local float AnimLength;

	// Stumble animation done playing
	if( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_CurrentStumbleAnim) )
	{
		StumbleEnded();
	}
	if ( PawnOwner.bPlayingSelfReviving )
	{
		if (PawnOwner.ReviveAnimType == ERAT_RECOVER)
		{
			if (PawnOwner.CurrentReviveStage == 2)
			{
				// We reached to the last animation - revive now
				PawnOwner.bFinishedSelfReviving = TRUE;

				PawnOwner.ClearTimer(nameof(PawnOwner.ClearRecovery));
				PawnOwner.ClearTimer(nameof(PawnOwner.MoveOntoNextStage));

				if (PawnOwner.Role == ROLE_Authority)
				{
					PawnOwner.DoRevival(PawnOwner);
					// I need to end SM here, otherwise, it will still blend to DBNO idle
					PawnOwner.EndSpecialMove();
				}
				else
				{
					AnimToPlay = PawnOwner.ReviveStageAnims[PawnOwner.CurrentReviveStage].ReviveAnims[ERAT_RECOVER];
					AnimLength = PawnOwner.BS_Play(AnimToPlay, 1.0f, 0.25f, 0.67f);
					PawnOwner.BS_SetPosition(AnimToPlay, AnimLength - 0.5f);
					PawnOwner.BS_SetAnimEndNotify(AnimToPlay, TRUE);
				}				
			}
			else
			{
				AnimToPlay = PawnOwner.ReviveStageAnims[PawnOwner.CurrentReviveStage].ReviveAnims[ERAT_LOOP];
				// transition to loop
				PawnOwner.BS_Play( AnimToPlay, 1.f, 0.25f, 0.25f, TRUE );
				PawnOwner.ReviveAnimType = ERAT_LOOP;
				// set timer
				PawnOwner.SetTimer(PawnOwner.ReviveStageAnims[PawnOwner.CurrentReviveStage].LoopTime/PawnOwner.GetRecoveryAnimationRate(), FALSE, nameof(PawnOwner.MoveOntoNextStage));
			}
		}
	}
}

/** called to clean up audio, particles, etc related to being DBNO
 * @note: also called by the DBNOFight special moves
 */
function CleanupDBNO()
{
	// mark that we were DNBO for handling in death
	PawnOwner.bWasDBNO = TRUE;

	// cleanup extra sounds
	PawnOwner.FadeOutAudioComponent(PawnOwner.ReviveBreathSound,0.1f);
	PawnOwner.FadeOutAudioComponent(PawnOwner.FlatLiningSound,0.1f);
	PawnOwner.FadeOutAudioComponent(PawnOwner.ReviveHeartbeatSound,0.1f);

	// turn off and remove the PSC so we are not constantly ticking it
	if( PSC_DBNO_BloodCrawlSpurt != None )
	{
		PSC_DBNO_BloodCrawlSpurt.DeactivateSystem();
		// the PSC will return to the pool on its own when it finishes dying
		PSC_DBNO_BloodCrawlSpurt = None;
	}

	PawnOwner.ClearTimer(nameof(StumbleEnded), Self);

	// Clean up animation if stopped early
	CleanUpStumbleAnimation();

	PawnOwner.StopBloodTrail( 'SpawnABloodTrail_DBNO' );

	// Reset crawling variable.
	PawnOwner.bIsCrawling = PawnOwner.default.bIsCrawling;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance AnimToStop;
	local GearPawn_Infantry GPI;

	// if they're not called yet, clear it, so that it doesn't get called
	PawnOwner.ClearTimer(nameof(PawnOwner.ClearRecovery));
	PawnOwner.ClearTimer(nameof(PawnOwner.MoveOntoNextStage));

	// high lag pawns are left standing at the top of the pose until the server ends the move
	PawnOwner.CurrentReviveStage = 0;
	PawnOwner.bPlayingSelfReviving = FALSE;
	AnimToStop = PawnOwner.ReviveStageAnims[2].ReviveAnims[ERAT_RECOVER];
	PawnOwner.BS_SetAnimEndNotify(AnimToStop, FALSE);
	PawnOwner.BS_Stop(AnimToStop, 0.67f);

	CleanUpDBNO();

	if (NextMove != SM_Hostage)
	{
		// reset the DBNO time
		PawnOwner.TimeOfDBNO = 0;
	}

	GPI = GearPawn_Infantry(PawnOwner);
	if (GPI != none && GPI.DBNO_POI != None)
	{
		GPI.DBNO_POI.DisablePOI();
	}

	PawnOwner.Velocity = vect(0,0,0);
	PawnOwner.Acceleration = vect(0,0,0);
	PawnOwner.Mesh.RootMotionVelocity = vect(0,0,0);
	PawnOwner.Mesh.RootMotionDelta.Translation = vect(0,0,0);

	if ( PCOwner != None && PCOwner.IsLocalPlayerController() )
	{
		// we pointed camera down earlier, reset it to 0 now
		GearPlayerInput(PCOwner.PlayerInput).ForcePitchCentering(TRUE, TRUE, 0);

		// remove revive/bleedout/martyr icons
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
	}

	// if it's finished self reviving, unholster weapon
	// when self reviving happens, DBNO recovery is almost skipped for client
	if (PawnOwner.bFinishedSelfReviving)
	{
		PawnOwner.UnHolsterWeapon();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function Tick(float DeltaTime)
{
	// once pawn has crawled a certain distance, trigger event.
	if (!bTriggeredCrawlingGUDS && VSize(PawnOwner.Location - DBNOStartLocation) > 128.0)
	{
		bTriggeredCrawlingGUDS = TRUE;
		if (PawnOwner.WorldInfo.Game != None)
		{
			GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_DBNOPawnCrawlingAway, PawnOwner);
		}
	}

	if (!bTriggeredNeedsRevivedGUDS)
	{
		if (PawnOwner.IsNearATeammate(256.0f))
		{
			if (PawnOwner.WorldInfo.Game != None)
			{
				GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_NeedsRevived_Nearby, PawnOwner);
			}
			bTriggeredNeedsRevivedGUDS = TRUE;
		}
	}

	// if moving or crawn speed modifier is < 0.1
	// OR if fast reviving is set or last stage, there is no fail, just keep going
	// OR if already finished animation, do not come back to recovering again - this happens in client - delay
	if( !PawnOwner.bFinishedSelfReviving)
	{
		if ((PawnOwner.CurrentReviveStage >= 1) || (PawnOwner.CrawlSpeedModifier > 0.f && VSizeSq(PawnOwner.Acceleration) <= 0))
		{
			PawnOwner.TickDBNORecovery();
		}
		else if ( PawnOwner.bPlayingSelfReviving && PawnOwner.ReviveAnimType != ERAT_FAIL )
		{
			PawnOwner.PlayRecoveryFailing();
		}
	}

	super.Tick(DeltaTime);
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// Slow down turning.
	Input.aTurn *= 0.33;
}

defaultproperties
{
	BS_StumbleAnims[EDTDefault]=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_Drop")))
	BS_StumbleAnims[EDTSpin]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Drop_Spin180")))
	BS_StumbleAnims[EDTRoadieRun]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Drop_RoadieRun")))

	GuardToggleBlendTime=0.33

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=FALSE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE

	bDoMeshFloorConform=TRUE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
}
