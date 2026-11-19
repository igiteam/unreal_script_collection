class R6ActorListManager extends Object
    native;

var array<Actor> m_DetectableExplosives;

// Export UR6ActorListManager::execAddDetectableExplosives(FFrame&, void* const)
native final function AddDetectableExplosives(Actor pExplosif);

// Export UR6ActorListManager::execRemoveDetectableExplosives(FFrame&, void* const)
native final function RemoveDetectableExplosives(Actor pExplosif);
