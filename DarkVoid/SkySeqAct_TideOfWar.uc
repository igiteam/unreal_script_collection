class SkySeqAct_TideOfWar extends SequenceAction;

var() array<s_TeamRivalInfo> TeamRivalList;

event Activated()
{
    local SkyGame SG;

    SG = SkyGame(GetWorldInfo().Game);
    SG.RivalInfo.SetRivalries(TeamRivalList);
    //return;    
}
