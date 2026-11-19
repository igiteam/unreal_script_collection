class SkySeqEvent_GameEnded extends SequenceEvent;

var Actor Winner;

event Activated()
{
    local SkyGame Game;

    Game = SkyGame(GetWorldInfo().Game);
    // End:0x3B
    if(Game != none)
    {
        Winner = Game.EndGameFocus;
    }
    //return;    
}
