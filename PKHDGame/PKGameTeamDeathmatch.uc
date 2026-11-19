class PKGameTeamDeathmatch extends PKGameDeathmatch
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var globalconfig bool bPlayersBalanceTeams;
var config bool bAllowNonTeamChat;
var bool bScoreTeamKills;
var bool bSpawnInTeamArea;
var bool bScoreVictimsTarget;
var bool bForceAllRed;
var float FriendlyFireScale;
var float TeammateBoost;
var string TeamFactions[2];
var class<LocalMessage> TeamScoreMessageClass;
var name FlagKillMessageName;

function PreBeginPlay()
{
    super.PreBeginPlay();
    CreateTeam(0);
    CreateTeam(1);
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local Actor A;

    super(PKGameMP_Base).PostLogin(NewPlayer);
    // End:0x42
    if(LocalPlayer(NewPlayer.Player) == none)
    {
        return;
    }
    // End:0x7B
    foreach AllActors(Class'Engine.Actor', A)
    {
        A.NotifyLocalPlayerTeamReceived();        
    }    
    //return;    
}

function int GetHandicapNeed(Pawn Other)
{
    local int ScoreDiff;

    // End:0x61
    if((Other.PlayerReplicationInfo == none) || Other.PlayerReplicationInfo.Team == none)
    {
        return 0;
    }
    ScoreDiff = int(Teams[1 - Other.PlayerReplicationInfo.Team.TeamIndex].Score - Other.PlayerReplicationInfo.Team.Score);
    // End:0x133
    if(ScoreDiff < 5)
    {
        return 0;
    }
    return ScoreDiff / 5;
    //return ReturnValue;    
}

function int LevelRecommendedPlayers()
{
    local UTMapInfo MapInfo;
    local int Num;

    MapInfo = UTMapInfo(WorldInfo.GetMapInfo());
    // End:0xB2
    if(MapInfo != none)
    {
        Num = Min(16, (MapInfo.RecommendedPlayersMax + MapInfo.RecommendedPlayersMin) / 2);
        // End:0xAF
        if((Num % 2) != 0)
        {
            Num++;
        }        
    }
    else
    {
        Num = 1;
    }
    return Num;
    //return ReturnValue;    
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
    local Controller C;
    local PlayerReplicationInfo Living;
    local bool bNoneLeft;

    // End:0x27D
    if(MaxLives > 0)
    {
        // End:0x57
        if((Scorer != none) && !Scorer.bOutOfLives)
        {
            Living = Scorer;
        }
        bNoneLeft = true;
        // End:0x223
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x222
            if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && !C.PlayerReplicationInfo.bOutOfLives) && !C.PlayerReplicationInfo.bOnlySpectator)
            {
                // End:0x18F
                if(Living == none)
                {
                    Living = C.PlayerReplicationInfo;
                    // End:0x222
                    continue;
                }
                // End:0x222
                if((C.PlayerReplicationInfo != Living) && C.PlayerReplicationInfo.Team != Living.Team)
                {
                    bNoneLeft = false;
                    // End:0x223
                    break;
                }
            }            
        }        
        // End:0x27D
        if(bNoneLeft)
        {
            // End:0x25F
            if(Living != none)
            {
                EndGame(Living, "LastMan");                
            }
            else
            {
                EndGame(Scorer, "LastMan");
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super(PKGameMP_Base).InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "AllRed");
    // End:0x5D
    if(InOpt != "")
    {
        bForceAllRed = true;
    }
    InOpt = ParseOption(Options, "BalanceTeams");
    // End:0xAE
    if(InOpt != "")
    {
        bPlayersBalanceTeams = bool(InOpt);
    }
    TeamFactions[0] = ParseOption(Options, "RedFaction");
    TeamFactions[1] = ParseOption(Options, "BlueFaction");
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0xE8
    if(bOverTime)
    {
        // End:0x29
        if((NumBots + NumPlayers) == 0)
        {
            return true;
        }
        bLastMan = true;
        // End:0xD8
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0xD7
            if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                bLastMan = false;
                // End:0xD8
                break;
            }            
        }        
        // End:0xE8
        if(bLastMan)
        {
            return true;
        }
    }
    bLastMan = Reason ~= "LastMan";
    // End:0x139
    if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x1C3
    if(bTeamScoreRounds)
    {
        // End:0x1C3
        if(Winner != none)
        {
            Winner.Team.Score += float(1);
            Winner.Team.bForceNetUpdate = true;
        }
    }
    // End:0x210
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x282
        if(Teams[1].Score > Teams[0].Score)
        {
            GameReplicationInfo.Winner = Teams[1];            
        }
        else
        {
            GameReplicationInfo.Winner = Teams[0];
        }
    }
    // End:0x3FE
    if(Winner == none)
    {
        // End:0x3FD
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x3FC
            if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) && (Winner == none) || P.PlayerReplicationInfo.Score > Winner.Score)
            {
                Winner = P.PlayerReplicationInfo;
            }            
        }        
    }
    EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;

    // End:0x55
    if(Winner != none)
    {
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x85
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0x15B
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    //return;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0x35
    if((ViewTarget == none) || ViewTarget.bOnlySpectator)
    {
        return false;
    }
    return Viewer.PlayerReplicationInfo.bOnlySpectator || ViewTarget.Team == Viewer.PlayerReplicationInfo.Team;
    //return ReturnValue;    
}

