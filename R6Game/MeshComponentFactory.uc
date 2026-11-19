class MeshComponentFactory extends PrimitiveComponentFactory
    abstract
    native;

var(Rendering) array<MaterialInstance> Materials;

defaultproperties
{
    CastShadow=true
}