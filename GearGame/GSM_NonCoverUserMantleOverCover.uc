/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_NonCoverUserMantleOverCover extends GSM_MantleOverCoverBase
	native(SpecialMoves);

/** Mantle Cover **/
var transient CovPosInfo MantleCover;

/** This is a mantle base class for any pawns that don't actually use cover, but still need to mantle */

native function bool HasMantleEdge();

simulated function vector GetCoverNormal()
{
	local Vector X, Y, Z;

	if (MantleCover.Link != None)
	{
		// look for a set of bounding slots
		if( MantleCover.Link.Slots.Length > 1 )
		{
			// use the axis based on the slot locations
			Z = vect(0,0,1);
			Y = Normal(MantleCover.Link.GetSlotLocation(MantleCover.RtSlotIdx) - MantleCover.Link.GetSlotLocation(MantleCover.LtSlotIdx));
			X = Normal(Y cross Z);
		}
		else
		{
			// otherwise default to our currently assigned slot's rotation
			X = vector(MantleCover.Link.GetSlotRotation(0));
		}
	}

	return -X;
}

function bool VerifyLandingClear(vector InMantleStartLoc, vector InMantleEndLoc)
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal, Extent;
	local actor HitActor;

	StartTrace = InMantleStartLoc;
	StartTrace.Z += PawnOwner.GetCollisionHeight();

	EndTrace = InMantleEndLoc;
	EndTrace.Z += PawnOwner.GetCollisionHeight();

	Extent = PawnOwner.GetCollisionExtent() * vect(1.f,1.f,0.25f);
	foreach PawnOwner.TraceActors(class'Actor',HitActor,HitLocation,HitNormal,EndTrace,StartTrace,Extent,,PawnOwner.TRACEFLAG_Blocking)
	{
		// if we hit something blocking that wont' move away for us, bail
		if(!HandleHitActor(HitActor,GearAI(PawnOwner.Controller) != None,HitLocation))
		{
			//PawnOwner.DrawDebugBox(HitLocation,Extent,255,0,128,TRUE);
			//PawnOwner.DrawDebugLine(StartTrace,EndTrace,255,0,0,TRUE);
			return false;			
		}
	}

	return super.VerifyLandingClear(InMantleStartLoc,InMantleEndLoc);
}

protected function bool InternalCanDoSpecialMove()
{
	local Pawn Obstruction;
	local bool bResult;

	if (PawnOwner.SpecialMove == SM_MidLvlJumpOver )
	{
		return FALSE;
	}

	if (PawnOwner.IsHumanControlled())
	{
		if ( PawnOwner.FindCoverFromLocAndDir(PawnOwner.Location, vector(PawnOwner.Rotation), 0.1, 100.0, MantleCover, Obstruction) &&
			Obstruction == None )
		{
			// pretend we're in cover so we can do the usual mantle checks
			PawnOwner.CurrentLink = MantleCover.Link;
			PawnOwner.LeftSlotIdx = MantleCover.LtSlotIdx;
			PawnOwner.RightSlotIdx = MantleCover.RtSlotIdx;
			bResult = Super.InternalCanDoSpecialMove();
			PawnOwner.CurrentLink = None;
			PawnOwner.LeftSlotIdx = INDEX_NONE;
			PawnOwner.RightSlotIdx = INDEX_NONE;
			return bResult;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return (HasMantleEdge() && FindMantleDistance());
	}
}

protected function bool HandleHitActor(Actor HitActor, bool bIsAI, vector HitLocation, optional vector StartDownTrace, out optional INT bHitSomethingHoriz)
{
	return Super.HandleHitActor(HitActor,TRUE,HitLocation,StartDownTrace,bHitSomethingHoriz);
}


simulated function bool SetCoverData()
{
	return (!PawnOwner.IsHumanControlled() || Super.SetCoverData());
}

simulated function GetMantleInformation(out BasedPosition InMantleStartLoc, out BasedPosition InMantleEndLoc, out float InMantleDistance)
{
	local vector MantleDir;
	local AICmd_Move_Mantle MantleCmd;

	if (PawnOwner.IsHumanControlled())
	{
		Super.GetMantleInformation(InMantleStartLoc, InMantleEndLoc, InMantleDistance);
	}
	else
	{
		MantleCmd = AICmd_Move_Mantle(GearAI(PawnOwner.Controller).GetActiveCommand());
		if (MantleCmd != None)
		{
			MantleDir = MantleCmd.MantleDest - PawnOwner.Location;
			MantleDir.Z = 0.f;
			InMantleDistance = Min(VSize2D(MantleDir), class'GearScout'.default.MaxMantleLateralDist);

			MantleDir = Normal(MantleDir);

			Vect2BP(InMantleStartLoc, PawnOwner.Location);
			Vect2BP(InMantleEndLoc, PawnOwner.Location + MantleDir * InMantleDistance);
		}
	}
}

defaultproperties
{
	bBreakFromCoverOnEnd=false
	bUseUnsynchedServerMove=true
	bLockPawnRotation=TRUE
	bOverrideCameraOrigin=false
}
