class R6SBActor extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

struct SBTwins
{
    var() int m_iVertex1;
    var() int m_iVertex2;

    structdefaultproperties
    {
        m_iVertex1=0
        m_iVertex2=0
    }
};

struct SBAttachment
{
    var() Actor m_AttachedActor;
    var() int m_iHook;
    var() int m_iTargetX;
    var() int m_iTargetZ;

    structdefaultproperties
    {
        m_AttachedActor=none
        m_iHook=0
        m_iTargetX=0
        m_iTargetZ=0
    }
};

struct SBBox
{
    var() Vector m_vMin;
    var() Vector m_vMax;

    structdefaultproperties
    {
        m_vMin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct SBPlane
{
    var() float m_fDistanceFromOrigin;
    var() float m_fXYPlaneAngle;
    var() float m_fElevationAngle;

    structdefaultproperties
    {
        m_fDistanceFromOrigin=0.0000000
        m_fXYPlaneAngle=0.0000000
        m_fElevationAngle=0.0000000
    }
};

var(SoftBodyActor) editconst export editinline R6SBComponent m_SoftBody;
var(SoftBodyActor) array<Actor> m_NotifyWhenCut;
var(SoftBodyActor) array<SBPlane> m_CollPlanes;
var(SoftBodyActor) array<SBBox> m_CollBoxes;
var(SoftBodyActor) array<Plane> m_CollSpheres;
var(SoftBodyActor) array<SBAttachment> m_AttachedActors;
var(SoftBodyActor) array<SBTwins> m_ExtraTwins;
var(SoftBodyActor) array<Vector> m_AnchorPoints;
var float m_fFragileRadius;
var bool m_bFragile;
var bool m_bSlashed;
var bool m_bIsCustom;

function Stiffen(bool Top)
{
    return;
}

function UnStiffen()
{
    return;
}

function PostBeginPlay()
{
    PostBeginPlay();
    return;
}

function HolderSlash()
{
    // End:0x0F
    if(!m_bSlashed)
    {
        __NFUN_3602__();
    }
    return;
}

function UnRoll()
{
    return;
}

function bool IsRolled()
{
    return false;
    return;
}

function Trigger(Actor other, Pawn EventInstigator, optional name EventID)
{
    return;
}

event CollidedBy(Actor CollidedInstigator, optional Vector HitLocation)
{
    // End:0x1F
    if(m_bFragile && !m_bSlashed)
    {
        __NFUN_3602__(HitLocation);
    }
    return;
}

event Detach(Actor other)
{
    __NFUN_3603__(other);
    return;
}

// Export UR6SBActor::execSBBulletHit(FFrame&, void* const)
native(3600) final function SBBulletHit(Vector Momentum);

// Export UR6SBActor::execSBExplosionHit(FFrame&, void* const)
native(3601) final function SBExplosionHit(Vector Center, Vector Momentum);

// Export UR6SBActor::execSBSlash(FFrame&, void* const)
native(3602) final function SBSlash(optional Vector HitLocation);

// Export UR6SBActor::execRemoveAttach(FFrame&, void* const)
native(3603) final function RemoveAttach(Actor Attach);

// Export UR6SBActor::execAttachPawn(FFrame&, void* const)
native(3604) final function AttachPawn(Pawn P, bool bAttach, optional bool bCanGoDown);

// Export UR6SBActor::execStepClimb(FFrame&, void* const)
native(3605) final function bool StepClimb(bool bGoUp);

defaultproperties
{
    m_fFragileRadius=10000.0000000
    UseCharacterLights=true
    bMovable=false
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    TickGroup=1
    m_supportedExplosionEffects=/* Array type was not detected. */
}