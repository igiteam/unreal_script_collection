class UIScene_TPLeaderboardResults extends UIScene_BaseFrontEnd;

enum ELeaderboardFilterType
{
	LFT_GameType,
	LFT_Players,
	LFT_Timeframe
};

var ELeaderboardFilterType FilterType;

var UILabel wPlayerLabel;
var UILabel wGameTypeLabel;
var UILabel wTimeframeLabel;

var UIList wLeaderboardList;
var int ListIndex, NumResults;
var OnlineStatsInterface StatsInterface;
var TPGameStats_DataStore LeaderboardDataStore;
var UIDataStore_OnlineStats StatsDataStore; 

var array<int> GameTypes;
var array<int> PlayerTypes;
var array<int> TimeframeTypes;

var UIScene SearchingScene;
var bool bReadingStats;

var() UIScene ConnectionDialog;

var localized string RefreshingString;

event InitScene()
{
	local UIDataStore DataStore;

	super.InitScene();
	wPlayerLabel = UILabel( FindChild( 'PlayerLabel' , true ) );
	wGameTypeLabel = UILabel( FindChild( 'GameTypeLabel' , true ) );
	wTimeframeLabel = UILabel( FindChild( 'TimeframeLabel' , true ) );
	
	wLeaderboardList = UIList( FindChild( 'LeaderboardList' , true ) );

	DataStore = SceneClient.DataStoreManager.FindDataStore('TPLeaderboard');
	LeaderboardDataStore = TPGameStats_DataStore(DataStore);
	//StatsDataStore = UTDataStore_OnlineStats(FindDataStore('UTLeaderboards'));
	//StatsDataStore = UIDataStore_OnlineStats(wLeaderboardList.DataSource.ResolvedDataStore);
	
	//StatsInterface = class'GameEngine'.static.GetOnlineSubsystem().StatsInterface;//LeaderboardDataStore.StatsInterface;
	LeaderboardDataStore.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnReadComplete); //SPARK MAY CODEDROP

	//StatsDataStore.RefreshStats( class'UIInteraction'.static.GetPlayerControllerId(0));
	LeaderboardDataStore.RefreshStats( GetPlayerOwner().ControllerId);
	//SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionDialog',,SearchingScene); //SPARK MAY CODEDROP
	SceneClient.OpenScene(ConnectionDialog,,SearchingScene);
	
	UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
	UIScene_ConnectionDialog(SearchingScene).InfoText = RefreshingString;
	bReadingStats = true;
}

function NotifyLinkStatusChanged(bool bConnected)
{
	Super.NotifyLinkStatusChanged(bConnected);

	if ( !bConnected )
	{
		LeaderboardDataStore.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadComplete);
		LeaderboardDataStore.StatsInterface.FreeStats(LeaderboardDataStore.StatsRead);

		bReadingStats = false;
		SceneClient.CloseScene(SearchingScene);
	}
}

function OnReadComplete(bool bWasSuccessful)
{
	// Clear the delegate that tells the UI to refresh
	LeaderboardDataStore.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadComplete);
	// If the call worked, sort the items before telling the list to refresh
	if (bWasSuccessful)
	{
		NumResults = LeaderboardDataStore.StatsRead.Rows.Length;
		LeaderboardDataStore.SortResultsByRank();
	}
	else
	{
		NumResults = 0;
	}
//@todo - display a message box upon error
	// Notify any subscribers that we have new data
	LeaderboardDataStore.NotifyPropertyChanged();
	LeaderboardDataStore.RefreshSubscribers();
	
	//StatsDataStore.NotifyPropertyChanged();
	//StatsDataStore.RefreshSubscribers();

	ListIndex = 0;

	bReadingStats = false;
	SceneClient.CloseScene(SearchingScene);
}

