class AdvPartyBeaconHost extends PartyBeaconHost
    native(Online)
    config(Engine);

enum EPKsReservationPacketType
{
    GRPT_ClientReservationWithPlaylistRequest,// 0
    GRPT_MAX                        // 1
};

struct native LastMatchPlayerData
{
    var UniqueNetId NetId;
    var int Score;

    structdefaultproperties
    {
        NetId=(Uid=none)
        Score=0
    }
};

var int PlaylistId;
var bool bAllowAdditionalConfigurationRequests;
var bool bUpdateElapsedSessionTimes;
var bool bLogoutOnSessionTimeout;
var bool bAutoBalanceTeams;
var config float SessionTimeoutSecs;
var config float TravelSessionTimeoutSecs;
var array<UniqueNetId> PlayersPendingJoin;
var float WeightPlayerXpLevel;
var float WeightPlayerSkill;
//var delegate<OnPlaylistInit> __OnPlaylistInit__Delegate;

// Export UAdvPartyBeaconHost::execResetElapsedSessionUpdateTimes(FFrame&, void* const)
native function ResetElapsedSessionUpdateTimes();

delegate OnPlaylistInit(int RequestedPlaylistId)
{
    //return;    
}

function int GetPlaylistId()
{
    return PlaylistId;
    //return ReturnValue;    
}

function ResetPlaylist()
{
    PlaylistId = default.PlaylistId;
    //return;    
}

// Export UAdvPartyBeaconHost::execReconfigureTeamAndPlayerCount(FFrame&, void* const)
native function bool ReconfigureTeamAndPlayerCount(int InNumTeams, int InNumPlayersPerTeam, int InNumReservations);

// Export UAdvPartyBeaconHost::execRebalanceTeamAssignments(FFrame&, void* const)
native function RebalanceTeamAssignments(optional array<LastMatchPlayerData> PlayerDataLastMatch);

function RebalanceTeamAssignmentsUsingScores()
{
    local array<LastMatchPlayerData> PlayerDataLastMatch;
    local int ResIdx, PlayerIdx;
    local UniqueNetId ZeroId, NetId;
    local LastMatchPlayerData NewPlayerEntry;

    ResIdx = 0;
    J0x0B:

    // End:0x14C [Loop If]
    if(ResIdx < Reservations.Length)
    {
        PlayerIdx = 0;
        J0x2E:

        // End:0x13E [Loop If]
        if(PlayerIdx < Reservations[ResIdx].PartyMembers.Length)
        {
            NetId = Reservations[ResIdx].PartyMembers[PlayerIdx].NetId;
            // End:0x130
            if(NetId != ZeroId)
            {
                NewPlayerEntry.NetId = NetId;
                NewPlayerEntry.Score = PlayerIdx;
                PlayerDataLastMatch.AddItem(NewPlayerEntry);                
            }
            PlayerIdx++;
            // [Loop Continue]
            goto J0x2E;
        }
        ResIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
    RebalanceTeamAssignments(PlayerDataLastMatch);
    //return;    
}

// Export UAdvPartyBeaconHost::execUpdatePlayerReservationSkills(FFrame&, void* const)
native function UpdatePlayerReservationSkills(const out UniqueNetId PlayerNetId, int Skill, int XpLevel);

defaultproperties
{
    PlaylistId=-1
    SessionTimeoutSecs=10.0000000
    TravelSessionTimeoutSecs=45.0000000
    WeightPlayerXpLevel=1.0000000
    bBestFitTeamAssignment=true
}