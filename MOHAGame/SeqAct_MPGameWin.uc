class SeqAct_MPGameWin extends SequenceAction
    hidecategories(Object);

var() int winningTeamIndex;

event Activated()
{
    local MOHAMultiplayerGameInfo Game;

    Game = MOHAMultiplayerGameInfo(GetWorldInfo().Game);
    // End:0x3D
    if(Game != none)
    {
        Game.TriggerWin(winningTeamIndex);
    }
    //return;    
}

defaultproperties
{
    winningTeamIndex=255
    ObjName="MP Game Win"
    ObjCategory="MPGame"
}