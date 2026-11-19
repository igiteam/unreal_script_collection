class DecalManager extends Object
    native;

var const array<DecalLifetime> LifetimePolicies;

// Export UDecalManager::execConnect(FFrame&, void* const)
native function Connect(DecalComponent InDecalComponent);

// Export UDecalManager::execDisconnect(FFrame&, void* const)
native function Disconnect(DecalComponent InDecalComponent);
