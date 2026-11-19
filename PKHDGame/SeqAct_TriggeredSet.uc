class SeqAct_TriggeredSet extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() array<int> Values;
var int OutputIndex;

function Activated()
{
    local int J, Value;
    local bool bAllEqual;

    bAllEqual = true;
    J = 0;
    J0x17:

    // End:0x9C [Loop If]
    if(J < Values.Length)
    {
        // End:0x5E
        if(J == 0)
        {
            Value = Values[J];            
        }
        else
        {
            // End:0x8E
            if(Value != Values[J])
            {
                bAllEqual = false;
                // [Explicit Break]
                goto J0x9C;
            }
        }
        J++;
        // [Loop Continue]
        goto J0x17;
    }
    J0x9C:

    // End:0xE0
    if(bAllEqual)
    {
        OutputIndex = Value;
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        OutputIndex = -1;
        OutputLinks[2].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Perform Check",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Correct",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Wrong",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Values",LinkVar="None",PropertyName="Values",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Set Index",LinkVar="None",PropertyName="OutputIndex",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=true,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Triggered Set"
}