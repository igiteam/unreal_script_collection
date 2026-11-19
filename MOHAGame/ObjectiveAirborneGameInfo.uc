class ObjectiveAirborneGameInfo extends ObjectiveGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

function bool CanRespawn(MOHAPlayerController C)
{
    return false;
    //return ReturnValue;    
}

function bool CheckIfTeamEliminated()
{
    return false;
    //return ReturnValue;    
}

function Reset()
{
    super.Reset();
    RespawnTimer = SecondsBetweenRespawn;
    //return;    
}

defaultproperties
{
    BestToNumberOfRoundsInRanked=2
    SecondsBetweenRespawn=30
    HUDType=Class'HUDObjectiveAirborne'
    GameReplicationInfoClass=Class'ObjectiveAirborneGameReplicationInfo'
}