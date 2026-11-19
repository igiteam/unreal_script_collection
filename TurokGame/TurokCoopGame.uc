class TurokCoopGame extends TurokMPGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var private config float FriendlyFireScale;
var private config float TeamMateBoost;
var private config int LivesPerPlayer;
var private array mProgressVolumes;

event InitGame(string Options, out string ErrorMessage)
{
    super.InitGame(Options, ErrorMessage);
    // End:0xAD
    if(ErrorMessage == "")
    {
        TimeLimit = 0;
        GoalScore = 0;
        MaxLives = 0;
        RivalMode = false;
        FriendlyFireScorePenalty = 0.0000000;
        RespawnTime = default.RespawnTime;
        RespawnTime = FClamp(RespawnTime, 0.0000000, 60.0000000);
        FriendlyFireRespawnTimePenalty = default.FriendlyFireRespawnTimePenalty;
        FriendlyFireRespawnTimePenalty = FClamp(FriendlyFireRespawnTimePenalty, 0.0000000, 60.0000000);
        InventoryMovementPenalty = default.InventoryMovementPenalty;
        AllowGrenades = default.AllowGrenades;
        WeaponPickupRespawnTimeout = default.WeaponPickupRespawnTimeout;
    }
    //return;    
}

function InitGameReplicationInfo()
{
    local @NULL GRI, net;

    GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    super.InitGameReplicationInfo();
    GRI.bStopCountDown = true;
    GRI.mFriendlyFireScale = FriendlyFireScale;
    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0xB0
    if((net != none) && net.GetLobby() != none)
    {
        GRI.mMaxTeamLives = LivesPerPlayer * net.GetLobby().GetNumGamePlayers();        
    }
    else
    {
        GRI.mMaxTeamLives = LivesPerPlayer * 1;
    }
    //return;    
}

protected function LoadMultiplayerClasses()
{
    mPlayerWCPawn0Class = class<Pawn>(FindObject(PlayerWCPawn0ClassName, Class'Core.Class'));
    mPlayerWCPawn1Class = class<Pawn>(FindObject(PlayerWCPawn1ClassName, Class'Core.Class'));
    mPlayerWCPawn2Class = class<Pawn>(FindObject(PlayerWCPawn2ClassName, Class'Core.Class'));
    mPlayerWCPawn3Class = class<Pawn>(FindObject(PlayerWCPawn3ClassName, Class'Core.Class'));
    mGrenadeClass = class<TurokInventory>(FindObject(GrenadeClassName, Class'Core.Class'));
    //return;    
}

event PreBeginPlay()
{
    local @NULL TCI, V;

    super.PreBeginPlay();
    TCI = __NFUN_278__(Class'TurokCoopInfo');
    GameReplicationInfo.Teams[0] = TCI;
    TCI.Initialize(0);
    TCI = __NFUN_278__(Class'TurokCoopInfo');
    GameReplicationInfo.Teams[1] = TCI;
    TCI.Initialize(1);
    // End:0xA5
    foreach AllActors(Class'TurokProgressActionVolumeNative', V)
    {
        mProgressVolumes[mProgressVolumes.Length] = V;        
    }    
    //return;    
}

function StartMatch()
{
    local @NULL GRI, Team, net;
    local int I;

    GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x85
    if((net != none) && net.GetLobby() != none)
    {
        GRI.mMaxTeamLives = LivesPerPlayer * net.GetLobby().GetNumGamePlayers();        
    }
    else
    {
        GRI.mMaxTeamLives = LivesPerPlayer * NumPlayers;
    }
    Team = TurokCoopInfo(GRI.Teams[0]);
    Team.SetDefaultSpawnTarget();
    super.StartMatch();
    I = 0;
    J0xDB:

    // End:0x10E [Loop If]
    if(I < mProgressVolumes.Length)
    {
        mProgressVolumes[I].NotifyMatchStarted();
        ++I;
        // [Loop Continue]
        goto J0xDB;
    }
    //return;    
}

