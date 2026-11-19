class SeqAct_MPCheckFlagWin extends SequenceAction
    hidecategories(Object);

event Activated()
{
    local ObjectiveGameInfo Game;

    Game = ObjectiveGameInfo(GetWorldInfo().Game);
    // End:0x38
    if(Game != none)
    {
        Game.CheckFlagObjectivesStatus();
    }
    //return;    
}

defaultproperties
{
    ObjName="MP Check Flag Win"
    ObjCategory="MPGame"
}