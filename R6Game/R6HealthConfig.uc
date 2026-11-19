class R6HealthConfig extends R6Config
    native
    hidecategories(Object);

struct sArmorCategoryInfo
{
    var() editconst R6EngineEnums.EArmorPieceCategory m_eType;
    var() float m_fEncumbrance;

    structdefaultproperties
    {
        m_eType=0
        m_fEncumbrance=0.0000000
    }
};

struct sArmorEncumbranceLevel
{
    var() editconst R6EngineEnums.EEncumbranceType m_eType;
    var() int m_iLevel;
    var() float m_fMaxVel;
    var() float m_fAbsortion;

    structdefaultproperties
    {
        m_eType=0
        m_iLevel=0
        m_fMaxVel=0.0000000
        m_fAbsortion=0.0000000
    }
};

struct sArmorPieceInfo
{
    var() editconst R6EngineEnums.EArmorPieceType m_eType;
    var() sArmorCategoryInfo m_aCategory[3];

    structdefaultproperties
    {
        m_eType=0
        m_aCategory[0]=(m_eType=0,m_fEncumbrance=0.0000000)
        m_aCategory[1]=(m_eType=1,m_fEncumbrance=0.0000000)
        m_aCategory[2]=(m_eType=2,m_fEncumbrance=0.0000000)
    }
};

struct sTerroHealthLevels
{
    var() editconst R6EngineEnums.ETerroArmorLevel m_eLevel;
    var() int m_iHealth;

    structdefaultproperties
    {
        m_eLevel=0
        m_iHealth=0
    }
};

var(Incapacitated) int m_iIncapacitatedHealth;
var(MaxHealth) int m_iMaxHealthPlayerNormal;
var(MaxHealth) int m_iMaxHealthPlayerVeteran;
var(MaxHealth) int m_iMaxHealthPlayerElite;
var(MaxHealth) int m_iMaxHealthPlayerMP;
var(MaxHealth) int m_iMaxHealthRainbowNormal;
var(MaxHealth) int m_iMaxHealthRainbowVeteran;
var(MaxHealth) int m_iMaxHealthRainbowElite;
var(MaxHealth) int m_iMaxHealthHostageMP;
var(MaxHealth) int m_iMaxHealthHostage;
var(MaxHealth) int m_iMaxHealthCivil;
var(MaxHealth) int m_iMaxHealthNPC;
var(MaxHealth) sTerroHealthLevels m_aTerroMaxHealth[4];
var(HealthStage) int m_iCriticalHealth;
var(HealthStage) int m_iCriticalHealthTerro;
var(HealthStage) int m_iCriticalHealthRainbowAI;
var(HealthStage) int m_iCriticalHealthMP;
var(HealthStage) int m_iIncapacitedHealth;
var(HealthRecovery) float m_fRecovTimerWoundedPlayerNormal;
var(HealthRecovery) float m_fRecovTimerWoundedPlayerVeteran;
var(HealthRecovery) float m_fRecovTimerWoundedPlayerElite;
var(HealthRecovery) float m_fRecovTimerWoundedRainbowNormal;
var(HealthRecovery) float m_fRecovTimerWoundedRainbowVeteran;
var(HealthRecovery) float m_fRecovTimerWoundedRainbowElite;
var(HealthRecovery) float m_fRecovTimerWoundedMP;
var(HealthRecovery) float m_fRecovTimerCriticalPlayerNormal;
var(HealthRecovery) float m_fRecovTimerCriticalPlayerVeteran;
var(HealthRecovery) float m_fRecovTimerCriticalPlayerElite;
var(HealthRecovery) float m_fRecovTimerCriticalRainbowNormal;
var(HealthRecovery) float m_fRecovTimerCriticalRainbowVeteran;
var(HealthRecovery) float m_fRecovTimerCriticalRainbowElite;
var(HealthRecovery) float m_fRecovTimerCriticalMP;
var(HealthRecovery) float m_fRecovTimerIncapacitated;
var(HealthRecovery) float m_fInvulnerableTimeAfterRevive;
var(HUD) float m_fArrowLifetime;
var(HUD) float m_fMinArrowLifetime;
var(PostProcess) float m_fHitFadeOutTime;
var(Doors) int m_iWoodHealth;
var(Doors) int m_iWoodHandleLockHealth;
var(Doors) int m_iWoodHingesHealth;
var(Doors) int m_iMetalHealth;
var(Doors) int m_iMetalHandleLockHealth;
var(Doors) int m_iMetalHingesHealth;
var(Doors) int m_iReinforcedHealth;
var(Doors) int m_iReinforcedHandleLockHealth;
var(Doors) int m_iReinforcedHingesHealth;
var(Doors) int m_iGlassHealth;
var(Doors) int m_iGlassHandleLockHealth;
var(Doors) int m_iGlassHingesHealth;
var(CollisionDamage) float m_fMinMomentumForDamage;
var(CollisionDamage) float m_fMomentumToDamageCoef;
var(Falling) int m_iMinHeightDamage;
var(Falling) int m_iMaxHeightDamage;
var(Falling) int m_iMinDamageFalling;
var(Falling) int m_iMaxDamageFalling;
var(Falling) int m_iMaxDamageForFollowing;
var(LocationBased) SLocationBasedHitPoints m_LocationBased;
var(LocationBased) float m_fDeadLimbDropDamage;
var(Armor) sArmorPieceInfo m_aArmorPieceInfo[4];
var(Armor) sArmorEncumbranceLevel m_aEncumbranceLevels[4];

// Export UR6HealthConfig::execGetArmorAbsortion(FFrame&, void* const)
native final function float GetArmorAbsortion(R6EngineEnums.EEncumbranceType EType);

