class AdvPreGameLobbyGameDedicated_Base extends AdvPreGameLobbyGame_Base
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var AdvPlayerMatchBeaconHost HostPregameLobbyPlayerMatchBeacon;
var AdvPartyBeaconHost HostPregameLobbyVsBeacon;
var config float RestartTimer;
var config bool bConfigureForRankedMatch;
var bool bUpdateSessionInProgress;
var bool bUpdateSessionRequested;
var config int DataCenterId;
var config int IdleServerTimeout;
var config OnlineSubsystem.ENATType CanHostDedicatedNatType;

defaultproperties
{
    OwningControllerIndex=0
    PlaylistTeamSize=5
    PlaylistTeamCount=2
    bUseSeamlessTravel=true
}