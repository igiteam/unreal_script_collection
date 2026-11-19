class SPActorPool extends ActorPool
    native;

struct native ActorsPerClass
{
    var class<Actor> Class;
    var init array<init Actor> cachedActors;

    structdefaultproperties
    {
        Class=none
        cachedActors=none
    }
};

var init transient array<init ActorsPerClass> actorLists;

// Export USPActorPool::execGetActorFromPool(FFrame&, void* const)
native function Actor GetActorFromPool(class<Actor> theClass, name theName, const out Vector theLocation, const out Rotator theRotation, Actor theTemplate, bool noCollisionFail, bool remoteOwned, Actor theOwner, Pawn theInstigator, bool noFail, Actor.ENetRole theRemoteClientRole, bool spawnSimulated);

// Export USPActorPool::execReturnActorToPool(FFrame&, void* const)
native function bool ReturnActorToPool(Actor actorToReturn);
