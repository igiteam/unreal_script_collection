class SkyGame_Struggle extends SkyGame
    config(Game);

var transient bool bAutomatedTest;
var float AutomatedTestTime;
var config int KillBountyBonus;
var config int TeamKillBountyPenalty;
var config float BountyDecayTime;
var config float BountyDecayDelay;
var config int BountyDecayIncrement;
var config int MinBounty;
var config int KillRepBonus;
var config int AssistRepBonus;
var config int SabotageRepBonus;

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

    super.PostLogin(NewPlayer);
    // End:0x27
    if(LocalPlayer(NewPlayer.Player) == none)
    {
        return;
    }
    // End:0x5D
    if(NewPlayer.PlayerReplicationInfo != none)
    {
        NewPlayer.PlayerReplicationInfo.Score = float(MinBounty);
    }
    // End:0x82
    foreach AllActors(Class'Engine.Actor', A)
    {
        A.NotifyLocalPlayerTeamReceived();        
    }    
    //return;    
}

function CreateTeam(int TeamIndex)
{
    local class<SkyTeamInfo> RosterClass;

    // End:0x37
    if(CustomTeamName[TeamIndex] != "")
    {
        RosterClass = class<SkyTeamInfo>(DynamicLoadObject(CustomTeamName[TeamIndex], Class'Core.Class'));        
    }
    else
    {
        RosterClass = class<SkyTeamInfo>(DynamicLoadObject(DefaultEnemyRosterClass, Class'Core.Class'));
    }
    Teams[TeamIndex] = Spawn(RosterClass);
    Teams[TeamIndex].Initialize(int(0.5000000 * float(DesiredPlayerCount)));
    Teams[TeamIndex].TeamIndex = TeamIndex;
    GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
    //return;    
}

function SkyTeamInfo GetBotTeam(optional int TeamBots)
{
    return none;
    //return ReturnValue;    
}

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer)
{
    super.PrecacheGameAnnouncements(Announcer);
    default.TeamScoreMessageClass.static.PrecacheGameAnnouncements(Announcer, default.Class);
    //return;    
}

function int LevelRecommendedPlayers()
{
    return 8;
    //return ReturnValue;    
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
    local Controller C;
    local PlayerReplicationInfo Living;
    local bool bNoneLeft;

    // End:0x18A
    if(MaxLives > 0)
    {
        // End:0x38
        if((Scorer != none) && !Scorer.bOutOfLives)
        {
            Living = Scorer;
        }
        bNoneLeft = true;
        // End:0x140
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x13F
            if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && !C.PlayerReplicationInfo.bOutOfLives) && !C.PlayerReplicationInfo.bOnlySpectator)
            {
                // End:0xEC
                if(Living == none)
                {
                    Living = C.PlayerReplicationInfo;
                    // End:0x13F
                    continue;
                }
                // End:0x13F
                if((C.PlayerReplicationInfo != Living) && C.PlayerReplicationInfo.Team != Living.Team)
                {
                    bNoneLeft = false;
                    // End:0x140
                    break;
                }
            }            
        }        
        // End:0x18A
        if(bNoneLeft)
        {
            // End:0x170
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
    local class<SkyTeamAI> InType;

    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "RedAI");
    // End:0x6C
    if(InOpt != "")
    {
        InType = class<SkyTeamAI>(DynamicLoadObject(InOpt, Class'Core.Class'));
        // End:0x6C
        if(InType != none)
        {
            TeamAIType[0] = InType;
        }
    }
    InOpt = ParseOption(Options, "BlueAI");
    // End:0xC9
    if(InOpt != "")
    {
        InType = class<SkyTeamAI>(DynamicLoadObject(InOpt, Class'Core.Class'));
        // End:0xC9
        if(InType != none)
        {
            TeamAIType[1] = InType;
        }
    }
    InOpt = ParseOption(Options, "AllRed");
    // End:0xFA
    if(InOpt != "")
    {
        bForceAllRed = true;
    }
    CustomTeamName[0] = ParseOption(Options, "RedTeam");
    CustomTeamName[1] = ParseOption(Options, "BlueTeam");
    // End:0x1C8
    if((CustomTeamName[0] != "") || CustomTeamName[1] != "")
    {
        bCustomBots = true;
        // End:0x195
        if(CustomTeamName[0] == "")
        {
            CustomTeamName[0] = "SkyGame.SkySurvivorsTeamInfo";
        }
        // End:0x1C8
        if(CustomTeamName[1] == "")
        {
            CustomTeamName[1] = "SkyGame.SkyWatchersTeamInfo";
        }
    }
    InOpt = ParseOption(Options, "FF");
    // End:0x201
    if(InOpt != "")
    {
        FriendlyFireScale = FMin(1.0000000, float(InOpt));
    }
    InOpt = ParseOption(Options, "BalanceTeams");
    // End:0x23E
    if(InOpt != "")
    {
        bPlayersBalanceTeams = bool(InOpt);
    }
    InOpt = ParseOption(Options, "AutomatedTest");
    // End:0x2CD
    if(InOpt != "")
    {
        bAutomatedTest = true;
        InOpt = ParseOption(Options, "AutomatedTestTime");
        // End:0x2B7
        if(InOpt != "")
        {
            AutomatedTestTime = float(InOpt);
        }
        SetTimer(AutomatedTestTime, false, 'ExitAutomatedTest');        
    }
    //return;    
}

