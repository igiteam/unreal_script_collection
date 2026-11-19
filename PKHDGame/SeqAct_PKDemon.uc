class SeqAct_PKDemon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var(DemonMode) float TimeOut;

event Activated()
{
    local PKGameSP Game;

    Game = PKGameSP(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x155
    if(Game != none)
    {
        // End:0xA4
        if(InputLinks[0].bHasImpulse)
        {
            Game.StartDaemonMode(TimeOut);            
        }
        else
        {
            // End:0xE8
            if(InputLinks[1].bHasImpulse)
            {
                Game.StopDaemonMode();                
            }
            else
            {
                // End:0x12C
                if(Game.IsDeamonMode())
                {
                    Game.StopDaemonMode();                    
                }
                else
                {
                    Game.StartDaemonMode(TimeOut);
                }
            }
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks=none
    ObjName="Toggle Demon Mode"
}