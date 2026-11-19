class CylinderComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories
    noexport;

var() const export float CollisionHeight;
var() const export float CollisionRadius;

// Export UCylinderComponent::execSetSize(FFrame&, void* const)
native final function SetSize(float NewHeight, float NewRadius);

defaultproperties
{
    IntProperty[233]=/* ERROR: System.Exception */
}