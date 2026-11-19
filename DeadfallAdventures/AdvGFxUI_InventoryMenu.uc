class AdvGFxUI_InventoryMenu extends UTGFxTweenableMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject ArrowMC;
var GFxObject Arrow;
var GFxObject BgMC;
var GFxObject Btn1MC;
var GFxObject Btn2MC;
var GFxObject Btn3MC;
var GFxObject Btn4MC;
var GFxClikWidget Btn1;
var GFxClikWidget Btn2;
var GFxClikWidget Btn3;
var GFxClikWidget Btn4;
var GFxObject KursorMC;
var AdvTypes.EInventoryItem SelectedItem;
var float OldGameSpeed;

function bool Start(optional bool StartPaused = false)
{
    local EvilPawn P;
    local ASDisplayInfo DI;

    P = EvilPlayerController(GetPC()).MyEvilPawn;
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    BgMC = MenuMC.GetObject("bg");
    ArrowMC = MenuMC.GetObject("arrow_mc");
    Arrow = ArrowMC.GetObject("arrow").GetObject("arrow_g");
    KursorMC = RootMC.GetObject("cursor");
    Btn1MC = MenuMC.GetObject("btn1_mc");
    Btn2MC = MenuMC.GetObject("btn2_mc");
    Btn3MC = MenuMC.GetObject("btn3_mc");
    Btn4MC = MenuMC.GetObject("btn4_mc");
    Btn1 = GFxClikWidget(Btn1MC.GetObject("btn1", Class'GFxUI.GFxClikWidget'));
    Btn2 = GFxClikWidget(Btn2MC.GetObject("btn2", Class'GFxUI.GFxClikWidget'));
    Btn3 = GFxClikWidget(Btn3MC.GetObject("btn3", Class'GFxUI.GFxClikWidget'));
    Btn4 = GFxClikWidget(Btn4MC.GetObject("btn4", Class'GFxUI.GFxClikWidget'));
    // End:0x47C
    if(!GetPC().PlayerInput.bUsingGamepad)
    {
        Btn1.AddEventListener('CLIK_rollOver', OnButton1Select);
        Btn2.AddEventListener('CLIK_rollOver', OnButton2Select);
        Btn3.AddEventListener('CLIK_rollOver', OnButton3Select);
        Btn4.AddEventListener('CLIK_rollOver', OnButton4Select);
    }
    // End:0x5EB
    if(P != none)
    {
        // End:0x4E7
        if(P.FindInventoryType(Class'AdvInventoryItem_Compass') == none)
        {
            Btn4.SetBool("disabled", true);            
        }
        else
        {
            Btn4.SetBool("disabled", false);
        }
        // End:0x597
        if(P.FindInventoryType(Class'AdvInventoryItem_Notepad') == none)
        {
            Btn1.SetBool("disabled", true);
            Btn3.SetBool("disabled", true);            
        }
        else
        {
            Btn1.SetBool("disabled", false);
            Btn3.SetBool("disabled", false);
        }
    }
    KursorMC.SetPosition(640.0000000, 360.0000000);
    DI.hasAlpha = true;
    DI.Alpha = 0.0000000;
    KursorMC.SetDisplayInfo(DI);
    return true;
    //return ReturnValue;    
}

function UpdateFlashDisplayInfo(AdvTypes.EInventoryItem Item)
{
    local ASDisplayInfo DI;

    // End:0x11C
    if(int(Item) != int(0))
    {
        DI.hasRotation = true;
        switch(Item)
        {
            // End:0x70
            case 3:
                DI.Rotation = -90.0000000;
                // End:0xF4
                break;
            // End:0x9A
            case 4:
                DI.Rotation = 90.0000000;
                // End:0xF4
                break;
            // End:0xC4
            case 5:
                DI.Rotation = 0.0000000;
                // End:0xF4
                break;
            // End:0xEE
            case 6:
                DI.Rotation = 180.0000000;
                // End:0xF4
                break;
            // End:0xFFFF
            default:
                // End:0xF4
                break;
                break;
        }
        Arrow.SetDisplayInfo(DI);
    }
    ArrowMC.GotoAndPlay("in");
    //return;    
}

function OnButton1Select(EventData ev)
{
    SelectedItem = 3;
    UpdateFlashDisplayInfo(SelectedItem);
    //return;    
}

function OnButton2Select(EventData ev)
{
    SelectedItem = 5;
    UpdateFlashDisplayInfo(SelectedItem);
    //return;    
}

function OnButton3Select(EventData ev)
{
    SelectedItem = 4;
    UpdateFlashDisplayInfo(SelectedItem);
    //return;    
}

function OnButton4Select(EventData ev)
{
    SelectedItem = 6;
    UpdateFlashDisplayInfo(SelectedItem);
    //return;    
}

