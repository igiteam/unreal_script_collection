/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameplayCamera extends GameThirdPersonCamera
	config(Camera)
	native(Camera);


/** Cover camera position when in cover */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamCover;
/** Cover camera position when in cover and targeting */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamCoverTargeting;
/** Cover camera position when in cover and targeting with grenades */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamCoverTargetingGrenade;
/** crouch camera mode */
var(Camera)	protected editinline	GameThirdPersonCameraMode		GearCamCrouch;
/** Roadie run camera mode */
var(Camera)	protected editinline	GameThirdPersonCameraMode		GearCamRoadie;
/** Roadie run stab camera mode */
var(Camera)	protected editinline	GameThirdPersonCameraMode		GearCamRoadieStab;
/** targeting camera mode */
var(Camera)	protected editinline	GameThirdPersonCameraMode		GearCamTargeting;
/** targeting camera mode special to grenades */
var(Camera)	protected editinline	GameThirdPersonCameraMode		GearCamTargetingGrenade;
/** DBNO camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamDBNO;
/** Death camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamDeath;
/** Death camera mode when killed by an avalanche */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamAvalancheDeath;
/** Ragdoll camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamRagdoll;
/** Meatbag camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamMeatbag;
/** Vehicle camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamVehicle;
/** Vehicle camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamSubmarineTurret;
/** Vehicle camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamKingRaven;
/** Vehicle turret camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamVehicleTurret;
/** Vehicle turret camera mode, while targeting */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamVehicleTurretTargeting;
/** Stationary turret camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamTurret;
/** Stationary turret camera mode (targeting mode) */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamTurretTargeting;
/** Special camera mode for cinematic-esque forcewalk conversations. */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamConversation;
/** Camera mode for when using a mounted heavy weapon. */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamMountedHeavyWeapon;
/** Camera mode for when shield is deployed. */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamDeployedShield;
/** Camera mode for when riding the zipline */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamZipline;
/** Camera mode for when riding the zipline and targeting */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamZiplineTargeting;
/** Player riding brumak camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamBrumakDriver, GearCamBrumakGunner;
/** Player targeting while riding brumak */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamBrumakDriverTargeting, GearCamBrumakGunnerTargeting;
/** Brumak death cam mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamBrumakDeath;
/** Player targeting while riding brumak */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamSniperZoom;
/** Swat turn camera */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamSwatTurn;
/** Silverback deployed cam mode */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamSilverbackDeployed;
/** Player driving Silverback cam mode */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamSilverback;
/** Player controlling Ticker cam mode */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamTicker;
/** Player controlling Serapede cam mode */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamSerapede;
/** Player controlling Berserker cam mode */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamBerserker;
/** (Experimental) Ironsights camera mode. */
var(Camera) protected editinline   GameThirdPersonCameraMode       GearCamIronSights;
/** Execution camera mode */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamExecution;
/** Corpser larva camera mode (siege) */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamCorpserLarva;
/** Reaver camera mode (siege) */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamReaver;
/** Reaver targeting camera mode (siege) */
var(Camera) protected editinline	GameThirdPersonCameraMode		GearCamReaverTargeting;

/** True if camera wants to be in conversation mode. False otherwise. */
var transient bool			bConversationMode;

/** For debugging purposes */
var transient GearPawn LastGearPawn;

/** used for transitions from 1st to 3rd person */
var protected transient float SnapToLookatPointTimeRemaining;
/** SnapToLookatPoint in world space */
var protected transient vector SnapToLookatPointWorld;
var protected transient rotator LastSnapToLookatDeltaRot;


cpptext
{
	void UpdateForMovingBase(class AActor* BaseActor);

	/** Returns desired camera origin offset that should be applied AFTER the interpolation, if any. */
	virtual FVector GetPostInterpCameraOriginLocationOffset(APawn* TargetPawn) const;

	virtual FMatrix GetWorstCaseLocTransform(APawn* TargetPawn) const;

	virtual UBOOL ShouldDoPerPolyPenetrationTests(APawn* TargetPawn) const;
	virtual UBOOL ShouldDoPredictavePenetrationAvoidance(APawn* TargetPawn) const;
	virtual UBOOL ShouldIgnorePenetrationHit(FCheckResult const* Hit, APawn* TargetPawn) const;
	virtual void HandlePawnPenetration(FTViewTarget& OutVT);
};

