class SkyBotMeleeInteraction extends SkyMeleeInteraction
    native
    editinlinenew;

var(AI) float MeleeWaitTimeMin;
var(AI) float MeleeWaitTimeMax;

// Export USkyBotMeleeInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
