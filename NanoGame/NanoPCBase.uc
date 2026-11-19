/**
 * NanoPCBase holds all of the non-nano specific PlayerController functions and vars
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPCBase extends GamePlayerController
	dependson(NanoPointOfInterest)
	config(Game)
	native(PC);


/** NanoPawn we're controlling, if we're controlling a turret */
var transient NanoPawn MyNP;
/** Turret we're controlling, if we're controlling a turret */
var transient NanoTurretBase MyTurret;

var transient NanoHud_Base MyNanoHUD;


/** Last friction target */
var transient Actor LastFrictionTarget;
/** Last friction target acquire time */
var transient float LastFrictionTargetTime;


/** Target we are forcibly adhering to. */
var NanoPawn ForcedAdhesionTarget;


struct native LocalEnemy
{
	/** reference to the enemy warpawn */
	var NanoPawn	Enemy;

	/** holds results of last LOS check */
	var bool	bVisible;

	/** true if enemy has ever been visible */
	var bool	bSeen;

	/** true if there is LOS...  this does NOT exclude enemies behind you like bVisible does */
	var bool	bHasLOS;
};

/** cache to store LOS status of enemies */
var array<LocalEnemy> LocalEnemies;

/** Idx in LocalEnemies array of next enemy to check for LOS (we only check one per frame */
var transient int NextLocalEnemyToCheckLOS;

/** The distance of the trace to determine if a player is friendly or not */
var() config float DistanceForEnemyTrace;

/** Whether TargetAdhesion is enabled or not **/
var() config bool bTargetAdhesionEnabled;

var config protected bool bDebugTargetAdhesion;

var(Debug) bool     bDebugAI;
var(Debug) NanoAI   DebugAIController;

var(Debug) bool     bDebugRoad;

/** Is this player in combat?  Set by IsInCombat(), and should never be referenced directly. */
var transient private float LastCheckIsInCombatTime;

/** Keeps track of active input-disabling requests */
var int InputIsDisabledCount;

/** List of enabled POIs */
var	private array<NanoPointOfInterest>	EnabledPointsOfInterest;
/** List that matches EnabledPointsOfInterest which determines if the POI in the same index has been looked at yet */
var private array<bool>					POILookedAtList;

/** Are we currently looking at a point of interest? */
var bool bLookingAtPointOfInterest;
var NanoPointOfInterest					CurrLookedAtPOI;

/** Played when we get a new POI **/
var SoundCue PointOfInterestAdded;
/** Last Time we played a POI Sound */
var float LastPoITime;
/** How long between POI Sounds*/
var() float PoIRepeatTime;

/** action info associated with looking at a focus point, and the timer that goes with it. */
var const ActionInfo ActionLookAt;

/** Is god mode currently enabled by a camera look at? */
var bool bCameraGodMode;

/** a bit kludgey here...borrowed from gears.  system need some architectural love */
var bool	bCameraLookAtIsFromKismet;
/** If TRUE, the player will continually face the camera target */
var transient bool  bCameraLookFaceTarget;

/** Interp speed range for looking at points of interest.  bonus points for long var name. */
var() vector2d PointOfInterestLookatInterpSpeedRange;

const Player_NearMissDistance	= 200;
const Player_BulletWhipDistance = 512;

cpptext
{
	/**
 	 * This will score both Adhesion and Friction targets.  We want the same scoring function as we
	 * don't want the two different systems fighting over targets that are close.
	 **/
	virtual FLOAT ScoreTargetAdhesionFrictionTarget( const AActor* P, FLOAT MaxDistance, const FVector& CamLoc, const FRotator& CamRot ) const;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// store the points of interest for clients
	StorePointsOfInterest();
}

event PlayerTick( float DeltaTime )
{
	Super.PlayerTick(DeltaTime);

	if ( IsLocalPlayerController() )
	{
		MaintainEnemyList();
	}

	// if we were looking at a POI that got deleted (streamed out), stop it
	if ( bLookingAtPointOfInterest && (GetCameraFocusActor() == None) )
	{
		StopForceLookAtPointOfInterest(false);
	}

	if( NanoPawnBase(Pawn) != None )
	{
		UpdateHUDActions(DeltaTime);
	}
}

