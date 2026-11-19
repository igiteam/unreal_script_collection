class R6SBComponent extends PrimitiveComponent
    abstract
    native;

enum ESBUpdateStatus
{
    ESBUS_DoUpdate,                 // 0
    ESBUS_DontUpdate,               // 1
    ESBUS_ForceUpdate,              // 2
    ESBUS_MAX                       // 3
};

struct SBVertex
{
    var int m_iFlags;
    var Vector m_vPos;
    var Vector m_vPrevPos;
    var Vector m_vAccel;
    var Vector m_vForce;
    var Vector m_vInstForce;
    var float m_fU;
    var float m_fV;

    structdefaultproperties
    {
        m_iFlags=0
        m_vPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPrevPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vAccel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vForce=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vInstForce=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fU=0.0000000
        m_fV=0.0000000
    }
};

struct SBLengthConstraint
{
    var int m_iV1;
    var int m_iV2;
    var float m_fLength;

    structdefaultproperties
    {
        m_iV1=0
        m_iV2=0
        m_fLength=0.0000000
    }
};

struct SBLocalActor
{
    var Actor m_Actor;
    var Vector m_vLocalPos;
    var Vector m_vLocalVel;

    structdefaultproperties
    {
        m_Actor=none
        m_vLocalPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLocalVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var(SoftBodyComponent) Vector m_vGravity;
var(SoftBodyComponent) bool m_bCollActor;
var(SoftBodyComponent) bool m_bCollWorld;
var(SoftBodyComponent) bool m_bPillsTest;
var(SoftBodyComponent) bool m_bGravInWorld;
var(SoftBodyComponent) bool m_bUpdateOnlyWhenVisible;
var(SoftBodyComponent) bool m_bAttachPreferX;
var(SoftBodyComponent) bool m_bAttachFlipZ;
var(wind) bool m_bAcceptWind;
var(SoftBodyComponent) float m_fFriction;
var(SoftBodyComponent) float m_fCollRepulse;
var(SoftBodyComponent) float m_fCollWorldOffset;
var(SoftBodyComponent) int m_iNbIter;
var(SoftBodyComponent) int m_iNbNormalizeIter;
var(SoftBodyComponent) int m_bCollSubDiv;
var(SoftBodyComponent) float m_fDragForce;
var(SoftBodyComponent) float m_fAirFriction;
var(SoftBodyComponent) float m_fHitDamping;
var(SoftBodyComponent) float m_fStiffness;
var(Material) MaterialInstance m_Material;
var(wind) float m_fScaleWind;
var(R6Sound) /*0x44000000-0x00000000*/ R6SoundSoftBodyParams m_SoundSoftBodyParams;
var transient bool m_bCrossingSoundPlaying;
var transient bool m_bContactWithHumanControlled;
var transient bool m_bBuilt;
var array<SBVertex> m_Vertices;
var array<SBLengthConstraint> m_Rods;
var array<SBTwins> m_Twins;
var array<SBTwins> m_ExtraTwins;
var array<Plane> m_CollPlanes;
var array<Box> m_CollBoxes;
var array<Plane> m_CollSpheres;
var array<SBAttachment> m_AttachedActors;
var R6SBComponent.ESBUpdateStatus m_eUpdateStatus;
var transient array<SBLocalActor> m_CollActors;
var transient float m_fDeltaTime;
var transient float m_fPrevDT;
var transient float m_fWarmupTime;
var transient Rotator m_rPrevRot;
var transient Vector m_vPrevPos;
var native const transient Pointer m_ObjectMesh;
var transient Box m_CachedBounds;

// Export UR6SBComponent::execApplyImpulseEffect(FFrame&, void* const)
native final function ApplyImpulseEffect(Vector vOrigin, float fRadius, float fStrength, Vector vImpulse);

defaultproperties
{
    m_vGravity=(X=0.0000000,Y=0.0000000,Z=-980.0000000)
    m_bGravInWorld=true
    m_bUpdateOnlyWhenVisible=true
    m_fCollWorldOffset=3.0000000
    m_iNbIter=1
    m_iNbNormalizeIter=1
    m_fDragForce=60.0000000
    m_fHitDamping=1.0000000
    m_fScaleWind=1.0000000
    bSpecialForceDynamicShadow=true
    CollideActors=true
    BlockActors=true
    BlockZeroExtent=true
    BlockNonZeroExtent=true
    BlockRigidBody=true
    TickGroup=0
}