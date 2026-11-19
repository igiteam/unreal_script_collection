class Texture2D extends Texture
    native
    noexport
    hidecategories(Object);

var native const noexport Pointer VfTable;
var native const int ResourceIndex;
var native const int UpdateHint;
var native const int SizeX;
var native const int SizeY;
var native const byte Format;
var native const int SizeZ;
var native const int NumMips;
var native const int CurrentMips;
var native const array<int> Mips;
var() Texture.TextureAddress AddressX;
var() Texture.TextureAddress AddressY;
var deprecated bool ClampX;
var deprecated bool ClampY;
var bool bFlipBook;
