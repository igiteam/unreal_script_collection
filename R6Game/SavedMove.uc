class SavedMove extends Info
    native
    notplaceable
    hidecategories(lighting,Movement,Collision);

var SavedMove NextMove;
var float TimeStamp;
var float Delta;
var Actor.EPhysics SavedPhysics;
var Vector StartLocation;
var Vector StartRelativeLocation;
var Vector StartVelocity;
var Vector StartFloor;
var Vector SavedLocation;
var Vector SavedVelocity;
var Vector SavedRelativeLocation;
var Actor StartBase;
var Actor EndBase;
var float AccelDotThreshold;

// Export USavedMove::execClear(FFrame&, void* const)
native final function Clear();

// Export USavedMove::execPostUpdate(FFrame&, void* const)
native final function PostUpdate(PlayerController P);

// Export USavedMove::execIsImportantMove(FFrame&, void* const)
native final function bool IsImportantMove(Vector CompareAccel);

// Export USavedMove::execGetStartLocation(FFrame&, void* const)
native final function Vector GetStartLocation();

// Export USavedMove::execSetInitialPosition(FFrame&, void* const)
native final function SetInitialPosition(Pawn P);

// Export USavedMove::execCanCombineWith(FFrame&, void* const)
native final function bool CanCombineWith(SavedMove NewMove, Pawn inPawn, float MaxDelta);

// Export USavedMove::execSetMoveFor(FFrame&, void* const)
native final function SetMoveFor(PlayerController P, float DeltaTime, Vector newAccel);

defaultproperties
{
    AccelDotThreshold=0.9000000
}