class R6DifficultyConfig extends R6Config
    native
    hidecategories(Object);

struct AIParameter
{
    var() float m_fSustainedVisionTimer;
    var() float m_fLockTimer;
    var() float m_fDefensiveTimerInputs;
    var() float m_fDefensiveTimerCap;

    structdefaultproperties
    {
        m_fSustainedVisionTimer=0.0000000
        m_fLockTimer=0.0000000
        m_fDefensiveTimerInputs=0.0000000
        m_fDefensiveTimerCap=0.0000000
    }
};

var(AI) AIParameter m_AIParameterNormal;
var(AI) AIParameter m_AIParameterVeteran;
var(AI) AIParameter m_AIParameterElite;

// Export UR6DifficultyConfig::execGetCurrentSustainedVisionTimer(FFrame&, void* const)
native final function float GetCurrentSustainedVisionTimer();

// Export UR6DifficultyConfig::execGetCurrentLockTimer(FFrame&, void* const)
native final function float GetCurrentLockTimer();

// Export UR6DifficultyConfig::execGetCurrentDefensiveTimerInputs(FFrame&, void* const)
native final function float GetCurrentDefensiveTimerInputs();

// Export UR6DifficultyConfig::execGetCurrentDefensiveTimerCap(FFrame&, void* const)
native final function float GetCurrentDefensiveTimerCap();

// Export UR6DifficultyConfig::execGetDamageToTerroModifier(FFrame&, void* const)
native final function float GetDamageToTerroModifier();

// Export UR6DifficultyConfig::execGetPlayerAccuracyModifier(FFrame&, void* const)
native final function float GetPlayerAccuracyModifier();

// Export UR6DifficultyConfig::execGetPlayerMaxHealth(FFrame&, void* const)
native final function int GetPlayerMaxHealth();

// Export UR6DifficultyConfig::execGetRainbowMaxHealth(FFrame&, void* const)
native final function int GetRainbowMaxHealth();

// Export UR6DifficultyConfig::execGetPlayerRecoveryTimerWounded(FFrame&, void* const)
native final function int GetPlayerRecoveryTimerWounded();

// Export UR6DifficultyConfig::execGetRainbowRecoveryTimerWounded(FFrame&, void* const)
native final function int GetRainbowRecoveryTimerWounded();

// Export UR6DifficultyConfig::execGetPlayerRecoveryTimerCritical(FFrame&, void* const)
native final function int GetPlayerRecoveryTimerCritical();

// Export UR6DifficultyConfig::execGetRainbowRecoveryTimerCritical(FFrame&, void* const)
native final function int GetRainbowRecoveryTimerCritical();

// Export UR6DifficultyConfig::execGetWeaponDefaultAmmo(FFrame&, void* const)
native final function int GetWeaponDefaultAmmo(Weapon Wp);

// Export UR6DifficultyConfig::execGetWeaponMaxAmmo(FFrame&, void* const)
native final function int GetWeaponMaxAmmo(Weapon Wp);

// Export UR6DifficultyConfig::execGetGadgetMaxAmmo(FFrame&, void* const)
native final function int GetGadgetMaxAmmo(Inventory Gadget);

defaultproperties
{
    m_AIParameterNormal=(m_fSustainedVisionTimer=2.0000000,m_fLockTimer=2.0000000,m_fDefensiveTimerInputs=2.0000000,m_fDefensiveTimerCap=2.0000000)
    m_AIParameterVeteran=(m_fSustainedVisionTimer=1.0000000,m_fLockTimer=1.0000000,m_fDefensiveTimerInputs=1.0000000,m_fDefensiveTimerCap=1.0000000)
    m_AIParameterElite=(m_fSustainedVisionTimer=0.5000000,m_fLockTimer=0.5000000,m_fDefensiveTimerInputs=0.5000000,m_fDefensiveTimerCap=0.5000000)
    m_szDescription="Difficulty Configuration"
}