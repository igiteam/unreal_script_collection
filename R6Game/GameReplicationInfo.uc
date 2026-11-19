class GameReplicationInfo extends ReplicationInfo
    native
    nativereplication
    config(Game)
    notplaceable
    hidecategories(lighting,Movement,Collision);

enum ECarriedObjectState
{
    COS_Home,                       // 0
    COS_HeldFriendly,               // 1
    COS_HeldEnemy,                  // 2
    COS_Down,                       // 3
    COS_MAX                         // 4
};

var class<GameInfo> GameClass;
var bool bStopCountDown;
var repnotify bool bMatchHasBegun;
var bool bPlayIntro;
var int m_iSyncTimeInterval;
var int RemainingTime;
var int ElapsedTime;
var repnotify int replicatedRemainingTime;
var repnotify int replicatedElapsedTime;
var float SecondCount;
var int GoalScore;
var int TimeLimit;
var int MaxLives;
var TeamInfo Teams[2];
var() globalconfig string ServerName;
var() globalconfig string ShortName;
var() globalconfig string AdminName;
var() globalconfig string AdminEmail;
var() globalconfig int ServerRegion;
var() globalconfig string MessageOfTheDay;
var Actor Winner;
var() array<PlayerReplicationInfo> PRIArray;
var GameReplicationInfo.ECarriedObjectState CarriedObjectState[2];
var int MatchID;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        CarriedObjectState, MatchID, 
        Teams, Winner, 
        bMatchHasBegun, bStopCountDown, 
        replicatedElapsedTime, replicatedRemainingTime;

    // Pos:0x018
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        AdminEmail, AdminName, 
        GameClass, GoalScore, 
        MaxLives, MessageOfTheDay, 
        ServerName, ServerRegion, 
        ShortName, TimeLimit, 
        bPlayIntro;
}

simulated function PostBeginPlay()
{
    local PlayerReplicationInfo PRI;

    // End:0x39
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ServerName = "";
        AdminName = "";
        AdminEmail = "";
        MessageOfTheDay = "";
    }
    SecondCount = WorldInfo.TimeSeconds;
    SetTimer(WorldInfo.TimeDilation, true);
    WorldInfo.GRI = self;
    // End:0x8D
    foreach DynamicActors(Class'PlayerReplicationInfo', PRI)
    {
        AddPRI(PRI);        
    }    
    return;
}

function Reset()
{
    Winner = none;
    bMatchHasBegun = false;
    return;
}

simulated event bool OnSameTeam(Actor A, Actor B)
{
    local byte ATeamIndex, BTeamIndex;

    // End:0x30
    if((!GameClass.default.bTeamGame || A == none) || B == none)
    {
        return false;
    }
    ATeamIndex = A.GetTeamNum();
    // End:0x56
    if(int(ATeamIndex) == 255)
    {
        return false;
    }
    BTeamIndex = B.GetTeamNum();
    // End:0x7C
    if(int(BTeamIndex) == 255)
    {
        return false;
    }
    return int(ATeamIndex) == int(BTeamIndex);
    return;
}

simulated function PlayerReplicationInfo FindPlayerByID(int PlayerID)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(I < PRIArray.Length)
    {
        // End:0x41
        if(PRIArray[I].PlayerID == PlayerID)
        {
            return PRIArray[I];
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    return;
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    local int I;

    // End:0x14
    if(PRI.HasLeftTheGame)
    {
        return;
    }
    I = 0;
    J0x1B:

    // End:0x4C [Loop If]
    if(I < PRIArray.Length)
    {
        // End:0x42
        if(PRIArray[I] == PRI)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1B;
    }
    PRIArray[PRIArray.Length] = PRI;
    return;
}

simulated event RemovePRI(PlayerReplicationInfo PRI)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < PRIArray.Length)
    {
        // End:0x2F
        if(PRIArray[I] == PRI)
        {
            // [Explicit Break]
            goto J0x39;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x39:

    // End:0x4B
    if(I == PRIArray.Length)
    {
        return;
    }
    PRIArray.Remove(I, 1);
    return;
}

simulated function GetPRIArray(out array<PlayerReplicationInfo> pris)
{
    local int I, num;

    pris.Remove(0, pris.Length);
    I = 0;
    J0x14:

    // End:0x58 [Loop If]
    if(I < PRIArray.Length)
    {
        // End:0x4E
        if(PRIArray[I] != none)
        {
            pris[num++] = PRIArray[I];
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return;
}

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    // End:0x2E
    if(P1.bOnlySpectator)
    {
        // End:0x29
        if(P2.bOnlySpectator)
        {
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        // End:0x42
        if(P2.bOnlySpectator)
        {
            return true;
        }
    }
    // End:0x65
    if(P1.Score < P2.Score)
    {
        return false;
    }
    // End:0x110
    if(P1.Score == P2.Score)
    {
        // End:0xA9
        if(P1.Deaths > P2.Deaths)
        {
            return false;
        }
        // End:0x110
        if(((P1.Deaths == P2.Deaths) && PlayerController(P2.Owner) != none) && LocalPlayer(PlayerController(P2.Owner).Player) != none)
        {
            return false;
        }
    }
    return true;
    return;
}

simulated function SortPRIArray()
{
    local int I, J;
    local PlayerReplicationInfo tmp;

    I = 0;
    J0x07:

    // End:0xA7 [Loop If]
    if(I < (PRIArray.Length - 1))
    {
        J = I + 1;
        J0x28:

        // End:0x9D [Loop If]
        if(J < PRIArray.Length)
        {
            // End:0x93
            if(!InOrder(PRIArray[I], PRIArray[J]))
            {
                tmp = PRIArray[I];
                PRIArray[I] = PRIArray[J];
                PRIArray[J] = tmp;
            }
            J++;
            // [Loop Continue]
            goto J0x28;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    local Actor A;

    // End:0x60
    if(VarName == 'bMatchHasBegun')
    {
        // End:0x5D
        if(bMatchHasBegun)
        {
            // End:0x4D
            foreach AllActors(Class'Actor', A)
            {
                // End:0x4C
                if(!A.m_bShutdown)
                {
                    A.MatchStarting();
                }                
            }            
            WorldInfo.NotifyMatchStarted();
        }        
    }
    else
    {
        ReplicatedEvent(VarName);
    }
    return;
}

defaultproperties
{
    bStopCountDown=true
    m_iSyncTimeInterval=5
    ServerName="Another Server"
    ShortName="Server"
    TickGroup=1
}