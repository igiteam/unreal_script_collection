class TurokUIDialog extends TurokUISceneController
    native;

enum DialogButtons
{
    eDB_Button_1,                   // 0
    eDB_Button_2,                   // 1
    eDB_Button_3,                   // 2
    eDB_NumButtons,                 // 3
    eDB_MAX                         // 4
};

enum NumberOfDialogButtons
{
    eDB_NumButtons,                 // 0
    eDB_NumButtons_1,               // 1
    eDB_NumButtons_2,               // 2
    eDB_NumButtons_3,               // 3
    eDB_NumButtons_MAX              // 4
};

struct native TurokUIDialogData
{
    var int title_hash;
    var int message_hash;
    var int button_hashes[3];
    var string title_str;
    var string message_str;
    var string button_strs[3];
    var int first_button;
    var int num_buttons;
    var bool always_allow_input;

    structdefaultproperties
    {
        title_hash=0
        message_hash=0
        button_hashes[0]=0
        button_hashes[1]=0
        button_hashes[2]=0
        title_str=""
        message_str=""
        button_strs[0]=""
        button_strs[1]=""
        button_strs[2]=""
        first_button=0
        num_buttons=0
        always_allow_input=false
    }
};

var private @NULL Buttons;
var private @NULL MessageText;
var private @NULL BlackBackgroundStretchQuad;
var private @NULL BackgroundDarkenImage;
var private @NULL BackgroundAnimationImages1[3];
var private @NULL BackgroundAnimationImages2[3];
var private @NULL BackgroundAnimationImages3[6];
var private @NULL SetupData;
var private float fVerticalOffset;
var private int ButtonPressed;
var protected bool bBlockInput;
var byte mDialogLayer;
var private @NULL dialogRef;
//var delegate<@NULL> __Button1Action__Delegate;
//var delegate<@NULL> __Button2Action__Delegate;
//var delegate<@NULL> __Button3Action__Delegate;

// Export UTurokUIDialog::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokUIDialog::execGetScreenHeight(FFrame&, void* const)
native final function float GetScreenHeight();

event OpenTCRPopup(@NULL scene_client, int numButtons, int titleHash, int messageHash, int buttonHash0, int buttonHash1, int buttonHash2, delegate<@NULL> delFunc0, delegate<@NULL> delFunc1, delegate<@NULL> delFunc2, optional int firstButton = 0)
{
    local @NULL myDlgInstance;

    // End:0x2E
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIDialog_TCR_SD';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIDialog_TCR';
    }
    myDlgInstance.PlaySound(true);
    switch(numButtons)
    {
        // End:0x8A
        case 0:
            myDlgInstance.ShowZeroButton(scene_client, titleHash, messageHash, 6, myDlgInstance);
            // End:0x170
            break;
        // End:0xCA
        case 1:
            myDlgInstance.ShowOneButton(scene_client, titleHash, messageHash, buttonHash0, delFunc0, firstButton, 6, myDlgInstance);
            // End:0x170
            break;
        // End:0x115
        case 2:
            myDlgInstance.ShowTwoButton(scene_client, titleHash, messageHash, buttonHash0, buttonHash1, delFunc0, delFunc1, firstButton, 6, myDlgInstance);
            // End:0x170
            break;
        // End:0x16A
        case 3:
            myDlgInstance.ShowThreeButton(scene_client, titleHash, messageHash, buttonHash0, buttonHash1, buttonHash2, delFunc0, delFunc1, delFunc2, firstButton, 6, myDlgInstance);
            // End:0x170
            break;
        // End:0xFFFF
        default:
            // End:0x170
            break;
            break;
    }
    //return;    
}

event OpenPopup(@NULL scene_client, int numButtons, int titleHash, int messageHash, int buttonHash0, int buttonHash1, int buttonHash2, delegate<@NULL> delFunc0, delegate<@NULL> delFunc1, delegate<@NULL> delFunc2, optional int firstButton = 0, optional bool alwaysAllowInput = false)
{
    local @NULL myDlgInstance;

    // End:0x33
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIDialog_SD';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIDialog';
    }
    myDlgInstance.PlaySound(true);
    switch(numButtons)
    {
        // End:0x94
        case 0:
            myDlgInstance.ShowZeroButton(scene_client, titleHash, messageHash, 2, myDlgInstance, alwaysAllowInput);
            // End:0x189
            break;
        // End:0xD9
        case 1:
            myDlgInstance.ShowOneButton(scene_client, titleHash, messageHash, buttonHash0, delFunc0, firstButton, 2, myDlgInstance, alwaysAllowInput);
            // End:0x189
            break;
        // End:0x129
        case 2:
            myDlgInstance.ShowTwoButton(scene_client, titleHash, messageHash, buttonHash0, buttonHash1, delFunc0, delFunc1, firstButton, 2, myDlgInstance, alwaysAllowInput);
            // End:0x189
            break;
        // End:0x183
        case 3:
            myDlgInstance.ShowThreeButton(scene_client, titleHash, messageHash, buttonHash0, buttonHash1, buttonHash2, delFunc0, delFunc1, delFunc2, firstButton, 2, myDlgInstance, alwaysAllowInput);
            // End:0x189
            break;
        // End:0xFFFF
        default:
            // End:0x189
            break;
            break;
    }
    //return;    
}

