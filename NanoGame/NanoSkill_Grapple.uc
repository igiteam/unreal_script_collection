/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSkill_Grapple extends NanoSkill
	native(Pawn)
	config(Pawn);

simulated protected function InternalActivated()
{
	local NanoPC PC;

	PC = NanoPC(PawnOwner.Controller);
	PawnOwner.DoSpecialMove( 'NSM_Grapple', TRUE, None, PC.GrappleTarget );
}

simulated protected function InternalDeactivated()
{
	PawnOwner.EndSpecialMove( 'NSM_Grapple' );
	PawnOwner.EndSpecialMove( 'NSM_WireSlide' );
}

simulated function Tick(float DeltaTime)
{
	local bool bWantsToGrapple;

	Super.Tick(DeltaTime);

	if( PawnOwner.Health <= 0 )
	{
		return;
	}

	bWantsToGrapple = WantsToGrapple();
	if( bWantsToGrapple && !bActive )
	{
		PawnOwner.ActivateSkill( class'NanoSkill_Grapple' );
	}
	else if( !bWantsToGrapple && bActive )
	{
		PawnOwner.DeactivateSkill( class'NanoSkill_Grapple' );
	}
}

simulated function bool WantsToGrapple()
{
	local NanoPC PC;

	PC = NanoPC(PawnOwner.Controller);
	if( PC != None && PawnOwner.bWantsToDash )
	{
		if( PawnOwner.bEndingSpecialMove || 
			PawnOwner.ActiveSpecialMoveName == 'NSM_Grapple' || 
			PawnOwner.ActiveSpecialMoveName == 'NSM_WireSlide' ||
			(PC.GrappleTarget != None && PawnOwner.CanDoSpecialMove( 'NSM_Grapple' )) )
		{
			return TRUE;
		}
	}

	return FALSE;
}

	
defaultproperties
{
	bSkipReplication=TRUE
	SkillType=NS_Grapple


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)
	bHideFromSkillUI=FALSE
}