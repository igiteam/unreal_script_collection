class PainPRI extends EvilPlayerReplicationInfo
    hidecategories(Navigation,Movement,Collision);

var class<PainDifficultySettings> Difficulty;
var class<EvilFamilyInfoBase> SecondPlayerCharClassInfo;
var int ArmourFound;
var int AmmoFound;
var int BonusItems;
var int HolyItems;
var int SecretsFound;
var int MonstersKilled;
var int MonstersGibbed;
var int MonstersKilledInDeamonMode;
var int PlayerMoney;
var int PlayerMoneyFound;
var int TotalArmourFound;
var int SoulsCollected;
var int DestroyedObjects;
var bool bQuadDamage;
var bool bPentagram;
var bool bHasWeaponModifier;
var bool bInLiveParty;
var bool bIsGuest;
var bool bIsTalking;
var int PlayerCoinsFound;
var int CharacterSkinIndex;
var int GoldenCardsUseLeft;
var int LuciferComments;
var protected transient int StatOfScoreFlag;
var protected transient int StatsOfReturnedFlag;
var protected transient int StatOfDeaths;
var protected transient int StatOfKills;
var protected transient int TotalKillsWritten;
var protected transient int TotalDeathsWritten;
var protected transient int TotalScoreFlagWritten;
var protected transient int TotalScoreReturnFlagWritten;
var array<string> CharactersMP;
var PKCharacterStore CharacterStore;
var repnotify UniqueNetId PartyOwnerUniqueId;
var float LastTalkTime;

replication
{
    // Pos:0x000
    if(bNetDirty)
        Difficulty, PartyOwnerUniqueId, 
        StatOfDeaths, StatOfKills, 
        StatOfScoreFlag, StatsOfReturnedFlag, 
        bHasWeaponModifier, bPentagram, 
        bQuadDamage;

    // Pos:0x00A
    if(bNetOwner)
        AmmoFound, ArmourFound, 
        BonusItems, CharacterSkinIndex, 
        DestroyedObjects, GoldenCardsUseLeft, 
        HolyItems, MonstersGibbed, 
        MonstersKilled, MonstersKilledInDeamonMode, 
        PlayerCoinsFound, PlayerMoney, 
        PlayerMoneyFound, SecretsFound, 
        SoulsCollected, TotalArmourFound;
}

simulated event PostBeginPlay()
{
    local PKPlayerController PC;

    CharacterStore = new (self) Class'PKCharacterStore';
    CharacterStore.__LoadComplete__Delegate = FamilyInfoLoaded;
    // End:0x1A1
    if(int(Role) == int(ROLE_Authority))
    {
        Difficulty = Class'PainDifficultySettings'.static.GetServerPlayerDifficultyLevel(WorldInfo);
        GoldenCardsUseLeft = PKGame(WorldInfo.Game).GoldenCardsUseLeft;
        // End:0x1A1
        if(WorldInfo.GRI.IsCoopMultiplayerGame())
        {
            // End:0x1A0
            foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
            {
                // End:0x19F
                if(PainPRI(PC.PlayerReplicationInfo).CharClassInfo == CharClassInfo)
                {
                    CharClassInfo = SecondPlayerCharClassInfo;
                    // End:0x1A0
                    break;
                }                
            }            
        }
    }
    super(PlayerReplicationInfo).PostBeginPlay();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    //return;    
}

function FamilyInfoLoaded(class<PKFamilyInfoBase> LoadedClass)
{
    CharClassInfo = LoadedClass;
    //return;    
}

simulated function SetupPlayerCharacter(int characterIndex)
{
    // End:0x6E
    if((characterIndex >= 0) && characterIndex < CharactersMP.Length)
    {
        CharacterSkinIndex = characterIndex;
        CharacterStore.LoadFamilyInfoClass(CharactersMP[characterIndex]);
    }
    //return;    
}

simulated function RegisterPlayerWithParty()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings PartySettings;
    local UniqueNetId ZeroId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x183
    if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && PartyOwnerUniqueId != ZeroId) && UniqueId != ZeroId)
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x183
        if((PartySettings != none) && PartySettings.OwningPlayerId == PartyOwnerUniqueId)
        {
            OnlineSub.GameInterface.RegisterPlayer('Party', UniqueId, true);
        }
    }
    //return;    
}

simulated function UnregisterPlayerFromParty()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings PartySettings;
    local UniqueNetId ZeroId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x12D
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && UniqueId != ZeroId)
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x12D
        if(PartySettings != none)
        {
            OnlineSub.GameInterface.UnregisterPlayer('Party', UniqueId);
        }
    }
    //return;    
}

