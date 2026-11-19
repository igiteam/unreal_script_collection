class TurokFEOptionsAdvanced extends TurokFEPauseOptionsAdvanced
    native;

var @NULL mOverlayEdges[2];
var @NULL mGamertag;

// Export UTurokFEOptionsAdvanced::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEOptionsAdvanced::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsAdvanced::execSelectStorageDevice(FFrame&, void* const)
native function SelectStorageDevice();

event SCInitialized()
{
    local @NULL db;
    local bool isXbox;

    OptionsMenu = TurokUIMenu(Scene.FindChild(name("AdvancedOptionsMenu")));
    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    isXbox = Class'Engine.Engine'.static.IsXenon();
    // End:0xAB
    if(isXbox && (db != none) && db.GetSignedInProfile() != none)
    {
        OptionsMenu.SetItemDelegate(3, SelectStorageDevice);        
    }
    else
    {
        // End:0xCD
        if(isXbox)
        {
            OptionsMenu.DisableItem(3, true);            
        }
        else
        {
            OptionsMenu.DisableItem(3, false);
        }
    }
    super.SCInitialized();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -412331001);
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

event bool SCInputKey_OptionsAdvanced(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = super.SCInputKey_OptionsAdvanced(ControllerId, Key, Event, AmountDepressed);
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
    SceneName="TurokFEOptions.AdvancedGroup.Advanced"
}