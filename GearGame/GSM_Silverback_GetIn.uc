
/**
 * SpecialMove played by the Silverback when driver gets in. 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_GetIn extends GSM_BasePlaySingleAnim;

/** Reference to our Silverback Vehicle */
var GearPawn_SilverbackBase Silverback;
/** AnimPlayTime */
var transient INT YawInterpSpeed;
/** Animation to play when deployed */
var const BodyStance BS_AnimationDeployed;
/** Loader carrying a crate variation */
var const BodyStance BS_AnimationPayload;

/** No need to replicate this move, as it's called from DoDriverAttachment that is already called on all netmodes */
function bool ShouldReplicate()
{
	return FALSE;
}

/**
 * On server only, possibly save chained move
 * @Return TRUE if move could be chained to this one
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	// Clients need to be able to chain into CoverExit to fix out of sync issues
	if (PawnOwner.Role != ROLE_Authority && NextMove == GSM_Silverback_CoverExit)
	{
		return TRUE;
	}

	return (NextMove == GSM_Silverback_CoverDeploy);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Silverback = GearPawn_SilverbackBase(PawnOwner);
// 	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName());

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function PlayAnimation()
{
	local GearPawn_SilverbackArmedBase ArmedSilverback;
	local GearPawn_SilverbackLoaderBase Loader;
	local INT DeltaYaw;
	local float PlayTime;

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
		else
		{
			BS_Animation = default.BS_Animation;
		}
	}

	Super.PlayAnimation();

	// Keep default animation for driver.
	BS_Animation = default.BS_Animation;

	// Offset by root motion :( Animation would need to be fixed up to not have to deal with that, but oh well..
	Silverback.Driver.Mesh.SetTranslation(Silverback.RootBoneSeatDelta);

	// Play same animation on Driver
	PlayTime = Silverback.Driver.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);

	// Calculate how fast to do controller rotation (camera) interpolation.
	if (PawnOwner.Controller != None)
	{
		DeltaYaw = NormalizeRotAxis(PawnOwner.Rotation.Yaw - PawnOwner.Controller.Rotation.Yaw);
		YawInterpSpeed = INT(float(DeltaYaw) / PlayTime) + 1;
	}
}

function Tick(float DeltaTime)
{
	local Rotator Rot;

	Super.Tick(DeltaTime);

	// Interpolate driver rotation to match Silverback.
	if( PawnOwner.Controller != None )
	{
		Rot = RInterpTo(Normalize(PawnOwner.Controller.Rotation), Normalize(PawnOwner.Rotation), DeltaTime, float(YawInterpSpeed), TRUE);
		Rot.Pitch = PawnOwner.Controller.Rotation.Pitch;
		PawnOwner.Controller.SetRotation(Rot);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_SilverbackArmedBase ArmedSilverback;

// 	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName());

	// Blend out from animation
	PawnOwner.BS_Stop(BS_Animation, 0.3f);	
	PawnOwner.BS_Stop(BS_AnimationDeployed, 0.3f);
	PawnOwner.BS_Stop(BS_AnimationPayload, 0.3f);

	Silverback.KeepDriverAnimationsInSync();

	if( Silverback.Driver != None )
	{
		// Discard Root Translation
		Silverback.Driver.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
		// Stop animation w/ blend out
		Silverback.Driver.BS_Stop(BS_Animation, 0.3f);	
		// Clear Translation offset - at that point PawnOwner has to be detached from seat!!
		Silverback.Driver.Mesh.SetTranslation(vect(0,0,0));
		// Force update mesh in case it's been rendered already, since we changed the root bone axis and mesh translation, we want everything update this frame.
		Silverback.Driver.Mesh.ForceUpdate(FALSE);
		
		// Activate IK for Driver Hands
		Silverback.DriverRightHandIK.SetSkelControlActive(TRUE);
		Silverback.DriverLeftHandIK.SetSkelControlActive(TRUE);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);


	// If Armed Silverback is deployed, then transition to the deployed special move right away
	ArmedSilverback = GearPawn_SilverbackArmedBase(Silverback);
	if( ArmedSilverback != None)
	{
		if (ArmedSilverback.bNetIsDeployed)
		{
			ArmedSilverback.DoSpecialMove(GSM_Silverback_CoverDeploy, TRUE);
		}
		// We're out of sync with the server's state, just fix it
		else if (ArmedSilverback.bAnimIsDeployed)
		{
			ArmedSilverback.DoSpecialMove(GSM_Silverback_CoverExit, TRUE);
		}

		// Trigger the silverback delegate
		if (ArmedSilverback.bNetIsDeployed)
		{
			PCOwner.TriggerGearEventDelegates(eGED_SilverbackDeployed);
		}
		else
		{
			PCOwner.TriggerGearEventDelegates(eGED_Silverback);
		}
	}
	else
	{
		// Trigger the silverback loader delegate
		PCOwner.TriggerGearEventDelegates(eGED_SilverbackLoader);
	}
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="SB_GetIn")))
	BS_AnimationDeployed=(Stance=((Slot=BS_FullBody,AnimName="SB_GetIn_Deployed")))
	BS_AnimationPayload=(Stance=((Slot=BS_FullBody,AnimName="Loader_GetIn_Payload")))
	BlendInTime=0.f
	BlendOutTime=-1.f

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
