class TextureRenderTargetCube extends Texture
    native
    noexport
    hidecategories(Object,Texture);

var native const noexport Pointer VfTable;
var native const int ResourceIndex;
var native const int UpdateHint;
var() native const int SizeX;
var native const int SizeY;
var native const byte Format;
var native const int SizeZ;
var native const int NumMips;
var native const int CurrentMips;
var native const byte CurTargetFace;

defaultproperties
{
    CompressionNone=true
    NeverStream=true
}