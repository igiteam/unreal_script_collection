//=============================================================================
// This is an example player-specific camera
// Cameras define the Point of View of a player in world space.
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class TPPlayerCamera extends Camera
	config(Game);

const AngleConvert = 0.0000958738;	// 2*PI/65536
var float CurrentFreeCamDistance;
var config float TransitionSpeed;
var config float GrappleFOV;
var vector OffsetLocation;
var rotator OffsetRotation;

var bool                          bUseFallDeathCam;
var TPFallToDeathTriggerInterface DeathTrigger;

var transient Emit_CameraEffect CameraEffectEmitter;


struct DeathCamStruct
{
	var vector smallRays[5];
	var vector rays[10];
	var vector deathLoc;
	var vector points[4];
	var float t;
};

var DeathCamStruct	deathCam;
			

// What is changed
// DesiredFOV, FOVAngle

// Play has begun
function PostBeginPlay()
{
	super.PostBeginPlay();
}

// Where should the death cam be based on how long its been following its bezier path?
function vector DeathCamLerp()
{
	local float OneMinusTime;
	local float timeSquared; 
	local float timeCubed;
	local float oneMinusTimeSquared;
	local float oneMinusTimeCubed;
	local vector answer;

    OneMinusTime            = 1.0f					- deathCam.t;
    timeSquared             = deathCam.t			* deathCam.t;
    timeCubed               = timeSquared			* deathCam.t;
    oneMinusTimeSquared		= OneMinusTime			* OneMinusTime;
    oneMinusTimeCubed		= oneMinusTimeSquared	* OneMinusTime;
	answer					= deathCam.points[0]	* oneMinusTimeCubed;

	answer					+= ( 3 * deathCam.points[1] * deathCam.t	* oneMinusTimeSquared );
	answer					+= ( 3 * deathCam.points[2] * timeSquared	* OneMinusTime );
	answer					+= ( 1 * deathCam.points[3]	* timeCubed );

    return answer;
}

simulated event Tick(float DeltaTime)
{
	local vector Loc;
	local rotator Rot;

    if ( CameraStyle == 'DeathCam' )
	{
		// slerp between points a,b at time T
		deathCam.t += ( DeltaTime / 10.0 );	// 10 second death cam

		if ( deathCam.t > 1.0f )
			deathCam.t = 1.0f;

		//Loc = VLerp(deathCam.orig, deathCam.ext, deathCam.t);
		Loc = DeathCamLerp();
		LookAt(Loc, deathCam.deathLoc, Rot);

		ViewTarget.POV.Location = Loc;
		ViewTarget.POV.Rotation = Rot;
	}
					
    Super.Tick(DeltaTime);
}

simulated state PlayerCameraTransition
{
    simulated event PushedState()
    {
        if (TransitionSpeed > 0)
            CurrentFreeCamDistance = CylinderComponent(PCOwner.Pawn.CollisionComponent).CollisionRadius;
    }

    simulated event PoppedState()
    {
        local TPPlayerController tpp;

        tpp = TPPlayerController(PCOwner);
        PCOwner.FOV(tpp.DesiredFOV);

        tpp.FOVAngle       = tpp.DesiredFOV;
        tpp.bCamTransition = false;
    }

	simulated function Tick(float dt)
	{
		local float Speed;
        local float angle;
        local TPPlayerController tpp;

        tpp = TPPlayerController(PCOwner);

		Speed = TransitionSpeed;

		//if (Speed < 0)
		//	Speed = TransitionSpeed /2;

		CurrentFreeCamDistance += Speed * dt;

        if (tpp.FOVStart > tpp.DesiredFOV)
            angle = lerp(tpp.FOVStart, tpp.DesiredFOV, CurrentFreeCamDistance/FreeCamDistance);
        else
            angle = lerp(tpp.DesiredFOV, tpp.FOVStart, CurrentFreeCamDistance/FreeCamDistance);

        PCOwner.FOV(angle);
        tpp.FOVAngle = angle;

        if (CurrentFreeCamDistance >= FreeCamDistance)
		{
			CurrentFreeCamDistance = FreeCamDistance;
            TransitionSpeed = Default.TransitionSpeed; // Reset to default since can be changed by AnimNotify
            PopState();
		}
		//else if (CurrentFreeCamDistance < 0)
        else if (Speed < 0 && CurrentFreeCamDistance < CylinderComponent(PCOwner.Pawn.CollisionComponent).CollisionRadius)  // Don't let camera clip through player
		{
			CurrentFreeCamDistance = CylinderComponent(PCOwner.Pawn.CollisionComponent).CollisionRadius;
            TransitionSpeed = Default.TransitionSpeed; // Reset to default since can be changed by AnimNotify
            tpp.TrueServerCamera('1st');
			PopState();
		}
       
	}
}

