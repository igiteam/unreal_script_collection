
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_SuperCurbstomp extends GSM_BasePlaySingleAnim;

var BodyStance BS_LoaderCarryingStomp;

function PlayAnimation()
{
	local GearPawnRidable_Base	RidablePawn;
	local GearPawn_SilverbackLoaderBase	Loader;

	Loader = GearPawn_SilverbackLoaderBase(PawnOwner);
	if( Loader != None && Loader.PickedUpCrate != None )
	{
		BS_Animation = BS_LoaderCarryingStomp;
	}
	else
	{
		BS_Animation = default.BS_Animation;
	}

	Super.PlayAnimation();

	// Play animation on Driver as well.
	RidablePawn = GearPawnRidable_Base(PawnOwner);
	if( RidablePawn != None && RidablePawn.Driver != None )
	{
		RidablePawn.Driver.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);
	}
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="SB_Stomp")))
	BS_LoaderCarryingStomp=(Stance=((Slot=BS_FullBody,AnimName="Loader_Stomp")))
	BlendOutTime=0.33f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
