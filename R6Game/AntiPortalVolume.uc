class AntiPortalVolume extends Volume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

defaultproperties
{
    BrushColor=(R=255,G=128,B=0,A=255)
    bColored=true
    // Reference: BrushComponent'Default__AntiPortalVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__Volume.BrushComponent0'
    begin object name="BrushComponent0"
        CollideActors=false
        BlockNonZeroExtent=false
    end object
    BrushComponent=BrushComponent0
    bCollideActors=false
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}