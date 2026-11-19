/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVehicle_ElevatorBase extends NanoVehicleAgent
	abstract
	native(Inherit);

/** Offsets from the player that the camera should be at when the elevator is traveling up **/
var() vector    UpCameraOffset;
/** Rotational offset applied to the camera to rotate from the line between the camera position and the player **/
var() Rotator   UpCameraRotationalOffset;
/** Offsets from the player that the camera should be at when the elevator is traveling up at overdrive launch velocity **/
var() Vector    LaunchSpeed_UpCameraOffset;
/** Rotational offset applied to the camera to rotate from the line between the camera position and the player at overdrive launch velocity **/
var() Rotator   LaunchSpeed_UpCameraRotationalOffset;

/** Offsets from the player that the camera should be at when the elevator is traveling down **/
var() vector    DownCameraOffset;
/** Rotational offset applied to the camera to rotate from the line between the camera position and the player **/
var() Rotator   DownCameraRotationalOffset;
/** Offsets from the player that the camera should be at when the elevator is traveling down at overdrive launch speed **/
var() vector    LaunchSpeed_DownCameraOffset;
/** Rotational offset applied to the camera to rotate from the line between the camera position and the player at overdrive launch speed **/
var() Rotator   LaunchSpeed_DownCameraRotationalOffset;

/** If a curve is specified, it will be played the first time the player is launched from the elevator, for emphasis */
var() InterpCurveFloat  LaunchSlomoCurve;

/** When the elevator is moving, pushing left / right on the left stick will yaw the camera at this rate */
var() float     LeftStick_CameraYawRate;

/** Degrees of freedom (in rotators) from the elevator's yaw rotation that the player can rotate the camera in **/
var() int     YawDegreesOfFreedom;

/** When player is not overriding elevator controls, camera will be this far away from them **/
var() float     NeutralCamViewDistance;
/** Degrees of freedom (in rotators) from the elevator's yaw rotation that the player can rotate the camera when not overriding controls **/
var() int       NeutralCamYawDegreesOfFreedom;
/** Degrees of freedom (in rotators) from the elevator's pitch rotation that the player can rotate the camera when not overriding controls **/
var() int       NeutralCamPitchDegreesOfFreedom;

/** Whether the pawn wants to drive the elevator up (by pressing Y), or down (by pressing X) */
var transient bool bIsOverridingUp;

/** Acceleration when the elevator is being overdriven */
var() float     OverrideAcceleration;

/** When player is in overdrive, this speed modifier will be added to the elevator **/
var() float     OverdriveSpeedModifier;
/** If the player goes dense while in overdrive, this speed modifier will be applied **/
var() float     OverdriveWhileDenseSpeedModifier;

/** If performing an overdrive launch within OverdriveLaunchRange, this is where they'll try to end up */
var()   Actor   OverdriveLaunchTarget;
/** Time to hang in the air for the overdrive launch **/
var()   float   OverdriveLaunchTargetTime;
/** If player performs an overdrive launch within this range of OverdriveLaunchTarget, they'll be flung here **/
var()   float   OverdriveLaunchRange;
/** If TRUE, the elevator will not be destroyed at the end of launching the player */
var()	bool	bDoNotDestroyAtLaunch;

var transient bool      bPlayedOverdriveLaunchEffects;

/** Duration over which the elevator will blend up to full acceleration */
var()   float       AccelCurveDuration;
/** Exponent on the acceleration curve (1.f = linear) */
var()   float       AccelCurveExponent;
/** Last time the vehicle changed direction */
var transient float LastChangedDirectionTime;

/** Played when the elevator has reached an overdrive velocity that will launch the player **/
var() ParticleSystem    OverdriveEffect;
var transient ParticleSystemComponent PSC_OverdriveEffect;

/** Sound to play in addition to the normal overdriving sound when the player reaches overdrive launch velocity */
var() SoundCue          OverdriveLaunchThresholdSound;

/** Radial blur component to activate when the elevator reaches the overdrive launch threshold */
var() RadialBlurComponent       RB_OverdriveBlur;

/** Sound to play when the player overdrives to the end of the track and wrecks the elevator **/
var()   SoundCue    HitEndOfTrackSoundCue;


/** Camera shake to play during normal operation */
var()   CameraShake MovingCameraShake;
var transient bool  bIsPlayingMovingCameraShake;

/** Camera shake to play when overdriving **/
var()   CameraShake OverdriveCameraShake;

/** Camera shake to play when crossing the overdrive launch threshold */
var()   CameraShake OverdriveLaunchThresholdCameraShake;

/** Camera shake for standard starting / stopping */
var()   CameraShake StartStopCameraShake;

/** Desired FOV for the camera when the player is overdriving **/
var()   float   OverdriveFOV;

/** If true, the player will launch when they turn off densing **/
var transient bool      bReadyToLaunch;

/** If true, elevator will transition between random floors, and wait for random intervals until a player takes control **/
var()   bool    bTravelRandomly;

/** If true, the elevator should begin braking as it approaches the end of the spline */
var transient bool bNotifyShouldBrakeAtEnd;

/** Time spent waiting at a floor (approximately) **/
var()   float       FloorWaitTime;
var transient bool  bWaitingAtFloor;

