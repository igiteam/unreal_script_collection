/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFormation extends Actor
	implements(Interface_NavigationHandle)
	native(AI);

var transient array<NanoAI> Members;

/** Our handle for pathing */
var transient NavigationHandle NavHandle;

/** Are we currently following a path */
var transient bool bMovingAlongPath;
/** Current path goal */
var transient Actor PathGoal;
var transient vector PathGoalLocation;
var transient vector NextMoveLocation;
/** Current rally goal */
var transient Actor RallyGoal;
var transient vector RallyGoalLocation;

/** Max movement speed for the formation */
var float MaxMovementSpeed;

/** Max size of the formation, for path finding */
var transient vector FormationExtent;

/** Enable debugging for the formation */
var bool bDebugFormation;

cpptext
{
	/** Interface_NavigationHandle implementation to grab search params */
	virtual void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
	virtual void InitForPathfinding() {}
	virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase* Edge);
};

// Interface_navigationhandle stub - called when path edge is deleted that this controller is using
event NotifyPathChanged();

// might not be needed but this guarentees look up.  FormationIndex should be correct.
function int FindMyMemberIdx( NanoAI AIToLookFor )
{
	local NanoAI AI;
	local int Idx;

	Idx = INDEX_NONE;

	foreach Members( AI )
	{
		Idx++;
		if( AI == AIToLookFor )
		{
			break;
		}
	}

	return Idx;
}

final function bool IsMemberInPosition(int MemberIdx)
{
	return Members[MemberIdx].Pawn == None || (VSize2D(Members[MemberIdx].Pawn.Location - GetPositionLocation(Members[MemberIdx].FormationPosition)) <= 256.f);
}

final event AddMember(NanoAI NewMember, optional bool bUpdateLocation)
{
	`log(`location@`showvar(NewMember),,,bDebugFormation);
    NewMember.Formation = self;
    Members.AddItem(NewMember);
	MembershipChanged();
	if (bUpdateLocation)
	{
		SetTimer(0.0001,FALSE,nameof(CalculateLocation));
	}
}

/** Averages the location of current membership, mainly used to establish starting position */
final function CalculateLocation()
{
	local vector LocationSum;
	local NanoAI Member;
	`log(`location,,,bDebugFormation);
	foreach Members(Member)
	{
		LocationSum += Member.Pawn.Location;
	}
	SetLocation(LocationSum/Members.Length);
	SetDesiredLocation(Location);
}

final event RemoveMember(NanoAI OldMember)
{
	if (OldMember != None)
	{
		if (OldMember.Formation == self)
		{
			OldMember.Formation = None;
		}
		if (Members.RemoveItem(OldMember) != INDEX_NONE)
		{
			MembershipChanged();
		}
	}
}

event vector GetPositionLocation(int Idx);
event rotator GetPositionRotation(int Idx);

function MembershipChanged();
function SetDesiredLocation( const vector InDesiredLocation );

defaultproperties
{
}