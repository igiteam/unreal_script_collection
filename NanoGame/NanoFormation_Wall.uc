/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFormation_Wall extends NanoFormation
	native(AI);

/** Leader used for AI schtuff, generally somebody in the first row */
var transient NanoAI LeaderAI;
/** What the formation is currently engaging */
var transient Actor FireTarget;

var transient Actor LookAtGoal;

var transient array<Actor> Obstacles;

/** List of formation positions, relative to Location */
struct native Position
{
	/** Index into Members list for the owner of this position */
    var int MemberIdx;
	/** Which row this position is in */
	var int Row;
	/** Relative location/rotation */
    var vector LocationOffset;
    var rotator RotationOffset;
};
var transient array<Position> Positions;

/** Spacing between positions/rows */
var int RowSpacing;
var int ColSpacing;
/** Current max members per row */
var transient int RowSize;
/** Current max number of rows */
var transient int RowCount;
/** Should rows offset column positions */
var bool bStaggerRows;
/** Desired max row size */
var int DesiredRowSize;

/** Desired yaw for the formation */
var int DesiredYaw;
/** Interp rate for DesiredYaw */
var int YawInterpRate;
/** Desired location for the formation */
var transient vector DesiredLocation;
/** Interp rate for DesiredLocation */
var float LocationInterpRate;

var transient bool bForceShields;
var transient bool bRotatingFormation;

/** This is our safe guard for a number of the SleepUntil that we use. **/
var transient float TimeOutTimer;

/** Max allowed speed */
var transient float MovementSpeedModifier;

var bool bAllowCombat;

/** Sound for shield guys to play when they put their shield down. **/
var SoundCue ShieldPose_ShieldDownSound;


function OnModifyFormation(SeqAct_ModifyFormation Action)
{
	`log(`location,bDebugFormation);
	RowSpacing = Action.RowSpacing;
	ColSpacing = Action.ColSpacing;
	SetRowSize(Action.DesiredRowSize);
	bForceShields = Action.bForceShields;
	bAllowCombat = Action.bAllowCombat;

	if (bForceShields)
	{
		EquipShields();
		SetTimer(0.25f,TRUE,nameof(ScareCrowds));
	}
	else
	{
		ClearTimer(nameof(ScareCrowds));
	}
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	SetFireTarget(None);
	PathGoal = Action.PickDestination(self);
	LookAtGoal = Action.LookAt;
	MovementSpeedModifier = Action.MovementSpeedModifier;
	PushState('PathToGoal');
}

function SetDesiredLocation( const vector InDesiredLocation )
{
	DesiredLocation = InDesiredLocation;
}

/** Notification that something happened, set timer to recalc positions next frame */
function MembershipChanged()
{
    SetTimer(0.1f,FALSE,nameof(CalculatePositions_NoMembershipChange));
	if (!IsInState('MoveIntoFormation',TRUE))
	{
		GotoState('MoveIntoFormation');
	}
	else
	{
		GotoState('MoveIntoFormation','Begin');
	}
}

function PostBeginPlay()
{
	SetTimer(0.25f,TRUE,nameof(BuildObstacles));
}

function CalculatePositions_NoMembershipChange()
{
	CalculatePositions(TRUE);
}

