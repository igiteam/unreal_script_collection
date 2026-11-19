class Font extends Object
    native
    hidecategories(Object);

const NULLCHARACTER = 127;

struct FontCharacter
{
    structcpptext
    {

		// Serializer.
		friend FArchive& operator<<( FArchive& Ar, FFontCharacter& Ch )
		{
			return Ar << Ch.StartU << Ch.StartV << Ch.USize << Ch.VSize << Ch.TextureIndex;
		}
	
    }

    var() int StartU;
    var() int StartV;
    var() int USize;
    var() int VSize;
    var() editconst byte TextureIndex;

    structdefaultproperties
    {
        StartU=0
        StartV=0
        USize=0
        VSize=0
        TextureIndex=0
    }
};

var() editinline array<editinline FontCharacter> Characters;
var array<Texture2D> Textures;
var private native const map{VOID,VOID} CharRemap;
var int IsRemapped;
var() int Kerning;
