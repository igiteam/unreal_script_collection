class R6DamageVolume extends Volume
    native
    hidecategories(lighting,Object,Movement,Display);

var(Damage) float m_fDamagePerSecond;
var(Damage) class<DamageType> m_damageType;
var array<Actor> m_touchingActors;
var array<float> m_accumulatedDamages;

// Export UR6DamageVolume::execApplyDamage(FFrame&, void* const)
native final function ApplyDamage(float fDeltaTime);

// Export UR6DamageVolume::execAddTouchingActor(FFrame&, void* const)
native final function AddTouchingActor(Actor other);

// Export UR6DamageVolume::execRemoveTouchingActor(FFrame&, void* const)
native final function RemoveTouchingActor(Actor other);

simulated function Tick(float fDeltaTime)
{
    ApplyDamage(fDeltaTime);
    return;
}

defaultproperties
{
    m_fDamagePerSecond=10.0000000
    m_damageType=Class'Engine.DamageType'
    BrushColor=(R=255,G=128,B=128,A=255)
    bColored=true
    SupportedEvents=/* Array type was not detected. */
}