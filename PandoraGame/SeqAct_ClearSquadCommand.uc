class SeqAct_ClearSquadCommand extends SequenceAction
    native;

/** Type of squad to select name from // CPP TEXT// (cpptext)// (cpptext)// (cpptext)// (cpptext)// NATIVE FUNCTION DECLARATIONS// FUNCTION DECLARATIONS// FUNCTIONS/STATES//-----------------------------------------------------------------------// Function:// Description:Called from native Activated() function defined above//in cpptext{}//----------------------------------------------------------------------- */
var() export editinline SPSquadSelector SquadType;

function bool ScriptActivated()
{
    local int Idx;
    local SPTeamInfo SPTeamInfo;
    local name squadName;
    local PandoraGameInfo spGameInfo;

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
    Idx = 0;
    J0x3C:

    // End:0xEB [Loop If]
    if(Idx < spGameInfo.m_teams.Length)
    {
        SPTeamInfo = spGameInfo.m_teams[Idx];
        // End:0xE1
        if((SPTeamInfo != none) && SquadType.IsAssociatedWithTeam(SPTeamInfo))
        {
            squadName = SPTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
            SPTeamInfo.ClearSquadCommand(squadName);
        }
        Idx++;
        // [Loop Continue]
        goto J0x3C;
    }
    return true;
    //return ReturnValue;    
}
