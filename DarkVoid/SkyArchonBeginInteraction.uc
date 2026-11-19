class SkyArchonBeginInteraction extends SkyGripBeginInteraction
    native
    editinlinenew;

var() bool bFireTailThrashEvent;
var() name TailThrashEvent;
var() array<SkyPawn.EArmorType> RequiredArmorPoints;
var() array<int> RequiredWeakPoints;
var() array<SkyPawn_Archon.EStumbleType> RequiredStumbleTypes;

// Export USkyArchonBeginInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyArchonBeginInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
