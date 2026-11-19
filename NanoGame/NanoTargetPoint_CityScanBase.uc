/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTargetPoint_CityScanBase extends NanoTargetPoint
	abstract;

/** Material for the target marker **/
var() Material     TargetMaterial;
var transient MaterialInstanceConstant    TargetMaterialInst;
/** Mesh that will be textured with the above material instance **/
var     StaticMeshComponent         TargetMesh;

/** Sound cue that the player will be hunting down while scanning for this target **/
var()   SoundCue            ScanAudio;
/** Scrambled version of the audio above that will play as the player drifts away from the signal **/
var()   SoundCue            ScanScrambledAudio;
/** The max speed at which the signal can travel around the channel's XY plane **/
var()   float               ScanAudioMaxSpeed;
/** Within this distance (in percentage, 0.0 to 1.0), the player will tune in the audio for this node **/
var()   float               TuningDistance;

/** Current position within the current channel that the scan audio target is at **/
var transient   Vector2D    ScanAudioPosition;
/** Current position that the audio signal is interpolating to on the channel's XY plane **/
var transient   Vector2D    CurrentScanAudioTarget;
/** Current channel (z-depth) that the scan audio target is at **/
var transient   int         ScanAudioChannel;

/** Color of the target when it's targeted for scanning **/
var() LinearColor           ActiveTargetColor;
/** Color of the target when it's not being scanned **/
var() LinearColor           InactiveTargetColor;
/** Used to blend the current color **/
var transient LinearColor   CurrentTargetColor;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Initialize the target material
	TargetMesh.SetMaterial(0, TargetMaterial);
	TargetMaterialInst = TargetMesh.CreateAndSetMaterialInstanceConstant(0);
	TargetMaterialInst.SetVectorParameterValue('ReticleColor', InactiveTargetColor);
	CurrentTargetColor = InactiveTargetColor;

	// Determine the starting channel for the audio
	ScanAudioChannel = Rand(class'NanoPawn_RebelsBase'.const.TOTAL_CITYSCAN_AUDIO_CHANNELS-1);

	// Determine the starting position in the channel for the audio (within the middle 70% of the channel so we don't start on the end)
	ScanAudioPosition.X = 0.70f * FRand() + 0.15f;
	ScanAudioPosition.Y = 0.70f * FRand() + 0.15f;

	// Determine and initial location for the scan audio to interpolate to
	CurrentScanAudioTarget.X = FRand();
	CurrentScanAudioTarget.Y = FRand();

	// Register this city scan target with the GRI for fast iteration
	NanoGRI(WorldInfo.GRI).CityScanTargets.AddItem(self);
}

simulated event Destroyed()
{
	Super.Destroyed();

	TargetMaterialInst = None;

	// Unregister this target with the GRI
	NanoGRI(WorldInfo.GRI).CityScanTargets.RemoveItem(self);
}

/** Called when the player is looking at this target **/
simulated function TargetActivated()
{
	GotoState('TargetActive');
}

/** Called when the player is no longer looking at this target **/
simulated function TargetDeactivated()
{
	GotoState('TargetInactive');
}

/** Called when a player successfully tunes into and listens to the whole broadcast **/
simulated function ScanCompleted( NanoPawn_RebelsBase InstigatingPawn )
{
	// Tell kismet that the scan for this target has been completed
	TriggerEventClass(class'SeqEvt_CityScanAudioComplete', InstigatingPawn, 0);

	// Hide the target so the pawn doesn't consider it
	SetHidden(TRUE);
}

simulated state TargetActive
{
	simulated event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		// Blend the color to the active target color, if needed
		if( CurrentTargetColor != ActiveTargetColor )
		{
			CurrentTargetColor.R = FInterpTo(CurrentTargetColor.R, ActiveTargetColor.R, DeltaTime, 10.f);
			CurrentTargetColor.G = FInterpTo(CurrentTargetColor.G, ActiveTargetColor.G, DeltaTime, 10.f);
			CurrentTargetColor.B = FInterpTo(CurrentTargetColor.B, ActiveTargetColor.B, DeltaTime, 10.f);
			CurrentTargetColor.A = FInterpTo(CurrentTargetColor.A, ActiveTargetColor.A, DeltaTime, 10.f);

			if( TargetMaterialInst != None )
			{
				TargetMaterialInst.SetVectorParameterValue('ReticleColor', CurrentTargetColor);
			}
		}
	}
};

