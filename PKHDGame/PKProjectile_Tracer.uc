class PKProjectile_Tracer extends EvilProjectile_Tracer_Base
    hidecategories(Navigation);

defaultproperties
{
    ProjFlightTemplate=ParticleSystem'ps_wp_MuzzleBase.Effects.ps_wp_Trace'
    // Reference: CylinderComponent'Default__PKProjectile_Tracer.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Tracer_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}