function RestartGame()
{
    local PlayerController PC;
    local int RedCount, BlueCount, MoveCount, I;
    local array<PlayerController> redPlayers, bluePlayers;

    // End:0x30C
    if(bPlayersBalanceTeams && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x1BD
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x1BC
            if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.Team != none)
            {
                // End:0x145
                if(PC.PlayerReplicationInfo.Team.TeamIndex == 0)
                {
                    RedCount++;
                    redPlayers[redPlayers.Length] = PC;
                    // End:0x1BC
                    continue;
                }
                // End:0x1BC
                if(PC.PlayerReplicationInfo.Team.TeamIndex == 1)
                {
                    BlueCount++;
                    bluePlayers[bluePlayers.Length] = PC;
                }
            }            
        }        
        // End:0x30C
        if(Abs(float(RedCount - BlueCount)) > float(1))
        {
            // End:0x282
            if(RedCount > BlueCount)
            {
                MoveCount = (RedCount - BlueCount) / 2;
                I = 0;
                J0x222:

                // End:0x27F [Loop If]
                if(I < MoveCount)
                {
                    SetTeam(redPlayers[(redPlayers.Length - I) - 1], Teams[1], false);
                    I++;
                    // [Loop Continue]
                    goto J0x222;
                }                
            }
            else
            {
                MoveCount = (BlueCount - RedCount) / 2;
                I = 0;
                J0x2AF:

                // End:0x30C [Loop If]
                if(I < MoveCount)
                {
                    SetTeam(bluePlayers[(bluePlayers.Length - I) - 1], Teams[0], false);
                    I++;
                    // [Loop Continue]
                    goto J0x2AF;
                }
            }
        }
    }
    super(PKGameMP_Base).RestartGame();
    //return;    
}

