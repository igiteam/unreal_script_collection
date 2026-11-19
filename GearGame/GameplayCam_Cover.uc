/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Cover extends GearGameplayCameraMode
	native(Camera)
	config(Camera);

//
// Player Relative Offsets
//

/** Posture: Standing Cover */
var() protected vector PawnRel_Posture_Standing;
/** Posture: Mid Level Cover */
var() protected vector PawnRel_Posture_MidLevel;

/** MidLevel: Default (moving) */
/** MidLevel: blindfiring */
var() protected vector PawnRel_Mod_MidLvlBlindUp;

/** MidLevel: Pop Up */
var() protected vector PawnRel_Mod_PopUp_MidLevel;
/** MidLevel: Pop Up, while doing 360 aim */
var() protected vector PawnRel_Mod_360Aim_PopUp;

/** Standing: Lean Right (We automatically negate Y for Lean Left) */
var() protected vector PawnRel_Mod_Lean_Standing;
/** MidLevel: Lean Right (We automatically negate Y for Lean Left) */
var() protected vector PawnRel_Mod_Lean_MidLevel;

/** Standing: Lean Right, while doing 360 aim */
var() protected vector PawnRel_Mod_Lean_360Aim_Standing;
/** MidLevel: Lean Right, while doing 360 aim */
var() protected vector PawnRel_Mod_Lean_360Aim_MidLevel;
/** Standing or MidLevel: standing near edge of cover */
var() protected vector PawnRel_Mod_CoverEdge;

/** View limits */
var() rotator ViewMaxLimit, ViewMaxLimit_Lean, ViewMaxLimit_Circular;
var() rotator ViewMinLimit, ViewMinLimit_Lean, ViewMinLimit_Circular;
var transient float LastCoverYaw;

/** WorstLocOffset to use when crouched/in low cover */
var() vector	WorstLocOffsetLow;

/** Angle at which to apply full offset Y inversion.  See AdjustPROForStance() */
var() float		CoverAngLimit;

var protected transient bool	bTemporaryOriginRotInterp;
var() protected const float		TemporaryOriginRotInterpSpeed;

/** Accumulated DeltaYaw due to CoverNormal Interpolation. So we can apply it more slowly over time */
var INT CoverNormalInterpYawAcc;
/** Speed for CoverNormalInterpolation */
var const FLOAT CoverNormalInterpSpeed;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

