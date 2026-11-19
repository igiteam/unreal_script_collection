class TurokFE extends UIInteraction within GameViewportClient
    transient
    config(Input)
    hidecategories(Object,UIRoot);

const NUM_SUB_MENU_SCENES = 30;

var @NULL mDebugScenes[30];
var @NULL mDebugOptionScene;
var @NULL mDebugMPScene;
var bool mBackButtonDown;
var bool mInputAllowed;
var private @NULL mMPHelper;
var globalconfig name CycleLanguageForward;
var globalconfig name CycleLanguageBackward;

event bool InputKey(int ControllerId, name Key, byte Event, optional float AmountDepressed = 1.0000000)
{
    local bool eatInputNow, submenuIsLoaded;
    local int I;
    local class<Class> MPClass;

    // End:0x3C
    if(Class'TurokEngine.TurokUI'.static.GetEngine().GamePlayers[0].ControllerId != ControllerId)
    {
        return false;
    }
    eatInputNow = false;
    // End:0x87
    if(Key == 'XboxTypeS_Back')
    {
        // End:0x6F
        if(int(Event) == int(0))
        {
            mBackButtonDown = true;
        }
        // End:0x87
        if(int(Event) == int(1))
        {
            mBackButtonDown = false;
        }
    }
    // End:0x35E
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0xAA
            case 'ScrollLock':
            // End:0xF2
            case 'XboxTypeS_Start':
                // End:0xF2
                if(!mBackButtonDown)
                {
                    // End:0xE7
                    if(mInputAllowed)
                    {
                        eatInputNow = Class'TurokEngine.TurokUI'.static.OpenPauseMenu();                        
                    }
                    else
                    {
                        eatInputNow = false;
                    }
                    // End:0x35E
                    break;
                }
            // End:0x14B
            case 'Pause':
                submenuIsLoaded = false;
                I = 0;
                J0x10D:

                // End:0x148 [Loop If]
                if(I < 30)
                {
                    // End:0x13E
                    if(mDebugScenes[I].SceneClient != none)
                    {
                        submenuIsLoaded = true;
                        // [Explicit Break]
                        goto J0x148;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x10D;
                }
                J0x148:

                // End:0x35E
                break;
            // End:0x1F8
            case 'F7':
                // End:0x1C8
                if(mMPHelper == none)
                {
                    MPClass = class<TurokMPDebugFEHelper>(DynamicLoadObject("TurokGame.TurokMPDebugFEHelper", Class'Core.Class'));
                    // DebugMode: 0
                    assert(MPClass != none);
                    mMPHelper = new (self) MPClass;
                    mMPHelper.InitMpHelper();
                }
                mMPHelper.StartGame("Deathmatch", "MP01");
                eatInputNow = true;
                // End:0x35E
                break;
            // End:0x29F
            case 'F8':
                // End:0x275
                if(mMPHelper == none)
                {
                    MPClass = class<TurokMPDebugFEHelper>(DynamicLoadObject("TurokGame.TurokMPDebugFEHelper", Class'Core.Class'));
                    // DebugMode: 0
                    assert(MPClass != none);
                    mMPHelper = new (self) MPClass;
                    mMPHelper.InitMpHelper();
                }
                mMPHelper.SearchGames("Deathmatch");
                eatInputNow = true;
                // End:0x35E
                break;
            // End:0x2FB
            case CycleLanguageForward:
                Outer.UIController.SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("CycleLanguage 1");
                // End:0x35E
                break;
            // End:0x358
            case CycleLanguageBackward:
                Outer.UIController.SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("CycleLanguage -1");
                // End:0x35E
                break;
            // End:0xFFFF
            default:
                // End:0x35E
                break;
                break;
        }
    }
    return eatInputNow || super(Interaction).InputKey(ControllerId, Key, Event, AmountDepressed);
    //return ReturnValue;    
}

function Initialized()
{
    //return;    
}

function InitSceneControllerRefs()
{
    local int I;

    mDebugScenes[0] = TurokFEDebugMainMenu(Outer.UIController.SceneClient.SceneControllerMgr.FindSceneController("DebugMainMenu"));
    I = 1;
    J0x51:

    // End:0x123 [Loop If]
    if(I < 30)
    {
        // End:0xC3
        if(I < 10)
        {
            mDebugScenes[I] = TurokFEDebugMainMenu(Outer.UIController.SceneClient.SceneControllerMgr.FindSceneController("DebugSubmenu0" $ string(I)));
            // [Explicit Continue]
            goto J0x119;
        }
        mDebugScenes[I] = TurokFEDebugMainMenu(Outer.UIController.SceneClient.SceneControllerMgr.FindSceneController("DebugSubmenu" $ string(I)));
        J0x119:

        I++;
        // [Loop Continue]
        goto J0x51;
    }
    mDebugOptionScene = TurokFEDebugOptionsMenu(Outer.UIController.SceneClient.SceneControllerMgr.FindSceneController("DebugOptionsMenu"));
    mDebugMPScene = TurokFEDebugMPMenu(Outer.UIController.SceneClient.SceneControllerMgr.FindSceneController("DebugMPMenu"));
    Class'TurokEngine.TurokUI'.static.InitPauseMenu();
    //return;    
}

function ClearSceneControllerRefs()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2A [Loop If]
    if(I < 30)
    {
        mDebugScenes[I] = none;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    mDebugOptionScene = none;
    mDebugMPScene = none;
    Class'TurokEngine.TurokUI'.static.ShutdownPauseMenu();
    //return;    
}

function SetPauseMenuEnabledTurokFE(bool enableInput)
{
    mInputAllowed = enableInput;
    //return;    
}

defaultproperties
{
    mInputAllowed=true
}