class SeqAct_EndOfSurvivalLevel extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local ADVGame Game;

    Game = ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0xD6
    if(Game != none)
    {
        // End:0xA8
        if(InputLinks[0].bHasImpulse)
        {
            Game.EndGame(none, "SurvivalWin");            
        }
        else
        {
            Game.EndGame(none, "SurvivalLose");
        }
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Win",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Lose",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="End of Survival Level"
}