function byte PickTeam(byte Num, Controller C)
{
    local PKTeamInfo SmallTeam, BigTeam, NewTeam;

    SmallTeam = PKTeamInfo(Teams[0]);
    BigTeam = PKTeamInfo(Teams[1]);
    // End:0xB9
    if(SmallTeam.Size > BigTeam.Size)
    {
        SmallTeam = PKTeamInfo(Teams[1]);
        BigTeam = PKTeamInfo(Teams[0]);
    }
    // End:0xF5
    if(int(Num) < int(2))
    {
        NewTeam = PKTeamInfo(Teams[int(Num)]);
    }
    // End:0x11A
    if(NewTeam == none)
    {
        NewTeam = SmallTeam;        
    }
    else
    {
        // End:0x2B0
        if((int(WorldInfo.NetMode) != int(NM_Standalone)) && PlayerController(C) != none)
        {
            // End:0x1B4
            if(SmallTeam.Size < BigTeam.Size)
            {
                NewTeam = SmallTeam;                
            }
            else
            {
                // End:0x20B
                if(BigTeam.Size < SmallTeam.Size)
                {
                    NewTeam = BigTeam;                    
                }
                else
                {
                    // End:0x2B0
                    if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.Team != none)
                    {
                        NewTeam = PKTeamInfo(C.PlayerReplicationInfo.Team);
                    }
                }
            }
        }
    }
    return byte(NewTeam.TeamIndex);
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    local PKTeamInfo NewTeam, PendingTeam;

    // End:0x33
    if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
    {
        return false;
    }
    // End:0xC6
    if(Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator)
    {
        Other.PlayerReplicationInfo.Team = none;
        return true;
    }
    NewTeam = ((Num < 255) ? PKTeamInfo(Teams[int(PickTeam(byte(Num), Other))]) : none);
    // End:0x433
    if(Other.PlayerReplicationInfo.Team == NewTeam)
    {
        // End:0x431
        if((((Num < 2) && Num != NewTeam.TeamIndex) && PlayerController(Other) != none) && PKTeamInfo(Other.PlayerReplicationInfo.Team) != none)
        {
            // End:0x3ED
            if(PendingTeamSwap != none)
            {
                // End:0x267
                if(PendingTeamSwap.bDeleteMe || (WorldInfo.TimeSeconds - SwapRequestTime) > 8.0000000)
                {
                    PendingTeamSwap = none;                    
                }
                else
                {
                    // End:0x3ED
                    if(PendingTeamSwap.PlayerReplicationInfo.Team.TeamIndex == Num)
                    {
                        PendingTeam = PKTeamInfo(PendingTeamSwap.PlayerReplicationInfo.Team);
                        // End:0x3ED
                        if(PendingTeam != none)
                        {
                            SetTeam(PendingTeamSwap, PKTeamInfo(Other.PlayerReplicationInfo.Team), true);
                            // End:0x3BA
                            if(PendingTeamSwap.Pawn != none)
                            {
                                PendingTeamSwap.Pawn.PlayerChangedTeam();
                            }
                            PendingTeamSwap = none;
                            SetTeam(Other, PendingTeam, bNewTeam);
                            return true;
                        }
                    }
                }
            }
            PendingTeamSwap = PlayerController(Other);
            SwapRequestTime = WorldInfo.TimeSeconds;
        }
        return false;
    }
    SetTeam(Other, NewTeam, bNewTeam);
    return true;
    //return ReturnValue;    
}

function SetTeam(Controller Other, EvilTeamInfo NewTeam, bool bNewTeam)
{
    local Actor A;

    // End:0x26
    if(Other.PlayerReplicationInfo == none)
    {
        return;
    }
    // End:0x99
    if((Other.PlayerReplicationInfo.Team != none) || !ShouldSpawnAtStartSpot(Other))
    {
        Other.StartSpot = none;
    }
    // End:0x159
    if(Other.PlayerReplicationInfo.Team != none)
    {
        Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
        Other.PlayerReplicationInfo.Team = none;
    }
    // End:0x266
    if((NewTeam == none) || (NewTeam != none) && NewTeam.AddToTeam(Other))
    {
        // End:0x266
        if((NewTeam != none) && ((int(WorldInfo.NetMode) != int(NM_Standalone)) || PlayerController(Other) == none) || PlayerController(Other).Player != none)
        {
            BroadcastLocalizedMessage(GameMessageClass, 3, Other.PlayerReplicationInfo, none, NewTeam);
        }
    }
    UpdateGameplayMuteList(PlayerController(Other));
    // End:0x30C
    if((PlayerController(Other) != none) && LocalPlayer(PlayerController(Other).Player) != none)
    {
        // End:0x30B
        foreach AllActors(Class'Engine.Actor', A)
        {
            A.NotifyLocalPlayerTeamReceived();            
        }        
    }
    //return;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Rating;

    Rating = super(PKGameMP_Base).RatePlayerStart(P, Team, Player);
    // End:0x9B
    if(P.TeamIndex != 255)
    {
        Rating += float(9 * ((int(Team) == P.TeamIndex) ? 1 : -1));
    }
    return Rating;
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x1B
    if(CheckMaxLives(Scorer))
    {
        return false;        
    }
    else
    {
        // End:0x51
        if((!bOverTime && GoalScore == 0) || Scorer == none)
        {
            return false;            
        }
        else
        {
            // End:0xE2
            if((Scorer.Team != none) && Scorer.Team.Score >= float(GoalScore))
            {
                EndGame(Scorer, "teamscorelimit");
                return true;                
            }
            else
            {
                // End:0x112
                if(bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;                    
                }
                else
                {
                    // End:0x471
                    if(bScoreDeaths && GoalScore > 0)
                    {
                        // End:0x24C
                        if(Scorer.Team.Score == float(GoalScore - 10))
                        {
                            // End:0x249
                            if(!bPlayedTenKills && GoalScore > 19)
                            {
                                // End:0x249
                                if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                {
                                    bPlayedTenKills = true;
                                    BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 0);
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x368
                            if(Scorer.Team.Score == float(GoalScore - 5))
                            {
                                // End:0x365
                                if(!bPlayedFiveKills && GoalScore > 9)
                                {
                                    // End:0x365
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedFiveKills = true;
                                        BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 1);
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0x471
                                if((Scorer.Team.Score == float(GoalScore - 1)) && !bPlayedOneKill)
                                {
                                    // End:0x471
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedOneKill = true;
                                        BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 2);
                                    }
                                }
                            }
                        }
                    }
                    return false;
                }
            }
        }
    }
    //return ReturnValue;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    super(PKGameMP_Base).EndGame(Winner, Reason);
    //return;    
}

