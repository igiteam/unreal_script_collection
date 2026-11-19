class GFxProjectedUI extends UTGFxTweenableMoviePlayer
    config(UI);

struct ItemData
{
    var string ItemInfo;
    var string ItemName;
    var byte ItemFrame;

    structdefaultproperties
    {
        ItemInfo=""
        ItemName=""
        ItemFrame=0
    }
};

var GFxObject Root;
var GFxObject Window;
var GFxObject MainMC;
var GFxObject BackpackMC;
var GFxObject ArsenalMC;
var array<GFxUI_InventoryButton> Buttons;
var array<ItemData> Items;
var GFxObject EquippedWeapon;
var GFxObject EquippedWeaponOutline;
var GFxObject EquippedWeaponText1;
var GFxObject EquippedWeaponText2;
var bool bArsenalTabFocused;
var bool bInitialized;
var GFxObject BackpackTabMC;
var GFxObject ArsenalTabMC;
var GFxObject LeftArrow02;
var GFxObject LeftArrow01;
var GFxObject BackgroundMC;
var GFxObject CPCLogoMC;
var GFxObject StartUpTextMC;
var GFxObject BG_LineMC;
var GFxObject BG_ArrowMC;
var GFxObject BG_Optic1MC;
var GFxObject BG_Optic2MC;
var GFxObject BG_Optic3MC;
var GFxObject BG_Optic4MC;
var GFxObject BG_Edge_LeftBottom;
var GFxObject BG_Edge_LeftMiddle;
var GFxObject BG_Edge_LeftTop;
var GFxObject BG_Edge_RightTop;
var GFxObject BG_Edge_RightMiddle;
var GFxObject BG_Edge_RightBottom;
var GFxObject InfoMC;
var GFxObject InfoIconWeap;
var GFxObject InfoIconItem;
var GFxObject InfoText;
var GFxObject InfoTitle;
var float Scale;
var float Width;
var float Height;
var float rotval;
var float PosX;
var float PosY;
var float rightThreshold;
var float leftThreshold;
var class<EvilWeap_Base> WeaponClass[11];
var Rotator StartRotation;
var const localized string AcceptString;
var const localized string CancelString;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    AddCaptureKeys();
    rotval = 0.0000000;
    // End:0x5A
    if(!bInitialized)
    {
        ConfigureInventory();
    }
    PopulateArsenal();
    UpdateEquippedWeapon();
    BackgroundMC.GotoAndPlay("open");
    StartRotation = GetPC().Rotation;
    return true;
    //return ReturnValue;    
}

function ConfigureInventory()
{
    local float x0, y0, X1, Y1;

    Root = GetVariableObject("_root");
    Window = Root.GetObject("inventory");
    MainMC = Window.GetObject("main");
    SetupInfo();
    CreateItemData();
    SetupArsenal();
    SetupArsenalButtons();
    PopulateArsenal();
    UpdateEquippedWeapon();
    SetupBackpack();
    SetupBackpackButtons();
    PopulateBackpackFake();
    SetupBorder();
    SetupBG();
    Scale = 1.0000000;
    GetVisibleFrameRect(x0, y0, X1, Y1);
    Width = (X1 - x0) * float(20);
    Height = (Y1 - y0) * float(20);
    Window.GetPosition(PosX, PosY);
    bInitialized = true;
    GetVariableObject("_root.inventory.main.info.help.help_g.text1").SetText(AcceptString);
    GetVariableObject("_root.inventory.main.info.help.help_g.text2").SetText(CancelString);
    //return;    
}