defaultproperties
{
    m_iIncapacitatedHealth=50
    m_iMaxHealthPlayerNormal=200
    m_iMaxHealthPlayerVeteran=160
    m_iMaxHealthPlayerElite=120
    m_iMaxHealthPlayerMP=100
    m_iMaxHealthRainbowNormal=200
    m_iMaxHealthRainbowVeteran=160
    m_iMaxHealthRainbowElite=120
    m_iMaxHealthHostageMP=100
    m_iMaxHealthHostage=100
    m_iMaxHealthCivil=100
    m_iMaxHealthNPC=100
    m_aTerroMaxHealth[0]=(m_eLevel=0,m_iHealth=80)
    m_aTerroMaxHealth[1]=(m_eLevel=1,m_iHealth=100)
    m_aTerroMaxHealth[2]=(m_eLevel=2,m_iHealth=120)
    m_aTerroMaxHealth[3]=(m_eLevel=3,m_iHealth=140)
    m_iCriticalHealth=30
    m_iCriticalHealthTerro=30
    m_iCriticalHealthRainbowAI=30
    m_iCriticalHealthMP=30
    m_fRecovTimerWoundedPlayerNormal=4.0000000
    m_fRecovTimerWoundedPlayerVeteran=6.0000000
    m_fRecovTimerWoundedPlayerElite=8.0000000
    m_fRecovTimerWoundedRainbowNormal=4.0000000
    m_fRecovTimerWoundedRainbowVeteran=6.0000000
    m_fRecovTimerWoundedRainbowElite=8.0000000
    m_fRecovTimerWoundedMP=4.0000000
    m_fRecovTimerCriticalPlayerNormal=4.0000000
    m_fRecovTimerCriticalPlayerVeteran=6.0000000
    m_fRecovTimerCriticalPlayerElite=8.0000000
    m_fRecovTimerCriticalRainbowNormal=4.0000000
    m_fRecovTimerCriticalRainbowVeteran=6.0000000
    m_fRecovTimerCriticalRainbowElite=8.0000000
    m_fRecovTimerCriticalMP=30.0000000
    m_fRecovTimerIncapacitated=60.0000000
    m_fInvulnerableTimeAfterRevive=5.0000000
    m_fArrowLifetime=2.0000000
    m_fMinArrowLifetime=3.0000000
    m_fHitFadeOutTime=2.0000000
    m_iWoodHealth=50
    m_iWoodHandleLockHealth=20
    m_iWoodHingesHealth=20
    m_iMetalHealth=200
    m_iMetalHandleLockHealth=50
    m_iMetalHingesHealth=100
    m_iReinforcedHealth=500
    m_iReinforcedHandleLockHealth=100
    m_iReinforcedHingesHealth=200
    m_iGlassHealth=5
    m_iGlassHandleLockHealth=20
    m_iGlassHingesHealth=20
    m_fMinMomentumForDamage=10.0000000
    m_fMomentumToDamageCoef=2.0000000
    m_iMinHeightDamage=200
    m_iMaxHeightDamage=500
    m_iMinDamageFalling=10
    m_iMaxDamageFalling=100
    m_iMaxDamageForFollowing=25
    m_LocationBased=(m_Head=(m_iHealth=0,m_fMultiplier=2.0000000),m_Chest=(m_iHealth=0,m_fMultiplier=1.0000000),m_LeftArm=(m_iHealth=30,m_fMultiplier=1.0000000),m_RightArm=(m_iHealth=30,m_fMultiplier=1.0000000),m_LeftLeg=(m_iHealth=50,m_fMultiplier=1.0000000),m_RightLeg=(m_iHealth=50,m_fMultiplier=1.0000000))
    m_fDeadLimbDropDamage=0.5000000
    m_aArmorPieceInfo[0]=(m_eType=0,m_aCategory=(m_eType=0,m_fEncumbrance=0.0000000),m_aCategory[1]=(m_eType=1,m_fEncumbrance=0.0000000),m_aCategory[2]=(m_eType=2,m_fEncumbrance=0.0000000))
    m_aArmorPieceInfo[1]=(m_eType=1,m_aCategory=(m_eType=0,m_fEncumbrance=0.0000000),m_aCategory[1]=(m_eType=1,m_fEncumbrance=0.0000000),m_aCategory[2]=(m_eType=2,m_fEncumbrance=0.0000000))
    m_aArmorPieceInfo[2]=(m_eType=2,m_aCategory=(m_eType=0,m_fEncumbrance=0.0000000),m_aCategory[1]=(m_eType=1,m_fEncumbrance=0.0000000),m_aCategory[2]=(m_eType=2,m_fEncumbrance=0.0000000))
    m_aArmorPieceInfo[3]=(m_eType=3,m_aCategory=(m_eType=0,m_fEncumbrance=0.0000000),m_aCategory[1]=(m_eType=1,m_fEncumbrance=0.0000000),m_aCategory[2]=(m_eType=2,m_fEncumbrance=0.0000000))
    m_aEncumbranceLevels[0]=(m_eType=0,m_iLevel=0,m_fMaxVel=400.0000000,m_fAbsortion=0.0000000)
    m_aEncumbranceLevels[1]=(m_eType=1,m_iLevel=6,m_fMaxVel=350.0000000,m_fAbsortion=0.1000000)
    m_aEncumbranceLevels[2]=(m_eType=2,m_iLevel=10,m_fMaxVel=300.0000000,m_fAbsortion=0.2500000)
    m_aEncumbranceLevels[3]=(m_eType=3,m_iLevel=100,m_fMaxVel=250.0000000,m_fAbsortion=0.4000000)
}