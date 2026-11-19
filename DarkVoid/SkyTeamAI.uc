class SkyTeamAI extends Info;

var SkyTeamInfo Team;
var SkyTeamInfo EnemyTeam;
var int NumSupportingPlayer;
var SkySquadAI Squads;
var SkySquadAI AttackSquad;
var class<SkySquadAI> SquadType;

function ClearEnemies()
{
    local SkySquadAI S;
    local int I;
    local SkyBotControllerBase M;

    Reset();
    S = Squads;
    J0x15:

    // End:0xB5 [Loop If]
    if(S != none)
    {
        I = 0;
        J0x27:

        // End:0x51 [Loop If]
        if(I < 8)
        {
            S.Reset();
            I++;
            // [Loop Continue]
            goto J0x27;
        }
        M = S.SquadMembers;
        J0x66:

        // End:0x9D [Loop If]
        if(M != none)
        {
            M.Reset();
            M = M.NextSquadMember;
            // [Loop Continue]
            goto J0x66;
        }
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

function SkySquadAI GetSquadLedBy(Controller C)
{
    local SkySquadAI S;

    S = Squads;
    J0x0B:

    // End:0x4D [Loop If]
    if(S != none)
    {
        // End:0x35
        if(S.SquadLeader == C)
        {
            return S;
        }
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local SkySquadAI S;

    S = Squads;
    J0x0B:

    // End:0x51 [Loop If]
    if(S != none)
    {
        S.NotifyKilled(Killer, Killed, KilledPawn);
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function RemoveSquad(SkySquadAI Squad)
{
    local SkySquadAI S;

    // End:0x16
    if(Squad == AttackSquad)
    {
        AttackSquad = none;
    }
    // End:0x3D
    if(Squad == Squads)
    {
        Squads = Squads.NextSquad;        
    }
    else
    {
        S = Squads;
        J0x48:

        // End:0xAF [Loop If]
        if(S != none)
        {
            // End:0x97
            if(S.NextSquad == Squad)
            {
                S.NextSquad = S.NextSquad.NextSquad;
                return;
            }
            S = S.NextSquad;
            // [Loop Continue]
            goto J0x48;
        }
    }
    //return;    
}

function SkySquadAI FindSquadOf(Controller C)
{
    local SkySquadAI S;

    // End:0x25
    if(SkyBotControllerBase(C) != none)
    {
        return SkyBotControllerBase(C).Squad;
    }
    S = Squads;
    J0x30:

    // End:0x72 [Loop If]
    if(S != none)
    {
        // End:0x5A
        if(S.SquadLeader == C)
        {
            return S;
        }
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x30;
    }
    return none;
    //return ReturnValue;    
}

function bool FriendlyToward(Actor Other)
{
    // End:0x30
    if(WorldInfo.GRI.OnSameTeam(Team, Other) == true)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function byte GetTeamNum()
{
    return byte(Team.TeamIndex);
    //return ReturnValue;    
}

function SkySquadAI FindHumanSquad()
{
    local SkySquadAI S;

    S = Squads;
    J0x0B:

    // End:0x56 [Loop If]
    if(S != none)
    {
        // End:0x3E
        if(S.SquadLeader.IsA('PlayerController'))
        {
            return S;
        }
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

function SkySquadAI AddHumanSquad()
{
    local SkySquadAI S;
    local PlayerController P;

    S = FindHumanSquad();
    // End:0x21
    if(S != none)
    {
        return S;
    }
    // End:0x94
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
    {
        // End:0x93
        if((P.PlayerReplicationInfo.Team == Team) && !P.PlayerReplicationInfo.bOnlySpectator)
        {            
            return AddSquadWithLeader(P);
        }        
    }    
    return none;
    //return ReturnValue;    
}

function PutBotOnSquadLedBy(Controller C, SkyBotControllerBase B)
{
    local SkySquadAI S;

    S = Squads;
    J0x0B:

    // End:0x4A [Loop If]
    if(S != none)
    {
        // End:0x32
        if(S.SquadLeader == C)
        {
            // [Explicit Break]
            goto J0x4A;
        }
        S = S.NextSquad;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x4A:

    // End:0x7C
    if((S == none) && PlayerController(C) != none)
    {
        S = AddSquadWithLeader(C);
    }
    // End:0xA0
    if(S != none)
    {
        S.AddBot(B);
    }
    //return;    
}

function SkySquadAI AddSquadWithLeader(Controller C)
{
    local SkySquadAI S;

    S = Spawn(SquadType);
    S.Initialize(Team, C);
    S.NextSquad = Squads;
    Squads = S;
    return S;
    //return ReturnValue;    
}

function SetBotOrders(SkyBotControllerBase NewBot, SkyRosterEntry R)
{
    PutOnOffense(NewBot);
    //return;    
}

function PutOnOffense(SkyBotControllerBase B)
{
    // End:0x48
    if((AttackSquad == none) || AttackSquad.Size >= AttackSquad.MaxSquadSize)
    {
        AttackSquad = AddSquadWithLeader(B);        
    }
    else
    {
        AttackSquad.AddBot(B);
    }
    //return;    
}

function RemoveFromTeam(Controller Other)
{
    local SkySquadAI S;

    // End:0x5F
    if(PlayerController(Other) != none)
    {
        S = Squads;
        J0x1B:

        // End:0x5C [Loop If]
        if(S != none)
        {
            S.RemovePlayer(PlayerController(Other));
            S = S.NextSquad;
            // [Loop Continue]
            goto J0x1B;
        }        
    }
    else
    {
        // End:0xBB
        if(SkyBotControllerBase(Other) != none)
        {
            S = Squads;
            J0x7A:

            // End:0xBB [Loop If]
            if(S != none)
            {
                S.RemoveBot(SkyBotControllerBase(Other));
                S = S.NextSquad;
                // [Loop Continue]
                goto J0x7A;
            }
        }
    }
    //return;    
}
