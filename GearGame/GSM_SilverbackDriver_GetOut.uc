
/**
 * SpecialMove played by the Silverback Driver when getting out. 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SilverbackDriver_GetOut extends GSM_BasePlaySingleAnim;

/** Reference to our Silverback Vehicle */
var GearPawn_SilverbackBase Silverback;
/** Animation to use when Armed Silverback is deployed */
var const BodyStance BS_AnimationDeployed;
/** Loader carrying a crate variation */
var const BodyStance BS_AnimationPayload;

/** @return FALSE if there's not enough room for the player to exit */
protected function bool InternalCanDoSpecialMove()
{
	local vector DesiredExit, Extent, HitLocation, HitNormal, ZOffset;
	local rotator PawnRotation;
	local GearPawn_SilverbackArmedBase ArmedSilverback;

	Extent = PawnOwner.GetCollisionRadius() * vect(1,1,0);
	Extent.Z = PawnOwner.GetCollisionHeight();

	ZOffset = PawnOwner.CylinderComponent.default.CollisionHeight * vect(0,0,1);
	
	PawnRotation = PawnOwner.Rotation;
	PawnRotation.Pitch = 0;

	ArmedSilverback = GearPawn_SilverbackArmedBase(Silverback);
	if (ArmedSilverback != None && ArmedSilverback.bAnimIsDeployed)
	{
		DesiredExit = vect(-100,0,30);
	}
	else
	{
		DesiredExit = vect(-100,0,20);
	}
	
	DesiredExit = PawnOwner.Location + ((DesiredExit - ZOffset) >> PawnRotation) + ZOffset;
	
	//PawnOwner.DrawDebugLine(DesiredExit, PawnOwner.Location + ZOffset, 255, 255, 255, TRUE);
	//PawnOwner.DrawDebugSphere(DesiredExit, 10, 10, 255, 0, 0, TRUE);
	//PawnOwner.DrawDebugSphere(PawnOwner.Location + ZOffset, 10, 10, 0, 255, 0, TRUE);

	//`log(DesiredExit);

	if (PawnOwner.Trace(HitLocation, HitNormal, DesiredExit, PawnOwner.Location + ZOffset, false, Extent) != None)
	{
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Silverback = GearPawn_SilverbackBase(PawnOwner.InteractionPawn);

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function PlayAnimation()
{
	local GearPawn_SilverbackArmedBase ArmedSilverback;
	local GearPawn_SilverbackLoaderBase Loader;

	// Keep default animation for driver
	BS_Animation = default.BS_Animation;

	Super.PlayAnimation();

		// If Armed Silverback is deployed, then play special animation for it.
	ArmedSilverback = GearPawn_SilverbackArmedBase(Silverback);
	if( ArmedSilverback != None && ArmedSilverback.bAnimIsDeployed )
	{
		BS_Animation = BS_AnimationDeployed;
	}
	else
	{
		Loader = GearPawn_SilverbackLoaderBase(Silverback);
		if( Loader != None && Loader.PickedUpCrate != None )
		{
			BS_Animation = BS_AnimationPayload;
		}
	}

	// Offset by root motion :( Animation would need to be fixed up to not have to deal with that, but oh well..
	PawnOwner.Mesh.SetTranslation(Silverback.RootBoneSeatDelta);

	// Play same animation on Silverback
	Silverback.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	EndThisSpecialMove();
}

function EndThisSpecialMove()
{
	// now force driver to leave...
	if( Silverback.WorldInfo.NetMode != NM_Client )
	{
		Silverback.DriverLeave(TRUE);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
// 	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName());

	// Clear Translation offset - at that point PawnOwner has to be detached from seat!!
	PawnOwner.Mesh.SetTranslation(vect(0,0,0));

	// Blend out from animation
	PawnOwner.BS_Stop(BS_Animation, 0.f);	

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="SB_GetOut")))
	BS_AnimationDeployed=(Stance=((Slot=BS_FullBody,AnimName="SB_GetOut_Deployed")))
	BS_AnimationPayload=(Stance=((Slot=BS_FullBody,AnimName="Loader_GetOut_Payload")))
	BlendInTime=0.f
	BlendOutTime=-1.f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}