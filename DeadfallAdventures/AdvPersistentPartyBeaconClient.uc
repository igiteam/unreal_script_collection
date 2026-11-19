class AdvPersistentPartyBeaconClient extends AdvPartyBeaconClient
    native(Online)
    config(Engine);

//var delegate<OnJIPGameSessionReceived> __OnJIPGameSessionReceived__Delegate;

delegate OnJIPGameSessionReceived(AdvPersistentPartyBeaconHost.EPKPersistentPartyJIPResult JIPResult, name SessionName, class<OnlineGameSearch> SearchClass, int GamePlaylistId, int GamePlaylistMgrVer, int DLCRequired, string CustomMapName, byte PlatformSpecificInfo[80])
{
    //return;    
}

defaultproperties
{
    PartyBeaconPort=8701
}