/** Get Pawn's relative offset (from location based on pawn's rotation */
function vector AdjustViewOffset( Pawn P, vector Offset )
{
	local ECoverType		CT;
	local ECoverAction		CA;
	local ECoverDirection	CD;
	local vector			OffsetAdjustment;
	local GearPawn			WP;
	local CoverLink			Link;
	local float				DistanceToSlot, Pct, LinkDist, LeanBlendWeight, BackToWallWeight;

	// can be None if camera target is not a GearPawn
	WP = GearPawn(P);

	if (WP != None)
	{
		CA = WP.CoverAction;
		CT = WP.CoverType;
		if (GearPC(WP.Controller) != None)
		{
			CD = GearPC(WP.Controller).GetCoverDirection();
		}
		else
		{
			// if spectating then guess at the cover direction
			if (CA == CA_LeanLeft)
			{
				CD = CD_Left;
			}
			else
			if (CA == CA_LeanRight)
			{
				CD = CD_Right;
			}
			else
			if (CA == CA_PopUp)
			{
				CD = CD_Up;
			}
			else
			{
				CD = CD_Default;
			}
		}
		// if not at cover then abort
		if( CT == CT_None )
		{
			return Super.AdjustViewOffset(P, Offset);
		}
		// initial offset based on cover type
		switch( CT )
		{
			case CT_Standing:	OffsetAdjustment = PawnRel_Posture_Standing;		break;
			case CT_MidLevel:	OffsetAdjustment = PawnRel_Posture_MidLevel;		break;
		}

		//`log(`showvar(CD)@`showvar(CA)@`showvar(CT)@`showvar(WP.IsPoppingUp()));
		if( WP.CoverBlendNode != None && (WP.IsDoing360ToLeaningTransition() || WP.IsDoingLeaningTo360Transition() || WP.IsDoingPopUpToLeanTransition()) )
		{
			OffsetAdjustment += PawnRel_Mod_MidLvlBlindUp * WP.CoverBlendNode.Children[3].Weight *  WP.CoverBlendNode.NodeTotalWeight;
			OffsetAdjustment += PawnRel_Mod_PopUp_MidLevel * WP.CoverBlendNode.Children[4].Weight *  WP.CoverBlendNode.NodeTotalWeight;

			BackToWallWeight = WP.CoverBlendNode.Children[1].Weight *  WP.CoverBlendNode.NodeTotalWeight;
			LeanBlendWeight = WP.CoverBlendNode.Children[5].Weight *  WP.CoverBlendNode.NodeTotalWeight;
			switch( CT )
			{
				case CT_Standing:	OffsetAdjustment += PawnRel_Mod_Lean_360Aim_Standing * LeanBlendWeight * BackToWallWeight;	break;
				case CT_MidLevel:	OffsetAdjustment += PawnRel_Mod_Lean_360Aim_MidLevel * LeanBlendWeight * BackToWallWeight;	break;
			}
			switch( CT )
			{
				case CT_Standing:	OffsetAdjustment += PawnRel_Mod_Lean_Standing * LeanBlendWeight * (1.f - BackToWallWeight);	break;
				case CT_MidLevel:	OffsetAdjustment += PawnRel_Mod_Lean_MidLevel * LeanBlendWeight * (1.f - BackToWallWeight);	break;
			}

			if( CT == CT_MidLevel )
			{
				OffsetAdjustment += PawnRel_Mod_360Aim_PopUp * BackToWallWeight;
			}
		}
		// additional offsets based on specific cover situation
		else if( WP.IsPoppingUp() )
		{
			OffsetAdjustment += PawnRel_Mod_PopUp_MidLevel;
		}
		else if( (CA == CA_BlindUp || CD == CD_Up) )
		{
			// blind up
			// not sure this check is necessary any more
			if( !WP.bDoing360Aiming )
			{
				OffsetAdjustment += PawnRel_Mod_MidLvlBlindUp;
			}
		}
		else if( CA == CA_LeanRight || CA == CA_LeanLeft || ((CD == CD_Right || CD == CD_Left) && (CA != CA_Default)) )
		{
			if (WP.bDoing360Aiming)
			{
				switch( CT )
				{
					case CT_Standing:	OffsetAdjustment += PawnRel_Mod_Lean_360Aim_Standing;	break;
					case CT_MidLevel:	OffsetAdjustment += PawnRel_Mod_Lean_360Aim_MidLevel;	break;
				}
			}
			else
			{
				// apply the lean direction offset
				switch( CT )
				{
					case CT_Standing:	OffsetAdjustment += PawnRel_Mod_Lean_Standing;	break;
					case CT_MidLevel:	OffsetAdjustment += PawnRel_Mod_Lean_MidLevel;	break;
				}
			}
		}
		else if ( (CT == CT_MidLevel) && (CA == CA_Default) && WP.bDoing360Aiming )
		{
			OffsetAdjustment += PawnRel_Mod_360Aim_PopUp;
		}

		// are we at cover edge?  if so, add additional offset
		Link = WP.CurrentLink;
		if (Link != None && (WP.CoverType != CT_Standing || WP.CoverAction != CA_PopUp))
		{
			if ( (WP.LeftSlotIdx == WP.RightSlotIdx) || Link.bCircular )
			{
				OffsetAdjustment += PawnRel_Mod_CoverEdge;
			}
			else
			{
				LinkDist = VSize(Link.GetSlotLocation(WP.LeftSlotIdx) - Link.GetSlotLocation(WP.RightSlotIdx));

				if (WP.CurrentSlotPct < 0.5f)
				{
					if(LinkDist > 0.01f)
					{
						DistanceToSlot = WP.CurrentSlotPct * LinkDist;
						Pct = 1.f - (DistanceToSlot / FMin(200.f, LinkDist));
					}
					else
					{
						if( WP.leftSlotIdx == WP.CurrentSlotIdx )
						{
							Pct = 1.0f;
						}
						else
						{
							Pct = 0.f;
						}
						
					}
					if ( (Pct > 0.f) && Link.Slots[WP.LeftSlotIdx].bLeanLeft && WP.bIsMirrored )
					{
						if ( (VSize(WP.Velocity) < 50.f) || Link.IsLeftEdgeSlot(WP.LeftSlotIdx, TRUE) )
						{
							// I'm at a left edge and looking out
							OffsetAdjustment += (PawnRel_Mod_CoverEdge * Pct * Pct);
						}

					}
				}
				else
				{
					if(LinkDist > 0.01f)
					{
						DistanceToSlot = (1.f - WP.CurrentSlotPct) * LinkDist;
						Pct = 1.f - (DistanceToSlot / FMin(200.f, LinkDist));
					}
					else
					{
						if( WP.RightSlotIdx == WP.CurrentSlotIdx )
						{
							Pct = 1.0f;
						}
						else
						{
							Pct = 0.f;
						}

					}
					if ( (Pct > 0.f) && Link.Slots[WP.RightSlotIdx].bLeanRight && !WP.bIsMirrored )
					{
						if ( (VSize(WP.Velocity) < 50.f) || Link.IsRightEdgeSlot(WP.RightSlotIdx, TRUE) )
						{
							// I'm at a right edge and looking out
							OffsetAdjustment += (PawnRel_Mod_CoverEdge * Pct * Pct);
						}
					}
				}
			}
		}

		//`log("pre"@`showvar(OffsetAdjustment)@`showvar(VSize(WP.Velocity))@`showvar(Link.IsLeftEdgeSlot(WP.IsLeftEdgeSlot, TRUE)));

		// if pawn is facing left, then mirror Y axis.
		OffsetAdjustment = AdjustOffsetForStance(WP, OffsetAdjustment);

		//`log("post"@`showvar(OffsetAdjustment)@`showvar(Pct));
	}

	Offset += OffsetAdjustment;

	// do super last
	return Super.AdjustViewOffset(P, Offset);
}

