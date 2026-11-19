/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSquadFormation extends Info
	dependson(GearTypes)
	native(AI);

const MAXPOSITIONDIST	= 1024;
const MAXPOSITIONDISTSQ = 1048576; /*1024^2*/

var GearSquad Squad;

/** Last update time */
var transient float		LastUpdateTime;
/** Last update position */
var transient Vector	LastUpdatePosition;

/** List of positions in the formation (leader is not included) */
var() editconst array<FormationPosition> Positions;

// old squad position to calc deltas for squad dir
var transient vector LastSquadPosition;
// used to determine what our last squad position was
var transient vector CurrentSquadPosition; 

native function int GetNumSquadMembersThatUsePositions();
native function int GetBestUnusedPositionForAI(GearAI AI);

final function Controller GetSquadLeader()
{
	if( Squad != None )
	{
		return Squad.Leader;
	}
	return None;
}

final function Actor GetSquadLeaderPosition()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderPosition();
	}
	return None;
}

final function Vector GetSquadLeaderLocation()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderLocation();
	}
	return vect(0,0,0);
}

function int AssignPosition( GearAI AI )
{
	local int Idx;
	Idx = GetBestUnusedPositionForAI(AI);
	if( Idx >= 0 )
	{
		Positions[Idx].AI = AI;
	}
	return Idx;
}

function DismissPosition( GearAI AI )
{
	local int Idx;

	Idx = Positions.Find('AI',AI);
	if (Idx != -1)
	{
		Positions[Idx].AI = None;
	}
}

final function bool GetCurrentIdealPosition( GearAI AI, out Vector out_IdealPos )
{
	local int PosIdx;
	PosIdx = Positions.Find( 'AI', AI );
	if( PosIdx >= 0 )
	{
		out_IdealPos = Positions[PosIdx].IdealPosition;
		return TRUE;
	}
	return FALSE;
}

final function bool DoesIdealSquadPosOverlapAnother(GearAI AI)
{
	local int PosIdx;
	local int i;
	local float RadiusSq;
	PosIdx = Positions.Find( 'AI', AI );
	if( PosIdx >= 0 )
	{

		if(AI.Pawn != none)
		{
			RadiusSq = AI.Pawn.GetCollisionRadius();
			RadiusSq *= RadiusSq;
		}
		else
		{
			RadiusSq = 34.f * 34.f;
		}
		
		// assume the only positions we care about are at the front of the list
		for(i=0;i<Squad.SquadMembers.length;i++)
		{
			if(i != PosIdx)
			{
				if(VSizeSq(Positions[i].IdealPosition - Positions[PosIdx].IdealPosition) < RadiusSq)
				{
					return TRUE;
				}
			}
		}

	}
	return FALSE;
}

final function Vector GetSquadLeaderDir()
{
	local Vector LeaderDir, LeaderPos;
	local Pawn	 LeaderPawn;
	local Actor  LeaderPosActor;
	local GameplayRouteNode GRN;
	local int NextRouteIdx;

	LeaderPosActor = GetSquadLeaderPosition();
	if( LeaderPosActor != None )
	{
		if( Squad.SquadRoute != None )
		{
			NextRouteIdx = Squad.SquadRouteIndex + 1;
			if( NextRouteIdx < Squad.SquadRoute.RouteList.Length && 
				Squad.SquadRoute.RouteList[NextRouteIdx].Actor != None )
			{
				// face NEXT squad position
				LeaderDir = Squad.SquadRoute.RouteList[NextRouteIdx].Actor.Location - LeaderPosActor.Location;
				LeaderDir.Z = 0;
				return Normal(LeaderDir);
			}
		}	

		GRN = GameplayRouteNode(LeaderPosActor);
		if( GRN != None )
		{
			return Vector(GRN.Rotation);
		}
	}

	LeaderPos  = GetSquadLeaderLocation();
	if(GetSquadLeader() != none)
	{
		LeaderPawn = GetSquadLeader().Pawn;
		if(LeaderPawn != none)
		{
			LeaderPos = LeaderPawn.Location;
		}
	}	

	if( LeaderPawn != none &&  IsZero(LeaderPawn.Velocity) )
	{
		LeaderDir = vector(LeaderPawn.Rotation);
	}
	else
	{
		LeaderDir = Normal((LeaderPos - LastSquadPosition) * vect(1,1,0));
	}

	return LeaderDir;
}