event OpenPopupStr(@NULL scene_client, int numButtons, string Title, string Message, string button0, string button1, string button2, delegate<@NULL> delFunc0, delegate<@NULL> delFunc1, delegate<@NULL> delFunc2, optional int firstButton = 0)
{
    local @NULL myDlgInstance;

    // End:0x2E
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIDialog_SD';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIDialog';
    }
    myDlgInstance.PlaySound(true);
    switch(numButtons)
    {
        // End:0x89
        case 0:
            myDlgInstance.ShowZeroButtonStr(scene_client, Title, Message, 2, myDlgInstance);
            // End:0x16C
            break;
        // End:0xC8
        case 1:
            myDlgInstance.ShowOneButtonStr(scene_client, Title, Message, button0, delFunc0, firstButton, 2, myDlgInstance);
            // End:0x16C
            break;
        // End:0x112
        case 2:
            myDlgInstance.ShowTwoButtonStr(scene_client, Title, Message, button0, button1, delFunc0, delFunc1, firstButton, 2, myDlgInstance);
            // End:0x16C
            break;
        // End:0x166
        case 3:
            myDlgInstance.ShowThreeButtonStr(scene_client, Title, Message, button0, button1, button2, delFunc0, delFunc1, delFunc2, firstButton, 2, myDlgInstance);
            // End:0x16C
            break;
        // End:0xFFFF
        default:
            // End:0x16C
            break;
            break;
    }
    //return;    
}

event CloseDialogImmediately()
{
    SceneClient.GoBackSceneController(mDialogLayer);
    //return;    
}

// Export UTurokUIDialog::execPlaySound(FFrame&, void* const)
native function PlaySound(bool bIsOpening);

event StartCloseDialog()
{
    local int I;

    PlaySound(false);
    // End:0x29
    if(Buttons != none)
    {
        Buttons.StartFadeOut();
    }
    Class'TurokUI'.static.PlayScript(MessageText, "fadeout");
    Class'TurokUI'.static.PlayScript(BlackBackgroundStretchQuad, "fadeout");
    Class'TurokUI'.static.PlayScript(BackgroundDarkenImage, "fadeout");
    Class'TurokUI'.static.PlayScript(BackgroundAnimationImages1[0], "fadeout");
    Class'TurokUI'.static.PlayScript(BackgroundAnimationImages2[0], "fadeout");
    I = 0;
    J0xD9:

    // End:0x116 [Loop If]
    if(I < 6)
    {
        Class'TurokUI'.static.PlayScript(BackgroundAnimationImages3[I], "fadeout");
        I++;
        // [Loop Continue]
        goto J0xD9;
    }
    bBlockInput = true;
    //return;    
}

function ShowZeroButton(@NULL scene_client, int title_hash, int message_hash, byte dialogLayer, @NULL overrideSC, optional bool always_allow_input = false)
{
    SetupDialogData(scene_client, title_hash, message_hash, 0, 0, 0, "", "", "", "", "", 0, 0, dialogLayer, overrideSC, always_allow_input);
    //return;    
}

function ShowOneButton(@NULL scene_client, int title_hash, int message_hash, int button_hash, delegate<@NULL> del_func, int firstButton, byte dialogLayer, @NULL overrideSC, optional bool always_allow_input = false)
{
    __Button1Action__Delegate = del_func;
    SetupDialogData(scene_client, title_hash, message_hash, button_hash, 0, 0, "", "", "", "", "", 1, firstButton, dialogLayer, overrideSC, always_allow_input);
    //return;    
}

function ShowTwoButton(@NULL scene_client, int title_hash, int message_hash, int button_hash_1, int button_hash_2, delegate<@NULL> del_func1, delegate<@NULL> del_func2, int firstButton, byte dialogLayer, @NULL overrideSC, optional bool always_allow_input = false)
{
    __Button1Action__Delegate = del_func1;
    __Button2Action__Delegate = del_func2;
    SetupDialogData(scene_client, title_hash, message_hash, button_hash_1, button_hash_2, 0, "", "", "", "", "", 2, firstButton, dialogLayer, overrideSC, always_allow_input);
    //return;    
}