protected function bool CheckMinimumPlayers(@NULL ExitingController)
{
    local @NULL net;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x52
    if((net != none) && net.GetLobby() != none)
    {
        return net.GetLobby().CheckMinimumGamePlayers(true);
    }
    // End:0x63
    if(NumPlayers < MinimumPlayers)
    {
        return false;
    }
    return true;
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

function bool ChangeTeam(@NULL ctrl, int TeamIndex, bool createTeam)
{
    local @NULL NewTeam;

    // End:0xCD
    if((((ctrl != none) && ctrl.bIsPlayer) && ctrl.PlayerReplicationInfo != none) && ctrl.PlayerReplicationInfo.Team == none)
    {
        ctrl.StartSpot = none;
        TeamIndex = 0;
        NewTeam = TurokTeamInfo(GameReplicationInfo.Teams[TeamIndex]);
        // DebugMode: 0
        assert(NewTeam != none);
        NewTeam.AddToTeam(ctrl);
        return (LivesPerPlayer == 0) || NewTeam.mNumLives > 0;
    }
    // End:0xFC
    if(TurokAIControllerHumanNpc(ctrl) != none)
    {
        TurokAIControllerHumanNpc(ctrl).SetTeamNum(TeamIndex);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function byte PickTeam(byte TeamIndex, @NULL C)
{
    return 0;
    //return ReturnValue;    
}

function float RatePlayerStart(@NULL P, byte Team, @NULL Player)
{
    local @NULL TP, SpawnTarget;

    SpawnTarget = TurokTeamInfo(GameReplicationInfo.Teams[int(Team)]).GetSpawnTarget();
    // End:0x40
    if(SpawnTarget == none)
    {
        return 0.0000000;
    }
    TP = TurokMPPlayerStart(P);
    // End:0x84
    if((TP == none) || int(TP.GetTeamNum()) != int(Team))
    {
        return 0.0000000;
    }
    // End:0xA7
    if(TP.GetSpawnTarget() != SpawnTarget)
    {
        return 0.0000000;
    }
    return super.RatePlayerStart(P, Team, Player);
    //return ReturnValue;    
}

function CaptureGoal(int TeamID, @NULL Scorer, @NULL goalInfo)
{
    local int I;
    local @NULL TGI, GRI;

    GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    TGI = TurokTeamGoalInfo(goalInfo);
    // End:0x2A9
    if(TGI != none)
    {
        switch(TGI.GetCoopTeamGoalType())
        {
            // End:0x16C
            case 1:
                switch(TeamID)
                {
                    // End:0x161
                    case 0:
                        // End:0xE6
                        if(GRI.PRIArray.Length > 0)
                        {
                            I = 0;
                            J0x78:

                            // End:0xE6 [Loop If]
                            if(I < GRI.PRIArray.Length)
                            {
                                // End:0xDC
                                if(int(GRI.PRIArray[I].TeamIndex) == 0)
                                {
                                    GRI.PRIArray[I].Score += float(WinAssaultPoints);
                                }
                                ++I;
                                // [Loop Continue]
                                goto J0x78;
                            }
                        }
                        GRI.Teams[0].Score += 1.0000000;
                        // End:0x147
                        if(GRI.GetCurrentCoopGoalID() != GRI.GetFinalCoopGoalID())
                        {
                            GRI.SetNextCurrentCoopGoalID();                            
                        }
                        else
                        {
                            EndGame(none, "scorelimit");
                        }
                        // End:0x169
                        break;
                    // End:0xFFFF
                    default:
                        // DebugMode: 0
                        assert(false);
                        break;
                }
                // End:0x2A9
                break;
            // End:0x2A6
            case 2:
                switch(TeamID)
                {
                    // End:0x280
                    case 0:
                        // End:0x206
                        if(GRI.PRIArray.Length > 0)
                        {
                            I = 0;
                            J0x198:

                            // End:0x206 [Loop If]
                            if(I < GRI.PRIArray.Length)
                            {
                                // End:0x1FC
                                if(int(GRI.PRIArray[I].TeamIndex) == 0)
                                {
                                    GRI.PRIArray[I].Score += float(WinDefensePoints);
                                }
                                ++I;
                                // [Loop Continue]
                                goto J0x198;
                            }
                        }
                        GRI.Teams[0].Score += 1.0000000;
                        // End:0x267
                        if(GRI.GetCurrentCoopGoalID() != GRI.GetFinalCoopGoalID())
                        {
                            GRI.SetNextCurrentCoopGoalID();                            
                        }
                        else
                        {
                            EndGame(none, "timelimit");
                        }
                        // End:0x2A6
                        break;
                    // End:0x29E
                    case 1:
                        EndGame(none, "scorelimit");
                        // End:0x2A6
                        break;
                    // End:0xFFFF
                    default:
                        // DebugMode: 0
                        assert(false);
                        break;
                }
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function ReleaseGoal(int TeamID, @NULL goalInfo)
{
    // End:0x58
    if(TeamID == 0)
    {
        GameReplicationInfo.Teams[0].NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        GameReplicationInfo.Teams[0].Score -= 1.0000000;
    }
    //return;    
}

function bool CheckScore(@NULL Scorer)
{
    return false;
    //return ReturnValue;    
}

protected function bool CheckLives()
{
    local int I;
    local @NULL GRI;

    GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    // End:0xAF
    if(GRI.PRIArray.Length > 0)
    {
        I = 0;
        J0x38:

        // End:0x7E [Loop If]
        if((I < GRI.PRIArray.Length) && GRI.PRIArray[I].bOutOfLives)
        {
            ++I;
            // [Loop Continue]
            goto J0x38;
        }
        // End:0xAF
        if(I == GRI.PRIArray.Length)
        {
            EndGame(none, "lifelimit");
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected function OnTimeOut()
{
    local @NULL TGI, GRI;

    GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
    TGI = GRI.GetCurrentCoopGoal();
    // End:0x67
    if((TGI != none) && int(TGI.GetCoopTeamGoalType()) == int(2))
    {
        TGI.OnGameTimeOut();
    }
    //return;    
}

function Killed(@NULL Killer, @NULL Victim, @NULL victimPawn, class<Class> DamageType)
{
    local @NULL TCI, PRI, GRI;

    // End:0x27
    if(Victim == none)
    {
        super.Killed(Killer, Victim, victimPawn, DamageType);
        return;
    }
    // End:0x1EF
    if((AllowKillScoreUpdate(DamageType)) && Victim != none)
    {
        // End:0xE4
        if(Victim.PlayerReplicationInfo != none)
        {
            TCI = TurokCoopInfo(Victim.PlayerReplicationInfo.Team);
            GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
            // End:0xE4
            if(GRI.mMaxTeamLives > 0)
            {
                // End:0xD1
                if(TCI.mNumLives == 0)
                {
                    Victim.PlayerReplicationInfo.bOutOfLives = true;                    
                }
                else
                {
                    TCI.DecrementNumberOfLives();
                }
            }
        }
        // End:0x130
        if((Killer == none) || Killer == Victim)
        {
            // End:0x130
            if(Victim.PlayerReplicationInfo != none)
            {
                Victim.PlayerReplicationInfo.Score -= float(1);
            }
        }
        // End:0x1EF
        if(Killer != none)
        {
            PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
            // End:0x1AB
            if(PRI != none)
            {
                // End:0x1A8
                if(!GameReplicationInfo.OnSameTeam(Killer, Victim))
                {
                    PRI.Score += float(KillAIInCoopPoints);
                    PRI.Kills++;
                }                
            }
            else
            {
                // End:0x1EF
                if(!Killer.bIsPlayer)
                {
                    // End:0x1EF
                    if(Victim.PlayerReplicationInfo != none)
                    {
                        Victim.PlayerReplicationInfo.Score -= float(1);
                    }
                }
            }
        }
    }
    super.Killed(Killer, Victim, victimPawn, DamageType);
    //return;    
}

function ReduceDamage(out int Damage, @NULL injured, @NULL InstigatedBy, @NULL HitLocation, out @NULL Momentum, class<Class> DamageType)
{
    local int instigatorTeam;

    // End:0x12C
    if(((InstigatedBy != none) && InstigatedBy != injured.Controller) && (injured.DrivenVehicle == none) || InstigatedBy.Pawn != injured.DrivenVehicle)
    {
        // End:0x90
        if(InstigatedBy.Pawn == none)
        {
            instigatorTeam = int(InstigatedBy.GetTeamNum());            
        }
        else
        {
            instigatorTeam = int(InstigatedBy.Pawn.GetTeamNum());
        }
        // End:0x12C
        if((((DamageType == none) || int(DamageType.default.mReactionType) != int(2)) && instigatorTeam != 255) && instigatorTeam == int(injured.GetTeamNum()))
        {
            Damage *= FriendlyFireScale;
            // End:0x12C
            if(DamageType != none)
            {
                Momentum *= TeamMateBoost;
            }
        }
    }
    // End:0x15B
    if(Damage > 0)
    {
        super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    //return;    
}

state GameInProgress
{
    function BeginState(name PreviousStateName)
    {
        local @NULL TCI, GRI;

        GRI = TurokCoopGameReplicationInfo(GameReplicationInfo);
        // End:0x65
        if(GRI.GetCurrentCoopGoalID() == -1)
        {
            TCI = TurokCoopInfo(GameReplicationInfo.Teams[0]);
            TCI.mNumLives = GRI.mMaxTeamLives;
        }
        GRI.InitCurrentCoopGoalID();
        mAccumulatedDT = 0.0000000;
        //return;        
    }
    stop;    
}

defaultproperties
{
    bTeamGame=true
    HUDType=Class'TurokCoopGameHud'
    GameReplicationInfoClass=Class'TurokCoopGameReplicationInfo'
}