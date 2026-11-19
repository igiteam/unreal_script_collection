class R6Console extends Console within GameViewportClient
    transient
    native
    config(Console);

var bool m_bSelection;
var bool m_bShiftPressed;
var bool m_bSearchingFuncs;
var bool m_bBlockAxisInputs;
var bool m_bCacheMTSelection;
var int m_iFuncCount;
var int m_iSelection;
var array<string> m_Functions;
var int m_iCacheMTSelection;

// Export UR6Console::execCopyToClipboard(FFrame&, void* const)
native final function CopyToClipboard();

// Export UR6Console::execPasteFromClipboard(FFrame&, void* const)
native final function PasteFromClipboard();

// Export UR6Console::execAutoComplete(FFrame&, void* const)
native final function AutoComplete();

event GetSelectionRange(out float X1, out float X2)
{
    // End:0x2C
    if(TypedStrPos < m_iSelection)
    {
        X1 = float(TypedStrPos);
        X2 = float(m_iSelection);        
    }
    else
    {
        X2 = float(TypedStrPos);
        X1 = float(m_iSelection);
    }
    return;
}

function EraseSelection()
{
    local float X1, X2;

    GetSelectionRange(X1, X2);
    TypedStr = Left(TypedStr, int(X1)) $ Right(TypedStr, int(float(Len(TypedStr)) - X2));
    TypedStrPos = int(X1);
    m_bSelection = false;
    return;
}

function CheckSelection()
{
    // End:0x2A
    if(m_bShiftPressed)
    {
        // End:0x1F
        if(!m_bSelection)
        {
            m_iSelection = TypedStrPos;
        }
        m_bSelection = true;        
    }
    else
    {
        m_bSelection = false;
    }
    return;
}

function bool ProcessInput(name Key, Object.EInputEvent Event, float fAmmountDepressed)
{
    // End:0x18
    if(int(Event) == int(0))
    {
        bIgnoreKeys = false;
    }
    // End:0x73
    if(((((Key != 'LeftShift') && Key != 'RightShift') && Key != 'LeftControl') && Key != 'RightControl') && Key != 'Tab')
    {
        m_bSearchingFuncs = false;
    }
    // End:0xD0
    if((Key == 'LeftShift') || Key == 'RightShift')
    {
        m_bShiftPressed = ((int(Event) == int(0)) || int(Event) == int(2)) || int(Event) == int(5);
        return true;        
    }
    else
    {
        // End:0x12D
        if((Key == 'LeftControl') || Key == 'RightControl')
        {
            bCtrl = ((int(Event) == int(0)) || int(Event) == int(2)) || int(Event) == int(5);
            return true;            
        }
        else
        {
            // End:0x186
            if((Key == 'Escape') && int(Event) == int(1))
            {
                // End:0x177
                if(TypedStr != "")
                {
                    TypedStr = "";
                    TypedStrPos = 0;
                    HistoryCur = HistoryTop;                    
                }
                else
                {
                    GotoState('None');
                }
                return true;                
            }
            else
            {
                // End:0x1AD
                if((int(Event) != int(0)) && int(Event) != int(2))
                {
                    return true;                    
                }
                else
                {
                    // End:0x1C7
                    if(Key == 'Tab')
                    {
                        AutoComplete();
                        return true;                        
                    }
                    else
                    {
                        // End:0x1F5
                        if((Key == 'C') && bCtrl)
                        {
                            // End:0x1F0
                            if(m_bSelection)
                            {
                                CopyToClipboard();
                            }
                            return true;                            
                        }
                        else
                        {
                            // End:0x22A
                            if((Key == 'V') && bCtrl)
                            {
                                // End:0x21F
                                if(m_bSelection)
                                {
                                    EraseSelection();
                                }
                                PasteFromClipboard();
                                return true;                                
                            }
                            else
                            {
                                // End:0x25F
                                if((Key == 'X') && bCtrl)
                                {
                                    // End:0x25A
                                    if(m_bSelection)
                                    {
                                        CopyToClipboard();
                                        EraseSelection();
                                    }
                                    return true;                                    
                                }
                                else
                                {
                                    // End:0x28B
                                    if(Key == 'Left')
                                    {
                                        CheckSelection();
                                        TypedStrPos = Max(0, TypedStrPos - 1);
                                        return true;                                        
                                    }
                                    else
                                    {
                                        // End:0x2BD
                                        if(Key == 'Right')
                                        {
                                            CheckSelection();
                                            TypedStrPos = Min(Len(TypedStr), TypedStrPos + 1);
                                            return true;                                            
                                        }
                                        else
                                        {
                                            // End:0x310
                                            if(Key == 'Delete')
                                            {
                                                // End:0x2DF
                                                if(m_bSelection)
                                                {
                                                    EraseSelection();                                                    
                                                }
                                                else
                                                {
                                                    TypedStr = Left(TypedStr, TypedStrPos) $ Right(TypedStr, (Len(TypedStr) - TypedStrPos) - 1);
                                                }
                                                return true;                                                
                                            }
                                            else
                                            {
                                                // End:0x375
                                                if(Key == 'BackSpace')
                                                {
                                                    // End:0x332
                                                    if(m_bSelection)
                                                    {
                                                        EraseSelection();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x370
                                                        if(TypedStrPos > 0)
                                                        {
                                                            TypedStr = Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
                                                            TypedStrPos--;
                                                        }
                                                    }
                                                    return true;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x397
                                                    if(Key == 'Home')
                                                    {
                                                        CheckSelection();
                                                        TypedStrPos = 0;
                                                        return true;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x3BC
                                                        if(Key == 'End')
                                                        {
                                                            CheckSelection();
                                                            TypedStrPos = Len(TypedStr);
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
    return false;
    return;
}

state Typing
{
    function BeginState(name PreviousStateName)
    {
        m_bBlockAxisInputs = true;
        return;
    }

    function EndState(name NextStateName)
    {
        m_bBlockAxisInputs = false;
        return;
    }

    event bool InputKey(int iControllerId, name Key, Object.EInputEvent Event, float fAmountDepressed)
    {
        // End:0x1E
        if(ProcessInput(Key, Event, fAmountDepressed))
        {
            return true;            
        }
        else
        {
            // End:0x2E
            if(m_bSelection)
            {
                EraseSelection();
            }
            InputKey(iControllerId, Key, Event, fAmountDepressed);
            return true;
        }
        return;
    }
    stop;
}

state Open
{
    function BeginState(name PreviousStateName)
    {
        m_bBlockAxisInputs = true;
        return;
    }

    function EndState(name NextStateName)
    {
        m_bBlockAxisInputs = false;
        return;
    }

    event bool InputKey(int iControllerId, name Key, Object.EInputEvent Event, float fAmountDepressed)
    {
        // End:0x1E
        if(ProcessInput(Key, Event, fAmountDepressed))
        {
            return true;            
        }
        else
        {
            // End:0x2E
            if(m_bSelection)
            {
                EraseSelection();
            }
            InputKey(iControllerId, Key, Event, fAmountDepressed);
            return true;
        }
        return;
    }
    stop;
}