/**
 * When player mirrors in cover, camera offsets can change suddenly.
 * This smooths out that sudden change by interpolating to the new offset
 * before it kicks in, so when the mirror does happen, the camera is already where
 * it needs to be.
 */
simulated protected function vector AdjustOffsetForStance(GearPawn WP, const out vector Offset)
{
	local vector AdjustedOffset, CoverTangent, CamLoc;
	local rotator CamRot;
	local float CoverAng, Pct;

	AdjustedOffset = Offset;

	CoverTangent = WP.GetCoverNormal(TRUE) cross vect(0,0,1);

	if (WP.Controller != None)
	{
		WP.Controller.GetPlayerViewPoint(CamLoc, CamRot);
	}
	else
	{
		CamRot = WP.Rotation;
	}

	// get angle
	CoverAng = vector(CamRot) dot CoverTangent;
	CoverAng = ACos(CoverAng) * RadToDeg;

	if ( !WP.bIsMirrored && (CoverAng > 90.f) )
	{
		Pct = (CoverAng - 90.f) / (CoverAngLimit);
		Pct = FClamp(Pct, 0.f, 1.f);
		Pct *= Pct;
		AdjustedOffset.Y += AdjustedOffset.Y * Pct * -2.f;
	}
	else if ( WP.bIsMirrored && (CoverAng < 90.f) )
	{
		Pct = (CoverAng - 90.f) / (-CoverAngLimit);
		Pct = FClamp(Pct, 0.f, 1.f);
		Pct *= Pct;
		AdjustedOffset.Y += AdjustedOffset.Y * Pct * -2.f;
	}

	//`log("CoverAng"@CoverAng@"mirrored="@WP.bIsMirrored@"pct"@Pct@"Y"@AdjustedOffset.Y@CoverAngLimit);
	return AdjustedOffset;
}

/**
 * Handles clamping view rotation within limits for cover / leaning
 *
 * @param	DeltaTime		- change in time
 * @param	ViewTarget		- Actor camera is attached to
 * @param	ViewRotation	- Current view rotation
 * @param	out_DeltaRot	- Change in rotation to possibly be applied (in)
							- Change in rotation to continue (out)
 *
 * @return Rotator of new view rotation
 */
