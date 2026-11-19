class PainGRI_SP extends PainGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int ChapterNum;
var bool bForceNextLevel;
var repnotify bool bMusicTrackMuted;
var bool b666AmmoCardEnabled;
var float TimeToRespawnInCOOP;
var array<UnlockCardStatus> UnlockCardStatusPerMap;
var PKTarotManager.EGoldenTarrotCard GoldenCardCanBeUnlocked;
var PKTarotManager.ESilverTarrotCard SilverCardCanBeUnlocked;

replication
{
    // Pos:0x000
    if(bNetDirty)
        ChapterNum, TimeToRespawnInCOOP;

    // Pos:0x00A
    if((int(Role) == int(ROLE_Authority)) && bNetDirty)
        b666AmmoCardEnabled, bMusicTrackMuted;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x64
    if(VarName == 'bMusicTrackMuted')
    {
        WorldInfo.MusicComp.VolumeMultiplier = ((bMusicTrackMuted) ? 1.0000000 : 0.0000000);
    }
    //return;    
}

function EndOfGame()
{
    local PKPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.WriteEndGameInformations();        
    }    
    //return;    
}

simulated function InitializeTarotUnlockingSystem()
{
    local int I;

    GoldenCardCanBeUnlocked = UnlockCardStatusPerMap[ChapterNum].GoldenCard;
    SilverCardCanBeUnlocked = UnlockCardStatusPerMap[ChapterNum].SilverCard;
    // End:0x11E
    if((ChapterNum == 17) || ChapterNum == 19)
    {
        I = 0;
        J0x8D:

        // End:0xC1 [Loop If]
        if(I < 3)
        {
            SelectedGoldCards[I] = 0;
            I++;
            // [Loop Continue]
            goto J0x8D;
        }
        I = 0;
        J0xCC:

        // End:0x100 [Loop If]
        if(I < 2)
        {
            SelectedSilverCards[I] = 0;
            I++;
            // [Loop Continue]
            goto J0xCC;
        }
        // End:0x11E
        if(ChapterNum == 19)
        {
            SelectedGoldCards[0] = 2;
        }
    }
    //return;    
}

function TryUnlockTarotCards(optional bool bIgnoreStaticUnlockCheck = false)
{
    local PKPlayerController PC;
    local PKTarotManager.ECardUnlockResult SilverCardUnlockStatus, GoldenCardUnlockStatus;

    // End:0x88
    if((int(GoldenCardCanBeUnlocked) != int(0)) && !UnlockCardStatusPerMap[ChapterNum].bGoldStaticUnlock || bIgnoreStaticUnlockCheck)
    {
        GoldenCardUnlockStatus = Class'PKTarotManager'.static.TryUnlockGoldCard(GoldenCardCanBeUnlocked);
    }
    // End:0x10B
    if((int(SilverCardCanBeUnlocked) != int(0)) && !UnlockCardStatusPerMap[ChapterNum].bSilverStaticUnlock || bIgnoreStaticUnlockCheck)
    {
        SilverCardUnlockStatus = Class'PKTarotManager'.static.TryUnlockSilverCard(SilverCardCanBeUnlocked);
    }
    // End:0x1B8
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0x17B
        if(int(GoldenCardUnlockStatus) == int(1))
        {
            PC.ClientUnlockGoldCard(GoldenCardCanBeUnlocked);
        }
        // End:0x1B7
        if(int(SilverCardUnlockStatus) == int(1))
        {
            PC.ClientUnlockSilverCard(SilverCardCanBeUnlocked);
        }        
    }    
    TryUnlockDLCAchievement(bIgnoreStaticUnlockCheck);
    //return;    
}

simulated function PKAchievements.EPKGameAchievements GetAchievementIDForDLCMap(PKTypes.ELevelID levelid)
{
    local PKAchievements.EPKGameAchievements Result;

    Result = 0;
    switch(levelid)
    {
        // End:0x33
        case 24:
            Result = 71;
            // End:0xA6
            break;
        // End:0x47
        case 22:
            Result = 72;
            // End:0xA6
            break;
        // End:0x5B
        case 26:
            Result = 73;
            // End:0xA6
            break;
        // End:0x6F
        case 33:
            Result = 76;
            // End:0xA6
            break;
        // End:0x83
        case 35:
            Result = 77;
            // End:0xA6
            break;
        // End:0x97
        case 38:
            Result = 78;
            // End:0xA6
            break;
        // End:0xFFFF
        default:
            Result = 0;
            break;
    }
    return Result;
    //return ReturnValue;    
}