function Init()
{

	if (GearCamCover == None)
	{
 		GearCamCover					= CreateCameraMode(class'GameplayCam_Cover');
 		GearCamCoverTargeting			= CreateCameraMode(class'GameplayCam_CoverTargeting');
 		GearCamCoverTargetingGrenade	= CreateCameraMode(class'GameplayCam_CoverTargetingGrenade');
 		GearCamCrouch					= CreateCameraMode(class'GameplayCam_Crouch');
 		GearCamRoadie					= CreateCameraMode(class'GameplayCam_RoadieRun');
 		GearCamRoadieStab				= CreateCameraMode(class'GameplayCam_RoadieRunStab');
 		GearCamTargeting				= CreateCameraMode(class'GameplayCam_Targeting');
 		GearCamTargetingGrenade			= CreateCameraMode(class'GameplayCam_TargetingGrenade');
 		GearCamDBNO						= CreateCameraMode(class'GameplayCam_DBNO');
 		GearCamDeath					= CreateCameraMode(class'GameplayCam_Death');
 		GearCamAvalancheDeath			= CreateCameraMode(class'GameplayCam_AvalancheDeath');
 		GearCamRagdoll					= CreateCameraMode(class'GameplayCam_Ragdoll');
		GearCamMeatbag                  = CreateCameraMode(class'GameplayCam_Meatbag');
 		GearCamVehicle					= CreateCameraMode(class'GameplayCam_Vehicle');
		GearCamSubmarineTurret			= CreateCameraMode(class'GameplayCam_SubTurret');
		GearCamKingRaven	            = CreateCameraMode(class'GameplayCam_Vehicle_KingRaven');
 		GearCamVehicleTurret			= CreateCameraMode(class'GameplayCam_VehicleTurret');
 		GearCamVehicleTurretTargeting	= CreateCameraMode(class'GameplayCam_VehicleTurretTargeting');
 		GearCamTurret					= CreateCameraMode(class'GameplayCam_Turret');
 		GearCamTurretTargeting			= CreateCameraMode(class'GameplayCam_TurretTargeting');
 		GearCamConversation				= CreateCameraMode(class'GameplayCam_Conversation');
 		GearCamMountedHeavyWeapon		= CreateCameraMode(class'GameplayCam_MountedHeavyWeapon');
 		GearCamDeployedShield			= CreateCameraMode(class'GameplayCam_DeployedShield');
 		GearCamBrumakDriver				= CreateCameraMode(class'GameplayCam_BrumakDriver');
 		GearCamBrumakDriverTargeting	= CreateCameraMode(class'GameplayCam_BrumakTargeting');
 		GearCamBrumakGunner				= CreateCameraMode(class'GameplayCam_BrumakGunner');
 		GearCamBrumakGunnerTargeting	= CreateCameraMode(class'GameplayCam_BrumakGunnerTargeting');
 		GearCamBrumakDeath				= CreateCameraMode(class'GameplayCam_BrumakDeath');
 		GearCamSniperZoom				= CreateCameraMode(class'GameplayCam_SniperZoom');
		GearCamSwatTurn					= CreateCameraMode(class'GameplayCam_SwatTurn');
 		GearCamSilverbackDeployed       = CreateCameraMode(class'GameplayCam_SilverbackDeployed');
 		GearCamSilverback               = CreateCameraMode(class'GameplayCam_Silverback');
		GearCamZipline                  = CreateCameraMode(class'GameplayCam_Zipline');
		GearCamZiplineTargeting         = CreateCameraMode(class'GameplayCam_ZiplineTargeting');
		GearCamTicker					= CreateCameraMode(class'GameplayCam_Ticker');
		GearCamSerapede					= CreateCameraMode(class'GameplayCam_Serapede');
		GearCamBerserker				= CreateCameraMode(class'GameplayCam_Berserker');
		GearCamIronSights				= CreateCameraMode(class'GameplayCam_IronSights');
 		GearCamExecution				= CreateCameraMode(class'GameplayCam_Execution');
		GearCamCorpserLarva				= CreateCameraMode(class'GameplayCam_CorpserLarva');
		GearCamReaver			        = CreateCameraMode(class'GameplayCam_Reaver');
		GearCamReaverTargeting			= CreateCameraMode(class'GameplayCam_ReaverTargeting');
	}

	Super.Init();
}


