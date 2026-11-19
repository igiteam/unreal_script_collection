class SkyDamageType extends DamageType
    native;

var(RigidBody) float KDeathImpulse;
var(RigidBody) bool bThrowRagdoll;
var() bool bBulletHit;
var() bool bGroundBasedOnly;
var(RigidBody) float PhysicsTakeHitMomentumThreshold;

// Export USkyDamageType::execGetHitEffectDuration(FFrame&, void* const)
native static function float GetHitEffectDuration(Pawn P, float Damage);
