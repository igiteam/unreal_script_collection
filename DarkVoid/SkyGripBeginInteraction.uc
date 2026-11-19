class SkyGripBeginInteraction extends SkyGameInteraction
    native
    editinlinenew;

var(GripInfo) name GripSocket;
var(GripInfo) name StartSocket;
var(GripInfo) float MaxStartSocketDist;
var(GripOffsets) bool bUseTargetRelativeOffsets;
var(GripOffsets) Vector MaxOffsetRelativeToTarget;
var(GripOffsets) Vector MinOffsetRelativeToTarget;
var(GripInfo) array<name> GripPointRequirements;
var(GripInfo) array<name> RequiredGripPoints;

// Export USkyGripBeginInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyGripBeginInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyGripBeginInteraction::execGetInteractionTargetLocation(FFrame&, void* const)
native function bool GetInteractionTargetLocation(SkyInteractor Target, out Vector TargetLocation);
