//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGameCrowdDestination extends GameCrowdDestination;

/** how long to wait before killing agent when it isn't visible */
var() float NotVisibleLifeSpan;

/** probability(0~1) which kill crowd when they reach this destination. (Play Death Animation)*/
var() float RandomKill;

/**
  * Called after Agent reaches this destination
  * Will be called every tick as long as ReachedBy() is true and agent is not idle, so should change
  * Agent to avoid this (change current destination, make agent idle, or kill agent) )
  *
  * @PARAM Agent is the crowd agent that just reached this destination
  * @PARAM bIgnoreKismet skips generating Kismet event if true.
  */
simulated event ReachedDestination(GameCrowdAgent Agent)
{
    if(NotVisibleLifeSpan >= 0.f)
    {
        //See AGameCrowdAgent::ShouldPerformCrowdSimulation
        Agent.NotVisibleLifeSpan = NotVisibleLifeSpan;
        Agent.MaxLOSLifeDistanceSq = 225; //3m
    }

    if(Agent.BehaviorDestination != self && RandomKill > 0.0 && RandomKill >= FRand())
    {
        Agent.TakeDamage(100, none, Agent.Location, vector(Agent.Rotation) * -100, none);

	    DecrementCustomerCount(Agent);
		Agent.CurrentDestination = None;
		return;
    }

    Super.ReachedDestination(Agent);
}