/** Overridden to set GameplayCam variable */
protected function GameThirdPersonCameraMode CreateCameraMode(class<GameThirdPersonCameraMode> ModeClass)
{
	local GameThirdPersonCameraMode NewMode;
	local GearGameplayCameraMode GearMode;
	NewMode = super.CreateCameraMode(ModeClass);

	GearMode = GearGameplayCameraMode(NewMode);
	if (GearMode != None)
	{
		GearMode.GameplayCam = self;
	}

	return NewMode;
}

/**
 * Per-tick focus point processing, for polling gamestate and adjusting as desired.
 */
protected event UpdateFocusPoint( Pawn P )
{
	local GearPawn	GP;
	local GearPC	GPC;

	GP = GearPawn(P);
	GPC = GearPC(P.Controller);

	if (bDoingACameraTurn)
	{
		// no POIs during camera turns
		ClearFocusPoint();
	}
 	else if( GPC != None && GPC.bLookingAtPointOfInterest )
 	{
 		// GearPC is driving things, so don't override it with the below checks
 		// still need this here, since this function polls the gamestate for focus points.
 		// nothing to really do here, though.
 	}
 	else if (GP != None && GP.IsDoingASpecialMove() && GP.SpecialMoveClasses[GP.SpecialMove].default.bCameraFocusOnPawn)
 	{
		// if evading, or doing a special move, then track head of player.
 		SetFocusOnActor(GP, GP.NeckBoneName, vect2d(3,3), vect2d(8,11));
 	}
	// give the camera mode a crack at it
	else if ( (CurrentCamMode == None) || (CurrentCamMode.SetFocusPoint(P) == FALSE) )
	{
		// Otherwise, clear focus point
		ClearFocusPoint();
	}

	if (bFocusPointSet)
	{
		// store old focus loc
		LastFocusPointLoc = ActualFocusPointWorldLoc;
		ActualFocusPointWorldLoc = GetActualFocusLocation();
	}
}


/** Overridden to handle POIs */
protected function vector GetActualFocusLocation()
{
	local GearPointOfInterest POI;

	if (FocusPoint.FocusActor != None)
	{
 		POI = GearPointOfInterest(FocusPoint.FocusActor);
 		if (POI != None)
 		{
 			// looking at an actual POI, let it tell us where to look
 			return POI.GetActualLookatLocation();
 		}
	}

	return super.GetActualFocusLocation();
}

/**
 * Evaluates the game state and returns the proper camera mode.
 *
 * @return 	  	new camera mode to use
 */
