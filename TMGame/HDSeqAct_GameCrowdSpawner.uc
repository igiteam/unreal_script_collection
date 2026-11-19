//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_GameCrowdSpawner extends SeqAct_GameCrowdSpawner
native(HDSequence);

/*When CleanUp(removed/unloaded), kill all*/
var() bool bKillAllWhenCleanUp;
var() int  Health;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function GameCrowdAgent CreateNewAgent(Actor SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup)
{
    local GameCrowdAgent	Agent;

    Agent = Super.CreateNewAgent(SpawnLoc, AgentTemplate, NewGroup);
    if(Agent != none && Health > 0)
    {
        Agent.Health = Health;
    }

    return Agent;
}

