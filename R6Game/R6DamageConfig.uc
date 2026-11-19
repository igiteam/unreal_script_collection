class R6DamageConfig extends R6Config
    native
    hidecategories(Object);

struct DamageMultiplier
{
    var() editconst R6EngineEnums.EBoneArmsAndHead m_eBodyPart;
    var() float m_fMultiplier;

    structdefaultproperties
    {
        m_eBodyPart=0
        m_fMultiplier=0.0000000
    }
};

var(DamageModifiers) float m_fOverallDamageModifier;
var(DamageModifiers) float m_fOverallObjectSolidityModifier;
var(DamageModifiers) float m_fExplosiveDamageOnObjectModifier;
var(DamageModifiers) float m_fOverallDamageModifierToTerroNormal;
var(DamageModifiers) float m_fOverallDamageModifierToTerroVeteran;
var(DamageModifiers) float m_fOverallDamageModifierToTerroElite;
var(DamageModifiers) DamageMultiplier m_damageMultipliersTerro[5];
var(DamageModifiers) DamageMultiplier m_damageMultipliersRainbow[5];
var(DamageModifiers) DamageMultiplier m_damageMultipliersAdversarialPlayer[5];
var(DamageModifiers) float m_fRappellingDamageModifier;
var(DamageModifiers) float m_fAIProximityDamageModifier;
var(DamageModifiers) float m_fAITaggedEnemyDamageModifier;
var(DamageModifiers) float m_fAIDemolitionPrimaryWeaponDamageModifier;
var(ExplosionVisibility) float m_fHipOffsetDistance;
var(ExplosionVisibility) float m_fSpineOffsetCrouchDistance;
var(ExplosionVisibility) float m_fSpineOffsetStandDistance;
var(TakeCoverModifiers) float m_fTCNotExposedPlayerModifier;
var(TakeCoverModifiers) float m_fTCNotExposedRainbowModifier;
var(TakeCoverModifiers) float m_fTCNotExposedTerroModifier;
var(TakeCoverModifiers) float m_fTCExposedPlayerModifier;
var(TakeCoverModifiers) float m_fTCExposedRainbowModifier;
var(TakeCoverModifiers) float m_fTCExposedTerroModifier;
var(Fire) int m_iDamageByFire;
var(Fire) float m_fTimeDamageByFire;
var(Impact) R6MaterialGameParams m_defaultMaterialGameParams;
var(Impact) R6MaterialGameParams m_FriendlyFireMaterialGameParams;
var(ExplosionDistances) float m_fExplosionNearDistance;
var(TerroExplosion) float m_fTerroExplosionFullStrengthRange;
var(TerroExplosion) float m_fTerroExplosionMaxRange;
var(KillTeam) float m_fTimeWaitAfterFightForKillTeam;

// Export UR6DamageConfig::execGetDamageMultiplierFor(FFrame&, void* const)
native function float GetDamageMultiplierFor(name BoneName, bool bTerro, bool bAdversarial);

defaultproperties
{
    m_fOverallDamageModifier=1.0000000
    m_fOverallObjectSolidityModifier=1.0000000
    m_fExplosiveDamageOnObjectModifier=3.0000000
    m_fOverallDamageModifierToTerroNormal=1.5000000
    m_fOverallDamageModifierToTerroVeteran=1.0000000
    m_fOverallDamageModifierToTerroElite=0.7500000
    m_damageMultipliersTerro[0]=(m_eBodyPart=0,m_fMultiplier=1.0000000)
    m_damageMultipliersTerro[1]=(m_eBodyPart=1,m_fMultiplier=1.0000000)
    m_damageMultipliersTerro[2]=(m_eBodyPart=2,m_fMultiplier=1.0000000)
    m_damageMultipliersTerro[3]=(m_eBodyPart=3,m_fMultiplier=1.0000000)
    m_damageMultipliersTerro[4]=(m_eBodyPart=4,m_fMultiplier=1.0000000)
    m_damageMultipliersRainbow[0]=(m_eBodyPart=0,m_fMultiplier=1.0000000)
    m_damageMultipliersRainbow[1]=(m_eBodyPart=1,m_fMultiplier=1.0000000)
    m_damageMultipliersRainbow[2]=(m_eBodyPart=2,m_fMultiplier=1.0000000)
    m_damageMultipliersRainbow[3]=(m_eBodyPart=3,m_fMultiplier=1.0000000)
    m_damageMultipliersRainbow[4]=(m_eBodyPart=4,m_fMultiplier=1.0000000)
    m_damageMultipliersAdversarialPlayer[0]=(m_eBodyPart=0,m_fMultiplier=1.0000000)
    m_damageMultipliersAdversarialPlayer[1]=(m_eBodyPart=1,m_fMultiplier=1.0000000)
    m_damageMultipliersAdversarialPlayer[2]=(m_eBodyPart=2,m_fMultiplier=1.0000000)
    m_damageMultipliersAdversarialPlayer[3]=(m_eBodyPart=3,m_fMultiplier=1.0000000)
    m_damageMultipliersAdversarialPlayer[4]=(m_eBodyPart=4,m_fMultiplier=1.0000000)
    m_fRappellingDamageModifier=1.2000000
    m_fAIProximityDamageModifier=10.0000000
    m_fAITaggedEnemyDamageModifier=10.0000000
    m_fAIDemolitionPrimaryWeaponDamageModifier=3.0000000
    m_fHipOffsetDistance=20.0000000
    m_fSpineOffsetCrouchDistance=50.0000000
    m_fSpineOffsetStandDistance=25.0000000
    m_fTCNotExposedPlayerModifier=1.0000000
    m_fTCNotExposedRainbowModifier=1.0000000
    m_fTCNotExposedTerroModifier=1.0000000
    m_fTCExposedPlayerModifier=1.0000000
    m_fTCExposedRainbowModifier=1.0000000
    m_fTCExposedTerroModifier=1.0000000
    m_iDamageByFire=10
    m_fTimeDamageByFire=0.5000000
    m_defaultMaterialGameParams=R6MaterialGameParams'ImpactConfig.BI_generic_param'
    m_FriendlyFireMaterialGameParams=R6MaterialGameParams'ImpactConfig.BI_generic_param'
    m_fExplosionNearDistance=200.0000000
    m_fTerroExplosionFullStrengthRange=100.0000000
    m_fTerroExplosionMaxRange=200.0000000
    m_fTimeWaitAfterFightForKillTeam=2.0000000
    m_szThumbnailTexture="KellerEditorMaterials.Damage"
    m_szDescription="Damage configuration"
}