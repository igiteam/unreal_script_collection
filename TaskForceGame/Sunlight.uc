//=============================================================================
// Directional sunlight
//=============================================================================
class Sunlight extends Light;

#exec Texture Import File=Textures\SunIcon.dds  Name=SunIcon Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    LightEffect=19
    Texture=Texture'SunIcon'
    bDirectional=true
}