function AddCaptureKeys()
{
    AddCaptureKey('W');
    AddCaptureKey('A');
    AddCaptureKey('S');
    AddCaptureKey('D');
    AddCaptureKey('SpaceBar');
    AddCaptureKey('T');
    AddCaptureKey('R');
    AddCaptureKey('Y');
    AddCaptureKey('X');
    AddCaptureKey('C');
    AddCaptureKey('Q');
    AddCaptureKey('Gamepad_LeftStick_Left');
    AddCaptureKey('Gamepad_LeftStick_Right');
    AddCaptureKey('Gamepad_LeftStick_Up');
    AddCaptureKey('Gamepad_LeftStick_Down');
    AddCaptureKey('Gamepad_RightStick_Left');
    AddCaptureKey('Gamepad_RightStick_Right');
    AddCaptureKey('Gamepad_RightStick_Up');
    AddCaptureKey('Gamepad_RightStick_Down');
    AddCaptureKey('XboxTypeS_DPad_Left');
    AddCaptureKey('XboxTypeS_DPad_Right');
    AddCaptureKey('XboxTypeS_DPad_Up');
    AddCaptureKey('XboxTypeS_DPad_Down');
    AddCaptureKey('XboxTypeS_A');
    AddCaptureKey('XboxTypeS_B');
    AddCaptureKey('XboxTypeS_Y');
    AddCaptureKey('XboxTypeS_X');
    AddCaptureKey('1');
    AddCaptureKey('2');
    AddCaptureKey('3');
    AddCaptureKey('4');
    AddCaptureKey('5');
    AddCaptureKey('6');
    AddCaptureKey('7');
    AddCaptureKey('8');
    AddCaptureKey('9');
    AddCaptureKey('Up');
    AddCaptureKey('Down');
    AddCaptureKey('Left');
    AddCaptureKey('Right');
    AddCaptureKey('Enter');
    //return;    
}

function StartCloseAnimation()
{
    BackgroundMC.GotoAndPlay("close");
    //return;    
}

function OnCloseAnimComplete()
{
    EvilGFxHudWrapper(GetPC().myHUD).CompleteCloseInventory();
    //return;    
}

function SetupBG()
{
    BackgroundMC = GetVariableObject("_root.inventory.bg");
    CPCLogoMC = GetVariableObject("_root.inventory.bg.cpc");
    StartUpTextMC = GetVariableObject("_root.inventory.bg.startup_text");
    BG_Optic1MC = BackgroundMC.GetObject("bg_optic1").GetObject("bg_optic1_g").GetObject("bg_optic1_gg");
    BG_Optic2MC = GetVariableObject("_root.inventory.bg.bg_optic2.bg_optic2_g");
    BG_Optic3MC = BackgroundMC.GetObject("bg_optic3").GetObject("bg_optic3_g").GetObject("bg_optic3_gg");
    BG_Optic4MC = BackgroundMC.GetObject("bg_optic4").GetObject("bg_optic4_g").GetObject("bg_optic4_gg");
    BG_Edge_LeftTop = BackgroundMC.GetObject("bg_edge1");
    BG_Edge_LeftMiddle = GetVariableObject("_root.inventory.bg.bg_edge2.bg_edge_g");
    BG_Edge_LeftBottom = BackgroundMC.GetObject("bg_edge3");
    BG_Edge_RightTop = BackgroundMC.GetObject("bg_edge4");
    BG_Edge_RightMiddle = GetVariableObject("_root.inventory.bg.bg_edge5.bg_edge_g");
    BG_Edge_RightBottom = BackgroundMC.GetObject("bg_edge6");
    BG_LineMC = GetVariableObject("_root.inventory.bg.bg_line");
    BG_ArrowMC = GetVariableObject("_root.inventory.bg.bg_arrow");
    BackgroundMC.SetFloat("_z", 1500.0000000);
    BG_Edge_RightMiddle.SetFloat("_z", -200.0000000);
    BG_Edge_LeftMiddle.SetFloat("_z", -200.0000000);
    TweenTurbines(true);
    BG_LineMC.SetFloat("_z", -200.0000000);
    BG_ArrowMC.SetFloat("_z", -200.0000000);
    //return;    
}

function SetupBorder()
{
    BackpackTabMC = BackpackMC.GetObject("tab2_mc");
    ArsenalTabMC = ArsenalMC.GetObject("tab1_mc");
    LeftArrow01 = GetVariableObject("_root.inventory.main.left.left_arrow1");
    LeftArrow02 = GetVariableObject("_root.inventory.main.left.left_arrow2");
    //return;    
}