function bool IsInFirstPerson()
{
    return CameraStyle == 'FirstPerson';
}

//SPMIRROR from Camera class
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local vector		Loc, Pos, HitLocation, HitNormal;
	local rotator		Rot;
	local Actor			HitActor;
	local CameraActor	CamActor;
	local bool			bDoNotApplyModifiers;


	// Default FOV on viewtarget
	OutVT.POV.FOV = DefaultFOV;

	// Viewing through a camera actor.
	CamActor = CameraActor(OutVT.Target);

	// Deathcam is handled via tick().  Do not handle it here, as it doesn't follow the standard targetting system.
	if ( CameraStyle == 'DeathCam' )
		return;

	if( CamActor != None )
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio	= bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio		= CamActor.AspectRatio;
		TPPlayerController(PCOwner).SetDesiredFOV(OutVT.POV.FOV);
		PCOwner.FOV(OutVT.POV.FOV);
	}
	else
	{
		// Return if we are in the Multiplayer Menu
		if (CameraStyle == 'MenuFixed')
			return;

		// Give Pawn Viewtarget a chance to dictate the camera position.
		// If Pawn doesn't override the camera view, then we proceed with our own defaults
		if( Pawn(OutVT.Target) == None ||
			!Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV) )
		{
			// don't apply modifiers when using these debug camera modes.
			bDoNotApplyModifiers = TRUE;

            if (bUseFallDeathCam)
            {
                OutVT.POV.Location = DeathTrigger.GetLocation();
                OutVT.POV.Rotation = DeathTrigger.GetLookAt(PCOwner.Pawn.Location);

                return;
            }
			
			switch( CameraStyle )
			{
				case 'Fixed':
					/* do not update, keep previous camera position */
					break;
				
				case 'DebugCam':
					DebugCam( OutVT, DeltaTime );
					break;
				
				case 'DeathCam':
					break;

				case 'ThirdPerson':
				
				case 'FreeCam':
				
					// Simple third person view implementation
					OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
					if (PCOwner != None && PCOwner.Pawn != None)
					{
						Loc    = PCOwner.Pawn.Mesh.GetBoneLocation('JO_Camera');

						if( CameraStyle == 'FreeCam' )
						{
							Rot = PCOwner.Rotation;
						}
						Loc += FreeCamOffset >> Rot;

                        Pos = Loc - Vector(Rot) * CurrentFreeCamDistance;
					    HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(5,5,5));

					    if( HitActor != None && HitActor != Owner)
					    {
						    Loc = HitLocation + HitNormal*2;
					    }
					    else
					    {
		        		    Loc = Pos;
					    }
						
						OutVT.POV.Location = Loc;
						OutVT.POV.Rotation = Rot;
					}
					break;
				case 'Bluff':
				
					BluffCam( OutVT, DeltaTime );
				
					break;

				case 'Grapple':
					GrappleCamera( OutVT, DeltaTime );
					break;

				case 'FirstPerson':
				default:
                    // Get the rotation...
					OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
					OutVT.POV.Rotation += OffsetRotation;
                    OutVT.POV.Rotation.Roll = 0;

                    break;
			}
		}
	}

	if( !bDoNotApplyModifiers )
	{
		// Apply camera modifiers at the end (view shakes for example)
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
	}

	// update any attached camera effect
	if (CameraEffectEmitter != None)
	{
		CameraEffectEmitter.UpdateLocation(OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
	}
	//log( WorldInfo.TimeSeconds  @ GetFuncName() @ OutVT.Target @ OutVT.POV.Location @ OutVT.POV.Rotation @ OutVT.POV.FOV );
}