/** Stores the bottom most spline actor along the path, so that random travel can occur more easily **/
var transient SplineActor       PathTerminus;
var transient int               PathLength;

cpptext
{
	void performPhysics(FLOAT DeltaTime);
	ANanoVehicleAgent* LookAheadForVehicle( FLOAT& DistanceCarIsInFront );

	FLOAT GetVehicleAcceleration();
	void TickSpecial( FLOAT DeltaSeconds );

	FVector GetTargetLocation(AActor* RequestedBy, UBOOL bRequestAlternateLoc) const;
};

/** Called when we need to determine the entire path of the elevator for random destination picking **/
simulated function DetermineTerminus()
{
	local SplineActor TmpPath;

	// Trace back along our current path to find the bottom most terminal node
	PathTerminus = CurrentSpline;
	while( (PathTerminus != None) && (PathTerminus.LinksFrom.Length > 0) )
		PathTerminus = PathTerminus.LinksFrom[0];

	// Now trace up from the terminus to find our total path length
	PathLength = 0;
	TmpPath = PathTerminus;
	while( TmpPath != None )
	{
		TmpPath = TmpPath.GetRandomConnection();
		++PathLength;
	}
}

/** Handle being told to move to new destination */
simulated function OnSetVehicleDestination(SeqAct_SetVehicleDestination Action)
{
	// If we were traveling randomly, then cancel that
	bTravelRandomly = FALSE;
	bWaitingAtFloor = FALSE;

	if( Action.Destination != TargetSpline )
	{
		bNotifyShouldBrakeAtEnd = FALSE;

		// This handles the case if we're on the terminal end of a spline
		if( TargetSpline == None )
		{
			TargetSpline = CurrentSpline;
		}

		// Find a path to the new destination!
		CreateCachedRouteTo(Action.Destination);
	}
}

simulated function OnSetElevatorLaunchTarget(SeqAct_SetElevatorLaunchTarget Action)
{
	if( Action != None )
	{
		OverdriveLaunchTarget = Action.LaunchTarget;
		OverdriveLaunchRange  = Action.LaunchRange;
		OverdriveLaunchTargetTime = Action.HangTime;
		bDoNotDestroyAtLaunch = Action.bDoNotDestroyAtLaunch;
	}
}