function SetupArsenal()
{
    local int I;

    ArsenalMC = MainMC.GetObject("arsenal");
    I = 0;
    J0x3E:

    // End:0x324 [Loop If]
    if(I < 10)
    {
        Buttons[I] = GFxUI_InventoryButton(ArsenalMC.GetObject("weapon_btn" $ string(I + 1), Class'GFxUI_InventoryButton'));
        Buttons[I].GetObject("weapon_black_icon").GetObject("weapon_black").GotoAndStopI(I + 2);
        Buttons[I].SetIconMC(Buttons[I].GetObject("weapon_icon"));
        Buttons[I].IconMC.SetVisible(false);
        Buttons[I].SetFloat("data", float(I + 1));
        // End:0x2A4
        if(I < 9)
        {
            Buttons[I].GetObject("textField").GetObject("textField").SetText("0" $ string(I + 1));            
        }
        else
        {
            Buttons[I].GetObject("textField").GetObject("textField").SetText("10");
        }
        I++;
        // [Loop Continue]
        goto J0x3E;
    }
    EquippedWeaponOutline = ArsenalMC.GetObject("equipped");
    EquippedWeapon = EquippedWeaponOutline.GetObject("equipped_weapon").GetObject("equipped_weapon_g");
    EquippedWeaponText1 = EquippedWeaponOutline.GetObject("equipped_text2").GetObject("textField");
    EquippedWeaponText2 = EquippedWeaponOutline.GetObject("equipped_text1").GetObject("textField");
    //return;    
}

