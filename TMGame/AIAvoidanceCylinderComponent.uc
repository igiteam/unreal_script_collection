/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AIAvoidanceCylinderComponent extends CylinderComponent
	native(TGAI)
	dependson(TGTeamInfo);

var native const Map{ANavigationPoint*,UBOOL} LinkedNavigationPoints;
var native const Map{UReachSpec*,UBOOL} LinkedReachSpecs;
var transient vector LastReLinkLocation;
var() float UpdateThreshold;
var() private bool bEnabled;

var() TGTeamInfo.ETGTeam TeamThatShouldFleeMe;

event ForceReLink()
{
	LastReLinkLocation=GetPosition() + vect(1,0,0) * UpdateThreshold * 10.f;
}

event SetEnabled(bool bInEnabled)
{
	local Actor CurrentTouch;
	local TGAI GAI;
	local TGPawn GP;
	if(!bEnabled && bInEnabled)
	{
		bEnabled = true;
		foreach Owner.Touching(CurrentTouch)
		{
			GP = TGPawn(CurrentTouch);
			if(GP != none)
			{
				GAI = TGAI(GP.Controller);

				if(GAI != none)
				{
					//`log("SetEnabled");
					AIEnteredAvoidanceCylinder(GAI);
				}

			}
		}
	}
	else
	{
		bEnabled = bInEnabled;
	}

}

native final function bool IsNavPointWithin(NavigationPoint Pt);
native final function bool DoesSpecIntersect(ReachSpec Spec);
/** @return whether there are currently any avoidance cylinders that would affect the passed in team
 * (pass TEAM_EVERYONE to return true if any cylinders exist at all)
 */
native static final function bool BuildListOfAffectingCylinders(TGAI AskingAI, out array<AIAvoidanceCylinderComponent> InAffectingCylinders);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function bool ShouldAIAvoidMe(TGAI AskingAI);

// script shouldavoid gets called after all the base conditions are met, gives script another chance to say no, don't call this fromt eh outside
protected event bool InternalShouldAIAvoidMe(TGAI AskingAI)
{
	local AIObjectAvoidanceInterface AvoidInt;

	// if the object implements the interface, and doesn't want an avoid, bail
	AvoidInt = AIObjectAvoidanceInterface(Owner);
	if(AvoidInt != none && !AvoidInt.ShouldAvoid(AskingAI,self))
	{
		return false;
	}

	return true;
}

protected function bool ShouldAIEvade(TGAI AskingAI)
{
	local AIObjectAvoidanceInterface AvoidInt;

	// if the object implements the interface, and doesn't want an avoid, bail
	AvoidInt = AIObjectAvoidanceInterface(Owner);
	if(AvoidInt != none && !AvoidInt.ShouldEvade(AskingAI,self))
	{
		return false;
	}

	return true;
}

protected function bool ShouldAIRoadieRun(TGAI AskingAI)
{
	local AIObjectAvoidanceInterface AvoidInt;

	// if the object implements the interface, and doesn't want an avoid, bail
	AvoidInt = AIObjectAvoidanceInterface(Owner);
	if(AvoidInt != none && !AvoidInt.ShouldRoadieRun(AskingAI,self))
	{
		return false;
	}

	return true;
}

function AIEnteredAvoidanceCylinder(TGAI EnteringAI)
{

	//ScriptTrace();
	//`log(GetFuncname()@EnteringAI);
	if(ShouldAIAvoidme(EnteringAI))
	{
		//if(ShouldAIEvade(EnteringAI))
		//{
		//	EnteringAI.ReactionManager.NudgeChannel(Owner,'EnteredEvadeAvoidanceZone');
		//}
		//else
			if(ShouldAIRoadieRun(EnteringAI))
		{
			EnteringAI.ReactionManager.NudgeChannel(Owner,'EnteredRoadieRunAvoidanceZone');
		}
		else
		{
			EnteringAI.ReactionManager.NudgeChannel(Owner,'EnteredAvoidanceZone');
		}
	}
	
}




