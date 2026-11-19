/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AIAvoidanceCylinder extends Actor
	placeable
	native(AI)
	implements(AIObjectAvoidanceInterface)
	dependson(AIAvoidanceCylinderComponent);

var() bool bEnabled;

var() editconst const AIAvoidanceCylinderComponent AvoidanceComp;

var() GearTeamInfo.EGearTeam TeamThatShouldFleeMe;

/** should AI fleeing this cylinder dive-roll out of it? */
var() bool bShouldEvade;

// for history, so we can track where they're coming from
var name OwnerName;

cpptext
{
#if WITH_EDITOR
	// AActor interface.
	virtual void EditorApplyScale(const FVector& DeltaScale, const FMatrix& ScaleMatrix, const FVector* PivotLocation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown);
#endif

	// default is to return event.. but can be overidden to allow quick returns on native classes
	virtual UAIAvoidanceCylinderComponent* GetAIAvoidanceCylinderComponent()
	{
		return AvoidanceComp;
	}

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL Verify()
	{
		return !IsPendingKill();
	}
}

// AIObjectAvoidanceInterface
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	return AvoidanceComp;
}

function private native ForceReTouch();

simulated function PostBeginPlay()
{	
	AvoidanceComp.TeamThatShouldFleeMe = TeamThatShouldFleeMe;
	SetEnabled(bEnabled);
	Super.PostBeginPlay();
	//DrawDebugCylinder(Location-vect(0,0,500),Location+vect(0,0,500),AvoidanceComp.CollisionRadius,6,255,0,0,TRUE);
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
	// set the flag first so that conditionalrelink gets the memo
	AvoidanceComp.SetEnabled(bEnabled);
	AvoidanceComp.SetActorCollision(bEnabled,false,bEnabled);
	SetCollision(bEnabled);
}

/**
 * setter for dontlinktomesh on the avoidance component.
 * Use this to indicate that this avoidance comp should not affect the navmesh 
 * @param bDontAffectMesh - whether or not this avoidance comp should be exempt from navmesh updates
 */
function SetDontAffectMesh(bool bDontAffectMesh)
{
	AvoidanceComp.bDontLinkToMesh = bDontAffectMesh;
}

function SetCylinderSize(float Radius,float Height)
{
	AvoidanceComp.SetCylinderSize(Radius,Height);
}

function SetAvoidanceTeam(EGearTeam TeamThatShouldAvoid)
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

simulated event Destroyed()
{
	Super.Destroyed();
	AvoidanceComp.SetEnabled(FALSE);
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

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
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

function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
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
	return bShouldEvade;
}

function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
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

function CoupleLifetime(Interface_NavMeshPathObstacle PO);
defaultproperties
{
	bEnabled=false

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=AIAvoidanceCylinderComponent Name=AvoidanceCollisionCylinder
		CollisionRadius=+00100.000000
		CollisionHeight=+0078.000000
		bEnabled=FALSE
	End Object
	CollisionComponent=AvoidanceCollisionCylinder
	AvoidanceComp=AvoidanceCollisionCylinder
	Components.Add(AvoidanceCollisionCylinder)


	bHidden=true
	bCollideActors=true
	bBlockActors=false
	bStatic=false
	bNoDelete=false

	TeamThatShouldFleeMe=TEAM_EVERYONE
}