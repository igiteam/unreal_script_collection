class TeamGameInfo extends MOHAMultiplayerGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var config float MaxDistToRateStart;
var config float MinDistToConsiderStart;
var config int SpawnRandomnessFactor;
var() SoundCue m_WinAllies;
var() SoundCue m_WinAxis;

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local bool bFilterOutByTeam, bSpawnIsReallyClose, bSpawnIsClose;
    local float MinDist;
    local MOHATeamPlayerStart TeamStart;
    local float Score, NextDist, SecondaryScore;
    local Controller OtherPlayer;

    SecondaryScore = 50.0000000;
    // End:0x1C
    if(P == none)
    {
        return -10.0000000;
    }
    // End:0x36
    if(!P.bEnabled)
    {
        return 0.0000000;
    }
    Score = ((P.bPrimaryStart) ? SecondaryScore + float(SpawnRandomnessFactor) : SecondaryScore);
    TeamStart = MOHATeamPlayerStart(P);
    // End:0x9B
    if((TeamStart != none) && TeamStart.bUsedAsStartPoint == true)
    {
        return 0.0000000;
    }
    bFilterOutByTeam = true;
    // End:0xB9
    if(TeamStart == none)
    {
        bFilterOutByTeam = false;        
    }
    else
    {
        // End:0xD9
        if(TeamStart.OwnerTeam == 255)
        {
            bFilterOutByTeam = false;            
        }
        else
        {
            // End:0xEF
            if(Player == none)
            {
                bFilterOutByTeam = false;                
            }
            else
            {
                // End:0x116
                if(int(Player.GetTeamNum()) == 255)
                {
                    bFilterOutByTeam = false;                    
                }
                else
                {
                    // End:0x146
                    if(int(Player.GetTeamNum()) == TeamStart.OwnerTeam)
                    {
                        bFilterOutByTeam = false;
                    }
                }
            }
        }
    }
    // End:0x155
    if(bFilterOutByTeam)
    {
        return 0.0000000;
    }
    // End:0x177
    if(GameModeFilteredOutThisPlayerStart(P, Team, Player))
    {
        return 0.0000000;
    }
    MinDist = MaxDistToRateStart;
    // End:0x386
    foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherPlayer)
    {
        // End:0x385
        if(OtherPlayer.bIsPlayer && OtherPlayer.Pawn != none)
        {
            // End:0x2B5
            if((Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < (P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)) && VSize2D(P.Location - OtherPlayer.Pawn.Location) < (P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius))
            {                
                return -10.0000000;
            }
            // End:0x385
            if(!WorldInfo.GRI.OnSameTeam(Player, OtherPlayer))
            {
                NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
                // End:0x345
                if((NextDist < MinDistToConsiderStart) && NextDist < MinDist)
                {
                    bSpawnIsReallyClose = true;
                    MinDist = NextDist;
                    // End:0x385
                    continue;
                }
                // End:0x385
                if((!bSpawnIsReallyClose && NextDist < MaxDistToRateStart) && NextDist < MinDist)
                {
                    bSpawnIsClose = true;
                    MinDist = NextDist;
                }
            }
        }        
    }    
    // End:0x3B2
    if(bSpawnIsReallyClose)
    {
        Score = (MinDist / MinDistToConsiderStart) * 10.0000000;
        return Score;        
    }
    else
    {
        // End:0x3FC
        if(bSpawnIsClose)
        {
            Score = (((MinDist - MinDistToConsiderStart) / (MaxDistToRateStart - MinDistToConsiderStart)) * 15.0000000) + 10.0000000;
            Score += float(Rand(5));
            return Score;
        }
    }
    Score += float(Rand(SpawnRandomnessFactor));
    return FMax(Score, 0.2000000);
    //return ReturnValue;    
}

