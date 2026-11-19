class SkyInteraction_VehicleInteraction extends SkyGameInteraction
    native
    editinlinenew;

var() name CentralSocket;
var() bool bUseFadeToBlack;
var() bool bEndOnFadeToBlackComplete;
var bool bFadeToBlackPreventingEnd;
var() float TimeUntilFadeToBlack;
var() float TimeOfFadeToBlack;
var() float TimeOfBlack;
var() float TimeOfFadeFromBlack;

// Export USkyInteraction_VehicleInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyInteraction_VehicleInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyInteraction_VehicleInteraction::execFadeFinished(FFrame&, void* const)
native function FadeFinished();
