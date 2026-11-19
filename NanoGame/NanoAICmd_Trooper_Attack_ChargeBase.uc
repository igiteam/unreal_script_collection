/**
 * AI Command that handles all of the shared "charge" attack code
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Attack_ChargeBase extends NanoAICmd within NanoAI_Trooper
	abstract
	config(AI);

/**
 * The AI needs to be this close to its FireTarget before it will attempt a charge attack.  Otherwise you get 
 * the AI randomly charging across the map which is going to fail as it does boids movement.
 **/
var config float MinDistToDoChargeAttack;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;
	local NanoAIBlackboard BB;

	BB = InAI.GetBlackBoard();
	if( ( InAI.FireTarget != None )
		&& ( VSize(InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location ) < default.MinDistToDoChargeAttack )
		&& ( `TimeSinceEx( InAI, BB.LastChargeAttackTime) > BB.DurationBetweenChargeAttacks )
		&& ( InAI.NavigationHandle.ObstacleLineCheck( InAI.Pawn.Location, InAI.FireTarget.GetTargetedLocation(), vect(0,0,0) ) == FALSE ) // we probably have moved around some so we need to check to make certain we have a clear path to run at the player
		)
	{
		Rating = Rand(50);
	}
	
	return Rating;
}

function Pushed()
{
	Super.Pushed();

	GetBlackBoard().LastChargeAttackTime = WorldInfo.TimeSeconds;

	SetConfrontationType( ECFT_Melee_Attacking ); // so this charge attack makes you get up close

	PossiblyPickFireTarget();

	RegisterAsActiveAttacker();

	Focus = FireTarget; // our focus for a melee target should always be our FireTarget

	Pawn.GroundSpeed *= 3.0f; 

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).ActivateGlow();
		NanoWeap_Baton(Pawn.Weapon).TargetLightBrightness = 50;
	}

	NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_ChargeAttack, Pawn );
}


function Popped()
{ 
	Super.Popped();

	Pawn.GroundSpeed = Pawn.default.GroundSpeed;

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).KillGlow();
		NanoWeap_Baton(Pawn.Weapon).TargetLightBrightness = 0;
	}

	ModifyActiveBoidMovement_AvoidTeammates( TRUE );
}





defaultproperties
{

}