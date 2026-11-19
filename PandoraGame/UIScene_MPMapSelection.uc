class UIScene_MPMapSelection extends UIScene_BaseFrontEnd;

var UIDataStore_GameResource GameResourceDataStore;
var int NumberOfMaps;

event InitScene()
{
    local int I;
    local PandoraGRI PGRI;
    local UIProviderScriptFieldValue MapNameValue;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2A
    if(PGRI == none)
    {
    }
    super.InitScene();
    GameResourceDataStore = UIDataStore_GameResource(GetCurrentUIController().DataStoreManager.FindDataStore('GameResources'));
    NumberOfMaps = GameResourceDataStore.GetProviderCount('MultiplayerMaps');
    I = 0;
    J0x8A:

    // End:0x1C2 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x1B8
        if(MenuItems[I].ButtonObj != none)
        {
            // End:0x14E
            if(I < NumberOfMaps)
            {
                MenuItems[I].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
                GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'MapName', I, MapNameValue);
                MenuItems[I].ButtonObj.SetDataStoreBinding(MapNameValue.StringValue);                
            }
            else
            {
                MenuItems[I].bDisabled = true;
                MenuItems[I].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                MenuItems[I].MenuItemUIObject.SetVisibility(false);
            }
            // [Explicit Continue]
        }
        I++;
        // [Loop Continue]
        goto J0x8A;
    }
    // End:0x20D
    if(MenuItems.Length > 0)
    {
        MenuItems[0].MenuItemUIObject.SetFocus(MenuItems[0].MenuItemUIObject.GetOwner());
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    // End:0x39
    if(myGameInfo == none)
    {
        return;
    }
    // End:0x5D
    if(MenuIndex < NumberOfMaps)
    {
        myGameInfo.MP_MapId = MenuIndex;
    }
    myGameInfo.CreateGameSession();
    //return;    
}
