class MOHAMultiplayerSettings_DataStore extends UIDataStore_OnlineGameSettings
    transient
    hidecategories(Object,UIRoot);

const GAME_MODE = 0x0000800B;
const CONTEXT_MAPNAME = 8;

defaultproperties
{
    GameSettingsClass=Class'MOHADMOnlineGameSettings'
    Tag="MP_GameSettings"
}