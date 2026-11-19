class TurokFEDebugArtReviewMenu extends TurokFEDebugMainMenu
    config(DebugMenu);

var config array ARMenuLabel;
var config array ARMenuCommand;

event SCInitialized()
{
    local @NULL Temp, TempLabel;
    local int I, NumItems;

    NumItems = Clamp(ARMenuLabel.Length, 0, 16);
    I = 0;
    J0x18:

    // End:0xC6 [Loop If]
    if(I < NumItems)
    {
        TempLabel = UILabel(Scene.FindChild(name("Option" $ string(I))));
        // End:0xBC
        if(TempLabel != none)
        {
            TempLabel.SetDataStoreBinding(ARMenuLabel[I]);
            Temp.mLabel = TempLabel;
            Temp.mCommand = ARMenuCommand[I];
            mMainItems[I] = Temp;
        }
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    I = NumItems;
    J0xD1:

    // End:0x134 [Loop If]
    if(I < 15)
    {
        TempLabel = UILabel(Scene.FindChild(name("Option" $ string(I))));
        // End:0x12A
        if(TempLabel != none)
        {
            TempLabel.SetVisibility(false);
        }
        I++;
        // [Loop Continue]
        goto J0xD1;
    }
    UpdateHighlight(mMainIndex);
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
            SceneClient.OpenSceneController(newSceneName, 0);            
        }
        else
        {
            SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(Command);
            SceneClient.ClearSceneStack(0);
        }
    }
    //return;    
}

defaultproperties
{
    SceneName="TurokFrontEnd.DebugArtReviewMenu"
}