/** Unlike cars, elevators can travel up or down spline paths.  This finds a route going between TargetSpline and Destination in either direction **/
simulated function CreateCachedRouteTo(NanoVehicleSpline Destination)
{
	local bool bSuccess;
	local int i, RouteLength;
	local SplineActor TmpSpline;

	// No more braking
	bNotifyShouldBrakeAtEnd = FALSE;

	if( TargetSpline == None )
		TargetSpline = CurrentSpline;

	if((TargetSpline != None) && (Destination != none))
	{
		bSuccess = TargetSpline.FindSplinePathTo(Destination, CachedRoute);

		// If we found a direct path, use it
		if(bSuccess)
		{
			// If we're switching directions, add the vehicle to the target spline so that we can immediately turn around
			if( !bFollowingPathForward && TargetSpline != None )
			{
				TargetSpline.AddVehicleToSpline(self);
			}

			bFollowingPathForward = true;

			// First element will be TargetSpline, so we remove it, to only contain paths after that
			CachedRoute.Remove(0, 1);
		}
		// If we didn't check for the path from target to current, and we'll reverse it
		else
		{
			// --- Reverse Path Handling ------------------
			bSuccess = Destination.FindSplinePathTo(TargetSpline, CachedRoute);

			if( bSuccess )
			{
				// If we're switching directions, add the vehicle to the target spline so that we can immediately turn around
				if( bFollowingPathForward && TargetSpline != None )
				{
					TargetSpline.AddVehicleToSpline(self);
				}

				bFollowingPathForward = false;

				// Invert the CachedRoute
				RouteLength = CachedRoute.Length;
				for( i = 0; i < RouteLength / 2; i++ )
				{
					TmpSpline = CachedRoute[i];
					CachedRoute[i] = CachedRoute[RouteLength-i-1];
					CachedRoute[RouteLength-i-1] = TmpSpline;
				}

				// First element will be CurrentSpline, so we remove it, to only contain paths after that
				CachedRoute.Remove(0, 1);
			}
			else
			{
				`log("Failed to path from"@self@"to"@Destination);
			}
		}
	}
}

simulated function bool PawnIsControlling()
{
	return (RidingPawn != None) && ((CurrentTurnDecision != ENTD_Straight) || bIsOverriding);
}

simulated function bool PawnWantsToGoUp()
{
	// Pawn is either not overriding and pressing up on the stick, or is overriding pressing Y
	return (!bIsOverriding && CurrentTurnDecision == ENTD_Up) || (bIsOverriding && bIsOverridingUp);
}

simulated function bool PawnWantsToGoDown() 
{
	// Pawn is either not overriding and pressing down on the stick, or is overriding pressing X
	return (!bIsOverriding && CurrentTurnDecision == ENTD_Down) || (bIsOverriding && !bIsOverridingUp);
}

/** Called from C++ code */
simulated event SplineActor ChooseNextSpline()
{
	local NanoVehicleSpline NextSpline;
	local SplineActor       RandomDestination;
	local int i;
	local bool bFoundNewDestination;

	// Check for a player overriding the controls
	if( PawnIsControlling() )
	{
		// If we have no target, but have user input, automatically follow that
		if( TargetSpline == None )
		{
			if( PawnWantsToGoUp() )
			{
				bFollowingPathForward = TRUE;
			}
			else
			{
				bFollowingPathForward = FALSE;
			}
		}

		// If the elevator is moving forward, then follow the spline path forward
		if( bFollowingPathForward )
		{
			bTravelRandomly = FALSE;
			bFollowingPathForward = TRUE;
			CachedRoute.length = 0;
			return CurrentSpline.GetRandomConnection();
		}
		// otherwise, reverse if possible
		else
		{
			if( CurrentSpline.LinksFrom.Length > 0 )
			{
				bTravelRandomly = FALSE;
				bFollowingPathForward = FALSE;
				CachedRoute.length = 0;
				return CurrentSpline.LinksFrom[0];
			}
		}
	}

	// Check for random travel
	if( bTravelRandomly && CachedRoute.Length == 0)
	{
		// If we haven't found the path of the elevator yet, do so now
		if( PathTerminus == None )
		{
			DetermineTerminus();
		}

		// If the path still isn't valid, clear the route and abort (can happen when level is streamed out)
		if( PathTerminus == None )
		{
			CachedRoute.Length = 0;
			return None;
		}

		// walk up the spline list until we reach the random target.  keep picking if we pick the current spline
		RandomDestination = PathTerminus;
		bFoundNewDestination = FALSE;

		while( !bFoundNewDestination )
		{
			i = Rand(PathLength);
			while( (i > 0) && (RandomDestination.Connections.Length > 0) )
			{
				RandomDestination = RandomDestination.GetRandomConnection();
				--i;
			}

			bFoundNewDestination = (RandomDestination != CurrentSpline);
			if( !bFoundNewDestination )
			{
				// If there was no destination found, reset and try again
				RandomDestination = PathTerminus;
			}
		}
		
		// fill up cached route with our new random path
		CreateCachedRouteTo(NanoVehicleSpline(RandomDestination));

		// Now that we have a new destination, wait here for a while
		bWaitingAtFloor = TRUE;
		SetTimer(RandRange(FloorWaitTime - 2.f, FloorWaitTime + 2.f), false, nameof(EndFloorWaiting));
	}

	// If we have a cached route, follow that
	if(CachedRoute.Length > 0)
	{
		// This should always be true
		NextSpline = NanoVehicleSpline( CachedRoute[0] );

		// Have to handle the bidirectional spline case here, so we check for paths from Current to Next, and vice versa
		if((NextSpline != None) && (CurrentSpline.IsConnectedTo(NextSpline, TRUE) || NextSpline.IsConnectedTo(CurrentSpline, TRUE)))
		{
			// Remove from head of list and go there.
			CachedRoute.Remove(0, 1);

			// If this is our last spline, notify that we may need to brake when approaching the floor
			if( CachedRoute.Length == 0 )
			{
				bNotifyShouldBrakeAtEnd = true;
			}

			return NextSpline;
		}
		// If its not, warn and give up on route
		else
		{
			`log( self @ "Cached Route Not Possible."@CurrentSpline@"not connected to"@NextSpline@" Cached Len: " @ CachedRoute.Length );
			CachedRoute.length = 0;
			return none;
		}
	}

	return None;
}

simulated event FillOutTargetSplines()
{
	// Super's FillOutTargetSplines() creates a route up the splines, we don't want that if we're traveling randomly
	if( !bTravelRandomly )
	{
		Super.FillOutTargetSplines();
		return;
	}

	// if we haven't already, determine a terminus
	if( PathTerminus == None )
		DetermineTerminus();

	TargetSpline = NanoVehicleSpline(ChooseNextSpline());
}

simulated function EndFloorWaiting()
{
	bWaitingAtFloor = FALSE;
}

/** Elevators don't fly off their tracks! **/
function FlyIntoTheAir( vector KillMomentum )
{
	return;
}

/** Overdrive Launch:  Performed when a player hits the end of the track when overdriving, or overdrives while densed, and then undenses **/
simulated event LaunchPlayer()
{
	local vector LaunchVelocity, VehicleVelocity;
	local NanoPawn  SavedPawn;
	local NanoSkill_Jump JumpSkill;
	local NanoGRI NGRI;

	if( RidingPawn == None )
	{
		`warn("NO PLAYER TO LAUNCH!!!");
		return;
	}

	// Back this up here, since jumping the pawn causes RidingPawn to be set to None
	SavedPawn = RidingPawn;

	NGRI = NanoGRI(WorldInfo.GRI);

	// If we have a launch target and we're within range, try to launch the player there
	if( (OverdriveLaunchTarget != None) && (Velocity dot LaunchVelocity <= 0.f) && (VSizeSq(OverdriveLaunchTarget.Location - RidingPawn.Location) <= OverdriveLaunchRange*OverdriveLaunchRange) && SavedPawn.AttemptBigJumpToActor(OverdriveLaunchTarget, OverdriveLaunchTargetTime) ) 
	{
		SavedPawn.UpdateJumpAnimSet('Sprint_Jump');

		// Trigger a slomo curve, if needed
		if( LaunchSlomoCurve.Points.Length > 0 )
		{
			FitSlomoCurveToTime(OverdriveLaunchTargetTime);
			NGRI.GameSlomoCurve(LaunchSlomoCurve);
		}

		// Store the launch velocity, so we can launch the elevator in the opposite direction
		LaunchVelocity = SavedPawn.Velocity;

		// Set the ejected from vehicle only if the vehicle is going to be destroyed, which will cause the camera to track both the pawn and the elevator
		SavedPawn.SetElevatorEjectionTarget(OverdriveLaunchTarget, OverdriveLaunchTargetTime);
	}
	// If we couldn't calculate a launch velocity, just launch using the elevator's velocity and the maximum jump velocity
	else
	{
		// if we're travelling downwards, we don't want the negative velocity, so just cap it at 0
		LaunchVelocity = 2.f * Velocity;
		LaunchVelocity.Z = FMax(0, LaunchVelocity.Z);

		// Add in the pawn's jump level to the velocity of the elevator
		JumpSkill = SavedPawn.GetSkill(class'NanoSkill_Jump');	
 		if( JumpSkill != none )
 		{
 			LaunchVelocity += vect(0,0,1) * JumpSkill.JumpLevels[JumpSkill.GetJumpLevel(RidingPawn)].DashUpwardVelocity;

			// launch em!
			SavedPawn.SetBase(None);
			SavedPawn.SetHardAttach(FALSE);
			SavedPawn.SetPhysics(PHYS_Falling);
			SavedPawn.Velocity = LaunchVelocity;
			SavedPawn.UpdateJumpAnimSet();
 		}
	}

	// Turn off collision to ensure that the elevator doesn't interfere with our flying to the target.
	SavedPawn.SetCollision(FALSE, FALSE, FALSE);
	SetTimer(1.f, false, 'RestoreCollisionAfterLaunch', SavedPawn);

	// Notify kismet that we launched the player
	TriggerEventClass(class'SeqEvt_ElevatorOverdriveLaunch', self, 0);

	if( !bDoNotDestroyAtLaunch )
	{
		// Set the elevator on a trajectory opposite our own
		SetPhysics(PHYS_RigidBody);
		VehicleVelocity = LaunchVelocity;
		VehicleVelocity.X = -VehicleVelocity.X;
		VehicleVelocity.Y = -VehicleVelocity.Y;
		if( Velocity.Z < 0.f )
		{
			VehicleVelocity.Z = -VehicleVelocity.Z;
		}

		VehicleMeshComponent.SetRBLinearVelocity(0.9f*VehicleVelocity, FALSE);
		VehicleMeshComponent.SetRBAngularVelocity(1.5f*VRand(), TRUE);

		DestroyDueToLaunching();
	}
}

simulated function FitSlomoCurveToTime( float NewDuration )
{
	local float ScaleFactor;
	local int i;

	// Scale the launch slomo curve to the specified duration
	if( LaunchSlomoCurve.Points.Length > 0 )
	{
		ScaleFactor = NewDuration / LaunchSlomoCurve.Points[LaunchSlomoCurve.Points.Length-1].InVal;
	}

	for( i = 0; i < LaunchSlomoCurve.Points.Length; i++ )
	{
		LaunchSlomoCurve.Points[i].InVal *= ScaleFactor;
	}
}

/** If we hit the end of the track when overloading, destroy the elevator **/
event DestroyDueToLaunching()
{
	TakeDamage( 10000, none, vect(0,0,0), vect(0,0,0), class'NanoGame.NDT_ElevatorCrash',,);

	// Play the crashing to the end of the track sound
	PlaySound(HitEndOfTrackSoundCue);

	// Stop playing the elevator sound, since we're busted
	if( AC_EngineSound != None )
	{
		AC_EngineSound.FadeOut( 0.250f, 0.0f );
	}

	if( AC_PlayerRidingOverride != None )
	{
		AC_PlayerRidingOverride.FadeOut( 0.250f, 0.0f );
	}

	SetOverdriveLaunchEffects(FALSE);
}

/** Called when a NanoPawn attaches - to track our rider */
simulated event Attach(Actor Other)
{
	local NanoPawn NP;

	NP = NanoPawn(Other);
	if( (NP != none)
		&& (Health > 0) 
		&& (bCarDisabledByTrafficControl == FALSE) )
	{
		// Stop the pawn from dashing, since they're stuck
		NP.ForceDashStop();

		// Check if there is already someone riding
		if(RidingPawn != None)
		{
			// TODO: Handle this better - kick of old pawn? Don't allow new attachment?
			`log("NanoVehicleAgent.Attach - Already a RidingPawn!");
		}		
	
		RidingPawn = NP;

		SetTickGroup( TG_PreAsyncWork );

		AC_PlayerRiding = new(self) class'AudioComponent';
		if( AC_PlayerRiding != None )
		{
			AC_PlayerRiding.SoundCue = PlayerRiding;
			AC_PlayerRiding.SetFloatParameter( AirCarEnginePitchName, 1.0f );
			AttachComponent( AC_PlayerRiding );
			AC_PlayerRiding.FadeIn( 0.100f, 1.0f );
		}
	}
}

