/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoCombatEffectors extends Object
	config(AI);

/**
 * Chances and their amounts for the utility function.
 * Using these consts allows us to have a formal semantics about the relation of type A to type B
 * and makes it much easier to change
 **/
const DOIT_CHANCE = 100;
const LARGE_CHANCE = 50;
const MEDIUM_CHANCE = 25;
const SMALL_CHANCE = 10;
const NO_CHANCE = 0;
// negative utility modification
const SMALL_CHANCE_REDUCE = -10;
const MEDIUM_CHANCE_REDUCE = -25;


/** Need to be in this .uc otherwise we can't use .EnumCount :-\ **/
enum ENanoCombatEffectorType
{
	NCAT_None,
	NCAT_NoOneHasAttackedWithinLastFiveSeconds,
	NCAT_PlayedAttemptedToFlee,
	NCAT_PlayerArrivedWithinStrikingDistance,  // was not there in previous N seconds
	NCAT_PlayerDodged,
	NCAT_PlayerExecutedAJumpAttack,
	NCAT_PlayerHitAFoe,
	NCAT_PlayerHitMe,
	NCAT_PlayerKilledAFoe,
	NCAT_PlayerWasGrabbed,
	NCAT_PlayerWasHit,
	NCAT_AI_Evaded_With_DiveRoll,
	NCAT_PlayerJumpAndPinnedAI,
	NCAT_MAX
};

enum EResponseType
{
	ERT_None,
	ERT_Attack,
	ERT_Idle,
	// we prob want to add in defensive/cower
	// pull out taser?
	ERT_MAX
};


struct NanoCombatEffectorDatum
{
	/** The response to do when this Effector is triggered **/
	var() EResponseType Response;
	/** How we should modify the Utility **/
	var() int Utility;
};


struct NanoCombatEffectorList
{
	var() array<NanoCombatEffectorDatum> Effectors;
};


/** Set of active combat Effectors that **/
// NOTE:  might need an array of NanoCombatEffectorDatum at each eventID
var NanoCombatEffectorList CombatEffectors[ENanoCombatEffectorType.EnumCount];


simulated function LogOutPropertyData()
{
	local int i;
	local NanoCombatEffectorList ListElt;
	local NanoCombatEffectorDatum NCAD;

	`log( "CombatEffectors" );
	for( i = 0; i < NCAT_MAX; ++i )
	{
		ListElt = CombatEffectors[i];

		`log( "CombatEffectors" @ i );

		foreach ListElt.Effectors( NCAD )
		{
			`log( "  " $ `showvar(NCAD.Response) @ `showvar(NCAD.Utility) );
		}	
	}
}



defaultproperties
{
	CombatEffectors[NCAT_NoOneHasAttackedWithinLastFiveSeconds]=(Effectors=((Response=ERT_Attack, Utility=NO_CHANCE))) // not certain we need this as the AI is going to try and hit the player if they are doing something "bad"
	CombatEffectors[NCAT_PlayedAttemptedToFlee]=(Effectors=((Response=ERT_Attack, Utility=NO_CHANCE)))  // the AIPlanner will keep trying to have the AI follow / boids will do the same / if player manages to escape then this is not needed as they escaped
	CombatEffectors[NCAT_PlayerArrivedWithinStrikingDistance]=(Effectors=((Response=ERT_Attack, Utility=NO_CHANCE))) // I think this will be taken care of by the octree grabbing of the AIPlanner



	CombatEffectors[NCAT_PlayerDodged]=(Effectors=((Response=ERT_Attack, Utility=MEDIUM_CHANCE)))
	CombatEffectors[NCAT_PlayerExecutedAJumpAttack]=(Effectors=((Response=ERT_Attack, Utility=LARGE_CHANCE)))
	CombatEffectors[NCAT_PlayerHitAFoe]=(Effectors=((Response=ERT_Attack, Utility=SMALL_CHANCE)))
	CombatEffectors[NCAT_PlayerHitMe]=(Effectors=((Response=ERT_Attack, Utility=MEDIUM_CHANCE)))
	CombatEffectors[NCAT_PlayerKilledAFoe]=(Effectors=((Response=ERT_Attack, Utility=LARGE_CHANCE)))
	CombatEffectors[NCAT_PlayerWasGrabbed]=(Effectors=((Response=ERT_Attack, Utility=DOIT_CHANCE)))

	CombatEffectors[NCAT_PlayerWasHit]=(Effectors=((Response=ERT_Attack, Utility=SMALL_CHANCE),(Response=ERT_Idle, Utility=MEDIUM_CHANCE))) // don't attack for a short time (is this a lock out?)

	CombatEffectors[NCAT_AI_Evaded_With_DiveRoll]=(Effectors=((Response=ERT_Attack, Utility=DOIT_CHANCE)))

	CombatEffectors[NCAT_PlayerJumpAndPinnedAI]=(Effectors=((Response=ERT_Attack, Utility=LARGE_CHANCE)))

}