class AdvGameTeamDeathmatchBase extends AdvGameDeathmatchBase
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bScoreTeamKills;
var float FriendlyFireScale;
var float TeammateBoost;

function PreBeginPlay()
{
    super(AdvGameMP_Base).PreBeginPlay();
    //return;    
}

function DoPostLogin(PlayerController NewPlayer)
{
    local Actor A;

    super(AdvGameMP_Base).DoPostLogin(NewPlayer);
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

function PlayEndMatchSound()
{
    local AdvPlayerControllerMP PC;
    local int I;

    // End:0x2A7
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0xFE
        if(GameReplicationInfo.Winner == none)
        {
            I = Rand(EndMatchSoundDraw.Length);
            PC.ClientPlaySound(EndMatchSoundDraw[I]);
            PC.SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchDrawStringKey[I], "AdvGame"));
            // End:0x2A6
            continue;
        }
        // End:0x203
        if(TeamInfo(GameReplicationInfo.Winner) == PC.PlayerReplicationInfo.Team)
        {
            I = Rand(EndMatchSoundWin.Length);
            PC.ClientPlaySound(EndMatchSoundWin[I]);
            PC.SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchWinStringKey[I], "AdvGame"));
            // End:0x2A6
            continue;
        }
        I = Rand(EndMatchSoundLose.Length);
        PC.ClientPlaySound(EndMatchSoundLose[I]);
        PC.SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchLoseStringKey[I], "AdvGame"));        
    }    
    //return;    
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
                // End:0x10F
                if(bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Rating;

    Rating = super(AdvGameMP_Base).RatePlayerStart(P, Team, Player);
    // End:0xE0
    if(P.TeamIndex != 255)
    {
        // End:0xA3
        if(AdvGRI(GameReplicationInfo).bTeamsInverted)
        {
            Team = ((int(Team) == int(0)) ? 1 : 0);
        }
        // End:0xE0
        if(int(Team) == P.TeamIndex)
        {
            Rating += float(10);
        }
    }
    return Rating;
    //return ReturnValue;    
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

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0x22
    if(Reason ~= "NotEnoughPlayers")
    {
        return true;
    }
    // End:0x10A
    if(bOverTime)
    {
        // End:0x4B
        if((NumBots + NumPlayers) == 0)
        {
            return true;
        }
        bLastMan = true;
        // End:0xFA
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0xF9
            if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                bLastMan = false;
                // End:0xFA
                break;
            }            
        }        
        // End:0x10A
        if(bLastMan)
        {
            return true;
        }
    }
    bLastMan = Reason ~= "LastMan";
    // End:0x15B
    if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x1E5
    if(bTeamScoreRounds)
    {
        // End:0x1E5
        if(Winner != none)
        {
            Winner.Team.Score += float(1);
            Winner.Team.bForceNetUpdate = true;
        }
    }
    // End:0x232
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x2A4
        if(Teams[1].Score > Teams[0].Score)
        {
            GameReplicationInfo.Winner = Teams[1];            
        }
        else
        {
            // End:0x316
            if(Teams[0].Score > Teams[1].Score)
            {
                GameReplicationInfo.Winner = Teams[0];                
            }
            else
            {
                GameReplicationInfo.Winner = none;
            }
        }
    }
    // End:0x358
    if((Winner == none) && !bAllowDraws)
    {
        return false;
    }
    AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
    EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    local AdvTeamInfo SmallTeam, BigTeam, NewTeam;
    local int SmallTeamRealSize, BigTeamRealSize;
    local PlayerReplicationInfo PRI;
    local int I;

    I = Rand(2);
    SmallTeam = AdvTeamInfo(Teams[I]);
    BigTeam = AdvTeamInfo(Teams[1 - I]);
    SmallTeamRealSize = SmallTeam.Size;
    BigTeamRealSize = BigTeam.Size;
    // End:0x1EE
    foreach WorldInfo.GRI.PRIArray(PRI)
    {
        // End:0x16F
        if(((PRI.Team == SmallTeam) && AdvPRI(PRI) != none) && AdvPRI(PRI).bIsTournamentSpectator)
        {
            SmallTeamRealSize--;            
        }
        else
        {
            // End:0x1ED
            if(((PRI.Team == BigTeam) && AdvPRI(PRI) != none) && AdvPRI(PRI).bIsTournamentSpectator)
            {
                BigTeamRealSize--;
            }
        }        
    }    
    // End:0x255
    if(SmallTeamRealSize > BigTeamRealSize)
    {
        SmallTeam = AdvTeamInfo(Teams[1 - I]);
        BigTeam = AdvTeamInfo(Teams[I]);
    }
    // End:0x3A9
    if(int(Num) < int(2))
    {
        NewTeam = AdvTeamInfo(Teams[int(Num)]);
        // End:0x3A6
        if((SmallTeamRealSize == BigTeamRealSize) || NewTeam != SmallTeam)
        {
            // End:0x393
            if((((C != none) && C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.Team != none) && SmallTeamRealSize == BigTeamRealSize)
            {
                NewTeam = AdvTeamInfo(C.PlayerReplicationInfo.Team);                
            }
            else
            {
                NewTeam = SmallTeam;
            }
        }        
    }
    else
    {
        NewTeam = SmallTeam;
    }
    return byte(NewTeam.TeamIndex);
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    local int InjuredTeam, InstigatorTeam;
    local class<EvilDmgType_Base> UTDamageType;
    local AdvPlayerController PC;

    // End:0x5A
    if(InstigatedBy == none)
    {
        super(ADVGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
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
                    PC = AdvPlayerController(InstigatedBy);
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
                                    if((AdvPlayerController(injured.Controller) != none) && AdvPlayerController(injured.Controller).bAutoTaunt)
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
                    super(ADVGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
                    return;
                }
                Damage *= FriendlyFireScale;                
            }
            else
            {
                // End:0x622
                if(((!injured.IsHumanControlled() && injured.Controller != none) && AdvPRI(injured.PlayerReplicationInfo) != none) && AdvPRI(injured.PlayerReplicationInfo).bHasFlag)
                {
                    injured.Controller.SendMessage(none, 'injured', 15.0000000);
                }
            }
        }
    }
    super(ADVGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    //return;    
}

