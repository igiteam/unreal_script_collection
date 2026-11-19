/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Turbine extends NanoSpecialMove;

/** Cached reference to the turbine the pawn is based on */
var transient NanoTurbineBase  Turbine;

/** Index of the blade that the pawn is attached to */
var transient int BladeIdx;

function ExtractSpecialMoveFlags( int Flags )
{
	BladeIdx = MyNP.SpecialMoveFlags;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local float AnimPosition;

	Super.SpecialMoveStarted( bForced, PrevMove );

	Turbine = NanoTurbineBase(MyNP.InteractionActor);

	if( Turbine != None )
	{
		if (!MyNP.bEmptyHanded)
		{
			MyNP.HolsterCurrentWeapon();
		}
		//`log("grabbing on to"@BladeTips[BladeIdx].BoneName);
		Turbine.BladeIdx = BladeIdx;
 		AnimPosition = ((Turbine.SeqNode.GetNormalizedPosition() + Turbine.BladeTips[BladeIdx].AnimPositionOffset) % 1);
 		AnimPosition *= Turbine.SeqNode.GetAnimPlaybackLength();
		MyNP.CurrentTurbine = Turbine;
		MyNP.SetPhysics(PHYS_None);
		MyNP.SetCollision(FALSE,FALSE,FALSE);
		MyNP.FullBodySlot.PlayCustomAnim('NW_Turbine_Grab_Transition_Loop', GetSpeedModifier(), 0.35f, -1.f, TRUE, TRUE, AnimPosition);
		MyNP.DesiredClothBlend = 0.0;
		MyNP.RootAttachmentComponent = Turbine.Mesh;
		MyNP.RootAttachmentBoneName = Turbine.BladeTips[BladeIdx].BoneName;
		MyNP.RootAttachmentInterpDuration = 0.35f;
		MyNP.RootAttachmentInterpTime = 0.f;
		MyNP.SetTimer(MyNP.RootAttachmentInterpDuration,FALSE,nameof(UpdateAttach), self);

		if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
		{
			MyNP.GetCamera().Default3pCam.AdhereToCameraBone(TRUE);
			MyNP.PlaySound(Turbine.PlayerGrabbedCue,FALSE);
			MyNP.GetPC().SetSoundMode(Turbine.PlayerGrabbedSoundMode);
		}
		
		Turbine.CurrentUser = MyNP;
		Turbine.LaunchIdx   = -1;
	}
	else
	{
		`log(self@"Turbine is NONE!!!");
	}
	
}

simulated function Rotator GetRotationFromTurbine()
{
	if( Turbine.bReverseDirection )
	{
		return Turbine.Rotation + rot(0,16384,0);
	}
	else
	{
		return Turbine.Rotation + rot(0,-16384,0);
	}
}

function UpdateAttach()
{
	`log(`location);
	MyNP.RootAttachmentComponent = None;
	MyNP.SetRotation(GetRotationFromTurbine());
	MyNP.SetBase(Turbine,,Turbine.Mesh,Turbine.BladeTips[BladeIdx].BoneName);
	MyNP.SetRelativeLocation(vect(0,0,1) * MyNP.GetCollisionHeight());
	if( Turbine.bReverseDirection )
	{
		MyNP.SetRelativeRotation(rot(0,32768,0));
	}
	else
	{
		MyNP.SetRelativeRotation(rot(0,0,0));
	}
	
	MyNP.RootAttachmentInterpTime = 0.f;

	if( MyNP.IsLocallyControlled() && MyNP.IsHumanControlled() )
	{
		MyNP.GetCamera().Default3pCam.bInterpLocByTime = TRUE;
		MyNP.GetCamera().Default3pCam.SetInterpLocationByTime(TRUE,0.25f,MyNP.GetCamera().PlayerCamera.Location);
		MyNP.GetCamera().Default3pCam.bInterpToIdealLocThenLock = TRUE;
	}
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( MyNP.RootAttachmentInterpDuration > 0.f )
	{
		MyNP.SetRotation(RInterpTo(MyNP.Rotation,GetRotationFromTurbine(),DeltaTime*2.f,32768,TRUE));
		MyNP.SetDesiredRotation(MyNP.Rotation);
	}

// 	if (MyNP.IsLocallyControlled())
// 	{
// 		MyNP.Controller.SetRotation(MyNP.Rotation);
// 	}
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	local vector X, Y, Z;
	local float VelX;

	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.SetBase(None);
	MyNP.SetPhysics(PHYS_Falling);
	MyNP.SetCollision(TRUE,TRUE,FALSE);
	MyNP.RootAttachmentComponent = None;
	MyNP.DesiredClothBlend = 1.0;

	if( Turbine.BladeIdx >= 0 )
	{
		MyNP.FullBodySlot.PlayCustomAnim('NW_Turbine_Grab_Release', GetSpeedModifier(), 0.1f, 0.f, FALSE, FALSE);
		MyNP.UpdateJumpAnimSet('Turbine_Jump');

		//`log(WorldInfo.TimeSeconds@`location@`showvar(CurrentUser.Rotation)@`showvar(RootLoc - CurrentUser.Location));
		if (Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchSpline != None)
		{
			VelX = FMax( Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchVelocity.X, 100.f );
			MyNP.SetSplineBase( Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchSpline, VelX );
		}
		else
		{
			if (Turbine.LaunchPointList[Turbine.LaunchIdx].bForceMaxLaunchVelocity)
			{
				MyNP.Velocity += Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchVelocity >> GetRotationFromTurbine();
			}
			else
			{
				GetAxes(GetRotationFromTurbine(),X,Y,Z);
				MyNP.Velocity += X * Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchVelocity.X + Y * Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchVelocity.Y + Z * Turbine.LaunchPointList[Turbine.LaunchIdx].LaunchVelocity.Z * FClamp((Turbine.WorldInfo.TimeSeconds - Turbine.LastLaunchOpportunity)/0.4,0.25,1.f);
			}
		}
	}
	else
	{
		MyNP.Velocity.Z = 300.f;
		MyNP.UpdateJumpAnimSet();
		MyNP.FullBodySlot.StopCustomAnim( 0.25f );
	}

	if( MyNP.IsLocallyControlled() )
	{
		MyNP.ResetDefaultCamAdhereToCameraBone();
		MyNP.GetPC().SetSoundMode('Default');
	}
	
	MyNP.CurrentTurbine = None;
	Turbine.CurrentUser = None;
	Turbine.LaunchIdx   = -1;

	Turbine = None;
}

defaultproperties
{
	bUseUnsynchedServerMove=true
	bSkipOrbitCameraBlend=true
}