function ScoreMonsterKilled()
{
    MonstersKilled++;
    PainGRI(WorldInfo.GRI).ScoreMonsterKilled();
    // End:0xE3
    if(PKPlayerController(Owner) != none)
    {
        PKPlayerController(Owner).IncrementGlobalIntStat(113);
        // End:0xE3
        if(PKPlayerController(Owner).IsDemon())
        {
            PKPlayerController(Owner).IncrementGlobalIntStat(131, 1);
        }
    }
    //return;    
}

function ScoreMonsterGibbed()
{
    MonstersGibbed++;
    // End:0x75
    if(PainGRI_SP(WorldInfo.GRI) != none)
    {
        PainGRI_SP(WorldInfo.GRI).IncrementGibbedPawns();
    }
    //return;    
}

function ScoreArmourTaken()
{
    ArmourFound++;
    PainGRI(WorldInfo.GRI).ScoreArmourTaken();
    // End:0x8C
    if(PKPlayerController(Owner) != none)
    {
        PKPlayerController(Owner).IncrementGlobalIntStat(121, 1);
    }
    //return;    
}

function ScoreAmmoTaken()
{
    AmmoFound++;
    PainGRI(WorldInfo.GRI).ScoreAmmoTaken();
    // End:0x8C
    if(PKPlayerController(Owner) != none)
    {
        PKPlayerController(Owner).IncrementGlobalIntStat(117, 1);
    }
    //return;    
}

function ScoreMoneyTaken(int MoneyToAdd)
{
    // End:0x4F
    if(PKGame(WorldInfo.Game).bGreedCardEnabled)
    {
        MoneyToAdd *= float(2);
    }
    PlayerCoinsFound++;
    PlayerMoney += MoneyToAdd;
    PlayerMoneyFound += MoneyToAdd;
    PainGRI(WorldInfo.GRI).ScoreGold(MoneyToAdd);
    //return;    
}

function ScoreBonusItemTaken(int BonusItemValue, bool bFromFallenEnemy)
{
    local int MoneyValue;

    // End:0x91
    if(bFromFallenEnemy)
    {
        switch(Difficulty.default.DifficultyLevel)
        {
            // End:0x53
            case 1:
                BonusItemValue = BonusItemValue + 1;
                // End:0x91
                break;
            // End:0x72
            case 2:
                BonusItemValue = BonusItemValue + 2;
                // End:0x91
                break;
            // End:0x8E
            case 3:
                BonusItemValue = BonusItemValue + 3;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        BonusItems += BonusItemValue;
        // End:0xF8
        if(bFromFallenEnemy)
        {
            PainGRI(WorldInfo.GRI).ScoreBonusItemFromFallenEnemy(BonusItemValue);
        }
        MoneyValue = BonusItemValue * ((PKGame(WorldInfo.Game).bGreedCardEnabled) ? 2 : 1);
        PlayerMoney += MoneyValue;
        PlayerMoneyFound += MoneyValue;
        PainGRI(WorldInfo.GRI).ScoreGold(MoneyValue);
        PainGRI(WorldInfo.GRI).ScoreBonusItemTaken(BonusItemValue);
        // End:0x261
        if((PKPlayerController(Owner) != none) && bFromFallenEnemy)
        {
            PKPlayerController(Owner).IncrementGlobalIntStat(137, MoneyValue);
        }
        //return;        
    }
}

function ScoreHolyItemTaken()
{
    HolyItems++;
    PainGRI(WorldInfo.GRI).ScoreHolyItemTaken();
    // End:0x8C
    if(PKPlayerController(Owner) != none)
    {
        PKPlayerController(Owner).IncrementGlobalIntStat(140);
    }
    //return;    
}

function ScoreSecretFound()
{
    SecretsFound++;
    PainGRI(WorldInfo.GRI).ScoreSecretFound();
    //return;    
}

function ScoreSoulTaken(optional PainPRI Source = none, optional bool bMonsterWasGibbed = false)
{
    PainGRI(WorldInfo.GRI).ScoreSoulTaken();
    SoulsCollected++;
    // End:0x10B
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x10B
        if(PKPlayerController(Owner) != none)
        {
            PKPlayerController(Owner).OnSoulTaken();
            PKPlayerController(Owner).IncrementGlobalIntStat(116);
            // End:0x10B
            if(bMonsterWasGibbed)
            {
                PKPlayerController(Owner).IncrementGlobalIntStat(135);
            }
        }
    }
    //return;    
}

function ScoreDestroyedObject()
{
    PainGRI(WorldInfo.GRI).ScoreDestroyedObject();
    DestroyedObjects++;
    //return;    
}

