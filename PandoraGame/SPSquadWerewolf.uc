class SPSquadWerewolf extends SPSquad
    native;

// Export USPSquadWerewolf::execIsEnemyTargetedBySquad(FFrame&, void* const)
native function bool IsEnemyTargetedBySquad(Controller theController, Pawn theEnemy);

function bool DoesSquadRequireAdvancedNoticeOfEnemiesInDefendArea(SPSquad.ESPSquadCommandPriority commandPriority)
{
    return int(commandPriority) == int(3);
    //return ReturnValue;    
}
