class TurokFEDebugOptionsMenu extends TurokUISceneController
    native;

struct native DebugOptionsItem
{
    var @NULL mLabel;
    var @NULL mValueLabel;
    var int mRange;
    var float mValueStep;
    var string mCommand;
    var float mCurrentValue;
    var string mDisplayValues;

    structdefaultproperties
    {
        mLabel=none
        mValueLabel=none
        mRange=0
        mValueStep=0.0000000
        mCommand=""
        mCurrentValue=0.0000000
        mDisplayValues=""
    }
};

var int mOptionsIndex;
var array mOptionsItems;
var transient float defaults[12];

// Export UTurokFEDebugOptionsMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEDebugOptionsMenu::execRequestUpdate(FFrame&, void* const)
native function RequestUpdate(bool bDockingStackChanged, bool bPositionsChanged);

event SCInitialized()
{
    local @NULL Temp, TempLabel, tempValueLabel;
    local int I;
    local string commands[12];
    local int Ranges[12];
    local float steps[12];
    local string Display[12];

    commands[0] = "walk|fly|ghost";
    commands[1] = "slomo %v";
    commands[2] = "camera firstperson|camera thirdperson";
    commands[3] = "god|god";
    commands[4] = "stat fps*stat memory|stat fps*stat memory";
    commands[5] = "togglehud|togglehud";
    commands[6] = "enabledualwield|enabledualwield";
    commands[7] = "SetFESFXVol %v";
    commands[8] = "SetFEMusicDepth %v";
    commands[9] = "AlwaysAmmo|AlwaysAmmo";
    commands[10] = "TogglePrimalVitals|TogglePrimalVitals";
    commands[11] = "ToggleDebugAmmo|ToggleDebugAmmo";
    Ranges[0] = 2;
    Ranges[1] = 2;
    Ranges[2] = 1;
    Ranges[3] = 1;
    Ranges[4] = 1;
    Ranges[5] = 1;
    Ranges[6] = 1;
    Ranges[7] = 1;
    Ranges[8] = 5;
    Ranges[9] = 1;
    Ranges[10] = 1;
    Ranges[11] = 1;
    steps[0] = 1.0000000;
    steps[1] = 0.1000000;
    steps[2] = 1.0000000;
    steps[3] = 1.0000000;
    steps[4] = 1.0000000;
    steps[5] = 1.0000000;
    steps[6] = 1.0000000;
    steps[7] = 0.0500000;
    steps[8] = 1.0000000;
    steps[9] = 1.0000000;
    steps[10] = 1.0000000;
    steps[11] = 1.0000000;
    Display[0] = "Walk|Fly|Ghost";
    Display[1] = "";
    Display[2] = "1st|3rd";
    Display[3] = "Off|On";
    Display[4] = "Off|On";
    Display[5] = "Off|On";
    Display[6] = "Off|On";
    Display[7] = "";
    Display[8] = "";
    Display[9] = "Off|On";
    Display[10] = "Off|On";
    Display[11] = "Off|On";
    I = 0;
    TempLabel = Scene.FindChild(name("Option" $ string(I)));
    J0x3A8:

    // End:0x4FB [Loop If]
    if(TempLabel != none)
    {
        tempValueLabel = TempLabel.FindChild(name(("Option" $ string(I)) $ "_V"));
        // End:0x40A
        if(tempValueLabel != none)
        {
            Temp.mValueLabel = UILabel(tempValueLabel);            
        }
        else
        {
            Temp.mValueLabel = none;
        }
        Temp.mLabel = UILabel(TempLabel);
        Temp.mCommand = commands[I];
        Temp.mRange = Ranges[I];
        Temp.mValueStep = steps[I];
        Temp.mDisplayValues = Display[I];
        Temp.mCurrentValue = defaults[I];
        mOptionsItems[I] = Temp;
        TempLabel = Scene.FindChild(name("Option" $ string(++I)));
        // [Loop Continue]
        goto J0x3A8;
    }
    //return;    
}