/** Called when pawn stops being attached to the elevator */
simulated event Detach(Actor Other)
{
	if((Other != none) && (Other == RidingPawn))
	{	
		// Stop normal camera shaking
		if( bIsPlayingMovingCameraShake )
		{
			NanoPC(RidingPawn.Controller).ClientStopCameraShake(MovingCameraShake);
		}
		// Stop the overdrive shaking
 		if( OverdriveCameraShake != None )
 		{
 			NanoPC(RidingPawn.Controller).ClientStopCameraShake(OverdriveCameraShake);
 		}

		// disable launch effects, if we were playing them
		SetOverdriveLaunchEffects(FALSE);

		// stop playing the custom elevator riding animation
		RidingPawn.FullBodySlot.StopCustomAnim(0.15f);

		// Restore simulation on cloth scarf
		RidingPawn.DesiredClothBlend = 1.f;

		RidingPawn = None;
		bIsOverriding = FALSE;
		bReadyToLaunch = FALSE;

		SetTickGroup( TG_PostAsyncWork );

		if( AC_PlayerRiding != None )
		{
			AC_PlayerRiding.FadeOut( 0.100f, 0.0f );
		}

		if( AC_PlayerRidingOverride != None )
		{
			AC_PlayerRidingOverride.FadeOut( 0.100f, 0.0f );
		}
	}
}

