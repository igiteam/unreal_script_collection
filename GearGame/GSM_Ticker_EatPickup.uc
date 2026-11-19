
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_Ticker_EatPickup extends GearSpecialMove;

/** Eating animation */
var()	GearPawn.BodyStance	BS_Loop;

/** Actor to pickup */
var Actor		PickupActor;

protected function bool InternalCanDoSpecialMove()
{
	return ( PawnOwner.Physics != PHYS_RigidBody );
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	AlignToActor = PickupActor;

	Super.SpecialMoveStarted(bForced,PrevMove);

	DisableGrenade();

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Loop, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, TRUE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Loop, TRUE);

	PawnOwner.SetTimer(0.5f, FALSE, 'DoPickUp', Self);
	PawnOwner.SetTimer(1.0f, FALSE, 'EndSpecialMove');
}

function DisableGrenade()
{
	local GearProj_Grenade Grenade;

	Grenade = GearProj_Grenade(PickupActor);
	if( Grenade != None )
	{
		// Stop the explosion
		Grenade.ClearTimer(nameof(Grenade.ArmGrenade));
		Grenade.ClearTimer(nameof(Grenade.DoExplosion));
		Grenade.ClearTimer(nameof(Grenade.WarnProjExplode));
		Grenade.ClearTimer(nameof(Grenade.PlayBeepSound));
	}
}

function DoPickUp()
{
	if( GearDroppedPickup(PickupActor) != None  || 
		GearProj_Grenade(PickupActor) != None   || 
		GearWeaponPickupFactory(PickupActor) != None )
	{
		PawnOwner.GrabPickup(PickupActor);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	PawnOwner.BS_Stop(BS_Loop, 0.2f/SpeedModifier);
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="scavenging_loop")))
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}