function bool GameModeFilteredOutThisPlayerStart(PlayerStart P, byte Team, Controller Player)
{
    return false;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    local MOHAPlayerController PC;
    local int num_players[2];
    local float rankSums[2];
    local byte Current, newTeam;

    Current = super(GameInfo).PickTeam(Num, C);
    // End:0x32
    if(int(Current) < 2)
    {
        newTeam = Current;        
    }
    else
    {
        num_players[0] = 0;
        num_players[1] = 0;
        // End:0x11F
        foreach WorldInfo.AllControllers(Class'MOHAPlayerController', PC)
        {
            // End:0xD6
            if((PC.PlayerReplicationInfo.Team.TeamIndex >= 0) && PC.PlayerReplicationInfo.Team.TeamIndex <= 1)
            {
                num_players[PC.PlayerReplicationInfo.Team.TeamIndex]++;
            }
            rankSums[PC.PlayerReplicationInfo.Team.TeamIndex] += float(int(MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo).m_eMilitaryRank));            
        }        
        // End:0x13E
        if(num_players[0] < num_players[1])
        {
            newTeam = 0;            
        }
        else
        {
            // End:0x15C
            if(num_players[0] > num_players[1])
            {
                newTeam = 1;                
            }
            else
            {
                // End:0x17A
                if(rankSums[0] <= rankSums[1])
                {
                    newTeam = 0;                    
                }
                else
                {
                    newTeam = 1;
                }
            }
        }
    }
    return newTeam;
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    // End:0x0D
    if(Other == none)
    {
        return false;
    }
    // End:0x23
    if(Other.PlayerReplicationInfo == none)
    {
        return false;
    }
    // End:0x3E
    if((N < 0) || N > 255)
    {
        return false;
    }
    SetTeam(Other, N, bNewTeam);
    Voip.PlayerSwitchesTeams(MOHAPlayerReplicationInfo(Other.PlayerReplicationInfo));
    return true;
    //return ReturnValue;    
}

