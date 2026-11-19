class TurokSavedMove extends SavedMove
    native;

const MAX_POSSIBLE_ACCELERATION = 1536.0f;
const MAX_TOLERANCE = 0.001f;

var @NULL mRootMotionDelta;
var @NULL mRootMotionRotation;
var byte mMaxSpeedMod;
var byte mSpeedMod;

// Export UTurokSavedMove::execClear(FFrame&, void* const)
native function Clear();

// Export UTurokSavedMove::execTurokIsImportantMove(FFrame&, void* const)
native function bool TurokIsImportantMove(@NULL TPC, @NULL CompareAccel, byte CompareMaxSpeed, byte CompareCurSpeed);

// Export UTurokSavedMove::execTurokSetMoveFor(FFrame&, void* const)
native function TurokSetMoveFor(@NULL TPC, float DeltaTime, @NULL newAccel);

// Export UTurokSavedMove::execTurokPreMove(FFrame&, void* const)
native function TurokPreMove(@NULL TPC, @NULL tPawn);

// Export UTurokSavedMove::execTurokPostMove(FFrame&, void* const)
native function TurokPostMove(@NULL TPC);

// Export UTurokSavedMove::execTurokCanCombineWith(FFrame&, void* const)
native function bool TurokCanCombineWith(@NULL NewMove, @NULL inPawn, float MaxDelta);

// Export UTurokSavedMove::execTurokGetStartPosition(FFrame&, void* const)
native function @NULL TurokGetStartPosition();

// Export UTurokSavedMove::execTurokSetStartPosition(FFrame&, void* const)
native function TurokSetStartPosition(@NULL P);

// Export UTurokSavedMove::execCompressedFlags(FFrame&, void* const)
native function byte CompressedFlags();

// Export UTurokSavedMove::execGetFlags(FFrame&, void* const)
native static final function byte GetFlags(@NULL PC, byte DClickMove);

// Export UTurokSavedMove::execSetFlags(FFrame&, void* const)
native static function byte SetFlags(byte Flags, @NULL PC);

// Export UTurokSavedMove::execCompressAcceleration(FFrame&, void* const)
native static final function @NULL CompressAcceleration(@NULL newAccel);

defaultproperties
{
    mMaxSpeedMod=128
    mSpeedMod=128
    AccelDotThreshold=0.9670000
}