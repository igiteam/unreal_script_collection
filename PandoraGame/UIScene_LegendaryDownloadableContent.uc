class UIScene_LegendaryDownloadableContent extends UIScene_BaseFrontEnd;

var UIDataStore_GameResource GameResourceDataStore;
var UIList SinglePlayerMapContentList;
var UILabel NothingAvailableLabel;
var OnlineSubsystem OnlineSub;

event InitScene()
{
    local int SPMapCount;

    GameResourceDataStore = UIDataStore_GameResource(GetCurrentUIController().DataStoreManager.FindDataStore('GameResources'));
    NothingAvailableLabel = UILabel(FindChild('NothingAvailableLabel', true));
    SinglePlayerMapContentList = UIList(FindChild('SinglePlayerMapContentList', true));
    SPMapCount = GameResourceDataStore.GetProviderCount('DownloadableSPMaps');
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    OnlineSub.ContentInterface.ReadContentList(byte(GetPlayerOwner().ControllerId));
    NothingAvailableLabel.SetVisibility(SPMapCount == 0);
    super.InitScene();
    //return;    
}

function OnSubmitSelection()
{
    local UIProviderScriptFieldValue MapNameValue;

    // End:0x89
    if(SinglePlayerMapContentList.GetItemCount() > 0)
    {
        GameResourceDataStore.GetProviderFieldValue('DownloadableSPMaps', 'MapName', SinglePlayerMapContentList.GetCurrentItem(), MapNameValue);        
        GetPC().ConsoleCommand("open " $ MapNameValue.StringValue);
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x55
    if(IsInputAlt2Accept(EventParms))
    {
        OnlineSub.PlayerInterfaceEx.ShowContentMarketplaceUI(byte(GetPlayerOwner().ControllerId));
        return true;
    }
    // End:0x73
    if(IsInputAccept(EventParms))
    {
        OnSubmitSelection();
        return true;
    }
    return super.CustomInputKey(EventParms);
    //return ReturnValue;    
}
