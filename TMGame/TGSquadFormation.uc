/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGSquadFormation extends Info
	native(TGAI);

const MAXPOSITIONDIST	= 1024;
const MAXPOSITIONDISTSQ = 1048576; /*1024^2*/

enum ETGSquadFormationType
{
	GSF_None,
	GSF_Column,
	GSF_Line,
};

var TGSquad Squad;

struct native FormationPosition
{
	/** Name of position */
	var() Name	PosName;
	/** Position is relative to position index (-1 == Leader) */
	/** Note: must be an index less than this current position */
	var() int RelIdx;
	/** Ideal yaw offset to "foward" (as defined by leader) */
	var() int YawOffset;
	/** Ideal distance from leader position */
	var() float Distance;

	/** Last update time */
	var float	LastUpdateTime;
	/** Last update position */
	var Vector	LastUpdatePosition;
	/** Ideal position in world space */
	var Vector	IdealPosition;

	/** Current navigation point assigned to this position */
	var() transient NavigationPoint Nav;
	/** Current AI controller assigned to this position */
	var() transient TGAI		AI;

	var() Color DebugColor;

	structdefaultproperties
	{
		RelIdx=-1
	}
};

/** List of positions in the formation (leader is not included) */
var() editconst array<FormationPosition> Positions;

// old squad position to calc deltas for squad dir
var transient vector LastSquadPosition;
// used to determine what our last squad position was
var transient vector CurrentSquadPosition; 

native function int GetNumSquadMembersThatUsePositions();

function Controller GetSquadLeader()
{
	if( Squad != None )
	{
		return Squad.Leader;
	}
	return None;
}

function Actor GetSquadLeaderPosition()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderPosition();
	}
	return None;
}

function Vector GetSquadLeaderLocation()
{
	if( Squad != None )
	{
		return Squad.GetSquadLeaderLocation();
	}
	return vect(0,0,0);
}

function int AssignPosition( TGAI AI )
{
	local int Idx;
	Idx = Positions.Find( 'AI', None );
	if( Idx >= 0 )
	{
		Positions[Idx].AI = AI;
	}
	return Idx;
}

function DismissPosition( TGAI AI )
{
	local int Idx;

	Idx = Positions.Find('AI',AI);
	if (Idx != -1)
	{
		Positions[Idx].AI = None;
	}
}

final function bool GetCurrentIdealPosition( TGAI AI, out Vector out_IdealPos )
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

final function bool DoesIdealSquadPosOverlapAnother(TGAI AI)
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

	

private final function Vector GetSquadLeaderDir( int Idx )
{
	local Vector LeaderDir, LeaderPos;
	local Pawn	 LeaderPawn;

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


/** Returns the ideal location for the specified formation position. */
private final function Vector GetIdealPosition( int Idx )
{
	local Vector IdealPosition, Pos, Start, LeaderDir;
	local Rotator Rot;
	local actor HitActor;
	local vector HitLocation,HitNormal;

	Start = (Positions[Idx].RelIdx < 0) ? GetSquadLeaderLocation() : GetIdealPosition( Positions[Idx].RelIdx );
	LeaderDir = GetSquadLeaderDir( Idx );

	Rot = rotator(LeaderDir * -1);
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

	return IdealPosition;
}

/** Finds new formation positions based on the leader's current position/orientation. */
final function UpdatePositions(optional int RequestedIdx = -1, optional bool bForce)
{
	local TGAI AI;
	local int Idx;

	// if there isn't a leader
	if( GetSquadLeader() == None || GetSquadLeader().Pawn == None )
	{
		// then no update is possible
		return;
	}

	// if this position doesn't need to be updated and this isn't forced
	if ( RequestedIdx >= 0 &&
		( TimeSince(Positions[RequestedIdx].LastUpdateTime) < 0.25f ||
		 (Positions[RequestedIdx].Nav != None && VSize(Positions[RequestedIdx].LastUpdatePosition - GetSquadLeaderLocation()) < 128.f) ) )
	{
		return;
	}

	for( Idx = 0; Idx < Positions.Length; Idx++ )
	{
		if( AI == None || AI.bDeleteMe )
		{
			AI = Positions[Idx].AI;
			
		}

		Positions[Idx].IdealPosition = GetIdealPosition( Idx );
	}

	LastSquadPosition = CurrentSquadPosition;
	if(GetSquadLeader() != none && GetSquadLeader().Pawn != none)
	{
		CurrentSquadPosition = GetSquadLeader().Pawn.Location;
	}
	else
	{
		CurrentSquadPosition = GetSquadLeaderLocation();
	}
	

	if( AI != None )
	{
		AI.FindSquadPosition( GetSquadLeader(), RequestedIdx );
	}
}

/**
 * Returns the navigation point assigned to the specified AI.
 */
final function NavigationPoint GetPosition( TGAI AI )
{
	local int Idx;

	//`AILog_Ext(GetFuncName()@AI.Pawn@AI.bIgnoreSquadPosition,,AI);
	if( AI.Pawn != None && !AI.bIgnoreSquadPosition )
	{
		//`AILog_Ext(GetFuncName()@GetSquadLeader()@GetSquadLeader().Pawn,,AI);
		if( GetSquadLeader() != None &&
			GetSquadLeader().Pawn != None )
		{
			Idx = Positions.Find( 'AI', AI );

			//`AILog_Ext(GetFuncName()@"Found index:"@Idx,,AI);
			if( Idx >= 0 )
			{
				UpdatePositions( Idx );
				//`AILog_Ext(GetFuncName()@"Returning Positions["$Idx$"].Nav"@Positions[Idx].Nav,,AI);
				return Positions[Idx].Nav;
			}
			else
			// Otherwise, if there is no position AI may be the leader
			if( GetSquadLeader() == AI )
			{
				// Return nav point near leaders position (probably just uses the anchor)
				//`AILog_Ext(GetFuncName()@"returning GetSquadLeaderPosition()"@GetSquadLeaderPosition(),,AI);
				return NavigationPoint(GetSquadLeaderPosition());
			}
		}
		else
		{
			//`AILog_Ext(GetFuncName()@"returning AI.Pawn.Anchor"@AI.Pawn.Anchor,,AI);
			return AI.Pawn.Anchor;
		}
	}

	;
	return None;
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
			Positions[PosIdx].Nav = None;

			// Update 
			Positions[PosIdx].LastUpdateTime	 = WorldInfo.TimeSeconds;
			Positions[PosIdx].LastUpdatePosition = LeaderPos.Location;
		}
	}
}
















































































