class SkyInteraction_WeaponLocker extends SkyGameInteraction
    native
    editinlinenew;

var(Bonus) UIScene WeaponLockerScene;
var transient SkyInteractor CachedInstigator;
var transient SkyInteractor CachedTarget;

// Export USkyInteraction_WeaponLocker::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyInteraction_WeaponLocker::execAbortTimer(FFrame&, void* const)
native function AbortTimer();

// Export USkyInteraction_WeaponLocker::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
