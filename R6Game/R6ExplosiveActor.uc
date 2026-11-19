class R6ExplosiveActor extends KActor
    native
    hidecategories(lighting);

var() int Health;
var() float m_fImpulse;
var() /*0x40000000-0x00000000*/ R6ExplosionParams m_Params;
var() class<DamageType> m_damageType;
var(R6Sound) /*0x44000000-0x00000000*/ R6SoundExplosionParams m_SoundExplosionParams;
var int m_iCurrentHealth;
var repnotify bool m_bExploded;
var Pawn m_pExplosionInstigator;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Health, m_Params, 
        m_bExploded, m_damageType, 
        m_fImpulse, m_iCurrentHealth;
}

simulated event Explode(Pawn ExplosionInstigator)
{
    local R6Explosion pExplosion;
    local Vector vNormal, vImpulse;

    vNormal.X = 0.0000000;
    vNormal.Y = 0.0000000;
    vNormal.Z = 1.0000000;
    pExplosion = __NFUN_278__(Class'Engine.R6Explosion',,, GetCenter(), Rotation);
    pExplosion.InitParams(m_Params, vNormal, m_SoundExplosionParams, StaticMeshComponent, m_damageType);
    pExplosion.Instigator = ExplosionInstigator;
    vImpulse = vNormal;
    vImpulse.Z *= m_fImpulse;
    StaticMeshComponent.AddImpulse(vImpulse, Location, 'None');
    pExplosion.super(R6ExplosiveActor).Explode();
    m_bExploded = true;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    return;
}

event PreBeginPlay()
{
    PreBeginPlay();
    m_iCurrentHealth = Health;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_pExplosionInstigator = none;
    m_bExploded = false;
    m_iCurrentHealth = Health;
    return;
}

defaultproperties
{
    m_damageType=Class'Engine.R6DmgTypeLevelExplosion'
    m_iCurrentHealth=-1
    bAlwaysRelevant=true
}