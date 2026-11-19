/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_AntennaRun extends NSM_Mantle_Base;
/** Cached reference to the antenna the pawn is based on */
var NanoAntennaBase  Antenna;

/** Whether or not to use the alternate animation on the antenna / pawn */
var bool             bUseAltAnim;

var Vector AttackDir;
var Vector LaunchVelocity;

function ExtractSpecialMoveFlags( int Flags )
{
	bUseAltAnim = (MyNP.SpecialMoveFlags & 1) == 1;
	if( bUseAltAnim )
	{
		AttackDir = Normal((Antenna.LaunchSpline.Location - Antenna.Location) * vect(1,1,0));
		LaunchVelocity = vect(0,0,0);
		AnimName = 'NW_Antenna_Run_Up_B';
	}
	else
	{
		AttackDir = MyNP.Velocity;
		LaunchVelocity = Antenna.LaunchVelocity;
		AnimName = 'NW_Antenna_Run_Up';
	}

	WallNorm = -AttackDir;
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Antenna = NanoAntennaBase(MyNP.InteractionActor);

	Super.SpecialMoveStarted( bForced, PrevMove );

	if( Antenna != None )
	{
		// --- Antenna Init -----------------------
		Antenna.CurrentUser = MyNP;
		Antenna.BeginAntennaMantle( (bUseAltAnim ? 'Antenna_Run_Up_B' : 'Antenna_Run_Up'), rotator(AttackDir));

		PostMantleVelocity = LaunchVelocity;
		if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
		{
			MyNP.GetCamera().Default3pCam.AdhereToCameraBone(TRUE);
		}

		MyNP.RootAttachmentComponent = Antenna.Mesh;
		MyNP.RootAttachmentBoneName = 'Antenna_Attach';
	}
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	if( Antenna.LaunchSpline != None )
	{
		// need to explicitly set jump set, otherwise the mantle will handle it
		MyNP.UpdateJumpAnimSet( 'Antenna_Jump' );
		MyNP.SetSplineBase( Antenna.LaunchSpline, Antenna.LaunchVelocity.X );
	}

	if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
	{
		MyNP.GetCamera().Default3pCam.AdhereToCameraBone(FALSE);
	}

	MyNP.RootAttachmentComponent = None;
	Antenna.CurrentUser = None;

	Antenna = None;
}

defaultproperties
{
	// Keep this true so we can bob up and down on the perch pole without the server trying to correct us all the time
	bUseUnsynchedServerMove=true
	bSkipSimulatedPhysics=true


	WalkAnimNames=("NW_Antenna_Run_Up,NW_Antenna_Run_Up_B")
	bManuallyTriggered=TRUE
	bForceCenterView=TRUE
	MantleType=MANTLE_AntennaRun
	MinAnimRate=1.f
	MaxAnimRate=1.f
	RequiredPhysics=(PHYS_Walking)
	bForcePostMantleVelocity=TRUE
	PostMantleVelocity=(X=1200,Z=384)
	PostMantleFallSetName=Antenna_Jump
	bAllowJump=FALSE
	BlendInTime=0.2f
	BlendOutTime=0.2f
	ClothBlend=1.0
}