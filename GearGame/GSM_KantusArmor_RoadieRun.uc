/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_KantusArmor_RoadieRun extends GSM_RoadieRun;

/**
 * Transition right into roll attack if we run into an enemy
 * 
 * @param Other - the actor that bumped us
 * 
 * @param OtherComp - the component that bumped us
 * 
 * @param HitNormal - the direction of the collision
 */
function NotifyBump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	local GearPawn GP;

	GP = GearPawn(Other);

  	if (PawnOwner.Role == ROLE_Authority && GP != None && !GP.bPlayedDeath && !PawnOwner.IsSameTeam(GP))
	{
		PawnOwner.ServerDoSpecialMove(GSM_KantusArmor_RollAttack, TRUE);
	}
}
