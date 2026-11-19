class BoxComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,lighting);

var Vector m_vSize;

// Export UBoxComponent::execSetBoxSize(FFrame&, void* const)
native final function SetBoxSize(float fX, float fY, float fZ);

defaultproperties
{
    m_vSize=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    StaticMesh=StaticMesh'KellerResource.cube1x1'
    bAcceptsLights=false
}