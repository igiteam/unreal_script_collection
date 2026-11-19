class PlayerReplicationInfo extends ReplicationInfo
    native
    nativereplication
    notplaceable
    hidecategories(lighting,Movement,Collision);

var float Score;
var float Deaths;
var byte Ping;
var byte PacketLoss;
var Actor PlayerLocationHint;
var int NumLives;
var repnotify string PlayerName;
var string OldName;
var string PreviousName;
var int PlayerID;
var repnotify TeamInfo Team;
var int TeamID;
var bool bAdmin;
var bool bIsFemale;
var bool bIsSpectator;
var bool bOnlySpectator;
var bool bWaitingPlayer;
var bool bReadyToPlay;
var bool bOutOfLives;
var bool bBot;
var bool bHasFlag;
var bool bHasBeenWelcomed;
var bool HasLeftTheGame;
var bool IsStarter;
var int StartTime;
var const localized string StringDead;
var const localized string StringSpectating;
var const localized string StringUnknown;
var int GoalsScored;
var int Kills;
var class<GameMessage> GameMessageClass;
var float ExactPing;
var string m_xuid;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Deaths, HasLeftTheGame, 
        IsStarter, PlayerLocationHint, 
        PlayerName, Score, 
        StartTime, Team, 
        TeamID, bAdmin, 
        bHasFlag, bIsFemale, 
        bIsSpectator, bOnlySpectator, 
        bOutOfLives, bReadyToPlay, 
        bWaitingPlayer, m_xuid;

    // Pos:0x018
    if((bNetDirty && int(Role) == int(ROLE_Authority)) && !bNetOwner)
        PacketLoss, Ping;

    // Pos:0x03D
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        PlayerID, bBot;
}

simulated event PostBeginPlay()
{
    // End:0x2E
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.AddPRI(self);
    }
    // End:0x40
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x58
    if(AIController(Owner) != none)
    {
        bBot = true;
    }
    StartTime = WorldInfo.GRI.ElapsedTime;
    Timer();
    SetTimer(1.5000000 + FRand(), true);
    return;
}

simulated function ClientInitialize(Controller C)
{
    local Actor A;

    SetOwner(C);
    // End:0x49
    if(PlayerController(C) != none)
    {
        // End:0x49
        if(Team != default.Team)
        {
            // End:0x48
            foreach AllActors(Class'Actor', A)
            {
                A.NotifyLocalPlayerTeamReceived();                
            }            
        }
    }
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    local Pawn P;
    local PlayerController PC;
    local int WelcomeMessageNum;
    local Actor A;

    // End:0x94
    if(VarName == 'Team')
    {
        // End:0x47
        foreach DynamicActors(Class'Pawn', P)
        {
            // End:0x46
            if(P.PlayerReplicationInfo == self)
            {
                P.NotifyTeamChanged();
                // End:0x47
                break;
            }            
        }        
        // End:0x90
        foreach LocalPlayerControllers(PC)
        {
            // End:0x8C
            if(PC.PlayerReplicationInfo == self)
            {
                // End:0x8B
                foreach AllActors(Class'Actor', A)
                {
                    A.NotifyLocalPlayerTeamReceived();                    
                }                
            }
            // End:0x90
            break;            
        }                
    }
    else
    {
        // End:0x195
        if(VarName == 'PlayerName')
        {
            // End:0xCF
            if(WorldInfo.TimeSeconds < float(2))
            {
                // End:0xCD
                if(PlayerID != 0)
                {
                    bHasBeenWelcomed = true;
                }
                return;
            }
            // End:0x10F
            if(bHasBeenWelcomed)
            {
                // End:0x10C
                if(ShouldBroadCastWelcomeMessage())
                {
                    // End:0x10B
                    foreach LocalPlayerControllers(PC)
                    {
                        PC.ReceiveLocalizedMessage(GameMessageClass, 2, self);                        
                    }                    
                }                
            }
            else
            {
                // End:0x123
                if(bOnlySpectator)
                {
                    WelcomeMessageNum = 16;                    
                }
                else
                {
                    WelcomeMessageNum = 1;
                }
                // End:0x13D
                if(PlayerID != 0)
                {
                    bHasBeenWelcomed = true;
                }
                PreviousName = PlayerName;
                // End:0x17F
                if(ShouldBroadCastWelcomeMessage())
                {
                    // End:0x17E
                    foreach LocalPlayerControllers(PC)
                    {
                        PC.ReceiveLocalizedMessage(GameMessageClass, WelcomeMessageNum, self);                        
                    }                    
                }
            }
            OldName = PreviousName;
            PreviousName = PlayerName;
        }
    }
    return;
}

