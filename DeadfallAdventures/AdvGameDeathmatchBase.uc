class AdvGameDeathmatchBase extends AdvGameMP_Base
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bNoKills;

function PlayEndMatchSound()
{
    local AdvPlayerController C;
    local array<AdvPlayerController> Players;
    local int I;
    local bool bDraw;

    bDraw = true;
    // End:0xEE
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', C)
    {
        // End:0xD7
        if((Players.Length > 0) && Players[Players.Length - 1].PlayerReplicationInfo.Score != C.PlayerReplicationInfo.Score)
        {
            bDraw = false;
        }
        Players.AddItem(C);                
    }    
    // End:0x1D8
    if(bDraw)
    {
        // End:0x1D5
        foreach Players(C)
        {
            I = Rand(EndMatchSoundDraw.Length);
            AdvPlayerControllerMP(Players[0]).ClientPlaySound(EndMatchSoundDraw[I]);
            AdvPlayerControllerMP(Players[I]).SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchDrawStringKey[I], "AdvGame"));            
        }        
        return;
    }
    Players.Sort(ComparePlayersScore);    
    // End:0x2C7
    if(Players.Length > 0)
    {
        I = Rand(EndMatchSoundDraw.Length);
        AdvPlayerControllerMP(Players[0]).ClientPlaySound(EndMatchSoundWin[I]);
        AdvPlayerControllerMP(Players[I]).SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchWinStringKey[I], "AdvGame"));
    }
    I = 1;
    J0x2D2:

    // End:0x3B1 [Loop If]
    if(I <= 5)
    {
        // End:0x300
        if(Players.Length < (I + 1))
        {
            // [Explicit Break]
            goto J0x3B1;
        }
        AdvPlayerControllerMP(Players[I]).ClientPlaySound(EndMatchSoundLose[0]);
        AdvPlayerControllerMP(Players[I]).SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchLoseStringKey[0], "AdvGame"));
        I++;
        // [Loop Continue]
        goto J0x2D2;
    }
    J0x3B1:

    I = 6;
    J0x3BD:

    // End:0x49C [Loop If]
    if(I <= 10)
    {
        // End:0x3EB
        if(Players.Length < (I + 1))
        {
            // [Explicit Break]
            goto J0x49C;
        }
        AdvPlayerControllerMP(Players[I]).ClientPlaySound(EndMatchSoundLose[1]);
        AdvPlayerControllerMP(Players[I]).SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchLoseStringKey[1], "AdvGame"));
        I++;
        // [Loop Continue]
        goto J0x3BD;
    }
    J0x49C:

    I = 11;
    J0x4A8:

    // End:0x573 [Loop If]
    if(I < Players.Length)
    {
        AdvPlayerControllerMP(Players[I]).ClientPlaySound(EndMatchSoundLose[2]);
        AdvPlayerControllerMP(Players[I]).SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchLoseStringKey[2], "AdvGame"));
        I++;
        // [Loop Continue]
        goto J0x4A8;
    }
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    super.ScoreKill(Killer, Other);
    // End:0x21C
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        // End:0x198
        if(((AdvPlayerControllerMP(Killer).KilledPlayerNames.Find(AdvPRI(Other.PlayerReplicationInfo).PlayerName) == ) && ) && !ClassIsChildOf(WorldInfo.GetGameClass(), Class'AdvGameTeamDeathmatchBase'))
        {
            !ClassIsChildOf(WorldInfo.GetGameClass(), Class'AdvGameTreasureHuntBase');            
            AdvPlayerControllerMP(Killer).KilledPlayerNames.AddItem(AdvPRI(Other.PlayerReplicationInfo).PlayerName);            
        }
        // End:0x21C
        if(AdvPlayerControllerMP(Killer).KilledPlayerNames.Length >= 10)
        {
            AdvPlayerControllerMP(Killer).KilledPlayerNames.Length = 0;
            AdvPlayerControllerMP(Killer).ClientUnlockAchievement(46);
        }
    }
    // End:0x368
    if(((((bNoKills && Killer != none) && AdvPlayerControllerMP(Killer) != none) && Other != none) && AdvPlayerController(Other) != none) && Killer != Other)
    {
        bNoKills = false;
        AdvPlayerControllerMP(Killer).SetFirstBloodMessage();
        // End:0x368
        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
        {
            AdvPlayerControllerMP(Killer).ClientUnlockAchievement(32);
            AdvPlayerController(Killer).AddXP(XPForFirstKill);
        }
    }
    //return;    
}