/** Returns the ideal location for the specified formation position.*/
private final function Vector GetIdealPosition( int Idx )
{
	local Vector IdealPosition, Pos, Start, LeaderDir;
	local Rotator Rot;
	local actor HitActor;
	local vector HitLocation,HitNormal;

	if (Positions[Idx].RelIdx < 0)
	{
		Start = GetSquadLeaderLocation();
	}
	else if (Positions[Idx].RelIdx < Idx)
	{
		// We've already computed this position. This function must be called in increasing order
		Start = Positions[Positions[Idx].RelIdx].IdealPosition;
	}
	else
	{
		// Haven't computed it yet
		Start = GetIdealPosition( Positions[Idx].RelIdx );
	}

	LeaderDir = GetSquadLeaderDir();

	Rot.Yaw = rotator(LeaderDir * -1).Yaw;
	Rot.Yaw += Positions[Idx].YawOffset;
	Pos.X = Positions[Idx].Distance;
	IdealPosition = Start + (Pos >> Rot);


	if(Idx < Squad.SquadMembers.length)
	{
		HitActor = Trace(HitLocation,HitNormal,IdealPosition,GetSquadLeaderLocation());
		if(HitActor != none)
		{
			IdealPosition = HitLocation + (HitNormal * GetSquadLeader().Pawn.GetCollisionRadius()*1.1f);
		}
	}

	//return class'NavigationHandle'.static.MoveToDesiredHeightAboveMesh(IdealPosition,class'GearPawn'.default.CylinderComponent.CollisionHeight);
	return IdealPosition;
}

