class TurokTeamGame extends TurokMPGame
    abstract
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var const config string TeamNames[2];
var const config @NULL TeamColors[2];
var protected const config float MaxDistanceForProximityKillPoints;
var protected config bool SpectateTeamOnly;
var protected config bool SpawnInTeamArea;
var protected config float FriendlyFireScale;
var protected config float TeamMateBoost;
var protected config int MaxTeamLives;

function InitGameReplicationInfo()
{
    local @NULL TGRI;

    super.InitGameReplicationInfo();
    TGRI = TurokTeamGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(TGRI != none);
    TGRI.mFriendlyFireScale = FriendlyFireScale;
    TGRI.mMaxTeamLives = MaxTeamLives;
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super.InitGame(Options, ErrorMessage);
    // End:0x1E
    if(ErrorMessage != "")
    {
        return;
    }
    InOpt = ParseOption(Options, "SpectateTeamOnly");
    // End:0x5F
    if(InOpt != "")
    {
        SpectateTeamOnly = bool(InOpt);
    }
    InOpt = ParseOption(Options, "SpawnInTeamArea");
    // End:0x9F
    if(InOpt != "")
    {
        SpawnInTeamArea = bool(InOpt);
    }
    InOpt = ParseOption(Options, "FriendlyFireScale");
    // End:0xEC
    if(InOpt != "")
    {
        FriendlyFireScale = FClamp(float(InOpt), 0.0000000, 1.0000000);
    }
    InOpt = ParseOption(Options, "TeamMateBoost");
    // End:0x135
    if(InOpt != "")
    {
        TeamMateBoost = FClamp(float(InOpt), 0.0000000, 1.0000000);
    }
    InOpt = ParseOption(Options, "MaxTeamLives");
    // End:0x171
    if(InOpt != "")
    {
        MaxTeamLives = int(InOpt);
    }
    // End:0x190
    if((MaxLives > 0) && MaxTeamLives > 0)
    {
        MaxLives = 0;
    }
    //return;    
}

