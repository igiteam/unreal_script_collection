/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_BlimpTurret extends GearAI
	native(AI)
	config(AI);

var Turret_BlimpBallBase MyTurret;

/**
 * Overridden for additional init.
 */
event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	if( Pawn != None )
	{
		MyTurret = Turret_BlimpBallBase(Pawn);
		WorldInfo.Game.ChangeTeam( self, TEAM_LOCUST, FALSE );
	}
}

function bool ShouldSaveForCheckpoint()
{
	return false;
}


final function bool CanTurretFireAt(Actor TestActor, optional Turret TestTurret, optional bool bSkipCoverCheck)
{
	local GearPawn TargetWP;

	if (TestTurret == None)
	{
		TestTurret = MyTurret;
	}

	if (TestTurret != None && TestActor != None)
	{
		// check to see if it's a target protected by cover
		TargetWP = GearPawn(TestActor);
		if ( !bSkipCoverCheck && TargetWP != None &&
			TargetWP.IsProtectedByCover(Normal(TargetWP.Location - TestTurret.GetPhysicalFireStartLoc(vect(0,0,0))), true) )
		{
			return FALSE;
		}

		// check to see if the target is outside our rotation clamps
		if (!GearTurret(TestTurret).IsWithinRotationClamps(TestActor.Location))
		{
			return FALSE;
		}

		// check to see if we have los
		return ( CanFireAt(TestActor, TestTurret.GetPhysicalFireStartLoc(vect(0,25,0))) ||
				 CanFireAt(TestActor, TestTurret.GetPhysicalFireStartLoc(vect(0,-25,0))) );
	}

	return FALSE;
}


state Action_Idle
{
Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	// make sure we have a squad
	if( Squad == None )
	{
		SetSquadName('Alpha');
	}

	// If we have enemies
	if( HasAnyEnemies() )
	{
		// Try to notice one which will put us into combat
		CheckNoticedEnemy();
		Sleep(1.f);
	}
	else
	{
		`AILog("no enemies, sleeping");
		Sleep(1.f);
	}

	Goto('Begin');
}


defaultproperties
{
	DefaultCommand=class'AICmd_Base_BlimpTurret'

	/// *** Begin Reactions ***
	DefaultReactConditionClasses.Empty
	DefaultReactConditionClasses.Add(class'AIReactCond_NewEnemy')
	
	Begin Object Class=AIReactionmanager Name=ReactionManager0
	End Object
	ReactionManager=ReactionManager0
	/// *** End Reactions ***

//	bDebug=TRUE
}
