class SeqAct_TriggeredSequenceValues extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() array<int> Combination;
var() int Values;
var private int NextElement;
var private int CurrentIndex;

function Activated()
{
    // End:0x3B
    if((NextElement < 1) || CurrentIndex == -1)
    {
        self.ResetCombination();
    }
    // End:0x77
    if(InputLinks[0].bHasImpulse)
    {
        self.ResetCombination();        
    }
    else
    {
        // End:0xF5
        if(Values == NextElement)
        {
            CurrentIndex++;
            // End:0xD5
            if(CurrentIndex == Combination.Length)
            {
                OutputLinks[0].bHasImpulse = true;                
            }
            else
            {
                NextElement = Combination[CurrentIndex];
            }            
        }
        else
        {
            OutputLinks[2].bHasImpulse = true;
            ResetCombination();
        }
    }
    //return;    
}

function Reset()
{
    super(SequenceOp).Reset();
    ResetCombination();
    //return;    
}

function ResetCombination()
{
    // End:0x30
    if(Combination.Length > 0)
    {
        NextElement = Combination[0];
        CurrentIndex = 0;
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 10;
    //return ReturnValue;    
}

defaultproperties
{
    CurrentIndex=-1
    InputLinks[0]=(LinkDesc="Reset Sequence",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Perform Next Check",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Correct Sequence",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Wrong Step",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Value",LinkVar="None",PropertyName="Values",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Triggered Sequence Values"
}