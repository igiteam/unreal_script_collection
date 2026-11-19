class AdvRecentPlayersList extends OnlineRecentPlayersList
    config(Engine);

struct AdvRecentPlayer extends CurrentPlayerMet
{
    var int Level;
};

struct PKRecentPlayerEndMatch extends AdvRecentPlayer
{
    var string Name;
    var string PawnClassName;
    var string TeamName;
    var int TeamScore;
    var bool bDidComplete;
    var bool bWasAFK;
    var bool bIsGuest;
};

struct PKRecentParty
{
    var UniqueNetId PartyLeader;
    var array<AdvRecentPlayer> PartyMembers;

    structdefaultproperties
    {
        PartyLeader=(Uid=none)
        PartyMembers=none
    }
};

var array<PKRecentParty> LastPKParties;
var bool bFromMapCycle;

function AddLastPKParty(UniqueNetId PartyLeader, const out array<AdvRecentPlayer> PartyMembers)
{
    local int FoundIdx;
    local UniqueNetId ZeroId;

    // End:0xD9
    if(PartyLeader != ZeroId)
    {
        FoundIdx = FindLastPKPartyIndex(PartyLeader);
        // End:0x79
        if(FoundIdx == -1)
        {
            FoundIdx = LastPKParties.Length;
            LastPKParties.Length = FoundIdx + 1;
        }
        LastPKParties[FoundIdx].PartyLeader = PartyLeader;
        LastPKParties[FoundIdx].PartyMembers = PartyMembers;
    }
    //return;    
}

function AddLastPKPartyPlayer(UniqueNetId PartyLeader, const out AdvRecentPlayer PartyMember)
{
    local int Idx, FoundIdx, PlayerIdx;
    local UniqueNetId ZeroId;

    // End:0x239
    if(PartyLeader != ZeroId)
    {
        FoundIdx = FindLastPKPartyIndex(PartyLeader);
        // End:0x79
        if(FoundIdx == -1)
        {
            FoundIdx = LastPKParties.Length;
            LastPKParties.Length = FoundIdx + 1;
        }
        LastPKParties[FoundIdx].PartyLeader = PartyLeader;
        PlayerIdx = -1;
        Idx = 0;
        J0xC3:

        // End:0x187 [Loop If]
        if(Idx < LastPKParties[FoundIdx].PartyMembers.Length)
        {
            // End:0x179
            if(LastPKParties[FoundIdx].PartyMembers[Idx].NetId == PartyMember.NetId)
            {
                PlayerIdx = Idx;
                // [Explicit Break]
                goto J0x187;
            }
            Idx++;
            // [Loop Continue]
            goto J0xC3;
        }
        J0x187:

        // End:0x1FF
        if(PlayerIdx == -1)
        {
            PlayerIdx = LastPKParties[FoundIdx].PartyMembers.Length;
            LastPKParties[FoundIdx].PartyMembers.Length = PlayerIdx + 1;
        }
        LastPKParties[FoundIdx].PartyMembers[PlayerIdx] = PartyMember;
    }
    //return;    
}

function int FindLastPKPartyIndex(UniqueNetId PartyLeader)
{
    local int Idx, FoundIdx;

    FoundIdx = -1;
    Idx = 0;
    J0x1A:

    // End:0x91 [Loop If]
    if(Idx < LastPKParties.Length)
    {
        // End:0x83
        if(LastPKParties[Idx].PartyLeader == PartyLeader)
        {
            FoundIdx = Idx;
            // [Explicit Break]
            goto J0x91;
        }
        Idx++;
        // [Loop Continue]
        goto J0x1A;
    }
    J0x91:

    return FoundIdx;
    //return ReturnValue;    
}

function ClearAllPKParties()
{
    LastPKParties.Length = 0;
    //return;    
}