simulated function DoAttachingDamage( NanoPawn Rider, vector AttachVelocity )
{
	// Don't damage elevators, no matter how fast we're going
	return;
}

// Changed to not add in the physics dip to elevators when mounting
function PerchedOnBy( NanoPawn NP )
{
	SetTickGroup( TG_PreAsyncWork );

	PlaySound( PlayerLandedCue );
}

/** Overridden to actually attach player to the elevator from high heights, unlike cars, where you simply base and walk around on them */
simulated function NotifyFinishedStabMantle( NanoPawn Rider, optional bool bViaLanding )
{
	local NanoPC NPC;
	local rotator PCRot;
	local vector PerchLoc;
	local rotator PerchRot;
	local SkeletalMeshComponent SMComp;
	local float AnimTime;

	Rider.SetBase(self);

	// If we didn't land on the car, attach us for driving
	Rider.SetPhysics(PHYS_Interpolating);
	Rider.SetHardAttach(TRUE);

	NPC = NanoPC(Rider.Controller);
	if(NPC != None)
	{
		PCRot = Rotation;
		PCRot.Roll = 0;
		NPC.SetRotation(PCRot);
	}

	GetVehiclePerchOffsets(PerchLoc, PerchRot);

	Rider.SetRelativeRotation(PerchRot);
	Rider.SetRelativeLocation(PerchLoc - Rider.Mesh.Translation);

	if( bViaLanding )
	{
		// If we landed on the elevator, play the elevator hacking animations on the pawn and the elevator
		SMComp = SkeletalMeshComponent(VehicleMeshComponent);
		if( SMComp != None )
		{
			Rider.FullBodySlot.PlayCustomAnim('Elevator_Hatch_Hack',1.0,0.1,-1.f,FALSE,TRUE);
			SMComp.PlayAnim('Elevator_Hatch_Hack');

			AnimTime = SMComp.GetAnimLength('Elevator_Hatch_Hack');
			SetTimer(AnimTime, false, nameof(HideElevatorHatch));
			SetTimer(AnimTime, false, nameof(PlayElevatorRidingAnim));
		}
	}
	else
	{
		PlayElevatorRidingAnim();
	}


	// Turn off simulation on cloth scarf
	Rider.DesiredClothBlend = 0.5f;

	PerchedOnBy( Rider );

	TriggerVehicleMountedEvents( Rider );
}

