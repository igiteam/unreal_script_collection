class R6DistanceFogParams extends R6Config
    native
    hidecategories(Object);

struct R6Fog
{
    var() LinearColor m_Color;
    var() float m_fDistanceStart;
    var() float m_fDistanceEnd;
    var() float m_fDistanceFalloff;
    var() float m_fDistanceStrength;
    var float m_fDistanceTensor;
    var() float m_fHeightStart;
    var() float m_fHeightEnd;
    var() float m_fHeightFalloff;
    var() float m_fHeightStrength;
    var float m_fHeightTensor;
    var bool m_bActive;

    structdefaultproperties
    {
        m_Color=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
        m_fDistanceStart=0.0000000
        m_fDistanceEnd=1000000000.0000000
        m_fDistanceFalloff=0.5000000
        m_fDistanceStrength=1.0000000
        m_fDistanceTensor=1000.0000000
        m_fHeightStart=0.0000000
        m_fHeightEnd=1000000000.0000000
        m_fHeightFalloff=0.5000000
        m_fHeightStrength=1.0000000
        m_fHeightTensor=1000.0000000
        m_bActive=false
    }
};

var(Fog) R6Fog m_Fog;

defaultproperties
{
    m_Fog=(m_Color=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000),m_fDistanceStart=0.0000000,m_fDistanceEnd=1000000000.0000000,m_fDistanceFalloff=0.5000000,m_fDistanceStrength=1.0000000,m_fDistanceTensor=1000.0000000,m_fHeightStart=0.0000000,m_fHeightEnd=1000000000.0000000,m_fHeightFalloff=0.5000000,m_fHeightStrength=1.0000000,m_fHeightTensor=1000.0000000,m_bActive=false)
    m_szThumbnailTexture="KellerEditorMaterials.Visuals"
    m_szDescription="R6DistanceFogParams"
}