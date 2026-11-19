/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_MeleeBase extends NanoAICmd within NanoAI_Trooper
	config(AI)
	abstract;

var transient TargetableOctreeComponent CurrTargetable;


function Pushed()
{ 
	Super.Pushed();

	BoidMeleeRangePercent = FRand() * 0.9;
	//`log( "Setting:" @ Outer @ `showvar(BoidMeleeRangePercent) );
	SetUseBoidMovement( TRUE );
	
	// so if the player is not trying to run away
	if( NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Combat' ) == TRUE )
	{
		NanoPawnBase(Outer.Pawn).GroundSpeed = NanoPawnBase(Outer.Pawn).NanoMeleeEngagedGroundspeed;
	}

	//`log( "AHHH ground speed" @ NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping' ) @ `showvar(NanoPawnBase(Outer.Pawn).GroundSpeed) );
	
}


function Popped()
{ 
	Super.Popped();
	ClearTimer( nameof(DoWaitingToAttackSpecialMove), self );
	ClearTimer( nameof(ShoutOutATaunt), self );
	
	NanoPawnBase(Outer.Pawn).GroundSpeed = NanoPawnBase(Outer.Pawn).NanoPursueGroundspeed;
}


/** This will shout out a taunt! **/
function ShoutOutATaunt();


defaultproperties
{

}


