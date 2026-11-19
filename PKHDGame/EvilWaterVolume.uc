class EvilWaterVolume extends WaterVolume
    hidecategories(Navigation,Object,Movement,Display);

var() ParticleSystem ProjectileEntryEffect;
var() PhysicalMaterial WaterPhysMaterial;

event ActorEnteredVolume(Actor Other)
{
    // End:0x40
    if(EvilProjectile_Base(Other) != none)
    {
        EvilProjectile_Base(Other).EnteredWaterVolume();
    }
    //return;    
}

event ActorLeavingVolume(Actor Other)
{
    // End:0x40
    if(EvilProjectile_Base(Other) != none)
    {
        EvilProjectile_Base(Other).ExitedWaterVolume();
    }
    //return;    
}

defaultproperties
{
    WaterPhysMaterial=PhysicalMaterial'pm_materials.PM_Water'
    bWaterVolume=false
    // Reference: BrushComponent'Default__EvilWaterVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__WaterVolume.BrushComponent0'
    begin object name="BrushComponent0"
        bBlockComplexCollisionTrace=true
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}