function bool CheckIfServerIsReturningToMenu(AdvPlayerController ExitingPC)
{
    local AdvPlayerController PC;
    local bool bOneOfLocalControllersReturningToMainMenu;

    // End:0x72
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x71
        if(PC.bIsReturningFromMatch || PC.bIsReturningToMainMenu)
        {
            bOneOfLocalControllersReturningToMainMenu = true;
        }        
    }    
    return bOneOfLocalControllersReturningToMainMenu;
    //return ReturnValue;    
}

function Logout(Controller Exiting)
{
    local TeamInfo OldTeam;
    local int I;
    local bool bFound;
    local int RedTeamMembersAmount, BlueTeamMembersAmount;
    local PlayerReplicationInfo PRI, Winner;

    // End:0x9A
    if(!WorldInfo.IsInSeamlessTravel() && Exiting.PlayerReplicationInfo.bFromPreviousLevel)
    {
        OldTeam = Exiting.PlayerReplicationInfo.Team;
    }
    super(AdvGameMP_Base).Logout(Exiting);
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
    // End:0x270
    foreach GameReplicationInfo.PRIArray(PRI)
    {
        // End:0x26F
        if(PRI != Exiting.PlayerReplicationInfo)
        {
            // End:0x1E4
            if(Winner == none)
            {
                Winner = PRI;
            }
            // End:0x22B
            if(PRI.Team.TeamIndex == 0)
            {
                RedTeamMembersAmount++;                
            }
            else
            {
                // End:0x26F
                if(PRI.Team.TeamIndex == 1)
                {
                    BlueTeamMembersAmount++;
                }
            }
        }        
    }    
    // End:0x3C1
    if(GetStateName() != 'MatchOver')
    {
        // End:0x3C1
        if((RedTeamMembersAmount == 0) || BlueTeamMembersAmount == 0)
        {
            // End:0x2EF
            if(CheckIfServerIsReturningToMenu(AdvPlayerController(Exiting)))
            {
                GameReplicationInfo.Winner = none;
                Winner = none;                
            }
            else
            {
                GameReplicationInfo.Winner = Winner.Team;
            }
            AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
            EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
            SetEndGameFocus(Winner);
            EndGame(Winner, "NotEnoughPlayers");
        }
    }
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local AdvPlayerControllerMP AssistingPlayer;

    super.ScoreKill(Killer, Other);
    // End:0x11C
    if(!Other.bIsPlayer || (Killer != none) && !Killer.bIsPlayer || Killer.PlayerReplicationInfo == none)
    {
        // End:0x11A
        if(((!bScoreTeamKills && Killer != none) && Killer.bIsPlayer) && MaxLives > 0)
        {
            CheckScore(Killer.PlayerReplicationInfo);
        }
        return;
    }
    // End:0x189
    if((Killer == none) && AdvPlayerControllerMP(Other).bKilledByTrap)
    {
        Killer = AdvPlayerControllerMP(Other).TrapKiller;
    }
    // End:0x68D
    if(Other.bIsPlayer)
    {
        // End:0x276
        if((Killer == none) || Killer == Other)
        {
            Other.PlayerReplicationInfo.Team.Score -= float(ScoreForSuicide);
            Other.PlayerReplicationInfo.Team.bForceNetUpdate = true;            
        }
        else
        {
            // End:0x56A
            if(Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)
            {
                // End:0x4C7
                if(AdvPlayerControllerMP(Other).AssistingPlayers.Length > 1)
                {
                    // End:0x4C3
                    foreach AdvPlayerControllerMP(Other).AssistingPlayers(AssistingPlayer)
                    {
                        // End:0x4C2
                        if(AssistingPlayer.PlayerReplicationInfo != none)
                        {
                            // End:0x422
                            if(AssistingPlayer != Killer)
                            {
                                AssistingPlayer.PlayerReplicationInfo.Team.Score += float(ScoreForAssist);
                                AssistingPlayer.PlayerReplicationInfo.Team.bForceNetUpdate = true;                                
                            }
                            else
                            {
                                AssistingPlayer.PlayerReplicationInfo.Team.Score += float(ScoreForFinisher);
                                AssistingPlayer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
                            }
                        }                        
                    }                                        
                }
                else
                {
                    Killer.PlayerReplicationInfo.Team.Score += float(ScoreForFlawlessKill);
                    Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
                }                
            }
            else
            {
                // End:0x68D
                if(bScoreTeamKills)
                {
                    Killer.PlayerReplicationInfo.bForceNetUpdate = true;
                    Killer.PlayerReplicationInfo.Score -= float(ScoreForSuicide);
                    Killer.PlayerReplicationInfo.Team.Score -= float(ScoreForSuicide);
                    Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
                }
            }
        }
    }
    // End:0x6D3
    if((Killer != none) && bScoreTeamKills)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    //return;    
}

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapperMP_Team';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    CommonForGenericPlayerInitialization(C);
    //return;    
}

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    Winner.IncrementGlobalIntStat(132);
    //return;    
}

