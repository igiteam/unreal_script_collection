class PainGRI extends EvilGameReplicationInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var PKTypes.EPKPartyType CurrentPartyType;
var repnotify PKTarotManager.EGoldenTarrotCard SelectedGoldCards[3];
var repnotify PKTarotManager.ESilverTarrotCard SelectedSilverCards[2];
var repnotify byte AvailableCardsGold[EGoldenTarrotCard];
var repnotify byte AvailableCardsSilver[ESilverTarrotCard];
var PKTypes.ELevelID NextLevelID;
var bool bGoldenCardsUseUnlimited;
var bool Finished;
var bool bIsSingleSurvivalGame;
var bool bIsMultiplayerGame;
var bool bIsTeamMultiplayerGame;
var bool bBrightSkin;
var bool bBunnyhopping;
var bool bForwardRocketJump;
var bool bGameplayTimerRunning;
var int MonstersKilled;
var int SoulsCollected;
var int ArmorsFound;
var int GoldFound;
var int BonusItems;
var int BonusItemsFromFallenEnemy;
var int HolyItemsFound;
var int AmmoFound;
var int ObjectsDestroyed;
var int SecretsFound;
var int TotalMonsters;
var int TotalSouls;
var int TotalArmors;
var int TotalGold;
var int TotalHolyItems;
var int TotalAmmo;
var int TotalObjects;
var int TotalSecrets;
var int GameplayTime;
var int CountdownTimer;
var int MonstersKilledInDeamonMode;
var int TotalSoulsCollected;
var int BansheeScreamingCount;
var int BansheeSpawnRavensCount;
var array<Pawn> BansheeScreamAffectedPawnsList;
var int BuildNumber;
var string BuildString;
var int DemonModeStarts;
var int GibbedFrozenMonsters;
var int MonstersPossessedBySoulCatcher;
var int ThreeEnemiesKilledByOneSoulSaw;
var int PawnsDetachedLimbs;
var int GibbedPawns;

