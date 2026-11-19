/**
 * So this is meant to be given to the "leader" of the formation and this AICmd will pathfind
 * and tell the wall
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BattlionMove extends NanoAICmd within NanoAI_Trooper;


//have one of the dudes (members[0] probably best) do a pathfinding

/** 
 *  For now we select a leader of the battlion and then he will tell all of his troops where to move.
 *  the formations don't have pathfinding yet so we just do a pass through via this guy
 *  **/
var transient protected NanoAI_Trooper LeaderOfBattlion;


/** This is where we want this battlion to move to **/
var transient protected Vector FormationMoveLocation;


var transient private NanoAI_Trooper Trooper;
var transient private Vector SpawnLocation;

var transient private bool bFilledOutWall;


/** The AIs we are meant to apprehend **/
var transient array<NanoAI> TargetsToApprehend;


var protected transient NanoProceduralMissionRewardBase RewardToGive; 


static final function BattlionMoveOut( NanoAI_Trooper AI, vector InMoveLocation, Vector InSpawnLocation, array<NanoAI> InTargetsToApprehend, NanoProceduralMissionRewardBase InRewardToGive  )
{
	local NanoAICmd_BattlionMove Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'NanoAICmd_BattlionMove';
		if( Cmd != None )
		{
			Cmd.LeaderOfBattlion = AI;
			Cmd.FormationMoveLocation = InMoveLocation;
			Cmd.SpawnLocation = InSpawnLocation;
			Cmd.TargetsToApprehend = InTargetsToApprehend;
			Cmd.RewardToGive = InRewardToGive;

			AI.PushCommand(Cmd);
		}
	}
}



function Pushed()
{
	Super.Pushed();
	GotoState( 'MovingFormationToGoal' );
}


/** 
 * So when we are resumed we will have finished our move action and we want to repath find to our  
 *  
 **/
function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( OldCommandName != 'NanoAICmd_BeatDownTheTroubleMakers' )
	{
		`log( "MOVE OUT!" @ OldCommandName @ Outer );
		MoveOut();
	}
	else
	{
		`log( "back to the battlion move" @ OldCommandName @ Outer );
	}
}


function MoveOut()
{
	local NanoAI TargetToApprehend;

	if( bFilledOutWall == FALSE )
	{
		TryToFillOutWall();
		class'NanoAICmd_Pause'.static.Pause( Outer, 1.0f ); // wait a bit
		//return;
	}


	// so now check to see if the wall is in the correct position
	if( NanoFormation_Wall(Formation).DesiredLocation != NanoFormation_Wall(Formation).Location )
	{
		`log( "  !!!! wall has not moved up yet" @ NanoFormation_Wall(Formation).DesiredLocation @ NanoFormation_Wall(Formation).Location );
		class'NanoAICmd_Pause'.static.Pause( Outer, 1.0f ); // wait a bit
		return;
	}


	if( VSize(FormationMoveLocation - Pawn.Location) > 256.0f )
	{
		`log( "MoveOut!!" @ VSize(FormationMoveLocation - Pawn.Location) );
   	 	if( GeneratePathToLocation( FormationMoveLocation ) == TRUE )
   	 	{
			NavigationHandle.SetFinalDestination( FormationMoveLocation );

    	    TellOurFormationToMoveToNextPoint2();
   	 	}
		else
		{
			`log( "GeneratePathToLocation failed to find a path" @ FormationMoveLocation );
		}
	}
	// we reached our goal
    else
	{
		// this should be a SpecialMove as we are interacting with other pawns
		// so since we are starting the beat down we should give these dudes some "rewards for being killed"
		// 
		// we will give Lyrik 20 seconds to stop the beat down.
		NanoPawnBase(Outer.Pawn).AddProceduralMisisonReward( RewardToGive ); // give the reward the dude picking up the package
		class'NanoAICmd_BeatDownTheTroubleMakers'.static.BeatDownTheTroubleMakers( Outer, 20.0f );

		foreach TargetsToApprehend( TargetToApprehend )
		{
			class'NanoAICmd_BeatDownByTheRiotTroopers'.static.BeatDownByTheRiotTroopers( TargetToApprehend, 17.0f );
		}


		//`log( "completed!  POPPING!!" );
		//PopCommand( Self );
    }
}


function TryToFillOutWall()
{
		// so now spawn some pals for him
        Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, FALSE, SpawnLocation + vect(1.5,0,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		Trooper.bInFormation = TRUE;
		Formation.AddMember( Trooper );
		DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

        Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, FALSE, SpawnLocation + vect(0,1.5,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		Trooper.bInFormation = TRUE;
		Formation.AddMember( Trooper );
		DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

        Trooper = NanoAI_Trooper(NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, FALSE, SpawnLocation + vect(1.5,1.5,0)*class'NanoPawn_MetaCorp_RiotCop_Captain'.default.CylinderComponent.CollisionRadius ));
		Trooper.bInFormation = TRUE;
        Formation.AddMember( Trooper );
		DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
		`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );

     NanoFormation_Wall(Formation).MembershipChanged();
	//NanoFormation_Wall(Formation).GotoState('MoveIntoFormation');


	 if( Formation.Members.Length >= 3 )
	 {
		bFilledOutWall = TRUE;
		Formation.PathGoalLocation = FormationMoveLocation;
	 }
}


function TellOurFormationToMoveToNextPoint2()
{
	local Vector NextMoveDest;

    if( NavigationHandle.GetNextMoveLocation( NextMoveDest, Pawn.GetCollisionRadius() ) == TRUE )
    {
		`log( "TellOurFormationToMoveToNextPoint2 Moving to" @ Pawn @ NextMoveDest @ Pawn.Location @ VSize(Pawn.Location-NextMoveDest) @ VSize(Pawn.Location - FormationMoveLocation ) );
		DrawDebugCoordinateSystem( NextMoveDest, rot(0,0,0), 10.0f, TRUE );
        DrawDebugLine( Pawn.Location, NextMoveDest, 128, 128, 0, TRUE );

		Formation.SetDesiredLocation( NextMoveDest );
		NanoFormation_Wall(Formation).CalculateLocation();

		class'NanoAICmd_MoveToWithOutPathing'.static.MoveToWithOutPathing( Outer, NextMoveDest, 64.0f );
		
		//MoveToLocation( NextMoveDest, 10.0f, TRUE );
		// need to use a goal here also


    }
	else
	{
		`log( "TellOurFormationToMoveToNextPoint2 Failed to find a GetNextMoveLocation" );
	}
}


function TellOurFormationToMoveToNextPoint()
{
	local Vector NextMoveDest;
	local NanoAI AI;

    if( NavigationHandle.GetNextMoveLocation( NextMoveDest, Pawn.GetCollisionRadius() ) == TRUE )
    {
		foreach Formation.Members( AI )
		{
			if( true ) //( AI != Outer )
			{
				`log( "Moving to" @ AI @ NextMoveDest );
			    AI.MoveToLocation( NextMoveDest );
			}
		}

		DrawDebugCoordinateSystem( NextMoveDest, rot(0,0,0), 10.0f, TRUE );
    }
}

