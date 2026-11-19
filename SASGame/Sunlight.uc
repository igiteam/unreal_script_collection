//=============================================================================
// Directional sunlight
//=============================================================================
class Sunlight extends Light;

#exec Texture Import File=Textures\SunIcon.pcx  Name=SunIcon Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'SunIcon'
    LightEffect=19
    bDirectional=true
}