function bool TooManyBots(Controller botToRemove)
{
    return true;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller KilledPlayer, Pawn KilledPawn)
{
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0x90
    if(bOverTime)
    {
        // End:0x1D
        if((NumBots + NumPlayers) == 0)
        {
            return true;
        }
        bLastMan = true;
        // End:0x84
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x83
            if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                bLastMan = false;
                // End:0x84
                break;
            }            
        }        
        // End:0x90
        if(bLastMan)
        {
            return true;
        }
    }
    bLastMan = Reason ~= "LastMan";
    // End:0xCD
    if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x102
    if(bTeamScoreRounds)
    {
        // End:0xFF
        if(Winner != none)
        {
            Winner.Team.Score += float(1);
        }        
    }
    else
    {
        // End:0x15D
        if(!bLastMan && Teams[1].Score == Teams[0].Score)
        {
            // End:0x15B
            if(!bOverTimeBroadcast)
            {
                StartupStage = 7;
                PlayStartupMessage();
                bOverTimeBroadcast = true;
            }
            return false;
        }
    }
    // End:0x188
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x1C9
        if(Teams[1].Score > Teams[0].Score)
        {
            GameReplicationInfo.Winner = Teams[1];            
        }
        else
        {
            GameReplicationInfo.Winner = Teams[0];
        }
    }
    // End:0x29F
    if(Winner == none)
    {
        // End:0x29E
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x29D
            if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) && (Winner == none) || P.PlayerReplicationInfo.Score > Winner.Score)
            {
                Winner = P.PlayerReplicationInfo;
            }            
        }        
    }
    EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;

    // End:0x2F
    if(Winner != none)
    {
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x4C
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0xC4
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    //return;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0x22
    if((ViewTarget == none) || ViewTarget.bOnlySpectator)
    {
        return false;
    }
    return Viewer.PlayerReplicationInfo.bOnlySpectator || ViewTarget.Team == Viewer.PlayerReplicationInfo.Team;
    //return ReturnValue;    
}

function byte PickTeam(byte num, Controller C)
{
    local SkyTeamInfo SmallTeam, BigTeam, NewTeam;
    local Controller B;
    local int BigTeamBots, SmallTeamBots;

    // End:0x0C
    if(bForceAllRed)
    {
        return 0;
    }
    // End:0x47
    if(bPlayersVsBots && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x44
        if(PlayerController(C) != none)
        {
            return 1;
        }
        return 0;
    }
    SmallTeam = Teams[0];
    BigTeam = Teams[1];
    // End:0x9E
    if(SmallTeam.Size > BigTeam.Size)
    {
        SmallTeam = Teams[1];
        BigTeam = Teams[0];
    }
    // End:0xC1
    if(int(num) < int(2))
    {
        NewTeam = Teams[int(num)];
    }
    // End:0xDA
    if(NewTeam == none)
    {
        NewTeam = SmallTeam;        
    }
    else
    {
        // End:0x301
        if((bPlayersBalanceTeams && int(WorldInfo.NetMode) != int(NM_Standalone)) && PlayerController(C) != none)
        {
            // End:0x142
            if(SmallTeam.Size < BigTeam.Size)
            {
                NewTeam = SmallTeam;                
            }
            else
            {
                // End:0x1EB
                foreach WorldInfo.AllControllers(Class'Engine.Controller', B)
                {
                    // End:0x1EA
                    if((B.PlayerReplicationInfo != none) && B.PlayerReplicationInfo.bBot)
                    {
                        // End:0x1C0
                        if(B.PlayerReplicationInfo.Team == BigTeam)
                        {
                            BigTeamBots++;
                            // End:0x1EA
                            continue;
                        }
                        // End:0x1EA
                        if(B.PlayerReplicationInfo.Team == SmallTeam)
                        {
                            SmallTeamBots++;
                        }
                    }                    
                }                
                // End:0x28E
                if(BigTeamBots > 0)
                {
                    // End:0x236
                    if((SmallTeam.Size - SmallTeamBots) < (BigTeam.Size - BigTeamBots))
                    {
                        NewTeam = SmallTeam;                        
                    }
                    else
                    {
                        // End:0x275
                        if((BigTeam.Size - BigTeamBots) < (SmallTeam.Size - SmallTeamBots))
                        {
                            NewTeam = BigTeam;                            
                        }
                        else
                        {
                            // End:0x28B
                            if(SmallTeamBots == 0)
                            {
                                NewTeam = BigTeam;
                            }
                        }
                    }                    
                }
                else
                {
                    // End:0x2A7
                    if(SmallTeamBots > 0)
                    {
                        NewTeam = SmallTeam;                        
                    }
                    else
                    {
                        // End:0x301
                        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.Team != none)
                        {
                            NewTeam = SkyTeamInfo(C.PlayerReplicationInfo.Team);
                        }
                    }
                }
            }
        }
    }
    return byte(NewTeam.TeamIndex);
    //return ReturnValue;    
}

