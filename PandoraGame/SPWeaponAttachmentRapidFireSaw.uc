class SPWeaponAttachmentRapidFireSaw extends SPWeaponAttachmentRapidFire
    abstract
    native
    notplaceable;

// Export USPWeaponAttachmentRapidFireSaw::execInitSPSawAttachedBulletComponent(FFrame&, void* const)
native function InitSPSawAttachedBulletComponent(SPStaticMeshComponent bulletComponent, StaticMesh bulletStaticMesh, SkeletalMeshComponent parentMesh);
