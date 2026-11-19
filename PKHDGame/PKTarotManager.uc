class PKTarotManager extends Object;

enum EGoldenTarrotCard
{
    CARD_G_NONE,                    // 0
    CARD_G_ENDURANCE,               // 1
    CARD_G_HASTE,                   // 2
    CARD_G_TIMEBONUS,               // 3
    CARD_G_SPEED,                   // 4
    CARD_G_FURY,                    // 5
    CARD_G_DOUBLEHASTE,             // 6
    CARD_G_DEXTERITY,               // 7
    CARD_G_IRONWILL,                // 8
    CARD_G_RAGE,                    // 9
    CARD_G_DOUBLETIMEBONUS,         // 10
    CARD_G_TRIPLEHASTE,             // 11
    CARD_G_CONFUSION,               // 12
    CARD_G_DLC1,                    // 13
    CARD_G_DLC2,                    // 14
    CARD_G_DLC3,                    // 15
    CARD_G_DLC4,                    // 16
    CARD_G_DLC5,                    // 17
    CARD_G_MAX                      // 18
};

enum ESilverTarrotCard
{
    CARD_S_NONE,                    // 0
    CARD_S_SOULKEEPER,              // 1
    CARD_S_BLESSING,                // 2
    CARD_S_REPLENISH,               // 3
    CARD_S_DARKSOUL,                // 4
    CARD_S_SOULCATCHER,             // 5
    CARD_S_FORGIVENESS,             // 6
    CARD_S_GREED,                   // 7
    CARD_S_VITALITY,                // 8
    CARD_S_DIVINEINTERVENTION,      // 9
    CARD_S_LASTBREATH,              // 10
    CARD_S_SOULREDEEMER,            // 11
    CARD_S_MERCY,                   // 12
    CARD_S_DLC1_FEAR,               // 13
    CARD_S_DLC2_HEALTHSTEALER,      // 14
    CARD_S_DLC3_ARMORREGEN,         // 15
    CARD_S_DLC4_666AMMO,            // 16
    CARD_S_DLC5_HEALHREGEN,         // 17
    CARD_S_MAX                      // 18
};

enum ECardUnlockResult
{
    ECUR_Locked,                    // 0
    ECUR_Unlocked,                  // 1
    ECUR_AlreadyUnlocked,           // 2
    ECUR_MAX                        // 3
};

struct UnlockCardStatus
{
    var PKTarotManager.EGoldenTarrotCard GoldenCard;
    var bool bGoldStaticUnlock;
    var PKTarotManager.ESilverTarrotCard SilverCard;
    var bool bSilverStaticUnlock;

    structdefaultproperties
    {
        GoldenCard=EGoldenTarrotCard.CARD_G_NONE
        bGoldStaticUnlock=false
        SilverCard=ESilverTarrotCard.CARD_S_NONE
        bSilverStaticUnlock=false
    }
};

struct TarrotCardInfo
{
    var const localized string CardName;
    var const localized string CardDesc;
    var const localized string UnlockCriteria;
    var int Cost;

    structdefaultproperties
    {
        CardName=""
        CardDesc=""
        UnlockCriteria=""
        Cost=0
    }
};

var array<TarrotCardInfo> GoldenCardsList;
var array<TarrotCardInfo> SilverCardsList;
var array<int> UnlockGCounters;
var array<int> UnlockSCounters;

static simulated function PKTarotManager.ECardUnlockResult TryUnlockSilverCard(PKTarotManager.ESilverTarrotCard cardID)
{
    local PKTarotManager.ECardUnlockResult bResult;
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    bResult = 0;
    switch(cardID)
    {
        // End:0xA8
        case 1:
            // End:0xA5
            if(GRI.GameplayTime < default.UnlockSCounters[1])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0xEB
        case 2:
            // End:0xE8
            if(GRI.GameplayTime < default.UnlockSCounters[2])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x12E
        case 3:
            // End:0x12B
            if(GRI.DemonModeStarts == default.UnlockSCounters[3])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x183
        case 4:
            // End:0x180
            if(GRI.SecretsFound == GRI.TotalSecrets)
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x1C6
        case 5:
            // End:0x1C3
            if(GRI.PawnsDetachedLimbs >= default.UnlockSCounters[5])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x209
        case 6:
            // End:0x206
            if(GRI.MonstersKilledInDeamonMode >= default.UnlockSCounters[6])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x25E
        case 7:
            // End:0x25B
            if(GRI.MonstersKilled == GRI.TotalMonsters)
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x2A1
        case 8:
            // End:0x29E
            if(GRI.GoldFound >= default.UnlockSCounters[8])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x2E4
        case 9:
            // End:0x2E1
            if(GRI.MonstersPossessedBySoulCatcher >= default.UnlockSCounters[9])
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x339
        case 10:
            // End:0x336
            if(GRI.SecretsFound == GRI.TotalSecrets)
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x38E
        case 11:
            // End:0x38B
            if(GRI.HolyItemsFound == GRI.TotalHolyItems)
            {
                bResult = 1;
            }
            // End:0x3AF
            break;
        // End:0x3A2
        case 12:
            bResult = 1;
            // End:0x3AF
            break;
        // End:0xFFFF
        default:
            ScriptTrace();
            break;
    }
    return bResult;
    //return ReturnValue;    
}

