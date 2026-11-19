class R6ColorGelParams extends R6Config
    native
    hidecategories(Object);

var(GelEffect) Color m_cGelColor;
var(GelEffect) float m_fGelBlend;
var(GelEffect) float m_fGelNoiseBlend;

defaultproperties
{
    m_fGelNoiseBlend=1.0000000
    m_szThumbnailTexture="KellerEditorMaterials.Visuals"
    m_szDescription="R6ColorGelParams"
}