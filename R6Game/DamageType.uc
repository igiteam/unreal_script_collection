class DamageType extends Object
    abstract
    native
    config(DamageTypesConfig);

enum EForceFeedbackWaveform
{
    EWAVEFORM_Hit,                  // 0
    EWAVEFORM_Killed,               // 1
    EWAVEFORM_Firing,               // 2
    EWAVEFORM_MAX                   // 3
};

var() const localized string DeathString;
var() const localized string FemaleSuicide;
var() const localized string MaleSuicide;
var() bool bArmorStops;
var() bool bAlwaysGibs;
var() bool bNeverGibs;
var() bool bLocationalHit;
var() bool bSkeletize;
var() bool bCausesBlood;
var() bool bKUseOwnDeathVel;
var bool bCausedByWorld;
var bool bExtraMomentumZ;
var() bool m_bExplosiveDamage;
var() bool m_bBulletDamage;
var() bool m_bDropWeaponOnKill;
var bool m_bIsFireDamage;
var(RigidBody) bool bKRadialImpulse;
var() float GibModifier;
var(RigidBody) config float KDamageImpulse;
var(RigidBody) float KDeathVel;
var(RigidBody) float KDeathUpKick;
var(RigidBody) float KImpulseRadius;
var float VehicleDamageScaling;
var float VehicleMomentumScaling;
var DamageType.EForceFeedbackWaveform m_WaveformHit;
var DamageType.EForceFeedbackWaveform m_WaveformKilled;
var DamageType.EForceFeedbackWaveform m_WaveformFiring;
var config float m_fCameraShakeDuration;
var config float m_fCameraShakeStrength;
var config float m_fCameraShakeRollFreq;
var config float m_fCameraShakePitchFreq;
var config float m_fCameraShakeYawFreq;
var config float m_fCameraShakeRollAmp;
var config float m_fCameraShakePitchAmp;
var config float m_fCameraShakeYawAmp;

static function IncrementKills(PlayerReplicationInfo KillerPRI)
{
    return;
}

static function ScoreKill(PlayerReplicationInfo KillerPRI, PlayerReplicationInfo KilledPRI, Pawn KilledPawn)
{
    IncrementKills(KillerPRI);
    return;
}

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, optional bool bKillerIsATerrorist)
{
    return default.DeathString;
    return;
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
    // End:0x28
    if((Victim != none) && Victim.bIsFemale)
    {
        return default.FemaleSuicide;        
    }
    else
    {
        return default.MaleSuicide;
    }
    return;
}

static function float VehicleDamageScalingFor(Vehicle V)
{
    return default.VehicleDamageScaling;
    return;
}

defaultproperties
{
    DeathString="%o was killed by %k."
    FemaleSuicide="%o killed herself."
    MaleSuicide="%o killed himself."
    bArmorStops=true
    bLocationalHit=true
    bCausesBlood=true
    bExtraMomentumZ=true
    m_bDropWeaponOnKill=true
    GibModifier=1.0000000
    KImpulseRadius=250.0000000
    VehicleDamageScaling=1.0000000
    VehicleMomentumScaling=1.0000000
    m_WaveformKilled=1
    m_WaveformFiring=2
}