static simulated function PKTarotManager.ECardUnlockResult TryUnlockGoldCard(PKTarotManager.EGoldenTarrotCard cardID)
{
    local PKTarotManager.ECardUnlockResult bResult;
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    bResult = 0;
    switch(cardID)
    {
        // End:0x7A
        case 1:
            bResult = 1;
            // End:0x393
            break;
        // End:0xCF
        case 2:
            // End:0xCC
            if(GRI.ObjectsDestroyed == GRI.TotalObjects)
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x112
        case 3:
            // End:0x10F
            if(GRI.GibbedPawns >= default.UnlockGCounters[3])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x155
        case 4:
            // End:0x152
            if(GRI.BonusItemsFromFallenEnemy >= default.UnlockGCounters[4])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x18D
        case 5:
            // End:0x18A
            if(GRI.ThreeEnemiesKilledByOneSoulSaw >= 1)
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x1D0
        case 6:
            // End:0x1CD
            if(GRI.SoulsCollected >= default.UnlockGCounters[6])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x213
        case 7:
            // End:0x210
            if(GRI.GameplayTime < default.UnlockGCounters[7])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x256
        case 8:
            // End:0x253
            if(GRI.GibbedFrozenMonsters >= default.UnlockGCounters[8])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x2AB
        case 9:
            // End:0x2A8
            if(GRI.HolyItemsFound == GRI.TotalHolyItems)
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x300
        case 10:
            // End:0x2FD
            if(GRI.AmmoFound == GRI.TotalAmmo)
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x343
        case 11:
            // End:0x340
            if(GRI.GameplayTime < default.UnlockGCounters[11])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0x386
        case 12:
            // End:0x383
            if(GRI.DemonModeStarts == default.UnlockGCounters[12])
            {
                bResult = 1;
            }
            // End:0x393
            break;
        // End:0xFFFF
        default:
            ScriptTrace();
            break;
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    GoldenCardsList[0]=(CardName="NONE",CardDesc="NONE",UnlockCriteria="NONE",Cost=0)
    GoldenCardsList[1]=(CardName="Endurance",CardDesc="Take only half of the damage",UnlockCriteria="Beat the level",Cost=100)
    GoldenCardsList[2]=(CardName="Haste",CardDesc="The world moves 2x slower",UnlockCriteria="Destroy all objects",Cost=100)
    GoldenCardsList[3]=(CardName="Time Bonus",CardDesc="Golden Cards last 10 seconds longer",UnlockCriteria="Gib 123 enemies",Cost=100)
    GoldenCardsList[4]=(CardName="Speed",CardDesc="Move faster",UnlockCriteria="Collect 330 pieces of gold dropped by enemies",Cost=100)
    GoldenCardsList[5]=(CardName="Fury",CardDesc="Deliver 2x more damage",UnlockCriteria="Kill 3 monsters in a row using saw blade",Cost=200)
    GoldenCardsList[6]=(CardName="Double Haste",CardDesc="The world moves 4x slower",UnlockCriteria="Collect 100 souls",Cost=300)
    GoldenCardsList[7]=(CardName="Dexterity ",CardDesc="Weapons reload 2x faster",UnlockCriteria="Kill Swamp Thing in under 4:00",Cost=300)
    GoldenCardsList[8]=(CardName="Iron Will",CardDesc="Enemies can't hurt you",UnlockCriteria="Gib 50 frozen enemies",Cost=666)
    GoldenCardsList[9]=(CardName="Rage",CardDesc="Deliver 4x more damage",UnlockCriteria="Collect all Holy Items",Cost=500)
    GoldenCardsList[10]=(CardName="Double Time Bonus",CardDesc="Golden Cards last 20 seconds longer",UnlockCriteria="Pick up every ammo box",Cost=300)
    GoldenCardsList[11]=(CardName="Triple Haste",CardDesc="The world moves 8x slower",UnlockCriteria="Kill Alastor in under 5:00",Cost=500)
    GoldenCardsList[12]=(CardName="Confusion",CardDesc="Confuse enemies",UnlockCriteria="Morph into demon 3 times",Cost=200)
    GoldenCardsList[13]=(CardName="",CardDesc="",UnlockCriteria="",Cost=0)
    GoldenCardsList[14]=(CardName="",CardDesc="",UnlockCriteria="",Cost=0)
    GoldenCardsList[15]=(CardName="",CardDesc="",UnlockCriteria="",Cost=0)
    GoldenCardsList[16]=(CardName="",CardDesc="",UnlockCriteria="",Cost=0)
    GoldenCardsList[17]=(CardName="",CardDesc="",UnlockCriteria="",Cost=0)
    SilverCardsList[0]=(CardName="NONE",CardDesc="NONE",UnlockCriteria="NONE",Cost=0)
    SilverCardsList[1]=(CardName="Soul Keeper",CardDesc="Souls stay longer",UnlockCriteria="Finish level in under 7:00",Cost=500)
    SilverCardsList[2]=(CardName="Blessing",CardDesc="Increase the initial health to 150",UnlockCriteria="Kill Necrogiant in under 2:00",Cost=200)
    SilverCardsList[3]=(CardName="Replenish",CardDesc="Double the ammo in ammo boxes",UnlockCriteria="Morph into demon 3 times",Cost=500)
    SilverCardsList[4]=(CardName="Dark Soul",CardDesc="Morph into demon form at every 50 souls",UnlockCriteria="Find all secret areas",Cost=400)
    SilverCardsList[5]=(CardName="Soul Catcher",CardDesc="Leech souls from a distance",UnlockCriteria="Cut limbs of 100 enemies using Soul Catcher",Cost=500)
    SilverCardsList[6]=(CardName="Forgiveness",CardDesc="You can use Golden Cards two times per level",UnlockCriteria="Kill 30 enemies in demon mode",Cost=1000)
    SilverCardsList[7]=(CardName="Greed",CardDesc="Double the amount of hidden wealth",UnlockCriteria="Kill all monsters",Cost=2000)
    SilverCardsList[8]=(CardName="Vitality",CardDesc="Increase base health capacity to 150",UnlockCriteria="Collect 500 gold",Cost=100)
    SilverCardsList[9]=(CardName="Divine Intervention",CardDesc="All Cards can be placed for free",UnlockCriteria="Possess 25 enemies using Soul Catcher",Cost=0)
    SilverCardsList[10]=(CardName="Last Breath",CardDesc="Health regeneration when you`re dying",UnlockCriteria="Find all secret areas",Cost=500)
    SilverCardsList[11]=(CardName="Soul Redeemer",CardDesc="Souls provide more health",UnlockCriteria="Collect all Holy Items",Cost=1000)
    SilverCardsList[12]=(CardName="Mercy",CardDesc="You can use Golden Cards three times per level",UnlockCriteria="Kill Grim Reaper",Cost=2000)
    SilverCardsList[13]=(CardName="Fear",CardDesc="Enemies have 90% of their initial health",UnlockCriteria="",Cost=0)
    SilverCardsList[14]=(CardName="Health Stealer",CardDesc="2.5% of the damage to the enemy goes to player's health",UnlockCriteria="",Cost=0)
    SilverCardsList[15]=(CardName="Armor Regeneration",CardDesc="Armor starts regenerating 10 seconds after last damage",UnlockCriteria="",Cost=0)
    SilverCardsList[16]=(CardName="666 Ammo",CardDesc="Start the level with 666 ammo for all weapons",UnlockCriteria="",Cost=0)
    SilverCardsList[17]=(CardName="Health Regeneration",CardDesc="Health starts regenerating 10 seconds after last damage",UnlockCriteria="",Cost=0)
    UnlockGCounters[0]=0
    UnlockGCounters[1]=0
    UnlockGCounters[2]=0
    UnlockGCounters[3]=123
    UnlockGCounters[4]=330
    UnlockGCounters[5]=1
    UnlockGCounters[6]=100
    UnlockGCounters[7]=240
    UnlockGCounters[8]=50
    UnlockGCounters[9]=0
    UnlockGCounters[10]=0
    UnlockGCounters[11]=300
    UnlockGCounters[12]=3
    UnlockSCounters[0]=0
    UnlockSCounters[1]=420
    UnlockSCounters[2]=120
    UnlockSCounters[3]=3
    UnlockSCounters[4]=0
    UnlockSCounters[5]=100
    UnlockSCounters[6]=30
    UnlockSCounters[7]=0
    UnlockSCounters[8]=500
    UnlockSCounters[9]=25
}