function Pawn FindVictimsTarget(Controller Other)
{
    local Vector Start, X, Y, Z;
    local float Dist, Aim;
    local Actor Target;

    // End:0x72
    if(((Other == none) || Other.Pawn == none) || Other.Pawn.Weapon == none)
    {
        return none;
    }
    GetAxes(Other.Pawn.GetViewRotation(), X, Y, Z);
    Start = Other.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Other.Pawn.BaseEyeHeight);
    Aim = 0.9700000;
    Target = Other.PickTarget(Class'Engine.Pawn', Aim, Dist, X, Start, 4000.0000000);
    return Pawn(Target);
    //return ReturnValue;    
}

function bool NearGoal(Controller C)
{
    return false;
    //return ReturnValue;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local Pawn Target;
    local PainPRI KillerPRI, OtherPRI, TargetPRI;

    // End:0x11C
    if(!Other.bIsPlayer || (Killer != none) && !Killer.bIsPlayer || Killer.PlayerReplicationInfo == none)
    {
        super.ScoreKill(Killer, Other);
        // End:0x11A
        if(((!bScoreTeamKills && Killer != none) && Killer.bIsPlayer) && MaxLives > 0)
        {
            CheckScore(Killer.PlayerReplicationInfo);
        }
        return;
    }
    // End:0x59C
    if(((Killer == none) || Killer == Other) || Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)
    {
        // End:0x57D
        if(Killer != none)
        {
            KillerPRI = PainPRI(Killer.PlayerReplicationInfo);
            OtherPRI = PainPRI(Other.PlayerReplicationInfo);
            // End:0x57D
            if(KillerPRI.Team != OtherPRI.Team)
            {
                // End:0x2CE
                if(OtherPRI.bHasFlag)
                {
                    OtherPRI.GetFlag().bLastSecondSave = NearGoal(Other);
                }
                // End:0x417
                if(OtherPRI.bHasFlag)
                {
                    // End:0x33D
                    if(NearGoal(Other))
                    {
                        OtherPRI.GetFlag().bLastSecondSave = true;
                    }
                    // End:0x417
                    if(OtherPRI != none)
                    {
                        KillerPRI.Score += float(2);
                        KillerPRI.bForceNetUpdate = true;
                        KillerPRI.IncrementEventStat('EVENT_KILLEDFLAGCARRIER');
                        // End:0x3FB
                        if(PKPlayerController(Killer) != none)
                        {
                            PKPlayerController(Killer).ClientMusicEvent(6);
                        }
                        SendFlagKillMessage(Killer, KillerPRI);
                    }
                }
                // End:0x57D
                if(bScoreVictimsTarget)
                {
                    Target = FindVictimsTarget(Other);
                    TargetPRI = ((Target != none) ? PainPRI(Target.PlayerReplicationInfo) : none);
                    // End:0x57D
                    if(((TargetPRI != none) && TargetPRI.bHasFlag) && TargetPRI.Team == Killer.PlayerReplicationInfo.Team)
                    {
                        Killer.PlayerReplicationInfo.Score += float(1);
                        Killer.PlayerReplicationInfo.bForceNetUpdate = true;
                    }
                }
            }
        }
        super.ScoreKill(Killer, Other);        
    }
    else
    {
        ModifyScoreKill(Killer, Other);
    }
    // End:0x782
    if(!bScoreTeamKills)
    {
        // End:0x738
        if(((((Other.bIsPlayer && Killer != none) && Killer.bIsPlayer) && Killer != Other) && Killer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
        {
            Killer.PlayerReplicationInfo.Score -= float(1);
            Killer.PlayerReplicationInfo.bForceNetUpdate = true;
        }
        // End:0x780
        if((MaxLives > 0) && Killer != none)
        {
            CheckScore(Killer.PlayerReplicationInfo);
        }
        return;
    }
    // End:0xAAE
    if(Other.bIsPlayer)
    {
        // End:0x8AA
        if(Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)
        {
            Killer.PlayerReplicationInfo.Team.Score += float(1);
            Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;            
        }
        else
        {
            // End:0x9C1
            if(FriendlyFireScale > float(0))
            {
                Killer.PlayerReplicationInfo.bForceNetUpdate = true;
                Killer.PlayerReplicationInfo.Score -= float(1);
                Killer.PlayerReplicationInfo.Team.Score -= float(1);
                Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
            }
        }
        // End:0xAAE
        if(PainGRI(GameReplicationInfo).bStoryMode && (PlayerController(Killer) != none) || PlayerController(Other) != none)
        {
            // End:0xA67
            if(AIController(Killer) != none)
            {
                AdjustSkill(AIController(Killer), PlayerController(Other), false);
            }
            // End:0xAAE
            if(AIController(Other) != none)
            {
                AdjustSkill(AIController(Other), PlayerController(Killer), true);
            }
        }
    }
    // End:0xAF4
    if((Killer != none) && bScoreTeamKills)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    //return;    
}

function AdjustSkill(AIController B, PlayerController P, bool bWinner)
{
    local float AdjustmentFactor;

    AdjustmentFactor = 0.1500000;
    // End:0x19F
    if(bWinner)
    {
        PlayerKills += 1;
        // End:0x177
        if((Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Score > (Teams[P.PlayerReplicationInfo.Team.TeamIndex].Score + float(1))) && Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Size > 1)
        {
            return;
        }
        AdjustedDifficulty = FMin(7.0000000, AdjustedDifficulty + AdjustmentFactor);        
    }
    else
    {
        PlayerDeaths += 1;
        // End:0x283
        if(Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Score <= Teams[P.PlayerReplicationInfo.Team.TeamIndex].Score)
        {
            return;
        }
        AdjustedDifficulty = FMax(0.0000000, AdjustedDifficulty - AdjustmentFactor);
    }
    AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.2500000, GameDifficulty + 1.2500000);
    //return;    
}

function SendFlagKillMessage(Controller Killer, PainPRI KillerPRI)
{
    // End:0x49
    if((PKPlayerController(Killer) != none) && !PKPlayerController(Killer).bAutoTaunt)
    {
        return;
    }
    Killer.SendMessage(none, FlagKillMessageName, 10.0000000, none);
    //return;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    local int InjuredTeam, InstigatorTeam;
    local class<EvilDmgType_Base> UTDamageType;
    local PKPlayerController PC;

    // End:0x5A
    if(InstigatedBy == none)
    {
        super(PKGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
        return;
    }
    InjuredTeam = int(injured.GetTeamNum());
    InstigatorTeam = int(InstigatedBy.GetTeamNum());
    // End:0x622
    if((InstigatedBy != injured.Controller) && (injured.DrivenVehicle == none) || InstigatedBy.Pawn != injured.DrivenVehicle)
    {
        // End:0x622
        if((InjuredTeam != 255) && InstigatorTeam != 255)
        {
            // End:0x522
            if(InjuredTeam == InstigatorTeam)
            {
                Momentum *= TeammateBoost;
                // End:0x4A2
                if(InstigatedBy.PlayerReplicationInfo != none)
                {
                    PC = PKPlayerController(InstigatedBy);
                    // End:0x4A2
                    if(((PC != none) && PC.Pawn != none) && (WorldInfo.TimeSeconds - PC.LastFriendlyFireTime) > float(5))
                    {
                        // End:0x4A2
                        if((Vector(PC.Rotation) Dot Normal(injured.Location - PC.Pawn.Location)) > 0.9000000)
                        {
                            // End:0x4A2
                            if(((PC.ShotTarget == injured) || PC.ShotTarget == none) || WorldInfo.GRI.OnSameTeam(PC.ShotTarget, PC))
                            {
                                UTDamageType = class<EvilDmgType_Base>(DamageType);
                                // End:0x4A2
                                if((UTDamageType != none) && UTDamageType.default.bComplainFriendlyFire)
                                {
                                    // End:0x4A2
                                    if((PKPlayerController(injured.Controller) != none) && PKPlayerController(injured.Controller).bAutoTaunt)
                                    {
                                        injured.Controller.SendMessage(InstigatedBy.PlayerReplicationInfo, 'FRIENDLYFIRE', 12.0000000);
                                    }
                                }
                            }
                        }
                    }
                }
                // End:0x50B
                if(FriendlyFireScale == 0.0000000)
                {
                    Damage = 0;
                    super(PKGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
                    return;
                }
                Damage *= FriendlyFireScale;                
            }
            else
            {
                // End:0x622
                if(((!injured.IsHumanControlled() && injured.Controller != none) && PainPRI(injured.PlayerReplicationInfo) != none) && PainPRI(injured.PlayerReplicationInfo).bHasFlag)
                {
                    injured.Controller.SendMessage(none, 'injured', 15.0000000);
                }
            }
        }
    }
    super(PKGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    //return;    
}

function bool DominatingVictory()
{
    return ((Teams[0].Score == float(0)) || Teams[1].Score == float(0)) && (Teams[0].Score + Teams[1].Score) >= float(3);
    //return ReturnValue;    
}

function bool IsAWinner(PlayerController C)
{
    // End:0x26
    if(C.PlayerReplicationInfo == none)
    {
        return false;
    }
    return C.PlayerReplicationInfo.bOnlySpectator || IsWinningTeam(C.PlayerReplicationInfo.Team);
    //return ReturnValue;    
}

function bool IsWinningTeam(TeamInfo T)
{
    // End:0x5F
    if(Teams[0].Score > Teams[1].Score)
    {
        return T == Teams[0];        
    }
    else
    {
        return T == Teams[1];
    }
    //return ReturnValue;    
}

function PlayRegularEndOfMatchMessage()
{
    local PKPlayerController PC;
    local int Index;

    // End:0x54
    if(Teams[0].Score > Teams[1].Score)
    {
        Index = 4;        
    }
    else
    {
        Index = 5;
    }
    // End:0xC8
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ClientPlayAnnouncement(VictoryMessageClass, Index);        
    }    
    //return;    
}

function AnnounceScore(int ScoringTeam)
{
    local PKPlayerController PC;
    local int OtherTeam, MessageIndex;

    // End:0x11
    if(TeamScoreMessageClass == none)
    {
        return;
    }
    OtherTeam = 1 - ScoringTeam;
    // End:0x9B
    if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(1)))
    {
        MessageIndex = 4 + ScoringTeam;        
    }
    else
    {
        // End:0x110
        if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(2)))
        {
            MessageIndex = 2 + ScoringTeam;            
        }
        else
        {
            MessageIndex = ScoringTeam;
        }
    }
    // End:0x18C
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ReceiveLocalizedMessage(TeamScoreMessageClass, MessageIndex);        
    }    
    //return;    
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
    local PKTeamInfo DesiredTeam;
    local int ActualTeamIndex;

    DesiredTeam = PKTeamInfo(PC.PlayerReplicationInfo.Team);
    PC.PlayerReplicationInfo.OverrideWith(OldPRI);
    // End:0x186
    if((DesiredTeam != PC.PlayerReplicationInfo.Team) && DesiredTeam != none)
    {
        ActualTeamIndex = int(PickTeam(byte(DesiredTeam.TeamIndex), PC));
        // End:0x186
        if(PC.PlayerReplicationInfo.Team != Teams[ActualTeamIndex])
        {
            SetTeam(PC, Teams[ActualTeamIndex], true);
        }
    }
    //return;    
}

