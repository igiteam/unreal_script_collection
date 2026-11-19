class R6SBComponentRapelRope extends R6SBComponentRope
    native
    editinlinenew
    hidecategories(Object,Object);

enum ERapelRopeAttach
{
    ERRA_None,                      // 0
    ERRA_LeftHand,                  // 1
    ERRA_RightHand,                 // 2
    ERRA_Spine,                     // 3
    ERRA_SpineFront,                // 4
    ERRA_MAX                        // 5
};

var float m_fDesiredSegLength;
var int m_iMaxNbSeg;
var int m_iOriginalNbSeg;
var transient R6InteractiveRope m_pInteractiveRope;
var transient int m_iOldNbAttach;
var bool m_bIsRolled;
var bool m_bNeedUpdateRessources;
var bool m_bUserJustAdded;
var transient R6SBComponentRapelRope.ERapelRopeAttach m_aAttach[4];
var transient bool m_bRejectAttach;

defaultproperties
{
    m_fDesiredSegLength=30.0000000
    m_iMaxNbSeg=50
    m_iOriginalNbSeg=-1
    m_fRadius=1.0000000
    m_fScaleU=4.0000000
    m_fScaleV=0.2000000
    m_bCollActor=true
    m_fFriction=0.5000000
    m_iNbNormalizeIter=4
    m_fDragForce=120.0000000
    m_fAirFriction=60.0000000
    BlockActors=false
    BlockRigidBody=false
}