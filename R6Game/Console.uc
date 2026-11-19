class Console extends Interaction within GameViewportClient
    transient
    native
    config(Input);

const MaxHistory = 16;

var LocalPlayer ConsoleTargetPlayer;
var ConsoleEntry MiniConsole;
var UISceneConsole ConsoleScene;
var globalconfig name ConsoleKey;
var globalconfig name AlternativeConsoleKey;
var globalconfig name TypeKey;
var globalconfig int MaxScrollbackSize;
var array<string> Scrollback;
var int SBHead;
var int SBPos;
var config int HistoryTop;
var config int HistoryBot;
var config int HistoryCur;
var config string History[16];
var string TypedStr;
var int TypedStrPos;
var bool bIgnoreKeys;
var bool bCtrl;
var bool bBlockCmdConsole;
var config bool bEnableUI;
var Texture2D TextureWhite;
var Texture2D TextureBlack;
var array<string> MTCacheScrollback;
var string MTCacheTypedStr;
var int MTCacheTypedStrPos;
var int MTCacheSBHead;
var int MTCacheSBPos;

function Initialized()
{
    Initialized();
    // End:0x18
    if(bEnableUI)
    {
        bEnableUI = false;
    }
    return;
}

function SetInputText(string Text)
{
    TypedStr = Text;
    // End:0x47
    if(bEnableUI)
    {
        MiniConsole.SetValue(Text);
        ConsoleScene.CommandRegion.SetValue(Text);
    }
    return;
}

function SetCursorPos(int Position)
{
    TypedStrPos = Position;
    // End:0x45
    if(bEnableUI)
    {
        MiniConsole.CursorPosition = Position;
        ConsoleScene.CommandRegion.CursorPosition = Position;
    }
    return;
}

// Export UConsole::execIsBlank(FFrame&, void* const)
native final function bool IsBlank(string szString);

function ConsoleCommand(string Command)
{
    local string CommandCaps, Prefix;

    CommandCaps = Caps(Command);
    Prefix = Left(CommandCaps, 3);
    // End:0x2D
    if(Prefix != "PB_")
    {
        return;
    }
    History[HistoryTop] = Command;
    HistoryTop = int(float(HistoryTop + 1) % float(16));
    // End:0x8E
    if((HistoryBot == -1) || HistoryBot == HistoryTop)
    {
        HistoryBot = int(float(HistoryBot + 1) % float(16));
    }
    HistoryCur = HistoryTop;
    SaveConfig();
    OutputText(("\n<<<" $ Command) $ ">>>");
    // End:0xE9
    if(ConsoleTargetPlayer != none)
    {        
        ConsoleTargetPlayer.Actor.ConsoleCommand(Command);        
    }
    else
    {
        // End:0x16C
        if((Outer.Outer.GamePlayers.Length > 0) && Outer.Outer.GamePlayers[0].Actor != none)
        {            
            Outer.Outer.GamePlayers[0].Actor.ConsoleCommand(Command);            
        }
        else
        {            
            Outer.ConsoleCommand(Command);
        }
    }
    return;
}

function ClearOutput()
{
    SBHead = 0;
    Scrollback.Remove(0, Scrollback.Length);
    // End:0x37
    if(bEnableUI)
    {
        ConsoleScene.BufferText.SetValue("");
    }
    return;
}

function OutputTextLine(coerce string Text)
{
    // End:0x29
    if(Scrollback.Length > MaxScrollbackSize)
    {
        Scrollback.Remove(0, 1);
        SBHead = MaxScrollbackSize - 1;        
    }
    else
    {
        SBHead++;
    }
    Scrollback.Length = Scrollback.Length + 1;
    Scrollback[SBHead] = Text;
    // End:0x77
    if(bEnableUI)
    {
        ConsoleScene.BufferText.SetArrayValue(Scrollback);
    }
    return;
}

event OutputText(coerce string Text)
{
    local string RemainingText;
    local int StringLength, LineLength;

    RemainingText = Text;
    StringLength = Len(Text);
    J0x18:

    // End:0x88 [Loop If]
    if(StringLength > 0)
    {
        LineLength = InStr(RemainingText, "\n");
        // End:0x4D
        if(LineLength == -1)
        {
            LineLength = StringLength;
        }
        OutputTextLine(Left(RemainingText, LineLength));
        RemainingText = Mid(RemainingText, LineLength + 1);
        StringLength -= (LineLength + 1);
        // [Loop Continue]
        goto J0x18;
    }
    return;
}

function StartTyping(coerce string Text)
{
    GotoState('Typing');
    SetInputText(Text);
    SetCursorPos(Len(Text));
    return;
}

