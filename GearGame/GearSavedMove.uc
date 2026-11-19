/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class GearSavedMove extends SavedMove;

var ECoverType CoverType;
var ECoverAction CoverAction;
var ECoverDirection CoverDirection;
var bool bWantsToBeMirrored;
var ECoverDirection CurrentSlotDirection;
var bool bIsInStationaryCover;

var bool bCoverTransition;
/** information about the cover we have claimed at the time of this move */
var CoverLink Link;
var byte SlotIdx;
var byte LeftIdx;
var byte RightIdx;
var float SlotPct;

function Clear()
{
	Super.Clear();
	CoverType = CT_None;
	CoverAction = CA_Default;
	CoverDirection = CD_Default;
	bWantsToBeMirrored = false;
	CurrentSlotDirection = CD_Default;
	bIsInStationaryCover = false;
	Link = None;
	SlotIdx = default.SlotIdx;
	LeftIdx = default.LeftIdx;
	RightIdx = default.RightIdx;
	SlotPct = 0.0;
	bCoverTransition = false;
}

/** clears only the cover related information */
final function ClearCover()
{
	CoverType = CT_None;
	CoverAction = CA_Default;
	CoverDirection = CD_Default;
	CurrentSlotDirection = CD_Default;
	bIsInStationaryCover = false;
	Link = None;
	SlotIdx = default.SlotIdx;
	LeftIdx = default.LeftIdx;
	RightIdx = default.RightIdx;
	SlotPct = 0.0;
	bCoverTransition = false;
}

function SetMoveFor(PlayerController P, float DeltaTime, vector NewAccel, EDoubleClickDir InDoubleClick)
{
	local GearPawn WP;
	Super.SetMoveFor(P,DeltaTime,NewAccel,InDoubleClick);
	// save the cover settings
	WP = GearPawn(P.Pawn);
	if (WP != None)
	{
		CoverType = WP.CoverType;
		CoverAction = WP.CoverAction;
		CurrentSlotDirection = WP.CurrentSlotDirection;
		bWantsToBeMirrored = WP.bWantsToBeMirrored;
		bIsInStationaryCover = WP.bIsInStationaryCover;
		Link = WP.CurrentLink;
		SlotIdx = WP.CurrentSlotIdx;
		LeftIdx = WP.LeftSlotIdx;
		RightIdx = WP.RightSlotIdx;
		SlotPct = WP.CurrentSlotPct;
		bCoverTransition = GearPC(P).bSendCoverTransition;
		// if we're entering cover use the Run2Cover direction so that the mirroring matches
		CoverDirection = (bCoverTransition && CoverType != CT_None) ? WP.FindBestCoverSideFor(WP.AcquiredCoverInfo) : WP.CoverDirection;
		GearPC(P).bSendCoverTransition = false;
	}
}

function bool CanCombineWith(SavedMove NewMove, Pawn InPawn, float MaxDelta)
{
	local GearSavedMove NewGearMove;
	local InterpActor_GearBasePlatform Platform;
	local GearPawn GP;

	//@hack: disallow movement combining when clamped to a base that prevents all movement
	if (InPawn != None)
	{
		Platform = InterpActor_GearBasePlatform(InPawn.Base);
		if (Platform != None && Platform.bDisallowPawnMovement)
		{
			return false;
		}
	}

	NewGearMove = GearSavedMove(NewMove);
	GP = GearPawn(InPawn);
	return (CoverType == CT_None &&			//@fixme - disable combining of cover moves for now
			CoverType == NewGearMove.CoverType &&
			CoverAction == NewGearMove.CoverAction &&
			CoverDirection == NewGearMove.CoverDirection &&
			bWantsToBeMirrored == NewGearMove.bWantsToBeMirrored &&
			CurrentSlotDirection == NewGearMove.CurrentSlotDirection &&
			bIsInStationaryCover == NewGearMove.bIsInStationaryCover &&
			(GP == None || GP.SpecialMove == SM_None || !GP.SpecialMoves[GP.SpecialMove].bUseUnsynchedServerMove) &&
			Super.CanCombineWith(NewMove,InPawn,MaxDelta));
}

defaultproperties
{
	SlotIdx=255
	LeftIdx=255
	RightIdx=255
}
