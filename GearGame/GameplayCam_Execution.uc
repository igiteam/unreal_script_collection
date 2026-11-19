/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Execution extends GearGameplayCameraMode
	config(Camera)
	native(Camera);

// Follower of the attack
var transient GearPawn Follower;
// Camera offset list - relative to transform of the attacker's pelvis bone  
var() const protected array<vector>	CameraOffsets;
// Currently used Camera Offset Index
// Pick on and use it - if not, it will jump around all over
var transient int CameraOffsetIndex;

// Last Saved Offset - if collides, stop fiding new points to go
var transient vector LastSavedCameraOffset;
var transient rotator LastSavedCameraRotator;

cpptext
{
	/**
	* Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	* around this point, offsets are applied from here, etc.
	*/
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
protected:
	/** Get Look At Point between two characters **/
	FVector GetLookAtPoint(class AGearPawn* TargetPawn);
};

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	local GearPawn GP;
	local GSM_InteractionPawnLeader_Base GSM;

	GP = GearPawn(TargetPawn);
	super.OnBecomeActive(TargetPawn, PrevMode);
	
	// set init information
	GSM = GSM_InteractionPawnLeader_Base(GP.SpecialMoves[GP.SpecialMove]);

	if (GSM != none)
	{
		Follower = GSM.Follower;
	}

	CameraOffsetIndex = INDEX_NONE;
	LastSavedCameraOffset = vect(0, 0, 0);
	LastSavedCameraRotator = MakeRotator(0, 0, 0);
}
/**
* Returns the "worst case" camera location for this camera mode.
* This is the position that the camera ray is shot from, so it should be
* a guaranteed safe place to put the camera.
*/
simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local GearPawn GP;
	local vector Loc;

	GP = GearPawn(TargetPawn);
	if (GP != None)
	{
		Loc = GP.Mesh.GetBoneLocation(GP.PelvisBoneName);
	}

	if (IsZero(Loc))
	{
		Loc = GP.Location;
	}

	return Loc;
}

defaultproperties
{
	CameraOffsets = ((X=150,Y=0,Z=100), (X=150,Y=-150,Z=100), (X=150,Y=150,Z=100), (X=150,Y=0,Z=150))

 	ViewOffset={(
 		OffsetHigh=(X=-100,Y=0,Z=5),
 		OffsetLow=(X=-100,Y=0,Z=5),
 		OffsetMid=(X=-100,Y=0,Z=5),
 		)}
 
	BlendTime=0.2f

	bDoPredictiveAvoidance=FALSE
	bValidateWorstLoc=true

	WorstLocOffset=(X=0,Y=0,Z=0)

	OriginLocInterpSpeed=3
	OriginRotInterpSpeed=1
}
