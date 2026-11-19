class TurokFEDebugMPMenu extends TurokUISceneController
    native;

const kNumItems = 5;

struct native DebugMultiplayerItem
{
    var @NULL mLabel;
    var @NULL mValueLabel;
    var int mRange;
    var float mValueStep;
    var string mCommand;
    var float mCurrentValue;
    var string mStringValue;
    var string mDisplayValues;

    structdefaultproperties
    {
        mLabel=none
        mValueLabel=none
        mRange=0
        mValueStep=0.0000000
        mCommand=""
        mCurrentValue=0.0000000
        mStringValue=""
        mDisplayValues=""
    }
};

struct native MapList
{
    var int mGameplayMode;
    var array mStringValue;
    var array mDisplayValues;
    var int mRange;

    structdefaultproperties
    {
        mGameplayMode=0
        mStringValue=none
        mDisplayValues=none
        mRange=0
    }
};

var private @NULL mMPHelper;
var array mMPItems;
var array mMapList;
var transient float defaults[5];
var private int mMultiplayerIndex;
var private int mLastGameplayModeValue;
var private int mSelectedServer;

// Export UTurokFEDebugMPMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEDebugMPMenu::execCloseScene(FFrame&, void* const)
native function CloseScene(@NULL newScene);

// Export UTurokFEDebugMPMenu::execRequestUpdate(FFrame&, void* const)
native function RequestUpdate(bool bDockingStackChanged, bool bPositionsChanged);

event SCInitialized()
{
    local class<Class> MPClass;
    local @NULL Temp, TempLabel, tempValueLabel;
    local int I;
    local string commands[5];
    local int Ranges[5];
    local float steps[5];
    local string Display[5], strValues;

    commands[0] = "";
    commands[1] = "";
    commands[2] = "startServer";
    commands[3] = "connectToServer";
    commands[4] = "disconnect";
    Ranges[0] = 5;
    Ranges[1] = -1;
    Ranges[2] = -1;
    Ranges[3] = -1;
    Ranges[4] = -1;
    steps[0] = 1.0000000;
    steps[1] = 1.0000000;
    steps[2] = 0.0000000;
    steps[3] = 1.0000000;
    steps[4] = 0.0000000;
    Display[0] = "Deathmatch|TeamDeathmatch|CTF|AssaultCTF|WarGames|Co-op";
    Display[1] = "";
    Display[2] = "";
    Display[3] = "";
    Display[4] = "";
    strValues[0] = "Deathmatch|TeamDeathmatch|CTF|AssaultCTF|WarGames|Co-op";
    strValues[1] = "";
    strValues[2] = "";
    strValues[3] = "";
    strValues[4] = "";
    I = 0;
    TempLabel = Scene.FindChild(name("Option" $ string(I)));
    J0x1E6:

    // End:0x364 [Loop If]
    if(TempLabel != none)
    {
        tempValueLabel = TempLabel.FindChild(name(("Option" $ string(I)) $ "_V"));
        // End:0x248
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
        Temp.mStringValue = strValues[I];
        mMPItems[I] = Temp;
        AdjustOptionValue(I, 0);
        TempLabel = Scene.FindChild(name("Option" $ string(++I)));
        // [Loop Continue]
        goto J0x1E6;
    }
    UpdateHighlight(mMultiplayerIndex);
    mSelectedServer = -1;
    MPClass = class<TurokMPDebugFEHelper>(DynamicLoadObject("TurokGame.TurokMPDebugFEHelper", Class'Core.Class'));
    // DebugMode: 0
    assert(MPClass != none);
    mMPHelper = new (self) MPClass;
    mMPHelper.InitMpHelper();
    //return;    
}

