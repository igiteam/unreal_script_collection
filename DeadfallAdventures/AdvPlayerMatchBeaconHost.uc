class AdvPlayerMatchBeaconHost extends AdvPartyBeaconHost
    native(Online)
    config(Engine);

function int GetTeamForCurrentPlayer(UniqueNetId PlayerID)
{
    local int ResIdx, PlayerIdx, TeamNum;
    local UniqueNetId ZeroId;

    ScriptTrace();
    TeamNum = 1;
    // End:0x13D
    if(ZeroId != PlayerID)
    {
        ResIdx = 0;
        J0x3E:

        // End:0x13D [Loop If]
        if(ResIdx < Reservations.Length)
        {
            PlayerIdx = 0;
            J0x61:

            // End:0x12F [Loop If]
            if(PlayerIdx < Reservations[ResIdx].PartyMembers.Length)
            {
                // End:0x121
                if(Reservations[ResIdx].PartyMembers[PlayerIdx].NetId == PlayerID)
                {
                    TeamNum = Reservations[ResIdx].TeamNum;
                    // [Explicit Break]
                    goto J0x12F;
                }
                PlayerIdx++;
                // [Loop Continue]
                goto J0x61;
            }
            J0x12F:

            ResIdx++;
            // [Loop Continue]
            goto J0x3E;
        }
    }
    return TeamNum;
    //return ReturnValue;    
}

function int GetOccupiedTeamSize(int TeamIdx)
{
    local int ResIdx, PlayerIdx, NumTeamMembers;
    local UniqueNetId ZeroId;

    NumTeamMembers = 0;
    ResIdx = 0;
    J0x16:

    // End:0x121 [Loop If]
    if(ResIdx < Reservations.Length)
    {
        // End:0x113
        if(Reservations[ResIdx].TeamNum == TeamIdx)
        {
            PlayerIdx = 0;
            J0x6D:

            // End:0x113 [Loop If]
            if(PlayerIdx < Reservations[ResIdx].PartyMembers.Length)
            {
                // End:0x105
                if(Reservations[ResIdx].PartyMembers[PlayerIdx].NetId != ZeroId)
                {
                    NumTeamMembers++;
                }
                PlayerIdx++;
                // [Loop Continue]
                goto J0x6D;
            }
        }
        ResIdx++;
        // [Loop Continue]
        goto J0x16;
    }
    return NumTeamMembers;
    //return ReturnValue;    
}

function int GetAllReservations()
{
    local UniqueNetId ZeroId;
    local int ReservationsNo, ResIdx, PlayerIdx;

    ResIdx = 0;
    J0x0B:

    // End:0xE2 [Loop If]
    if(ResIdx < Reservations.Length)
    {
        PlayerIdx = 0;
        J0x2E:

        // End:0xD4 [Loop If]
        if(PlayerIdx < Reservations[ResIdx].PartyMembers.Length)
        {
            // End:0xC6
            if(Reservations[ResIdx].PartyMembers[PlayerIdx].NetId != ZeroId)
            {
                ReservationsNo++;
            }
            PlayerIdx++;
            // [Loop Continue]
            goto J0x2E;
        }
        ResIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
    return ReservationsNo;
    //return ReturnValue;    
}

function bool AddPKPartyReservation(UniqueNetId PartyLeader, const array<AdvRecentPlayer> PartyMembers, bool bIsGameHost)
{
    local array<PlayerReservation> ReservationMembers;
    local int CurPlayerIdx;
    local bool bResult;

    bResult = false;
    // End:0x1AF
    if(PartyMembers.Length > 0)
    {
        ReservationMembers.Length = Min(PartyMembers.Length, NumPlayersPerTeam);
        CurPlayerIdx = 0;
        J0x47:

        // End:0x154 [Loop If]
        if(CurPlayerIdx < ReservationMembers.Length)
        {
            ReservationMembers[CurPlayerIdx].NetId = PartyMembers[CurPlayerIdx].NetId;
            ReservationMembers[CurPlayerIdx].Skill = PartyMembers[CurPlayerIdx].Skill;
            ReservationMembers[CurPlayerIdx].XpLevel = PartyMembers[CurPlayerIdx].Level;
            CurPlayerIdx++;
            // [Loop Continue]
            goto J0x47;
        }
        // End:0x1AF
        if(int(AddPartyReservationEntry(PartyLeader, ReservationMembers, PartyMembers[0].TeamNum, bIsGameHost)) == int(6))
        {
            bResult = true;
        }
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bUpdateElapsedSessionTimes=true
    bLogoutOnSessionTimeout=true
    bAutoBalanceTeams=true
    bBestFitTeamAssignment=false
    PartyBeaconPort=8700
}