function bool AllowClientToTeleport(EvilPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
    return GameReplicationInfo.OnSameTeam(ClientPRI, DestinationActor);
    //return ReturnValue;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    local int I;

    super(EvilGame).GetSeamlessTravelActorList(bToEntry, ActorList);
    I = 0;
    J0x28:

    // End:0x176 [Loop If]
    if(I < WorldInfo.GRI.Teams.Length)
    {
        // End:0x168
        if((WorldInfo.GRI.Teams[I] != none) && bToEntry || WorldInfo.GRI.Teams[I].Size > 0)
        {
            ActorList[ActorList.Length] = WorldInfo.GRI.Teams[I];
        }
        I++;
        // [Loop Continue]
        goto J0x28;
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local TeamInfo OldTeam;
    local int I;
    local bool bFound;

    // End:0x9A
    if(!WorldInfo.IsInSeamlessTravel() && Exiting.PlayerReplicationInfo.bFromPreviousLevel)
    {
        OldTeam = Exiting.PlayerReplicationInfo.Team;
    }
    super(PKGame).Logout(Exiting);
    // End:0x16A
    if((OldTeam != none) && OldTeam.Size <= 1)
    {
        I = 0;
        J0xED:

        // End:0x143 [Loop If]
        if(I < Teams.Length)
        {
            // End:0x135
            if(Teams[I] == OldTeam)
            {
                bFound = true;
                // [Explicit Break]
                goto J0x143;
            }
            I++;
            // [Loop Continue]
            goto J0xED;
        }
        J0x143:

        // End:0x16A
        if(!bFound)
        {
            OldTeam.Destroy();
        }
    }
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local TeamInfo NewTeam;

    // End:0x314
    if(C.PlayerReplicationInfo != none)
    {
        // End:0x2AC
        if((C.PlayerReplicationInfo.Team != none) && C.PlayerReplicationInfo.Team.TeamIndex < Teams.Length)
        {
            // End:0x2A9
            if(Teams[C.PlayerReplicationInfo.Team.TeamIndex] != C.PlayerReplicationInfo.Team)
            {
                NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
                // End:0x22F
                if(C.PlayerReplicationInfo.Team.Size <= 1)
                {
                    C.PlayerReplicationInfo.Team.Destroy();                    
                }
                else
                {
                    C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
                }
                NewTeam.AddToTeam(C);
            }            
        }
        else
        {
            // End:0x314
            if(!C.PlayerReplicationInfo.bOnlySpectator && AIController(C) == none)
            {
                ChangeTeam(C, 0, false);
            }
        }
    }
    super(EvilGame).HandleSeamlessTravelPlayer(C);
    //return;    
}

function SetControllersWinnerFlag(PlayerReplicationInfo Winner)
{
    local int WinnerTeamIndex, I;
    local PKPlayerController PKPC;
    local PainPRI PRI;
    local bool bIsCTFGame;
    local string MapName;

    MapName = Caps(WorldInfo.GetMapName(true));
    bIsCTFGame = default.Acronym == "CTF";
    WinnerTeamIndex = Winner.Team.TeamIndex;
    I = 0;
    J0x8F:

    // End:0x238 [Loop If]
    if(I < GameReplicationInfo.PRIArray.Length)
    {
        PRI = PainPRI(GameReplicationInfo.PRIArray[I]);
        PKPC = PKPlayerController(PRI.Owner);
        // End:0x20A
        if(PRI.Team.TeamIndex == WinnerTeamIndex)
        {
            PKPC.ClientSetWinnerOfTheMatch(true);
            // End:0x207
            if(bIsCTFGame && (MapName == "CTF-COMMUNITY2_HD_DLC_4") || MapName == "CTF-COMMUNITY2_DLC_4")
            {
                PKPC.ClientUnlockAchievement(75);
            }            
        }
        else
        {
            PKPC.ClientSetWinnerOfTheMatch(false);
        }
        I++;
        // [Loop Continue]
        goto J0x8F;
    }
    //return;    
}

function int GetVoiceChannel(PKPlayerController PC)
{
    local TeamInfo Team;

    Team = PC.PlayerReplicationInfo.Team;
    return (((Team != none) && Team.TeamIndex != 255) ? Team.TeamIndex + 1 : 0);
    //return ReturnValue;    
}

auto state PendingMatch
{
    ignores CheckLives, CheckScore, ScoreKill;

    function RestartPlayer(Controller aPlayer)
    {
        // End:0x3E
        if(UTGameReplicationInfo(GameReplicationInfo).bWarmupRound)
        {
            global.RestartPlayer(aPlayer);
        }
        //return;        
    }

    function Timer()
    {
        local PlayerController P;
        local bool bReady;
        local int numPlayersReady;

        global.Timer();
        bReady = true;
        numPlayersReady = 0;
        // End:0x1A1
        if(PainGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
        {
            // End:0x1A0
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                numPlayersReady++;
                // End:0x19F
                if(((P.PlayerReplicationInfo != none) && P.bIsPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
                {
                    // End:0x15E
                    if(!P.PlayerReplicationInfo.bOnlySpectator)
                    {
                        bReady = false;
                        numPlayersReady--;
                    }
                    // End:0x19F
                    if(PKPlayerController_MP(P) != none)
                    {
                        PKPlayerController_MP(P).ShowTeamPanel(true);
                    }
                }                
            }            
        }
        // End:0x2FE
        if(bReady && numPlayersReady >= 2)
        {
            // End:0x204
            if(PainGRI(GameReplicationInfo).CountdownTimer == 0)
            {
                PlayStartupMessage();
                StartMatch();                
            }
            else
            {
                // End:0x2FE
                if(PainGRI(GameReplicationInfo).CountdownTimer > 0)
                {
                    // End:0x2D5
                    if(!PainGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
                    {
                        // End:0x2D4
                        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
                        {
                            // End:0x2D3
                            if(PKPlayerController_MP(P) != none)
                            {
                                PKPlayerController_MP(P).ShowTeamPanel(true);
                            }                            
                        }                        
                    }
                    PainGRI(GameReplicationInfo).CountdownTimer--;
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        PainGRI(GameReplicationInfo).CountdownTimer = InitialCountdown;
        bWaitingToStartMatch = true;
        StartupStage = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        local PlayerController P;

        // End:0x76
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x75
            if(PKPlayerController_MP(P) != none)
            {
                PKPlayerController_MP(P).ShowTeamPanel(false);
            }            
        }        
        //return;        
    }
Begin:

    // End:0x6D
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_ListenServer)) && !IsConsoleDedicatedServer())
    {
        Sleep(0.0000000);
    }
    // End:0xB3
    if((DesiredPlayerCount <= 1) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bQuickStart = true;
    }
    // End:0x10A
    if(bQuickStart)
    {
        // End:0x100
        if(DemoPrefix != "")
        {            
            ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
        }
        StartMatch();
    }
    stop;        
}

defaultproperties
{
    bScoreTeamKills=true
    FriendlyFireScale=0.6000000
    TeammateBoost=0.3000000
    FlagKillMessageName="Taunt"
    bAllowFriendlyFire=true
    bMustHaveMultiplePlayers=true
    bIgnoreTeamForVoiceChat=false
    Acronym="TDM"
    MidgameScorePanelTag="TDMPanel"
    GameName="Team Deathmatch"
    GoalScore=30
    TimeLimit=10
    OnlineStatsWriteClass=Class'PKLeaderboardWriteTDM'
    OnlineGameSettingsClass=Class'PKGameTeamDeathMatchSettings'
}