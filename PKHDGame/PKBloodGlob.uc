class PKBloodGlob extends EvilBloodGlob
    hidecategories(Navigation);

defaultproperties
{
    BloodDecal=/* Array type was not detected. */
    ProjFlightTemplate=ParticleSystem'ps_Blood.Effects.ps_Bloodhit_RedBlob'
    // Reference: CylinderComponent'Default__PKBloodGlob.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilBloodGlob.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}