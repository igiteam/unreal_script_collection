class TurokFEExtrasCredits extends TurokUISceneController
    native;

var @NULL mCredits;

// Export UTurokFEExtrasCredits::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event bool SCInputKey_Credits(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // DebugMode: 0
    assert(mCredits != none);
    // End:0x43
    if(mCredits.ProcessInput(ControllerId, Key, Event, AmountDepressed) == true)
    {
        return true;
    }
    // End:0xA6
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x66
            case 'XboxTypeS_B':
            // End:0x72
            case 'MouseXButton1':
            // End:0x7E
            case 'LeftMouseButton':
            // End:0x8A
            case 'Escape':
            // End:0xA3
            case 'BackSpace':
                CloseMenu();
                // End:0xA6
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return EatInput;
        //return ReturnValue;        
    }
}

event SCInitialized()
{
    mCredits = TurokUICredits(Scene.FindChild(name("TurokUICredits")));
    // End:0x50
    if(mCredits != none)
    {
        mCredits.__OnCreditsFinished__Delegate = CloseMenu;
    }
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

event SCTick(float DeltaTime)
{
    // End:0x23
    if(mCredits != none)
    {
        mCredits.Tick(DeltaTime);
    }
    //return;    
}

event SCCleanUpOnExit()
{
    SceneClient = none;
    //return;    
}

function CloseMenu()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEExtras.Credits"
}