function MoveCaptainAwayFromFormation()
{
	local Vector NextMoveDest;

   	 	if( GeneratePathToLocation( FormationMoveLocation ) == TRUE )
   	 	{
			NavigationHandle.SetFinalDestination( FormationMoveLocation );
   			if( NavigationHandle.GetNextMoveLocation( NextMoveDest, Pawn.GetCollisionRadius() ) == TRUE )
   			{
				class'NanoAICmd_MoveToWithOutPathing'.static.MoveToWithOutPathing( Outer, NextMoveDest, 64.0f );
   			}
   	 	}
		else
		{
			`log( "GeneratePathToLocation failed to find a path" @ FormationMoveLocation );
		}

}


function SpawnTroopers()
{

}




state MovingFormationToGoal
{

Begin:

	Sleep( 20.0f ); // sleep for a bit

    MoveCaptainAwayFromFormation();
    Sleep( 1.0f );

  //  while( Formation.Members.Length != 5 )
   // {
    //    Trooper = NanoAI_Trooper(NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_SpawnAroundCornerOutOfSight, SpawnLocation ));
	//	Formation.AddMember( Trooper );
//		DrawDebugLine( Trooper.Pawn.Location, SpawnLocation, 0, 255, 0, TRUE );
//		`log( "Trooper" @ Trooper @ Trooper.Pawn.Location @ SpawnLocation );
//		 Sleep(1.0f);
  //  }

	`log( "Formation.Members.Length" @ Formation.Members.Length );
	MoveOut();

}


// well we can't use GetValidPositionsForBox as that is returning the N polys that are within range and returning thei poly center
// so that breaks for large polys :-(  And it just so happens the navmesh tries to make the largest polys possible so yeah no dice there



defaultproperties	
{
}




// so we need a goal for determining if our poly is large enough for us
//  -- the box check will be nice but we still need a specific area that is probably big enough for us to spawn in  and then the box checker thing will give us the actual slots 

// we need a goal that is deffered for determing if the poly is valid for us  (basically a list of points where dudes have previously spawned before and then bias the choice against that)

// need to expose the epsilon for the distance to goal so we can use that
//  ---> look into having a callback for getting notified when we can not get to the goal but are close to it



