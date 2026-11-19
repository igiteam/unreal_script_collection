class GFxUDKFrontEnd_Multiplayer extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
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
var GFxObject MenuMC;

function OnViewLoaded()
{
    super(GFxUDKFrontEnd_View).OnViewLoaded();
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView();
    // End:0x67
    if(bPlayOpenAnimation)
    {
        MenuMC.GotoAndPlay("open");
        FooterMC.GotoAndPlay("next");
    }
    MenuManager.SetSelectionFocus(ListMC);
    UpdateDescription();
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    ListMC.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function Select_JoinGame()
{
    // End:0x4D
    if(MenuManager.CheckLinkConnectionAndError())
    {
        MenuManager.PushViewByName('JoinGame');
    }
    //return;    
}

function Select_HostGame()
{
    // End:0x4D
    if(MenuManager.CheckLinkConnectionAndError())
    {
        MenuManager.PushViewByName('HostGame');
    }
    //return;    
}

function OnListItemPress(EventData ev)
{
    local int SelectedIndex;
    local name Selection;

    SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
    Selection = name(ListDataProvider.GetElementMemberString(SelectedIndex, "name"));
    switch(Selection)
    {
        // End:0xA0
        case 'JoinGame':
            Select_JoinGame();
            // End:0xBF
            break;
        // End:0xB9
        case 'HostGame':
            Select_HostGame();
            // End:0xBF
            break;
        // End:0xFFFF
        default:
            // End:0xBF
            break;
            break;
    }
    //return;    
}

function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string Description;

    SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
    Description = ListOptions[SelectedIndex].OptionDesc;
    InfoTxt.SetText(Description);
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
    ListMC.SetFloat("selectedIndex", 0.0000000);
    ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
    ListMC.AddEventListener('CLIK_change', OnListChange);
    //return;    
}

function SetList(GFxObject InList)
{
    ActionScriptVoid("setList");
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0x73
        case 'List':
            ListMC = GFxClikWidget(Widget);
            SetList(ListMC);
            UpdateListDataProvider();
            bWasHandled = true;
            // End:0xA7
            break;
        // End:0xA1
        case 'Menu':
            MenuMC = Widget;
            bWasHandled = true;
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            // End:0xA7
            break;
            break;
    }
    // End:0xE6
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}