function ShowThreeButton(@NULL scene_client, int title_hash, int message_hash, int button_hash_1, int button_hash_2, int button_hash_3, delegate<@NULL> del_func1, delegate<@NULL> del_func2, delegate<@NULL> del_func3, int firstButton, byte dialogLayer, @NULL overrideSC, optional bool always_allow_input = false)
{
    __Button1Action__Delegate = del_func1;
    __Button2Action__Delegate = del_func2;
    __Button3Action__Delegate = del_func3;
    SetupDialogData(scene_client, title_hash, message_hash, button_hash_1, button_hash_2, button_hash_3, "", "", "", "", "", 3, firstButton, dialogLayer, overrideSC, always_allow_input);
    //return;    
}

function ShowZeroButtonStr(@NULL scene_client, string title_str, string message_str, byte dialogLayer, @NULL overrideSC)
{
    SetupDialogData(scene_client, 0, 0, 0, 0, 0, title_str, message_str, "", "", "", 0, 0, dialogLayer, overrideSC);
    //return;    
}

function ShowOneButtonStr(@NULL scene_client, string title_str, string message_str, string button_str, delegate<@NULL> del_func, int firstButton, byte dialogLayer, @NULL overrideSC)
{
    __Button1Action__Delegate = del_func;
    SetupDialogData(scene_client, 0, 0, 0, 0, 0, title_str, message_str, button_str, "", "", 1, firstButton, dialogLayer, overrideSC);
    //return;    
}

function ShowTwoButtonStr(@NULL scene_client, string title_str, string message_str, string button_str_1, string button_str_2, delegate<@NULL> del_func1, delegate<@NULL> del_func2, int firstButton, byte dialogLayer, @NULL overrideSC)
{
    __Button1Action__Delegate = del_func1;
    __Button2Action__Delegate = del_func2;
    SetupDialogData(scene_client, 0, 0, 0, 0, 0, title_str, message_str, button_str_1, button_str_2, "", 2, firstButton, dialogLayer, overrideSC);
    //return;    
}

function ShowThreeButtonStr(@NULL scene_client, string title_str, string message_str, string button_str_1, string button_str_2, string button_str_3, delegate<@NULL> del_func1, delegate<@NULL> del_func2, delegate<@NULL> del_func3, int firstButton, byte dialogLayer, @NULL overrideSC)
{
    __Button1Action__Delegate = del_func1;
    __Button2Action__Delegate = del_func2;
    __Button3Action__Delegate = del_func3;
    SetupDialogData(scene_client, 0, 0, 0, 0, 0, title_str, message_str, button_str_1, button_str_2, button_str_3, 3, firstButton, dialogLayer, overrideSC);
    //return;    
}

event bool SCInputKey_TurokUIDialog(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x0B
    if(bBlockInput)
    {
        return true;
    }
    // End:0x42
    if(Buttons != none)
    {
        // End:0x42
        if(Buttons.ProcessInput(ControllerId, Key, Event, AmountDepressed))
        {
            return true;
        }
    }
    switch(Key)
    {
        // End:0x6A
        case 'XboxTypeS_Back':
            // End:0x6A
            if(Class'Engine.Engine'.static.IsPS3())
            {
                // End:0xCC
                break;
            }
        // End:0x78
        case 'Pause':
            return true;
        // End:0xC9
        case 'Escape':
            // End:0xA7
            if(SetupData.num_buttons == 3)
            {
                Button3Pressed();                
            }
            else
            {
                // End:0xC7
                if(SetupData.num_buttons == 2)
                {
                    Button2Pressed();
                }
            }
            return true;
        // End:0xFFFF
        default:
            break;
    }
    return false;
    //return ReturnValue;    
}

event SCCleanUpOnExit()
{
    local int I;

    // End:0x25
    if(Buttons != none)
    {
        Buttons.Deinitialize();
        Buttons = none;
    }
    MessageText.ScriptCtrl = none;
    MessageText = none;
    BlackBackgroundStretchQuad.ScriptCtrl = none;
    BlackBackgroundStretchQuad = none;
    BackgroundDarkenImage.ScriptCtrl = none;
    BackgroundDarkenImage = none;
    I = 0;
    J0x71:

    // End:0xAA [Loop If]
    if(I < 3)
    {
        BackgroundAnimationImages1[I].ScriptCtrl = none;
        BackgroundAnimationImages1[I] = none;
        I++;
        // [Loop Continue]
        goto J0x71;
    }
    I = 0;
    J0xB1:

    // End:0xEA [Loop If]
    if(I < 3)
    {
        BackgroundAnimationImages2[I].ScriptCtrl = none;
        BackgroundAnimationImages2[I] = none;
        I++;
        // [Loop Continue]
        goto J0xB1;
    }
    I = 0;
    J0xF1:

    // End:0x12A [Loop If]
    if(I < 6)
    {
        BackgroundAnimationImages3[I].ScriptCtrl = none;
        BackgroundAnimationImages3[I] = none;
        I++;
        // [Loop Continue]
        goto J0xF1;
    }
    SceneClient = none;
    //return;    
}

