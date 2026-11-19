class SkeletalMeshSocket extends Object
    native
    hidecategories(Object,Actor);

var() const editconst name SocketName;
var() const editconst name BoneName;
var() Vector RelativeLocation;
var() Rotator RelativeRotation;
var() Vector RelativeScale;
var() transient SkeletalMesh PreviewSkelMesh;
var() transient StaticMesh PreviewStaticMesh;
var() const editconst bool m_pIsTemplateSocket;

defaultproperties
{
    RelativeScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
}