/** Finds new formation positions based on the leader's current position/orientation. */
final function UpdatePositions(optional bool bForce)
{
	local GearAI AI;
	local int Idx;
	local Controller SquadLeader;
	
	if( WorldInfo.bPlayersOnly )
	{
		return;
	}

	SquadLeader = GetSquadLeader();

	// if there isn't a leader
	if( SquadLeader == None || SquadLeader.Pawn == None )
	{
		// then no update is possible
		return;
	}

	AI = GearAI(SquadLeader);

	// check to see if we should do skip this update
	if(!bForce && (`TimeSince(LastUpdateTime) < 2.5 || VSize(LastUpdatePosition - GetSquadLeaderLocation()) < 256.f) )
	{
		return;
	}

	LastUpdateTime = WorldInfo.TimeSeconds;

	foreach Squad.AllMembers(class'GearAI',AI)
	{
		if( AI != none && !AI.bDeleteMe )
		{
			break;
		}
	}

	// Compute in order, so we can get the old positions
	for( Idx = 0; Idx < Positions.Length; Idx++ )
	{
		Positions[Idx].IdealPosition = GetIdealPosition( Idx );
	}

	LastUpdatePosition = GetSquadLeaderLocation();
	LastSquadPosition = CurrentSquadPosition;
	if(SquadLeader != none && SquadLeader.Pawn != none)
	{
		CurrentSquadPosition = SquadLeader.Pawn.Location;
	}
	else
	{
		CurrentSquadPosition = GetSquadLeaderLocation();
	}
	

	// ok, call up to the heavy-lifting function to get a real update
	if( AI != None )
	{
		AI.ComputeSquadFormationPositions( SquadLeader );
	}
}

/**
 * Returns the point assigned to the specified AI.
*/
final function Vector GetPosition( GearAI AI )
{
	local int Idx;

	//`AILog_Ext(GetFuncName()@AI.Pawn@AI.bIgnoreSquadPosition,,AI);
	if( AI.Pawn != None && !AI.bIgnoreSquadPosition )
	{
		//`AILog_Ext(GetFuncName()@GetSquadLeader()@GetSquadLeader().Pawn,,AI);
		if( GetSquadLeader() != None &&
			GetSquadLeader().Pawn != None )
		{
			UpdatePositions();
			Idx = Positions.Find( 'AI', AI );

			//`AILog_Ext(GetFuncName()@"Found index:"@Idx,,AI);
			if( Idx >= 0 )
			{
				//`AILog_Ext(GetFuncName()@"Returning Positions["$Idx$"].ActualPosition"@Positions[Idx].ActualPosition,,AI);
				return Positions[Idx].ActualPosition;
			}
			else
			// Otherwise, if there is no position AI may be the leader
			if( GetSquadLeader() == AI )
			{
				// Return point near leaders position (probably just uses the anchor)
				//`AILog_Ext(GetFuncName()@"returning GetSquadLeaderPosition()"@GetSquadLeaderPosition(),,AI);
				return GetSquadLeaderPosition().Location;
			}
			else
			{
				// force an update so we get a position
				if(`TimeSince(LastUpdateTime) > 0.25f)
				{
					UpdatePositions(true);
					Idx = Positions.Find( 'AI', AI );

					//`AILog_Ext(GetFuncName()@"Found index:"@Idx,,AI);
					if( Idx >= 0 )
					{
						//`AILog_Ext(GetFuncName()@"Returning Positions["$Idx$"].ActualPosition"@Positions[Idx].ActualPosition,,AI);
						return Positions[Idx].ActualPosition;
					}
				}

			}
		}
		else
		{
			//`AILog_Ext(GetFuncName()@"returning AI.Pawn.Anchor"@AI.Pawn.Anchor,,AI);
			return AI.Pawn.Location;
		}
	}

	`AILog_Ext(GetFuncName()@"failed and is returning none",,AI);
	return vect(0,0,0);
}

final function ClearPositions( Actor LeaderPos, optional int PositionIdx = -1 )
{
	local int	PosIdx;

	// Go through each position
	for( PosIdx = 0; PosIdx < Positions.Length; PosIdx++ )
	{
		if( PositionIdx >= 0 && PositionIdx != PosIdx )
			continue;

		if( Positions[PosIdx].AI != None )
		{
			// Clear position info
			Positions[PosIdx].ActualPosition = vect(0,0,0);
			Positions[PosIdx].Nav = None;
			`AILog_Ext(GetFuncName()@"Clearing squad position!",,Positions[PosIdx].AI);
			Positions[PosIdx].AI = None;
		}
	}

	// Update 
	LastUpdateTime	 = WorldInfo.TimeSeconds-1;
	LastUpdatePosition = LeaderPos.Location;

}

