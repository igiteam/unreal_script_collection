class EvilDynamicCoverLink extends EvilCoverLink
    config(Game)
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: EvilCoverMeshComponent'Default__EvilDynamicCoverLink.CoverMesh0'
    begin object name=CoverMesh0
        // Reference: AnimNodeSequence'Default__EvilDynamicCoverLink.CoverMesh0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
    end object
    CoverCharacterMesh=CoverMesh0
    // Reference: CylinderComponent'Default__EvilDynamicCoverLink.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CollisionCylinder
    Components[3]=CoverMesh0
    bStatic=false
    CollisionComponent=CollisionCylinder
}