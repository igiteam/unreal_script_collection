class BlockingVolume extends Volume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() bool bClampFluid;

defaultproperties
{
    bClampFluid=true
    // Reference: BrushComponent'Default__BlockingVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__Volume.BrushComponent0'
    begin object name="BrushComponent0"
        BlockActors=true
        BlockRigidBody=true
    end object
    BrushComponent=BrushComponent0
    bWorldGeometry=true
    bBlockActors=true
    Components[0]=BrushComponent0
    m_eExplosionCollisionOverride=2
    CollisionComponent=BrushComponent0
}