function SetupBackpack()
{
    local byte I;

    BackpackMC = MainMC.GetObject("backpack");
    I = 10;
    J0x40:

    // End:0x1C9 [Loop If]
    if(int(I) < int(20))
    {
        Buttons[int(I)] = GFxUI_InventoryButton(BackpackMC.GetObject("item_btn" $ string(int(I) - int(9)), Class'GFxUI_InventoryButton'));
        Buttons[int(I)].SetIconMC(Buttons[int(I)].GetObject("item").GetObject("item_g"));
        Buttons[int(I)].IconMC.SetVisible(false);
        Buttons[int(I)].SetFloat("data", float(int(I) + int(1)));
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    //return;    
}

function SetupInfo()
{
    InfoMC = GetVariableObject("_root.inventory.main.info.info_mc.info_mc_g");
    InfoIconWeap = InfoMC.GetObject("weapon");
    InfoIconItem = InfoMC.GetObject("item");
    InfoText = InfoMC.GetObject("info_text").GetObject("textField");
    InfoTitle = InfoMC.GetObject("info_title").GetObject("textField");
    //return;    
}

function PopulateBackpackFake()
{
    local byte I;

    I = 10;
    J0x0C:

    // End:0x108 [Loop If]
    if(int(I) < int(13))
    {
        Buttons[int(I)].IconMC.GotoAndStopI(int(I) + int(2));
        Buttons[int(I)].IconMC.SetVisible(true);
        Buttons[int(I)].AddEventListener('CLIK_click', OnClickFakeItem);
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

function SetupArsenalButtons()
{
    local byte I;

    I = 0;
    J0x0C:

    // End:0x106 [Loop If]
    if(int(I) < int(10))
    {
        Buttons[int(I)].AddEventListener('CLIK_focusIn', OnFocusArsenalTab);
        Buttons[int(I)].AddEventListener('CLIK_click', OnClickWeaponButton);
        Buttons[int(I)].AddEventListener('CLIK_focusIn', OnFocusUpdateInfo);
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

function SetupBackpackButtons()
{
    local int I;

    I = 10;
    J0x0C:

    // End:0xB6 [Loop If]
    if(I < 20)
    {
        Buttons[I].AddEventListener('CLIK_focusIn', OnFocusBackpackTab);
        Buttons[I].AddEventListener('CLIK_focusIn', OnFocusUpdateInfo);
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

function SwitchWeapon(byte Index)
{
    UTPlayerController(GetPC()).SwitchWeapon(Index);
    //return;    
}

function OnFocusInSelection(EventData ev)
{
    local byte Data;

    Data = byte(ev.Target.GetFloat("data") - float(1));
    // End:0xCA
    if(Buttons[int(Data)].IconMC.GetBool("_visible"))
    {
        FloatSelectionUp(Buttons[int(Data)].IconMC);
    }
    //return;    
}

function OnFocusOutSelection(EventData ev)
{
    local byte Index;

    Index = byte(ev.Target.GetFloat("data") - float(1));
    ClearsTweensOnMovieClip(Buttons[int(Index)].IconMC);
    //return;    
}

function OnClickWeaponButton(EventData ev)
{
    local int Index;

    Index = int(ev.Target.GetFloat("data"));
    // End:0xCA
    if((Index >= 0) && WeaponClass[Index] != none)
    {
        UTPawn(GetPC().Pawn).SwitchWeapon(byte(Index));
        FakeUpdateEquippedWeapon(Index);
    }
    //return;    
}

function OnFocusUpdateInfo(EventData ev)
{
    local int buttonIndex;

    buttonIndex = int(ev.Target.GetFloat("data"));
    // End:0xA8
    if(Buttons[buttonIndex - 1].IconMC.GetBool("_visible"))
    {
        SetInfo(buttonIndex);        
    }
    else
    {
        SetInfo(-1);
    }
    //return;    
}

function OnFocusArsenalTab(EventData ev)
{
    // End:0x11B
    if(!bArsenalTabFocused)
    {
        ArsenalTabMC.GotoAndPlay("on");
        BackpackTabMC.GotoAndPlay("off");
        LeftArrow01.GotoAndPlay("on");
        LeftArrow02.GotoAndPlay("off");
        ClearsTweensOnMovieClip(ArsenalMC, false);
        ClearsTweensOnMovieClip(BackpackMC, false);
        TweenTo(ArsenalMC, 0.5000000, "_z", -1500.0000000, 0, "");
        TweenTo(BackpackMC, 0.5000000, "_z", 0.0000000, 0, "");
        bArsenalTabFocused = true;
    }
    //return;    
}

function OnFocusBackpackTab(EventData ev)
{
    // End:0x119
    if(bArsenalTabFocused)
    {
        ArsenalTabMC.GotoAndPlay("off");
        BackpackTabMC.GotoAndPlay("on");
        LeftArrow01.GotoAndPlay("off");
        LeftArrow02.GotoAndPlay("on");
        ClearsTweensOnMovieClip(ArsenalMC, false);
        ClearsTweensOnMovieClip(BackpackMC, false);
        TweenTo(ArsenalMC, 0.5000000, "_z", 0.0000000, 0, "");
        TweenTo(BackpackMC, 0.5000000, "_z", -1500.0000000, 0, "");
        bArsenalTabFocused = false;
    }
    //return;    
}

function OnClickFakeItem(EventData ev)
{
    local UTPawn P;

    switch(ev.Target.GetFloat("data"))
    {
        // End:0xB8
        case 11.0000000:
            GetPC().Pawn.Health = GetPC().Pawn.HealthMax;
            return;
            // End:0x17E
            break;
        // End:0x178
        case 12.0000000:
            P = UTPawn(GetPC().Pawn);
            // End:0x173
            if(P != none)
            {
                P.PlayEmote('UseArmor', -1);
                P.VestArmor = float(Max(50, int(P.VestArmor)));
            }
            return;
            // End:0x17E
            break;
        // End:0xFFFF
        default:
            // End:0x17E
            break;
            break;
    }
    //return;    
}

function SetInfo(int Index)
{
    local string OldText;

    OldText = InfoText.GetText();
    // End:0xD3
    if(Index < 0)
    {
        // End:0xD0
        if(OldText != "")
        {
            InfoMC.GotoAndPlay("off");
            InfoIconWeap.GotoAndStopI(0);
            InfoText.SetText("");
            InfoTitle.SetText("");
        }        
    }
    else
    {
        InfoMC.GotoAndPlay("on");
        // End:0x1EA
        if(Items.Length >= Index)
        {
            InfoIconWeap.GotoAndStopI(int(Items[Index - 1].ItemFrame));
            InfoText.SetText(Items[Index - 1].ItemInfo);
            InfoTitle.SetText(Items[Index - 1].ItemName);
        }
    }
    //return;    
}

function PopulateArsenal()
{
    local byte I;

    // End:0x1A3
    if(GetPC().Pawn != none)
    {
        I = 0;
        J0x31:

        // End:0x1A3 [Loop If]
        if(int(I) < int(9))
        {
            // End:0x195
            if((WeaponClass[int(I) + int(1)] != none) && GetPC().Pawn.FindInventoryType(WeaponClass[int(I) + int(1)], true) != none)
            {
                Buttons[int(I)].IconMC.SetVisible(true);
                Buttons[int(I)].IconMC.GotoAndStopI(int(I) + int(2));
                Buttons[int(I)].SetFloat("data", float(int(I) + int(1)));
            }
            I++;
            // [Loop Continue]
            goto J0x31;
        }
    }
    //return;    
}

function FakeUpdateEquippedWeapon(int Index)
{
    local string CurrentWeaponString;

    CurrentWeaponString = string(Index);
    // End:0x3D
    if(Index < 10)
    {
        CurrentWeaponString = "0" $ CurrentWeaponString;
    }
    EquippedWeapon.GotoAndStopI(Index + 1);
    EquippedWeaponOutline.GotoAndPlay("equipped");
    EquippedWeaponText1.SetText(CurrentWeaponString);
    EquippedWeaponText2.SetText(CurrentWeaponString);
    //return;    
}

function UpdateEquippedWeapon()
{
    local byte CurrentWeapon;
    local string CurrentWeaponString;

    CurrentWeapon = EvilWeap_Base(GetPC().Pawn.Weapon).InventoryGroup;
    CurrentWeaponString = string(CurrentWeapon);
    // End:0x9D
    if(int(CurrentWeapon) < int(10))
    {
        CurrentWeaponString = "0" $ CurrentWeaponString;
    }
    EquippedWeapon.GotoAndStopI(int(CurrentWeapon) + int(1));
    EquippedWeaponText1.SetText(CurrentWeaponString);
    EquippedWeaponText2.SetText(CurrentWeaponString);
    //return;    
}

function ProcessTweenCallback(string Callback, GFxObject TargetMC)
{
    switch(Callback)
    {
        // End:0x34
        case "TweenTurbines1":
            TweenTurbines(true);
            // End:0xB5
            break;
        // End:0x55
        case "TweenTurbines2":
            TweenTurbines(false);
            // End:0xB5
            break;
        // End:0x82
        case "ContinueFloatCheck":
            FloatSelectionUp(TargetMC);
            // End:0xB5
            break;
        // End:0xAF
        case "FloatSelectionDown":
            FloatSelectionDown(TargetMC);
            // End:0xB5
            break;
        // End:0xFFFF
        default:
            // End:0xB5
            break;
            break;
    }
    //return;    
}

function TweenTurbines(bool Toggle)
{
    // End:0x8D
    if(Toggle)
    {
        TweenTo(BG_Optic1MC, 11.0000000, "_z", -1000.0000000, 0, "TweenTurbines2");
        TweenTo(BG_Optic3MC, 10.0000000, "_z", -2000.0000000, 0, "");
        TweenTo(BG_Optic4MC, 10.0000000, "_z", 2000.0000000, 0, "");        
    }
    else
    {
        TweenTo(BG_Optic1MC, 11.0000000, "_z", 1000.0000000, 0, "TweenTurbines1");
        TweenTo(BG_Optic3MC, 10.0000000, "_z", 2000.0000000, 0, "");
        TweenTo(BG_Optic4MC, 10.0000000, "_z", -2000.0000000, 0, "");
    }
    //return;    
}

function FloatSelectionUp(GFxObject ButtonIconMC)
{
    TweenTo(ButtonIconMC, 1.0000000, "_z", -600.0000000 * 4.0000000, 2, "FloatSelectionDown");
    //return;    
}

function FloatSelectionDown(GFxObject ButtonIconMC)
{
    TweenTo(ButtonIconMC, 1.0000000, "_z", -600.0000000 * 3.5000000, 2, "ContinueFloatCheck");
    //return;    
}

function UpdatePos()
{
    local float yawRadian, pitchRadian;
    local Matrix mYaw, mTranslate, mPitch, mFinal;

    mTranslate.XPlane.X = 1.0000000;
    mTranslate.YPlane.Y = 1.0000000;
    mTranslate.ZPlane.Z = 1.0000000;
    mTranslate.WPlane.W = 1.0000000;
    mYaw = mTranslate;
    mPitch = mTranslate;
    mTranslate.WPlane.X = PosX;
    mTranslate.WPlane.Y = PosY;
    yawRadian = float(-(16384 + (GetPC().Rotation.Yaw - StartRotation.Yaw)) & 65535) * (3.1415930 / 32768.0000000);
    yawRadian -= (float(3) * 1.5707960);
    pitchRadian = float(-(16384 + (GetPC().Rotation.Pitch - StartRotation.Pitch)) & 65535) * (3.1415930 / 32768.0000000);
    pitchRadian -= (float(3) * 1.5707960);
    mYaw.XPlane.X = Cos(yawRadian) * Scale;
    mYaw.XPlane.Z = -Sin(yawRadian) * Scale;
    mYaw.ZPlane.X = Sin(yawRadian) * Scale;
    mYaw.ZPlane.Z = Cos(yawRadian) * Scale;
    mPitch.YPlane.Y = Cos(pitchRadian) * Scale;
    mPitch.YPlane.Z = Sin(pitchRadian) * Scale;
    mPitch.ZPlane.Y = -Sin(pitchRadian) * Scale;
    mPitch.ZPlane.Z = Cos(pitchRadian) * Scale;
    mFinal = Multiply_MatrixMatrix(Multiply_MatrixMatrix(mYaw, mPitch), mTranslate);
    Window.SetDisplayMatrix3D(mFinal);
    //return;    
}

function CreateItemData()
{
    local byte I;
    local ItemData Data;

    I = 0;
    J0x0C:

    // End:0x138 [Loop If]
    if(int(I) < int(10))
    {
        // End:0xDB
        if(WeaponClass[int(I) + int(1)] != none)
        {
            Data.ItemName = WeaponClass[int(I) + int(1)].default.ItemName;
            Data.ItemInfo = WeaponClass[int(I) + int(1)].default.UseHintString;
        }
        Data.ItemFrame = byte(int(I) + int(2));
        Items[int(I)] = Data;
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    Data.ItemName = Class'EvilHealthPickupFactory'.default.PickupMessage;
    Data.ItemInfo = Class'EvilHealthPickupFactory'.default.UseHintMessage;
    Data.ItemFrame = 12;
    Items[10] = Data;
    Data.ItemName = Class'EvilArmorPickupFactory'.default.PickupMessage;
    Data.ItemInfo = Class'EvilArmorPickupFactory'.default.UseHintMessage;
    Data.ItemFrame = 13;
    Items[11] = Data;
    Data.ItemName = "DAMAGE AMPLIFIER";
    Data.ItemInfo = "Amplifies the user's damage by 4x.  Use with caution.";
    Data.ItemFrame = 14;
    Items[12] = Data;
    //return;    
}

defaultproperties
{
    bArsenalTabFocused=true
    rightThreshold=-10.9000000
    leftThreshold=-8.3400000
    bIgnoreMouseInput=true
}