/** Big mama, calculates the relative offsets for all the positions in the formation. */
function CalculatePositions(optional bool bPreserveMembership)
{
    local int Idx, Row, Pos, Flipper;
	local bool bStaggerThisRow;

    //FlushPersistentDebugLines();
    if (Members.Length > 0)
    {
		DesiredLocation = Location;
		DesiredYaw = Rotation.Yaw;
        // for now don't alter row size, just calculate number of rows
        RowSize = DesiredRowSize;
        RowCount = (Members.Length-1)/RowSize + 1;
		Flipper = Members.Length - Positions.Length;
		if (Flipper > 0)
		{
			Positions.Length = Members.Length;
			for (Idx = Positions.Length - Flipper; Idx < Positions.Length; Idx++)
			{
				Positions[Idx].MemberIdx = INDEX_NONE;
			}
		}
		// grow from in inside out, first row going back
        Row = 0;
		bStaggerThisRow = FALSE;
		Pos = RowSize/2;
		Flipper = 0;
        for (Idx = 0; Idx < Positions.Length; Idx++)
        {
			// check for next row
            if ((Idx - (Row * RowSize)) >= RowSize)
            {
				Flipper = 0;
                Row++;
				bStaggerThisRow = (bStaggerRows && (Row % 2) == 1); // || (Members.Length - (Row * RowSize)) < RowSize;
            }
			// figure out the position
			if ((Idx % 2) == 0)
			{
				Pos = RowSize/2 + Flipper;
			}
			else
			{
				Pos = RowSize/2 - Flipper - 1;
				Flipper++;
			}
			Positions[Idx].LocationOffset.X = Row * -RowSpacing;
			Positions[Idx].LocationOffset.Y = (Pos - RowSize/2) * ColSpacing;
			Positions[Idx].LocationOffset.Z = 0;
			Positions[Idx].Row = Row + 1;
			// stagger the rows
			if (bStaggerThisRow)
			{
				Positions[Idx].LocationOffset.Y += ColSpacing;
			}
        }
		AssignPositions(bPreserveMembership);
		// grab the leader
		LeaderAI = Members[Positions[0].MemberIdx];
		if (!IsInState('MoveIntoFormation',TRUE))
		{
			GotoState('MoveIntoFormation');
		}
    }
	else
	{
		RowSize = 0;
		RowCount = 0;
		Positions.Length = 0;
	}

	FormationExtent.X = (RowCount * RowSpacing) / 2;
	FormationExtent.Y = (RowSize * ColSpacing) / 2;
	FormationExtent.Z = (LeaderAI != None ? LeaderAI.Pawn.GetCollisionHeight() : 0.f);

	//`log( "FormationExtent" @ FormationExtent, bDebugFormation );
}

final function SetRowSize(int NewRowSize)
{
	if (DesiredRowSize != NewRowSize)
	{
		`log(`location@`showvar(NewRowSize),bDebugFormation);
		DesiredRowSize = NewRowSize;
		CalculatePositions();
	}
}

function vector GetPositionLocation(int Idx)
{
	if (Idx == INDEX_NONE)
	{
		ScriptTrace();
	}
    return Location + (Positions[Idx].LocationOffset >> Rotation);
}

function rotator GetPositionRotation(int Idx)
{
	return Rotation;
}


function float ClosestPointTo(NanoAI A)
{
	local int Idx;
	local float Dist, BestDist;
	BestDist = 9999999.f;
	for (Idx = 0; Idx < Positions.Length; Idx++)
	{
		if (Positions[Idx].MemberIdx != INDEX_NONE)
		{
			continue;
		}
		Dist = VSize(GetPositionLocation(Idx) - A.Pawn.Location);
		if (Dist < BestDist)
		{
			BestDist = Dist;
		}
	}
	return BestDist;
}

function int SortMembersByDist(NanoAI A, NanoAI B)
{
	return ClosestPointTo(A) < ClosestPointTo(B) ? -1 : 0;
}

/** Assigns members to positions based on a furthest-pick-closest approach */
function AssignPositions(optional bool bPreserveMembership)
{
	local NanoAI Member;
	local array<NanoAI> SortedList;
	local int Idx, BestIdx, MemberIdx;
	local float Dist, BestDist;
	local vector PositionLocation;
	`log(`location@`showvar(bPreserveMembership),bDebugFormation);
	if (bPreserveMembership)
	{
		// only assign positions to members w/o one already
		foreach Members(Member,MemberIdx)
		{
			if (Member.FormationPosition == INDEX_NONE)
			{
				SortedList.AddItem(Member);
			}
		}
	}
	else
	{
		// clear out previous assignments
		for (Idx = 0; Idx < Positions.Length; Idx++)
		{
			Positions[Idx].MemberIdx = INDEX_NONE;
		}
		foreach Members(Member)
		{
			Member.FormationPosition = INDEX_NONE;
			SortedList.AddItem(Member);
		}
	}
	while (SortedList.Length > 0)
	{
		SortedList.Sort(SortMembersByDist);
		Member = SortedList[0];
		SortedList.Remove(0,1);
		BestDist = 99999999.f;
		for (Idx = 0; Idx < Positions.Length; Idx++)
		{
			if (Positions[Idx].MemberIdx != INDEX_NONE)
			{
				continue;
			}
			PositionLocation = GetPositionLocation(Idx);
			Dist = VSize(PositionLocation - Member.Pawn.Location);
			if (Dist < BestDist)
			{
				BestDist = Dist;
				BestIdx = Idx;
			}
		}
		Member.SetFormationPosition(self,BestIdx);
		Positions[BestIdx].MemberIdx = Members.Find(Member);
		// make sure everyone has a gun
		NanoPawn(Member.Pawn).SpawnNanoMP7();
		if (Positions[BestIdx].Row == 1)
		{
			`log("create shield:"@`showvar(Member));
			NanoPawn(Member.Pawn).CreateShield();
		}
		else
		{
			// back rows always aim mode
			NanoPawn(Member.Pawn).bForceAimAnim = TRUE;
		}
	}
	if (bDebugFormation)
	{
		foreach Members(Member)
		{
			`log(">"@`showvar(Member)@Member.FormationPosition);
		}
	}
}

