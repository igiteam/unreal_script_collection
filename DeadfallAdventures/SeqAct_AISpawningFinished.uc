class SeqAct_AISpawningFinished extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    // End:0x7A
    if(InputLinks[0].bHasImpulse)
    {
        AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bDirectorSpawningFinished = true;        
    }
    else
    {
        // End:0x145
        if(InputLinks[1].bHasImpulse)
        {
            AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PrepareClientAIWallView(false);
            AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bDirectorSpawningFinished = false;
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Activated",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Deactivated",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks=none
    ObjName="Director Spawning Finished"
}