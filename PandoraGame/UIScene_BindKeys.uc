class UIScene_BindKeys extends UIScene_BaseFrontEnd;

struct BindInfo
{
    var name LabelName;
    var string BindCommand;
    var UILabel myLabel;

    structdefaultproperties
    {
        LabelName="None"
        BindCommand=""
        myLabel=none
    }
};

struct KeyName
{
    var string Key;
    var string DataStore;

    structdefaultproperties
    {
        Key=""
        DataStore=""
    }
};

var array<BindInfo> BindLabels;
var array<KeyName> KeyNames;
var UIScene_GrabKey GrabKeyScene;
var int CurrentIndex;

event InitScene()
{
    local int I;

    super.InitScene();
    I = 0;
    J0x0D:

    // End:0x60 [Loop If]
    if(I < BindLabels.Length)
    {
        BindLabels[I].myLabel = UILabel(FindChild(BindLabels[I].LabelName, true));
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    RefreshBindingLabels();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    RefreshBindingLabels();
    //return;    
}

static function string GetLocalizedKeyName(string myKeyName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7F [Loop If]
    if(I < default.KeyNames.Length)
    {
        // End:0x75
        if(default.KeyNames[I].Key ~= myKeyName)
        {
            return Localize("OptionsGrabKey", default.KeyNames[I].DataStore, "PandoraGame");
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    switch(myKeyName)
    {
        // End:0x9B
        case "One":
            myKeyName = "1";
            // End:0x15C
            break;
        // End:0xAF
        case "Two":
            myKeyName = "2";
            // End:0x15C
            break;
        // End:0xC5
        case "Three":
            myKeyName = "3";
            // End:0x15C
            break;
        // End:0xDA
        case "Four":
            myKeyName = "4";
            // End:0x15C
            break;
        // End:0xEF
        case "Five":
            myKeyName = "5";
            // End:0x15C
            break;
        // End:0x103
        case "Six":
            myKeyName = "6";
            // End:0x15C
            break;
        // End:0x119
        case "Seven":
            myKeyName = "7";
            // End:0x15C
            break;
        // End:0x12F
        case "Eight":
            myKeyName = "8";
            // End:0x15C
            break;
        // End:0x144
        case "Nine":
            myKeyName = "9";
            // End:0x15C
            break;
        // End:0x159
        case "Zero":
            myKeyName = "0";
            // End:0x15C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return myKeyName;
    //return ReturnValue;    
}

function RefreshBindingLabels()
{
    local int I;
    local string NewKeyVal, LocalizedKeyVal;

    // End:0x18A
    if(myPC != none)
    {
        I = 0;
        J0x12:

        // End:0x18A [Loop If]
        if(I < BindLabels.Length)
        {
            // End:0x41
            if(BindLabels[I].myLabel == none)
            {
                // [Explicit Continue]
                goto J0x180;
            }
            NewKeyVal = string(myPC.GetNonControllerBinding(BindLabels[I].BindCommand));
            LocalizedKeyVal = GetLocalizedKeyName(NewKeyVal);
            // End:0xBD
            if(LocalizedKeyVal != "")
            {
                BindLabels[I].myLabel.SetValue(LocalizedKeyVal);                
            }
            else
            {
                BindLabels[I].myLabel.SetValue(NewKeyVal);
            }
            // End:0x13B
            if(NewKeyVal == "None")
            {
                BindLabels[I].myLabel.StringRenderComponent.SetColor(MakeLinearColor(1.0000000, 0.0000000, 0.0000000, 1.0000000));
                // [Explicit Continue]
                goto J0x180;
            }
            BindLabels[I].myLabel.StringRenderComponent.SetColor(MakeLinearColor(1.0000000, 1.0000000, 1.0000000, 1.0000000));
            J0x180:

            I++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    CurrentIndex = MenuIndex;
    // End:0x84
    if(MenuIndex != (MenuIndexByName("btnReset")))
    {
        DisplayGrabKey(MenuItems[MenuIndex].ButtonObj.GetDataStoreBinding(), string(myPC.GetNonControllerBinding(BindLabels[MenuIndex].BindCommand)));        
    }
    else
    {
        ShowMsgBox("<strings:PandoraGame.ErrorMessages.ResetToDefaults_Message>", "<strings:PandoraGame.ErrorMessages.ResetToDefaults_Title>", 1, OnResetToDefaultMsgResults);
    }
    //return;    
}

function DisplayGrabKey(string BindedCommandMarkup, string KeyMarkup)
{
    local UIScene TempScene;
    local UIScene_GrabKey KeyScene;

    // End:0xC7
    if(SceneClient.OpenScene(GrabKeyScene, LocPlayer, TempScene))
    {
        KeyScene = UIScene_GrabKey(TempScene);
        // End:0xC7
        if(KeyScene != none)
        {
            KeyScene.FadeIn(0.5000000);
            KeyScene.SetVisibility(true);
            KeyScene.__OnSceneClose__Delegate = Restore;
            KeyScene.SetKeyAndCommandDatastoreBinding(GetLocalizedKeyName(KeyMarkup), BindedCommandMarkup);
            KeyScene.__OnResults__Delegate = OnGrabKeyResults;
        }
    }
    //return;    
}

function OnGrabKeyResults(int PlayerIndex, name ReturnButton)
{
    // End:0xF2
    if(ReturnButton != 'None')
    {
        // End:0x7A
        if((myPC != none) && !myPC.IsAlreadyBound(ReturnButton))
        {
            myPC.SetNonControllerBinding(ReturnButton, BindLabels[CurrentIndex].BindCommand);
            RefreshBindingLabels();            
        }
        else
        {
            ShowMsgBox("<strings:PlatformPC.ErrorMessages.KeyInUse_Message>", "<strings:PlatformPC.ErrorMessages.KeyInUse_Title>", 0);
        }
    }
    //return;    
}

function OnResetToDefaultMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local PandoraPlayerInput PanInput;

    // End:0x6B
    if(int(eReturnValue) == int(1))
    {
        // End:0x35
        if(myPC != none)
        {
            PanInput = PandoraPlayerInput(myPC.PlayerInput);
        }
        // End:0x6B
        if(PanInput != none)
        {
            PanInput.ResetToDefaultKeyBinding();
            PanInput.SaveConfig();
            RefreshBindingLabels();
        }
    }
    //return;    
}
