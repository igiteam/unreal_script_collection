class GFxUDKFrontEnd_Mutators extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
    config(UI);

var array<UTUIDataProvider_Mutator> AllMutatorsList;
var array<UTUIDataProvider_Mutator> AvailableMutatorList;
var transient UTUIDataStore_MenuItems MenuDataStore;
var array<int> EnabledList;
var GFxClikWidget ListMC;
var GFxObject MenuMC;
var GFxObject ListDataProvider;
var GFxClikWidget ConfigListMC;
var GFxObject ConfigListDataProvider;
var bool bFirstUpdateAfterActivation;

function OnViewLoaded()
{
    super(GFxUDKFrontEnd_View).OnViewLoaded();
    MenuDataStore = UTUIDataStore_MenuItems(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTMenuItems'));
    //return;    
}

function OnViewActivated()
{
    super(GFxUDKFrontEnd_View).OnViewActivated();
    bFirstUpdateAfterActivation = true;
    SortAllMutatorsBasedOnOfficialArray();
    //return;    
}

function SortAllMutatorsBasedOnOfficialArray()
{
    local byte I;
    local string GameModeString;
    local array<UTUIDataProvider_Mutator> TempList;
    local UIDataStore_Registry Registry;
    local array<UIResourceDataProvider> Providers;
    local UTUIDataProvider_Mutator MutatorProvider;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData("SelectedGameMode", GameModeString);
    Registry.SetData("SelectedGameMode", "");
    MenuDataStore.GetResourceProviders('Mutators', Providers);
    I = 0;
    J0xE6:

    // End:0x181 [Loop If]
    if(int(I) < Providers.Length)
    {
        MutatorProvider = UTUIDataProvider_Mutator(Providers[int(I)]);
        // End:0x173
        if((MutatorProvider != none) && !MutatorProvider.ShouldBeFiltered())
        {
            TempList.AddItem(MutatorProvider);            
        }
        I++;
        // [Loop Continue]
        goto J0xE6;
    }
    AllMutatorsList = TempList;
    Registry.SetData("SelectedGameMode", GameModeString);
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
    UpdateDescription();
    UpdateListDataProvider();
    MenuManager.SetSelectionFocus(ListMC);
    ListMC.SetFloat("selectedIndex", 0.0000000);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    ListMC.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function PlayOpenAnimation()
{
    MenuMC.GotoAndPlay("open");
    FooterMC.GotoAndPlay("next");
    //return;    
}

function OnListItemPress(EventData ev)
{
    local byte SelectedIndex, OfficialSelectedIndex;
    local GFxObject MutatorData;

    SelectedIndex = byte(ev.Target.GetFloat("selectedIndex"));
    // End:0xD1
    if(int(SelectedIndex) != -1)
    {
        MutatorData = ListDataProvider.GetElementObject(int(SelectedIndex));
        OfficialSelectedIndex = FindMutatorIndexByClass(MutatorData.GetString("class"));
    }
    SetMutatorEnabled(int(OfficialSelectedIndex));
    //return;    
}

final function byte FindMutatorIndexByClass(string MutatorClass)
{
    local byte MutatorIdx;

    MutatorIdx = 0;
    J0x0C:

    // End:0x76 [Loop If]
    if(int(MutatorIdx) < AllMutatorsList.Length)
    {
        // End:0x68
        if(AllMutatorsList[int(MutatorIdx)].ClassName == MutatorClass)
        {
            return MutatorIdx;
        }
        MutatorIdx++;
        // [Loop Continue]
        goto J0x0C;
    }
    return 255;
    //return ReturnValue;    
}

function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string MutatorClass, Description;

    // End:0x147
    if(ListMC != none)
    {
        SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
        // End:0x125
        if(SelectedIndex >= 0)
        {
            MutatorClass = ListDataProvider.GetElementObject(SelectedIndex).GetString("class");
            SelectedIndex = int(FindMutatorIndexByClass(MutatorClass));
            Description = AllMutatorsList[SelectedIndex].Description;
            InfoTxt.SetText(Description);            
        }
        else
        {
            InfoTxt.SetText("");
        }
    }
    //return;    
}

function UpdateListDataProvider()
{
    local byte I;
    local int EnabledIndex;
    local byte IndexInAllMutatorsList;
    local GFxObject DataProvider, TempObj;
    local array<UTUIDataProvider_Mutator> FilteredMutatorList;
    local bool bMutatorEnabled;

    I = 0;
    J0x0C:

    // End:0xA3 [Loop If]
    if(int(I) < AllMutatorsList.Length)
    {
        // End:0x95
        if((AllMutatorsList[int(I)] != none) && !AllMutatorsList[int(I)].ShouldBeFiltered())
        {
            FilteredMutatorList.AddItem(AllMutatorsList[int(I)]);            
        }
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    AvailableMutatorList = FilteredMutatorList;
    DataProvider = Outer.CreateArray();
    I = 0;
    J0xEB:

    // End:0x30D [Loop If]
    if(int(I) < AvailableMutatorList.Length)
    {
        TempObj = Outer.CreateObject("Object");
        TempObj.SetString("label", Caps(AvailableMutatorList[int(I)].FriendlyName));
        TempObj.SetString("class", AvailableMutatorList[int(I)].ClassName);
        IndexInAllMutatorsList = byte(AllMutatorsList.Find(AvailableMutatorList[int(I)]));        
        EnabledIndex = MenuDataStore.EnabledMutators.Find(int(IndexInAllMutatorsList));        
        bMutatorEnabled = EnabledIndex != -1;
        TempObj.SetBool("toggled", bMutatorEnabled);
        DataProvider.SetElementObject(int(I), TempObj);
        TempObj.SetBool("bForceToggledUpdate", bFirstUpdateAfterActivation);
        I++;
        // [Loop Continue]
        goto J0xEB;
    }
    bFirstUpdateAfterActivation = false;
    ListMC.SetObject("dataProvider", DataProvider);
    ListDataProvider = ListMC.GetObject("dataProvider");
    //return;    
}

function UpdateConfigListDataProvider()
{
    //return;    
}

function SetMutatorEnabled(int MutatorId)
{
    // End:0x4B
    if(MenuDataStore.EnabledMutators.Find(MutatorId) == )
    {        
        AddMutatorAndFilterList(MutatorId);        
    }
    else
    {
        // End:0xCB
        if(MenuDataStore.EnabledMutators.Find(MutatorId) != )
        {            
            EnabledList.RemoveItem(MutatorId);            
            MenuDataStore.EnabledMutators.RemoveItem(MutatorId);            
            UpdateListDataProvider();
        }
    }
    //return;    
}

function AddMutatorAndFilterList(int NewMutator)
{
    local bool bFiltered;
    local int EnabledIdx, MutatorIdx, GroupIdx;
    local string StringValue;
    local array<string> GroupNames, CompareGroupNames;
    local array<int> FinalItems;

    // End:0x6B
    if(AllMutatorsList[NewMutator] != none)
    {
        StringValue = AllMutatorsList[NewMutator].GroupNames;
        ParseStringIntoArray(StringValue, GroupNames, "|", true);
    }
    // End:0x1C5
    if(GroupNames.Length > 0)
    {
        MutatorIdx = 0;
        J0x86:

        // End:0x1C2 [Loop If]
        if(MutatorIdx < EnabledList.Length)
        {
            bFiltered = false;
            EnabledIdx = EnabledList[MutatorIdx];
            ParseStringIntoArray(AllMutatorsList[EnabledIdx].GroupNames, CompareGroupNames, "|", true);
            GroupIdx = 0;
            J0x111:

            // End:0x170 [Loop If]
            if(GroupIdx < GroupNames.Length)
            {
                // End:0x162
                if(CompareGroupNames.Find(GroupNames[GroupIdx]) != )
                {                    
                    bFiltered = true;
                    // [Explicit Break]
                    goto J0x170;
                }
                GroupIdx++;
                // [Loop Continue]
                goto J0x111;
            }
            J0x170:

            // End:0x1B4
            if(!bFiltered)
            {
                FinalItems.AddItem(MenuDataStore.EnabledMutators[MutatorIdx]);                
            }
            MutatorIdx++;
            // [Loop Continue]
            goto J0x86;
        }        
    }
    else
    {
        FinalItems = EnabledList;
    }
    FinalItems.AddItem(NewMutator);    
    MenuDataStore.EnabledMutators = FinalItems;
    EnabledList = MenuDataStore.EnabledMutators;
    UpdateListDataProvider();
    //return;    
}

static function string GetEnabledMutators()
{
    local string MutatorString;
    local int MutatorIdx;
    local UTUIDataStore_MenuItems LocalMenuDataStore;
    local array<UIResourceDataProvider> Providers;
    local UTUIDataProvider_Mutator Provider;
    local int I;

    MutatorString = "";
    LocalMenuDataStore = UTUIDataStore_MenuItems(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTMenuItems'));
    LocalMenuDataStore.GetResourceProviders('Mutators', Providers);
    I = 0;
    J0x84:

    // End:0x19A [Loop If]
    if(I < LocalMenuDataStore.EnabledMutators.Length)
    {
        MutatorIdx = LocalMenuDataStore.EnabledMutators[I];
        // End:0x18C
        if(MutatorIdx < Providers.Length)
        {
            Provider = UTUIDataProvider_Mutator(Providers[MutatorIdx]);
            // End:0x18C
            if(Provider != none)
            {
                // End:0x159
                if(Len(MutatorString) > 0)
                {                    
                    MutatorString $= ",";
                }                
                MutatorString $= Provider.ClassName;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x84;
    }
    return MutatorString;
    //return ReturnValue;    
}

static function int GetNumEnabledMutators()
{
    local UTUIDataStore_MenuItems LocalMenuDataStore;

    LocalMenuDataStore = UTUIDataStore_MenuItems(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTMenuItems'));
    return LocalMenuDataStore.EnabledMutators.Length;
    //return ReturnValue;    
}

static function ApplyGameModeFilter()
{
    local int MutatorIdx;
    local array<int> FinalItems;
    local UTUIDataStore_MenuItems LocalMenuDataStore;
    local array<UIResourceDataProvider> Providers;
    local UTUIDataProvider_Mutator Provider;

    LocalMenuDataStore = UTUIDataStore_MenuItems(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTMenuItems'));
    LocalMenuDataStore.GetResourceProviders('Mutators', Providers);
    MutatorIdx = 0;
    J0x78:

    // End:0x151 [Loop If]
    if(MutatorIdx < LocalMenuDataStore.EnabledMutators.Length)
    {
        Provider = UTUIDataProvider_Mutator(Providers[LocalMenuDataStore.EnabledMutators[MutatorIdx]]);
        // End:0x143
        if(!Provider.ShouldBeFiltered())
        {
            FinalItems.AddItem(LocalMenuDataStore.EnabledMutators[MutatorIdx]);            
        }
        MutatorIdx++;
        // [Loop Continue]
        goto J0x78;
    }
    LocalMenuDataStore.EnabledMutators = FinalItems;
    //return;    
}

function bool IsCurrentMutatorConfigurable()
{
    return false;
    //return ReturnValue;    
}

function SetList(GFxObject List)
{
    ActionScriptVoid("setList");
    //return;    
}

function SetConfigList(GFxObject ConfigList)
{
    ActionScriptVoid("setConfigList");
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0x169
        case 'mutator_list':
            // End:0x166
            if(ListMC == none)
            {
                ListMC = GFxClikWidget(Widget);
                SetList(ListMC);
                UpdateListDataProvider();
                ListMC.SetFloat("selectedIndex", 0.0000000);
                ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
                ListMC.AddEventListener('CLIK_change', OnListChange);
                ListMC.AddEventListener('CLIK_focusIn', OnListChange);
                bWasHandled = true;
            }
            // End:0x250
            break;
        // End:0x20D
        case 'mutator_config':
            // End:0x20A
            if(ConfigListMC == none)
            {
                ConfigListMC = GFxClikWidget(Widget.GetObject("list", Class'GFxUI.GFxObject'));
                // End:0x1FE
                if(ConfigListMC != none)
                {
                    ConfigListMC.SetBool("disabled", false);
                }
                bWasHandled = true;
            }
            // End:0x250
            break;
        // End:0x24A
        case 'Menu':
            // End:0x247
            if(MenuMC == none)
            {
                MenuMC = Widget;
                bWasHandled = true;
            }
            // End:0x250
            break;
        // End:0xFFFF
        default:
            // End:0x250
            break;
            break;
    }
    // End:0x28F
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}

defaultproperties
{
    SubWidgetBindings=/* Array type was not detected. */
}