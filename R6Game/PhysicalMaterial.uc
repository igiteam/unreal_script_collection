class PhysicalMaterial extends Object
    native
    collapsecategories
    hidecategories(Object);

var transient int MaterialIndex;
var() float Friction;
var() float Restitution;
var() float Density;
var() float AngularDamping;
var() float LinearDamping;
var() float MagneticResponse;
var() float WindResponse;
var(Parent) PhysicalMaterial Parent;
var(PhysicalProperties) export editinline PhysicalMaterialPropertyBase PhysicalMaterialProperty;

function PhysicalMaterialPropertyBase GetPhysicalMaterialProperty(class<PhysicalMaterialPropertyBase> DesiredClass)
{
    // End:0x2F
    if((PhysicalMaterialProperty != none) && ClassIsChildOf(PhysicalMaterialProperty.Class, DesiredClass))
    {
        return PhysicalMaterialProperty;        
    }
    else
    {
        // End:0x53
        if(Parent != none)
        {
            return Parent.GetPhysicalMaterialProperty(DesiredClass);            
        }
        else
        {
            return none;
        }
    }
    return;
}

defaultproperties
{
    Friction=0.7000000
    Restitution=0.3000000
    Density=1.0000000
    AngularDamping=0.1000000
    LinearDamping=0.1000000
}