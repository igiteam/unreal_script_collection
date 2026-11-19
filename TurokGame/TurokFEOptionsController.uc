class TurokFEOptionsController extends TurokFEPauseOptionsController
    native;

var @NULL mOverlayEdges[2];
var @NULL mGamertag;

// Export UTurokFEOptionsController::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEOptionsController::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    super.SCInitialized();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

event SCTick(float DeltaTime)
{
    super(TurokUISceneController).SCTick(DeltaTime);
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    super.SCCleanUpOnExit();
    I = 0;
    J0x0D:

    // End:0x49 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    mGamertag = none;
    //return;    
}

event bool SCInputKey_OptionsController(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = super.SCInputKey_OptionsController(ControllerId, Key, Event, AmountDepressed);
    return EatInput;
    //return ReturnValue;    
}

function ExitComplete()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEOptions.ControllerGroup.Controller"
}