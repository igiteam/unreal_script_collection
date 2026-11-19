class SkyMeleeInteraction_Watcher extends SkyMeleeInteraction
    native
    editinlinenew;

var(Watcher) float EnergyOnDeath;
var(Watcher) bool bRequireStun;
var(Watcher) bool bRequireEhben;

// Export USkyMeleeInteraction_Watcher::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
