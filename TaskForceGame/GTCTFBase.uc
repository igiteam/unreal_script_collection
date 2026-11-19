class GTCTFBase extends Actor
	native
	placeable;

// kkm--eliminates runtime dependency on Editor.u
#exec NEW StaticMesh File="..\Editor\models\TexPropCube.Ase" Name="TexPropCube2"

var(CTF) int TeamIndex;
var(CTF) vector FlagPositionOffset;
var GTCTFFlag myFlag;

var int GTFlags;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Decompiled with UE Explorer.
defaultproperties
{
    gtFlags=64
    DrawType=8
    StaticMesh=StaticMesh'TexPropCube2'
    bStatic=true
    bAcceptsProjectors=false
    bAlwaysRelevant=true
    bShadowCast=true
    bStaticLighting=true
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
    bDirectional=true
    bEdShouldSnap=true
}