function int ComparePlayersScore(AdvPlayerController A, AdvPlayerController B)
{
    // End:0x2A
    if(A.PlayerReplicationInfo == none)
    {
        return -1;
    }
    // End:0x50
    if(B.PlayerReplicationInfo == none)
    {
        return 1;
    }
    // End:0xC0
    if(A.PlayerReplicationInfo.Score == B.PlayerReplicationInfo.Score)
    {
        return 0;        
    }
    else
    {
        // End:0x130
        if(A.PlayerReplicationInfo.Score > B.PlayerReplicationInfo.Score)
        {
            return 1;            
        }
        else
        {
            return -1;
        }
    }
    //return ReturnValue;    
}

function PreBeginPlay()
{
    local int I;

    Teams.Length = ((Teams.Length < 255) ? 255 : Teams.Length);
    super.PreBeginPlay();
    I = 3;
    J0x40:

    // End:0x71 [Loop If]
    if(I < 255)
    {
        CreateTeam(I);
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    super.InitGame(Options, ErrorMessage);
    //return;    
}

function int GetHandicapNeed(Pawn Other)
{
    local float ScoreDiff;

    // End:0x26
    if(Other.PlayerReplicationInfo == none)
    {
        return 0;
    }
    UTGameReplicationInfo(GameReplicationInfo).SortPRIArray();
    ScoreDiff = GameReplicationInfo.PRIArray[0].Score - Other.PlayerReplicationInfo.Score;
    // End:0xD6
    if(ScoreDiff < float(3))
    {
        return 0;
    }
    return int(ScoreDiff / float(3));
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    local int Index;

    // End:0x19
    if(C == none)
    {
        ScriptTrace();
    }
    // End:0xBC
    if((C == none) || !C.IsA('EvilAIController'))
    {
        Index = 0;
        J0x5A:

        // End:0xB0 [Loop If]
        if(Index < MaxPlayers)
        {
            // End:0xA2
            if(Teams[Index].Size == 0)
            {
                // [Explicit Break]
                goto J0xB0;
            }
            ++Index;
            // [Loop Continue]
            goto J0x5A;
        }
        J0xB0:

        return byte(Index);
    }
    return 250;
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    // End:0xE4
    if(((Num == 255) || Other.IsA('EvilPlayerController') && Teams[Num].Size > 0) || Other.IsA('EvilAIController') && Teams[Num].Size < 1)
    {
        Num = int(PickTeam(byte(Num), Other));
    }
    SetTeam(Other, ((Num < 255) ? Teams[Num] : none), false);
    return true;
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
            // End:0xA2
            if(Scorer.Score >= float(GoalScore))
            {
                EndGame(Scorer, "fraglimit");
                return true;                
            }
            else
            {
                // End:0xD2
                if(bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;                    
                }
                else
                {
                    // End:0x3E8
                    if(bScoreDeaths && GoalScore > 0)
                    {
                        // End:0x1F4
                        if(Scorer.Team.Score == float(GoalScore - 10))
                        {
                            // End:0x1F1
                            if(!bPlayedTenKills && GoalScore > 19)
                            {
                                // End:0x1F1
                                if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                {
                                    bPlayedTenKills = true;
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x2F8
                            if(Scorer.Team.Score == float(GoalScore - 5))
                            {
                                // End:0x2F5
                                if(!bPlayedFiveKills && GoalScore > 9)
                                {
                                    // End:0x2F5
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedFiveKills = true;
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0x3E8
                                if((Scorer.Team.Score == float(GoalScore - 1)) && !bPlayedOneKill)
                                {
                                    // End:0x3E8
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedOneKill = true;
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

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    Winner.IncrementGlobalIntStat(131);
    //return;    
}

defaultproperties
{
    bNoKills=true
    EndMatchSoundLose[0]=SoundCue'a_anno_dth01_cue.ANNO_DTH_PL_001'
    EndMatchSoundLose[1]=SoundCue'a_anno_dth01_cue.ANNO_DTH_PL_002'
    EndMatchSoundLose[2]=SoundCue'a_anno_dth01_cue.ANNO_DTH_PL_003'
    EndMatchLoseStringKey[0]="ANNO_DTH_PL_001"
    EndMatchLoseStringKey[1]="ANNO_DTH_PL_002"
    EndMatchLoseStringKey[2]="ANNO_DTH_PL_003"
    bScoreDeaths=true
    bIgnoreTeamForVoiceChat=true
    Acronym="DM"
    MapPrefixes=/* Array type was not detected. */
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_DM'
}