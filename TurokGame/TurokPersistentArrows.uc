class TurokPersistentArrows extends TurokPersistentObjectContainer
    native
    config(Engine);

var config int mMaxArrows;

// Export UTurokPersistentArrows::execAddArrow(FFrame&, void* const)
native function AddArrow(@NULL pArrowActor);

// Export UTurokPersistentArrows::execRemoveArrow(FFrame&, void* const)
native function RemoveArrow(@NULL pArrowActor);
