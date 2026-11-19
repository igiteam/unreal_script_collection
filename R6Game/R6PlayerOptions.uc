class R6PlayerOptions extends R6Config
    native
    hidecategories(Object);

var() string m_szGamerTag;
var(Splitscreen) R6EngineEnums.EPlayerCharacterType m_eSplitScreenCharacterType;
var(SPDifficulty) R6EngineEnums.EGameDifficulty m_eSPDifficulty;
var(Inputs) R6EngineEnums.EThumbstickConfig m_eThumbstickConfig;
var(Inputs) R6EngineEnums.EButtonsConfig m_eButtonsConfig;
var(TerroHunt) R6EngineEnums.EGameDifficulty m_eTerroDifficulty;
var(TerroHunt) R6EngineEnums.EGameHostileDensity m_eTerroHostileDensity;
var(TerroHunt) R6EngineEnums.EGameTerroHuntTeamType m_eTerroTeamType;
var(TerroHunt) R6EngineEnums.EPlayerCharacterType m_eTerroCharacterType;
var(Weapons) array<R6EngineEnums.EWeapon> m_aUnlockedWeapons;
var(AutoAim) bool m_bAutoAimOn;
var(Adhesion) bool m_bAdhesionOn;
var(Inputs) bool m_bInvertPitch;
var(Inputs) bool m_bVibrationEnabled;
var(Tutorial) bool m_bDisplayTutorial;
var(Tutorial) bool m_bHadPlayerHealScenario;
var(Tutorial) bool m_bHadTeammateHealScenario;
var(Tutorial) bool m_bHadTakeCoverTurretScenario;
var(Sound) bool m_bUseVoiceMPBriefing;
var(Inputs) float m_fPitchSensitivity;
var(Inputs) float m_fYawSensitivity;
var(TerroHunt) int m_iTerroBestScore;
var array<int> m_aCheckpoints;
var float m_fSoundEffectsVolume;
var float m_fMusicVolume;
var float m_fVoiceVolume;
var int m_iGamma;

// Export UR6PlayerOptions::execUnlockWeapon(FFrame&, void* const)
native function UnlockWeapon(R6EngineEnums.EWeapon EWeapon);

// Export UR6PlayerOptions::execIsWeaponUnlocked(FFrame&, void* const)
native function bool IsWeaponUnlocked(R6EngineEnums.EWeapon EWeapon);

// Export UR6PlayerOptions::execApplySharedSettings(FFrame&, void* const)
native function ApplySharedSettings();

// Export UR6PlayerOptions::execGetCheckpointFileName(FFrame&, void* const)
native function string GetCheckpointFileName(int iCheckPointId);

defaultproperties
{
    m_szGamerTag="New Profile"
    m_eSPDifficulty=2
    m_eTerroDifficulty=2
    m_eTerroHostileDensity=2
    m_eTerroTeamType=1
    m_aUnlockedWeapons=/* ERROR: System.ArgumentOutOfRangeException */
    m_bAutoAimOn=true
    m_bAdhesionOn=true
    m_bVibrationEnabled=true
    m_bDisplayTutorial=true
    m_bUseVoiceMPBriefing=true
    m_fPitchSensitivity=1.0000000
    m_fYawSensitivity=1.0000000
    m_fSoundEffectsVolume=70.0000000
    m_fMusicVolume=90.0000000
    m_fVoiceVolume=100.0000000
    m_iGamma=5
}