event BroadcastLocalizedTeam(int TeamIndex, Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;

    // End:0x72
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
    {
        // End:0x71
        if(P.PlayerReplicationInfo.Team == Sender)
        {
            P.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }        
    }    
    //return;    
}

function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
{
    local SkyTeamInfo NewTeam, PendingTeam;

    // End:0x20
    if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
    {
        return false;
    }
    // End:0x74
    if(Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator)
    {
        Other.PlayerReplicationInfo.Team = none;
        return true;
    }
    NewTeam = ((num < 255) ? Teams[int(PickTeam(byte(num), Other))] : none);
    // End:0x287
    if(Other.PlayerReplicationInfo.Team == NewTeam)
    {
        // End:0x285
        if(((((num < 2) && num != NewTeam.TeamIndex) && !bPlayersVsBots) && PlayerController(Other) != none) && SkyTeamInfo(Other.PlayerReplicationInfo.Team) != none)
        {
            // End:0x260
            if(PendingTeamSwap != none)
            {
                // End:0x180
                if(PendingTeamSwap.bDeleteMe || (WorldInfo.TimeSeconds - SwapRequestTime) > 8.0000000)
                {
                    PendingTeamSwap = none;                    
                }
                else
                {
                    // End:0x260
                    if(PendingTeamSwap.PlayerReplicationInfo.Team.TeamIndex == num)
                    {
                        PendingTeam = SkyTeamInfo(PendingTeamSwap.PlayerReplicationInfo.Team);
                        // End:0x260
                        if(PendingTeam != none)
                        {
                            SetTeam(PendingTeamSwap, SkyTeamInfo(Other.PlayerReplicationInfo.Team), true);
                            // End:0x23D
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

function SetTeam(Controller Other, SkyTeamInfo NewTeam, bool bNewTeam)
{
    local Actor A;

    Other.StartSpot = none;
    // End:0x78
    if(Other.PlayerReplicationInfo.Team != none)
    {
        Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
        Other.PlayerReplicationInfo.Team = none;
    }
    // End:0x1B2
    if((NewTeam == none) || (NewTeam != none) && NewTeam.AddToTeam(Other))
    {
        // End:0x129
        if((NewTeam != none) && ((int(WorldInfo.NetMode) != int(NM_Standalone)) || PlayerController(Other) == none) || PlayerController(Other).Player != none)
        {
            BroadcastLocalizedMessage(GameMessageClass, 3, Other.PlayerReplicationInfo, none, NewTeam);
        }
        // End:0x1B2
        if(bNewTeam && PlayerController(Other) != none)
        {
            GameEvent('TeamChange', NewTeam.TeamIndex, Other.PlayerReplicationInfo);
            // End:0x1B2
            if(SkyPawn_MP(Other.Pawn) != none)
            {
                SkyPawn_MP(Other.Pawn).NotifyTeamChanged();
            }
        }
    }
    // End:0x209
    if((PlayerController(Other) != none) && LocalPlayer(PlayerController(Other).Player) != none)
    {
        // End:0x208
        foreach AllActors(Class'Engine.Actor', A)
        {
            A.NotifyLocalPlayerTeamReceived();            
        }        
    }
    //return;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    // End:0x47
    if(bSpawnInTeamArea)
    {
        // End:0x1F
        if(SkyPlayerStart(P) == none)
        {
            return 0.5000000;
        }
        // End:0x47
        if(int(Team) != int(SkyPlayerStart(P).TeamNumber))
        {
            return 0.1000000;
        }
    }
    return super.RatePlayerStart(P, Team, Player);
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x17
    if(CheckMaxLives(Scorer))
    {
        return false;        
    }
    else
    {
        // End:0x2C
        if(!super(GameInfo).CheckScore(Scorer))
        {
            return false;            
        }
        else
        {
            // End:0x49
            if(!bOverTime && GoalScore == 0)
            {
                return false;                
            }
            else
            {
                // End:0xB6
                if(((Scorer != none) && Scorer.Team != none) && Scorer.Team.Score >= float(GoalScore))
                {
                    EndGame(Scorer, "teamscorelimit");
                    return true;                    
                }
                else
                {
                    // End:0xEB
                    if((Scorer != none) && bOverTime)
                    {
                        EndGame(Scorer, "timelimit");
                        return true;                        
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

function bool CriticalPlayer(Controller Other)
{
    // End:0x36
    if((Other.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo.bHasFlag)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pawn FindVictimsTarget(Controller Other)
{
    local Vector Start, X, Y, Z;
    local float Dist, Aim;
    local Actor Target;

    // End:0x45
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
    // End:0x18C
    if(((Killer != none) && Other != none) && int(Killer.GetTeamNum()) != int(Other.GetTeamNum()))
    {
        Killer.PlayerReplicationInfo.Score += float(KillBountyBonus);
        SkyPlayerReplicationInfo(Killer.PlayerReplicationInfo).ReputationPoints += KillRepBonus;
        // End:0x132
        if(Killer.PlayerReplicationInfo.Team != none)
        {
            TeamScoreChange(Killer.PlayerReplicationInfo, int(Other.PlayerReplicationInfo.Score), Other.PlayerReplicationInfo);
            Killer.PlayerReplicationInfo.Team.Score += Other.PlayerReplicationInfo.Score;
        }
        AnnounceBounty(Killer.PlayerReplicationInfo);
        Killer.SetTimer(BountyDecayDelay, false, 'DecayBounty');
        Other.PlayerReplicationInfo.Score = float(MinBounty);        
    }
    else
    {
        // End:0x22D
        if(Other != none)
        {
            // End:0x22D
            if(Other.PlayerReplicationInfo.Team != none)
            {
                TeamScoreChange(((Killer == none) ? Other.PlayerReplicationInfo : Killer.PlayerReplicationInfo), -TeamKillBountyPenalty, Other.PlayerReplicationInfo);
                Other.PlayerReplicationInfo.Team.Score -= float(TeamKillBountyPenalty);
            }
        }
    }
    // End:0x25C
    if((Killer != none) && bScoreTeamKills)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    //return;    
}

event ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    local int InjuredTeam, InstigatorTeam;

    // End:0x31
    if(InstigatedBy == none)
    {
        super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
        return;
    }
    InjuredTeam = int(injured.GetTeamNum());
    InstigatorTeam = int(InstigatedBy.GetTeamNum());
    // End:0x127
    if((InstigatedBy != injured.Controller) && (injured.DrivenVehicle == none) || InstigatedBy.Pawn != injured.DrivenVehicle)
    {
        // End:0x127
        if((InjuredTeam != 255) && InstigatorTeam != 255)
        {
            // End:0x127
            if(InjuredTeam == InstigatorTeam)
            {
                // End:0x103
                if(class<SkyDamageType>(DamageType) != none)
                {
                    Momentum *= TeammateBoost;
                }
                // End:0x11B
                if(FriendlyFireScale == 0.0000000)
                {
                    Damage = 0;
                    return;
                }
                Damage *= FriendlyFireScale;
            }
        }
    }
    super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    //return;    
}

function bool DominatingVictory()
{
    return ((Teams[0].Score == float(0)) || Teams[1].Score == float(0)) && (Teams[0].Score + Teams[1].Score) >= float(3);
    //return ReturnValue;    
}

function bool IsAWinner(PlayerController C)
{
    return C.PlayerReplicationInfo.bOnlySpectator || IsWinningTeam(C.PlayerReplicationInfo.Team);
    //return ReturnValue;    
}

function bool IsWinningTeam(TeamInfo T)
{
    // End:0x39
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
    local SkyPlayerController PC;
    local int Index;

    // End:0x32
    if(Teams[0].Score > Teams[1].Score)
    {
        Index = 4;        
    }
    else
    {
        Index = 5;
    }
    // End:0x79
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        PC.ClientSPlayAnnouncement(VictoryMessageClass, byte(Index));        
    }    
    //return;    
}

function AnnounceBounty(PlayerReplicationInfo PRI)
{
    local SkyPlayerController PC;

    // End:0x5B
    if(PRI != none)
    {
        // End:0x5A
        foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
        {
            PC.ReceiveLocalizedMessage(Class'SkyBountyMessage', int(PRI.Score), PRI);            
        }        
    }
    //return;    
}

function TeamScoreChange(PlayerReplicationInfo PRI, int change, Object Reason)
{
    local SkyPlayerController PC;

    // End:0x60
    if((PRI != none) && change != 0)
    {
        // End:0x5F
        foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
        {
            PC.ReceiveLocalizedMessage(TeamScoreMessageClass, change, PRI,, Reason);            
        }        
    }
    //return;    
}

function AnnounceScore(int ScoringTeam)
{
    local SkyPlayerController PC;
    local int OtherTeam, MessageIndex;

    OtherTeam = 1 - ScoringTeam;
    // End:0x54
    if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(1)))
    {
        MessageIndex = 4 + ScoringTeam;        
    }
    else
    {
        // End:0x9B
        if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(2)))
        {
            MessageIndex = 2 + ScoringTeam;            
        }
        else
        {
            MessageIndex = ScoringTeam;
        }
    }
    // End:0xE5
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        PC.ReceiveLocalizedMessage(TeamScoreMessageClass, MessageIndex);        
    }    
    //return;    
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
    local SkyTeamInfo DesiredTeam;

    DesiredTeam = SkyTeamInfo(PC.PlayerReplicationInfo.Team);
    PC.PlayerReplicationInfo.OverrideWith(OldPRI);
    // End:0x8C
    if((DesiredTeam != PC.PlayerReplicationInfo.Team) && DesiredTeam != none)
    {
        SetTeam(PC, DesiredTeam, true);
    }
    //return;    
}

function bool AllowClientToTeleport(SkyPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
    return GameReplicationInfo.OnSameTeam(ClientPRI, DestinationActor);
    //return ReturnValue;    
}

function ShowPathTo(PlayerController P, int TeamNum)
{
    //return;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    super(GameInfo).GetSeamlessTravelActorList(bToEntry, ActorList);
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[0];
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[1];
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local TeamInfo NewTeam;

    // End:0x155
    if(C.PlayerReplicationInfo != none)
    {
        // End:0x125
        if((C.PlayerReplicationInfo.Team != none) && C.PlayerReplicationInfo.Team.TeamIndex < 2)
        {
            NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
            // End:0xDC
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
        else
        {
            // End:0x155
            if(!C.PlayerReplicationInfo.bOnlySpectator)
            {
                ChangeTeam(C, 0, false);
            }
        }
    }
    super.HandleSeamlessTravelPlayer(C);
    //return;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.Class;
    //return ReturnValue;    
}

function ExitAutomatedTest()
{
    ConsoleCommand("EXIT");
    //return;    
}

event AddDefaultInventory(Pawn PlayerPawn)
{
    local int I;
    local bool bActivated;

    bActivated = false;
    // End:0xA0
    if(SkyPawn(PlayerPawn) == none)
    {
        I = 0;
        J0x1F:

        // End:0x9D [Loop If]
        if(I < DefaultInventory.Length)
        {
            // End:0x93
            if(SkyPawn(PlayerPawn).FindInventoryTypeByArch(DefaultInventory[I]) == none)
            {
                PlayerPawn.CreateInventory(DefaultInventory[I].Class, bActivated, DefaultInventory[I]);
                bActivated = true;
            }
            I++;
            // [Loop Continue]
            goto J0x1F;
        }        
    }
    else
    {
        SkyPawn(PlayerPawn).DefaultInventory = DefaultInventory;
    }
    PlayerPawn.AddDefaultInventory();
    SetPlayerDefaults(PlayerPawn);
    //return;    
}

function bool NeedPlayers()
{
    return false;
    //return ReturnValue;    
}

function string GetTeamName(int Index)
{
    // End:0x16
    if(Index == 1)
    {
        return "Watchers";
    }
    return "Survivalists";
    //return ReturnValue;    
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    // End:0x8F
    if(C.PlayerReplicationInfo != none)
    {
        // End:0x8F
        if((C.PlayerReplicationInfo.Team != none) && C.PlayerReplicationInfo.Team.TeamIndex < 2)
        {
            // End:0x8F
            if(C.PlayerReplicationInfo.Team.TeamIndex == 1)
            {
                return Class'SkyPawn_MP_IHGrunt';
            }
        }
    }
    return Class'SkyPawn_MP_Survivor';
    //return ReturnValue;    
}
