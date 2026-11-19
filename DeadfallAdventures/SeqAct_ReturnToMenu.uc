class SeqAct_ReturnToMenu extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    AdvPlayerController(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].Actor).ReturnToMainMenu(false);
    super(SequenceOp).Activated();
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="Return to Main Menu"
}