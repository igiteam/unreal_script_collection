/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class AIAvoidanceCylinder extends Actor
	placeable
	native(TGAI)
	implements(AIObjectAvoidanceInterface)
	dependson(AIAvoidanceCylinderComponent);

var() bool bEnabled;

var() editconst const AIAvoidanceCylinderComponent AvoidanceComp;

var() TGTeamInfo.ETGTeam TeamThatShouldFleeMe;

// for history, so we can track where they're coming from
var name OwnerName;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function private native ForceReTouch();

simulated function PostBeginPlay()
{	
	AvoidanceComp.TeamThatShouldFleeMe = TeamThatShouldFleeMe;
	SetEnabled(bEnabled);
	Super.PostBeginPlay();
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled= true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled= false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;
	}

	SetEnabled(bEnabled);

}

function SetEnabled(bool bInEnabled)
{
	bEnabled = bInEnabled;
	AvoidanceComp.SetActorCollision(bEnabled,false,bEnabled);
	AvoidanceComp.SetEnabled(bEnabled);
	SetCollision(bEnabled);
}

function SetCylinderSize(float Radius,float Height)
{
	AvoidanceComp.SetCylinderSize(Radius,Height);
}

function SetAvoidanceTeam(ETGTeam TeamThatShouldAvoid)
{
	TeamThatShouldFleeMe = TeamThatShouldAvoid;
	AvoidanceComp.TeamThatShouldFleeMe = TeamThatShouldFleeMe;
}

event BaseChange()
{
	Super.BaseChange();
	
	if(Base != none)
	{
		OwnerName = Base.Name;
	}
}

/*
event Tick(float DeltaTime )
{
	local vector Offset;
	Super.Tick(DeltaTime);
	if(bEnabled)
	{
		Offset.Z = AvoidanceComp.CollisionHeight/2.f;
		DrawDebugCylinder(Location - Offset,Location+Offset,AvoidanceComp.CollisionRadius,10,255,0,0);
	}
}*/

function bool ShouldAvoid(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local AIobjectAvoidanceInterface AvoidInt;
	// if we're based on something which implements this interface, let it arbitrate who should avoid
	if(Base != none)
	{
		AvoidInt = AIobjectAvoidanceInterface(Base);

		if(AvoidInt != none)
		{
			return AvoidInt.ShouldAvoid(AskingAI,TriggeringComponent);
		}
	}
	return true;
}

function bool ShouldEvade(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local AIobjectAvoidanceInterface AvoidInt;
	// if we're based on something which implements this interface, let it arbitrate who should avoid
	if(Base != none)
	{
		AvoidInt = AIobjectAvoidanceInterface(Base);

		if(AvoidInt != none)
		{
			return AvoidInt.ShouldEvade(AskingAI,TriggeringComponent);
		}
	}
	return false;
}

function bool ShouldRoadieRun(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local AIobjectAvoidanceInterface AvoidInt;
	// if we're based on something which implements this interface, let it arbitrate who should avoid
	if(Base != none)
	{
		AvoidInt = AIobjectAvoidanceInterface(Base);

		if(AvoidInt != none)
		{
			return AvoidInt.ShouldRoadieRun(AskingAI,TriggeringComponent);
		}
	}
	return true;
}