function SetTeam(Controller Other, int N, bool bNewTeam)
{
    local TeamInfo newTeam, T;
    local Actor A;

    // End:0x0D
    if(Other == none)
    {
        return;
    }
    // End:0x23
    if(Other.PlayerReplicationInfo == none)
    {
        return;
    }
    // End:0x6C
    if(Other.PlayerReplicationInfo.Team != none)
    {
        // End:0x6C
        if(Other.PlayerReplicationInfo.Team.TeamIndex == N)
        {
            return;
        }
    }
    Other.StartSpot = none;
    // End:0xDC
    if(Other.PlayerReplicationInfo.Team != none)
    {
        Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
        Other.PlayerReplicationInfo.Team = none;
    }
    // End:0x113
    foreach DynamicActors(Class'Engine.TeamInfo', T)
    {
        // End:0x112
        if(T.TeamIndex == N)
        {
            newTeam = T;
            // End:0x113
            break;
        }        
    }    
    // End:0x171
    if(newTeam == none)
    {
        newTeam = __NFUN_278__(Class'Engine.TeamInfo');
        // End:0x140
        if(newTeam == none)
        {
            return;
        }
        newTeam.TeamIndex = N;
        GameReplicationInfo.SetTeam(N, newTeam);
    }
    newTeam.AddToTeam(Other);
    // End:0x1DE
    if((PlayerController(Other) != none) && LocalPlayer(PlayerController(Other).Player) != none)
    {
        // End:0x1DD
        foreach DynamicActors(Class'Engine.Actor', A)
        {
            A.NotifyLocalPlayerTeamReceived();            
        }        
    }
    //return;    
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    local MOHAMultiplayerController mpc;
    local bool bIsOnAlliesTeam;

    mpc = MOHAMultiplayerController(C);
    // End:0x27
    if(mpc == none)
    {
        return super(GameInfo).GetDefaultPlayerClass(C);
    }
    bIsOnAlliesTeam = mpc.PlayerReplicationInfo.Team.TeamIndex == 0;
    switch(mpc.m_DesiredWeapon)
    {
        // End:0x8E
        case 1:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesRiflePawnClass : WorldInfo.AxisRiflePawnClass);
        // End:0xBB
        case 2:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesThompsonPawnClass : WorldInfo.AxisMP40PawnClass);
        // End:0xE8
        case 3:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesAutoRiflePawnClass : WorldInfo.AxisAutoRiflePawnClass);
        // End:0x115
        case 4:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesSniperPawnClass : WorldInfo.AxisSniperPawnClass);
        // End:0x142
        case 5:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesAntiTankPawnClass : WorldInfo.AxisAntiTankPawnClass);
        // End:0x16F
        case 6:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesThompsonPawnClass : WorldInfo.AxisMP40PawnClass);
        // End:0x174
        case 0:
        // End:0x1A1
        case 7:
            return ((bIsOnAlliesTeam) ? WorldInfo.AlliesThompsonPawnClass : WorldInfo.AxisMP40PawnClass);
        // End:0xFFFF
        default:
            return super(GameInfo).GetDefaultPlayerClass(C);
            break;
    }
    //return ReturnValue;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local MOHAGameReplicationInfo MGRI;
    local SoundCue WinSoundCue;

    MGRI = MOHAGameReplicationInfo(GameReplicationInfo);
    // End:0x29
    if(CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    GameReplicationInfo.RemainingTime = 0;
    // End:0x60
    if(Reason == "NoWinner")
    {
        MGRI.RoundStatus = 1;        
    }
    else
    {
        // End:0xAE
        if(int(SpecialCaseEndGame) == int(1))
        {
            MGRI.AlliedRoundsWon++;
            PlaySound(m_WinAllies);
            WinSoundCue = m_WinAllies;
            MGRI.RoundStatus = 2;            
        }
        else
        {
            // End:0xFC
            if(int(SpecialCaseEndGame) == int(2))
            {
                MGRI.AxisRoundsWon++;
                PlaySound(m_WinAxis);
                WinSoundCue = m_WinAxis;
                MGRI.RoundStatus = 2;                
            }
            else
            {
                // End:0x142
                if(MGRI.GetWinningTeam() == 0)
                {
                    MGRI.AlliedRoundsWon++;
                    PlaySound(m_WinAllies);
                    WinSoundCue = m_WinAllies;                    
                }
                else
                {
                    MGRI.AxisRoundsWon++;
                    PlaySound(m_WinAxis);
                    WinSoundCue = m_WinAxis;
                }
                // End:0x1D3
                if(((MGRI.AxisRoundsWon >= MGRI.BestOfThisManyRounds) || MGRI.AlliedRoundsWon >= MGRI.BestOfThisManyRounds) || ShouldEndDueToTeamQuit())
                {
                    MGRI.RoundStatus = 2;                    
                }
                else
                {
                    MGRI.RoundStatus = 1;
                }
            }
        }
    }
    MGRI.RemainingTime = 60 * TimeLimit;
    MGRI.ElapsedTime = 0;
    MGRI.ResetRoundStartTime();
    // End:0x2AA
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        PlayerController(P).ClientPlaySound(WinSoundCue);
        P.GotoState('RoundEnded');
        P.GameHasEnded(none, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo == Winner);        
    }    
    return true;
    //return ReturnValue;    
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local MOHAMultiplayerController MP;

    // End:0x67C
    if((KilledPlayer != none) && KilledPlayer.bIsPlayer)
    {
        // End:0x187
        if((Killer == KilledPlayer) || DamageType == Class'Engine.DmgType_Fell')
        {
            // End:0x184
            if((KilledPlayer != none) && KilledPlayer.PlayerReplicationInfo != none)
            {
                MOHAMultiplayerController(KilledPlayer).m_MPPlayerStats.StatAddTeamPoint(int(TeamPointsPenaltyForSuicide));
                MOHAPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo).MP_Suicides++;
                // End:0x12E
                if(DamageType != Class'Engine.DmgType_Suicided')
                {
                    RemoveTeamPointsForSuicide(KilledPlayer.PlayerReplicationInfo.Team.TeamIndex);
                    // End:0x12E
                    if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                    {
                        Class'Engine.Engine'.static.DSLog(KilledPlayer.PlayerReplicationInfo.PlayerName @ "killed himself.");
                    }
                }
                // End:0x183
                foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', MP)
                {
                    MP.ClientSuicideMessage(KilledPlayer.PlayerReplicationInfo.PlayerName, 'KilledBy', 15.0000000);                    
                }                
            }            
        }
        else
        {
            // End:0x279
            if(Killer == none)
            {
                // End:0x275
                foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', MP)
                {
                    MP.ClientDesertedMessage(KilledPlayer.PlayerReplicationInfo.PlayerName, 'KilledBy', 15.0000000);
                    // End:0x274
                    if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                    {
                        Class'Engine.Engine'.static.DSLog(((KilledPlayer.PlayerReplicationInfo.PlayerName @ "deserted to the") @ MOHAGameReplicationInfo(GameReplicationInfo).GetTeamName(KilledPlayer.PlayerReplicationInfo.Team.TeamIndex)) $ ".");
                    }                    
                }                                
            }
            else
            {
                // End:0x4FC
                if(((((Killer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team != none) && KilledPlayer.PlayerReplicationInfo != none) && KilledPlayer.PlayerReplicationInfo.Team != none) && Killer.PlayerReplicationInfo.Team == KilledPlayer.PlayerReplicationInfo.Team)
                {
                    MOHAMultiplayerController(Killer).m_MPPlayerStats.StatAddTeamKill();
                    MOHAMultiplayerController(Killer).m_MPPlayerStats.StatAddTeamPoint(int(TeamPointsPenaltyForTeamKill));
                    // End:0x3CB
                    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', MP)
                    {
                        MP.ClientTeamKilledMessage(Killer.PlayerReplicationInfo.PlayerName, KilledPlayer.PlayerReplicationInfo.PlayerName, 'KilledBy', 15.0000000);                        
                    }                    
                    RemoveTeamPointsForSuicide(Killer.PlayerReplicationInfo.Team.TeamIndex);
                    // End:0x48C
                    if(((((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || bPlayerCreatedUnrankedMatch) && TeamKillKick > 0) && !Killer.IsLocalPlayerController()) && MOHAMultiplayerController(Killer).m_MPPlayerStats.PRI.MP_TeamKills > TeamKillKick)
                    {
                        MOHAMultiplayerController(Killer).ClientServerKicked(true);
                    }
                    // End:0x4F9
                    if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                    {
                        Class'Engine.Engine'.static.DSLog((("Team kill:" @ Killer.PlayerReplicationInfo.PlayerName) @ "killed") @ KilledPlayer.PlayerReplicationInfo.PlayerName);
                    }                    
                }
                else
                {
                    // End:0x638
                    if(Killer.PlayerReplicationInfo != none)
                    {
                        Killer.PlayerReplicationInfo.Kills++;
                        AddTeamPointsForKill(Killer.PlayerReplicationInfo.Team.TeamIndex);
                        ScoreKillCalculatePoints(Killer, KilledPlayer, DamageType);
                        // End:0x5D8
                        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', MP)
                        {
                            MP.ClientKilledMessage(Killer.PlayerReplicationInfo.PlayerName, KilledPlayer.PlayerReplicationInfo.PlayerName, 'KilledBy', 15.0000000);                            
                        }                        
                        // End:0x638
                        if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
                        {
                            Class'Engine.Engine'.static.DSLog((Killer.PlayerReplicationInfo.PlayerName @ "killed") @ KilledPlayer.PlayerReplicationInfo.PlayerName);
                        }
                    }
                }
            }
        }
        // End:0x668
        if((Killer != none) || MaxLives > 0)
        {
            CheckScore(Killer.PlayerReplicationInfo);
        }
        CheckAssistPointsOnDeath(Killer, KilledPlayer);
    }
    super(GameInfo).Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    //return;    
}