simulated function HasLeftGame()
{
    local PlayerController PC;

    // End:0x3B
    if((WorldInfo != none) && WorldInfo.GRI != none)
    {
        WorldInfo.GRI.RemovePRI(self);
    }
    // End:0x6F
    if(ShouldBroadCastWelcomeMessage())
    {
        // End:0x6E
        foreach LocalPlayerControllers(PC)
        {
            PC.ReceiveLocalizedMessage(GameMessageClass, 4, self);            
        }        
    }
    HasLeftTheGame = true;
    return;
}

// Export UPlayerReplicationInfo::execUpdatePing(FFrame&, void* const)
native final function UpdatePing(float TimeStamp);

simulated function bool ShouldBroadCastWelcomeMessage()
{
    return bHasBeenWelcomed && int(WorldInfo.NetMode) != int(NM_Standalone);
    return;
}

simulated function Destroyed()
{
    // End:0x2E
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.RemovePRI(self);
    }
    Destroyed();
    return;
}

function Reset()
{
    Score = 0.0000000;
    Deaths = 0.0000000;
    bReadyToPlay = false;
    NumLives = 0;
    bOutOfLives = false;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

simulated function string GetHumanReadableName()
{
    return PlayerName;
    return;
}

simulated function string GetLocationName()
{
    local string LocationString;

    // End:0x11
    if(PlayerLocationHint == none)
    {
        return StringSpectating;
    }
    LocationString = PlayerLocationHint.GetLocationStringFor(self);
    // End:0x3A
    if(LocationString == "")
    {
        return StringUnknown;
    }
    return LocationString;
    return;
}

function UpdatePlayerLocation()
{
    local Volume V, Best;
    local Pawn P;

    // End:0x29
    if(Controller(Owner) != none)
    {
        P = Controller(Owner).Pawn;
    }
    // End:0x3D
    if(P == none)
    {
        PlayerLocationHint = none;
        return;
    }
    // End:0xC5
    foreach P.TouchingActors(Class'Volume', V)
    {
        // End:0x6F
        if(V.LocationName == "")
        {
            continue;            
        }
        // End:0xA1
        if((Best != none) && V.LocationPriority <= Best.LocationPriority)
        {
            continue;            
        }
        // End:0xC4
        if(V.Encompasses(P))
        {
            Best = V;
        }        
    }    
    // End:0xDF
    if(Best != none)
    {
        PlayerLocationHint = Best;        
    }
    else
    {
        PlayerLocationHint = P.Region.Zone;
    }
    return;
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    local float XS, YS;

    // End:0x31
    if(Team == none)
    {
        HUD.Canvas.SetDrawColor(byte(255), byte(255), 0);        
    }
    else
    {
        // End:0x69
        if(Team.TeamIndex == 0)
        {
            HUD.Canvas.SetDrawColor(byte(255), 0, 0);            
        }
        else
        {
            HUD.Canvas.SetDrawColor(64, 64, byte(255));
        }
    }
    HUD.Canvas.SetPos(4.0000000, YPos);
    HUD.Canvas.Font = Class'Engine'.default.SmallFont;
    HUD.Canvas.__NFUN_464__(PlayerName, XS, YS);
    HUD.Canvas.__NFUN_465__(PlayerName);
    HUD.Canvas.SetPos(4.0000000 + XS, YPos);
    HUD.Canvas.Font = Class'Engine'.default.TinyFont;
    HUD.Canvas.SetDrawColor(byte(255), byte(255), 0);
    // End:0x1B0
    if(bHasFlag)
    {
        HUD.Canvas.__NFUN_465__("   has flag ");
    }
    YPos += YS;
    HUD.Canvas.SetPos(4.0000000, YPos);
    // End:0x301
    if(!bBot && PlayerController(HUD.Owner).ViewTarget != PlayerController(HUD.Owner).Pawn)
    {
        HUD.Canvas.SetDrawColor(128, 128, byte(255));
        HUD.Canvas.__NFUN_465__((((((((("      bIsSpec:" @ string(bIsSpectator)) @ "OnlySpec:") $ string(bOnlySpectator)) @ "Waiting:") $ string(bWaitingPlayer)) @ "Ready:") $ string(bReadyToPlay)) @ "OutOfLives:") $ string(bOutOfLives));
        YPos += YL;
        HUD.Canvas.SetPos(4.0000000, YPos);
    }
    return;
}

function Timer()
{
    UpdatePlayerLocation();
    SetTimer(1.5000000 + FRand(), true);
    return;
}

event SetPlayerName(string S)
{
    PlayerName = S;
    // End:0x4B
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        ReplicatedEvent('PlayerName');
    }
    OldName = PlayerName;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

function SetWaitingPlayer(bool B)
{
    bIsSpectator = B;
    bWaitingPlayer = B;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

defaultproperties
{
    StringDead="Dead"
    StringSpectating="Spectating"
    StringUnknown="Unknown"
    GameMessageClass=Class'GameMessage'
    TickGroup=1
    NetUpdateFrequency=1.0000000
}