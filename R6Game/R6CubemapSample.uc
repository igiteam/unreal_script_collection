class R6CubemapSample extends Actor
    native
    placeable
    hidecategories(lighting,Object);

enum CMSize
{
    CMSIZE_32x32,                   // 0
    CMSIZE_64x64,                   // 1
    CMSIZE_128x128,                 // 2
    CMSIZE_256x256,                 // 3
    CMSIZE_512x512,                 // 4
    CMSIZE_1024x1024,               // 5
    CMSIZE_MAX                      // 6
};

var(CubemapSample) string m_Prefix;
var(CubemapSample) R6CubemapSample.CMSize m_eSize;
var(CubemapSample) int m_iLODBias;
var(CubemapSample) editconst TextureCube m_Cubemap;

defaultproperties
{
    m_eSize=1
    // Reference: SpriteComponent'Default__R6CubemapSample.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.S_CubemapSample'
    end object
    Components[0]=Sprite
    Components[1]=Sprite
}