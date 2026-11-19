class SkySeqEvent_EnterExitVehicle extends SequenceEvent
    native;

var() protectedwrite array<protectedwrite string> SupportedVehicles;
var() bool bIgnoreRocketpack;

// Export USkySeqEvent_EnterExitVehicle::execCheckEnterActivate(FFrame&, void* const)
native final function bool CheckEnterActivate(Actor InOriginator, Actor InInstigator, optional bool bTest);

// Export USkySeqEvent_EnterExitVehicle::execCheckExitActivate(FFrame&, void* const)
native final function bool CheckExitActivate(Actor InOriginator, Actor InInstigator, optional bool bTest);
