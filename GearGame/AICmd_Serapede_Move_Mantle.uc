/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Serapede_Move_Mantle extends AICommand
	within GearAI;

var Vector MantleStart;
var Vector MantleDest;
var float MantleDist;

struct MovePointInfo
{
	var vector Point;
	var EPhysics PhysicsMode;
};

var array<MovePointInfo> movepoints;

var vector HeightOffsetForTopPt;
var vector HeightOffGroundForStartDest;

var float OldGroundSpeed;

var int i;

static function bool MantleEdge( GearAI AI, Vector MoveStart, Vector MoveDest, CoverInfo Info )
{
	local AICmd_Serapede_Move_Mantle Cmd;

	if( AI != None && AI.MyGearPawn != None && !AI.MyGearPawn.IsAKidnapper() && Info.Link != None )
	{
		Cmd = new(AI) class'AICmd_Serapede_Move_Mantle';
		Cmd.MantleStart		= MoveStart;
		Cmd.MantleDest		= MoveDest;

		AI.PushCommand( Cmd );
		return TRUE;
	}

	return FALSE;
}
function Pushed()
{
	Super.Pushed();

	MantleDist=250;

	ReactionManager.SuppressAll();

	Pawn.SetCollision(false,false);

	MantleStart += HeightOffGroundForStartDest;
	MantleDest.Z = MantleStart.Z;
	if(MyGearPawn.FindMantleDistance(MantleStart,MantleDest,MantleDist))
	{
		GotoState( 'FlyOverMantle' );
	}
	else
	{
		`AILog("Could not find mantle distance.. abort!");
		AbortCommand(self);
	}

}

function Popped()
{
	Super.Popped();

	ReactionManager.UnSuppressAll();

	Pawn.SetCollision(true,true);

	MyGearPawn.SetMovementPhysics();
	MyGearPawn.GroundSpeed = OldGroundSpeed;
}

state FlyOverMantle
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
	}

	function EndState(Name EndStateName)
	{
		Super.EndState(EndStateName);
	}

	function bool SetMovePoints()
	{
		local vector HitLoc, HitNorm, Start,End;
		local actor HitActor;

		// go back down to ground level
		movepoints[0].Point=MantleStart-HeightOffGroundForStartDest;
		
		// go up HeightOffsetForTopPt offset from ground
		movepoints[1].Point=movepoints[0].Point + HeightOffsetForTopPt;
		movepoints[1].Point.z += MyGearPawn.CylinderComponent.CollisionHeight;
		
		// find ground below end
		Start = MantleDest;
		End = Start - vect(0,0,200);
		HitActor=MyGearPawn.Trace(HitLoc,Hitnorm,End,Start,TRUE,vect(1,1,1));
		
		if(HitActor == none)
		{
			return false;
		}
		
		movepoints[2].Point=MantleDest;
		movepoints[2].Point.z = movepoints[1].Point.z;
		movepoints[3].Point=HitLoc;

		return true;

	}
Begin:
	if(!SetMovePoints())
	{
		GotoState('DelayFailure');
	}

	OldGroundSpeed=MyGearPawn.GroundSpeed;
	MyGearPawn.GroundSpeed += 200;

	// fly to start pt;
	for(i=0;i<4;i++)
	{
		// first have it lookat dest point
		SetFocalPoint(movepoints[i].Point);
		MoveToDirectNonPathPos(movepoints[i].Point,,Pawn.GetCollisionRadius());

		if(movepoints[i].PhysicsMode != MyGearPawn.Physics)
		{
			MyGearPawn.SetPhysics(movepoints[i].PhysicsMode);
		}

// 		if(i<3)
// 		{
// 			MyGearPawn.DrawDebugLine(movepoints[i].Point,movepoints[i+1].Point,255,0,0,TRUE);
// 		}
	}

	MyGearPawn.SetMovementPhysics();

	// check to see if we're in a valid spot!
	if( !NavigationHandle.ObstaclePointCheck(Pawn.Location,Pawn.GetCollisionExtent()) )
	{
		GotoState('WeAreEphedNeedToGetUnEphed');
	}
	else
	{
		Status='Success';
		PopCommand(Self);
	}
}

state WeAreEphedNeedToGetUnEphed `DEBUGSTATE
{
	function vector GetFailSafeMovePoint()
	{
		local array<vector> Points;

		NavigationHandle.GetValidPositionsForBox(Pawn.Location,1024,Pawn.GetCollisionExtent(),FALSE,Points,1);

		if( Points.length > 0 )
		{
			//DrawDebugLine(Points[0],Pawn.Location,255,255,0,TRUE);
			return Points[0];
		}
		
		//DrawDebugLine(movepoints[3].Point,Pawn.Location,255,0,0,TRUE);
		return movepoints[3].Point;
	}
Begin:
	
	`AILog("We are hosed.. zapping to walkable location");

	Pawn.SetLocation(GetFailSafeMovePoint());

	GotoState('DelayFailure');

};

/** Disable transitions */
function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
      return TRUE;
}

defaultproperties
{
	HeightOffsetForTopPt=(z=90)
	HeightOffGroundForStartDest=(z=50);

	movepoints(0)=(PhysicsMode=PHYS_Spider)
	movepoints(1)=(PhysicsMode=PHYS_Spider)
	movepoints(2)=(PhysicsMode=PHYS_Flying)
	movepoints(3)=(PhysicsMode=PHYS_Flying)

	bIgnoreNotifies=true
}
