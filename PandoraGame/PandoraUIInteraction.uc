class PandoraUIInteraction extends UIInteraction within PandoraGameViewportClient
    transient
    native
    config(LevelInfo);

enum EMenuState
{
    EMS_INIT,                       // 0
    EMS_PUBLISHER_SCREEN_FADEIN,    // 1
    EMS_PUBLISHER_SCREEN_WAIT,      // 2
    EMS_PUBLISHER_SCREEN_FADEOUT,   // 3
    EMS_SPARK_SCREEN_FADEIN,        // 4
    EMS_SPARK_SCREEN_WAIT,          // 5
    EMS_PANDORA_SCREEN_FADEIN,      // 6
    EMS_PANDORA_SCREEN_WAIT,        // 7
    EMS_PANDORA_SCREEN_MENUTRANS,   // 8
    EMS_MENU,                       // 9
    EMS_LEVEL_TRANSITION_FADEIN,    // 10
    EMS_MENU_TRANS,                 // 11
    EDMS_INIT,                      // 12
    EDMS_FADE_BLACK,                // 13
    EDMS_FADE_PANDORA,              // 14
    EDMS_FADE_PANDORA_WAIT,         // 15
    EDMS_FADE_LOADING,              // 16
    EDMS_END,                       // 17
    EMenuState_MAX                  // 18
};

struct native MenuItem
{
    var string ItemName;
    var string ItemCmd;
    var float XPos;
    var float YPos;

    structdefaultproperties
    {
        ItemName=""
        ItemCmd=""
        XPos=0.0000000
        YPos=0.0000000
    }
};

struct native UIMenu
{
    var string MenuName;
    var array<MenuItem> MenuItems;
    var float X;
    var float Y;
    var float Width;
    var float Height;

    structdefaultproperties
    {
        MenuName=""
        MenuItems=none
        X=0.0000000
        Y=0.0000000
        Width=0.0000000
        Height=0.0000000
    }
};

var int ScreenWidth;
var int ScreenHeight;
var int SelectWidth;
var int SelectHeight;
var int SelectStartX;
var int SelectStartY;
var int SelectBarPosX;
var int SelectBarWidth;
var int FontHeight;
var Texture2D LoadBackground;
var UIScene myUIScene;
var UIMenu LevelMenu;
var UIMenu MainMenu;
var UIMenu SpawnMenu;
var UIMenu ActiveMenu;
var UIMenu UIPauseMenu;
var int CurrentMenuItem;
var bool bMoveUp;
var bool bMoveDown;
var bool bExecute;
var bool bBack;
var bool bTimerStart;
var bool bInitSetMainE3;
var bool bInitSet;
var bool bInitPauseMenu;
var config bool bE3Build;
var int SelectBarY;
var int SelectBarDestY;
var int SelectBarSpeed;
var float TickUpdate;
var Color FadeColor;
var int Timer;
var PandoraUIInteraction.EMenuState MenuState;
var int LoadTick;
var SoundCue SoundScroll;
var SoundCue SoundConfirm;
var config array<config MenuItem> LevelInfo;
var config int LevelInfoMax;
var Font itemFont;
var Font itemFocusedFont;
var Font titleFont;

function ClearKeyStates()
{
    bMoveUp = false;
    bMoveDown = false;
    bExecute = false;
    bBack = false;
    CurrentMenuItem = 0;
    //return;    
}

function Reset()
{
    ClearKeyStates();
    //return;    
}

function AssignScreenSize()
{
    local Vector2D VSize;

    Outer.GetViewportSize(VSize);
    ScreenWidth = int(VSize.X);
    ScreenHeight = int(VSize.Y);
    SelectWidth = (512 * ScreenWidth) / 640;
    SelectHeight = (40 * ScreenHeight) / 480;
    SelectStartX = (75 * ScreenWidth) / 640;
    SelectStartY = (255 * ScreenHeight) / 480;
    SelectBarPosX = (60 * ScreenWidth) / 640;
    SelectBarWidth = (512 * ScreenWidth) / 640;
    FontHeight = 30;
    //return;    
}