function CycleLeaderboardType(optional bool bCycleBackward)
{
	// Find the datastore by name and verify it's of the correct type
	local int CurrentValue;
	local array<int> TypeInts;
	
	
	if(LeaderboardDataStore != none && LeaderboardDataStore.LeaderboardSettings != none)
	{
		switch(FilterType)
		{
		case LFT_GameType:
			TypeInts = GameTypes;
			break;
		case LFT_Players:
			TypeInts = PlayerTypes;
			break;
		case LFT_Timeframe:
			TypeInts = TimeframeTypes;
			break;
		}

		if(TypeInts.Length > 0 && LeaderboardDataStore.LeaderboardSettings.GetStringSettingValue(TypeInts[0], CurrentValue))
		{
			
			// Cycle the value forward or backward depending on our cycle setting.  We wrap at the min and max.
			if(bCycleBackward)
			{
				if(CurrentValue == TypeInts[1])
				{
					CurrentValue = TypeInts[2];
				}
				else
				{
					CurrentValue--;
				}
			}
			else
			{
				if(CurrentValue == TypeInts[2])
				{
					CurrentValue = TypeInts[1];
				}
				else
				{
					CurrentValue++;
				}
			}

			LeaderboardDataStore.LeaderboardSettings.SetStringSettingValue(TypeInts[0], CurrentValue, false);
		}
		//LeaderboardDataStore.RefreshSubscribers();
		LeaderboardDataStore.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnReadComplete); //SPARK MAY CODEDROP
		//StatsDataStore.RefreshStats( class'UIInteraction'.static.GetPlayerControllerId(0));
		LeaderboardDataStore.RefreshStats( GetPlayerOwner().ControllerId);
		
		//SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionDialog',,SearchingScene); //SPARK MAY CODEDROP
		SceneClient.OpenScene(ConnectionDialog,,SearchingScene);
		
		UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
		UIScene_ConnectionDialog(SearchingScene).InfoText = RefreshingString;
		bReadingStats = true;
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (bReadingStats)
		return true;

	if ( EventParms.InputKeyName == 'XboxTypeS_X' && EventParms.EventType == IE_Released ) 
	{
		PlayUISound('ListSubmit');
		FilterType = LFT_Timeframe;
		CycleLeaderboardType(false);
		wTimeframeLabel.RefreshSubscriberValue();
		return true;
	}
	else if ( EventParms.InputKeyName == 'XboxTypeS_A' && EventParms.EventType == IE_Released ) 
	{
		if (NumResults == 0)
			return true;

		PlayUISound('Clicked');
		LeaderboardDataStore.ShowGamercard(class'UIInteraction'.static.GetPlayerControllerId(0),ListIndex);
		return true;
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_DPad_Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') && EventParms.EventType == IE_Released ) 
	{
		if (NumResults == 0)
			return true;

		PlayUISound('ListUp');
		ListIndex--;
		if (ListIndex < 0)
			ListIndex = NumResults-1;
		wLeaderboardList.SetIndex(ListIndex);
		return true;
	}
	else if ((EventParms.InputKeyName == 'XboxTypeS_DPad_Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') && EventParms.EventType == IE_Released ) 
	{
		if (NumResults == 0)
			return true;

		PlayUISound('ListDown');
		ListIndex++;
		if (ListIndex >= NumResults)
			ListIndex = 0;
		wLeaderboardList.SetIndex(ListIndex);
		
		return true;
	}
	else if ( EventParms.InputKeyName == 'XboxTypeS_RightShoulder' && EventParms.EventType == IE_Released ) 
	{
		PlayUISound('Clicked');
		FilterType = LFT_Players;
		CycleLeaderboardType(false);
		wPlayerLabel.RefreshSubscriberValue();
		return true;
	}
	else if ( EventParms.InputKeyName == 'XboxTypeS_LeftShoulder' && EventParms.EventType == IE_Released ) 
	{
		PlayUISound('Clicked');
		FilterType = LFT_GameType;
		CycleLeaderboardType(false);
		wGameTypeLabel.RefreshSubscriberValue();
		return true;
	}
	
	return super.CustomInputKey(EventParms);
}

