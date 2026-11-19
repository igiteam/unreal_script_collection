/**
 * This is just a Faux SpecialMove which allows us to display ActionInfos on the HUD
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_EvadeFromCoverBase extends GearSpecialMove
	DependsOn(GearPawn);

var() float SideCheckDist;

/**
 * Checks to see if there is world geo in the path of an evade to the side of cover,
 * used to not display the HUD icon for evade when there is something in the way
 * @param bLeft - are we evading left?
 * @return TRUE if the evade is clear
 */
protected function bool EvadeClear(bool bLeft)
{
	local vector CoverDir,SlotSideDir;
	local actor HitActor;
	local vector HitLocation, HitNormal, Start, End, Extent;

	CoverDir = Vector(PawnOwner.CurrentLink.GetSlotRotation(PawnOwner.CurrentSlotIdx));

	SlotSideDir = Normal(CoverDir cross vect(0,0,1));
	if( !bLeft )
	{
		SlotSideDir *= -1.0;
	}


	Extent = PawnOWner.GetCollisionExtent();
	Extent.Z *= 0.5;
	Extent *= 0.75;

	Start = PawnOwner.Location;
	End = Start + SlotSideDir * SideCheckDist;
	HitActor = PawnOwner.Trace( HitLocation, HitNormal, End,Start, false, Extent );

	if( HitActor != none )
	{
		return false;
	}

	return true;

}

protected function bool CanEvadeFromCover(ECoverType InCoverType)
{
	local GearPC	PC;
	local bool bWantsLeft;

	// only allowed from in cover
	if( (PawnOwner.CoverType == CT_None) || (PawnOwner.CurrentLink == None) )
	{
		return false;
	}
	PC = GearPC(PawnOwner.Controller);

	// If this is a player
	if( PC != None )
	{
		if (!PawnOwner.IsOnACoverSlot() || PawnOwner.PickClosestCoverSlot(true) == -1)
		{
			return false;
		}

		// Make sure they are close enough to the edge to do a slip and allowed to slip in that direction
		if( (PawnOwner.bIsMirrored && (PawnOwner.CurrentSlotIdx != 0 || !PawnOwner.IsAtLeftEdgeSlot() || PC.RemappedJoyRight > -PC.DeadZoneThreshold)) ||
			(!PawnOwner.bIsMirrored && (PawnOwner.CurrentSlotIdx != PawnOwner.CurrentLink.Slots.length - 1 || !PawnOwner.IsAtRightEdgeSlot() || PC.RemappedJoyRight < PC.DeadZoneThreshold)) )
		{
			return false;
		}

		bWantsLeft = PC.RemappedJoyRight <= -PC.DeadZoneThreshold;

		if ( ! EvadeClear(bWantsLeft) )
		{
			return false;
		}
	}
	else
	{
		// Otherwise, for AI, make sure this is an actual edge slot
		if( ( PawnOwner.bIsMirrored && ( !PawnOwner.CurrentLink.IsLeftEdgeSlot(PawnOwner.CurrentSlotIdx, TRUE))) ||
			(!PawnOwner.bIsMirrored && ( !PawnOwner.CurrentLink.IsRightEdgeSlot(PawnOwner.CurrentSlotIdx, TRUE))) )
		{
			//`log( "FALSE 2" );
			return false;
		}
	}

	// make sure the player is pressing sideways
	if( PC != None && PC.IsLocalPlayerController() )
	{
		if( PawnOwner.CoverType == InCoverType )
		{
			// must be pushing sideways
			if( Abs(PC.RemappedJoyUp) > Abs(PC.RemappedJoyRight) ||
				Abs(PC.RemappedJoyRight) < 0.3 )
			{
				//`log( "FALSE 3" );
				return false;
			}
		}
		else
		{
			//`log( "FALSE 4" );
			// should never hit this
			return false;
		}
	}

	// don't allow if carrying a heavy weapon
	if( PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		return false;
	}

	//`log( "TRUE 0" );
	return true;
}



defaultproperties
{
	//Standing evade 340,289 172x52
	Action={(
			 ActionName=EvadeFromCover,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=0,V=127,UL=210,VL=107)))	),
			)}

	SideCheckDist=100
}
