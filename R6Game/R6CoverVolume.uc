class R6CoverVolume extends BlockingVolume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

defaultproperties
{
    // Reference: BrushComponent'Default__R6CoverVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__BlockingVolume.BrushComponent0'
    begin object name="BrushComponent0"
        BlockZeroExtent=true
        BlockRigidBody=false
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}