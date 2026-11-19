class R6SBComponentChain extends R6SBComponent
    native
    editinlinenew
    hidecategories(Object);

struct MeshInstance
{
    var Matrix m_LocalToWorld;
    var Matrix m_WorldToLocal;
    var Matrix m_PreviousLocalToWorld;
    var float m_LocalToWorldDeterminant;

    structdefaultproperties
    {
        m_LocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_WorldToLocal=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_PreviousLocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_LocalToWorldDeterminant=0.0000000
    }
};

var(SBChain) StaticMesh m_LinkMesh;
var(SBChain) bool m_bMakesAINoise;
var(SBChain) float m_fLength;
var(SBChain) float m_fOffsetV;
var(SBChain) float m_fRadius;
var(SBChain) int m_iNbSeg;
var array<MeshInstance> m_MeshInstances;
var transient int m_iHitVertex1;
var transient int m_iHitVertex2;
var native const transient Pointer m_pSBCMTCache[2];

event CollidedBy(Actor CollidedInstigator, optional Vector HitLocation)
{
    return;
}

defaultproperties
{
    m_fLength=10.0000000
    m_fRadius=0.7500000
    m_iNbSeg=10
    m_iHitVertex1=-1
    m_iHitVertex2=-1
}