function EquipShields()
{
	local int Idx;
	for (Idx = 0; Idx < Positions.Length; Idx++)
	{
		if (Positions[Idx].Row == 2)
		{
			NanoPawn(Members[Positions[Idx].MemberIdx].Pawn).SpawnNanoMP7();
		}
		else if (Positions[Idx].Row == 1)
		{
			NanoPawn(Members[Positions[Idx].MemberIdx].Pawn).CreateShield();
		}
	}
}

final function bool MembersAreInPosition()
{
	local int Idx;
	for (Idx = 0; Idx < Positions.Length; Idx++)
	{
		if (!IsMemberInPosition(Positions[Idx].MemberIdx))
		{

			`log( "Member is not in position!" @ `showvar(Members[Positions[Idx].MemberIdx]) );
			`log( `showvar(Members[Positions[Idx].MemberIdx].Pawn.Location) @ `showvar(GetPositionLocation(Members[Positions[Idx].MemberIdx].FormationPosition)) );

			if (bDebugFormation)
			{
				DrawDebugLine(Members[Positions[Idx].MemberIdx].Pawn.Location,Members[Positions[Idx].MemberIdx].Pawn.Location+vect(0,0,1024),255,0,0,TRUE);
				DrawDebugLine(GetPositionLocation(Members[Positions[Idx].MemberIdx].FormationPosition),GetPositionLocation(Members[Positions[Idx].MemberIdx].FormationPosition)+vect(0,0,1024),0,255,0,TRUE);
			}

			return FALSE;
		}
	}
	return TRUE;
}


final function bool IsFacingFireTarget()
{
	return (DesiredYaw == Rotation.Yaw || (vector(Rotation) dot Normal(FireTarget.Location - Location)) > 0.5f);
}

final function bool IsFireTargetInRange()
{
	return FireTarget != None && VSize(FireTarget.Location - Location) > 512.f && VSize(FireTarget.Location - Location) < 2048.f;
}

final function bool IsFireTargetVisible()
{
	return FireTarget == None || LeaderAI == None || LeaderAI.LineOfSightTo(FireTarget);
}

final function SetFireTarget(Actor NewFireTarget)
{
	local NanoAI Member;
	FireTarget = NewFireTarget;
	foreach Members(Member)
	{
		Member.SetFireTarget( FireTarget );
	}
}

state MoveIntoFormation
{

    final function MoveMembers()
    {
        local NanoAI Member;
        foreach Members(Member)
        {
            if (bDebugFormation) DrawDebugLine(Member.Pawn.Location,GetPositionLocation(Member.FormationPosition),0,255,0,TRUE);
            Member.MoveToFormationPosition();
        }
    }

	function StartFiring()
	{
		local int Idx;
		for (Idx = 0; Idx < Positions.Length; Idx++)
		{
			if (Positions[Idx].Row == 2)
			{
				Members[Positions[Idx].MemberIdx].OpenFire();
			}
		}
	}

	function StopFiring()
	{
		local int Idx;
		for (Idx = 0; Idx < Positions.Length; Idx++)
		{
			if (Positions[Idx].Row == 2)
			{
				Members[Positions[Idx].MemberIdx].StopFiring();
			}
		}
	}

	function ContinuedState()
	{
		if (!bAllowCombat)
		{
			GotoState(GetStateName(),'Idle');
		}
	}

Begin:
	// initial delay, in case more members are joining shortly
	if (IsTimerActive(nameof(CalculatePositions_NoMembershipChange)))
	{
		Sleep(0.25f);
	}
    // first have everybody grab a position
    MoveMembers();
	Sleep(1.f);
	TimeOutTimer = WorldInfo.TimeSeconds;
	`SleepUntil(MembersAreInPosition());// || (`TimeSince(TimeOutTimer) > 5.0f));
	if (!bAllowCombat)
	{
		Goto('Idle');
	}
	ColSpacing = 128;
	if (RowCount == 1)
	{
		`log("stacking",bDebugFormation);
		SetRowSize(Max(1,Members.Length/2+1));
	}
	else
	{
		CalculatePositions(TRUE);
	}
	EquipShields();
	TimeOutTimer = WorldInfo.TimeSeconds;
	`SleepUntil(MembersAreInPosition() || (`TimeSince(TimeOutTimer) > 5.0f) );
	`log("all members in position"@`showvar(RowCount)@`showvar(Members.Length)@`showvar(RowSize),bDebugFormation);
	if (LookAtGoal != None)
	{
		bRotatingFormation = TRUE;
		DesiredYaw = rotator(LookAtGoal.Location - Location).Yaw;
		`SleepUntil(DesiredYaw == Rotation.Yaw && MembersAreInPosition());
		bRotatingFormation = FALSE;
	}
	Stop;

EngageFireTarget:
	LeaderAI.PossiblyPickFireTarget();
	if (LeaderAI.FireTarget != None)
	{
		SetFireTarget(LeaderAI.FireTarget);
		if (!IsFireTargetVisible())
		{
			PathGoal = FireTarget;
			PushState('PathToGoal');
			Goto('EngageFireTarget');
		}
		`SleepUntil(IsFacingFireTarget());
		if (FireTarget == None)
		{
			// might have lost our target, recheck
			Goto('EngageFireTarget');
		}
		`log("engaging fire target"@VSize(Location - FireTarget.Location),bDebugFormation);
		if (VSize(Location - FireTarget.Location) > 2048.f)
		{
			AdvanceFormation();
			TimeOutTimer = WorldInfo.TimeSeconds;
			`SleepUntilEx( ((DesiredLocation == Location && MembersAreInPosition())) || (`TimeSince(TimeOutTimer) > 5.0f) ,1.f);
		}
		else if (VSize(Location - FireTarget.Location) < 512.f)
		{
			//DisbandFormation();
		}
		else
		{
			Goto('OpenFire');
		}
	}

	else
	{
		if (FireTarget != None && !IsFireTargetVisible())
		{
			PathGoal = FireTarget;
			PushState('PathToGoal');
		}
		else if(( PathGoal != none ) || (VSize(PathGoalLocation) != 0 ) )
		{
			`log( "formation: did not have a firetarget but did have a goal so let's move!" );
			PushState('PathToGoal');
		}
		Sleep(1.f);
	}
	Goto('EngageFireTarget');

OpenFire:
	`log("staggering formation",bDebugFormation);
	ColSpacing = 256;
	bStaggerRows = TRUE;
	CalculatePositions(TRUE);
	`SleepUntilEx(MembersAreInPosition(),1.f);
	`log("opening fire",bDebugFormation);
	do
	{
		`log("firing at target"@VSize(Location - FireTarget.Location),bDebugFormation);
		StartFiring();
		Sleep(2.5f);
	} until(!IsFacingFireTarget() || !IsFireTargetInRange() || !IsFireTargetVisible());
	StopFiring();
	`log("closing formation",bDebugFormation);
	ColSpacing = 192;
	bStaggerRows = FALSE;
	CalculatePositions(TRUE);
	`SleepUntilEx(MembersAreInPosition(),1.f);
	Goto('EngageFireTarget');

Idle:
	Stop;
}

state PathToGoal
{
	function PushedState()
	{
		bMovingAlongPath = TRUE;
		RallyGoal = None;
	}
	
	function PoppedState()
	{
		local NanoAI Member;

		bRotatingFormation = FALSE;
		bMovingAlongPath = FALSE;
		PathGoal = None;
		PathGoalLocation = vect(0,0,0);
		RallyGoal = None;
		RallyGoalLocation = vect(0,0,0);
		ClearLatentAction(class'SeqAct_AIMoveToActor');
		MovementSpeedModifier = default.MovementSpeedModifier;

		// so when we get everyone to the goal we sometimes have residual velocity so we want to make certain everyone stops
        foreach Members( Member )
        {
			if( Member.Pawn != none )
			{
			    Member.Pawn.Velocity = vect(0,0,0);
			}
        }
	}

	function SetRallyPoint(Actor NewGoal, vector NewGoalLocation)
	{
		local NanoAI Member;
		local Rotator NewRot;
		RallyGoal = NewGoal;
		RallyGoalLocation = NewGoalLocation;
		// move the formation immediately
		DesiredLocation = RallyGoalLocation;
		DesiredLocation.Z = Location.Z;
		SetLocation(DesiredLocation);
		if (RallyGoal != None)
		{
			DesiredYaw = RallyGoal.Rotation.Yaw;
			NewRot = Rotation;
			NewRot.Yaw = DesiredYaw;
			SetRotation(NewRot);
		}
		// and move the members to their new spots
		foreach Members(Member)
		{
			`log("Sending"@`showvar(Member)@"to"@GetPositionLocation(Member.FormationPosition)@`showvar(Member.FormationPosition),bDebugFormation);
			class'NanoAICmd_Move'.static.MoveTo(Member,GetPositionLocation(Member.FormationPosition));
		}
	}

	function bool CanDirectlyMoveTo(vector TestLocation)
	{
		return FastTrace(TestLocation,Location,vect(1,1,0) * FormationExtent,FALSE);
	}

Begin:
	if (PathGoal != None)
	{
		PathGoalLocation = PathGoal.Location;
	}

	if (CanDirectlyMoveTo(PathGoalLocation))
	{
		`log("direct move",bDebugFormation);
		NextMoveLocation = PathGoalLocation;
		DesiredYaw = rotator(NextMoveLocation - Location).Yaw;
		if (VSize2D(NextMoveLocation - Location) > 32.f && (vector(Rotation) dot Normal(NextMoveLocation - Location)) < 0.4)
		{
			bRotatingFormation = TRUE;
			`log("- turning towards move location"@VSize2D(NextMoveLocation - Location)@`showvar(NextMoveLocation),bDebugFormation);
			// wait till the formation is facing the next move location
			//`SleepUntil((vector(Rotation) dot Normal(NextMoveLocation - Location)) > 0.4 && MembersAreInPosition(),`log(`showvar(DesiredYaw)@"angle:"@(vector(Rotation) dot Normal(NextMoveLocation - Location)),bDebugFormation));
			bRotatingFormation = FALSE;
		}
		DesiredLocation = NextMoveLocation;
		`log( "sleeping until members are in position" @ `showvar(DesiredLocation) );
		//`SleepUntil(DesiredLocation == Location && MembersAreInPosition());
		if (LookAtGoal != None)
		{
			bRotatingFormation = TRUE;
			DesiredYaw = rotator(LookAtGoal.Location - Location).Yaw;
			`log( "sleeping until members are in position" @ `showvar(DesiredYaw) );
			//`SleepUntil(DesiredYaw == Rotation.Yaw && MembersAreInPosition());
			bRotatingFormation = FALSE;
		}
		PopState();
	}

	`log("pathing to"@`showvar(PathGoal)@`showvar(PathGoalLocation),bDebugFormation);
	if (NavHandle == None)
	{
		NavHandle = new(self) class'NavigationHandle';
	}
	NavHandle.ClearConstraints();
	if (PathGoal != None)
	{
		class'NavMeshPath_Toward'.static.TowardGoal( NavHandle, PathGoal );
		class'NavMeshGoal_At'.static.AtActor( NavHandle, PathGoal, 512.f, TRUE );
	}
	else
	{
		class'NavMeshPath_Toward'.static.TowardPoint( NavHandle, PathGoalLocation );
		class'NavMeshGoal_At'.static.AtLocation( NavHandle, PathGoalLocation, 512.f, TRUE );
	}

	// @TODO:  for this we need to path from the start to the goal with the maxExtent( all members ) and bias that path
	// search with looking for edges that are near our formation extent's width
	//   for lines this will work then
	//   for trains/2xN column this will semi work as at least the head goes through
	// so after that, we will have a valid path.  
	// then we do GetNextLocation and test to see if we can fit our formation (to test we need a native function that then calls FNavMeshEdgeBase::Supports()
	//  if we can we just move
	//  if we can't then we need to reduce our formation width / size down some until we are just a single file line
	//      OR just go every man for themselves using our rallypoint system
    //
	// polish:  make it so we form into our formation at the earliest opportunity
	//          make use of the GetValidPositionsForBox to find locations where we can go that are close to our formation

	if (!NavHandle.FindPath())
	{
		`log("no path for formation, rallying",bDebugFormation);
		// tell everyone to rally at the goal point
		SetRallyPoint(PathGoal,PathGoalLocation);
		`SleepUntilEx(MembersAreInPosition(),1.f);
		`log("everyone at goal",bDebugFormation);

		PopState();
	}

	NavHandle.SetFinalDestination(PathGoalLocation);
	
	`log("following path to"@`showvar(PathGoal)@`showvar(PathGoalLocation),bDebugFormation);
	while (NavHandle.GetNextMoveLocation(NextMoveLocation,0))
	{
		// check to see if we're close enought to the goal
		if (VSize2D(Location - PathGoalLocation) < 128.f)
		{
			if (PathGoal != None)
			{
				DesiredYaw = PathGoal.Rotation.Yaw;
			}
			`log("reached goal",bDebugFormation);
			PopState();
		}
	
		DesiredYaw = rotator(NextMoveLocation - Location).Yaw;
		
		if (VSize2D(NextMoveLocation - Location) > 32.f && (vector(Rotation) dot Normal(NextMoveLocation - Location)) < 0.4)
		{
			bRotatingFormation = TRUE;
			`log("- turning towards next move location"@VSize2D(NextMoveLocation - Location)@`showvar(NextMoveLocation),bDebugFormation);
			// wait till the formation is facing the next move location
			`SleepUntil((vector(Rotation) dot Normal(NextMoveLocation - Location)) > 0.4 && MembersAreInPosition(),`log(`showvar(DesiredYaw)@"angle:"@(vector(Rotation) dot Normal(NextMoveLocation - Location)),bDebugFormation));
			bRotatingFormation = FALSE;
		}
		
		// now move everyone to it
		DesiredLocation = NextMoveLocation;
		
		`log("- moving towards next move location"@`showvar(NextMoveLocation),bDebugFormation);
		`SleepUntil(DesiredLocation == Location && MembersAreInPosition());
		// check for early out
		if (bAllowCombat && FireTarget != None && IsFireTargetVisible())
		{
			`log("fire target visible early",bDebugFormation);
			PopState();
		}
	}

	
	`log("no more move locations");
	
	Sleep(0.5f);
	Goto('Begin');
}

function DisbandFormation()
{
	local NanoAI Member;
	foreach Members(Member)
	{
		Member.SetFormationPosition(None,INDEX_NONE);
		Member.GotoState('Combat');
	}
	Members.Length = 0;
	Destroy();
}

function RotateFormation(int RotationOffset)
{
	DesiredYaw = Rotation.Yaw + RotationOffset;
}

function AdvanceFormation()
{
	local float DistToMove;
	if (FireTarget != None)
	{
		DistToMove = VSize(FireTarget.Location - Location) - 1024.f + 128.f;
		DesiredLocation = Location + Normal(FireTarget.Location - Location) * DistToMove;
	}
	else
	{
		DesiredLocation = Location + vector(Rotation) * 512.f;
	}
}

function BuildObstacles()
{
	Obstacles.Length = 0;
	GetObstacles(Obstacles);
}

function GetObstacles(out array<Actor> out_Obstacles)
{
	local NanoAI Member;
	local NanoFormation Formation;
	if (FireTarget != None)
	{
		out_Obstacles.AddItem(FireTarget);
	}
	foreach DynamicActors(class'NanoFormation',Formation)
	{
		if (Formation == self || VSize2D(Formation.Location - Location) < 4096.f)
		{
			foreach Formation.Members(Member)
			{
				if (Member.Pawn != None && Member.Pawn.Health > 0)
				{
					out_Obstacles.AddItem(Member.Pawn);
				}
			}
	    }
	}
}

function Tick(float DeltaTime)
{
	local int Idx;
	local rotator NewRot, DesiredRot;
	local vector NewLoc, DeltaLoc;
	local NanoAI Member;
	local NanoPawnBase MemberPawn;
	local float DistToGoal, InterpSpeed;

	if (bDebugFormation)
	{
		FlushPersistentDebugLines();
		for (Idx = 0; Idx < Positions.Length; Idx++)
		{
			DrawDebugBox(GetPositionLocation(Idx),vect(16,16,16),0,255,0,TRUE);
		}
		DrawDebugBox(Location,vect(32,32,32),255,255,0,TRUE);
		DrawDebugBox(Location,FormationExtent,255,255,0,TRUE);
		DrawDebugLine(Location,NextMoveLocation,0,0,255,TRUE);
		DrawDebugBox(NextMoveLocation,vect(32,32,32),0,0,0,TRUE);
	}
	if (Positions.Length > 0)
	{
		MaxMovementSpeed = 9999.f;
		//`log("Calculating avoidance"@WorldInfo.TimeSeconds@`showvar(LastMaxMovementSpeed));
		// calculate velocities for all members to get into position
		foreach Members(Member,Idx)
		{
			if (Member.bInFormation && Member.FormationPosition != INDEX_NONE && Member.MoveTimer <= 0.f)
			{
				MemberPawn = NanoPawnBase(Member.Pawn);
				if (MemberPawn != None)
				{
					// update max movement speed while we're in here
					MaxMovementSpeed = FMin(MaxMovementSpeed,MemberPawn.GroundSpeed * (MemberPawn.bShieldPose ? 0.5f : 1.f));
					NewLoc = GetPositionLocation(Member.FormationPosition);
					DistToGoal = VSize2D(NewLoc - MemberPawn.Location);
					Member.RVOVelocity = MemberPawn.GetAvoidanceVector(Obstacles,NewLoc,MemberPawn.GetCollisionRadius(),VSize(MemberPawn.Velocity),16,0.1,3.f);
					if (DesiredLocation == Location &&
						DistToGoal < MemberPawn.GetCollisionRadius() * 2.f)
					{
						MemberPawn.Velocity = (NewLoc - MemberPawn.Location) * 1/MemberPawn.AvgPhysicsTime;
						MemberPawn.Acceleration = vect(0,0,0);
					}
					else
					{
						MemberPawn.Acceleration = Member.RVOVelocity * MemberPawn.AccelRate * 0.5f;
					}
					// for those with shields figure out if they should be hunkering down
					if (MemberPawn.bHasShield)
					{
						if (bForceShields)
						{
							MemberPawn.bShieldPose = TRUE;
						}
						// only put down shield if running far
						else if (MemberPawn.bShieldPose && (bMovingAlongPath || VSize2D(NewLoc - MemberPawn.Location) > 256.f))
						{
							MemberPawn.bShieldPose = FALSE;
						}
						// and only put up shield when close
						else if (!MemberPawn.bShieldPose && !bMovingAlongPath && VSize2D(NewLoc - MemberPawn.Location) < 128.f)
						{
							MemberPawn.bShieldPose = TRUE;
							MemberPawn.Playsound( ShieldPose_ShieldDownSound );
						}
					}
					if (bDebugFormation)
					{
						DrawDebugLine(MemberPawn.Location,MemberPawn.Location + MemberPawn.Velocity * 0.5f,255,0,0,TRUE);
						DrawDebugLine(MemberPawn.Location,MemberPawn.Location + Member.RVOVelocity * 0.5f,0,0,255,TRUE);
						DrawDebugLine(MemberPawn.Location,Member.GetDestinationPosition(),0,255,0,TRUE);
						DrawDebugLine(MemberPawn.Location,BP2Vect(Member.NavigationHandle.FinalDestination),128,0,128,TRUE);
					}
				}
			}
		}
		// if not turning the formation then limit the overall movement speed
		if (!bRotatingFormation)
		{
			MaxMovementSpeed *= MovementSpeedModifier;
		}
	}
	// update rotation to firetarget location
	if (!bMovingAlongPath && FireTarget != None)
	{
		`log(`location@`showvar(FireTarget));
		DesiredYaw = rotator(FireTarget.Location - Location).Yaw;
	}
	// interp rotation
	if (Rotation.Yaw != DesiredYaw)
	{
		NewRot = Rotation;
		DesiredRot = Rotation;
		DesiredRot.Yaw = DesiredYaw;
		NewRot = RInterpTo(Rotation,DesiredRot,DeltaTime,YawInterpRate,TRUE);
		SetRotation(NewRot);
	}
	// interp location
	DesiredLocation.Z = Location.Z;
	if (DesiredLocation != Location)
	{
		InterpSpeed = FMin(MaxMovementSpeed,LocationInterpRate);
		DeltaLoc = DesiredLocation - Location;
		if (VSize(DeltaLoc) < InterpSpeed * DeltaTime * MovementSpeedModifier)
		{
			NewLoc = DesiredLocation;
		}
		else
		{
			NewLoc = Location + Normal(DeltaLoc) * InterpSpeed * DeltaTime * MovementSpeedModifier;
		}
		SetLocation(NewLoc);
	}
}

function ScareCrowds()
{
	local GameCrowdAgent Agent;
	local vector ScareOrigin;
	ScareOrigin = Location + vector(Rotation) * LocationInterpRate * 0.5f;
	foreach DynamicActors(class'GameCrowdAgent',Agent)
	{
		if (VSize2D(Agent.Location - ScareOrigin) < 512.f || VSize2D(Agent.Location - Location) < 512.f)
		{
			Agent.SetPanic(self,TRUE);
		}
	}
}

defaultproperties
{
    DesiredRowSize=3
	YawInterpRate=20000
	LocationInterpRate=900
	RowSpacing=256
	ColSpacing=256
	MovementSpeedModifier=1.f
	bAllowCombat=TRUE

	bDebugFormation=TRUE

	ShieldPose_ShieldDownSound=SoundCue'Foley_Body.MetaCorps.Trooper_ShieldSlam_Cue' 
}
