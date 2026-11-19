class TextureCube extends Texture
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
var() const noexport Texture2D FacePosX;
var() const noexport Texture2D FaceNegX;
var() const noexport Texture2D FacePosY;
var() const noexport Texture2D FaceNegY;
var() const noexport Texture2D FacePosZ;
var() const noexport Texture2D FaceNegZ;
var native const array<int> MipsPosX;
var native const array<int> MipsNegX;
var native const array<int> MipsPosY;
var native const array<int> MipsNegY;
var native const array<int> MipsPosZ;
var native const array<int> MipsNegZ;
var native const int Valid;
