/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMEmitCameraEffect extends Emitter
	abstract
	native;

/** How far in front of the camera this emitter should live. */
var() protected float DistFromCamera;

/** Camera this emitter is attached to, will be notified when emitter is destroyed */
var protected TMPlayerController Cam;


simulated event PostBeginPlay()
{
	ParticleSystemComponent.SetDepthPriorityGroup(SDPG_Foreground);
	super.PostBeginPlay();
}

function Destroyed()
{
	Cam.RemoveCameraEffect(self);
}

/** Tell the emitter what camera it is attached to. */
function RegisterCamera( TMPlayerController inCam )
{
	Cam = inCam;
}

/** Given updated camera information, adjust this effect to display appropriately. */
native function UpdateLocation( const out vector CamLoc, const out rotator CamRot, float CamFOVDeg );