function GameThirdPersonCameraMode FindBestCameraMode(Pawn P)
{
 	local GameThirdPersonCameraMode NewCamMode;
 	local GearWeapon			W;
 	local GearWeap_HeavyBase	HW;
 	local bool					bShouldZoom, bGrenade, bSniperZoom, bUnarmedZoom, bIronSights;
 	local GearPawn				GP;
 	local GearVehicle			GearV;
 	local GearWeaponPawn		GearWP;
	local GearPC                GPC;
 	local GearPawn_LocustBrumakBase GearBrumak;
 	local GearPawn_SilverbackBase   Silverback;

	//Sometimes called with non-Pawns, return None
	if (P == None)
	{
		return None;
	}

 	GP = GearPawn(P);
	LastGearPawn = GP;

	// Since this is very often called from infantry, see if we can skip a bunch of unnecessary casts
	if (GearPawn_Infantry(GP) == None)
	{
		if (GearPawn_LocustTickerBase(GP) != None)
		{
			return GearCamTicker;
		}
		else if (GearPawn_LocustCorpserLarvaUndergroundBase(GP) != None)
		{
			return GearCamCorpserLarva;
		}
		else if (GearPawn_LocustSerapedeBase(GP) != None)
		{
			return GearCamSerapede;
		}
		else if (GearPawn_LocustBerserkerBase(GP) != None)
		{
			return GearCamBerserker;
		}
		
		GearWP = GearWeaponPawn(P);
 		if(GearWP != None)
 		{
 			GearV = GearWP.MyVehicle;
 		}
 		else
 		{
 			GearV = GearVehicle(P);
 		}

 		if(GearV == None)
 		{
 			// Look for a brumak
 			GearBrumak = GearPawn_LocustBrumakBase(P);
 			if(GearBrumak == None)
 			{
 				GearBrumak = GearPawn_LocustBrumakBase(P.Base);
 			}

 			Silverback = GearPawn_SilverbackBase(P);
 		}
	}

	GPC = GearPC(PlayerCamera.PCOwner);

 	if( Silverback != none )
 	{
 		NewCamMode = (Silverback.IsDoingSpecialMove(GSM_Silverback_CoverDeploy) ? GearCamSilverbackDeployed : GearCamSilverback);
 	}
	// if not auto reviving, use DBNO
 	else if ( (GP != None) && GP.IsDBNO() )
 	{
 		NewCamMode = GearCamDBNO;
 	}
 	else if (GearV != None)
 	{
 		// target pawn is a vehicle
		// jf: ridereavers gone in Rift?
		if (Vehicle_Reaver_Base(GearV) != None)
		{
			NewCamMode = (GPC != None && GPC.bIsTargeting) ? GearCamReaverTargeting : GearCamReaver;
		}
		else if (Vehicle_KingRaven_Base(GearV) != None)
		{
			NewCamMode = GearCamKingRaven;
		}
		else if (Vehicle_Submarine_Base(GearV) != None)
		{
			NewCamMode = GearCamSubmarineTurret;
		}
 		else
 		{
 			NewCamMode = GearCamVehicle;
 		}
 	}
 	else if(GearBrumak != None)
 	{
 		// target pawn is a brumak
 		if(GearBrumak.Health <= 0)
 		{
 			NewCamMode = GearCamBrumakDeath;
 		}
 		else
 		{
 			if( PlayerCamera.PCOwner.Pawn != None )
 			{
 				W = GearWeapon(PlayerCamera.PCOwner.Pawn.Weapon);
 			}
 			bShouldZoom = ((W != None) && W.ShouldTargetingModeZoomCamera());

 			// Driver
 			if( GearBrumak == PlayerCamera.PCOwner.Pawn )
 			{
 				if( bShouldZoom )
 				{
 					NewCamMode = GearCamBrumakDriverTargeting;
 				}
 				else
 				{
 					NewCamMode = GearCamBrumakDriver;
 				}
 			}
 			// Gunner
 			else
 			{
 				if( bShouldZoom )
 				{
 					NewCamMode = GearCamBrumakGunnerTargeting;
 				}
 				else
 				{
 					NewCamMode = GearCamBrumakGunner;
 				}

 			}
 		}
 	}
 	else if ( (P.Health <= 0 || P.bPlayedDeath) &&
 			  ( (GP == None) ||
 			    ( (GP.SpecialMove != SM_MidLvlJumpOver) && (GP.SpecialMove != SM_RecoverFromRagdoll) ) ))
 	{
		if (GP.SpecialMove == SM_Hostage)
		{
			// target pawn is a meatbag
			NewCamMode = GearCamMeatbag;
		}
		else if (ClassIsChildOf(GP.HitDamageType, class'GDT_Avalanche'))
		{
			NewCamMode = GearCamAvalancheDeath;
		}
		else
		{
 			// target pawn is dead
 			NewCamMode = GearCamDeath;
		}
 	}
	// if doing punchface, and playing camera failed
	else if ( GP != None && (GP.IsDoingSpecialMove(SM_CQCMove_PunchFace) && GSM_CQCMove_PunchFace(GP.SpecialMoves[SM_CQCMove_PunchFace]).NeedExecutionCamera()) )
	{
		// play backup camera
		NewCamMode = GearCamExecution;
	}
 	else if (GP != None && ((GP.Physics == PHYS_RigidBody) || GP.IsDoingSpecialMove(SM_RecoverFromRagdoll)) )
 	{
 		NewCamMode = GearCamRagdoll;
 	}
 	else if ( GearWeaponPawn(P) != None )
 	{
 		// manning a vehicle weapon, do we want to make
 		// something other than default here?
 		NewCamMode = GearWeaponPawn(P).ShouldTargetingModeZoomCamera() ? GearCamVehicleTurretTargeting : GearCamVehicleTurret;
 	}
 	else if ( GearTurret(P) != None )
 	{
 		NewCamMode = GearTurret(P).ShouldTargetingModeZoomCamera() ? GearCamTurretTargeting : GearCamTurret;
 	}
 	else if (bConversationMode)
 	{
 		NewCamMode = GearCamConversation;
 	}
 	else
 	{
 		if (GP != None)
 		{
 			W = GearWeapon(P.Weapon);
 			HW = GearWeap_HeavyBase(W);

 			// see if we should enter targeting mode view
 			bShouldZoom =	( (W != None) && W.ShouldTargetingModeZoomCamera() 		// weapon must not be reloaded
 				&& (GP.CoverType == CT_None || GP.IsLeaning() || GP.bDoing360Aiming || GP.IsPoppingUp() || GP.IsDoingLeaningTo360Transition() ) // not in cover, or leaning in cover
				);

 			bGrenade = (GearWeap_GrenadeBase(W) != None);
 			bSniperZoom = GP.bIsZoomed && W != None &&
 						(W.bIsScopeWeapon || GearWeap_HeavySniperBase(W) != None) && W.ShouldTargetingModeZoomCamera();
			bUnarmedZoom = bShouldZoom && W.bTemporaryHolster;

			bIronSights = (W != None && W.bIronSightsCamera);

 			if( (HW != None) && (HW.IsMounted() || HW.IsBeingMounted()) && !bSniperZoom )
 			{
 				// heavy weapons, while propped up, get turret cam for now
 				NewCamMode = GearCamMountedHeavyWeapon;
 			}
 			else if (GP.IsDeployingShield())
 			{
 				NewCamMode = GearCamDeployedShield;
 			}
			else if (GP.SpecialMove == SM_StdLvlSwatTurn)
			{
				NewCamMode = GearCamSwatTurn;
			}
			else if (GP.SpecialMove == SM_ZiplineIdle)
			{
				if( bShouldZoom )
				{
					NewCamMode = GearCamZiplineTargeting;
				}
				else
				{
					NewCamMode = GearCamZipline;
				}
			}
 			else if( (GP.CoverType != CT_None) && (GPC == None || !GPC.bBreakFromCover) && (GP.SpecialMove != SM_MantleUpLowCover) )
 			{
				if (bIronSights)
				{
					NewCamMode = GearCamIronSights;
				}
				else if (bSniperZoom)
				{
					NewCamMode = GearCamSniperZoom;
				}
				else if( bShouldZoom )
 				{
 					NewCamMode = (bGrenade ? GearCamCoverTargetingGrenade : GearCamCoverTargeting);
 				}
 				else
 				{
 					NewCamMode = GearCamCover;
 				}
 			}
 			else
 			{
				if (bIronSights)
				{
					NewCamMode = GearCamIronSights;
				}
				else if (bSniperZoom)
				{
					NewCamMode = GearCamSniperZoom;
				}
				else if( bShouldZoom )
 				{
					if( bUnarmedZoom )
					{
						NewCamMode = GearCamTargeting;
					}
					else if( bGrenade )
					{
						NewCamMode = GearCamTargetingGrenade;
					}
					else
					{
						NewCamMode = GearCamTargeting;
					}
 				}
 				else if( GP.bIsCrouched )
 				{
 					NewCamMode = GearCamCrouch;
 				}
 				else if( GP.SpecialMove == SM_RoadieRun || (GP.SpecialMove == SM_MantleDown && GSM_MantleDown(GP.SpecialMoves[SM_MantleDown]).TransitionFromRoadieRun) )
 				{
 					NewCamMode = GearCamRoadie;
 				}
				else if( GP.SpecialMove == SM_RoadieRunStab )
				{
					NewCamMode = GearCamRoadieStab;
				}
 				else
 				{
 					NewCamMode = ThirdPersonCamDefault;
 				}
 			}
 		}
 	}

 	if (NewCamMode == None)
 	{
 		`log("Could not find appropriate camera mode, using GearCamDefault!");
 		NewCamMode = ThirdPersonCamDefault;
 	}

 	return NewCamMode;
}


simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas	Canvas;

	Super.DisplayDebug(HUD, out_YL, out_YPos);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	Canvas.DrawText( "  " @ `showvar(CurrentCamMode) @ `showvar(GearWeapon(LastGearPawn.Weapon).ShouldTargetingModeZoomCamera()) );
	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
}

/**
 * We're no longer in a 3rd person camera at all, shut down the current camera mode gracefully
 * The only camera that currently needs to shut down like this is sniper zoom
 * 
 * @param NewCamera - the new game camera style we're switching to
 */
function OnBecomeInActive(GameCameraBase NewCamera)
{
	if (CurrentCamMode != None)
	{
		CurrentCamMode.OnBecomeInActive(None, None);
	}

	SnapToLookatPointTimeRemaining = 0.f;
}

function ForceNextFrameLookatPoint(vector LookatPointWorld, float Duration)
{
	SnapToLookatPointWorld= LookatPointWorld;
	SnapToLookatPointTimeRemaining = Duration;

//	PlayerCamera.PCOwner.DrawDebugBox(LookatPointWorld, vect(6,6,6), 64, 255, 64, true);
}

/** 
 *  Returns the rotation the controller needs to be to make the camera point at a specific world location.
 */
protected function rotator GetOriginRotThatPointsCameraAtPoint(vector Pivot, rotator PivotRot, vector CameraPos, vector LookatWorld)
{
	local vector CamToLookat, CamLocalOffset;
	local int IterationIdx;
	local rotator NewPivotRot;

//	local rotator PerfectPivotRot, RotError;

	if ( VSize(Pivot - CameraPos) > VSize(Pivot - LookatWorld) )          // the 1.5f is safety/fudge, could be larger prolly
	{
		// unsolveable
		return PivotRot;
	}

//  	PlayerCamera.PCOwner.DrawDebugBox(LookatWorld, vect(4,4,4), 255, 64, 0, true);
//  	PlayerCamera.PCOwner.DrawDebugBox(CameraPos, vect(4,4,4), 255, 0, 255, true);
//  	PlayerCamera.PCOwner.DrawDebugLine(CameraPos, CameraPos + vector(PivotRot) * 2048.f, 255, 0, 255, true);

	CamLocalOffset = (CameraPos - Pivot) << PivotRot;       // get pivot-local space
	
	// since rotating the controller moves the camera's location and rotation, need to iteratively solve
	// this.  Each iteration should get closer to the true result.
	// 3 seems to do the trick here, derived empirically.
	for (IterationIdx=0; IterationIdx<3; IterationIdx++)
	{
		CamToLookat = LookatWorld - CameraPos;
		NewPivotRot = rotator(CamToLookat);

		// find out where camera would be at the new pivot rot, assuming same offset
		CameraPos = Pivot + (CamLocalOffset >> NewPivotRot);

// 		PlayerCamera.PCOwner.DrawDebugBox(CameraPos, vect(4,4,4), 255, 255, 40*IterationIdx, true);
// 		PlayerCamera.PCOwner.DrawDebugLine(CameraPos, CameraPos + vector(NewPivotRot) * 2048.f, 255, 255, 40*IterationIdx, true);
	}

	// test code to see if it's close
// 	PerfectPivotRot = rotator(LookatWorld - CameraPos);
// 	RotError = PerfectPivotRot - NewPivotRot;

	return NewPivotRot;
}

function AdjustFocusPointInterpolation(rotator Delta)
{
	local rotator AdjustedDelta, NewBasisRot;
	local vector CamLocalOffset;

	super.AdjustFocusPointInterpolation(Delta);

	if (LastSnapToLookatDeltaRot != rot(0,0,0))
	{
		AdjustedDelta = Normalize(Delta - LastSnapToLookatDeltaRot);

		// put it into cam origin space
		CamLocalOffset = (SnapToLookatPointWorld - LastIdealCameraOrigin) << LastIdealCameraOriginRot;

		// rotate it and put it back into world space
		NewBasisRot = LastIdealCameraOriginRot + AdjustedDelta;
		SnapToLookatPointWorld = LastIdealCameraOrigin + (CamLocalOffset >> NewBasisRot);
	}
}

function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local rotator DesiredPivotRot, DeltaRot;

	Super.UpdateCamera(P, CameraActor, DeltaTime, OutVT);

	if (SnapToLookatPointTimeRemaining > 0.f)
	{
		DesiredPivotRot = GetOriginRotThatPointsCameraAtPoint(LastIdealCameraOrigin, LastIdealCameraOriginRot, OutVT.POV.Location, SnapToLookatPointWorld);
		DeltaRot = Normalize(DesiredPivotRot - LastIdealCameraOriginRot);
		if (DeltaRot == rot(0,0,0))
		{
			// stop
			SnapToLookatPointTimeRemaining = 0.f;
		}
		else
		{
			GearPC(PlayerCamera.PCOwner).ExtraRot += DeltaRot; 
			SnapToLookatPointTimeRemaining -= DeltaTime;
		}

		LastSnapToLookatDeltaRot = DeltaRot;
	}
}

defaultproperties
{
	ThirdPersonCamDefaultClass=class'GameplayCam_Default'
}