simulated function int GetDeltaStat(int TotalStat, out int CounterStat)
{
    local int Delta;

    Delta = Max(TotalStat - Max(CounterStat, 0), 0);
    CounterStat = TotalStat;
    return Delta;
    //return ReturnValue;    
}

simulated function int GetDeathsSinceLastWrite()
{
    return GetDeltaStat(StatOfDeaths, TotalDeathsWritten);
    //return ReturnValue;    
}

simulated function int GetKillsSinceLastWrite()
{
    return GetDeltaStat(StatOfKills, TotalKillsWritten);
    //return ReturnValue;    
}

simulated function int GetFlagsCapturedSinceLastWrite()
{
    return GetDeltaStat(StatOfScoreFlag, TotalScoreFlagWritten);
    //return ReturnValue;    
}

simulated function int GetFlagsReturnedSinceLastWrite()
{
    return GetDeltaStat(StatsOfReturnedFlag, TotalScoreReturnFlagWritten);
    //return ReturnValue;    
}

function int IncrementKillStat(name NewStatName)
{
    StatOfKills++;
    return 1;
    //return ReturnValue;    
}

function int IncrementDeathStat(name NewStatName)
{
    StatOfDeaths++;
    return 1;
    //return ReturnValue;    
}

function int IncrementCapturedFlagsStat()
{
    StatOfScoreFlag++;
    return 1;
    //return ReturnValue;    
}

function int IncrementReturnedFlagStat()
{
    StatsOfReturnedFlag++;
    return 1;
    //return ReturnValue;    
}

simulated function CopyLevelStatsToLevelStatsStruct(out LevelStatistics ls)
{
    local PainGRI GRI;

    GRI = PainGRI(WorldInfo.GRI);
    ls.GameplayTime = GRI.GameplayTime;
    ls.Difficulty = Difficulty.default.DifficultyLevel;
    ls.MonstersKilled = MonstersKilled;
    ls.SoulsCollected = SoulsCollected;
    ls.ArmorsFound = ArmourFound;
    ls.GoldFound = PlayerMoney;
    ls.BonusItems = BonusItems;
    ls.HolyItemsFound = HolyItems;
    ls.AmmoFound = AmmoFound;
    ls.ObjectsDestroyed = DestroyedObjects;
    ls.SecretsFound = SecretsFound;
    ls.TotalMonsters = GRI.TotalMonsters;
    ls.TotalSouls = GRI.TotalSouls;
    ls.TotalArmors = GRI.TotalArmors;
    ls.TotalGold = GRI.TotalGold;
    ls.TotalHolyItems = GRI.TotalHolyItems;
    ls.TotalAmmo = GRI.TotalAmmo;
    ls.TotalObjects = GRI.TotalObjects;
    ls.TotalSecrets = GRI.TotalSecrets;
    //return;    
}

defaultproperties
{
    SecondPlayerCharClassInfo=Class'PKFamilyInfo_Eve'
    CharactersMP[0]="PKHDGame.PKFamilyInfo_MainHero"
    CharactersMP[1]="PKHDGame.PKFamilyInfo_Eve"
    CharactersMP[2]="PKHDGameContent.PKFamilyInfo_EvilMonk"
    CharactersMP[3]="PKHDGameContent.PKFamilyInfo_Hellangel"
    CharactersMP[4]="PKHDGameContent.PKFamilyInfo_BlackDemon"
    CharactersMP[5]="PKHDGameContent.PKFamilyInfo_Sado"
    CharactersMP[6]="PKHDGameContent.PKFamilyInfo_Samurai"
    CharactersMP[7]="PKHDGameContent.PKFamilyInfo_SkeletonSoldier"
    CharactersMP[8]="PKHDGameContent.PKFamilyInfo_Banshee"
    CharactersMP[9]="PKHDGameContent.PKFamilyInfo_Sensei"
    CharactersMP[10]="PKHDGameContent.PKFamilyInfo_GrimReaper"
    CharactersMP[11]="PKHDGameContent.PKFamilyInfo_Pinokio"
    CharactersMP[12]="PKHDGameContent.PKFamilyInfo_Giant"
    CharactersMP[13]="PKHDGameContent.PKFamilyInfo_DevilMonk"
    CharactersMP[14]="PKHDGameContent.PKFamilyInfo_WhiteDemon"
    CharactersMP[15]="PKHDGameContent.PKFamilyInfo_AssasinGreed"
    CharactersMP[16]="PKHDGameContent.PKFamilyInfo_Leper"
    CharactersMP[17]="PKHDGameContent.PKFamilyInfo_WalkingDead"
    LastTalkTime=-5.0000000
    CharClassInfo=Class'PKFamilyInfo_MainHero'
}