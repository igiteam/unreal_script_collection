/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Destination used with the NanoIntersectionManager.  Records a list of crowd members departing for other crosswalk destination, so they can reach their destinations before traffic
 * is allowed to pass
 */
class NanoCrosswalkDestination extends GameCrowdDestination;

var transient   NanoIntersectionManager     IntersectionManager;

simulated function PickNewDestinationFor(GameCrowdAgent Agent, bool bIgnoreRestrictions )
{
	local NanoCrosswalkDestination NCD;

	Super.PickNewDestinationFor(Agent, bIgnoreRestrictions);

	// Check to see if this agent was sent to another crosswalk destination managed by our manager
	NCD = NanoCrosswalkDestination(Agent.CurrentDestination);
	if( (NCD != None) && (IntersectionManager != None) && (NCD.IntersectionManager == IntersectionManager) )
	{
		IntersectionManager.IncrementCrossingAgentCount();
	}
}

simulated event ReachedDestination(GameCrowdAgent Agent)
{
	local NanoCrosswalkDestination NCD;

	// Check to see if this agent came from another crosswalk destination governed by our manager
	NCD = NanoCrosswalkDestination(Agent.PreviousDestination);

	if( (NCD != None) && (IntersectionManager != None) && (NCD.IntersectionManager == IntersectionManager) )
	{
		IntersectionManager.DecrementCrossingAgentCount();
	}

	Super.ReachedDestination(Agent);

	// To keep the count from growing out of control, if we can't find a new destination (i.e. isolated node), kill the agent
	if( Agent != None && Agent.CurrentDestination == self )
	{
		`log("Killing agent for invalid path..." $ self);
		Agent.CurrentDestination = None;
		Agent.KillAgent();
	}
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.Crowd.T_Crowd_Crosswalk'
		Scale=0.5f
	End Object
}