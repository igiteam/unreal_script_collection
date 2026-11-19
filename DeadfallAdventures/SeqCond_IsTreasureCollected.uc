class SeqCond_IsTreasureCollected extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var AdvTreasureTrigger_Base TreasureActor;
var() string TreasureID;

event Activated()
{
    local AdvEngine Eng;

    // End:0xB4
    if(TreasureActor == none)
    {
        Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
        // End:0x90
        if(Eng.IsTreasureCollected(TreasureID))
        {
            OutputLinks[0].bHasImpulse = true;            
        }
        else
        {
            OutputLinks[1].bHasImpulse = true;
        }        
    }
    else
    {
        // End:0xFA
        if(TreasureActor.bCollected)
        {
            OutputLinks[0].bHasImpulse = true;            
        }
        else
        {
            OutputLinks[1].bHasImpulse = true;
        }
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Yes",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="No",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TreasureTrigger Actor",LinkVar="None",PropertyName="TreasureActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Is Treasure Collected"
}