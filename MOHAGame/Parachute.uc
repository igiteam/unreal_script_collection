class Parachute extends PrimitiveComponent
    native;

var private native const Pointer m_pPimpl;

// Export UParachute::execInit(FFrame&, void* const)
native function Init(SkeletalMeshComponent ParachuteMesh);

// Export UParachute::execSpawnAt(FFrame&, void* const)
native function SpawnAt(Vector pos, int ZRot);

// Export UParachute::execFinishDestroy(FFrame&, void* const)
native function FinishDestroy();
