class SeqAct_PKSetFlashlight extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local Object O;
    local PKPlayerPawn PP;
    local bool bNewEnabled;

    // End:0x31
    if(InputLinks[0].bHasImpulse)
    {
        bNewEnabled = true;        
    }
    else
    {
        // End:0x5F
        if(InputLinks[1].bHasImpulse)
        {
            bNewEnabled = false;
        }
    }
    PublishLinkedVariableValues();
    // End:0x13A
    foreach Targets(O)
    {
        PP = PKPlayerPawn(O);
        // End:0x110
        if(PP == none)
        {
            // End:0x110
            if(Controller(O) != none)
            {
                PP = PKPlayerPawn(Controller(O).Pawn);
                // End:0x110
                if(PP == none)
                {
                    continue;
                    // [Explicit Continue]
                    goto J0x13A;
                }
            }
        }
        PP.SetFlashlight(bNewEnabled);        
    }
    J0x13A:
    
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle Flashlight"
}