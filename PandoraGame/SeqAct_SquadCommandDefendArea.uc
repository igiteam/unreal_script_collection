class SeqAct_SquadCommandDefendArea extends SequenceAction
    native;

/** Type of squad to select name from */
var() export editinline SPSquadSelector SquadType;
var() SPSquad.ESPSquadCommandPriority commandPriority;
var() SPSquad.ESPDefendAreaDestAssignment DestinationAssignment;
var() float AttackDistWhileDefendingArea;
var() float attackHeightCheckWhileDefendingArea;

function bool ScriptActivated()
{
    local int Idx;
    local SPTeamInfo SPTeamInfo;
    local name squadName;
    local PandoraGameInfo spGameInfo;
    local SPDefendAreaVolume SPDefendAreaVolume;
    local Trigger_Dynamic trigDynamicVolume;
    local Actor targDefendArea;
    local SPSquad.ESPSquadCommandPriority Priority;
    local SquadCommandDefendArea_Params Params;
    local array<Object> objVars;

    // End:0x0D
    if(SquadType == none)
    {
        return true;
    }
    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x35
    if(spGameInfo == none)
    {
        return true;
    }
    GetObjectVars(objVars, "DefendArea Volume");
    // End:0x61
    if(objVars.Length <= 0)
    {
        return true;
    }
    // End:0x6D
    if(objVars.Length > 1)
    {
    }
    SPDefendAreaVolume = SPDefendAreaVolume(objVars[0]);
    trigDynamicVolume = Trigger_Dynamic(objVars[0]);
    // End:0xBE
    if((SPDefendAreaVolume == none) && trigDynamicVolume == none)
    {
        targDefendArea = Actor(objVars[0]);        
    }
    else
    {
        targDefendArea = none;
    }
    // End:0xEC
    if(((SPDefendAreaVolume == none) && trigDynamicVolume == none) && targDefendArea == none)
    {
        return true;
    }
    Priority = 1;
    // End:0x10F
    if(int(commandPriority) != int(0))
    {
        Priority = commandPriority;
    }
    Params.defendAreaVolume = SPDefendAreaVolume;
    Params.commandPriority = Priority;
    Params.destAssignment = DestinationAssignment;
    Params.AttackDistWhileDefendingArea = AttackDistWhileDefendingArea;
    Params.defendAreaTarget = targDefendArea;
    Params.attackHeightCheckWhileDefendingArea = attackHeightCheckWhileDefendingArea;
    Idx = 0;
    J0x19A:

    // End:0x24E [Loop If]
    if(Idx < spGameInfo.m_teams.Length)
    {
        SPTeamInfo = spGameInfo.m_teams[Idx];
        // End:0x244
        if((SPTeamInfo != none) && SquadType.IsAssociatedWithTeam(SPTeamInfo))
        {
            squadName = SPTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
            SPTeamInfo.IssueCommandDefendAreaToSquad(squadName, Params);
        }
        Idx++;
        // [Loop Continue]
        goto J0x19A;
    }
    return true;
    //return ReturnValue;    
}
