class TurokFEOptionsOverlay extends TurokUISceneController
    native;

var protected @NULL mList;
var protected @NULL mHighlightImage;
var protected @NULL mCurrentDescriptionLabel;
var protected array mDescriptionText;
var protected bool mBlockInput;
var bool bHasFocus;
var @NULL m_OverlayParent;

// Export UTurokFEOptionsOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsOverlay::execSetHasFocus(FFrame&, void* const)
native function SetHasFocus(bool bFocus);

// Export UTurokFEOptionsOverlay::execRefreshList(FFrame&, void* const)
protected native function RefreshList();

// Export UTurokFEOptionsOverlay::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

// Export UTurokFEOptionsOverlay::execSetOverlayParent(FFrame&, void* const)
native function SetOverlayParent(@NULL pOverlayParent);

event SCInitialized()
{
    InitList();
    //return;    
}

event SCTick(float DeltaTime)
{
    mList.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    mList.Deinitialize();
    mList = none;
    SceneClient = none;
    //return;    
}

event bool SCInputKey_OptionsOverlay(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0x1B
    if(mBlockInput == true)
    {
        return EatInput;
    }
    // End:0x59
    if(mList.ProcessInput(ControllerId, Key, Event, AmountDepressed) == true)
    {
        ChangeDescriptionLabel();
        return EatInput;
    }
    // End:0x111
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x7C
            case 'XboxTypeS_X':
            // End:0x8B
            case 'X':
                // End:0x111
                break;
            // End:0x97
            case 'XboxTypeS_A':
            // End:0xB0
            case 'Enter':
                Activate();
                // End:0x111
                break;
            // End:0xD1
            case 'XboxTypeS_Back':
                // End:0xD1
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x111
                    break;
                }
            // End:0xDD
            case 'XboxTypeS_B':
            // End:0xE9
            case 'MouseXButton1':
            // End:0xF5
            case 'BackSpace':
            // End:0x10E
            case 'Escape':
                GoBackScreen();
                // End:0x111
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

event HasFocus()
{
    super.HasFocus();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Hide();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Show(false);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

protected function InitList()
{
    //return;    
}

protected function Activate()
{
    //return;    
}

// Export UTurokFEOptionsOverlay::execChangeDescriptionLabel(FFrame&, void* const)
protected native function ChangeDescriptionLabel();

protected function IntroComplete()
{
    mBlockInput = false;
    //return;    
}

protected function ExitComplete()
{
    //return;    
}

defaultproperties
{
    mHighlightImage=Texture2D'EngineResources.DecoPaint'
    bHasFocus=true
}