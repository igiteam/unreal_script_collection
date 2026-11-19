class SeqAct_Stopwatch extends SequenceAction
    native
    hidecategories(Object);

var() int startVal;
var() int endVal;
var() bool bCountdown;
var() bool bShowTimeOnHUD;
var bool bRunning;
var bool bPaused;
var int outputTime;
var float CurrentTime;

// Export USeqAct_Stopwatch::execSetRunning(FFrame&, void* const)
native function SetRunning(bool bIsRunning);

event Pause()
{
    SetRunning(false);
    bPaused = true;
    //return;    
}

event Stop()
{
    SetRunning(false);
    CurrentTime = float(startVal);
    outputTime = startVal;
    bPaused = false;
    //return;    
}

event Start()
{
    // End:0x0B
    if(bRunning)
    {
        return;
    }
    // End:0x4D
    if((bCountdown && endVal > startVal) || !bCountdown && endVal < startVal)
    {
        bRunning = false;
        return;
    }
    // End:0x70
    if(!bPaused)
    {
        CurrentTime = float(startVal);
        outputTime = startVal;
    }
    SetRunning(true);
    bPaused = false;
    //return;    
}

defaultproperties
{
    startVal=10
    bCountdown=true
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Stop & Reset",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[2]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    OutputLinks[0]=(Links=none,LinkDesc="Ticked",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Current Time",LinkVar="None",PropertyName="outputTime",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="startVal",LinkVar="None",PropertyName="startVal",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="endVal",LinkVar="None",PropertyName="endVal",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Stopwatch"
    ObjCategory="Misc"
}