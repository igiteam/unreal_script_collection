class JumpOverObstacleWithAnim extends PathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    implements(Interface_NavMeshPathObject);

struct native JumpAnimanfo
{
    var name AnimName;
    var Vector AnimMove;

    structdefaultproperties
    {
        AnimName="None"
        AnimMove=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var private native const noexport Pointer VfTable_IInterface_NavMeshPathObject;
var array<JumpAnimanfo> JumpOverObstacleAnims;

defaultproperties
{
    // Reference: CylinderComponent'Default__JumpOverObstacleWithAnim.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Engine.Default__PathNode.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=none
    Components[3]=CollisionCylinder
    Components[4]=none
    CollisionComponent=CollisionCylinder
}