event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed)
{
    1.0000000
    // End:0x57
    if((!bBlockCmdConsole && (Key == ConsoleKey) || Key == AlternativeConsoleKey) && int(Event) == int(0))
    {
        GotoState('Open');
        return true;        
    }
    else
    {
        // End:0x87
        if((Key == TypeKey) && int(Event) == int(0))
        {
            GotoState('Typing');
            return true;            
        }
        else
        {
            return InputKey(ControllerId, Key, Event, AmountDepressed);
        }
    }
    return;
}

event SetBlockCmdConsole(bool blockCmd)
{
    bBlockCmdConsole = blockCmd;
    return;
}

state Typing
{
    event bool InputChar(int ControllerId, string Unicode)
    {
        local int Character;

        // End:0x0B
        if(bIgnoreKeys)
        {
            return true;
        }
        J0x0B:

        // End:0xBB [Loop If]
        if(Len(Unicode) > 0)
        {
            Character = Asc(Left(Unicode, 1));
            Unicode = Mid(Unicode, 1);
            // End:0xB8
            if((((Character >= 32) && Character < 256) && Character != Asc("~")) && Character != Asc("`"))
            {
                SetInputText((Left(TypedStr, TypedStrPos) $ Chr(Character)) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos + 1);
            }
            // [Loop Continue]
            goto J0x0B;
        }
        return true;
        return;
    }

    event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed)
    {
        local string Temp;
        local int iAux;

        1.0000000
        // End:0x21
        if(int(Event) == int(0))
        {
            bIgnoreKeys = false;
        }
        // End:0x7E
        if((Key == 'Escape') && int(Event) == int(1))
        {
            // End:0x6F
            if(TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryTop;
                return true;                
            }
            else
            {
                GotoState('None');
            }
            return true;            
        }
        else
        {
            // End:0xCC
            if((!bBlockCmdConsole && (Key == ConsoleKey) || Key == AlternativeConsoleKey) && int(Event) == int(0))
            {
                GotoState('Open');
                return true;                
            }
            else
            {
                // End:0xFC
                if((Key == TypeKey) && int(Event) == int(0))
                {
                    GotoState('None');
                    return true;                    
                }
                else
                {
                    // End:0x164
                    if(Key == 'Enter')
                    {
                        // End:0x155
                        if(TypedStr != "")
                        {
                            Temp = TypedStr;
                            SetInputText("");
                            SetCursorPos(0);
                            ConsoleCommand(Temp);
                            OutputText("");
                            GotoState('None');                            
                        }
                        else
                        {
                            GotoState('None');
                        }
                        return true;                        
                    }
                    else
                    {
                        // End:0x187
                        if(InputKey(ControllerId, Key, Event, AmountDepressed))
                        {
                            return true;                            
                        }
                        else
                        {
                            // End:0x1AE
                            if((int(Event) != int(0)) && int(Event) != int(2))
                            {
                                return false;                                
                            }
                            else
                            {
                                // End:0x29C
                                if(Key == 'Up')
                                {
                                    // End:0x297
                                    if(HistoryBot >= 0)
                                    {
                                        // End:0x1E5
                                        if(HistoryCur == HistoryBot)
                                        {
                                            HistoryCur = HistoryTop;                                            
                                        }
                                        else
                                        {
                                            HistoryCur--;
                                            // End:0x202
                                            if(HistoryCur < 0)
                                            {
                                                HistoryCur = 16 - 1;
                                            }
                                        }
                                        iAux = HistoryCur;
                                        J0x20D:

                                        // End:0x253 [Loop If]
                                        if(IsBlank(History[HistoryCur]))
                                        {
                                            HistoryCur--;
                                            // End:0x23E
                                            if(HistoryCur < 0)
                                            {
                                                HistoryCur = 16 - 1;
                                            }
                                            // End:0x250
                                            if(HistoryCur == iAux)
                                            {
                                                // [Explicit Break]
                                                goto J0x253;
                                            }
                                            // [Loop Continue]
                                            goto J0x20D;
                                        }
                                        J0x253:

                                        TypedStr = History[HistoryCur];
                                        TypedStrPos = Len(TypedStr);
                                        SetInputText(History[HistoryCur]);
                                        SetCursorPos(Len(History[HistoryCur]));
                                    }
                                    return true;                                    
                                }
                                else
                                {
                                    // End:0x36A
                                    if(Key == 'Down')
                                    {
                                        // End:0x367
                                        if(HistoryBot >= 0)
                                        {
                                            // End:0x2D3
                                            if(HistoryCur == HistoryTop)
                                            {
                                                HistoryCur = HistoryBot;                                                
                                            }
                                            else
                                            {
                                                HistoryCur = int(float(HistoryCur + 1) % float(16));
                                            }
                                            iAux = HistoryCur;
                                            J0x2F6:

                                            // End:0x337 [Loop If]
                                            if(IsBlank(History[HistoryCur]))
                                            {
                                                HistoryCur = int(float(HistoryCur + 1) % float(16));
                                                // End:0x334
                                                if(HistoryCur == iAux)
                                                {
                                                    // [Explicit Break]
                                                    goto J0x337;
                                                }
                                                // [Loop Continue]
                                                goto J0x2F6;
                                            }
                                            J0x337:

                                            TypedStr = History[HistoryCur];
                                            TypedStrPos = Len(TypedStr);
                                            SetInputText(History[HistoryCur]);
                                        }                                        
                                    }
                                    else
                                    {
                                        // End:0x3C5
                                        if(Key == 'BackSpace')
                                        {
                                            // End:0x3C0
                                            if(TypedStrPos > 0)
                                            {
                                                SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                                                SetCursorPos(TypedStrPos - 1);
                                            }
                                            return true;                                            
                                        }
                                        else
                                        {
                                            // End:0x417
                                            if(Key == 'Delete')
                                            {
                                                // End:0x412
                                                if(TypedStrPos < Len(TypedStr))
                                                {
                                                    SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, (Len(TypedStr) - TypedStrPos) - 1));
                                                }
                                                return true;                                                
                                            }
                                            else
                                            {
                                                // End:0x43D
                                                if(Key == 'Left')
                                                {
                                                    SetCursorPos(Max(0, TypedStrPos - 1));
                                                    return true;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x469
                                                    if(Key == 'Right')
                                                    {
                                                        SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
                                                        return true;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x485
                                                        if(Key == 'Home')
                                                        {
                                                            SetCursorPos(0);
                                                            return true;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x4A4
                                                            if(Key == 'End')
                                                            {
                                                                SetCursorPos(Len(TypedStr));
                                                                return true;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x1A
        if(bEnableUI)
        {
            MiniConsole.SetVisibility(true);
        }
        bIgnoreKeys = true;
        HistoryCur = HistoryTop;
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(MiniConsole != none)
        {
            MiniConsole.SetVisibility(false);
        }
        return;
    }
    stop;
}

state Open
{
    event bool InputChar(int ControllerId, string Unicode)
    {
        local int Character;

        // End:0x0B
        if(bIgnoreKeys)
        {
            return true;
        }
        J0x0B:

        // End:0xBB [Loop If]
        if(Len(Unicode) > 0)
        {
            Character = Asc(Left(Unicode, 1));
            Unicode = Mid(Unicode, 1);
            // End:0xB8
            if((((Character >= 32) && Character < 256) && Character != Asc("~")) && Character != Asc("`"))
            {
                SetInputText((Left(TypedStr, TypedStrPos) $ Chr(Character)) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos + 1);
            }
            // [Loop Continue]
            goto J0x0B;
        }
        return true;
        return;
    }

    event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed)
    {
        local string Temp;

        1.0000000
        // End:0x21
        if(int(Event) == int(0))
        {
            bIgnoreKeys = false;
        }
        // End:0x65
        if(Key == 'LeftControl')
        {
            // End:0x4B
            if(int(Event) == int(1))
            {
                bCtrl = false;                
            }
            else
            {
                // End:0x63
                if(int(Event) == int(0))
                {
                    bCtrl = true;
                }
            }
            return true;
        }
        // End:0xAE
        if(Key == 'Escape')
        {
            // End:0xA1
            if(TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryTop;
                return true;                
            }
            else
            {
                GotoState('None');
            }            
        }
        else
        {
            // End:0xFC
            if((!bBlockCmdConsole && (Key == ConsoleKey) || Key == AlternativeConsoleKey) && int(Event) == int(0))
            {
                GotoState('None');
                return true;                
            }
            else
            {
                // End:0x129
                if((Key == TypeKey) && int(Event) == int(0))
                {
                    GotoState('Typing');
                    return true;
                }
            }
        }
        // End:0x18A
        if(Key == 'Enter')
        {
            // End:0x185
            if(TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                // End:0x179
                if(Temp ~= "cls")
                {
                    ClearOutput();                    
                }
                else
                {
                    ConsoleCommand(Temp);
                }
            }
            return true;            
        }
        else
        {
            // End:0x1AD
            if(InputKey(ControllerId, Key, Event, AmountDepressed))
            {
                return true;                
            }
            else
            {
                // End:0x1D4
                if((int(Event) != int(0)) && int(Event) != int(2))
                {
                    return false;                    
                }
                else
                {
                    // End:0x29A
                    if(Key == 'Up')
                    {
                        // End:0x25C
                        if(!bCtrl)
                        {
                            // End:0x259
                            if(HistoryBot >= 0)
                            {
                                // End:0x216
                                if(HistoryCur == HistoryBot)
                                {
                                    HistoryCur = HistoryTop;                                    
                                }
                                else
                                {
                                    HistoryCur--;
                                    // End:0x233
                                    if(HistoryCur < 0)
                                    {
                                        HistoryCur = 16 - 1;
                                    }
                                }
                                SetInputText(History[HistoryCur]);
                                SetCursorPos(Len(History[HistoryCur]));
                            }                            
                        }
                        else
                        {
                            // End:0x295
                            if(SBPos < (Scrollback.Length - 1))
                            {
                                SBPos++;
                                // End:0x295
                                if(SBPos >= Scrollback.Length)
                                {
                                    SBPos = Scrollback.Length - 1;
                                }
                            }
                        }
                        return true;                        
                    }
                    else
                    {
                        // End:0x332
                        if(Key == 'Down')
                        {
                            // End:0x309
                            if(!bCtrl)
                            {
                                // End:0x306
                                if(HistoryBot >= 0)
                                {
                                    // End:0x2DC
                                    if(HistoryCur == HistoryTop)
                                    {
                                        HistoryCur = HistoryBot;                                        
                                    }
                                    else
                                    {
                                        HistoryCur = int(float(HistoryCur + 1) % float(16));
                                    }
                                    SetInputText(History[HistoryCur]);
                                }                                
                            }
                            else
                            {
                                // End:0x32D
                                if(SBPos > 0)
                                {
                                    SBPos--;
                                    // End:0x32D
                                    if(SBPos < 0)
                                    {
                                        SBPos = 0;
                                    }
                                }
                            }
                            return true;                            
                        }
                        else
                        {
                            // End:0x38D
                            if(Key == 'BackSpace')
                            {
                                // End:0x388
                                if(TypedStrPos > 0)
                                {
                                    SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                                    SetCursorPos(TypedStrPos - 1);
                                }
                                return true;                                
                            }
                            else
                            {
                                // End:0x3DF
                                if(Key == 'Delete')
                                {
                                    // End:0x3DA
                                    if(TypedStrPos < Len(TypedStr))
                                    {
                                        SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, (Len(TypedStr) - TypedStrPos) - 1));
                                    }
                                    return true;                                    
                                }
                                else
                                {
                                    // End:0x405
                                    if(Key == 'Left')
                                    {
                                        SetCursorPos(Max(0, TypedStrPos - 1));
                                        return true;                                        
                                    }
                                    else
                                    {
                                        // End:0x431
                                        if(Key == 'Right')
                                        {
                                            SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
                                            return true;                                            
                                        }
                                        else
                                        {
                                            // End:0x455
                                            if(bCtrl && Key == 'Home')
                                            {
                                                SBPos = 0;                                                
                                            }
                                            else
                                            {
                                                // End:0x471
                                                if(Key == 'Home')
                                                {
                                                    SetCursorPos(0);
                                                    return true;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x49D
                                                    if(bCtrl && Key == 'End')
                                                    {
                                                        SBPos = Scrollback.Length - 1;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x4BF
                                                        if(Key == 'End')
                                                        {
                                                            SetCursorPos(Len(TypedStr));
                                                            return true;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x532
                                                            if((Key == 'PageUp') || Key == 'MouseScrollUp')
                                                            {
                                                                // End:0x52D
                                                                if(SBPos < (Scrollback.Length - 1))
                                                                {
                                                                    // End:0x507
                                                                    if(bCtrl)
                                                                    {
                                                                        SBPos += 5;                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        SBPos++;
                                                                    }
                                                                    // End:0x52D
                                                                    if(SBPos >= Scrollback.Length)
                                                                    {
                                                                        SBPos = Scrollback.Length - 1;
                                                                    }
                                                                }
                                                                return true;                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x58D
                                                                if((Key == 'PageDown') || Key == 'MouseScrollDown')
                                                                {
                                                                    // End:0x58B
                                                                    if(SBPos > 0)
                                                                    {
                                                                        // End:0x572
                                                                        if(bCtrl)
                                                                        {
                                                                            SBPos -= 5;                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            SBPos--;
                                                                        }
                                                                        // End:0x58B
                                                                        if(SBPos < 0)
                                                                        {
                                                                            SBPos = 0;
                                                                        }
                                                                    }
                                                                    return true;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
        return;
    }

    function BeginState(name PreviousStateName)
    {
        bIgnoreKeys = true;
        HistoryCur = HistoryTop;
        SBPos = 0;
        bCtrl = false;
        return;
    }
    stop;
}

defaultproperties
{
    ConsoleKey="Tilde"
    AlternativeConsoleKey="Tilde"
    TypeKey="F12"
    MaxScrollbackSize=1024
    HistoryBot=-1
    TextureWhite=Texture2D'EngineResources.White'
    TextureBlack=Texture2D'EngineResources.Black'
}