function ReflectPlane(vector PlaneN, float PlaneD, out vector CamLoc, out rotator CamRot)
{
    local vector LookAt;
    local float  dist;

    LookAt = vector(CamRot);
    LookAt = LookAt - (2 *(LookAt dot PlaneN) * PlaneN);

    CamRot = rotator(LookAt);

    dist = (CamLoc dot PlaneN) - PlaneD;
    CamLoc -= 2 * PlaneN * dist;
}

function ReflectPlaneX(out vector CamLoc, out rotator CamRot)
{
    local vector PlaneX, PlaneY, PlaneZ;
    local float  PlaneD;

    GetAxes(PCOwner.Pawn.Rotation, PlaneX, PlaneY, PlaneZ);
    PlaneD = TPPlayerController(PCOwner).GrappleOpponent.Location dot PlaneX;
    ReflectPlane(PlaneX, PlaneD, CamLoc, CamRot);
}

function ReflectPlaneY(out vector CamLoc, out rotator CamRot)
{
    local vector PlaneX, PlaneY, PlaneZ;
    local float  PlaneD;

    GetAxes(PCOwner.Pawn.Rotation, PlaneX, PlaneY, PlaneZ);
    PlaneD = PCOwner.Pawn.Location dot PlaneY;
    ReflectPlane(PlaneY, PlaneD, CamLoc, CamRot);
}

function ShieldCam(out TViewTarget OutVT, float DeltaTime)
{
    local rotator Rot;
    local vector  Loc, offset, HitLocation, HitNormal;
    local Actor   HitActor;
    local float   Len, hitLen;

    PCOwner.Pawn.GetActorEyesViewPoint(Loc, Rot);
    PCOwner.Pawn.Mesh.GetSocketWorldLocationAndRotation('cameraBone', OutVT.POV.Location, OutVT.POV.Rotation);

    //Loc .   . newLoc
    //     \  |
    //      \ |
    //       \|
    //        | cameraBone location
    Len    = VSize(Loc - OutVT.POV.Location);
    hitLen = Len;
    Loc  = ((Loc - OutVT.POV.Location) dot vector(OutVT.POV.Rotation)) * vector(OutVT.POV.Rotation);
    Loc += OutVT.POV.Location;

	HitActor = PCOwner.Pawn.Trace(HitLocation, HitNormal, OutVT.POV.Location, Loc, true, vect(5,5,5));

	if( HitActor != None)
    {
		OutVT.POV.Location = HitLocation + HitNormal*2;
        hitLen = VSize(Loc - OutVT.POV.Location);
    }

    if (PCOwner.Rotation.Pitch >= 0 && PCOwner.Rotation.Pitch <= class'PlayerPawn'.default.ViewPitchMax)
    {
        offset.z = PCOwner.Rotation.Pitch / class'PlayerPawn'.default.ViewPitchMax;
        offset  *= hitLen/len;
        OutVT.POV.Location -= offset * 150;
        // For looking up, we want to offset more so pistol stays in line with reticle
    }
    else
    {
        offset.z = float(65535-PCOwner.Rotation.Pitch) / class'PlayerPawn'.default.ViewPitchMin;
        offset  *= hitLen/len;
        OutVT.POV.Location -= offset * 150;
    }
    
    OutVT.POV.Rotation.Pitch += PCOwner.Rotation.Pitch;
}

function GrappleCamera(out TViewTarget OutVT, float DeltaTime)
{
    if (TPPlayerController(PCOwner).IsInState('PlayerShielding'))
        ShieldCam(OutVT, DeltaTime);
    else
        GrappleCam(OutVT, DeltaTime);
}