function Button1Pressed()
{
    ButtonPressed = 0;
    StartCloseDialog();
    //return;    
}

function Button2Pressed()
{
    ButtonPressed = 1;
    StartCloseDialog();
    //return;    
}

function Button3Pressed()
{
    ButtonPressed = 2;
    StartCloseDialog();
    //return;    
}

delegate Button1Action()
{
    //return;    
}

delegate Button2Action()
{
    //return;    
}

delegate Button3Action()
{
    //return;    
}

function ShowText()
{
    // End:0x3C
    if(SetupData.num_buttons > 0)
    {
        Buttons.SetMenuVisibility(true);
        Buttons.StartFadeIn();
    }
    //return;    
}

function InitComplete()
{
    // End:0x1D
    if(SetupData.num_buttons > 0)
    {
        bBlockInput = false;
    }
    //return;    
}

function ExitComplete()
{
    SceneClient.EnableHelpBarRendering();
    SceneClient.GoBackSceneController(mDialogLayer);
    switch(ButtonPressed)
    {
        // End:0x48
        case 0:
            Button1Action();
            // End:0x7B
            break;
        // End:0x5E
        case 1:
            Button2Action();
            // End:0x7B
            break;
        // End:0x75
        case 2:
            Button3Action();
            // End:0x7B
            break;
        // End:0xFFFF
        default:
            // End:0x7B
            break;
            break;
    }
    __Button1Action__Delegate = None;
    __Button2Action__Delegate = None;
    __Button3Action__Delegate = None;
    //return;    
}

private final function SetupDialogData(@NULL scene_client, int title_hash, int message_hash, int button_hash_1, int button_hash_2, int button_hash_3, string title_str, string message_str, string button_str_1, string button_str_2, string button_str_3, int num_buttons, int first_button, byte dialogLayer, @NULL overrideSC, optional bool always_allow_input = false)
{
    local byte eFirstButton;

    // DebugMode: 0
    assert(first_button < 3);
    // End:0x28
    if(first_button == 0)
    {
        eFirstButton = 0;        
    }
    else
    {
        // End:0x3E
        if(first_button == 1)
        {
            eFirstButton = 1;            
        }
        else
        {
            eFirstButton = 2;
        }
    }
    mDialogLayer = dialogLayer;
    SetupData.title_hash = title_hash;
    SetupData.message_hash = message_hash;
    SetupData.button_hashes[0] = button_hash_1;
    SetupData.button_hashes[1] = button_hash_2;
    SetupData.button_hashes[2] = button_hash_3;
    SetupData.title_str = title_str;
    SetupData.message_str = message_str;
    SetupData.button_strs[0] = button_str_1;
    SetupData.button_strs[1] = button_str_2;
    SetupData.button_strs[2] = button_str_3;
    SetupData.num_buttons = num_buttons;
    SetupData.first_button = int(eFirstButton);
    SetupData.always_allow_input = always_allow_input;
    bBlockInput = true;
    scene_client.OpenSceneController("Dialog", mDialogLayer, overrideSC);
    //return;    
}

// Export UTurokUIDialog::execSetupButtons(FFrame&, void* const)
native function SetupButtons(const float kStretchQuadY, const float kStretchQuadHeight);

// Export UTurokUIDialog::execSetupMessageText(FFrame&, void* const)
native function SetupMessageText();

// Export UTurokUIDialog::execSetupBlackBackgroundStretchQuad(FFrame&, void* const)
native function SetupBlackBackgroundStretchQuad();

// Export UTurokUIDialog::execSetupBackgroundAnimationImages(FFrame&, void* const)
native function SetupBackgroundAnimationImages();

// Export UTurokUIDialog::execSetupBackgroundImages(FFrame&, void* const)
native function SetupBackgroundImages(const float kStretchQuadY, const float kStretchQuadHeight);

// Export UTurokUIDialog::execIsInputAllowed(FFrame&, void* const)
native function bool IsInputAllowed();

defaultproperties
{
    ButtonPressed=-1
    dialogRef=UIScene'UIDialog.FEDialog'
    SceneName="UIDialog.FEDialog"
}