event SCTick(float DeltaTime)
{
    local @NULL ServerOption, IPAddr, MapOption;
    local int I, numServers;
    local array serverNames, serverAddrs;
    local string curServerAddr;

    // DebugMode: 0
    assert(mMPHelper != none);
    ServerOption = UILabel(Scene.FindChild('Option3'));
    IPAddr = UILabel(Scene.FindChild('IPAddr'));
    numServers = mMPHelper.GetNumServers();
    serverNames.Length = numServers;
    serverAddrs.Length = numServers;
    I = 0;
    J0x8C:

    // End:0xED [Loop If]
    if(I < numServers)
    {
        serverNames[I] = mMPHelper.GetServerName(I);
        serverAddrs[I] = mMPHelper.GetServerAddr(I);
        I++;
        // [Loop Continue]
        goto J0x8C;
    }
    numServers = UpdateItem(ServerOption, numServers, serverNames, serverAddrs, "No Servers Found", "No IP");
    mSelectedServer = int(mMPItems[numServers].mCurrentValue);
    // End:0x18F
    if(float(serverAddrs.Length) > mMPItems[numServers].mCurrentValue)
    {
        curServerAddr = serverAddrs[int(mMPItems[numServers].mCurrentValue)];        
    }
    else
    {
        curServerAddr = "No IP";
    }
    IPAddr.SetDataStoreBinding(("(" $ curServerAddr) $ ")");
    // End:0x28F
    if(mMPItems[0].mCurrentValue != float(mLastGameplayModeValue))
    {
        mLastGameplayModeValue = int(mMPItems[0].mCurrentValue);
        MapOption = UILabel(Scene.FindChild('Option1'));
        UpdateItem(MapOption, mMapList[int(mMPItems[0].mCurrentValue)].mRange, mMapList[int(mMPItems[0].mCurrentValue)].mDisplayValues, mMapList[int(mMPItems[0].mCurrentValue)].mStringValue);
    }
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    // DebugMode: 0
    assert(mMPHelper != none);
    mMPHelper.ShutdownMpHelper();
    mMPHelper = none;
    SceneClient = none;
    I = 0;
    J0x34:

    // End:0x7C [Loop If]
    if(I < mMPItems.Length)
    {
        mMPItems[I].mLabel = none;
        mMPItems[I].mValueLabel = none;
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

event bool SCInputKey(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0x150
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x2B
            case 'XboxTypeS_DPad_Up':
            // End:0x49
            case 'Up':
                PreviousOption(mMultiplayerIndex);
                // End:0x150
                break;
            // End:0x55
            case 'XboxTypeS_DPad_Down':
            // End:0x73
            case 'Down':
                NextOption(mMultiplayerIndex);
                // End:0x150
                break;
            // End:0x7F
            case 'XboxTypeS_DPad_Left':
            // End:0xA2
            case 'Left':
                AdjustOptionValue(mMultiplayerIndex, -1);
                // End:0x150
                break;
            // End:0xAE
            case 'XboxTypeS_DPad_Right':
            // End:0xCD
            case 'Right':
                AdjustOptionValue(mMultiplayerIndex, 1);
                // End:0x150
                break;
            // End:0xD9
            case 'XboxTypeS_X':
            // End:0xF2
            case 'X':
                SearchGames();
                // End:0x150
                break;
            // End:0xFE
            case 'XboxTypeS_A':
            // End:0x11C
            case 'Enter':
                SelectOption(mMultiplayerIndex);
                // End:0x150
                break;
            // End:0x128
            case 'XboxTypeS_Back':
            // End:0x134
            case 'Pause':
            // End:0x14D
            case 'Escape':
                CloseMenu();
                // End:0x150
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
        menuHighlight.DockTargets.TargetWidget[I] = mMPItems[Index].mLabel;
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
    if(Index >= mMPItems.Length)
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
        Index = mMPItems.Length - 1;
    }
    UpdateHighlight(Index);
    //return;    
}

function SearchGames()
{
    local array values1;
    local string GameName;

    // End:0x65
    if(mMPHelper != none)
    {
        StrSplit(mMPItems[0].mStringValue, "|", values1);
        GameName = values1[int(mMPItems[0].mCurrentValue)];
        mMPHelper.SearchGames(GameName);
    }
    //return;    
}

function SelectOption(int Index)
{
    local string Command;
    local array values1, values2;
    local string MapName, GameName;

    Command = mMPItems[Index].mCommand;
    // End:0x169
    if(Command != "")
    {
        // End:0xE2
        if(Command == "startServer")
        {
            StrSplit(mMPItems[0].mStringValue, "|", values1);
            StrSplit(mMPItems[1].mStringValue, "|", values2);
            GameName = values1[int(mMPItems[0].mCurrentValue)];
            MapName = values2[int(mMPItems[1].mCurrentValue)];
            mMPHelper.StartGame(GameName, MapName);            
        }
        else
        {
            // End:0x129
            if(Command == "connectToServer")
            {
                // End:0x10E
                if(mSelectedServer == -1)
                {
                    return;
                }
                mMPHelper.JoinGame(mSelectedServer);                
            }
            else
            {
                // End:0x169
                if(Command == "disconnect")
                {
                    mMPHelper.LeaveGame();
                    SceneClient.ClearSceneStack(1);
                }
            }
        }
    }
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

function int GetItemIndex(@NULL Item)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(I < mMPItems.Length)
    {
        // End:0x3C
        if(mMPItems[I].mLabel == Item)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function int UpdateItem(@NULL Item, int numValues, array displayValues, array stringValues, optional string emptyDisplayValue, optional string emptyStringValue)
{
    local int itemIndex, I;

    itemIndex = GetItemIndex(Item);
    // End:0x28
    if(itemIndex < 0)
    {
        return -1;
    }
    mMPItems[itemIndex].mRange = numValues - 1;
    // End:0x8A
    if(numValues <= 0)
    {
        mMPItems[itemIndex].mDisplayValues = emptyDisplayValue;
        mMPItems[itemIndex].mStringValue = emptyStringValue;        
    }
    else
    {
        mMPItems[itemIndex].mDisplayValues = "";
        mMPItems[itemIndex].mStringValue = "";
        I = 0;
        J0xC1:

        // End:0x137 [Loop If]
        if(I < (numValues - 1))
        {            
            mMPItems[itemIndex].mDisplayValues $= (displayValues[I] $ "|");            
            mMPItems[itemIndex].mStringValue $= (stringValues[I] $ "|");
            I++;
            // [Loop Continue]
            goto J0xC1;
        }        
        mMPItems[itemIndex].mDisplayValues $= displayValues[I];        
        mMPItems[itemIndex].mStringValue $= stringValues[I];
    }
    AdjustOptionValue(itemIndex, 0);
    return itemIndex;
    //return ReturnValue;    
}

function AdjustOptionValue(int Index, int Amount)
{
    local @NULL mo;
    local array parts;

    mo = mMPItems[Index];
    // End:0x3F
    if((mo.mValueLabel == none) || mo.mRange < 0)
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
    mMPItems[Index] = mo;
    // End:0x16E
    if(mo.mDisplayValues != "")
    {
        StrSplit(mo.mDisplayValues, "|", parts);
        mo.mValueLabel.SetDataStoreBinding(parts[int(mo.mCurrentValue)]);
    }
    //return;    
}

defaultproperties
{
    mLastGameplayModeValue=-1
    mSelectedServer=-1
    SceneName="TurokDebugMP.DebugMPMenu"
}