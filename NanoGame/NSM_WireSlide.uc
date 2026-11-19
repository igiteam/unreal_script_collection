/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_WireSlide extends NanoSpecialMove
	native(Inherit);

var transient   NanoWireBase    Wire;

/** Current position along the wire, in spline space */
var transient   float   CurrentWirePosition;

/** Current velocity of the pawn along the wire (positive: away from origin, negative: towards origin) */
var transient   float   WireSpeed;

/** Animations to play when the pawn is idle, accelerating forward and backward */
var()   name        IdleAnimName;
var()   name        ForwardAccelAnimName;
var()   name        BackwardAccelAnimName;

/** Whether or not the pawn wants to head towards the origin of the wire */
var transient   bool    bWantsToHeadBackwards;

/** TRUE when the player has densed, and is preparing to launch */
var transient   bool    bChargingDenseJump;
/** Time densed required to get the full dense jump bonus */
var()   float           DenseJumpRequiredTime;


var SoundCue WireSlideStartSound;

var SoundCue WireSlideLoopingSound;
var transient AudioComponent AC_LoopingSlidingSound;

var SoundCue WireSlideStopSound;


cpptext
{
	/** This is where we update the pawn's location on the wire slide */
	virtual void TickSpecialMove(FLOAT DeltaTime);
};

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	Wire = NanoWireBase(MyNP.InteractionActor);

	// Lock the pawn in on the wire
	MyNP.SetPhysics( PHYS_None );
	MyNP.SetLocation( Wire.GetClosestPointOnWireTo(MyNP.Location, CurrentWirePosition) );

	// Zero out the mesh translation, so the animation lines up with the wire
	MyNP.SetMeshTranslationOffset( (-MyNP.default.Mesh.Translation >> MyNP.Rotation), TRUE );
	MyNP.bDisableMeshTranslationChanges = TRUE;

	WireSpeed = 0.f;
	bChargingDenseJump = FALSE;

	MyNP.PlaySound( WireSlideStartSound );

	AC_LoopingSlidingSound = new(self) class'AudioComponent';
	if( AC_LoopingSlidingSound != None )
	{
		AC_LoopingSlidingSound.SoundCue = WireSlideLoopingSound;
		AC_LoopingSlidingSound.FadeIn( 0.3f, 1.0f );
		MyNP.AttachComponent( AC_LoopingSlidingSound );
	}
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.ClearTimer(nameof(DenseLaunch), self);

	MyNP.bDisableMeshTranslationChanges = FALSE;
	MyNP.SetPhysics(PHYS_Falling);

	MyNP.FullBodySlot.StopCustomAnim(0.2f);

	MyNP.PlaySound( WireSlideStopSound );
	if( AC_LoopingSlidingSound != None )
	{
		AC_LoopingSlidingSound.FadeOut( 0.3f, 0.0f );
		AC_LoopingSlidingSound = None;
	}
}

event ArrivedAtEnd()
{
	if( MyNP.IsLocallyControlled() )
	{
		MyNP.EndSpecialMove('NSM_WireSlide');
		MyNP.HandleMantleChecks( NanoPC(MyNP.Controller) );
	}
}

function bool CheckActiveDismount()
{
	local vector EndToCheck;

	// See which endpoint we should check, depending on direction of travel
	EndToCheck = (WireSpeed >= 0.f) ? Wire.EndPoint : Wire.Location;

	return (VSize(EndToCheck - MyNP.Location) <= Wire.ActiveDismountDistance);
}

function Tick( float DeltaTime )
{
	local bool bAccelerating;

	Super.Tick(DeltaTime);

	// See if we're accelerating, and play the appropriate anim
	bAccelerating = (bWantsToHeadBackwards && WireSpeed < 0.f) || ( !bWantsToHeadBackwards && WireSpeed > 0.f );
	if( abs(WireSpeed) <= 500.f  )
	{
		if( MyNP.FullBodySlot.GetPlayedAnimation() != IdleAnimName )
		{
			MyNP.FullBodySlot.PlayCustomAnim(IdleAnimName, GetSpeedModifier(), 0.2f, 0.f, TRUE);
		}
	}
	else if( !bAccelerating || bChargingDenseJump )
	{
		if( MyNP.FullBodySlot.GetPlayedAnimation() != BackwardAccelAnimName )
		{
			MyNP.FullBodySlot.PlayCustomAnim(BackwardAccelAnimName, GetSpeedModifier(), 0.2f, 0.f, TRUE);
		}
	}
	else
	{
		if( MyNP.FullBodySlot.GetPlayedAnimation() != ForwardAccelAnimName )
		{
			MyNP.FullBodySlot.PlayCustomAnim(ForwardAccelAnimName, GetSpeedModifier(), 0.5f, 0.f, TRUE);
		}
	}

	// Update dense status if necessary
	if( !bChargingDenseJump && MyNP.CurrNanoState == ENS_Dense )
	{
		bChargingDenseJump = TRUE;
		MyNP.SetTimer(DenseJumpRequiredTime, FALSE, nameof(DenseLaunch), self);
	}
}

function DenseLaunch()
{
	MyNP.EndSpecialMove('NSM_WireSlide');

	MyNP.Velocity.Z = Wire.WireDensedJumpVelocity;
}

/** Check for an active mantle button press! */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	if( bPressed && !bChargingDenseJump )
	{
		if( ButtonName == 'A' )
		{
			MyNP.EndSpecialMove('NSM_WireSlide');

			if( CheckActiveDismount() )
			{
				// We performed an active dismount, perform a handspring!
				MyNP.MantleState = MANTLE_EndingMantle;
				if( NanoPlayerInput(PlayerController(MyNP.Controller).PlayerInput).AttemptJump() )
				{
					MyNP.bHandspringJump = true;
					MyNP.MantleState = MANTLE_FlipJump;
					MyNP.BlendFallNode.CopyAnimsFromSetByName('FlipJump');
					MyNP.BlendFallNode.bResetFall = TRUE;
					MyNP.BlendFallNode.ChangeFallState( FBT_Up );
					MyNP.bHandspringJump = false;
					MyNP.Velocity.Z = Wire.WireJumpVelocity;
					MyNP.Velocity *= Wire.ActiveDismountVelocityBonus;
				}
			}
			else if( !bChargingDenseJump )
			{
				// With a normal jump, just give them the normal wire boost
				MyNP.Velocity.Z = Wire.WireJumpVelocity;
			}

			return TRUE;
		}
		else if( ButtonName == 'X' )
		{
			MyNP.EndSpecialMove('NSM_WireSlide');
			return TRUE;
		}	
	}

	return FALSE;
}

defaultproperties
{
	bLockMeshTranslationOffset=TRUE

	IdleAnimName=Zipline_Idle
	ForwardAccelAnimName=Zipline_Fwd
	BackwardAccelAnimName=Zipline_Bwd

	DenseJumpRequiredTime=1.f

	WireSlideStartSound=SoundCue'Gameplay_Audio.CableSlide.CableSlide_Start_Cue'
	WireSlideLoopingSound=SoundCue'Gameplay_Audio.CableSlide.CableSlide_Travel_Loop_Stereo_01Cue'
	WireSlideStopSound=SoundCue'Gameplay_Audio.CableSlide.CableSlide_Stop_Cue'
}