simulated state TargetInactive
{
	simulated event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		// Blend the color to the inactive target color, if needed
		if( CurrentTargetColor != InactiveTargetColor )
		{
			CurrentTargetColor.R = FInterpTo(CurrentTargetColor.R, InactiveTargetColor.R, DeltaTime, 10.f);
			CurrentTargetColor.G = FInterpTo(CurrentTargetColor.G, InactiveTargetColor.G, DeltaTime, 10.f);
			CurrentTargetColor.B = FInterpTo(CurrentTargetColor.B, InactiveTargetColor.B, DeltaTime, 10.f);
			CurrentTargetColor.A = FInterpTo(CurrentTargetColor.A, InactiveTargetColor.A, DeltaTime, 10.f);

			if( TargetMaterialInst != None )
			{
				TargetMaterialInst.SetVectorParameterValue('ReticleColor', CurrentTargetColor);
			}
		}
	}
};

simulated function bool PlayerAbleToTune( vector CameraLocation, vector CameraDirection )
{
	local float ViewingAngleDot;

	// Determine the angle between the camera direction and the vector from the pawn
	ViewingAngleDot = Normal(Location - CameraLocation) dot CameraDirection;

	// Return true if < ~10 degrees
	return (ViewingAngleDot > 0.98) && !bHidden;
}

/** Returns true if player is locked on to the audio signal **/
simulated function bool IsPlayerTuned( vector2D PlayerTuningLocation, int PlayerTuningChannel, out float TunedPercentage )
{
	local float Distance;

	// Only do the distance test if the signal is on the same channel as the player
	if( !bHidden && (PlayerTuningChannel == ScanAudioChannel) )
	{
		Distance = Square(PlayerTuningLocation.X - ScanAudioPosition.X) + Square(PlayerTuningLocation.Y - ScanAudioPosition.Y);

		TunedPercentage = FMax(1.f - Distance / Square(TuningDistance), 0.f);

		return ( TunedPercentage > 0.f );
	}

	TunedPercentage = 0.f;
	return FALSE;
}

/** Called every tick where the scanner is active and this point is targeted **/
simulated function UpdateSignalPosition( float DeltaTime )
{
	local Vector2D Dist;
	local float    MoveStep, DistMag;

	// Only bother moving the target if we have a velocity
	if( ScanAudioMaxSpeed > 0.f )
	{
		// Interpolate the signal towards the current target destination
		MoveStep = FClamp(DeltaTime * ScanAudioMaxSpeed, 0.f, 1.f);

		// Calculate the distance remaining
		Dist = CurrentScanAudioTarget - ScanAudioPosition;
		DistMag = sqrt(Dist.X ** 2 + Dist.Y ** 2);
		if( DistMag <= MoveStep )
		{
			// If we're close, set the current position to the target
			ScanAudioPosition = CurrentScanAudioTarget;

			// Pick a new destination to interpolate to
			CurrentScanAudioTarget.X = FRand();
			CurrentScanAudioTarget.Y = FRand();
		}
		else
		{
			// Otherwise, interpolate towards the target
			Dist.X /= DistMag;
			Dist.Y /= DistMag;

			ScanAudioPosition.X += Dist.X * MoveStep;
			ScanAudioPosition.Y += Dist.Y * MoveStep;
		}
	}
}

// Due to lack of a screen aligned material sprite or mesh, screen align up the meshes the old fashioned way
simulated function AlignScanTargetToPawn( vector CameraPosition )
{
	SetRotation(rotator(CameraPosition - Location));
}

defaultproperties
{

}