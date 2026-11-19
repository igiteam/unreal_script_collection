class TurokBlackboard extends Object
    native;

var array mBBRecords;

// Export UTurokBlackboard::execPostBBRecord(FFrame&, void* const)
native function PostBBRecord(name post, @NULL poster, @NULL Target, optional float Data);

// Export UTurokBlackboard::execRemoveBBRecord(FFrame&, void* const)
native function RemoveBBRecord(name post, @NULL poster, @NULL Target);

// Export UTurokBlackboard::execCountBBRecords(FFrame&, void* const)
native function int CountBBRecords(name post, @NULL poster, @NULL Target);

// Export UTurokBlackboard::execClearBBRecords(FFrame&, void* const)
native function ClearBBRecords(name post, @NULL poster, @NULL Target);

// Export UTurokBlackboard::execGetBBRecordData(FFrame&, void* const)
native function float GetBBRecordData(name post, @NULL poster, @NULL Target);

// Export UTurokBlackboard::execUpdateBBRecordData(FFrame&, void* const)
native function UpdateBBRecordData(name post, @NULL poster, @NULL Target, float Data);

// Export UTurokBlackboard::execGetBBRecordPoster(FFrame&, void* const)
native function float GetBBRecordPoster(int Index, name post, out @NULL poster, optional @NULL Target);
