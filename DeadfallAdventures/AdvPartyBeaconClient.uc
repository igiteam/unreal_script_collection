class AdvPartyBeaconClient extends PartyBeaconClient
    native(Online)
    config(Engine);

enum EPKsPartyBeaconClientRequest
{
    GPBClientRequest_NewReservationWithPlaylist,// 0
    GPBClientRequest_MAX            // 1
};

var int PlaylistId;

// Export UAdvPartyBeaconClient::execRequestReservationWithPlaylist(FFrame&, void* const)
native function bool RequestReservationWithPlaylist(const out OnlineGameSearchResult DesiredHost, UniqueNetId RequestingPartyLeader, const out array<PlayerReservation> Players, int InPlaylistId);

defaultproperties
{
    PlaylistId=-1
}