event PreBeginPlay()
{
    local int I;

    super.PreBeginPlay();
    I = 0;
    J0x0D:

    // End:0x32 [Loop If]
    if(I < 2)
    {
        createTeam(I);
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function createTeam(int TeamIndex)
{
    local @NULL Team;

    Team = __NFUN_278__(Class'TurokTeamInfo');
    GameReplicationInfo.Teams[TeamIndex] = Team;
    Team.Initialize(TeamIndex);
    //return;    
}

function StartMatch()
{
    local int I;
    local @NULL Team;

    I = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(I < 2)
    {
        Team = TurokTeamInfo(GameReplicationInfo.Teams[I]);
        Team.SetDefaultSpawnTarget();
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    super.StartMatch();
    //return;    
}

protected function bool CheckMinimumPlayers(@NULL ExitingController)
{
    local int I, NumTeamPlayers;
    local @NULL net;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x52
    if((net != none) && net.GetLobby() != none)
    {
        return net.GetLobby().CheckMinimumGamePlayers(true);
    }
    I = 0;
    J0x59:

    // End:0xF0 [Loop If]
    if(I < 2)
    {
        NumTeamPlayers = GameReplicationInfo.Teams[I].Size;
        // End:0xD5
        if((ExitingController != none) && int(ExitingController.GetTeamNum()) == int(GameReplicationInfo.Teams[I].TeamIndex))
        {
            --NumTeamPlayers;
        }
        // End:0xE6
        if(NumTeamPlayers < MinimumPlayers)
        {
            return false;
        }
        ++I;
        // [Loop Continue]
        goto J0x59;
    }
    return true;
    //return ReturnValue;    
}

function Reset()
{
    local int currTeamIndex;
    local @NULL TTeamInfo;

    super.Reset();
    currTeamIndex = 0;
    J0x0D:

    // End:0x62 [Loop If]
    if(currTeamIndex < 2)
    {
        TTeamInfo = TurokTeamInfo(GameReplicationInfo.Teams[currTeamIndex]);
        // DebugMode: 0
        assert(TTeamInfo != none);
        TTeamInfo.mNumLives = MaxTeamLives;
        ++currTeamIndex;
        // [Loop Continue]
        goto J0x0D;
    }
    // End:0x71
    if(IsNextRoundReset())
    {
        return;
    }
    currTeamIndex = 0;
    J0x78:

    // End:0xB1 [Loop If]
    if(currTeamIndex < 2)
    {
        GameReplicationInfo.Teams[currTeamIndex].Score = 0.0000000;
        ++currTeamIndex;
        // [Loop Continue]
        goto J0x78;
    }
    //return;    
}

function byte PickTeam(byte TeamIndex, @NULL C)
{
    local int I;

    // End:0x23
    if((int(TeamIndex) >= 0) && int(TeamIndex) < 2)
    {
        return TeamIndex;
    }
    TeamIndex = 0;
    I = 1;
    J0x32:

    // End:0x96 [Loop If]
    if(I < 2)
    {
        // End:0x8C
        if(GameReplicationInfo.Teams[I].Size < GameReplicationInfo.Teams[int(TeamIndex)].Size)
        {
            TeamIndex = byte(I);
        }
        ++I;
        // [Loop Continue]
        goto J0x32;
    }
    return TeamIndex;
    //return ReturnValue;    
}

function bool ChangeTeam(@NULL Other, int Num, bool bNewTeam)
{
    local @NULL NewTeam, net, Lobby;

    // DebugMode: 0
    assert(Other != none);
    // End:0x1D6
    if(Other.bIsPlayer)
    {
        // DebugMode: 0
        assert(Other.PlayerReplicationInfo != none);
        Num = int(PickTeam(byte(Num), Other));
        NewTeam = TurokTeamInfo(GameReplicationInfo.Teams[Num]);
        // DebugMode: 0
        assert(NewTeam != none);
        // End:0x9F
        if(Other.PlayerReplicationInfo.Team == NewTeam)
        {
            return false;
        }
        Other.StartSpot = none;
        // End:0x10F
        if(Other.PlayerReplicationInfo.Team != none)
        {
            Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
            Other.PlayerReplicationInfo.Team = none;
        }
        // End:0x1D3
        if((NewTeam != none) && NewTeam.AddToTeam(Other))
        {
            net = Class'Engine.Engine'.static.GetTurokNet();
            // End:0x1B4
            if(net != none)
            {
                Lobby = net.GetLobby();
                // End:0x1B4
                if(Lobby != none)
                {
                    Lobby.ModifyPlayerTeam(Other.PlayerReplicationInfo.UniqueId, Other.PlayerReplicationInfo.TeamIndex);
                }
            }
            return (MaxTeamLives == 0) || NewTeam.mNumLives > 0;
        }        
    }
    else
    {
        // End:0x205
        if(TurokAIControllerHumanNpc(Other) != none)
        {
            TurokAIControllerHumanNpc(Other).SetTeamNum(Num);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function float RatePlayerStart(@NULL P, byte Team, @NULL Player)
{
    local @NULL TP, SpawnTarget;

    // End:0x9F
    if(SpawnInTeamArea)
    {
        TP = TurokMPPlayerStart(P);
        // End:0x4D
        if((TP == none) || int(TP.GetTeamNum()) != int(Team))
        {
            return 0.0000000;
        }
        SpawnTarget = TurokMPTeamSpawnTarget(TP.GetSpawnTarget());
        // End:0x9F
        if((SpawnTarget == none) || int(SpawnTarget.GetTeamNum()) != int(Team))
        {
            return 0.0000000;
        }
    }
    return super.RatePlayerStart(P, Team, Player);
    //return ReturnValue;    
}

protected function @NULL GetMatchEndFocus(byte WinningTeamIndex)
{
    // End:0x13
    if(int(WinningTeamIndex) == 0)
    {
        return mGameJustEndedViewpointTeam0;
    }
    return mGameJustEndedViewpointTeam1;
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, @NULL injured, @NULL InstigatedBy, @NULL HitLocation, out @NULL Momentum, class<Class> DamageType)
{
    local int InjuredTeam, instigatorTeam;

    // End:0x104
    if((InstigatedBy != none) && injured != none)
    {
        InjuredTeam = int(injured.GetTeamNum());
        instigatorTeam = int(InstigatedBy.GetTeamNum());
        // End:0x104
        if((injured.DrivenVehicle == none) || InstigatedBy.Pawn != injured.DrivenVehicle)
        {
            // End:0x104
            if((InjuredTeam != 255) && instigatorTeam != 255)
            {
                // End:0x104
                if(InjuredTeam == instigatorTeam)
                {
                    // End:0xE0
                    if(DamageType != none)
                    {
                        Momentum *= TeamMateBoost;
                        // End:0xE0
                        if(int(DamageType.default.mReactionType) == int(2))
                        {
                            return;
                        }
                    }
                    // End:0xF8
                    if(FriendlyFireScale == 0.0000000)
                    {
                        Damage = 0;
                        return;
                    }
                    Damage *= FriendlyFireScale;
                }
            }
        }
    }
    // End:0x133
    if(Damage > 0)
    {
        super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    //return;    
}

function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
{
    local @NULL TTeamInfo, PRI;

    // End:0x141
    if(AllowKillScoreUpdate(DamageType))
    {
        // End:0xB7
        if(((MaxTeamLives != 0) && TurokPlayerController(KilledPlayer) != none) && KilledPlayer.PlayerReplicationInfo != none)
        {
            TTeamInfo = TurokTeamInfo(KilledPlayer.PlayerReplicationInfo.Team);
            // DebugMode: 0
            assert(TTeamInfo != none);
            // End:0xA4
            if(TTeamInfo.mNumLives == 0)
            {
                KilledPlayer.PlayerReplicationInfo.bOutOfLives = true;                
            }
            else
            {
                TTeamInfo.DecrementNumberOfLives();
            }
        }
        // End:0x141
        if(Killer != none)
        {
            PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
            // End:0x141
            if(((PRI != none) && Killer != KilledPlayer) && GameReplicationInfo.OnSameTeam(Killer, KilledPlayer))
            {
                PRI.AddRespawnInterval(FriendlyFireRespawnTimePenalty);
                PRI.mFriendly++;
            }
        }
    }
    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    //return;    
}

function bool CheckScore(@NULL Scorer)
{
    // End:0x70
    if(GoalScore > 0)
    {
        // End:0x70
        if((GameReplicationInfo.Teams[0].Score >= float(GoalScore)) || GameReplicationInfo.Teams[1].Score >= float(GoalScore))
        {
            EndGame(none, "scorelimit");
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected function bool CheckLives()
{
    local @NULL PRI, bestPlayerStillStanding, GRI;
    local bool somebodyAliveTeam0, somebodyAliveTeam1;
    local int numPlayersOnTeam0, numPlayersOnTeam1, I;

    GRI = TurokTeamGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    // End:0x1C8
    if((MaxLives > 0) || MaxTeamLives > 0)
    {
        I = 0;
        J0x3B:

        // End:0xFF [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            PRI = GRI.PRIArray[I];
            // End:0xB3
            if(int(PRI.Team.TeamIndex) == 0)
            {
                // End:0xA9
                if(!PRI.bOutOfLives)
                {
                    somebodyAliveTeam0 = true;
                }
                ++numPlayersOnTeam0;
                // [Explicit Continue]
                goto J0xF5;
            }
            // End:0xF5
            if(int(PRI.Team.TeamIndex) == 1)
            {
                // End:0xEE
                if(!PRI.bOutOfLives)
                {
                    somebodyAliveTeam1 = true;
                }
                ++numPlayersOnTeam1;
            }
            J0xF5:

            ++I;
            // [Loop Continue]
            goto J0x3B;
        }
        // End:0x1C8
        if(((numPlayersOnTeam0 > 0) && somebodyAliveTeam0 == false) || (numPlayersOnTeam1 > 0) && somebodyAliveTeam1 == false)
        {
            GRI.SortTurokPRIs();
            I = 0;
            J0x14D:

            // End:0x1AF [Loop If]
            if(I < GRI.PRIArray.Length)
            {
                bestPlayerStillStanding = GRI.PRIArray[I];
                // End:0x1A5
                if(!bestPlayerStillStanding.bOutOfLives)
                {
                    OnNoLivesLeft(bestPlayerStillStanding);
                    return true;
                }
                ++I;
                // [Loop Continue]
                goto J0x14D;
            }
            EndGame(none, "scorelimit");
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected function OnNoLivesLeft(@NULL BestRemainingPlayer)
{
    EndGame(BestRemainingPlayer, "lifelimit");
    //return;    
}

function bool CanSpectate(@NULL Viewer, @NULL ViewTarget)
{
    // End:0x17
    if(!super.CanSpectate(Viewer, ViewTarget))
    {
        return false;
    }
    // End:0x47
    if(SpectateTeamOnly)
    {
        return GameReplicationInfo.OnSameTeam(Viewer, ViewTarget.Owner);
    }
    return true;
    //return ReturnValue;    
}

exec function NetPrintScores()
{
    local int I;
    local @NULL TGRI, TTeamInfo;
    local string TempStr;

    super.NetPrintScores();
    TGRI = TurokTeamGameReplicationInfo(GameReplicationInfo);
    I = 0;
    J0x1D:

    // End:0x87 [Loop If]
    if(I < 2)
    {
        TTeamInfo = TurokTeamInfo(GameReplicationInfo.Teams[I]);
        // End:0x7D
        if(TGRI.mMaxTeamLives != 0)
        {
            TempStr = " Lives=" $ string(TTeamInfo.mNumLives);
        }
        ++I;
        // [Loop Continue]
        goto J0x1D;
    }
    //return;    
}

exec function NetPrintHostSettings()
{
    super.NetPrintHostSettings();
    //return;    
}

defaultproperties
{
    bTeamGame=true
    GameReplicationInfoClass=Class'TurokTeamGameReplicationInfo'
}