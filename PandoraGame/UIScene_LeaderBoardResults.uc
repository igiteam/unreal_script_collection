class UIScene_LeaderBoardResults extends UIScene_NetworkScene;

var transient PanLeaderboards_DataStore StatsDataStore;
var UIList lstLeaderboard;

function Cleanup()
{
    super(UIScene_BaseFrontEnd).Cleanup();
    //return;    
}

function LeaderboardResultsActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    lstLeaderboard = UIList(FindChild('lstLeaderboard', true));
    StatsDataStore = PanLeaderboards_DataStore(SceneClient.DataStoreManager.FindDataStore('PanLeaderboards'));
    // End:0x55
    if(StatsDataStore == none)
    {
    }
    StatsDataStore.LeaderboardSettings.SetStringSettingValue(3, 3);
    StatsDataStore.LeaderboardSettings.SetStringSettingValue(1, 2);
    SceneActivated(bInitialActivation);
    //return;    
}

event InitScene()
{
    __OnSceneActivated__Delegate = LeaderboardResultsActivated;
    super(UIScene_BaseFrontEnd).InitScene();
    //return;    
}