function bool InputKey(int ControllerId, name Key, Object.EInputEvent EventType, optional float AmountDepressed = 1.0000000, optional bool bGamepad)
{
    // End:0x10A
    if(bE3Build && ActiveMenu.MenuName != "Paused")
    {
        // End:0x7C
        if(((Key == 'Left') || Key == 'XboxTypeS_DPad_Left') && int(EventType) == int(0))
        {
            bMoveUp = true;
            bMoveDown = false;
        }
        // End:0xC6
        if(((Key == 'Right') || Key == 'XboxTypeS_DPad_Right') && int(EventType) == int(0))
        {
            bMoveUp = false;
            bMoveDown = true;
        }
        // End:0x108
        if(((Key == 'Enter') || Key == 'XboxTypeS_A') && int(EventType) == int(0))
        {
            bExecute = true;
        }
        return false;
    }
    // End:0x154
    if(((Key == 'Up') || Key == 'XboxTypeS_DPad_Up') && int(EventType) == int(0))
    {
        bMoveUp = true;
        bMoveDown = false;
    }
    // End:0x19E
    if(((Key == 'Down') || Key == 'XboxTypeS_DPad_Down') && int(EventType) == int(0))
    {
        bMoveUp = false;
        bMoveDown = true;
    }
    // End:0x1E0
    if(((Key == 'Enter') || Key == 'XboxTypeS_A') && int(EventType) == int(0))
    {
        bExecute = true;
    }
    // End:0x222
    if(((Key == 'Escape') || Key == 'XboxTypeS_B') && int(EventType) == int(0))
    {
        bBack = true;
    }
    return true;
    //return ReturnValue;    
}

function SetActiveMenu(UIMenu Menu)
{
    ActiveMenu = Menu;
    //return;    
}

function BuildActiveMenuFromTransitionData()
{
    local int I, num_items;
    local Vector2D VSize;

    Outer.GetViewportSize(VSize);
    ScreenWidth = int(VSize.X);
    ScreenHeight = int(VSize.Y);
    // End:0x22F
    if(bE3Build)
    {
        ActiveMenu.MenuName = "";
        ActiveMenu.MenuItems.Remove(0, ActiveMenu.MenuItems.Length);
        ActiveMenu.MenuItems.Length = 0;
        ActiveMenu.X = 170.0000000;
        ActiveMenu.Y = float(ScreenHeight) * 0.1000000;
        ActiveMenu.Height = float(ScreenHeight) * 0.8000000;
        ActiveMenu.Width = 512.0000000;
        num_items = 2;
        ActiveMenu.MenuItems.Insert(0, num_items);
        I = 0;
        J0x127:

        // End:0x22C [Loop If]
        if(I < num_items)
        {
            ActiveMenu.MenuItems[I].XPos = ActiveMenu.X + float(I * ((ScreenWidth / 2) + 40));
            ActiveMenu.MenuItems[I].YPos = ActiveMenu.Y;
            ActiveMenu.MenuItems[I].ItemName = LevelInfo[I].ItemName;
            ActiveMenu.MenuItems[I].ItemCmd = LevelInfo[I].ItemCmd;
            I++;
            // [Loop Continue]
            goto J0x127;
        }        
    }
    else
    {
        ActiveMenu.MenuName = "";
        ActiveMenu.MenuItems.Remove(0, ActiveMenu.MenuItems.Length);
        ActiveMenu.MenuItems.Length = 0;
        ActiveMenu.X = 10.0000000;
        ActiveMenu.Y = float(ScreenHeight) * 0.1250000;
        ActiveMenu.Height = float(ScreenHeight) * 0.7000000;
        ActiveMenu.Width = 512.0000000;
        num_items = LevelInfo.Length;
        ActiveMenu.MenuItems.Insert(0, num_items);
        I = 0;
        J0x30C:

        // End:0x3D7 [Loop If]
        if(I < num_items)
        {
            ActiveMenu.MenuItems[I].YPos = ActiveMenu.Y + float(I * FontHeight);
            ActiveMenu.MenuItems[I].ItemName = LevelInfo[I].ItemName;
            ActiveMenu.MenuItems[I].ItemCmd = LevelInfo[I].ItemCmd;
            I++;
            // [Loop Continue]
            goto J0x30C;
        }
    }
    //return;    
}

