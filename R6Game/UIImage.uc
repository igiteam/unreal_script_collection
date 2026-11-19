class UIImage extends UIObject
    native
    hidecategories(Object);

var() UITexture Image;
var() TextureCoordinates Coordinates;

final function SetValue(Texture2D NewImage, TextureCoordinates NewCoordinates)
{
    Image.ImageMaterial = NewImage;
    Coordinates = NewCoordinates;
    return;
}

defaultproperties
{
    DefaultStyleTag="DefaultImageStyle"
    Position=(Value[2]=50.0000000,Value[3]=50.0000000,ScaleType[2]=3,ScaleType[3]=3)
}