simulated function TryUnlockDLCAchievement(optional bool bIgnoreStaticUnlockCheck = false)
{
    local PKPlayerController PC;
    local PKAchievements.EPKGameAchievements AchievID;
    local bool bUnlockAchiev;

    AchievID = GetAchievementIDForDLCMap(byte(ChapterNum));
    // End:0x3A
    if(int(AchievID) == int(0))
    {
        return;
    }
    switch(AchievID)
    {
        // End:0x74
        case 71:
            bUnlockAchiev = MonstersKilled >= TotalMonsters;
            // End:0x13C
            break;
        // End:0x91
        case 72:
            bUnlockAchiev = bIgnoreStaticUnlockCheck;
            // End:0x13C
            break;
        // End:0xB8
        case 73:
            bUnlockAchiev = SecretsFound >= TotalSecrets;
            // End:0x13C
            break;
        // End:0xDF
        case 76:
            bUnlockAchiev = HolyItemsFound >= TotalHolyItems;
            // End:0x13C
            break;
        // End:0x106
        case 77:
            bUnlockAchiev = ObjectsDestroyed >= TotalObjects;
            // End:0x13C
            break;
        // End:0x12D
        case 78:
            bUnlockAchiev = AmmoFound >= TotalAmmo;
            // End:0x13C
            break;
        // End:0xFFFF
        default:
            bUnlockAchiev = false;
            break;
    }
    // End:0x1A8
    if(bUnlockAchiev)
    {
        // End:0x1A7
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            PC.ClientUnlockAchievement(AchievID);            
        }        
    }
    //return;    
}

reliable server function ShowAndWriteLevelStatistics()
{
    local PKGame PKG;
    local PKGameSP PKGSP;
    local PainGRI PKGRI;
    local PKPlayerController PC;
    local LevelStatistics ls;
    local int CoopPlayersCounter;

    PKG = PKGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    PKGRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    PKGSP = PKGameSP(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    CopyGlobalStatisticsToLevelStatisticsStruct(ls);
    ls.TotalGold = ls.TotalGold * ((PKG.bGreedCardEnabled) ? 2 : 1);
    Finished = true;
    ClearTimer('TryUnlockTarotCards');
    TryUnlockTarotCards(true);
    // End:0x275
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        CoopPlayersCounter++;
        // End:0x20C
        if(PC.Pawn != none)
        {
            PC.Pawn.ZeroMovementVariables();
        }
        PC.ClientShowEndStatisticsScreen();
        PC.WriteEndLevelStatistics(byte(ChapterNum), PKGRI.IsCoopMultiplayerGame());        
    }    
    // End:0x312
    if(((CoopPlayersCounter > 1) && PKGSP != none) && PKGSP.CoopPlayersAreAliveAndWell)
    {
        // End:0x311
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            PC.ClientUnlockAchievement(52);            
        }        
    }
    //return;    
}

defaultproperties
{
    UnlockCardStatusPerMap[0]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[1]=(GoldenCard=EGoldenTarrotCard.CARD_G_ENDURANCE,bGoldStaticUnlock=true,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[2]=(GoldenCard=EGoldenTarrotCard.CARD_G_SPEED,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_VITALITY,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[3]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_SOULKEEPER,bSilverStaticUnlock=true)
    UnlockCardStatusPerMap[4]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_BLESSING,bSilverStaticUnlock=true)
    UnlockCardStatusPerMap[5]=(GoldenCard=EGoldenTarrotCard.CARD_G_DOUBLEHASTE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_DARKSOUL,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[6]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_SOULCATCHER,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[7]=(GoldenCard=EGoldenTarrotCard.CARD_G_TRIPLEHASTE,bGoldStaticUnlock=true,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[8]=(GoldenCard=EGoldenTarrotCard.CARD_G_TIMEBONUS,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_SOULREDEEMER,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[9]=(GoldenCard=EGoldenTarrotCard.CARD_G_IRONWILL,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_GREED,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[10]=(GoldenCard=EGoldenTarrotCard.CARD_G_DEXTERITY,bGoldStaticUnlock=true,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[11]=(GoldenCard=EGoldenTarrotCard.CARD_G_FURY,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_DIVINEINTERVENTION,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[12]=(GoldenCard=EGoldenTarrotCard.CARD_G_DOUBLETIMEBONUS,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_REPLENISH,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[13]=(GoldenCard=EGoldenTarrotCard.CARD_G_RAGE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_MERCY,bSilverStaticUnlock=true)
    UnlockCardStatusPerMap[14]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_LASTBREATH,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[15]=(GoldenCard=EGoldenTarrotCard.CARD_G_CONFUSION,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[16]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_FORGIVENESS,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[17]=(GoldenCard=EGoldenTarrotCard.CARD_G_HASTE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[18]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[19]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[20]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[21]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[22]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[23]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[24]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[25]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[26]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[27]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[28]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[29]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[30]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[31]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[32]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[33]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[34]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[35]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[36]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[37]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[38]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[39]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
    UnlockCardStatusPerMap[40]=(GoldenCard=EGoldenTarrotCard.CARD_G_NONE,bGoldStaticUnlock=false,SilverCard=ESilverTarrotCard.CARD_S_NONE,bSilverStaticUnlock=false)
}