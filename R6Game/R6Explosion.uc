class R6Explosion extends Actor
    native
    notplaceable
    hidecategories(lighting);

struct SDelayedVisibilityCheck
{
    var Actor m_pActor;
    var float m_fDistance;
    var R6Effect.EEffectVisibilityType m_eVisibilityType;
    var Vector m_vVisibilityLocation;
    var float m_fVisibilityWeight;

    structdefaultproperties
    {
        m_pActor=none
        m_fDistance=0.0000000
        m_eVisibilityType=0
        m_vVisibilityLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fVisibilityWeight=0.0000000
    }
};

struct SActorExplosionDistance
{
    var Actor m_pActor;
    var float m_fDistance;

    structdefaultproperties
    {
        m_pActor=none
        m_fDistance=0.0000000
    }
};

struct SEffectAffectedActors
{
    var R6Effect m_effect;
    var array<Actor> m_affectedActors;

    structdefaultproperties
    {
        m_effect=none
        m_affectedActors=none
    }
};

var bool m_bExploded;
var bool m_bInit;
var bool m_bUpdateActorsInRange;
var array<bool> m_EffectsEnded;
var array<bool> m_EffectsStarted;
var float m_fTimeSinceExplosion;
var() R6ExplosionParams m_explosionParams;
var(R6Sound) /*0x04000000-0x00000000*/ R6SoundExplosionParams m_SoundExplosionParams;
var float m_fTotalDuration;
var float m_fMaxRange;
var Vector m_vExplosionNormal;
var Emitter m_explosionEffectEmitter;
var Actor m_ExplosionSourceActor;
var export editinline MeshComponent m_ExplodedMesh;
var array<Object> m_EffectData;
var class<DamageType> m_damageType;
var array<SEffectAffectedActors> m_effectAffectedActors;
var export editinline PointLightComponent m_pPointLight;
var int m_iUpdateActorsInRangeTimer;
var array<SDelayedVisibilityCheck> m_DelayedVisibilityChecks;
var int m_iDelayedVisiblityCheckIndex;
var float m_fDelayedVisibilityRatio;
var array<float> m_effectRanges;
//var delegate<OnExplosionFinished> __OnExplosionFinished__Delegate;

// Export UR6Explosion::execExplode(FFrame&, void* const)
native final function Explode(optional Actor pExplosionSourceActor);

// Export UR6Explosion::execInitParams(FFrame&, void* const)
native final function InitParams(R6ExplosionParams explosionParams, Vector vExplosionNormal, R6SoundExplosionParams SoundExplosionParams, optional MeshComponent ExplodedMesh, optional class<DamageType> DamageType);

delegate OnExplosionFinished(R6Explosion pExplosion)
{
    return;
}

defaultproperties
{
    m_damageType=Class'R6DamageTypeExplosive'
    // Reference: PointLightComponent'Default__R6Explosion.ExplosionPointLightComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ExplosionPointLightComponent" class=Class'PointLightComponent'
        Translation=(X=0.0000000,Y=0.0000000,Z=10.0000000)
        bEnabled=false
        AffectPawns=true
        bUseZoneList=false
        m_bDelayAddRemoveLight=true
    end object
    m_pPointLight=ExplosionPointLightComponent
    // Reference: SpriteComponent'Default__R6Explosion.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=ExplosionPointLightComponent
    TickGroup=1
}