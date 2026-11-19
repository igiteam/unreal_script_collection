class UIScene_TPLeaderboard extends UIScene_BaseFrontEnd;

enum ELeaderboardFilterType
{
	LFT_GameType,
	LFT_Players,
	LFT_Timeframe
};

var UILabel wPlayerLabel;
var UILabel wGameTypeLabel;
var UILabel wTimeframeLabel;

var ELeaderboardFilterType FilterType;

var array<int> GameTypes;
var array<int> PlayerTypes;
var array<int> TimeframeTypes;

event InitScene()
{
	super.InitScene();
	wPlayerLabel = UILabel( FindChild( 'PlayersLabel' , true ) );
	//wPlayerLabel.SetValue("Me");
	wGameTypeLabel = UILabel( FindChild( 'GameModeLabel' , true ) );
	//wGameTypeLabel.SetValue("Death Match");
	wTimeframeLabel = UILabel( FindChild( 'TimeframeLabel' , true ) );
	//wTimeframeLabel.SetValue("");
}

function CycleLeaderboardType(optional bool bCycleBackward)
{
	// Find the datastore by name and verify it's of the correct type
	local UIDataStore DataStore;
	local TPGameStats_DataStore LeaderboardDataStore;
	local int CurrentValue;
	local array<int> TypeInts;

	DataStore = SceneClient.DataStoreManager.FindDataStore('TPLeaderboard');
	LeaderboardDataStore = TPGameStats_DataStore(DataStore);

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
		LeaderboardDataStore.NotifyPropertyChanged();
		LeaderboardDataStore.RefreshSubscribers();
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') && EventParms.EventType == IE_Released )
	{
		PlayUISound('NavigateLeft');
		switch (CurrentSelectedIndex)
		{
		case 0:			
			FilterType = LFT_Players;
			CycleLeaderboardType(true);
			wPlayerLabel.RefreshSubscriberValue();
			break;
		case 1:
			FilterType = LFT_GameType;
			CycleLeaderboardType(true);
			wGameTypeLabel.RefreshSubscriberValue();
			break;
		case 2:
			FilterType = LFT_Timeframe;
			CycleLeaderboardType(true);
			wTimeframeLabel.RefreshSubscriberValue();
			break;
		}
		return true;
	}
	else if ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') && EventParms.EventType == IE_Released )
	{
		PlayUISound('NavigateLeft');
		switch (CurrentSelectedIndex)
		{
		case 0:			
			FilterType = LFT_Players;
			CycleLeaderboardType(false);
			wPlayerLabel.RefreshSubscriberValue();
			break;
		case 1:
			FilterType = LFT_GameType;
			CycleLeaderboardType(false);
			wGameTypeLabel.RefreshSubscriberValue();
			break;
		case 2:
			FilterType = LFT_Timeframe;
			CycleLeaderboardType(false);
			wTimeframeLabel.RefreshSubscriberValue();
			break;
		}
		return true;
	}
	return super.CustomInputKey(EventParms);
}