static function SelectInventory(AdvTypes.EInventoryItem Selection, EvilPlayerController PC)
{
    local class<AdvInventoryItem_Base> CurrItemClass;
    local AdvInventoryItem_Notepad Notepad;

    // End:0x24
    if(PC.isPlayerSliding())
    {
        return;
    }
    // End:0x1FB
    if(PC.MyEvilPawn != none)
    {
        CurrItemClass = class<AdvInventoryItem_Base>(PC.MyEvilPawn.EvilInvManager.BlockingClassLeft);
        // End:0x1FB
        if((((CurrItemClass == Class'AdvInventoryItem_Torch') && PC.MyEvilPawn.WeaponLeft != none) && PC.MyEvilPawn.WeaponLeft.IsInState('WeaponEquipping') || (PC.MyEvilPawn.Weapon != none) && PC.MyEvilPawn.Weapon.IsInState('ReloadState')) || PC.IsInState('Wounded_Base'))
        {
            return;
        }
    }
    // End:0x2A4
    if(CurrItemClass != none)
    {
        switch(Selection)
        {
            // End:0x248
            case 2:
                // End:0x245
                if(CurrItemClass == Class'AdvInventoryItem_Notepad')
                {
                    Selection = 5;
                }
                // End:0x2A1
                break;
            // End:0x273
            case 6:
                // End:0x270
                if(CurrItemClass == Class'AdvInventoryItem_Compass')
                {
                    Selection = 5;
                }
                // End:0x2A1
                break;
            // End:0x29E
            case 1:
                // End:0x29B
                if(CurrItemClass == Class'AdvInventoryItem_Torch')
                {
                    Selection = 5;
                }
                // End:0x2A1
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        // End:0x2DA
        if((int(Selection) == int(3)) || int(Selection) == int(4))
        {
            Selection = 2;
        }
    }
    switch(Selection)
    {
        // End:0x3BA
        case 6:
            // End:0x3B7
            if(PC.CanShowGameplayObject() && PC.MyEvilPawn.FindInventoryType(Class'AdvInventoryItem_Compass') != none)
            {
                PC.MyEvilPawn.SetBlockingInventoryClass(Class'AdvInventoryItem_Compass', true);
                PC.ShowGameplayObject();
            }
            // End:0x102D
            break;
        // End:0x6A5
        case 5:
            // End:0x62B
            if(((PC.MyEvilPawn.Weapon != none) && EvilWeap_Base(PC.MyEvilPawn.Weapon).BothHandWeapon) && AdvPlayerPawn(PC.MyEvilPawn).MyTorch.IsAttachedToAnotherWeapon())
            {
                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.bAutoActiveAfterEquip = false;
                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.TurnFlashlightOff();
                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.ClientTurnFlashlight(false);
                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.DetachFromWeapon();
                PC.MyEvilPawn.SetBlockingInventoryClass(none, true);                
            }
            else
            {
                // End:0x6A2
                if(PC.CanHideGameplayObject())
                {
                    PC.MyEvilPawn.SetBlockingInventoryClass(none, true);
                    PC.HideGameplayObject();
                }
            }
            // End:0x102D
            break;
        // End:0x6AA
        case 3:
        // End:0x772
        case 4:
            // End:0x772
            if(CurrItemClass == Class'AdvInventoryItem_Notepad')
            {
                // End:0x772
                if(PC.MyEvilPawn != none)
                {
                    Notepad = AdvInventoryItem_Notepad(PC.MyEvilPawn.FindInventoryType(Class'AdvInventoryItem_Notepad'));
                    // End:0x772
                    if(Notepad != none)
                    {
                        Notepad.TurnPage(Selection);
                    }
                }
            }
        // End:0x93E
        case 2:
            // End:0x93B
            if(PC.CanShowGameplayObject() && PC.MyEvilPawn.FindInventoryType(Class'AdvInventoryItem_Notepad') != none)
            {
                PC.MyEvilPawn.SetBlockingInventoryClass(Class'AdvInventoryItem_Notepad', true);
                // End:0x8E7
                if(AdvWeap_Base(PC.MyEvilPawn.Weapon) != none)
                {
                    PC.MyEvilPawn.SavedWeaponLeft = AdvWeap_Base(PC.MyEvilPawn.Weapon).OffHandWeaponClass;                    
                }
                else
                {
                    PC.MyEvilPawn.SavedWeaponLeft = none;
                }
                PC.ShowGameplayObject();
            }
            // End:0x102D
            break;
        // End:0x102A
        case 1:
            // End:0x1027
            if(PC.CanShowGameplayObject() && PC.MyEvilPawn.FindInventoryType(Class'AdvInventoryItem_Torch') != none)
            {
                // End:0xFCA
                if((((EvilWeap_Base(PC.MyEvilPawn.Weapon) != none) && EvilWeap_Base(PC.MyEvilPawn.Weapon).BothHandWeapon) && UDKSkeletalMeshComponent(EvilWeap_Base(PC.MyEvilPawn.Weapon).Mesh) != none) && UDKSkeletalMeshComponent(EvilWeap_Base(PC.MyEvilPawn.Weapon).Mesh).GetSocketByName('FlashLightSocket') != none)
                {
                    PC.MyEvilPawn.SetBlockingInventoryClass(Class'AdvInventoryItem_Torch', true);
                    // End:0xD09
                    if(AdvPlayerPawn(PC.MyEvilPawn).MyTorch.IsAttachedToAnotherWeapon())
                    {
                        AdvPlayerPawn(PC.MyEvilPawn).MyTorch.bAutoActiveAfterEquip = false;
                        AdvPlayerPawn(PC.MyEvilPawn).MyTorch.TurnFlashlightOff();
                        AdvPlayerPawn(PC.MyEvilPawn).MyTorch.ClientTurnFlashlight(false);
                        AdvPlayerPawn(PC.MyEvilPawn).MyTorch.DetachFromWeapon();                        
                    }
                    else
                    {
                        // End:0xFC7
                        if(AdvPlayerPawn(PC.MyEvilPawn).MyTorch.CanAttachToWeapon(EvilWeap_Base(PC.MyEvilPawn.Weapon)))
                        {
                            AdvPlayerPawn(PC.MyEvilPawn).MyTorch.AttachToWeapon(EvilWeap_Base(PC.MyEvilPawn.Weapon));
                            AdvPlayerPawn(PC.MyEvilPawn).MyTorch.TurnFlashlightOn();
                            AdvPlayerPawn(PC.MyEvilPawn).MyTorch.ClientTurnFlashlight(true);
                            // End:0xFC7
                            if(AdvPlayerPawn(PC.MyEvilPawn).MyTorch.bAutoActiveAfterEquip)
                            {
                                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.ActivateFlightBeam();
                                AdvPlayerPawn(PC.MyEvilPawn).MyTorch.ClientActivateFlightBeam();
                            }
                        }
                    }                    
                }
                else
                {
                    PC.MyEvilPawn.SetBlockingInventoryClass(Class'AdvInventoryItem_Torch', true);
                    PC.ShowGameplayObject();
                }
            }
            // End:0x102D
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function PlayOpenAnimation(AdvTypes.EInventoryItem Selection)
{
    local AdvPlayerController PC;
    local AdvPlayerInput AdvInput;

    MenuMC.GotoAndPlay("open");
    PC = AdvPlayerController(GetPC());
    PC.SetSprint(false);
    OldGameSpeed = PC.WorldInfo.Game.GameSpeed;
    PC.WorldInfo.Game.SetGameSpeed(0.0100000);
    // End:0x20B
    if(PC.PlayerInput.bUsingGamepad)
    {
        Btn1MC.GetObject("textField").SetText(" ");
        Btn3MC.GetObject("textField").SetText(" ");
        Btn4MC.GetObject("textField").SetText(" ");        
    }
    else
    {
        AdvInput = AdvPlayerInput(PC.PlayerInput);
        Btn1MC.GetObject("textField").SetText(Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadPrev", true)));
        Btn2MC.GetObject("textField").SetText("Scroll");
        Btn3MC.GetObject("textField").SetText(Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadNext", true)));
        Btn4MC.GetObject("textField").SetText(Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvInput.FindPrimaryBindingForCommand("GBA_PC_TEST_Compass", true)));
    }
    SelectedItem = Selection;
    UpdateFlashDisplayInfo(SelectedItem);
    //return;    
}

function PlayCloseAnimation()
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(GetPC());
    MenuMC.GotoAndPlay("close");
    PC.WorldInfo.Game.SetGameSpeed(OldGameSpeed);
    Btn1.RemoveAllEventListeners("rollOver");
    Btn1.RemoveAllEventListeners("rollOut");
    Btn2.RemoveAllEventListeners("rollOver");
    Btn2.RemoveAllEventListeners("rollOut");
    Btn3.RemoveAllEventListeners("rollOver");
    Btn3.RemoveAllEventListeners("rollOut");
    Btn4.RemoveAllEventListeners("rollOver");
    Btn4.RemoveAllEventListeners("rollOut");
    SelectInventory(SelectedItem, PC);
    SelectedItem = 0;
    //return;    
}

function OnPlayAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    AdvGFxHudWrapper(GetPC().myHUD).CompleteQuickMenuClose();
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x16
    if(int(InputEvent) == int(1))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    //return;    
}

defaultproperties
{
    bCaptureAxisInput=true
    bResetMousePositionOnStart=true
}