simulated function TriggerVehicleMountedEvents(NanoPawn Rider)
{
	local array<int> ActivateIndices;
	local array<SequenceEvent> ActivatedEvents;
	local SequenceEvent it;
	local SeqEvt_VehicleMounted Evt;

	// Handle notifying kismet VehicleMounted events
	ActivateIndices[0] = 2;
	// Activate VehicleMounted event on the vehicle
	ActivateEventClass(class'SeqEvt_VehicleMounted', Rider, GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
	foreach ActivatedEvents(it)
	{
		Evt = SeqEvt_VehicleMounted(it);
		if( Evt != None )
		{
			Evt.Vehicle = self;
		}
	}

	// Activate VehicleMounted event on the rider
	ActivatedEvents.length = 0;
	Rider.ActivateEventClass(class'SeqEvt_VehicleMounted', Rider, Rider.GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
	foreach ActivatedEvents(it)
	{
		Evt = SeqEvt_VehicleMounted(it);
		if( Evt != None )
		{
			Evt.Vehicle = self;
		}
	}
}

/** Look at NanoPawn and decide which way it wants to turn. */
simulated event ENanoTurnDirection DecidePawnTurnDesire(NanoPawn NP)
{
	local NanoPC NPC;
	local ENanoTurnDirection NewTurn;

	NewTurn = ENTD_Straight;
	
	NPC = NanoPC(NP.Controller);
	if(!NP.bStabMantling && NP.IsLocallyControlled())
	{
		if(NPC.PlayerInput.RawJoyUp > 0.25f || (bIsOverriding && bIsOverridingUp))
		{
			// move immediately if the pawn wants to go
			bWaitingAtFloor = FALSE;
			NewTurn = ENTD_Up;
		}
		else if(NPC.PlayerInput.RawJoyUp < -0.25f || (bIsOverriding && !bIsOverridingUp))
		{
			// move immediately if the pawn wants to go
			bWaitingAtFloor = FALSE;
			NewTurn = ENTD_Down;
		}
	}
	
	// If we've changed turn desires, record the time so we can accelerate appropriately
	if( NewTurn != CurrentTurnDecision )
	{
		LastChangedDirectionTime = WorldInfo.TimeSeconds;
	}

	return NewTurn;
}

/** The elevator doesn't use the vehicleoverride nano skill, so remove these functions */
simulated function AttemptToOverride(bool bOverrideUp )
{
	return;
}
/** The elevator doesn't use the vehicleoverride nano skill, so remove these functions */
simulated function StopOverride()
{
	return;
}

simulated event PossiblyPlayerOverride()
{
	local float CurrDistanceFromStartingAltitude;
	local NanoPC NPC;
	local bool bWasGoingUp;

	if( !RidingPawn.IsLocallyControlled() )
	{
		return;
	}

	NPC = NanoPC(RidingPawn.Controller);

	// Check for the player overdriving the elevator
	if( !RidingPawn.bStabMantling && (NPC.IsButtonActive(GB_Y) || NPC.IsButtonActive(GB_X)) )
	{
		if( !bIsOverriding )
		{
			bIsOverriding = TRUE;

			// Start shaking the camera
			if( OverdriveCameraShake != None )
			{
				NanoPC(RidingPawn.Controller).ClientPlayCameraShake(OverdriveCameraShake);
			}

			if( PlayerOverridingControl != None )
			{
				PlaySound(PlayerOverridingControl);
			}

			bLimitMaxUpwardsVelocityDueToPlayerOverridingControl = FALSE;

			LocationWhenPlayerOverodeControl = Location;
			LastChangedDirectionTime = WorldInfo.TimeSeconds;

			AC_PlayerRidingOverride = new(self) class'AudioComponent';
			if( AC_PlayerRidingOverride != none )
			{
				AC_PlayerRidingOverride.SoundCue = PlayerRidingOverride;
				AttachComponent( AC_PlayerRidingOverride );
				AC_PlayerRidingOverride.FadeIn( 0.25f, 1.0f );
			}
		}

		bWasGoingUp = bIsOverridingUp;

		// If the player is pressing Y, then the pawn wants to override up.  Otherwise, they're pressing X, and want to go down
		bIsOverridingUp = NPC.IsButtonActive(GB_Y);

		// If we changed overdrive directions without stopping, reset the accel curve
		if( bWasGoingUp != bIsOverridingUp )
		{
			LastChangedDirectionTime = WorldInfo.TimeSeconds;
		}

		// Handle playing sparks if we're above the overdrive launch threshold
		SetOverdriveLaunchEffects( CarSpeed >= MaxCarSpeed );
	}
	else
	{
		bIsOverriding = FALSE;
		bReadyToLaunch = FALSE;

		// Stop shaking the camera
 		if( OverdriveCameraShake != None )
 		{
 			NanoPC(RidingPawn.Controller).ClientStopCameraShake(OverdriveCameraShake);
 		}

		if( AC_PlayerRidingOverride != none )
		{
			AC_PlayerRidingOverride.FadeOut( 0.100f, 0.f );
			DetachComponent( AC_PlayerRidingOverride );
			AC_PlayerRidingOverride = None;
		}

		SetOverdriveLaunchEffects(FALSE);
	}

	CurrDistanceFromStartingAltitude = VSize(LocationWhenPlayerOverodeControl - Location);
	if( AC_PlayerRidingOverride != none )
	{
		AC_PlayerRidingOverride.SetFloatParameter( AirCarEnginePitchName, bIsOverriding ? abs(CurrDistanceFromStartingAltitude/MaxAltitudeChangeAllowWhenOverriden) : 0.f );
	}

}

simulated function SetOverdriveLaunchEffects(bool bEnable)
{
	if( bEnable && !bPlayedOverdriveLaunchEffects )
	{
		// Play the overdrive spark effect, if needed
		if( (OverdriveEffect != None) && (PSC_OverdriveEffect == None) )
		{
			PSC_OverdriveEffect = WorldInfo.MyEmitterPool.SpawnEmitter(OverdriveEffect, Location, Rotation, self);
		}

		// Switch the overriding sound cue, if needed
		if( (AC_PlayerRidingOverride != None) && (AC_PlayerRidingOverride.SoundCue != OverdriveLaunchThresholdSound) )
		{
			AC_PlayerRidingOverride.SoundCue = OverdriveLaunchThresholdSound;
			AC_PlayerRidingOverride.Play();
		}

		// Activate the radial blur
		if( RB_OverdriveBlur != None )
		{
			if( !RB_OverdriveBlur.bEnabled )
			{
				RB_OverdriveBlur.SetEnabled(TRUE);
				RidingPawn.AttachComponent(RB_OverdriveBlur);
			}
		}

		NanoPC(RidingPawn.Controller).ClientPlayCameraShake(OverdriveLaunchThresholdCameraShake);

		bPlayedOverdriveLaunchEffects = TRUE;
	}
	else if( !bEnable && bPlayedOverdriveLaunchEffects )
	{
		// Deactivate the system, if needed
		if( PSC_OverdriveEffect != None )
		{
			PSC_OverdriveEffect.DeactivateSystem();
			PSC_OverdriveEffect = None;
		}

		// Switch the overriding sound cue, if needed
		if( (AC_PlayerRidingOverride != None) && (AC_PlayerRidingOverride.SoundCue != PlayerRidingOverride) && bIsOverriding )
		{
			// Switch back to the normal override sound
			AC_PlayerRidingOverride.SoundCue = PlayerRidingOverride;
		}

		// Disable the radial blur
		if( RB_OverdriveBlur != None )
		{
			RB_OverdriveBlur.SetEnabled(FALSE);
			RidingPawn.DetachComponent(RB_OverdriveBlur);
		}

		bPlayedOverdriveLaunchEffects = FALSE;
	}
}

simulated event ENanoTurnDirection PlayRidingCarSounds( float DeltaTime )
{
	local NanoPC NPC;
	local NanoVehicleSpline TmpSpline;
	local bool bNeedDirectionChange;

	// Handle throttling of the elevator by the player
	NPC = NanoPC(RidingPawn.Controller);
	if( !RidingPawn.bStabMantling )
	{
		if( bIsOverriding || CurrentTurnDecision != ENTD_Straight )
		{	
			// See if we need to change directions because of overriding or player joystick input
			bNeedDirectionChange = (bFollowingPathForward && PawnWantsToGoDown()) || (!bFollowingPathForward && PawnWantsToGoUp());

			if( bNeedDirectionChange )
			{
				// if the pawn is trying to change directions, slow them down first
				CarDesiredSpeed = 0.f;
			}
			else
			{
				if( !bIsOverriding )
				{
					// otherwise, use the joystick to govern speed (0.5 joystick = max speed)
					CarDesiredSpeed = FMin(MaxCarSpeed * 2.f * abs(NPC.PlayerInput.RawJoyUp), MaxCarSpeed);
				}
				else
				{
					// If the player is overriding, always use max throttle
					CarDesiredSpeed = MaxCarSpeed;
				}
			}
		}
		else
		{
			CarDesiredSpeed = 0.f;
		}

		// If we've slowed down enough, change directions if the pawn desires
		if( bNeedDirectionChange && (CarSpeed < 1.f) )
		{
			// Swap the Current and Target splines if we've actually changed directions
			if( TargetSpline != None )
			{
				TmpSpline = CurrentSpline;
				TargetSpline.AddVehicleToSpline(self);
				TargetSpline = TmpSpline;
			}

			bFollowingPathForward = !bFollowingPathForward;

			// Clear the CachedRoute, because we're changing directions
			CachedRoute.Length = 0;
		}
	}

	// Handle camera shaking
	if( bIsPlayingMovingCameraShake && (CarSpeed <= 250.f || bIsOverriding || TargetSpline == None) )
	{
		// If we're playing the moving camera shake, and we drop below the speed threshold or start the override camera shake, stop the moving camera shake
		NPC.ClientStopCameraShake(MovingCameraShake);
		bIsPlayingMovingCameraShake = FALSE;
	}
	else if( !bIsPlayingMovingCameraShake && CarSpeed >= 250.f )
	{
		// Otherwise, if we're not playing the camera shake, but are moving fast enough to, start shaking
		NPC.ClientPlayCameraShake(MovingCameraShake);
		bIsPlayingMovingCameraShake = TRUE;
	}

	// Handle the player trying to overdrive the elevator
	if( bIsOverriding )
	{
		if( (bFollowingPathForward && bIsOverridingUp)
			|| (!bFollowingPathForward && !bIsOverridingUp) )
		{
			// If we're traveling in the same direction we want to go, give the player a boost in speed
			CarDesiredSpeed += OverdriveSpeedModifier;
		}
		else
		{
			// Otherwise, slow them down faster because of the overdrive
			CarDesiredSpeed -= OverdriveSpeedModifier;

			if( CarDesiredSpeed < 0.f )
			{
				CarDesiredSpeed = 0.f;
			}
		}

		if( RidingPawn.IsDensed() )
		{
			// Subtract speed if densed while going up, add if going down
			if( Velocity dot vect(0,0,1) > 0 )
				CarDesiredSpeed -= OverdriveWhileDenseSpeedModifier;
			else
			{
				CarDesiredSpeed += OverdriveWhileDenseSpeedModifier;
			}

			// ready to launch when the car is slowed down as much as it can be by the densing
			if( abs(CarSpeed - CarDesiredSpeed) <= 25.f )
				bReadyToLaunch = TRUE;
			else
				bReadyToLaunch = FALSE;
		}
		else if( bReadyToLaunch )
		{
			LaunchPlayer();
		}
	}

	return bFollowingPathForward ? ENTD_Up : ENTD_Down;
}

simulated event PlayElevatorSounds( float DeltaTime )
{
	if( CarSpeed >= 0.f )
	{
		// Handle playing acceleration / deceleration sounds
		if( (CarDesiredSpeed > 0.f) && !bPlayedAcclerationSound )
		{
			bPlayedAcclerationSound = TRUE;

			PlaySound( PlayerAccelerating );

			bPlayedDecelerationSound = FALSE;

			if( AC_EngineSound != None )
			{
				AC_EngineSound.FadeIn(3.f, 1.f);
			}

			// Play a camera shake on the player
			if( RidingPawn != None )
			{
				NanoPC(RidingPawn.Controller).ClientPlayCameraShake(StartStopCameraShake);
			}
		}
		else if( (CarDesiredSpeed == 0.f) && !bPlayedDecelerationSound )
		{
			bPlayedDecelerationSound = TRUE;

			PlaySound( PlayerDecelerating );

			bPlayedAcclerationSound = FALSE;

			if( AC_EngineSound != None )
			{
				AC_EngineSound.FadeOut(0.5f, 0.f);
			}

			// Play a camera shake on the player
			if( RidingPawn != None )
			{
				NanoPC(RidingPawn.Controller).ClientPlayCameraShake(StartStopCameraShake);
			}
		}
	}
	
	// Blend the pitch up or down, based on the goal
	AirCarEnginePitchGoal = bIsOverriding ? 1.f : 0.f;
	if( ( AirCarEnginePitchCurr != AirCarEnginePitchGoal ) && ( AC_EngineSound != None ) )
	{
		AirCarEnginePitchCurr = FInterpTo( AirCarEnginePitchCurr, AirCarEnginePitchGoal, DeltaTime, 0.67f );
		AC_EngineSound.SetFloatParameter( AirCarEnginePitchName, AirCarEnginePitchCurr );
	}
}

simulated function bool IsOverdriving()
{
	return bIsOverriding;
}

/** For right now, elevators should never spawn ticks **/
function PossiblySpawnATick()
{
	return;
}

simulated function bool ShouldShowActionInfo()
{
	return Super.ShouldShowActionInfo() && (CarDesiredSpeed == 0.f);
}

simulated function vector GetStabAttachOffset()
{
	local SkeletalMeshComponent SMComp;

	SMComp = SkeletalMeshComponent(VehicleMeshComponent);
	if( SMComp == None )
	{
		return Super.GetStabAttachOffset();
	}
	else
	{
		return (SMComp.GetBoneLocation('b_Elevator_Attach_01', 0) - Location) << Rotation;
	}
}

simulated function name GetStabMantleApproachAnim()
{
	return 'Elevator_Stab_Mantle_Front_Fly';
}

simulated function name GetStabMantleAnim( bool bRightSide )
{
	return 'Elevator_Stab_Mantle_Front_Up';
}

simulated function float GetStabMantleAnimRate()
{
	return 1.f;
}

simulated function NotifySomeoneAttached( NanoPawn Rider )
{
	local SkeletalMeshComponent SMComp;
	local float AnimTime;

	SMComp = SkeletalMeshComponent(VehicleMeshComponent);
	if( SMComp != None )
	{
		SMComp.PlayAnim('Elevator_Stab_Mantle_Front_Up');

		AnimTime = SMComp.GetAnimLength('Elevator_Stab_Mantle_Front_Up');
		SetTimer(AnimTime, false, nameof(HideElevatorHatch));
	}
}

simulated function bool ValidPlatformJumpTarget(NanoPawn NP)
{
	return FALSE;
}

simulated function HideElevatorHatch()
{
	local SkeletalMeshComponent SKComp;

	SKComp = SkeletalMeshComponent(VehicleMeshComponent);
	if( SKComp != None )
	{
		SKComp.HideBoneByName('b_Elevator_Hatch', PBO_None);
	}
}

simulated function PlayElevatorRidingAnim()
{
	// Play the custom animation for riding the hacked elevator
	RidingPawn.FullBodySlot.PlayCustomAnim('Elevator_Hatch_Hack_Idle', 1.f, 0.25f, 0.f, TRUE, TRUE);
	RidingPawn.HolsterCurrentWeapon();
}

simulated function GetVehiclePerchOffsets( out vector LocOffset, out rotator RotOffset )
{
	local SkeletalMeshComponent SMComp;

	SMComp = SkeletalMeshComponent(VehicleMeshComponent);
	if( SMComp == None )
	{
		Super.GetVehiclePerchOffsets(LocOffset, RotOffset);
	}
	else
	{
		LocOffset = (SMComp.GetBoneLocation('b_Elevator_Attach_01', 0) - Location) << Rotation;
		RotOffset = QuatToRotator(SMComp.GetBoneQuaternion('b_Elevator_Attach_01', 1));
	}
}

// @todo:  remove this once the spawner has addressed not killing non-vis pawns on the server!
event KillAgent()
{
	return;
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
}