`if(`notdefined(FINAL_RELEASE))
simulated function Tick( float DeltaTime )
{
	local int Idx;

	super.Tick( DeltaTime );

//	bDebug=TRUE;
/*	if( GetSquadLeader() != None &&
		GetSquadLeader().Pawn != None &&
		!GetSquadLeader().Pawn.IsHumanControlled() )
	{
//		bDebug = TRUE;
	}
	else
	{
		disable('Tick');
	}
*/

// 	if(GetSquadLeader() != none)
// 	{
// 		DrawDebugCylinder(GetSquadLeader().Pawn.Location,GetSquadLeader().Pawn.Location,25.f,3,255,255,0);
// 	}
// 	for( Idx = 0; Idx < Positions.Length; Idx++ )
// 	{
// 		if(Positions[Idx].AI != none)
// 		{
// 			DrawDebugCylinder(Positions[Idx].IdealPosition,Positions[Idx].IdealPosition,25.f,3,255,255,255);
// 			DrawDebugLine(Positions[Idx].IdealPosition,Positions[Idx].AI.Pawn.Location,255,255,255);
// 			if( !IsZero(Positions[Idx].ActualPosition) )
// 			{
// 				DrawDebugLine(Positions[Idx].IdealPosition,Positions[Idx].ActualPosition,100,255,100);
// 			}
// 			
// 		}
// 		else
// 		{
// 			DrawDebugCylinder(Positions[Idx].IdealPosition,Positions[Idx].IdealPosition,25.f,3,100,255,100);
// 			if( !IsZero(Positions[Idx].ActualPosition) )
// 			{
// 				DrawDebugLine(Positions[Idx].IdealPosition,Positions[Idx].ActualPosition,100,255,100);
// 			}
// 		}
// 	}

	if( bDebug )
	{
		FlushPersistentDebugLines();
		for( Idx = 0; Idx < Positions.Length; Idx++ )
		{
			if( Positions[Idx].AI != None &&
				Positions[Idx].AI.Pawn != None )
			{
				if( GetSquadLeader() != None )
				{
					// Ideal position little box w/ line to leader location
					DrawDebugBox( Positions[Idx].IdealPosition + vect(0,0,50), vect(5,5,5), Positions[Idx].DebugColor.R/2, Positions[Idx].DebugColor.G/2, Positions[Idx].DebugColor.B/2, TRUE );
					DrawDebugLine( Positions[Idx].IdealPosition + vect(0,0,50), GetSquadLeaderLocation(), Positions[Idx].DebugColor.R/2, Positions[Idx].DebugColor.G/2, Positions[Idx].DebugColor.B/2, TRUE );
				}

				if( !IsZero(Positions[Idx].ActualPosition) )
				{
					// Actual position larger box w/ line to ideal and AI pawn
					DrawDebugBox( Positions[Idx].ActualPosition + vect(0,0,50), vect(10,10,10), Positions[Idx].DebugColor.R, Positions[Idx].DebugColor.G, Positions[Idx].DebugColor.B, TRUE );
					DrawDebugLine( Positions[Idx].ActualPosition + vect(0,0,50), Positions[Idx].IdealPosition + vect(0,0,50), Positions[Idx].DebugColor.R, Positions[Idx].DebugColor.G, Positions[Idx].DebugColor.B, TRUE );
					DrawDebugLine( Positions[Idx].ActualPosition + vect(0,0,50), Positions[Idx].AI.Pawn.Location, Positions[Idx].DebugColor.R, Positions[Idx].DebugColor.G, Positions[Idx].DebugColor.B, TRUE );
				}
			}
		}
		// White sphere around leader position w/ line to leader
		DrawDebugCylinder(GetSquadLeaderLocation(),GetSquadLeaderLocation(),25.f,3,255,255,0,TRUE);
		DrawDebugLine( GetSquadLeaderLocation(), GetSquadLeader().Pawn.Location, 255, 255, 255, TRUE );
		DrawDebugCoordinateSystem( GetSquadLeaderLocation(), Rotator(GetSquadLeaderDir()), 64.f, TRUE );
	}
}
`endif

defaultproperties
{
	Positions(0)=(PosName="LeftFlank",RelIdx=-1,YawOffset=8348,Distance=256.f,DebugColor=(R=255,G=0,B=0))
	Positions(1)=(PosName="RightFlank",RelIdx=-1,YawOffset=-8384,Distance=256.f,DebugColor=(R=0,G=0,B=255))
	Positions(2)=(PosName="LeftFlankRear_0",RelIdx=0,YawOffset=0,Distance=256.f,DebugColor=(R=0,G=255,B=0))
	Positions(3)=(PosName="RightFlankRear_0",RelIdx=1,YawOffset=0,Distance=256.f,DebugColor=(R=255,G=255,B=0))
	Positions(4)=(PosName="LeftFlankRear_1",RelIdx=2,YawOffset=0,Distance=256.f,DebugColor=(R=0,G=255,B=0))
	Positions(5)=(PosName="RightFlankRear_1",RelIdx=3,YawOffset=0,Distance=256.f,DebugColor=(R=255,G=255,B=0))
	Positions(6)=(PosName="LeftFlankRear_2",RelIdx=4,YawOffset=0,Distance=256.f,DebugColor=(R=0,G=255,B=0))
	Positions(7)=(PosName="RightFlankRear_2",RelIdx=5,YawOffset=0,Distance=256.f,DebugColor=(R=255,G=255,B=0))
}
