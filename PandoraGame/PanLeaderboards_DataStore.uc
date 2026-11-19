class PanLeaderboards_DataStore extends UIDataStore_OnlineStats
    transient
    native;

var class<PanLeaderboard_Settings> LeaderboardSettingsClass;
var Settings LeaderboardSettings;
var UIDataProvider_Settings SettingsProvider;

function SetStatsReadInfo()
{
    local int ObjectIndex, GameModeId, PlayerFilterType, TimePeriodId;

    LeaderboardSettings.GetStringSettingValue(0, GameModeId);
    ObjectIndex = GameModeId;
    LeaderboardSettings.GetStringSettingValue(1, TimePeriodId);
    ObjectIndex += TimePeriodId;
    StatsRead = StatsReadObjects[ObjectIndex];
    LeaderboardSettings.GetStringSettingValue(3, PlayerFilterType);
    switch(PlayerFilterType)
    {
        // End:0x8E
        case 0:
            CurrentReadType = 0;
            // End:0xC0
            break;
        // End:0x9D
        case 1:
            CurrentReadType = 1;
            // End:0xC0
            break;
        // End:0xAD
        case 2:
            CurrentReadType = 2;
            // End:0xC0
            break;
        // End:0xBD
        case 3:
            CurrentReadType = 3;
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}