function GrappleCam(out TViewTarget OutVT, float DeltaTime)
{
    local Actor HitActor;
    local vector PlaneX, PlaneY, PlaneZ, Dummy;
    local GrappleInteraction_v2 GrapInt;

    GrapInt = TPPlayerController(PCOwner).GrapInt_v2;
    GetAxes(PCOwner.Pawn.Rotation, PlaneX, PlaneY, PlaneZ);

	//Use the camera bone
	PCOwner.Pawn.Mesh.GetSocketWorldLocationAndRotation('cameraBone', OutVT.POV.Location, OutVT.POV.Rotation);

    // Reflect the camera about the player's x and y planes if necessary
    HitActor = PCOwner.Pawn.Trace(Dummy, Dummy, PCOwner.Pawn.Location, OutVT.POV.Location);
    if (GrapInt.GrappleCamChoice >= 1 || 
        (HitActor != None && HitActor != TPPlayerController(PCOwner).GrappleOpponent && !HitActor.IsA('TPDroppedPickup')))
    {
        if (GrapInt.GrappleCamChoice <= 1)
            GrapInt.GrappleCamChoice = 1;

        ReflectPlaneY(OutVT.POV.Location, OutVT.POV.Rotation);
    }

    HitActor = PCOwner.Pawn.Trace(Dummy, Dummy, PCOwner.Pawn.Location, OutVT.POV.Location);
    if (GrapInt.GrappleCamChoice >= 2 ||
        (HitActor != None && HitActor != TPPlayerController(PCOwner).GrappleOpponent && !HitActor.IsA('TPDroppedPickup')))
    {
        if (GrapInt.GrappleCamChoice <= 2)
            GrapInt.GrappleCamChoice = 2;

        ReflectPlaneX(OutVT.POV.Location, OutVT.POV.Rotation);
    }

    HitActor = PCOwner.Pawn.Trace(Dummy, Dummy, PCOwner.Pawn.Location, OutVT.POV.Location);
    if (GrapInt.GrappleCamChoice >= 3 ||
        (HitActor != None && HitActor != TPPlayerController(PCOwner).GrappleOpponent && !HitActor.IsA('TPDroppedPickup')))
    {
        if (GrapInt.GrappleCamChoice <= 3)
            GrapInt.GrappleCamChoice = 3;

        GrapInt.GrappleCamChoice = 3;
        ReflectPlaneY(OutVT.POV.Location, OutVT.POV.Rotation);
    }
}

function BluffCam(out TViewTarget OutVT, float DeltaTime)
{
	//Use the camera bone	
	
	PCOwner.Pawn.Mesh.GetSocketWorldLocationAndRotation('cameraBone', OutVT.POV.Location, OutVT.POV.Rotation);
}

function DebugCam(out TViewTarget OutVT, float DeltaTime)
{
    TPPlayerController(PCOwner).GetDebugCam(OutVT);
}

function LookAt(vector camLoc, vector lookAtLoc, out rotator outCamRot)
{
	local vector delta;
	local float horiz;
	
	delta = lookAtLoc - camLoc;
	horiz = sqrt( (delta.x*delta.x) + (delta.y*delta.y) );

	outCamRot.Yaw	= atan( delta.y, delta.x )/AngleConvert;
	outCamRot.Pitch = atan( delta.z, horiz )/AngleConvert;
}

/**
 * @param EffectEmitter If None, remove any effect.  If set, remove only that effect.
 */
simulated function RemoveCameraEffect(Emit_CameraEffect EffectEmitter)
{
	if (CameraEffectEmitter == EffectEmitter)
	{
		CameraEffectEmitter = None;
	}
}

simulated function ClearCameraEffect()
{
	if (CameraEffectEmitter != None)
	{
		CameraEffectEmitter.Destroy();
		CameraEffectEmitter = none;
	}
}