simulated function ProcessViewRotation
(
		float	DeltaTime,
		Actor	ViewTarget,
	out	Rotator out_ViewRotation,
	out Rotator out_DeltaRot
)
{
	local Rotator	MaxLimit, MinLimit;
	local GearPawn	ViewedPawn;
	local int		DeltaYaw, YawStep, MaxYawStep;
	local rotator	CoverRot;
	local GearPC PC;

	ViewedPawn = GearPawn(ViewTarget);

	if ( ViewedPawn != None && (ViewedPawn.CoverType != CT_None) && (ViewedPawn.CurrentLink != None) )
	{
		PC = GearPC(ViewedPawn.Controller);
		if (PC != None)
		{
			// smoothed cover normal here is niiiice
			CoverRot = rotator(ViewedPawn.GetCoverNormal(TRUE));

			if ( (PC.PlayerInput != None && PC.PlayerInput.aTurn != 0.f) || ViewedPawn.bDoing360Aiming )
			{
				// if player is controlling camera with stick, or in 360 aim, skip all of this!
				LastCoverYaw = CoverRot.Yaw;
				CoverNormalInterpYawAcc = 0;
			}
			else
			{
				DeltaYaw = NormalizeRotAxis(CoverRot.Yaw - LastCoverYaw);
				// Accumulate  DeltaYaw
				CoverNormalInterpYawAcc += DeltaYaw;

				if( CoverNormalInterpYawAcc != 0 )
				{
					MaxYawStep = FCeil(CoverNormalInterpSpeed * DeltaTime);
					YawStep = Clamp(CoverNormalInterpYawAcc, -MaxYawStep, MaxYawStep);
// 					`log(GetFuncName() @ `showvar(CoverNormalInterpYawAcc) @ `showvar(DeltaTime) @ `showvar(YawStep));
					CoverNormalInterpYawAcc -= YawStep;
					out_ViewRotation.Yaw += YawStep;

					// reset the view relative controls
					PC.ControlsRemapRotation = out_ViewRotation;
				}
			}

			// Retrieve upper/lower clamp limits based on cover state
			GetViewRotationLimits(ViewedPawn, MaxLimit, MinLimit);

			// Clamp Pitch
			if ( MinLimit.Pitch != 0 || MaxLimit.Pitch != 0 )
			{
				SClampRotAxis( DeltaTime, out_ViewRotation.Pitch-ViewTarget.Rotation.Pitch, out_DeltaRot.Pitch, MaxLimit.Pitch, MinLimit.Pitch, 4.f );
			}
		}
	}

	// save the last viewed pawn yaw
	if (ViewedPawn != None)
	{
		LastCoverYaw += DeltaYaw;
	}
}


/**
 * Returns View Rotation Clipping limits depending on GearPawn's cover state
 *
 * @output	out_MaxLimit	min view rotation limit
 * @output	out_MinLimit	min view rotation limit
 */
final simulated function GetViewRotationLimits
(
		GearPawn	ViewedPawn,
	out	Rotator	out_MaxLimit,
	out	Rotator	out_MinLimit
)
{
	if( ViewedPawn.CurrentLink != None && 
		ViewedPawn.CurrentLink.bCircular &&
		VSizeSq(ViewedPawn.Velocity) > 0.01 )
	{
		out_MaxLimit = ViewMaxLimit_Circular;
		out_MinLimit = ViewMinLimit_Circular;
	}
	else if( ViewedPawn.CoverAction == CA_LeanRight ||
			 ViewedPawn.CoverAction == CA_BlindRight )
	{
		out_MaxLimit = ViewMaxLimit_Lean;
		out_MinLimit = ViewMinLimit_Lean;
	}
	else if( ViewedPawn.CoverAction == CA_LeanLeft ||
			 ViewedPawn.CoverAction == CA_BlindLeft )
	{
		out_MaxLimit = ViewMinLimit_Lean;
		out_MinLimit = ViewMaxLimit_Lean;
		out_MaxLimit.Yaw = -out_MaxLimit.Yaw;
		out_MinLimit.Yaw = -out_MinLimit.Yaw;
	}
	else
	{
		out_MaxLimit = ViewMaxLimit;
		out_MinLimit = ViewMinLimit;
	}
}

function OnBecomeActive(Pawn CameraTarget, GameThirdPersonCameraMode PrevMode)
{
	local GearPawn GP;

	Super.OnBecomeActive(CameraTarget, PrevMode);

	GP = GearPawn(CameraTarget);
	if (GP != None)
	{
		LastCoverYaw = rotator(GP.GetCoverNormal(TRUE)).Yaw;
	}

	// limiting to grenade modes for now, but might work ok for any modes?
	if ( PrevMode.bInterpRotation && 
		( (GameplayCam_CoverTargetingGrenade(PrevMode) != None) || (GameplayCam_TargetingGrenade(PrevMode) != None) ) ) 
	{
		bTemporaryOriginRotInterp = TRUE;
	}
}


/**
 * Returns the "worst case" camera location for this camera mode.
 * This is the position that the camera ray is shot from, so it should be
 * a guaranteed safe place to put the camera.
 */
