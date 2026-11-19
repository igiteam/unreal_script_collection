class MeshComponent extends PrimitiveComponent
    abstract
    native
    noexport;

var(Rendering) const array<MaterialInstance> Materials;
var bool m_bWeaponComponent;

// Export UMeshComponent::execGetMaterial(FFrame&, void* const)
native function MaterialInstance GetMaterial(int SkinIndex);

// Export UMeshComponent::execSetMaterial(FFrame&, void* const)
native function SetMaterial(int SkinIndex, MaterialInstance Material);
