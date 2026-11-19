class GFxUDKFrontEnd_MainMenu extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
    config(UI);

struct Option
{
    var string OptionName;
    var string OptionLabel;
    var string OptionDesc;

    structdefaultproperties
    {
        OptionName=""
        OptionLabel=""
        OptionDesc=""
    }
};

var config array<config Option> ListOptions;
var GFxClikWidget ListMC;
var GFxObject ListDataProvider;
var GFxObject UserLabelTxt;
var GFxObject UserNameTxt;
var byte LastSelectedIndex;

function OnViewLoaded()
{
    super(GFxUDKFrontEnd_View).OnViewLoaded();
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
    MenuManager.SetSelectionFocus(ListMC);
    UpdateDescription();
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    // End:0x42
    if(ListMC != none)
    {
        ListMC.SetBool("disabled", bDisableComponents);
    }
    //return;    
}

function Select_InstantAction()
{
    MenuManager.PushViewByName('InstantAction');
    //return;    
}

function Select_Multiplayer()
{
    // End:0x4D
    if(MenuManager.CheckLinkConnectionAndError())
    {
        MenuManager.PushViewByName('Multiplayer');
    }
    //return;    
}

function Select_ExitGame()
{
    local GFxUDKFrontEnd_InfoDialog ExitDialogMC;

    ExitDialogMC = GFxUDKFrontEnd_InfoDialog(MenuManager.SpawnDialog('InfoDialog'));
    ExitDialogMC.SetTitle("EXIT GAME");
    ExitDialogMC.SetInfo("Are you sure you wish to exit?");
    ExitDialogMC.SetBackButtonLabel("CANCEL");
    ExitDialogMC.SetAcceptButtonLabel("EXIT GAME");
    ExitDialogMC.SetAcceptButton_OnPress(ExitDialog_SelectOK);
    ExitDialogMC.SetBackButton_OnPress(ExitDialog_SelectBack);
    //return;    
}

function ExitDialog_SelectOK(EventData ev)
{
    ConsoleCommand("quit");
    //return;    
}

function ExitDialog_SelectBack(EventData ev)
{
    MenuManager.PopView();
    //return;    
}

private final function OnListItemPress(EventData ev)
{
    local int SelectedIndex;
    local name Selection;

    SelectedIndex = ev.Index;
    Selection = name(ListOptions[SelectedIndex].OptionName);
    switch(Selection)
    {
        // End:0x84
        case 'InstantAction':
            Select_InstantAction();
            // End:0xBC
            break;
        // End:0x9D
        case 'Multiplayer':
            Select_Multiplayer();
            // End:0xBC
            break;
        // End:0xB6
        case 'Exit':
            Select_ExitGame();
            // End:0xBC
            break;
        // End:0xFFFF
        default:
            // End:0xBC
            break;
            break;
    }
    //return;    
}

private final function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string Description;

    // End:0xBC
    if(ListMC != none)
    {
        SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
        // End:0x63
        if(SelectedIndex < 0)
        {
            SelectedIndex = 0;
        }
        Description = ListOptions[SelectedIndex].OptionDesc;
        InfoTxt.SetText(Description);
    }
    //return;    
}

function UpdateListDataProvider()
{
    local byte I;
    local GFxObject DataProvider, TempObj;

    DataProvider = Outer.CreateArray();
    I = 0;
    J0x35:

    // End:0x1AE [Loop If]
    if(int(I) < ListOptions.Length)
    {
        TempObj = Outer.CreateObject("Object");
        TempObj.SetString("name", ListOptions[int(I)].OptionName);
        TempObj.SetString("label", ListOptions[int(I)].OptionLabel);
        TempObj.SetString("desc", ListOptions[int(I)].OptionDesc);
        DataProvider.SetElementObject(int(I), TempObj);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    ListMC.SetObject("dataProvider", DataProvider);
    ListDataProvider = ListMC.GetObject("dataProvider");
    ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
    ListMC.AddEventListener('CLIK_change', OnListChange);
    //return;    
}

function SetList(GFxObject InList)
{
    ActionScriptVoid("setList");
    //return;    
}

function OnEscapeKeyPress()
{
    Select_ExitGame();
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0xE7
        case 'List':
            // End:0xE4
            if(ListMC == none)
            {
                ListMC = GFxClikWidget(Widget);
                SetList(ListMC);
                UpdateListDataProvider();
                MenuManager.SetSelectionFocus(ListMC);
                ListMC.SetFloat("selectedIndex", 0.0000000);
                UpdateDescription();
                bWasHandled = true;
            }
            // End:0x1CA
            break;
        // End:0x1BB
        case 'UserName':
            // End:0x1B8
            if(UserNameTxt == none)
            {
                UserLabelTxt = Widget.GetObject("label");
                UserNameTxt = Widget.GetObject("textField");
                UserLabelTxt.SetText("");
                UserNameTxt.SetText("");
                bWasHandled = true;
            }
            // End:0x1CA
            break;
        // End:0xFFFF
        default:
            bWasHandled = false;
            break;
    }
    // End:0x209
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}

defaultproperties
{
    CancelButtonHelpText="EXIT GAME"
}