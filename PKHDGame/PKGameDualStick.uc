class PKGameDualStick extends PKGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

struct EvilCheckPoint
{
    var bool bValid;
    var Vector pos;
    var Rotator Rot;

    structdefaultproperties
    {
        bValid=false
        pos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rot=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct EvilTeleportInfo
{
    var Vector PawnLocation;
    var Rotator ControllerRotation;

    structdefaultproperties
    {
        PawnLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ControllerRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var() float DemonTime;
var private bool bInDeamonMode;
var bool bStartupLoadCheckpoint;
var bool bStartupSaveCheckpoint;
var int CurrentChapter;
var config array<config EvilTeleportInfo> TeleportInfos;

event InitGame(string Options, out string ErrorMessage)
{
    local int ChapterOption;
    local array<SequenceObject> AllCheckpointEvents;
    local Sequence GameSeq;
    local SeqEvent_ChapterPoint chapterSequence;
    local int I;

    super.InitGame(Options, ErrorMessage);
    // End:0x7B
    if((HasOption(Options, "loadcheckpoint")) && (ParseOption(Options, "loadcheckpoint")) != "0")
    {
        bStartupLoadCheckpoint = true;
    }
    ChapterOption = GetIntOption(Options, "chapter", -1);
    // End:0xBC
    if(ChapterOption == -1)
    {        
    }
    else
    {
        bStartupSaveCheckpoint = true;
        CurrentChapter = ChapterOption;
        GameSeq = WorldInfo.GetGameSequence();
        // End:0x288
        if(GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_ChapterPoint', true, AllCheckpointEvents);
            I = 0;
            J0x150:

            // End:0x1EE [Loop If]
            if(I < AllCheckpointEvents.Length)
            {
                chapterSequence = SeqEvent_ChapterPoint(AllCheckpointEvents[I]);
                // End:0x1E0
                if(int(chapterSequence.Chapter) == CurrentChapter)
                {
                    chapterSequence.CheckActivate(self, none);
                }
                I++;
                // [Loop Continue]
                goto J0x150;
            }
            GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_CheckpointLoaded', true, AllCheckpointEvents);
            I = 0;
            J0x22B:

            // End:0x288 [Loop If]
            if(I < AllCheckpointEvents.Length)
            {
                SeqEvent_CheckpointLoaded(AllCheckpointEvents[I]).CheckActivate(self, none);
                I++;
                // [Loop Continue]
                goto J0x22B;
            }
        }
    }
    //return;    
}

function StartMatch()
{
    super.StartMatch();
    //return;    
}

function ModifyScoreKill(Controller Killer, Controller Other)
{
    local float ScoreMultiplier;

    super(GameInfo).ModifyScoreKill(Killer, Other);
    // End:0xB4
    if((Killer == Other) || Killer == none)
    {
        // End:0xB1
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score += float(1);
        }        
    }
    else
    {
        // End:0x152
        if(Killer.PlayerReplicationInfo != none)
        {
            Killer.PlayerReplicationInfo.Score += ((float(Other.Pawn.HealthMax) * ScoreMultiplier) - float(1));
        }
    }
    //return;    
}

function ScoreHit(Controller HitInstigator, Controller Other, optional float Score = 1.0000000, optional int Priority, optional string ComboName)
{
    local float ScoreMultiplier;

    // End:0x146
    if(((HitInstigator != Other) && HitInstigator != none) && HitInstigator.PlayerReplicationInfo != none)
    {
        ScoreMultiplier = EvilPlayerReplicationInfo(HitInstigator.PlayerReplicationInfo).ScoreMultiplier;
        HitInstigator.PlayerReplicationInfo.Score += (Score * ScoreMultiplier);
        HitInstigator.PlayerReplicationInfo.bForceNetUpdate = true;
        CheckScore(HitInstigator.PlayerReplicationInfo);
    }
    //return;    
}

function ScoreLevel(PlayerController PC)
{
    // End:0x84
    if(PC != none)
    {
        PC.PlayerReplicationInfo.Score += float(10000 + (PC.Pawn.Health * 100));
    }
    //return;    
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController NewPlayer, PC;
    local Controller C;
    local bool bDedicatedServerSpectator;
    local PainPRI PRI;

    // End:0x90
    if(((NumPlayers == 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && HasOption(Options, "dedicated"))
    {
        bDedicatedServerSpectator = true;        
        Options $= "?SpectatorOnly=1";
    }
    // End:0x166
    if(MaxLives > 0)
    {
        // End:0x165
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x164
            if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
            {
                Options = "?SpectatorOnly=1" $ Options;
                // End:0x165
                break;
            }            
        }        
    }
    NewPlayer = super.Login(Portal, Options, UniqueId, ErrorMessage);
    // End:0x248
    if(UTPlayerController(NewPlayer) != none)
    {
        // End:0x211
        if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
        {
            UTPlayerController(NewPlayer).bLateComer = true;
        }
        // End:0x248
        if(bDedicatedServerSpectator)
        {
            UTPlayerController(NewPlayer).bDedicatedServerSpectator = true;
        }
    }
    // End:0x2EC
    if((!bUseClassicHUD && NewPlayer != none) && Class'Engine.Engine'.static.IsSplitScreen())
    {
        // End:0x2EB
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x2EA
            if(PC != NewPlayer)
            {
                PC.ClientSetHUD(HUDType);
            }            
        }        
    }
    // End:0x4BB
    if(NewPlayer != none)
    {
        PRI = PainPRI(NewPlayer.PlayerReplicationInfo);
        // End:0x493
        if(PRI != none)
        {
            // End:0x392
            if(HasOption(Options, "Daydream"))
            {
                bURLDifficultyOverride = true;
                PRI.Difficulty = Class'PainDifficultySettings_Daydream';                
            }
            else
            {
                // End:0x3E9
                if(HasOption(Options, "Insomnia"))
                {
                    bURLDifficultyOverride = true;
                    PRI.Difficulty = Class'PainDifficultySettings_Insomnia';                    
                }
                else
                {
                    // End:0x441
                    if(HasOption(Options, "Nightmare"))
                    {
                        bURLDifficultyOverride = true;
                        PRI.Difficulty = Class'PainDifficultySettings_Nightmare';                        
                    }
                    else
                    {
                        // End:0x493
                        if(HasOption(Options, "Trauma"))
                        {
                            bURLDifficultyOverride = true;
                            PRI.Difficulty = Class'PainDifficultySettings_Trauma';
                        }
                    }
                }
            }
        }
        PKPlayerController(NewPlayer).UpdateDifficultySetting();
    }
    return NewPlayer;
    //return ReturnValue;    
}

function RestartPlayer(Controller aPlayer)
{
    local EvilVehicle_Base V, Best;
    local Vector ViewDir;
    local float bestDist, Dist;
    local EvilPlayerController PC;

    PC = EvilPlayerController(aPlayer);
    // End:0x6F
    if(PC != none)
    {
        // End:0x6F
        if((bMustJoinBeforeStart && PC != none) && PC.bLateComer)
        {
            return;
        }
    }
    // End:0xA8
    if(aPlayer.PlayerReplicationInfo.bOutOfLives)
    {
        return;
    }
    super.RestartPlayer(aPlayer);
    // End:0xE1
    if(aPlayer.Pawn == none)
    {
        return;
    }
    AssignHoverboard(UTPawn(aPlayer.Pawn));
    // End:0x414
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(aPlayer) != none)
    {
        bestDist = 2000.0000000;
        ViewDir = Vector(aPlayer.Pawn.Rotation);
        V = VehicleList;
        J0x1B6:

        // End:0x3C2 [Loop If]
        if(V != none)
        {
            // End:0x219
            if(!bTeamGame && V.bTeamLocked)
            {
                V.bTeamLocked = false;
            }
            // End:0x397
            if(V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer, V))
            {
                Dist = VSize(V.Location - aPlayer.Pawn.Location);
                // End:0x35A
                if((ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < float(0))
                {
                    Dist *= float(2);
                }
                // End:0x397
                if(Dist < bestDist)
                {
                    Best = V;
                    bestDist = Dist;
                }
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x1B6;
        }
        // End:0x414
        if(Best != none)
        {
            Best.PlayerStartTime = WorldInfo.TimeSeconds + float(8);
        }
    }
    // End:0x437
    if(PC != none)
    {
        SetupPlayerMuteList(PC, false);
    }
    //return;    
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return (((int(WorldInfo.NetMode) == int(NM_Standalone)) && Player != none) && Player.StartSpot != none) && bWaitingToStartMatch || (Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.bWaitingPlayer;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    // End:0x12
    if(C == none)
    {
        return 255;
    }
    // End:0xC7
    if(C.IsA('EvilPlayerController') || ((EvilAIController(C) != none) && EvilAIController(C).Master != none) && EvilAIController(C).Master.IsA('EvilPlayerController'))
    {
        return 0;        
    }
    else
    {
        return 1;
    }
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    // End:0x61
    if((Num == 255) || !Other.IsA('EvilAIController'))
    {
        Num = int(PickTeam(byte(Num), Other));
    }
    SetTeam(Other, Teams[Num], false);
    return true;
    //return ReturnValue;    
}

function bool IsDeamonMode()
{
    return bInDeamonMode;
    //return ReturnValue;    
}

function StartDaemonMode(optional float InDemonTime, optional bool bIsWarningFlash = false)
{
    local float DemonT;
    local PKPlayerController PC;

    // End:0x15
    if(IsDeamonMode())
    {
        return;
    }
    // End:0x69
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ToggleDemon();        
    }    
    DemonT = DemonTime;
    // End:0xA1
    if(InDemonTime != float(0))
    {
        DemonT = InDemonTime;
    }
    DemonT *= Class'PKPlayerController'.default.DemonBulletTimeMultiplier;
    // End:0xF5
    if(DemonT > float(0))
    {
        SetTimer(DemonT, false, 'StopDaemonMode');        
    }
    else
    {
        ClearTimer('StopDaemonMode');
    }
    bInDeamonMode = true;
    //return;    
}

function StopDaemonMode()
{
    local PKPlayerController PC;

    // End:0x79
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0x78
        if(PC.IsInState('Demon'))
        {
            PC.ToggleDemon();
        }        
    }    
    ClearTimer('StopDaemonMode');
    bInDeamonMode = false;
    //return;    
}

defaultproperties
{
    DemonTime=20.0000000
    Acronym="SP"
    SpawnProtectionTime=0.0000000
    DefaultInventory=/* Array type was not detected. */
    MapPrefixes=/* Array type was not detected. */
    ConsolePlayerControllerClass=Class'PKDualStickPlayerController'
    DefaultPawnClass=Class'PKDualStickPlayerPawn'
    PlayerControllerClass=Class'PKDualStickPlayerController'
}