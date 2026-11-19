class SeqAct_ToggleSplitscreen extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    // End:0x71
    if(InputLinks[0].bHasImpulse)
    {
        Class'Engine.Engine'.static.GetEngine().GameViewport.SetSplitscreenConfiguration(5);        
    }
    else
    {
        Class'Engine.Engine'.static.GetEngine().GameViewport.SetSplitscreenConfiguration(0);
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks=none
    ObjName="Toggle Splitscreen"
}