simulated function vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local bool bLow;
	local GearPawn WP;
	local vector WorstLocation,	Direction, TempLocation, Offset;
	local float Buffer;

	WP = GearPawn(TargetPawn);

	if( WP != None )
	{
		// Special path when targeting.
		// Make worst location safe inside the collision cylinder, and bring it close to the gun, aligned with camera.
		if( WP.bIsTargeting )
		{
			Direction = Vector(CurrentViewTarget.POV.Rotation);
			PointDistToLine(TargetPawn.Location, Direction, CurrentViewTarget.POV.Location, WorstLocation);

			// We've found the closest point from camera direction to cylinder center.
			// Now move that point back into safe cylinder zone.
			Buffer = 0.99f;
			WorstLocation.Z = FClamp(WorstLocation.Z, TargetPawn.Location.Z - TargetPawn.CylinderComponent.CollisionHeight * Buffer, TargetPawn.Location.Z + TargetPawn.CylinderComponent.CollisionHeight * Buffer);

			TempLocation = TargetPawn.Location;
			TempLocation.Z = WorstLocation.Z;

			WorstLocation = TempLocation + Normal(WorstLocation - TempLocation) * TargetPawn.CylinderComponent.CollisionRadius * Buffer;

			return WorstLocation;
		}
		else
		{
			bLow = (WP.CoverType == CT_MidLevel) && ( (WP.CoverAction != CA_PopUp) || WP.bDoing360Aiming );

			Offset = (bLow) ? WorstLocOffsetLow : WorstLocOffset;
			if (WP.bIsMirrored)
			{
				Offset.Y = -Offset.Y;
			}

			WorstLocation = WP.Location + (Offset >> WP.Rotation);

			return WorstLocation;
		}
	}
	else
	{
		// what is the target?  dunno, just let parent handle it
		return super.GetCameraWorstCaseLoc(TargetPawn, CurrentViewTarget);
	}
}

defaultproperties
{
	CoverNormalInterpSpeed=32768.f
	TemporaryOriginRotInterpSpeed=12.f

	OffsetAdjustmentInterpSpeed=8.f

	ViewMaxLimit=(Pitch=0,Yaw=13650,Roll=0)
	ViewMinLimit=(Pitch=0,Yaw=-13650,Roll=0)
	ViewMaxLimit_Lean=(Pitch=0,Yaw=16384,Roll=0)
	ViewMinLimit_Lean=(Pitch=0,Yaw=-4550,Roll=0)
	ViewMaxLimit_Circular=(Pitch=0,Yaw=2048,Roll=0)
	ViewMinLimit_Circular=(Pitch=0,Yaw=-2048,Roll=0)

	PawnRel_Posture_Standing=(X=0,Y=40,Z=0)
	PawnRel_Posture_MidLevel=(X=-32,Y=40,Z=-12)

	PawnRel_Mod_MidLvlBlindUp=(X=-16,Y=0,Z=20)

	PawnRel_Mod_PopUp_MidLevel=(X=0,Y=48,Z=32)
	PawnRel_Mod_360Aim_PopUp=(X=0,Y=48,Z=32)

	PawnRel_Mod_Lean_Standing=(X=0,Y=24,Z=0)
	PawnRel_Mod_Lean_MidLevel=(X=0,Y=20,Z=0)
	PawnRel_Mod_Lean_360Aim_Standing=(X=0,Y=0,Z=0)
	PawnRel_Mod_Lean_360Aim_MidLevel=(X=0,Y=0,Z=0)

	PawnRel_Mod_CoverEdge=(X=0,Y=84,Z=0)

	ViewOffset={(
		OffsetHigh=(X=-128,Y=0,Z=24),
		OffsetLow=(X=-160,Y=0,Z=32),
		OffsetMid=(X=-160,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-12),
		OffsetLow=(X=0,Y=0,Z=-12),
		OffsetMid=(X=0,Y=0,Z=-12),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=-20,Z=0),
		OffsetLow=(X=0,Y=-20,Z=0),
		OffsetMid=(X=0,Y=-20,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=0,Y=0,Z=25),
		OffsetLow=(X=0,Y=0,Z=25),
		OffsetMid=(X=0,Y=0,Z=25),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-10),
		OffsetLow=(X=0,Y=0,Z=-10),
		OffsetMid=(X=0,Y=0,Z=-10),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	PerPawnViewOffsetAdjustments.Empty
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(X=-15,Y=15,Z=-40)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustWretchBase',Offset=(X=30,Y=20,Z=0)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBoomerBase',Offset=(X=-20,Y=15,Z=-30)))

	BlendTime=0.15f

	FOVAngle_ViewportAdjustments(CVT_16to9_VertSplit)=20

	WorstLocOffset=(X=-8,Y=10,Z=90)
	WorstLocOffsetLow=(X=-10,Y=10,Z=45)

	CoverAngLimit=55.f
	OriginLocInterpSpeed=12.f
}

