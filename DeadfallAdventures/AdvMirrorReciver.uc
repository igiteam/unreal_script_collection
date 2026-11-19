class AdvMirrorReciver extends AdvMirrorDynamic
    config(Game)
    hidecategories(Navigation);

var(AdvMirrorDynamic) private bool bReflect;

function bool CreateReflection(Vector HitRayLocation)
{
    // End:0x24
    if(bReflect)
    {
        return super.CreateReflection(HitRayLocation);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvMirrorReciver.Mesh'
    begin object name=Mesh
        ReplacementPrimitive=none
    end object
    MirrorMesh=Mesh
    // Reference: CylinderComponent'Default__AdvMirrorReciver.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=Mesh
    bMovable=false
    CollisionComponent=Mesh
}