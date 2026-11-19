class SkySeqAct_SetAvaBattleVO extends SequenceAction;

var() bool bAvaIsPilotAIInCurrentBattle;

event Activated()
{
    local SkyGame Info;

    // End:0x49
    if(GetWorldInfo() != none)
    {
        Info = SkyGame(GetWorldInfo().Game);
        // End:0x49
        if(Info != none)
        {
            Info.bAvaIsPilotAIInCurrentBattle = bAvaIsPilotAIInCurrentBattle;
        }
    }
    //return;    
}
