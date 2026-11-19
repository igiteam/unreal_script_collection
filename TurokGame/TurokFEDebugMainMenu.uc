class TurokFEDebugMainMenu extends TurokUISceneController
    native
    config(DebugMenu);

const MAX_NUM_MENU_ITEMS = 32;
const NUM_ITEMS_PER_COL = 16;

struct native DebugMainItem
{
    var @NULL mLabel;
    var string mCommand;

    structdefaultproperties
    {
        mLabel=none
        mCommand=""
    }
};

var int mMainIndex;
var array mMainItems;
var bool mShowMenuDivider;
var config string MenuTitle;
var config array MenuLabel;
var config array MenuCommand;

// Export UTurokFEDebugMainMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEDebugMainMenu::execRequestUpdate(FFrame&, void* const)
native function RequestUpdate(bool bDockingStackChanged, bool bPositionsChanged);

event SCInitialized()
{
    local @NULL Temp, TempLabel, divider;
    local int I, NumItems;

    TempLabel = UILabel(Scene.FindChild('Title'));
    // End:0x44
    if(TempLabel != none)
    {
        TempLabel.SetDataStoreBinding(MenuTitle);
    }
    // End:0x93
    if(mShowMenuDivider == false)
    {
        divider = UIImage(Scene.FindChild('MM_Divider'));
        // End:0x93
        if(divider != none)
        {
            divider.SetVisibility(false);
        }
    }
    NumItems = Clamp(MenuLabel.Length, 0, 32);
    I = 0;
    J0xAB:

    // End:0x159 [Loop If]
    if(I < NumItems)
    {
        TempLabel = UILabel(Scene.FindChild(name("Option" $ string(I))));
        // End:0x14F
        if(TempLabel != none)
        {
            TempLabel.SetDataStoreBinding(MenuLabel[I]);
            Temp.mLabel = TempLabel;
            Temp.mCommand = MenuCommand[I];
            mMainItems[I] = Temp;
        }
        I++;
        // [Loop Continue]
        goto J0xAB;
    }
    I = NumItems;
    J0x164:

    // End:0x1C7 [Loop If]
    if(I < 32)
    {
        TempLabel = UILabel(Scene.FindChild(name("Option" $ string(I))));
        // End:0x1BD
        if(TempLabel != none)
        {
            TempLabel.SetVisibility(false);
        }
        I++;
        // [Loop Continue]
        goto J0x164;
    }
    UpdateHighlight(mMainIndex);
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

    // End:0x3F [Loop If]
    if(I < mMainItems.Length)
    {
        mMainItems[I].mLabel = none;
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
    // End:0x64
    if((int(Event) == int(0)) && ((Key == 'XboxTypeS_Back') || Key == 'Pause') || Key == 'Escape')
    {
        CloseMenu();        
    }
    else
    {
        // End:0x162
        if((int(Event) == int(0)) || int(Event) == int(2))
        {
            switch(Key)
            {
                // End:0x99
                case 'XboxTypeS_DPad_Up':
                // End:0xB7
                case 'Up':
                    PreviousOption(mMainIndex);
                    // End:0x162
                    break;
                // End:0xC3
                case 'XboxTypeS_DPad_Down':
                // End:0xE1
                case 'Down':
                    NextOption(mMainIndex);
                    // End:0x162
                    break;
                // End:0xED
                case 'XboxTypeS_DPad_Left':
                // End:0x10B
                case 'Left':
                    MoveLeft(mMainIndex);
                    // End:0x162
                    break;
                // End:0x117
                case 'XboxTypeS_DPad_Right':
                // End:0x135
                case 'Right':
                    MoveRight(mMainIndex);
                    // End:0x162
                    break;
                // End:0x141
                case 'XboxTypeS_A':
                // End:0x15F
                case 'Enter':
                    SelectOption(mMainIndex);
                    // End:0x162
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }
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
        menuHighlight.DockTargets.TargetWidget[I] = mMainItems[Index].mLabel;
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
    if(Index >= mMainItems.Length)
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
        Index = mMainItems.Length - 1;
    }
    UpdateHighlight(Index);
    //return;    
}

function MoveLeft(out int Index)
{
    local int prevIndex;

    prevIndex = Index;
    Index -= 16;
    // End:0x43
    if(Index < 0)
    {
        Index += 32;
        // End:0x43
        if(Index >= mMainItems.Length)
        {
            Index = prevIndex;
        }
    }
    UpdateHighlight(Index);
    //return;    
}

function MoveRight(out int Index)
{
    local int prevIndex;

    prevIndex = Index;
    Index += 16;
    // End:0x2C
    if(Index >= 32)
    {
        Index -= 32;        
    }
    else
    {
        // End:0x47
        if(Index >= mMainItems.Length)
        {
            Index = prevIndex;
        }
    }
    UpdateHighlight(Index);
    //return;    
}

function SelectOption(int Index)
{
    local string Command, newSceneName;

    Command = mMainItems[Index].mCommand;
    // End:0xB6
    if(Command != "")
    {
        // End:0x6C
        if(Left(Command, 1) == ":")
        {
            newSceneName = Right(Command, Len(Command) - 1);
            SceneClient.OpenSceneController(newSceneName, 1);            
        }
        else
        {
            SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(Command);
            SceneClient.ClearSceneStack(1);
        }
    }
    //return;    
}

defaultproperties
{
    mShowMenuDivider=true
    SceneName="TurokFEDebugMenus.DebugGenericMenu"
}