/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDebugCameraActor extends CameraActor
	config(Camera)
	native(Camera);

/** Cached references to necessary actors (for ticking and view targeting) */
var transient NanoPC                NPC;
var transient NanoPlayerInput_Base  NPI;
var transient Camera                PlayerCam;

/** Speeds for camera parameters */
var config float   TranslationSpeed;
var config float   RotationSpeed;
var config float   FOVBlendSpeed;

/** If true, the debug camera will move at twice the normal speed */
var transient bool bFastMode;

cpptext
{
	// Return true here so that we can be ticked when the game is paused (with bAlwaysTick)	
	UBOOL PlayerControlled()
	{
		return TRUE;
	}
};

event PostBeginPlay()
{
	local vector ViewLocation;
	local rotator ViewRotation;

	Super.PostBeginPlay();

	// Look for a player controller input if we have none
	if( NPI == None )
	{
		if( Owner != None )
		{
			NPC = NanoPC(Owner);

			if( NPC != None )
			{
				NPC.DebugCam = self;

				// Store a reference to the player input, so we can read the raw values
				NPI = NanoPlayerInput_Base(NPC.PlayerInput);
				PlayerCam = NPC.PlayerCamera;

				// Initialize the camera to the PC's current view point
				NPC.GetActorEyesViewPoint(ViewLocation, ViewRotation);
				SetLocation(ViewLocation);
				SetRotation(ViewRotation);

				// View from the new camera actor
				NPC.SetViewTarget(self);

				// Pause the game while the camera is active
				NPC.SetPause(TRUE);

				// Set a timer so we can ignore the back + start button button combo to close the camera immediately after spawning it
				SetTimer(2.5f, FALSE, nameof(EnableInputCallback));
			}
		}
	}
}

// Do nothing
function EnableInputCallback();

function ToggleFastMode()
{
	bFastMode = !bFastMode;
}

event Tick( float DeltaTime )
{
	local vector NewPosOffset;
	local rotator NewRotation;
	local float UseSpeed;

	// Update the player camera, since it won't get ticked on it's own
	if( PlayerCam != None )
	{
		PlayerCam.UpdateCamera(DeltaTime);
	}

	// Handle input from the player
	if( NPI != None )
	{
		// --- Handle rotation ---------------------------
		UseSpeed = bFastMode ? 4.f * RotationSpeed : RotationSpeed;
		NewRotation = Rotation;
		NewRotation.Yaw += NPI.RawJoyLookRight * UseSpeed * DeltaTime;
		NewRotation.Pitch -= NPI.RawJoyLookUp * UseSpeed * DeltaTime;

		SetRotation(NewRotation);

		// --- Handle translation ------------------------
		UseSpeed = bFastMode ? 4.f * TranslationSpeed : TranslationSpeed;
		NewPosOffset = vect(0.f, 0.f, 0.f);
		NewPosOffset.X = NPI.RawJoyUp * UseSpeed * DeltaTime;
		NewPosOffset.Y = NPI.RawJoyRight * UseSpeed * DeltaTime;
		NewPosOffset.Z += 0.5f * NPI.InputButtonDataList[GB_LeftTrigger].RawActive * UseSpeed * DeltaTime;      // Dampen the z-speed a little, since it's a bit sensitive on the triggers
		NewPosOffset.Z -= 0.5f * NPI.InputButtonDataList[GB_RightTrigger].RawActive * UseSpeed * DeltaTime;

		NewPosOffset = NewPosOffset >> Rotation;
		SetLocation(Location + NewPosOffset);

		// --- Handle FOV -------------------------------
		UseSpeed = bFastMode ? 4.f * FOVBlendSpeed : FOVBlendSpeed;
		if( NPI.InputButtonDataList[GB_DPad_Up].RawActive > 0.f )
		{
			FOVAngle -= UseSpeed * DeltaTime;
		}
		else if( NPI.InputButtonDataList[GB_DPad_Down].RawActive > 0.f )
		{
			FOVAngle += UseSpeed * DeltaTime;
		}

		FOVAngle = FClamp(FOVAngle, 10.f, 140.f);
	}
}

function EndDebugCamera()
{
	// Restore the view target and unpause the game before destroying self
	if( NPC != None )
	{
		NPC.DebugCam = None;

		NPC.SetViewTarget(NPC.Pawn);
		NPC.SetPause(FALSE);
	}

	Destroy();
}


defaultproperties
{
	bNoDelete=false
	// Always tick, so we can move when the game is paused
	bAlwaysTick=true
}