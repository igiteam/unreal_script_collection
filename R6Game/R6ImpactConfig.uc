class R6ImpactConfig extends R6Config
    native
    hidecategories(Object);

var(ImpactMaterial) MaterialInstance m_ImpactMaterial;
var(ImpactMaterial) int m_iNumColumns;
var(ImpactMaterial) int m_iNumRows;
var(UnlitModulate) MaterialInstance m_UnlitModMaterial;
var(UnlitModulate) IntPoint m_UnlitImpactTextureSize;
var(BloodMark) array<R6DecalCreationInfo> m_aBloodMarks;
var(ExplosionDecal) R6DecalCreationInfo m_ExplosionDecal;
var(BloodStain) bool m_bShowBloodStain;
var(BloodStain) float m_fBloodStainGrowthTime;
var(BloodStain) float m_fBloodStainMinSize;
var(BloodStain) float m_fBloodStainMaxSize;
var(BloodStain) float m_fBloodStainHeadSize;
var(BloodStain) Texture2D m_BloodStainTexture;

function R6DecalCreationInfo GetBloodImpact()
{
    return m_aBloodMarks[Rand(m_aBloodMarks.Length)];
    return;
}

defaultproperties
{
    m_iNumColumns=1
    m_iNumRows=1
    m_UnlitImpactTextureSize=(X=45,Y=4)
    m_ExplosionDecal=(m_iStart=(X=45,Y=4),m_iSize=(X=45,Y=4),m_fScale=0.0000000,m_fScaleJitter=1.2000000,m_fProjectionDistance=2.0000000)
    m_bShowBloodStain=true
    m_fBloodStainGrowthTime=1.0000000
    m_szThumbnailTexture="KellerEditorMaterials.Visuals"
    m_szDescription="Impact configuration"
}