event SCTick(float DeltaTime)
{
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    SceneClient = none;
    I = 0;
    J0x0E:

    // End:0x56 [Loop If]
    if(I < mOptionsItems.Length)
    {
        mOptionsItems[I].mLabel = none;
        mOptionsItems[I].mValueLabel = none;
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

event bool SCInputKey(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0x12E
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x2B
            case 'XboxTypeS_DPad_Up':
            // End:0x49
            case 'Up':
                PreviousOption(mOptionsIndex);
                // End:0x12E
                break;
            // End:0x55
            case 'XboxTypeS_DPad_Down':
            // End:0x73
            case 'Down':
                NextOption(mOptionsIndex);
                // End:0x12E
                break;
            // End:0x7F
            case 'XboxTypeS_DPad_Left':
            // End:0xA2
            case 'Left':
                AdjustOptionValue(mOptionsIndex, -1);
                // End:0x12E
                break;
            // End:0xAE
            case 'XboxTypeS_DPad_Right':
            // End:0xCD
            case 'Right':
                AdjustOptionValue(mOptionsIndex, 1);
                // End:0x12E
                break;
            // End:0xEE
            case 'XboxTypeS_Back':
                // End:0xEE
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x12E
                    break;
                }
            // End:0xFA
            case 'XboxTypeS_A':
            // End:0x106
            case 'Enter':
            // End:0x112
            case 'Pause':
            // End:0x12B
            case 'Escape':
                CloseMenu();
                // End:0x12E
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

function UpdateHighlight(int Index)
{
    local @NULL menuHighlight;
    local int I;

    menuHighlight = UIImage(Scene.FindChild(name("Highlight")));
    I = 0;
    J0x2F:

    // End:0x79 [Loop If]
    if(I < 4)
    {
        menuHighlight.DockTargets.TargetWidget[I] = mOptionsItems[Index].mValueLabel;
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    RequestUpdate(true, false);
    //return;    
}

function CloseMenu()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

function NextOption(out int Index)
{
    ++Index;
    // End:0x1E
    if(Index >= mOptionsItems.Length)
    {
        Index = 0;
    }
    UpdateHighlight(Index);
    //return;    
}

function PreviousOption(out int Index)
{
    --Index;
    // End:0x21
    if(Index < 0)
    {
        Index = mOptionsItems.Length - 1;
    }
    UpdateHighlight(Index);
    //return;    
}

function StrSplit(string Source, string delimiter, out array Result)
{
    local int pos;

    pos = InStr(Source, delimiter);
    J0x12:

    // End:0x66 [Loop If]
    if(pos > -1)
    {
        Result[Result.Length] = Mid(Source, 0, pos);
        Source = Mid(Source, pos + 1);
        pos = InStr(Source, delimiter);
        // [Loop Continue]
        goto J0x12;
    }
    Result[Result.Length] = Source;
    //return;    
}

function AdjustOptionValue(int Index, int Amount)
{
    local @NULL mo;
    local array parts;
    local int I;
    local string Temp;

    mo = mOptionsItems[Index];
    // End:0x3F
    if((mo.mValueLabel == none) || mo.mRange == 0)
    {
        return;
    }
    mo.mCurrentValue += (float(Amount) * mo.mValueStep);
    // End:0xA0
    if(mo.mCurrentValue < float(0))
    {
        mo.mCurrentValue = float(mo.mRange);
    }
    // End:0xDA
    if(mo.mCurrentValue > float(mo.mRange))
    {
        mo.mCurrentValue = 0.0000000;
    }
    defaults[Index] = mo.mCurrentValue;
    mOptionsItems[Index] = mo;
    // End:0x230
    if(mo.mDisplayValues != "")
    {
        StrSplit(mo.mDisplayValues, "|", parts);
        mo.mValueLabel.SetDataStoreBinding(parts[int(mo.mCurrentValue)]);
        parts.Length = 0;
        StrSplit(mo.mCommand, "|", parts);
        Temp = parts[int(mo.mCurrentValue)];
        parts.Length = 0;
        StrSplit(Temp, "*", parts);
        I = 0;
        J0x1DA:

        // End:0x22D [Loop If]
        if(I < parts.Length)
        {
            SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(parts[I]);
            ++I;
            // [Loop Continue]
            goto J0x1DA;
        }        
    }
    else
    {
        mo.mValueLabel.SetDataStoreBinding("" $ string(mo.mCurrentValue));
        SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(Repl(mo.mCommand, "%v", string(mo.mCurrentValue), false));
    }
    //return;    
}

defaultproperties
{
    defaults[1]=1.0000000
    defaults[5]=1.0000000
    defaults[7]=1.0000000
    SceneName="TurokFEDebugMenus.DebugOptionsMenu"
}