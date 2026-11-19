class UIScene_LeaderBoard extends UIScene_NetworkScene;

var transient PanLeaderboards_DataStore StatsDataStore;
var UIList lstLeaderboard;

function GetGamercardFromSelection()
{
    local int CurItem;

    CurItem = lstLeaderboard.GetCurrentItem();
    StatsDataStore.SetStatsReadInfo();
    StatsDataStore.ShowGamercard(byte(LocPlayer.ControllerId), CurItem);
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x2D
    if(IsInputAltAccept(EventParms))
    {
        GetGamercardFromSelection();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function BaseLeaderboardResultsActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    lstLeaderboard = UIList(FindChild('lstLeaderboard', true));
    StatsDataStore = PanLeaderboards_DataStore(SceneClient.DataStoreManager.FindDataStore('PanLeaderboards'));
    // End:0x55
    if(StatsDataStore == none)
    {
    }
    StatsDataStore.LeaderboardSettings.SetStringSettingValue(3, 3);
    StatsDataStore.LeaderboardSettings.SetStringSettingValue(1, 2);
    StatsDataStore.RefreshStats(byte(LocPlayer.ControllerId));
    SceneActivated(bInitialActivation);
    //return;    
}

event InitScene()
{
    __OnSceneActivated__Delegate = BaseLeaderboardResultsActivated;
    super(UIScene_BaseFrontEnd).InitScene();
    //return;    
}
