class SkyArchonEndInteraction extends SkyGripEndInteraction
    native
    editinlinenew;

var() array<int> ExposedWeakPoints;
var() bool bLowerEnergyShields;

// Export USkyArchonEndInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
