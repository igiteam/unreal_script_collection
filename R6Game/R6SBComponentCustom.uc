class R6SBComponentCustom extends R6SBComponent
    native
    editinlinenew
    hidecategories(Object);

struct R6SBCustomTri
{
    var int m_iVertex1;
    var int m_iVertex2;
    var int m_iVertex3;
    var int m_iEdge12;
    var int m_iEdge23;
    var int m_iEdge31;
    var Vector m_vNormal;
    var transient Vector m_vTangent;
    var transient Vector m_vBinormal;

    structdefaultproperties
    {
        m_iVertex1=0
        m_iVertex2=0
        m_iVertex3=0
        m_iEdge12=0
        m_iEdge23=0
        m_iEdge31=0
        m_vNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vTangent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vBinormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct R6SBCustomEdge
{
    var int m_iVertex1;
    var int m_iVertex2;
    var float m_fU;
    var float m_fV;
    var Vector m_vMidPoint;
    var Vector m_vNormal;
    var transient Vector m_vTangent;
    var transient Vector m_vBinormal;

    structdefaultproperties
    {
        m_iVertex1=0
        m_iVertex2=0
        m_fU=0.0000000
        m_fV=0.0000000
        m_vMidPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vTangent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vBinormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct R6SBCustomVertex
{
    var int m_iPhysVertex;
    var transient Vector m_vNormal;
    var transient Vector m_vTangent;
    var transient Vector m_vBinormal;

    structdefaultproperties
    {
        m_iPhysVertex=0
        m_vNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vTangent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vBinormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct SBSubArray
{
    var array<int> m_SubArray;

    structdefaultproperties
    {
        m_SubArray=none
    }
};

var(SBCustom) bool m_bUseSubDiv;
var array<R6SBCustomTri> m_Triangles;
var array<R6SBCustomVertex> m_TriVertices;
var array<R6SBCustomEdge> m_Edges;
var array<SBSubArray> m_Wedges;
var array<int> m_PhysVisMapping;
var transient int m_iHitTri;
var transient bool m_bPrevUseSubDiv;

defaultproperties
{
    m_bUseSubDiv=true
    m_iHitTri=-1
    m_bPrevUseSubDiv=true
    m_fCollRepulse=0.1000000
    m_iNbIter=3
    m_iNbNormalizeIter=2
    m_bCollSubDiv=1
}