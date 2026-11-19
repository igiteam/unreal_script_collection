/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_MomCorpser_Stab extends AICommand_SpecialMove
	within GearAI_MomCorpser;

/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	
	bWantsLedgeCheck = TRUE;
	
	Corpser.SetDesiredRotation( Rotator(Enemy.Location-Corpser.Location) );
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
}

function bool PickStabPattern()
{
	local int       ZoneIdx, PatternIdx;
	local Vector	TargLoc;
	local Actor		TargActor;

	//debug
	`AILog( GetFuncName()@Enemy );

	if( Corpser == None || 
		Corpser.Patterns.Length == 0 )
	{
		//debug
		`AILog( "No corpser or attack patterns" );

		return FALSE;
	}
	
	// Otherwise, use enemy location
	TargActor = Enemy;

	TargLoc = TargActor.Location - vect(0,0,80);

	ZoneIdx = Corpser.GetAttackZone( TargLoc );
	if( ZoneIdx < 0 )
	{
		//debug
		`AILog( "Target in invalid attack zone!"@TargActor@Enemy@Enemy.Location );

		return FALSE;
	}

	// Pick stab pattern
	if( Corpser.AttackZones[ZoneIdx].PatternList.Length == 0 )
	{
		//debug
		`AILog( "Zone"@ZoneIdx@"had no patterns!" );

		return FALSE;
	}

	PatternIdx = Corpser.AttackZones[ZoneIdx].PatternList[Rand(Corpser.AttackZones[ZoneIdx].PatternList.Length)];
	Corpser.SetPatternIdx( PatternIdx, TargActor, TargLoc );

	//debug
	`AILog( GetFuncName()@"Zone"@ZoneIdx@"Pattern"@Corpser.PatternIdx@Corpser.PatternLegIdx );

	return TRUE;
}


state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Corpser_Stab;
	}

	function bool ExecuteSpecialMove()
	{
		if( PickStabPattern() )
		{
			Corpser.SetTimer( 0.75, FALSE, nameof(Corpser.PlayStabAttackSound) );

			return Super.ExecuteSpecialMove();
		}
		else
		{
			//debug
			`AILog( "Failed to find stab pattern to hit"@Enemy );

			return FALSE;
		}
	}


	function float GetPostSpecialMoveSleepTime()
	{
		return 1.5f * FRand();
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}