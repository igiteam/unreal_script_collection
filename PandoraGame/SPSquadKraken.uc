class SPSquadKraken extends SPSquad
    native;

function bool DoesSquadRequireAdvancedNoticeOfEnemiesInDefendArea(SPSquad.ESPSquadCommandPriority commandPriority)
{
    return int(commandPriority) == int(3);
    //return ReturnValue;    
}
