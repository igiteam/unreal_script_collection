//=============================================================================
// InterpolationPoint.
// Used as destinations to move the camera to in Matinee scenes.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

#exec Texture Import File=Textures\IntrpPnt.dds Name=S_Interp Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
    Texture=Texture'S_Interp'
    bDirectional=true
}