class SPSawPersistent extends SPWeaponRapidFirePersistant
    abstract
    native
    config(Game);

// Export USPSawPersistent::execInitSPSawAttachedBulletComponent(FFrame&, void* const)
native function InitSPSawAttachedBulletComponent(SPStaticMeshComponent bulletComponent, StaticMesh bulletStaticMesh, SkeletalMeshComponent parentMesh);