function InitPauseMenu()
{
    local int I;

    UIPauseMenu.X = 10.0000000;
    UIPauseMenu.Y = 245.0000000;
    UIPauseMenu.Height = 240.0000000;
    UIPauseMenu.Width = 512.0000000;
    I = 0;
    J0x5F:

    // End:0xC6 [Loop If]
    if(I < UIPauseMenu.MenuItems.Length)
    {
        UIPauseMenu.MenuItems[I].YPos = UIPauseMenu.Y + float(I * FontHeight);
        I++;
        // [Loop Continue]
        goto J0x5F;
    }
    //return;    
}

exec function PlayState()
{
    //return;    
}

exec function MainMenuState()
{
    //return;    
}

exec function PlaySoundScroll()
{
    Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundScroll);
    //return;    
}

exec function PlaySoundConfirm()
{
    Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundConfirm);
    //return;    
}

// Export UPandoraUIInteraction::execCleanUpMenu(FFrame&, void* const)
native function CleanUpMenu();

function ExitMenuInternal()
{
    Outer.ExitMenu();
    CleanUpMenu();
    //return;    
}

function UpdateMenuLogic()
{
    local string ItemCmd;
    local int I;

    // End:0x115
    if(bExecute)
    {
        Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundConfirm);
        bExecute = false;
        ItemCmd = ActiveMenu.MenuItems[CurrentMenuItem].ItemCmd;
        // End:0x95
        if(ItemCmd == "end")
        {
            bInitSet = false;
            ExitMenuInternal();            
        }
        else
        {
            // End:0xDE
            if(ItemCmd == "pause")
            {
                bInitSet = false;
                Outer.ViewportConsole.ConsoleCommand(ItemCmd);
                ExitMenuInternal();                
            }
            else
            {
                bInitSet = false;
                ExitMenuInternal();
                Outer.ViewportConsole.ConsoleCommand(ItemCmd);
            }
        }
        return;
    }
    // End:0x20C
    if(bE3Build)
    {
        // End:0x194
        if(bMoveUp)
        {
            Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundScroll);
            CurrentMenuItem--;
            // End:0x18C
            if(CurrentMenuItem < 0)
            {
                CurrentMenuItem = ActiveMenu.MenuItems.Length - 1;
            }
            bMoveUp = false;
        }
        // End:0x20A
        if(bMoveDown)
        {
            Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundScroll);
            CurrentMenuItem++;
            // End:0x202
            if(CurrentMenuItem > (ActiveMenu.MenuItems.Length - 1))
            {
                CurrentMenuItem = 0;
            }
            bMoveDown = false;
        }
        return;
    }
    // End:0x2F4
    if(bMoveUp)
    {
        Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundScroll);
        // End:0x2EC
        if(CurrentMenuItem > 0)
        {
            CurrentMenuItem--;
            // End:0x2EC
            if(ActiveMenu.MenuItems[CurrentMenuItem].YPos < ActiveMenu.Y)
            {
                I = 0;
                J0x29D:

                // End:0x2EC [Loop If]
                if(I < ActiveMenu.MenuItems.Length)
                {
                    ActiveMenu.MenuItems[I].YPos += float(FontHeight);
                    I++;
                    // [Loop Continue]
                    goto J0x29D;
                }
            }
        }
        bMoveUp = false;
    }
    // End:0x401
    if(bMoveDown)
    {
        Outer.Outer.GetCurrentWorldInfo().Game.PlaySound(SoundScroll);
        // End:0x3F9
        if(CurrentMenuItem < (ActiveMenu.MenuItems.Length - 1))
        {
            CurrentMenuItem++;
            // End:0x3F9
            if(ActiveMenu.MenuItems[CurrentMenuItem].YPos >= (ActiveMenu.Y + ActiveMenu.Height))
            {
                I = 0;
                J0x3AA:

                // End:0x3F9 [Loop If]
                if(I < ActiveMenu.MenuItems.Length)
                {
                    ActiveMenu.MenuItems[I].YPos -= float(FontHeight);
                    I++;
                    // [Loop Continue]
                    goto J0x3AA;
                }
            }
        }
        bMoveDown = false;
    }
    // End:0x414
    if(bBack)
    {
        ExitMenuInternal();
    }
    //return;    
}

