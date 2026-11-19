class TurokFEExtrasVideos extends TurokUISceneController
    native;

var @NULL mMenu;
var @NULL mFEAudio;
var @NULL mCurrentUnlockLabel;
var array mLockedVideos;
var array mLockLabels;

// Export UTurokFEExtrasVideos::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event bool SCInputKey_Videos(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // DebugMode: 0
    assert(mMenu != none);
    // End:0x43
    if(mMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed) == true)
    {
        return true;
    }
    // End:0x82
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x66
            case 'XboxTypeS_B':
            // End:0x7F
            case 'Backslash':
                CloseMenu();
                // End:0x82
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
    local class<Class> FEAudioClass;

    FEAudioClass = class<TurokFEAudio>(DynamicLoadObject("TurokEngine.TurokFEAudio", Class'Core.Class'));
    // End:0x4C
    if(FEAudioClass != none)
    {
        mFEAudio = new (self) FEAudioClass;
    }
    mMenu = TurokUIMenu(Scene.FindChild(name("YeOldeMenu")));
    // End:0x154
    if(mMenu != none)
    {
        mMenu.SetItemHighlightDelegate(0, ChangeLockedLabel);
        mMenu.SetItemHighlightDelegate(1, ChangeLockedLabel);
        mMenu.SetItemHighlightDelegate(2, ChangeLockedLabel);
        mMenu.SetItemDelegate(0, PlayVideo);
        mMenu.SetItemDelegate(1, PlayVideo);
        mMenu.SetItemDelegate(2, PlayVideo);
        mMenu.bScrollWrapped = true;
        mMenu.PostSetupInitialize();
    }
    UpdateLockedLabelImages();
    mCurrentUnlockLabel = UILabel(Scene.FindChild(name("Unlock0")));
    //return;    
}

event SCTick(float DeltaTime)
{
    // End:0x1E
    if(mMenu != none)
    {
        mMenu.Tick();
    }
    //return;    
}

event SCCleanUpOnExit()
{
    mFEAudio = none;
    // End:0x2C
    if(mMenu != none)
    {
        mMenu.Deinitialize();
        mMenu = none;
    }
    SceneClient = none;
    //return;    
}

function CloseMenu()
{
    SceneClient.GoBackSceneController(0);
    //return;    
}

function ChangeLockedLabel()
{
    // End:0x1F
    if(mCurrentUnlockLabel != none)
    {
        mCurrentUnlockLabel.SetVisibility(false);
    }
    mCurrentUnlockLabel = mLockLabels[mMenu.SelectedItemIndex];
    // End:0x74
    if((mCurrentUnlockLabel != none) && mLockedVideos[mMenu.SelectedItemIndex] == true)
    {
        mCurrentUnlockLabel.SetVisibility(true);
    }
    //return;    
}

function UpdateLockedLabelImages()
{
    local int yeOldeCounter;
    local @NULL TempLabel;

    yeOldeCounter = 0;
    J0x07:

    // End:0x5D [Loop If]
    if(yeOldeCounter < mLockedVideos.Length)
    {
        Scene.FindChild(name("Locked" $ string(yeOldeCounter))).SetVisibility(mLockedVideos[yeOldeCounter]);
        ++yeOldeCounter;
        // [Loop Continue]
        goto J0x07;
    }
    yeOldeCounter = 0;
    TempLabel = UILabel(Scene.FindChild(name("Unlock" $ string(yeOldeCounter))));
    J0x92:

    // End:0xE1 [Loop If]
    if(TempLabel != none)
    {
        mLockLabels[yeOldeCounter++] = TempLabel;
        TempLabel = UILabel(Scene.FindChild(name("Unlock" $ string(yeOldeCounter))));
        // [Loop Continue]
        goto J0x92;
    }
    //return;    
}

function PlayVideo()
{
    // End:0x1A
    if(mLockedVideos[mMenu.SelectedItemIndex] == false)
    {
    }
    //return;    
}

defaultproperties
{
    mLockedVideos=/* Array type was not detected. */
    SceneName="TurokFEExtras.Videos"
}