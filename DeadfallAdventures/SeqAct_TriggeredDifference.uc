class SeqAct_TriggeredDifference extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

struct ValuesSet
{
    var() int OffsetValue1;
    var() int OffsetValue2;

    structdefaultproperties
    {
        OffsetValue1=0
        OffsetValue2=0
    }
};

var() array<ValuesSet> Set;
var int OutputIndex;
var() array<int> Values;

function Activated()
{
    local int J, SetNo, Value1, Value2, Value3;

    local bool bCorrect;

    bCorrect = false;
    Value1 = Values[0];
    Value2 = Values[1];
    Value3 = Values[2];
    // End:0x68
    if(Value2 <= 0)
    {
        Value2 += 8;
    }
    // End:0x84
    if(Value3 <= 0)
    {
        Value3 += 8;
    }
    // End:0xB5
    if(Value2 < Value1)
    {
        Value2 += 8;
        Value3 += 8;
    }
    // End:0xD9
    if(Value3 < Value2)
    {
        Value3 += 8;
    }
    J = 0;
    J0xE4:

    // End:0x1AC [Loop If]
    if(J < Set.Length)
    {
        // End:0x19E
        if(((Value2 - Value1) == Set[J].OffsetValue1) && (Value3 - Value2) == Set[J].OffsetValue2)
        {
            SetNo = J;
            bCorrect = true;
            // [Explicit Break]
            goto J0x1AC;
        }
        J++;
        // [Loop Continue]
        goto J0xE4;
    }
    J0x1AC:

    // End:0x1F0
    if(bCorrect)
    {
        OutputIndex = SetNo;
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
    ObjName="Triggered Difference"
}