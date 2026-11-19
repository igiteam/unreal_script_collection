/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_RoadieRunStadium extends GSM_RoadieRun
	native(SpecialMoves);

/** The pawn for Cole that is doing the charge move */
var GearPawn_COGGusStadiumBase ColePawn;

var Name RoadieRunAnim;
var Name OrigRoadieRunAnim;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	ColePawn = GearPawn_COGGusStadiumBase(PawnOwner);
	ColePawn.bJustStartedSpecialMove = TRUE;
	
	OrigRoadieRunAnim = ColePawn.RoadieRunAdditiveNode.AnimSeqName;
	if( ColePawn.bThashballHidden )
	{
		ColePawn.RoadieRunAdditiveNode.SetAnim( RoadieRunAnim );
	}

	ColePawn.MyGearWeapon.HolsterWeaponTemporarily(TRUE);
	ColePawn.MyGearWeapon.StopHolsterAnims();

   	Super.SpecialMoveStarted(bForced,PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	ColePawn.RoadieRunAdditiveNode.SetAnim( OrigRoadieRunAnim );
}

/** Overridden to destroy GDOs that are in the way */
function NotifyBump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	if( Other.Role == ROLE_Authority && ( Other.IsA('GearPawn') || Other.IsA('GearDestructibleObject') ) )
	{
		Other.TakeDamage(5000, PawnOwner.Controller, PawnOwner.Location, Normal(Other.Location - PawnOwner.Location), class'GDT_RoadieRunStadium',, PawnOwner);
	}
}

/** Force Cole to run forward, and only allow the player to offset him a bit from the matinee path */
simulated function PreProcessInput(GearPlayerInput Input)
{
	// Force running forwards, and prevent turning
	Input.aBaseY = 1.f;
	Input.aTurn = 0.f;

	// Save off last aStrafe input for Tick()
	ColePawn.LastStrafe = Input.aStrafe;
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableSteering=true
	bNoStoppingPower=true
	bDisallowReverseTransitions=true
	bIgnoreCameraTurn=TRUE
	bCanSwitchWeapons=FALSE
	bDeferWeaponSwitch=FALSE

	RoadieRunAnim=ADD_Thrashball_RoadieRun_Fwd
}
