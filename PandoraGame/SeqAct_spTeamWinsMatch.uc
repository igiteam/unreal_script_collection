class SeqAct_spTeamWinsMatch extends SequenceAction
    native;

enum EMPTeamThatWillWin
{
    EMPTeamThatWillWin_1,           // 0
    EMPTeamThatWillWin_2,           // 1
    EMPTeamThatWillWin_MAX          // 2
};

var() SeqAct_spTeamWinsMatch.EMPTeamThatWillWin winningTeam;

event EnterPostGame()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x3B
    if(PGRI != none)
    {
        PGRI.SetIsInPostGame(true);
    }
    //return;    
}