function RenderMenu(Canvas Canvas)
{
    local int I;

    // End:0x27
    if(ActiveMenu.MenuName == "exit")
    {
        ExitMenuInternal();
        return;
    }
    // End:0x16D
    if(bE3Build && ActiveMenu.MenuName != "Paused")
    {
        I = 0;
        J0x56:

        // End:0x16B [Loop If]
        if(I < ActiveMenu.MenuItems.Length)
        {
            // End:0xAF
            if(I == CurrentMenuItem)
            {
                Canvas.SetDrawColor(242, 239, 219);
                Canvas.Font = itemFocusedFont;                
            }
            else
            {
                Canvas.SetDrawColor(10, 10, 10);
                Canvas.Font = itemFont;
            }
            Canvas.SetPos(ActiveMenu.MenuItems[I].XPos, ActiveMenu.MenuItems[I].YPos);
            Canvas.DrawText(ActiveMenu.MenuItems[I].ItemName);
            I++;
            // [Loop Continue]
            goto J0x56;
        }
        return;
    }
    // End:0x224
    if((ActiveMenu.MenuName == "Paused") || ActiveMenu.MenuName == "Select")
    {
        Canvas.Font = titleFont;
        Canvas.SetPos(5.0000000, 200.0000000);
        Canvas.bCenter = true;
        Canvas.SetDrawColor(0, 0, 255);
        Canvas.DrawText(ActiveMenu.MenuName);
    }
    Canvas.bCenter = true;
    I = 0;
    J0x23D:

    // End:0x3B6 [Loop If]
    if(I < ActiveMenu.MenuItems.Length)
    {
        // End:0x296
        if(I == CurrentMenuItem)
        {
            Canvas.SetDrawColor(242, 239, 219);
            Canvas.Font = itemFocusedFont;            
        }
        else
        {
            Canvas.SetDrawColor(213, 179, 115);
            Canvas.Font = itemFont;
        }
        // End:0x3AC
        if((ActiveMenu.MenuItems[I].YPos < (ActiveMenu.Y + ActiveMenu.Height)) && ActiveMenu.MenuItems[I].YPos >= ActiveMenu.Y)
        {
            Canvas.SetPos(0.0000000, ActiveMenu.MenuItems[I].YPos);
            Canvas.DrawText(ActiveMenu.MenuItems[I].ItemName);
        }
        I++;
        // [Loop Continue]
        goto J0x23D;
    }
    //return;    
}

