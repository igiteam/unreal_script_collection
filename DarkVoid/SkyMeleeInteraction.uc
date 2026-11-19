class SkyMeleeInteraction extends SkyGameInteraction
    native
    editinlinenew;

var(DamageOnFailure) float Damage;
var(DamageOnFailure) Vector DamageOffset;
var(DamageOnFailure) Vector DamageMomentum;
var(DamageOnFailure) class<SkyDamageType> DamageType;
var(Physics) bool bUseInstigatorStartPhysics;
var(Physics) bool bUseInstigatorEndPhysics;
var() bool bLockMovement;
var transient bool bInstigatorWins;
var transient bool bDisableAbort;
var(Physics) Actor.EPhysics InstigatorStartPhysics;
var(Physics) Actor.EPhysics InstigatorEndPhysics;

// Export USkyMeleeInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyMeleeInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyMeleeInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
