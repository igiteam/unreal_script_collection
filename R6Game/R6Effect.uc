class R6Effect extends Object
    abstract
    native
    editinlinenew
    hidecategories(Object);

enum EEffectVisibilityType
{
    EEffectVisibility_Location,     // 0
    EEffectVisibility_Body,         // 1
    EEffectVisibility_ViewPoint,    // 2
    EEffectVisibility_DistanceOnly, // 3
    EEffectVisibility_MAX           // 4
};

var R6EngineEnums.EExplosionEffectType m_eEffectType;
var() R6EngineEnums.EEffectImmuneType m_eImmuneType;
var() R6Effect.EEffectVisibilityType m_eVisibilityType;
var() float m_fStrength;
var() float m_fFullStrengthRange;
var() float m_fMaxRange;
var() SInterpParams m_strengthInterpParams;
var() float m_fExpansionDuration;
var() float m_fFullRangeDuration;
var() editinline R6EffectZone m_effectZone;
var() bool m_bNeedsExplodedActorShown;
var() bool m_bNeedsExplodedActorPhysics;
var() bool m_bDangerousForAI;
var() bool m_bSkipFriends;
var() bool m_bAffectInside;

// Export UR6Effect::execTargetHasGasMask(FFrame&, void* const)
native function bool TargetHasGasMask(Actor pActor, Vector vLocation);

// Export UR6Effect::execGetInterpolatedStrength(FFrame&, void* const)
native function float GetInterpolatedStrength(float fDistance);

defaultproperties
{
    m_eVisibilityType=1
    m_fStrength=100.0000000
    m_fMaxRange=1000.0000000
    m_strengthInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=-4.0000000)
    m_fExpansionDuration=0.5000000
    // Reference: R6EffectZoneSphere'Default__R6Effect.DefaultEffectZone'
    begin object name="DefaultEffectZone" class=Class'R6EffectZoneSphere'
    end object
    m_effectZone=DefaultEffectZone
    m_bNeedsExplodedActorPhysics=true
    m_bAffectInside=true
}