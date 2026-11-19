//=============================================================================
// Ambient sound, sits there and emits its sound.  This class is no different 
// than placing any other actor in a level and setting its ambient sound.
//=============================================================================
class AmbientSound extends Keypoint;

// Import the sprite.
#exec Texture Import File=Textures\Ambient.dds Name=S_Ambient Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    RemoteRole=0
    Texture=Texture'S_Ambient'
    SoundVolume=190
}