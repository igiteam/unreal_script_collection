class SeqAct_ToggleLetterbox extends SequenceAction
    native
    hidecategories(Object);

var() float secondsToAnimate;
var() float barScreenPercentHeight;
var() bool bAnimateBars;
var bool bFinished;

function NotifyFinished()
{
    bFinished = true;
    // End:0x34
    if(OutputLinks[1].bDisabled == false)
    {
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

event Activated()
{
    // End:0x2C
    if(OutputLinks[0].bDisabled == false)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    secondsToAnimate=2.6400000
    barScreenPercentHeight=0.0700000
    bAnimateBars=true
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Move In",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Move Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished Anim",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Toggle Letterbox"
    ObjCategory="Toggle"
}