/** Returns TRUE if the button is currently held. */
final event bool IsButtonActive(EGameButtons Button, optional bool bRaw, optional out float HoldTime)
{
	if ( PlayerInput == None )
	{
		`warn("PlayerInput is NULL - should NOT be called on nonlocal players!");
		ScriptTrace();
		return FALSE;
	}

	return NanoPlayerInput_Base(PlayerInput).IsButtonActive( Button, bRaw, HoldTime );
}


/**
* Test code for bullet-attractor method of autoaim.  Experimental
* for now, we'll see how it feels to the masses.
*/
function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local Actor			BestTarget;
	local NanoPawn		TargetWP;
	local NanoWeapon	WW;
	local vector		AttractPt, BaseAimDir, ToAttractorNorm, BestToAttrNorm;
	local Rotator		BaseAimRot;
	local float			Alpha, BestAttrAlpha, AimAssistScale;
	local int			AttractorIdx, NumAttractors;
	local AimAttractor	Attr;
	local vector		UnusedVec1, UnusedVec2;
	local NanoAimAssistActor TargetGAAA;
	local Pawn			ShootingPawn;

	ShootingPawn = Pawn;
	

	// Get default rot so we can return it or base
	// aim assistance calcs off of it, as necessary
	BaseAimRot = (ShootingPawn != None) ? ShootingPawn.GetBaseAimRotation() : Rotation;

	WW = NanoWeapon(W);
	if (WW == None)
	{
		return BaseAimRot;
	}

	BestTarget = GetFrictionAdhesionTarget(WW.WeaponRange);
	ShotTarget = Pawn(BestTarget);

	// we want steady aiming regardless of camera shake and stuff like that.
 	BaseAimRot = NanoPlayerCamera(PlayerCamera).Cam_3p.LastPreModifierCameraRot;
	//`log(`location@`showvar(BaseAimRot));

	if (!WW.bInstantHit)
	{
		// not firing a Nanoweapon, what's going on?
		return BaseAimRot;
	}

	// early out check, so we can maybe skip any traces or other geom queries.
	AimAssistScale = NanoPawn(Pawn).bIsTargeting ? WW.AimAssistScaleWhileTargeting : WW.AimAssistScale;
	if( AimAssistScale <= 0.f )
	{
		//`log("no assist");
		return BaseAimRot;
	}

	BaseAimDir = vector(BaseAimRot);

	if ( BestTarget == None )
	{
		//`log("no target");
		// no one around worth autoaiming at
		return BaseAimRot;
	}

	TargetWP = NanoPawn(BestTarget);
	TargetGAAA = NanoAimAssistActor(BestTarget);

	// If no target OR is aiming and close to the target and not shotgun OR target is protected by cover
	if( ((TargetWP == None) && (TargetGAAA == None))
		|| ( VSize(BestTarget.Location - ShootingPawn.Location) < 128 )
		|| ( NanoPawn(Pawn).bIsTargeting && ( VSize(BestTarget.Location - ShootingPawn.Location) < 512 ) )
		)
	{
		//`log("no aim");
		// No aim adjust
		return BaseAimRot;
	}

	// aim at target - help with leading also
	// @todo (if this passes poc stage)
	// - handle non-instant-hit weapons
	// - it's possible in multiplayer to have different autoaim params,
	//    it would be good to unify the values so this isn't a subtle bug later

	BaseAimDir = vector(BaseAimRot);

	if (TargetWP != None)
	{
		// don't do aim attraction if base aim will hit target (it's presumably unneeded
		if (!TraceComponent(UnusedVec1, UnusedVec2, TargetWP.Mesh, (StartFireLoc + BaseAimDir*10000), StartFireLoc))
		{
			NumAttractors = TargetWP.AimAttractors.Length;

			for (AttractorIdx=0; AttractorIdx<NumAttractors; ++AttractorIdx)
			{

				Attr = TargetWP.AimAttractors[AttractorIdx];

				//`log( "testing " @ Attr.BoneName );

				// get world pos of attractor
				AttractPt = TargetWP.Mesh.GetBoneLocation(Attr.BoneName);

				EvalAimAttractor(Attr, Alpha, ToAttractorNorm, StartFireLoc, BaseAimDir, AttractPt, AimAssistScale);

				// decide which is the best attractor and use it
				if ( (Alpha > BestAttrAlpha) && FastTrace(AttractPt, StartFireLoc) )
				{
					//`log( "Attr " @ AttractorIdx @ Attr.BoneName @ Alpha @ BestTarget @ AttractPt );
					BestAttrAlpha = Alpha;
					BestToAttrNorm = ToAttractorNorm;
				}
			}
		}
	}
	else if (TargetGAAA != None)
	{
		TargetGAAA.GetAimAttractorRadii(Attr.InnerRadius, Attr.OuterRadius);
		EvalAimAttractor(Attr, BestAttrAlpha, BestToAttrNorm, StartFireLoc, BaseAimDir, TargetGAAA.Location, AimAssistScale);
	}

	//`log("AimAttracted to "@TargetWP@BestAttrAlpha);
	return RLerp(BaseAimRot, rotator(BestToAttrNorm), BestAttrAlpha, TRUE);
}

simulated protected final function EvalAimAttractor(const out AimAttractor Attr, out float AttractorAlpha, out vector ToAttractorNorm, vector StartFireLoc, vector BaseAimDir, vector AttractPt, float AimAssistScale)
{
	local float ToAttractorDist, DotExtentInner, DotExtentOuter;
	local float AttractDot, ToAttractorDistSq;

	// init to no attraction
	AttractorAlpha = 0.f;

	// vector from shot origin to attractor
	ToAttractorNorm = AttractPt - StartFireLoc;
	ToAttractorDist = VSize(ToAttractorNorm);
	if (ToAttractorDist >= 0.f)
	{
		ToAttractorDistSq = Square(ToAttractorDist);
		ToAttractorNorm /= ToAttractorDist;

		// actual dot of my aim
		AttractDot = BaseAimDir dot ToAttractorNorm;

		// in front?
		if (AttractDot > 0.0f)
		{
			// solving for cos(angle)
			DotExtentOuter = ToAttractorDist / Sqrt(Square(Attr.OuterRadius * AimAssistScale) + ToAttractorDistSq);
			DotExtentInner = ToAttractorDist / Sqrt(Square(Attr.InnerRadius * AimAssistScale) + ToAttractorDistSq);

			// how much attraction do we get?
			AttractorAlpha = (AttractDot - DotExtentOuter) / (DotExtentInner - DotExtentOuter);
			AttractorAlpha = FClamp(AttractorAlpha, 0.f, 1.f);
		}
	}
}


/** Deal with list of nearby enemies, keep it up to date and all that. */
final native function MaintainEnemyList();

/** Returns which target we should use for friction (or adhesion), or None if none are appropriate. */
final native function Actor GetFrictionAdhesionTarget(float MaxDistance, optional bool bAdhesion);


final event NoticeEnemy(Pawn Noticer, Pawn Noticee)
{
	local NanoGame	SPGame;
	SPGame = NanoGame(WorldInfo.Game);
	if (SPGame != None)
	{
		SPGame.BattleMonitor.NotifyEnemyNoticed(Noticer, Noticee);
	}
}

simulated function bool IsViewingTarget(Actor TargetActor)
{
	if (GetViewTarget() == TargetActor)
	{
		// we don't consider "fixed" cameramode as viewing the target
		if ( (PlayerCamera != None) && (PlayerCamera.CameraStyle != 'Fixed') )
		{
			return TRUE;
		}
	}

	return FALSE;
}


exec function SetAIDrawDebug( bool bOn )
{
	local NanoAI AI;
	foreach WorldInfo.AllControllers(class'NanoAI', AI)
	{
		AI.bAIDrawDebug = bOn; 
	}
}

function DebugDraw_AI(NanoHUD_Base H)
{
	local vector CamLoc;
	local rotator CamRot;
	local NanoAI AI;
	local String Str;
	local float	X, Y;
	local NanoTargetPoint NTP;

	H.Canvas.Font = class'Engine'.static.GetTinyFont();
	H.Canvas.SetDrawColor(255,255,255);

	if( DebugAIController != None )
	{
		DrawDebugLine( DebugAIController.Pawn.Location, DebugAIController.Pawn.Location + vect(0,0,4096), 255, 0, 0 );
		DebugAIController.DrawDebug( H, TRUE );
	}
	else
	{
		GetPlayerViewPoint(CamLoc,CamRot);
		foreach WorldInfo.AllControllers(class'NanoAI', AI)
		{
			if( AI.bAIDrawDebug && AI.Pawn != None && (AI.Pawn.Location - CamLoc) dot vector(CamRot) > 0.f )
			{
				AI.DrawDebug( H );
				//AI.NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
				//AI.NavigationHandle.bUltraVerbosePathDebugging = TRUE;
			}
			else
			{
				//AI.NavigationHandle.bDebugConstraintsAndGoalEvals = FALSE;
				//AI.NavigationHandle.bUltraVerbosePathDebugging = FALSE;
			}
		}
	}

	foreach WorldInfo.AllActors(class'NanoTargetPoint', NTP)
	{
		if( (NTP.Location - CamLoc) dot vector(CamRot) > 0.f )
		{
			NTP.DrawDebug( H );
		}
	}




	X = H.SizeX - 160;
	Y = H.SizeY - 20;
	H.Canvas.SetPos( X, Y );

	Str = "Frame Time:"@WorldInfo.TimeSeconds;
	H.Canvas.DrawText( Str, TRUE );
}

function DebugDraw_Road(NanoHUD_Base H)
{
	local vector CamLoc, ToSpline, LookDir, ScreenLoc;
	local rotator CamRot;
	local NanoVehicleSpline VSpline;

	GetPlayerViewPoint(CamLoc,CamRot);
	LookDir = vector(CamRot);

	foreach WorldInfo.AllActors(class'NanoVehicleSpline', VSpline)
	{
		ToSpline = VSpline.Location - CamLoc;

		if((VSize(ToSpline) < 10000.0) && (ToSpline dot LookDir > 0.0))
		{
			ScreenLoc = H.Canvas.Project( VSpline.Location + vect(0,0,1) );
			H.Canvas.SetPos( ScreenLoc.X, ScreenLoc.Y );

			if(VSpline.bPlayerHasLineOfSight)
			{
				H.Canvas.SetDrawColor(255,200,200);
			}
			else
			{
				H.Canvas.SetDrawColor(200,200,255);
			}

			H.Canvas.DrawText(VSpline.SpawnerPriority);
		}
	}
}

/** Returns whether or not we think the player is in combat */
event bool IsInCombat( optional bool bForceCheck )
{
	local NanoGRI NGRI;
	local NanoAI AI;
	local bool bWasInCombat;

	// if we don't have a gear pawn we can't be in combast
	if (MyNP == None)
	{
		return FALSE;
	}

	// server replicates combat state to client
	if (Role < ROLE_Authority)
	{
		// so just return the cached version
		return MyNP.bIsInCombat;
	}

	NGRI = NanoGRI(WorldInfo.GRI);

	// only update the cached value if it's been a while
	if( ( `TimeSince( LastCheckIsInCombatTime ) > 0.5f ) || ( bForceCheck == TRUE ) )
	{
		//`log( "IsInCombat checking" );
		bWasInCombat = MyNP.bIsInCombat;
		LastCheckIsInCombatTime = WorldInfo.TimeSeconds;

		MyNP.bIsInCombat = FALSE;
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			// If there is a controller that has an enemy on the other team
			if( AI != none 
				&& AI.Pawn != None 
				&& AI.Pawn.Health > 0
				&& AI.FireTarget != None 
				&& ( Pawn(AI.FireTarget) == None || ( Pawn(AI.FireTarget).IsSameTeam( AI.Pawn ) == FALSE ) )// targeting an actor  OR if I am targeting a pawn then they are not on the same team as me
				//&& ( AI.GetStateName() != 'Idle' )
				&& ( AI.CommandList != None )
				&& ( AI.FindCommandOfClass( class'NanoAIAction_EngageThreatBase' ) != None )
				&& ( VSize( AI.Pawn.Location - MyNP.Location ) < 2048.0f )  // if they are close
				)
			{
				//`log( "bIsInCombat = TRUE" @ C @ C.Enemy );
				// Consider them in combat
				// This is bogus for Nano.  We need to check that the enemies are actually wanting to attack lyrik
				MyNP.bIsInCombat = TRUE;
				if( NGRI.WorldStateSettings.bMusicManagerEnabled == TRUE )
				{
					if( ( CurrentSoundMode != 'CombatRapidMotion' ) && ( CurrentSoundMode != 'Combat_ChaosAnnounce' ) )
					{
						SetSoundMode( 'Combat' );
					}
				}
				break;
			}

			//`log( C @ C.Pawn @ C.Pawn.Health @ C.Enemy @ C.GetStateName() );
		}

		//`log( `showvar(bWasInCombat) @ `showvar(MyNP.bIsInCombat) );
	}


	// if we were just in combat and killed them all then we are not in combat any more
	if( ( bWasInCombat == TRUE ) && ( MyNP.bIsInCombat == FALSE ) )
	{
 		if( NGRI.GetCurrentChaosLevel() == 0 )
 		{
 			SetSoundMode( 'Default' );
 		}
 		else
 		{
 			//NGRI.GetMusicManager().HandleMusicEvent( EME_ChaosLevelOne );
 		}

		NGRI.NGM.ResetGorePeriodicity();

	}

	return MyNP.bIsInCombat;
}



/** This is our helper function which will allow us to call Eval on the InterpCurveFloat **/
final native function float GetValueFromRange( const out InterpCurveFloat TheCurve, float value ) const;

function bool CanPickupWeapons()
{
	return TRUE;
}

/**
* Checks various special moves to show the tip icon if necessary.
*/
final function UpdateHUDActions(float DeltaTime)
{
	local NanoPawnBase              NPB;
	local vector					StartTrace, EndTrace, TraceDir;
	local rotator					CamRot;
	local string					HitPawnName;
	local NanoVehicleAgent          Vehicle;

	if ( MyNanoHUD == None )
	{
		return;
	}

	NPB = NanoPawnBase(Pawn);

	// start the trace from the camera location
	GetPlayerViewPoint(StartTrace, CamRot);
	TraceDir = vector(CamRot);
	EndTrace = StartTrace + (TraceDir * DistanceForEnemyTrace);

	//Figures out who/what we are hitting (HitPawn)
	if ( NPB != None && NPB.bIsTargeting )
	{
		AssignHitTargets(StartTrace, EndTrace, TraceDir, HitPawnName);
	}

	// if we are showing a scripted icon and the poi for it was disabled, turn off the icon
	if ( MyNanoHUD.ActiveAction.bActive && MyNanoHUD.ActiveAction.ActionType == AT_Scripted && CurrLookedAtPOI != None &&
		(!CurrLookedAtPOI.bEnabled || CurrLookedAtPOI.CurrIconDuration <= 0.0) )
	{
		MyNanoHUD.ClearActionInfoByType(AT_Scripted);
	}

	Vehicle = NanoVehicleAgent(Pawn.Base);
	if( Vehicle != None && Vehicle.ShouldShowActionInfo() )
	{
		MyNanoHUD.SetActionInfo(AT_Vehicle, Vehicle.InteractAction);
	}
	else
	{
		MyNanoHUD.ClearActionInfoByType(AT_Vehicle);
	}

	CheckEnabledPointsOfInterest(DeltaTime);
}

final function AssignHitTargets(const vector StartTrace, const vector EndTrace, const vector TraceDir, out string HitPawnName)
{
	local vector				HitLoc, HitNormal;
	local NanoPawnBase			HitNP;
	local ImpactInfo			Impact;
	local Actor					HitActor;

	// do the trace to see what's in our sights
	CalcWeaponFire( StartTrace, EndTrace, HitLoc, HitNormal, HitActor, Impact );

	HitNP = NanoPawnBase( HitActor );

	//Record the name of the hit target
	if (HitNP != None && HitNP.PlayerReplicationInfo != None)
	{
		HitPawnName = HitNP.PlayerReplicationInfo.PlayerName;
	}
}

simulated function CalcWeaponFire( Vector StartTrace, Vector EndTrace, out Vector out_HitLocation, out Vector out_HitNormal, out Actor out_HitActor, out ImpactInfo out_HitImpact )
{
	if( Pawn != None && Pawn.Weapon != None)
	{
		out_HitImpact = Pawn.Weapon.CalcWeaponFire( StartTrace, EndTrace );
		out_HitLocation = out_HitImpact.HitLocation;
		out_HitNormal	= out_HitImpact.HitNormal;
		out_HitActor	= out_HitImpact.HitActor;
		if( out_HitActor == None )
		{
			out_HitLocation = EndTrace;
		}
	}
	else
	{
		// use old-school trace. this might hit triggers and such.
		out_HitActor = Trace(out_HitLocation, out_HitNormal, EndTrace, StartTrace, TRUE,, out_HitImpact.HitInfo, TRACEFLAG_Bullet);
	}
}

simulated function Pawn GetMyRealPawn()
{
	local Pawn MyPawn;
	local Vehicle NPVehicle;
	local NanoPawnBase NP;

	MyPawn = Pawn;
	NPVehicle = Vehicle(Pawn);
	if ( NPVehicle != None )
	{
		NP = NanoPawnBase(NPVehicle.Driver);
		if ( NP != None )
		{
			MyPawn = NPVehicle.Driver;
		}
		else
		{
			NP = NanoPawnBase(ViewTarget);
			if ( NP != None )
			{
				MyPawn = Pawn(ViewTarget);
			}
		}
	}

	return MyPawn;
}

/**
*  Check to see if there is any possibility for interaction with a pickup
*  Code broken out from UpdateHUDActions(), expects that the CanPickupWeapons() function returns true
*/
final function CheckForPickups()
{
	local NanoPawnBase NPB;
	local ActionInfo Action;
	local NanoPickupFactory	FactoryPickup;

	NPB = NanoPawnBase(Pawn);
	if( NPB == None )
	{
		return;
	}

	// look for any pickups
	foreach NPB.TouchingActors(class'NanoPickupFactory', FactoryPickup)
	{
		MyNanoHUD.SetActionInfo(AT_Pickup,Action);
		break;
	}

	// if we don't have an interaction then clear the last one
	if (FactoryPickup == None)
	{
		MyNanoHUD.ClearActionInfoByType(AT_Pickup);
	}
}

function OnCameraLookAt(SeqAct_CameraLookAt Action)
{
	local array<Object> ObjVars;
	local int Idx;
	local Actor FocusActor;
	local Controller C;

	// Find the first supplied actor
	Action.GetObjectVars(ObjVars, "Focus");
	for( Idx = 0; Idx < ObjVars.Length && FocusActor == None; Idx++ )
	{
		FocusActor = Actor(ObjVars[Idx]);

		// If its a player variable, look at pawn not controller
		C = Controller(FocusActor);
		if( C != None && C.Pawn != None )
		{
			FocusActor = C.Pawn;
		}
	}

	ProcessCameraLookAt(Action, FocusActor);
	if (LocalPlayer(Player) == None)
	{
		ClientProcessCameraLookAt(Action, FocusActor);
	}
}

simulated function ProcessCameraLookAt(SeqAct_CameraLookAt Action, Actor FocusActor)
{
	local NanoPlayerCamera		Cam;
	local NanoPawnBase          MyNanoPawn;
	local SkelControlLookAt		HeadControl;
	local bool					bDoNoInterpolate;
	local ActionInfo			HUDAction;
	local SkeletalMeshComponent ComponentIt;
	local vector				FocusLocation, HitLoc, HitNormal, StartTrace, StartTraceAdj;
	local actor					HitActor;

	MyNanoPawn = NanoPawnBase(Pawn);

	if (Action.bCheckLineOfSight)
	{
		FocusLocation = FocusActor.Location;
		if( Action.FocusBoneName != 'None' && Action.FocusBoneName != '' )
		{
			// find a skeletal mesh component on the focus actor
			foreach FocusActor.ComponentList(class'SkeletalMeshComponent', ComponentIt)
			{
				FocusLocation = ComponentIt.GetBoneLocation(Action.FocusBoneName);
				break;
			}
		}

		StartTrace = Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight();

		if (MyNanoPawn != None)
		{
			// adjust starttrace right a little, to account for camera offset
			StartTraceAdj = vect(0,64,0);
			StartTrace += StartTraceAdj >> rotator(FocusLocation-StartTrace);
		}

		HitActor = Trace(HitLoc, HitNormal, FocusLocation, StartTrace);

		if ( (HitActor != None) && (HitActor != FocusActor) )
		{
			// activate failed output
			Action.OutputLinks[3].bHasImpulse = TRUE;

			// and BAIL!
			return;
		}
	}


	Focus = FocusActor;

	// If we have a focus, update camera focuspoint. These params are used by the camera to look at focus point.
	if( Action.bAffectCamera )
	{
		Cam = NanoPlayerCamera(PlayerCamera);

		if( FocusActor != None )
		{
			SetFocusPoint(
				TRUE,
				FocusActor,
				Action.InterpSpeedRange,
				Action.InFocusFOV,
				Action.CameraFOV,
				Action.bAlwaysFocus,
				!Action.bTurnInPlace,
				Action.bIgnoreTrace,
				Action.FocusBoneName,
				Action.bRotatePlayerWithCamera);

			if ( (MyNanoHUD != None) && (Len(Action.TextDisplay) > 0) )
			{
				HUDAction.ToolTipText = Action.TextDisplay;
				MyNanoHUD.SetActionInfo(AT_ForceLook, HUDAction);
			}

			if ( Action.bToggleGodMode )
			{
				// if not already in god mode
				if (!bGodMode)
				{
					bCameraGodMode = TRUE;
				}
			}

			// Turn input off if disabled and the action has a duration
			if (Action.bDisableInput) // && Action.bUsedTimer) comment due to legacy kimset in gears
			{
				DisableInput(true,true,true);
			}
		}
		else
		{
			ClearCameraFocus(Action, Cam);
		}
	}

	if( Action.bAffectHead )
	{
		HeadControl = MyNanoPawn.HeadTrackSkelControl;
		if( HeadControl != None )
		{
			// set for the first time, do not interpolate
			// use interpolation for in between target transitions.
			if( MyNanoPawn.HeadLookAtActor == None )
			{
				bDoNoInterpolate = TRUE;
			}
			MyNanoPawn.HeadLookAtActor = FocusActor;

			if( MyNanoPawn.HeadLookAtActor != None )
			{
				MyNanoPawn.HeadLookAtBoneName = Action.FocusBoneName;
				HeadControl.DesiredTargetLocation = MyNanoPawn.GetHeadLookTargetLocation();
				if( bDoNoInterpolate )
				{
					HeadControl.TargetLocation = HeadControl.DesiredTargetLocation;
				}
				HeadControl.SetSkelControlActive(TRUE);
			}
			else
			{
				HeadControl.SetSkelControlActive(FALSE);
			}
		}
	}

	// activate succeeded output
	Action.OutputLinks[2].bHasImpulse = TRUE;
}

/** calls ProcessCameraLookAt on the client
 * @warning: assumes the various properties of Action aren't changed at runtime, since those changes won't happen on the client
 */
reliable client function ClientProcessCameraLookAt(SeqAct_CameraLookAt Action, Actor FocusActor)
{
	ProcessCameraLookAt(Action, FocusActor);
}

simulated function SetFocusPoint(bool bFromKismet, Actor FocusActor, vector2d InterpSpeedRange, vector2d InFocusFOV, optional float CameraFOV, optional bool bAlwaysFocus, optional bool bAdjustCamera, optional bool bIgnoreTrace, optional Name FocusBoneName, optional bool bFaceTarget)
{
	// tell camera to focus on the given actor
	NanoPlayerCamera(PlayerCamera).Cam_3p.SetFocusOnActor(FocusActor, FocusBoneName, InterpSpeedRange, InFocusFOV, CameraFOV, bAlwaysFocus, bAdjustCamera, bIgnoreTrace);

	// needs to happen AFTER setfocuspoint, since setfocuspoint will clear it
	bCameraLookAtIsFromKismet = bFromKismet;
	bCameraLookFaceTarget = bFaceTarget;
}

simulated function ClearFocusPoint_KeepRotation()
{
	ClearFocusPoint(FALSE,FALSE);
}

simulated function ClearFocusPoint_LeaveRotation()
{
	ClearFocusPoint(FALSE,TRUE);
}

simulated function ClearFocusPoint(bool bFromKismet, optional bool bForceLeaveRotation)
{
	local bool bLeaveRotation;
	local NanoPointOfInterest CurrPOI;

	if ( bFromKismet == bCameraLookAtIsFromKismet )
	{
		CurrPOI = NanoPointOfInterest(GetCameraFocusActor());
		bLeaveRotation = bForceLeaveRotation ||
						( (CurrPOI != None) && CurrPOI.bLeavePlayerFacingPOI );

		NanoPlayerCamera(PlayerCamera).Cam_3p.ClearFocusPoint(bLeaveRotation);
	}

	bCameraLookFaceTarget = FALSE;
}

/**
 * The function that gets called when the cameralookat is done.
 * This cleans up the CameraLookAt mode for kismet.
 */
simulated event CameraLookAtFinished(SeqAct_CameraLookAt Action)
{
	local NanoPlayerCamera	Cam;
	local NanoPawnBase      NP;
	local SkelControlLookAt	HeadControl;

	Focus = None;

	NP = NanoPawnBase(Pawn);

	if( Action.bAffectCamera )
	{
		Cam = NanoPlayerCamera(PlayerCamera);
		ClearCameraFocus(Action, Cam);
	}

	if( Action.bAffectHead && NP != None)
	{
		HeadControl = NP.HeadTrackSkelControl;
		if( HeadControl != None )
		{
			NP.HeadLookAtActor = None;
			HeadControl.SetSkelControlActive(FALSE);
		}
	}

	if (LocalPlayer(Player) == None)
	{
		ClientCameraLookAtFinished(Action);
	}
}

reliable client function ClientCameraLookAtFinished(SeqAct_CameraLookAt Action)
{
	CameraLookAtFinished(Action);
}

/** Undo the CameraLookAt */
simulated function ClearCameraFocus(SeqAct_CameraLookAt Action, NanoPlayerCamera Cam)
{
	ClearFocusPoint(TRUE, Action.bLeaveCameraRotation );
	
	// clear camera god mode
	if ( bCameraGodMode )
	{
		bCameraGodMode = FALSE;
	}

	// clear the tooltip
	if ( MyNanoHUD != None )
	{
		MyNanoHUD.ClearActionInfoByType(AT_ForceLook);
	}

	// Turn input back on.
	if ( Action.bDisableInput )
	{
		EnableInput(true,true,true);
	}
}

/** Find and store all the points of interest in the level */
simulated function StorePointsOfInterest()
{
	local NanoPointOfInterest POI;

	foreach DynamicActors(class'NanoPointOfInterest',POI)
	{
		if ( POI.bEnabled )
		{
			AddPointOfInterest( POI );
		}
	}
}

/** Whether the player has line of sight to the POI or not */
simulated function bool HasLineOfSightToPOI( NanoPointOfInterest POI )
{
	local Actor HitActor;
	local vector ActualLookatLoc, HitLoc, HitNormal, StartTrace, StartTraceAdj;

	// See if we should trace for line of sight
	if ( POI.bForceLookCheckLineOfSight )
	{
		ActualLookatLoc = POI.GetActualLookatLocation();
		StartTrace = Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight();

		// adjust starttrace right a little, to account for camera offset
		StartTraceAdj = vect(0,64,0);

		StartTrace += StartTraceAdj >> rotator(ActualLookatLoc-StartTrace);

		HitActor = Trace( HitLoc, HitNormal, ActualLookatLoc, StartTrace );

		if ( (HitActor != None) && (HitActor != POI.AttachedToActor) )
		{
			return false;
		}
	}

	return true;
}

/**
 * Returns the actor the camera is currently focused on (via a LookAt or whatever), or None if none.
 */
simulated protected function Actor GetCameraFocusActor()
{
	return NanoPlayerCamera(PlayerCamera).Cam_3p.GetFocusActor();
}

/** Force the player to look at a POI */
simulated function ProcessPOI( optional NanoPointOfInterest POI, optional bool bUserInstigated )
{
	local NanoPointOfInterest BestPOI, CurrPOI;

	// First see which POI is best to look at
	BestPOI = FindBestPOIToLookAt( POI );
	// If a POI was passed in and it's not the best one or there is no best one, do nothing
	if ( (BestPOI == None) || ((POI != None) && (POI != BestPOI)) )
	{
		return;
	}

	// Do a line of sight check if we need to, returning if failed
	if ( (BestPOI.ForceLookType != ePOIFORCELOOK_None) && BestPOI.bForceLookCheckLineOfSight )
	{
		if ( !HasLineOfSightToPOI(BestPOI) )
		{
			return;
		}
	}

	// See if we need to stop an old look at or return because we're about to look at the same one
	if ( bLookingAtPointOfInterest )
	{
		CurrPOI = NanoPointOfInterest(GetCameraFocusActor());
		if (CurrPOI != None)
		{
			// Same POI so return
			if ( CurrPOI == BestPOI )
			{
				return;
			}

			// Different POI, so stop it
			if ( CurrPOI != None )
			{
				StopForceLookAtPointOfInterest( bUserInstigated );
			}
		}
	}

	// Look at the POI
	ForceLookAtPointOfInterest( bUserInstigated, BestPOI );
}

/**
 * Add a point of interest this client can look at, optionally forced.
 */
simulated function AddPointOfInterest( NanoPointOfInterest POI )
{
	local int Idx, CurrPriority;

	if (POI != None)
	{
		// Set locally in case of networked games
		POI.bEnabled = TRUE;

		// Add to list
		if (EnabledPointsOfInterest.Find(POI) == INDEX_NONE)
		{
			EnabledPointsOfInterest[EnabledPointsOfInterest.length] = POI;
			POILookedAtList[POILookedAtList.length] = false;
		}

		// If this poi wants us to disable the other scripted pois, then do so
		if ( POI.bDisableOtherPOIs )
		{
			ClearFocusPoint( false );
			for ( Idx = 0; Idx < EnabledPointsOfInterest.length; Idx++ )
			{
				if ( (EnabledPointsOfInterest[Idx] != POI) && EnabledPointsOfInterest[Idx].bEnabled )
				{
					CurrPriority = EnabledPointsOfInterest[Idx].GetLookAtPriority( self );
					if ( CurrPriority >= class'NanoPointOfInterest'.Default.POIPriority_ScriptedEvent )
					{
						EnabledPointsOfInterest[Idx].bEnabled = false;
					}
				}
			}
		}

		// If we are doing an automatic force-look, or the player is already looking at a POI, try and process it
		if ( (POI.ForceLookType == ePOIFORCELOOK_Automatic) || (bLookingAtPointOfInterest && IsHoldingPOIButton()) )
		{
			ProcessPOI( POI, (bLookingAtPointOfInterest && IsHoldingPOIButton()) );
		}
	}
}

/**
* Removes a point of interest from the potential list.
*/
simulated function RemovePointOfInterest( NanoPointOfInterest POI, optional EPOIForceLookType ForceLookType )
{
	local int Idx;

	if ( POI != None )
	{
		Idx = EnabledPointsOfInterest.Find( POI );
		if ( Idx >= 0 )
		{
			EnabledPointsOfInterest.Remove( Idx, 1 );
			POILookedAtList.Remove( Idx, 1 );
			if (GetCameraFocusActor() == POI)
			{
				StopForceLookAtPointOfInterest();
			}
		}
	}
}

/**
*  Check to see if there is any possibility for a POI alert
*  Code broken out from UpdateHUDActions()
*/
final function CheckEnabledPointsOfInterest(float DeltaTime)
{
	local NanoPawnBase MyNanoPawn;
	local int Idx;

	MyNanoPawn = NanoPawnBase(Pawn);

	// check to see if there's a poi force look available
	if ((EnabledPointsOfInterest.Length > 0) && (!MyNanoHUD.ActiveAction.bActive || MyNanoHUD.ActiveAction.ActionType >= AT_Scripted))
	{
		for (Idx = 0; Idx < EnabledPointsOfInterest.Length; Idx++)
		{
			// make sure the poi didn't get deleted behind our back
			if ( EnabledPointsOfInterest[Idx] == None )
			{
				// remove from the list, back the index up, and continue through loop
				EnabledPointsOfInterest.Remove( Idx, 1 );
				POILookedAtList.Remove( Idx, 1 );
				Idx--;
				continue;
			}

			// if this poi has an icon duration...
			if ( EnabledPointsOfInterest[Idx].bEnabled && (EnabledPointsOfInterest[Idx].CurrIconDuration > 0.f) )
			{
				EnabledPointsOfInterest[Idx].CurrIconDuration -= DeltaTime;

				if ( EnabledPointsOfInterest[Idx].CurrIconDuration > 0.f )
				{
					if(MyNanoPawn != none && MyNanoPawn.IsLocallyControlled() && LastPoITime+PoIRepeatTime < WorldInfo.TimeSeconds)
					{
						PlaySound( PointOfInterestAdded, true );
						LastPoITime = WorldInfo.TimeSeconds;
					}
					if ( MyNanoHUD.SetActionInfo(AT_Scripted, ActionLookAt) )
					{
						CurrLookedAtPOI = EnabledPointsOfInterest[Idx];
					}
				}
				else
				{
					MyNanoHUD.ClearActionInfoByType(AT_Scripted);
				}
			}
		}
	}
}

/** Player induced look at - pressed the "look at" input */
final function TryPOILookAt()
{
	ProcessPOI( None, true );
	ClearPOIIconDurations();
}

/** Player induced look away from POI - unpressed the "look at" input */
final function TryPOILookAway()
{
	local NanoPointOfInterest CurrPOI;

	// See if there is a current POI
	CurrPOI = NanoPointOfInterest(GetCameraFocusActor());
	if ( CurrPOI != None )
	{
		// See if the current POI is still being forced
		if ( IsTimerActive('ForceLookDurationExpired') )
		{
			return;
		}
	}

	StopForceLookAtPointOfInterest( true );
}

/** Timer callback function called when the force-look duration is over */
final function ForceLookDurationExpired()
{
	if ( !bLookingAtPointOfInterest || !IsHoldingPOIButton(TRUE) )
	{
		StopForceLookAtPointOfInterest( false );
	}
}

/**
 * Find the best POI to look at
 * @param POIToTest - a POI to test against, if the best POI has the same priorty as this one, the POIToTest will take precedence
 */
final simulated function NanoPointOfInterest FindBestPOIToLookAt( optional NanoPointOfInterest POIToTest )
{
	local NanoPointOfInterest POI, BestPOI;
	local int POIPriority, CurrPriority;
	local Pawn Myself;

	// set the initial ratings
	BestPOI = POIToTest;
	POIPriority = (BestPOI == None) ? -1 : BestPOI.LookAtPriority;

	// then look for an active point of interest based on priority
	foreach EnabledPointsOfInterest(POI)
	{
		Myself = GetMyRealPawn();
		// if enabled, and not attached or not attached to my pawn
		if ( POI.bEnabled && (POI.AttachedToActor == None || POI.AttachedToActor != Myself) )
		{
			CurrPriority = POI.GetLookAtPriority( self );
			if ( CurrPriority >= 0 )
			{
				if ( (BestPOI == None) ||
					(CurrPriority > POIPriority) ||
					((CurrPriority == POIPriority) && (POIToTest == None || BestPOI != POIToTest) && (VSizeSq(POI.Location - Pawn.Location) < VSizeSq(BestPOI.Location - Pawn.Location))) )
				{
					// Found one!
					BestPOI = POI;
					POIPriority = CurrPriority;
				}
			}
		}
	}

	return BestPOI;
}

final simulated function ForceLookAtPointOfInterest( optional bool bUserInstigated, optional NanoPointOfInterest POIToForce )
{
	local NanoPlayerCamera Cam;
	local ActionInfo Action;
	local float POICamFOV;
	local int IndexInList;
	local bool bDoForceLookTimer;

	// disallow forcelook while chainsawing
	if ( bUserInstigated && (ForcedAdhesionTarget != None) )
	{
		return;
	}

	// If we have a camera
	Cam = NanoPlayerCamera(PlayerCamera);
	if ( Cam != None )
	{
		// Find the best POI if one was not provided
		if ( POIToForce == None )
		{
			POIToForce = FindBestPOIToLookAt();
		}

		// Already looking at this POI so return
		if ( GetCameraFocusActor() == POIToForce )
		{
			return;
		}
		// Stop an already existing force look
		else if ( bLookingAtPointOfInterest )
		{
			StopForceLookAtPointOfInterest(FALSE);
		}

		// Focus the camera on the new POI
		if ( POIToForce != None )
		{
			// Set the camera up to look at the POI
			POICamFOV = ( Vehicle(Pawn) == None ) ? POIToForce.GetDesiredFOV(Cam.Location) : 0.f;
			SetFocusPoint(FALSE, POIToForce, PointOfInterestLookatInterpSpeedRange, vect2d(1.f,1.f), POICamFOV, TRUE, TRUE, TRUE);
			bLookingAtPointOfInterest = TRUE;

			// Play a sound if the player pressed the button
			if( bUserInstigated )
			{
				Pawn.PlaySound( SoundCue'Interface_Audio.Forcelook_Enter_cue' );
			}

			// Stop the player from pressing buttons
			DisableInput(true,false,false,true);

			// Show the text to the HUD
			if ( MyNanoHUD != None )
			{
				Action.ToolTipText = POIToForce.GetDisplayName();
				MyNanoHUD.SetActionInfo( AT_ForceLook, Action );
			}

			// If there is a force look duration
			if ( (POIToForce.ForceLookType != ePOIFORCELOOK_None) && (POIToForce.ForceLookDuration > 0.0f) )
			{
				bDoForceLookTimer = true;

				// If this is a player-induced force look, make sure we haven't done it already
				if ( POIToForce.ForceLookType != ePOIFORCELOOK_None )
				{
					IndexInList = EnabledPointsOfInterest.Find( POIToForce );
					if ( (IndexInList == INDEX_NONE) || POILookedAtList[IndexInList] )
					{
						bDoForceLookTimer = false;
					}
				}

				if ( bDoForceLookTimer )
				{
					SetTimer( POIToForce.ForceLookDuration, FALSE, nameof(ForceLookDurationExpired) );

				}
			}

			// Mark this POI as having been seen
			IndexInList = EnabledPointsOfInterest.Find( POIToForce );
			if ( IndexInList != INDEX_NONE )
			{
				POILookedAtList[IndexInList] = true;
			}

			// Have the server see if it needs to fire a kismet link
			ServerFirePOIActionOutputLink( POIToForce, eMPOIOUTPUT_LookAt );
		}
	}
}

/** Stop the current POI from being looked at */
final function StopForceLookAtPointOfInterest( optional bool bUserInstigated )
{
	local NanoPlayerCamera Cam;
	local NanoPointOfInterest POI;

	ClearTimer( 'ForceLookDurationExpired' );

	Cam = NanoPlayerCamera(PlayerCamera);
	if ( bLookingAtPointOfInterest )
	{
		POI = NanoPointOfInterest(GetCameraFocusActor());
		if ( POI != None )
		{
			// Have the server see if it needs to fire a kismet link
			ServerFirePOIActionOutputLink( POI, eMPOIOUTPUT_LookAway );
		}

		bLookingAtPointOfInterest = FALSE;

		if ( MyNanoHUD != None )
		{
			MyNanoHUD.ClearActionInfoByType( AT_ForceLook );
		}

		if ( Cam != None )
		{
			ClearFocusPoint(FALSE);
			ClientClearForcedCameraFOV();
			if( bUserInstigated == TRUE )
			{
				Pawn.PlaySound( SoundCue'Interface_Audio.Forcelook_Exit_cue' );
			}
			EnableInput(true,false,false);
		}
	}
}

/** Function that has the server fire the output link for the action of a POI */
final reliable server function ServerFirePOIActionOutputLink( NanoPointOfInterest POI, int POIOutputType )
{
	if ( (POI != None) && (POI.POIAction != None) )
	{
		// Fire link
		POI.POIAction.OutputLinks[POIOutputType].bHasImpulse = true;

		// Set the enable flag false if we're looking away
		if ( POIOutputType == eMPOIOUTPUT_LookAway )
		{
			POI.POIAction.POI_bEnabled = false;
		}
	}
}

reliable client function ClientSetForcedCameraFOV(float inFOV)
{
	local NanoPlayerCamera Cam;

	Cam = NanoPlayerCamera(PlayerCamera);
	Cam.bUseForcedCamFOV = TRUE;
	Cam.ForcedCamFOV = inFOV;
}

reliable client function ClientClearForcedCameraFOV()
{
	local NanoPlayerCamera Cam;

	Cam = NanoPlayerCamera(PlayerCamera);
	Cam.bUseForcedCamFOV = FALSE;
}

/** Whether the POI button is being held or not */
simulated final function bool IsHoldingPOIButton( optional bool bRaw )
{
	local NanoPlayerInput_Base NPI;

	NPI = NanoPlayerInput_Base(PlayerInput);
	return (NPI != None && NPI.IsButtonActive(GB_Y, true));
}

/**
 * POIs need their icon durations zeroed out once the player hits the forcelook button
 */
function ClearPOIIconDurations()
{
	local NanoPointOfInterest POI;
	foreach EnabledPointsOfInterest(POI)
	{
		POI.CurrIconDuration = 0.f;
	}
}

/** Enable the input */
function EnableInput(bool bEnableButtons, bool bEnableMovement, bool bEnableLook)
{
	if (bEnableButtons && InputIsDisabledCount > 0)
	{
		// decrement the disabled counter
		InputIsDisabledCount--;
		if (InputIsDisabledCount == 0)
		{
			NanoPlayerInput_Base(PlayerInput).EnableButtonInput();
		}
	}
	// free movement input
	if (bEnableMovement)
	{
		IgnoreMoveInput(FALSE);
	}
	// free camera input
	if (bEnableLook)
	{
		IgnoreLookInput(FALSE);
	}
}

/**
 * Disable any current input and set the flag that will prevent future input
 * @PARAM bIsPOI - whether we want to force the POI button to call it's release function,
 *		since the POI button CAN be one of the buttons that reenables the input we sometimes want
 *		to force it and sometimes not.
 */
function DisableInput(bool bDisableButtons, bool bDisableMovement, bool bDisableLook, bool bIsPOI=false)
{
	local NanoPlayerInput_Base NPIB;

	if (bDisableButtons)
	{
		// If the input was previously enabled, disable it.
		if ( InputIsDisabledCount == 0 )
		{
			NPIB = NanoPlayerInput_Base(PlayerInput);
			if (NPIB != none)
			{
				NPIB.DisableButtonInput(bIsPOI);
			}
		}
		// increment the disabled count
		InputIsDisabledCount++;
	}
	// disable movement input
	if (bDisableMovement)
	{
		IgnoreMoveInput(TRUE);
	}
	// disable camera input
	if (bDisableLook)
	{
		IgnoreLookInput(TRUE);
	}
}


/**
 * Check if bullet went close by my pawn.
 *
 */
function CheckNearMiss(Pawn Shooter, NanoWeaponBase GearWeap, const out ImpactInfo Impact, class<DamageType> InDamageType)
{
	local FLOAT		NearMissDist;
	local Vector	ClosestPoint;

	// Find closest distance to segment bullet traveled.
	NearMissDist = PointDistToSegment(MyNP.Location, Impact.StartTrace, Impact.HitLocation, ClosestPoint);

	// Play bullet whip sounds
	if( (NearMissDist < Player_BulletWhipDistance) && (MyNP.LastBulletWhipTime + GearWeap.MinTimeBetweenBulletWhips) < WorldInfo.TimeSeconds )
	{
		// only play the sound on the clients
		if( WorldInfo.NetMode != NM_DedicatedServer && Impact.HitActor != MyNP )
		{
			//`log( "Should Hear a Whip sound" @ GearWeap.WeaponWhipSound );
			// only play a whip sound if the bullet flew past you and
			// if it did NOT impact something
			WorldInfo.PlaySound(GearWeap.WeaponWhipSound, false, true,, ClosestPoint);
		}

		MyNP.LastBulletWhipTime = WorldInfo.TimeSeconds;
	}

	// Let our Pawn know we got a near miss.
	// Cringes
	if( NearMissDist < Player_NearMissDistance )
	{
	//	MyNP.RegisterNearHitMiss(Impact, InDamageType);
	}
}



/**
 * This function is called after we acquire the travel points right before we start traveling.
 **/
function Sentinel_PostAcquireTravelTheWorldPoints()
{
	// need to do this here to escape the clutches of spectator cameras
	GotoState( 'BaseSpectating' );
	SetViewTarget( self );
	ConsoleCommand( "camera freecam" );
}



defaultproperties
{
	bWarnCrowdMembers=true

	PoIRepeatTime = 15.f
	PointOfInterestLookatInterpSpeedRange=(X=7.f,Y=7.f)

	ActionLookAt={(
		ActionName=LookAtSomething,
		IconAnimationSpeed=0.35f,
		ActionIconDatas=(	(ActionIcons=((Texture=None,U=176,V=314,UL=35,VL=64), // Y Button
										  (Texture=None,U=176,V=314,UL=35,VL=64))),
							(ActionIcons=((Texture=None,U=293,V=270,UL=74,VL=85),
										  (Texture=None,U=367,V=270,UL=74,VL=85))) ),
		)}
}
