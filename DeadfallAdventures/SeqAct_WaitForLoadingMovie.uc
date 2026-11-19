class SeqAct_WaitForLoadingMovie extends SeqAct_Latent
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    super(SequenceOp).Activated();
    //return;    
}

event PauseUntilKeyPressed()
{
    local WorldInfo WorldInfo;
    local AdvGameSP ADVGame;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    ADVGame = AdvGameSP(WorldInfo.Game);
    // End:0x88
    if(ADVGame != none)
    {
        ADVGame.PauseAndWaitForKeyPress();
    }
    //return;    
}

event UnpauseAfterKeyPressed()
{
    //return;    
}

defaultproperties
{
    ObjName="Wait For Loading Movie"
}