defaultproperties
{
    bScoreTeamKills=true
    FriendlyFireScale=0.6000000
    TeammateBoost=0.5000000
    EndMatchSoundWin[0]=SoundCue'a_anno_tdctf01_cue.ANNO_TDCTF_WON_001'
    EndMatchWinStringKey[0]="ANNO_TDCTF_WON_001"
    EndMatchWinStringKey[1]="ANNO_DTHTTH_WON_002"
    EndMatchSoundLose[0]=SoundCue'a_anno_tdctf01_cue.ANNO_TDCTF_LOS_001'
    EndMatchLoseStringKey[0]="ANNO_TDCTF_LOS_001"
    EndMatchLoseStringKey[1]="ANNO_DTH_PL_002"
    EndMatchLoseStringKey[2]="ANNO_DTH_PL_003"
    CloseToEndWinSound[0]=SoundCue'a_anno_tdctftth01_cue.ANNO_TDCTFTTH_WON_001'
    CloseToEndWinStringKey[0]="ANNO_TDCTFTTH_WON_001"
    CloseToEndWinStringKey[1]="ANNO_DTH_AEND_002"
    CloseToEndLoseSound[0]=SoundCue'a_anno_tdctftth01_cue.ANNO_TDCTFTTH_LOS_001'
    CloseToEndLoseStringKey[0]="ANNO_TDCTFTTH_LOS_001"
    CloseToEndLoseStringKey[1]="ANNO_DTH_AEND_002"
    bAllowFriendlyFire=true
    bMustHaveMultiplePlayers=true
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_TDM'
}