replication
{
    // Pos:0x000
    if(bNetDirty)
        AmmoFound, ArmorsFound, 
        AvailableCardsGold, AvailableCardsSilver, 
        BansheeScreamingCount, BonusItems, 
        CountdownTimer, CurrentPartyType, 
        Finished, GameplayTime, 
        GoldFound, HolyItemsFound, 
        MonstersKilled, ObjectsDestroyed, 
        SecretsFound, SelectedGoldCards, 
        SelectedSilverCards, SoulsCollected, 
        TotalAmmo, TotalArmors, 
        TotalGold, TotalHolyItems, 
        TotalMonsters, TotalObjects, 
        TotalSecrets, TotalSouls, 
        TotalSoulsCollected, bBrightSkin, 
        bBunnyhopping, bForwardRocketJump;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

simulated event bool ShouldShowGore()
{
    return !Class'PKEngine'.static.IsLowViolence();
    //return ReturnValue;    
}

function ResumeGameplayTimer()
{
    bGameplayTimerRunning = true;
    //return;    
}

function PauseGameplayTimer()
{
    bGameplayTimerRunning = false;
    //return;    
}

simulated function GetTotalStatisticsFromMapInfo()
{
    local PKMapInfo MapInfo;

    MapInfo = PKMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x1B0
    if(MapInfo != none)
    {
        TotalMonsters = MapInfo.TotalCollectibles[0];
        TotalSouls = MapInfo.TotalCollectibles[1];
        TotalArmors = MapInfo.TotalCollectibles[2];
        TotalGold = MapInfo.TotalCollectibles[3];
        TotalHolyItems = MapInfo.TotalCollectibles[4];
        TotalAmmo = MapInfo.TotalCollectibles[5];
        TotalObjects = MapInfo.TotalCollectibles[6];
        TotalSecrets = MapInfo.TotalCollectibles[7];        
    }
    //return;    
}

simulated function ReceivedGameClass()
{
    bIsMultiplayerGame = ClassIsChildOf(GameClass, Class'PKGameMP_Base');
    bIsTeamMultiplayerGame = ClassIsChildOf(GameClass, Class'PKGameTeamDeathmatch');
    bIsSingleSurvivalGame = ClassIsChildOf(GameClass, Class'PKGameSingleSurvival');
    //return;    
}

simulated function bool IsSingleSurvivalGame()
{
    return bIsSingleSurvivalGame;
    //return ReturnValue;    
}

simulated function bool IsMultiplayerGame()
{
    return bIsMultiplayerGame;
    //return ReturnValue;    
}

simulated function bool IsTeamMultiPlayerGame()
{
    return bIsTeamMultiplayerGame;
    //return ReturnValue;    
}

simulated function bool IsCoopMultiplayerGame()
{
    return ClassIsChildOf(GameClass, Class'PKGameCooperative');
    //return ReturnValue;    
}

simulated function bool IsPureSinglePlayerGame()
{
    return (!IsMultiplayerGame() && !IsTeamMultiPlayerGame()) && !IsCoopMultiplayerGame();
    //return ReturnValue;    
}

function ScoreGold(int Amount)
{
    GoldFound += Amount;
    TryUnlockTarotCards();
    //return;    
}

function ScoreMonsterKilled()
{
    local PKGameSP GSP;

    MonstersKilled++;
    GSP = PKGameSP(WorldInfo.Game);
    // End:0x79
    if((GSP != none) && GSP.IsDeamonMode())
    {
        IncremenetMonstersKilledInDeamonMode();
    }
    TryUnlockTarotCards();
    //return;    
}

function ScoreArmourTaken()
{
    ArmorsFound++;
    TryUnlockTarotCards();
    //return;    
}

function ScoreAmmoTaken()
{
    AmmoFound++;
    TryUnlockTarotCards();
    //return;    
}

function ScoreDestroyedObject()
{
    ObjectsDestroyed++;
    TryUnlockTarotCards();
    //return;    
}

function ScoreBonusItemTaken(int val)
{
    BonusItems += val;
    TryUnlockTarotCards();
    //return;    
}

function ScoreBonusItemFromFallenEnemy(int val)
{
    BonusItemsFromFallenEnemy += val;
    TryUnlockTarotCards();
    //return;    
}

function ScoreHolyItemTaken()
{
    HolyItemsFound++;
    TryUnlockTarotCards();
    //return;    
}

function ScoreSecretFound()
{
    SecretsFound++;
    TryUnlockTarotCards();
    //return;    
}

function ScoreSoulTaken()
{
    local PKGame PKG;

    SoulsCollected++;
    TotalSoulsCollected++;
    PKG = PKGame(WorldInfo.Game);
    TryUnlockTarotCards();
    // End:0xAD
    if(TotalSoulsCollected >= PKG.SoulsToEnableDemon)
    {
        PKG.StartDaemonMode();
        TotalSoulsCollected = 0;        
    }
    else
    {
        // End:0x102
        if(TotalSoulsCollected >= (PKG.SoulsToEnableDemon - 3))
        {
            PKG.StartDaemonMode(0.5000000, true);
        }
    }
    //return;    
}

function ClearGlobalLevelStatistics()
{
    MonstersKilled = 0;
    SoulsCollected = 0;
    ArmorsFound = 0;
    GoldFound = 0;
    BonusItems = 0;
    HolyItemsFound = 0;
    AmmoFound = 0;
    ObjectsDestroyed = 0;
    SecretsFound = 0;
    Finished = false;
    //return;    
}

simulated function CopyLevelStatisticsToGlobalStatistics(const out LevelStatistics ls)
{
    AmmoFound = ls.AmmoFound;
    ArmorsFound = ls.ArmorsFound;
    BonusItems = ls.BonusItems;
    GameplayTime = ls.GameplayTime;
    GoldFound = ls.GoldFound;
    HolyItemsFound = ls.HolyItemsFound;
    MonstersKilled = ls.MonstersKilled;
    ObjectsDestroyed = ls.ObjectsDestroyed;
    SecretsFound = ls.SecretsFound;
    SoulsCollected = ls.SoulsCollected;
    TotalAmmo = ls.TotalAmmo;
    TotalArmors = ls.TotalArmors;
    TotalGold = ls.TotalGold;
    TotalHolyItems = ls.TotalHolyItems;
    TotalMonsters = ls.TotalMonsters;
    TotalObjects = ls.TotalObjects;
    TotalSecrets = ls.TotalSecrets;
    TotalSouls = ls.TotalSouls;
    //return;    
}

simulated function CopyGlobalStatisticsToLevelStatisticsStruct(out LevelStatistics ls)
{
    ls.AmmoFound = AmmoFound;
    ls.ArmorsFound = ArmorsFound;
    ls.BonusItems = BonusItems;
    ls.GameplayTime = GameplayTime;
    ls.GoldFound = GoldFound;
    ls.HolyItemsFound = HolyItemsFound;
    ls.MonstersKilled = MonstersKilled;
    ls.ObjectsDestroyed = ObjectsDestroyed;
    ls.SecretsFound = SecretsFound;
    ls.SoulsCollected = SoulsCollected;
    ls.TotalAmmo = TotalAmmo;
    ls.TotalArmors = TotalArmors;
    ls.TotalGold = TotalGold;
    ls.TotalHolyItems = TotalHolyItems;
    ls.TotalMonsters = TotalMonsters;
    ls.TotalObjects = TotalObjects;
    ls.TotalSecrets = TotalSecrets;
    ls.TotalSouls = TotalSouls;
    Class'PKPlayerPersistentData'.static.DebugLogLevelStatistics(ls);
    //return;    
}

simulated function Timer()
{
    local int minutes;
    local PlayerController PC;

    super(UTGameReplicationInfo).Timer();
    // End:0x81
    if(((WorldInfo.Game == none) || WorldInfo.Game.MatchIsInProgress()) && bGameplayTimerRunning)
    {
        GameplayTime++;
    }
    // End:0xBC
    if(!WorldInfo.GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0xE7
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x120
    if(WorldInfo.GRI.IsCoopMultiplayerGame())
    {
        return;
    }
    // End:0x29B
    if(((bMatchHasBegun && !bStopCountDown) && !bMatchIsOver) && Winner == none)
    {
        // End:0x298
        if((RemainingTime > 60) && (RemainingTime % 60) == 0)
        {
            minutes = RemainingTime / 60;
            // End:0x297
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                // End:0x296
                if(PainGFxHud(PainGFxHudWrapper(PC.myHUD).HudMovie) != none)
                {
                    PainGFxHud(PainGFxHudWrapper(PC.myHUD).HudMovie).AddMessage("htmlText", Class'PKGameMP_Base'.default.MinutesRemaining $ string(minutes));
                }                
            }            
        }        
    }
    else
    {
        // End:0x52A
        if(!bMatchIsOver && !bMatchHasBegun)
        {
            // End:0x52A
            if(CountdownTimer < 20)
            {
                // End:0x329
                if((CountdownTimer >= 1) && CountdownTimer <= 3)
                {
                    PlaySound(Class'PKGameMP_Base'.default.LuciferTimeSound[CountdownTimer - 1], true);                    
                }
                else
                {
                    // End:0x366
                    if(CountdownTimer < 10)
                    {
                        PlaySound(Class'PKGameMP_Base'.default.ClockTick, true);
                    }
                }
                // End:0x529
                foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
                {
                    // End:0x528
                    if(PainGFxHud(PainGFxHudWrapper(PC.myHUD).HudMovie) != none)
                    {
                        // End:0x498
                        if(CountdownTimer == Class'PKGameMP_Base'.default.InitialCountdown)
                        {
                            PainGFxHud(PainGFxHudWrapper(PC.myHUD).HudMovie).AddMessage("htmlText", Localize("KGFxUI_PreGameLobby", "TitleHost", "PKHDGame"));
                            // End:0x528
                            continue;
                        }
                        PainGFxHud(PainGFxHudWrapper(PC.myHUD).HudMovie).AddMessage("htmlText", Class'PKGameMP_Base'.default.SecondsToStart $ string(CountdownTimer));
                    }                    
                }                
            }
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local PlayerController PC;
    local bool bCardsNeedUpdating;

    switch(VarName)
    {
        // End:0x2E
        case 'SelectedGoldCards':
            bCardsNeedUpdating = true;
            // End:0x98
            break;
        // End:0x49
        case 'SelectedSilverCards':
            bCardsNeedUpdating = true;
            // End:0x98
            break;
        // End:0x64
        case 'AvailableCardsGold':
            bCardsNeedUpdating = true;
            // End:0x98
            break;
        // End:0x7F
        case 'AvailableCardsSilver':
            bCardsNeedUpdating = true;
            // End:0x98
            break;
        // End:0xFFFF
        default:
            super(GameReplicationInfo).ReplicatedEvent(VarName);
            // End:0x98
            break;
            break;
    }
    // End:0x203
    if(bCardsNeedUpdating)
    {
        // End:0x202
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x201
            if((PainGFxHudWrapper(PC.myHUD).TarotMovie != none) && PainGFxHudWrapper(PC.myHUD).TarotMovie.bMovieIsOpen)
            {
                PainGFxHudWrapper(PC.myHUD).TarotMovie.UpdateLocalCopyOfAvailableCards();
                PainGFxHudWrapper(PC.myHUD).TarotMovie.UpdateCards();
            }            
        }        
    }
    //return;    
}

simulated function ClearAvailableCards()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x3F [Loop If]
    if(I < 18)
    {
        AvailableCardsGold[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x4A:

    // End:0x7E [Loop If]
    if(I < 18)
    {
        AvailableCardsSilver[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x4A;
    }
    //return;    
}

function TryUnlockTarotCards(optional bool bIgnoreStaticUnlockCheck = false)
{
    //return;    
}

simulated function IncrementDemonModeStarts()
{
    DemonModeStarts++;
    TryUnlockTarotCards();
    //return;    
}

simulated function IncrementGibbedFrozenMonsters()
{
    GibbedFrozenMonsters++;
    TryUnlockTarotCards();
    //return;    
}

simulated function IncrementMonstersPossessedBySoulCatcher()
{
    MonstersPossessedBySoulCatcher++;
    TryUnlockTarotCards();
    //return;    
}

simulated function IncrementThreeEnemiesKilledByOneSoulSaw()
{
    ThreeEnemiesKilledByOneSoulSaw++;
    TryUnlockTarotCards();
    //return;    
}

simulated function IncrementPawnsDetachedLimbs()
{
    PawnsDetachedLimbs++;
    TryUnlockTarotCards();
    //return;    
}

simulated function IncrementGibbedPawns()
{
    GibbedPawns++;
    TryUnlockTarotCards();
    //return;    
}

function IncremenetMonstersKilledInDeamonMode()
{
    MonstersKilledInDeamonMode++;
    TryUnlockTarotCards();
    //return;    
}

simulated function PKTypes.EMultiGameMode GetMultiGameMode()
{
    // End:0x1B
    if(ClassIsChildOf(GameClass, Class'PKGameSurvival'))
    {
        return 4;
    }
    // End:0x36
    if(ClassIsChildOf(GameClass, Class'PKGameCooperative'))
    {
        return 5;
    }
    // End:0x51
    if(ClassIsChildOf(GameClass, Class'PKGameCTF'))
    {
        return 3;
    }
    // End:0x6C
    if(ClassIsChildOf(GameClass, Class'PKGameTeamDeathmatch'))
    {
        return 2;
    }
    // End:0x87
    if(ClassIsChildOf(GameClass, Class'PKGameDeathmatch'))
    {
        return 1;
    }
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    CurrentPartyType=EPKPartyType.EPPT_Local
    bBunnyhopping=true
    BuildNumber=3
    BuildString="20-09-2012"
}