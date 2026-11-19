class SeqAct_TreasureFlare extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvTreasureTrigger_Base TreasureActor;

event Activated()
{
    // End:0x11
    if(TreasureActor == none)
    {
        return;
    }
    // End:0xFF
    if(!TreasureActor.bCollected)
    {
        // End:0x7A
        if(InputLinks[0].bHasImpulse)
        {
            TreasureActor.SetFlareEnabled(true);            
        }
        else
        {
            // End:0xBF
            if(InputLinks[1].bHasImpulse)
            {
                TreasureActor.SetFlareEnabled(false);                
            }
            else
            {
                TreasureActor.SetFlareEnabled(!TreasureActor.bFlareVisible);
            }
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TreasureTrigger Actor",LinkVar="None",PropertyName="TreasureActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle Treasure Flare"
}