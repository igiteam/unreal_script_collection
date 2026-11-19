class RB_BodySetup extends KMeshProps
    native
    noexport
    hidecategories(Object);

var() name BoneName;
var() bool bFixed;
var() bool bNoCollision;
var() bool bBlockZeroExtent;
var() bool bBlockNonZeroExtent;
var bool m_bDoesNotOwnShapes;
var() /*0x40000000-0x00000000*/ PhysicalMaterial PhysMaterial;
var() /*0x44000000-0x00000000*/ R6SoundMaterial SoundMaterial;
var() float MassScale;
var native const array<Pointer> CollisionGeom;
var native const array<Vector> CollisionGeomScale3D;

defaultproperties
{
    bBlockZeroExtent=true
    bBlockNonZeroExtent=true
    MassScale=1.0000000
}