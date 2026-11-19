class TurokFEMultiplayerLobbyOverlay extends TurokUISceneController
    native;

var protected @NULL mList;
var protected @NULL mHighlightImage;
var protected @NULL mCurrentDescriptionLabel;
var protected array mDescriptionText;
var protected bool mBlockInput;
var @NULL TheMenu;

// Export UTurokFEMultiplayerLobbyOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEMultiplayerLobbyOverlay::execRefreshList(FFrame&, void* const)
protected native function RefreshList();

// Export UTurokFEMultiplayerLobbyOverlay::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

event SCInitialized()
{
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
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

event bool SCInputKey_MultiplayerLobbyOverlay(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local @NULL Label, Image;
    local bool EatInput;

    EatInput = true;
    // End:0x1B
    if(mBlockInput == true)
    {
        return EatInput;
    }
    // End:0x194
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x3E
            case 'XboxTypeS_X':
            // End:0x4D
            case 'X':
                // End:0x194
                break;
            // End:0x59
            case 'XboxTypeS_A':
            // End:0x72
            case 'Enter':
                Activate();
                // End:0x194
                break;
            // End:0x133
            case 'LeftMouseButton':
                Image = mList.GetSlotImage(mList.GetSelectedSlotIndex());
                // End:0xD7
                if((Image != none) && Image.IsMouseOver())
                {
                    Activate();
                }
                Label = mList.GetSlotLabel(mList.GetSelectedSlotIndex());
                // End:0x130
                if((Label != none) && Label.IsMouseOver())
                {
                    Activate();
                }
                // End:0x194
                break;
            // End:0x154
            case 'XboxTypeS_Back':
                // End:0x154
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x194
                    break;
                }
            // End:0x160
            case 'XboxTypeS_B':
            // End:0x16C
            case 'MouseXButton1':
            // End:0x178
            case 'BackSpace':
            // End:0x191
            case 'Escape':
                GoBackScreen();
                // End:0x194
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x1D2
        if(mList.ProcessInput(ControllerId, Key, Event, AmountDepressed) == true)
        {
            ChangeDescriptionLabel();
            return EatInput;
        }
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

// Export UTurokFEMultiplayerLobbyOverlay::execChangeDescriptionLabel(FFrame&, void* const)
protected native function ChangeDescriptionLabel();

protected final event NativeActivate()
{
    Activate();
    //return;    
}

// Export UTurokFEMultiplayerLobbyOverlay::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerLobbyOverlay::execOnCancel(FFrame&, void* const)
native function OnCancel();

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
}