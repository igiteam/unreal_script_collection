class SPPlayerCameraActor extends CameraActor
    native;

var PlayerController CurrentPC;
var() bool bKeepPostProcessOverride;

// Export USPPlayerCameraActor::execGetCurrentPC(FFrame&, void* const)
native function PlayerController GetCurrentPC();

// Export USPPlayerCameraActor::execUpdatePC(FFrame&, void* const)
native function UpdatePC();

// Export USPPlayerCameraActor::execGetInterpAction(FFrame&, void* const)
native function SeqAct_Interp GetInterpAction();

// Export USPPlayerCameraActor::execInterpolationStarted(FFrame&, void* const)
native simulated event InterpolationStarted(SeqAct_Interp InterpAction);

// Export USPPlayerCameraActor::execInterpolationFinished(FFrame&, void* const)
native simulated event InterpolationFinished(SeqAct_Interp InterpAction);

// Export USPPlayerCameraActor::execInterpolationChanged(FFrame&, void* const)
native simulated event InterpolationChanged(SeqAct_Interp InterpAction);

simulated function OnToggle(SeqAct_Toggle Action)
{
    local bool bEnableOverride;
    local PlayerController PC;
    local LocalPlayer LP;

    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnableOverride = true;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnableOverride = false;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnableOverride = !bCamOverridePostProcess;
            }
        }
    }
    PC = GetCurrentPC();
    // End:0xDD
    if(PC != none)
    {
        LP = LocalPlayer(PC.Player);
        // End:0xDD
        if(LP != none)
        {
            LP.bOverridePostProcessSettings = bEnableOverride;
        }
    }
    //return;    
}