function AddTeamPointsForKill(int TeamIndex)
{
    WorldInfo.GRI.Teams[TeamIndex].Score = WorldInfo.GRI.Teams[TeamIndex].Score + float(1);
    //return;    
}

function RemoveTeamPointsForSuicide(int TeamIndex)
{
    WorldInfo.GRI.Teams[TeamIndex].Score = WorldInfo.GRI.Teams[TeamIndex].Score - float(1);
    //return;    
}

event HandleSeamlessTravelPlayer(Controller C)
{
    super(GameInfo).HandleSeamlessTravelPlayer(C);
    SetTeam(C, C.PlayerReplicationInfo.Team.TeamIndex, true);
    //return;    
}

state RoundOver
{
    function bool CanRespawn(MOHAPlayerController C)
    {
        return false;
        //return ReturnValue;        
    }

    function RestartRound()
    {
        super.RestartRound();
        GameReplicationInfo.RemainingTime = 60 * TimeLimit;
        GameReplicationInfo.ElapsedTime = 0;
        MOHAGameReplicationInfo(GameReplicationInfo).ResetRoundStartTime();
        MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus = 0;
        //return;        
    }
    stop;    
}

defaultproperties
{
    MaxDistToRateStart=3000.0000000
    MinDistToConsiderStart=1000.0000000
    SpawnRandomnessFactor=50
    m_WinAllies=SoundCue'Aud_MP_FakeWAV.Music.Allied_Victory'
    m_WinAxis=SoundCue'Aud_MP_FakeWAV.Music.Axis_Victory'
}