class SeqAct_TriggeredSequence extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() array<int> Combination;
var private int NextElement;
var private int CurrentIndex;

function Activated()
{
    local int I;

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
        I = 1;
        J0x82:

        // End:0x17F [Loop If]
        if(I < InputLinks.Length)
        {
            // End:0x171
            if(InputLinks[I].bHasImpulse)
            {
                // End:0x142
                if(I == NextElement)
                {
                    CurrentIndex++;
                    // End:0x122
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
                // [Explicit Break]
                goto J0x17F;
            }
            I++;
            // [Loop Continue]
            goto J0x82;
        }
    }
    J0x17F:

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
    InputLinks[1]=(LinkDesc="Trigger 1",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Trigger 2",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[3]=(LinkDesc="Trigger 3",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[4]=(LinkDesc="Trigger 4",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[5]=(LinkDesc="Trigger 5",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Correct Sequence",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Wrong Step",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks=none
    ObjName="Triggered Sequence"
}