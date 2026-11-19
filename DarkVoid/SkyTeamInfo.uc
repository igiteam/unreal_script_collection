class SkyTeamInfo extends TeamInfo
    native;

var() SkyRosterEntry DefaultRosterEntry;
var() export editinline array<export editinline SkyRosterEntry> Roster;
var() class<SkyPawn> AllowedTeamMembers[32];
var int DesiredTeamSize;
var SkyTeamAI AI;
var string TeamSymbolName;
var repnotify Material TeamIcon;
var SkyGameObjective HomeBase;
var SkyCarriedObject TeamFlag;
var array<string> RosterNames;
var Color BaseTeamColor[4];
var Color UniformTeamColor[4];
var Color TextColor[4];
var const localized string TeamColorNames[4];

replication
{
    // Pos:0x000
    if(bNetInitial
        TeamIcon;

    // Pos:0x006
    if(bNetDirty
        HomeBase, TeamFlag;
}

simulated function string GetHumanReadableName()
{
    // End:0x36
    if(TeamName == default.TeamName)
    {
        // End:0x27
        if(TeamIndex < 4)
        {
            return TeamColorNames[TeamIndex];
        }
        return TeamName @ string(TeamIndex);
    }
    return TeamName;
    //return ReturnValue;    
}

simulated function Color GetHUDColor()
{
    return BaseTeamColor[TeamIndex];
    //return ReturnValue;    
}

simulated function Color GetTextColor()
{
    return TextColor[TeamIndex];
    //return ReturnValue;    
}

simulated function Color GetUniformColor()
{
    return UniformTeamColor[TeamIndex];
    //return ReturnValue;    
}

function Reset()
{
    super(Actor).Reset();
    // End:0x35
    if(!SkyGame(WorldInfo.Game).bTeamScoreRounds)
    {
        Score = 0.0000000;
    }
    //return;    
}

function bool AllBotsSpawned()
{
    return false;
    //return ReturnValue;    
}

function Initialize(int TeamBots)
{
    //return;    
}

simulated function class<Pawn> NextLoadOut(class<Pawn> CurrentLoadout)
{
    local int I;
    local class<Pawn> Result;

    Result = AllowedTeamMembers[0];
    I = 0;
    J0x14:

    // End:0x84 [Loop If]
    if(I < (32 - 1))
    {
        // End:0x66
        if(AllowedTeamMembers[I] == CurrentLoadout)
        {
            // End:0x60
            if(AllowedTeamMembers[I + 1] != none)
            {
                Result = AllowedTeamMembers[I + 1];
            }
            // [Explicit Break]
            goto J0x84;
            // [Explicit Continue]
            goto J0x7A;
        }
        // End:0x7A
        if(AllowedTeamMembers[I] == none)
        {
            // [Explicit Break]
            goto J0x84;
        }
        J0x7A:

        I++;
        // [Loop Continue]
        goto J0x14;
    }
    J0x84:

    return Result;
    //return ReturnValue;    
}

function bool NeedsBotMoreThan(SkyTeamInfo T)
{
    return (DesiredTeamSize - Size) > (T.DesiredTeamSize - T.Size);
    //return ReturnValue;    
}

function SkyRosterEntry ChooseBotClass(optional string BotName)
{
    // End:0x18
    if(BotName == "")
    {
        return GetNextBot();
    }
    return GetNamedBot(BotName);
    //return ReturnValue;    
}

function SkyRosterEntry GetRandomPlayer()
{
    //return ReturnValue;    
}

function AddRandomPlayer()
{
    //return;    
}

function SkyRosterEntry GetNextBot()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x60 [Loop If]
    if(I < Roster.Length)
    {
        // End:0x56
        if(!Roster[I].bTaken)
        {
            Roster[I].bTaken = true;
            return Roster[I];
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = Roster.Length;
    Roster.Length = Roster.Length + 1;
    Roster[I] = GetRandomPlayer();
    Roster[I].bTaken = true;
    return Roster[I];
    //return ReturnValue;    
}

function AddNamedBot(string BotName)
{
    //return;    
}

function SkyRosterEntry GetNamedBot(string BotName)
{
    return GetNextBot();
    //return ReturnValue;    
}

function SetBotOrders(SkyBotControllerBase NewBot, SkyRosterEntry R)
{
    // End:0x29
    if(AI != none)
    {
        AI.SetBotOrders(NewBot, R);
    }
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    // End:0x1E
    if(AI != none)
    {
        AI.Destroy();
    }
    //return;    
}
