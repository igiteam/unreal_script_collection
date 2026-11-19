class SeqAct_GameplayTimerCounter extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0xDB
    if(GRI != none)
    {
        // End:0x9A
        if(InputLinks[0].bHasImpulse)
        {
            GRI.ResumeGameplayTimer();            
        }
        else
        {
            // End:0xDB
            if(InputLinks[1].bHasImpulse)
            {
                GRI.PauseGameplayTimer();
            }
        }
    }
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Start counting",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop counting",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Gameplay timer"
}