function FadeIn(PandoraUIInteraction.EMenuState new_state, Canvas Canvas, Texture2D Tex)
{
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(FadeColor.R, FadeColor.G, FadeColor.B, FadeColor.A);
    Canvas.DrawTile(Tex, float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    // End:0x104
    if(((int(FadeColor.R) == int(255)) && int(FadeColor.G) == int(255)) && int(FadeColor.B) == int(255))
    {
        MenuState = new_state;
        return;
    }
    FadeColor.R++;
    FadeColor.G++;
    FadeColor.B++;
    //return;    
}

function FadeInBlack(PandoraUIInteraction.EMenuState new_state, Canvas Canvas, Texture2D Tex)
{
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(0, 0, 0, FadeColor.A);
    FadeColor.A++;
    // End:0x78
    if(int(FadeColor.A) >= int(255))
    {
        MenuState = new_state;
    }
    //return;    
}

function FadeOut(PandoraUIInteraction.EMenuState new_state, Canvas Canvas, Texture2D Tex)
{
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(FadeColor.R, FadeColor.G, FadeColor.B, 255);
    Canvas.DrawTile(Tex, float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    FadeColor.R--;
    FadeColor.G--;
    FadeColor.B--;
    // End:0x12C
    if(((int(FadeColor.R) <= int(0)) || int(FadeColor.G) <= int(0)) || int(FadeColor.B) <= int(0))
    {
        MenuState = new_state;
        return;
    }
    //return;    
}

function CrossFade(PandoraUIInteraction.EMenuState new_state, Canvas Canvas, Texture2D tex0, Texture2D tex1)
{
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(FadeColor.R, FadeColor.G, FadeColor.B, 255);
    Canvas.DrawTile(tex1, float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(FadeColor.R, FadeColor.G, FadeColor.B, FadeColor.A);
    Canvas.DrawTile(tex0, float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    // End:0x161
    if((int(FadeColor.A) - int(2)) <= 0)
    {
        MenuState = new_state;
        return;
    }
    FadeColor.A -= 2;
    //return;    
}

function DrawScreen(Canvas Canvas, Texture2D Tex)
{
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawTile(Tex, float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    //return;    
}

function delay(PandoraUIInteraction.EMenuState new_state, int F)
{
    Timer++;
    // End:0x28
    if(Timer >= F)
    {
        Timer = 0;
        MenuState = new_state;
    }
    //return;    
}

function DrawE3MenuState(Canvas Canvas)
{
    //return;    
}

function ResetFadeColorBlack()
{
    FadeColor.R = 0;
    FadeColor.G = 0;
    FadeColor.B = 0;
    FadeColor.A = 255;
    //return;    
}

function ResetFadeColorWhite()
{
    FadeColor.R = 255;
    FadeColor.G = 255;
    FadeColor.B = 255;
    FadeColor.A = 255;
    //return;    
}

function RenderE3Menu(Canvas Canvas)
{
    AssignScreenSize();
    //return;    
}

function RenderE3EndMenu(Canvas Canvas)
{
    AssignScreenSize();
    //return;    
}

function ResetDrawColor(Canvas Canvas)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    //return;    
}

function DrawBlack(Canvas Canvas)
{
    Canvas.SetDrawColor(0, 0, 0, 255);
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.DrawTile(Texture2D'PandoraShell.Texture.Sub_menu_frame', float(ScreenWidth), float(ScreenHeight), 0.0000000, 0.0000000, 1024.0000000, 1024.0000000);
    //return;    
}

function RenderLoadingScreenOverlay(Canvas Canvas)
{
    local float screen_center_y;

    AssignScreenSize();
    screen_center_y = float((ScreenHeight / 2) + 120);
    Canvas.Font = itemFocusedFont;
    Canvas.SetPos(0.0000000, screen_center_y);
    Canvas.bCenter = true;
    Canvas.SetDrawColor(255, 230, 80);
    Canvas.DrawText("Loading. . .");
    //return;    
}

function RenderLoadingScreen(Canvas Canvas)
{
    local float screen_center_y;

    AssignScreenSize();
    screen_center_y = float((ScreenHeight / 2) + 120);
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.DrawTile(LoadBackground, Canvas.ClipX, Canvas.ClipY, 0.0000000, 0.0000000, 1280.0000000, 720.0000000);
    Canvas.Font = itemFocusedFont;
    Canvas.SetPos(0.0000000, screen_center_y);
    Canvas.bCenter = true;
    Canvas.SetDrawColor(255, 230, 80);
    Canvas.DrawText("Loading. . .");
    //return;    
}
