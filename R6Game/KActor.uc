class KActor extends DynamicSMActor
    native
    nativereplication
    placeable
    hidecategories(lighting);

var() bool bDamageAppliesImpulse;
var() bool bWakeOnLevelStart;
var() bool bKickable;
var() bool m_bDamagePawn;
var native const bool m_bWasRolling;
var native const bool m_bWasSliding;
var() float BumpImpulse;
var() float BumpImpulseZOffset;
var() float BumpImpulseMaxSpeed;
var const float m_fLastTimeImpactSoundTriggered;
var() Actor.EAttractorType m_eAttractorType;
var native const RigidBodyState RBState;
var native const float AngErrorAccumulator;
var() float m_fMassOverride;
var native const export editinline PrimitiveComponent m_pLastCollisionComponent;
var native const Vector m_vLastCollisionForce;
var native const float m_fContactSpeedSqr;
var native const float m_fCOMSpeedSqr;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        RBState;
}

// Export UKActor::execInitNotifyCollision(FFrame&, void* const)
native function InitNotifyCollision();

// Export UKActor::execGetMass(FFrame&, void* const)
native final function float GetMass();

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x20
    if(bWakeOnLevelStart)
    {
        StaticMeshComponent.WakeRigidBody();
    }
    InitNotifyCollision();
    return;
}

function ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    local Vector ApplyImpulse;

    ImpulseDir = Normal(ImpulseDir);
    ApplyImpulse = ImpulseDir * ImpulseMag;
    // End:0x5C
    if(HitInfo.HitComponent != none)
    {
        HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);        
    }
    else
    {
        CollisionComponent.AddImpulse(ApplyImpulse, HitLocation);
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        StaticMeshComponent.WakeRigidBody();
    }
    return;
}

simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local array<Object> objVars;
    local int idx;
    local Actor destActor;

    inAction.GetObjectVars(objVars, "Destination");
    idx = 0;
    J0x28:

    // End:0x65 [Loop If]
    if((idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[idx]);
        idx++;
        // [Loop Continue]
        goto J0x28;
    }
    // End:0xA4
    if(destActor != none)
    {
        StaticMeshComponent.SetRBPosition(destActor.Location, destActor.Rotation);
        PlayTeleportEffect(false, true);
    }
    return;
}

event Bump(Actor other, PrimitiveComponent pComponent, Vector vBumpNormal)
{
    local Vector vImpulse, vImpulsePoint, vXdir, vSide, vZdir, vCurPos,
	    vSpeed;

    local Rotator rCurRot;
    local float fSpeed;

    // End:0x1AE
    if((((Pawn(other) != none) && CollisionComponent != none) && BumpImpulse != float(0)) && other.Base != self)
    {
        // End:0xA2
        if(bBlockActors)
        {
            // End:0x8F
            if(Abs(vBumpNormal.Z) < 0.9000000)
            {
                vImpulse = Normal(vBumpNormal) * BumpImpulse;
                CollisionComponent.AddImpulse(vImpulse);                
            }
            else
            {
                CollisionComponent.WakeRigidBody();
            }            
        }
        else
        {
            CollisionComponent.GetRBPosition(vCurPos, rCurRot);
            GetAxes(other.Rotation, vXdir, vSide, vZdir);
            // End:0x10F
            if(((vCurPos - other.Location) Dot vSide) < float(0))
            {
                vImpulse = -vSide;                
            }
            else
            {
                vImpulse = vSide;
            }
            CollisionComponent.GetRBLinearVelocity(vSpeed);
            fSpeed = vSpeed Dot vImpulse;
            // End:0x1AE
            if(fSpeed < BumpImpulseMaxSpeed)
            {
                vImpulse *= float(Min(int(BumpImpulse), int((BumpImpulseMaxSpeed - fSpeed) * GetMass())));
                vImpulsePoint = vCurPos;
                vImpulsePoint.Z += BumpImpulseZOffset;
                CollisionComponent.AddImpulse(vImpulse, vImpulsePoint);
            }
        }
    }
    return;
}

defaultproperties
{
    bDamageAppliesImpulse=true
    bKickable=true
    BumpImpulse=50.0000000
    BumpImpulseZOffset=10.0000000
    BumpImpulseMaxSpeed=1000.0000000
    // Reference: StaticMeshComponent'Default__KActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__DynamicSMActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        WireframeColor=(R=0,G=255,B=128,A=255)
    end object
    StaticMeshComponent=StaticMeshComponent0
    bNoDelete=true
    bStasis=true
    bUpdateSimulatedPosition=true
    bNetInitialRotation=true
    bProjTarget=true
    bCollideSB=true
    bNoEncroachCheck=true
    m_bIgnoreForNavMesh=true
    Components[0]=StaticMeshComponent0
    Physics=10
    RemoteRole=3
    m_eExplosionCollisionOverride=2
    TickGroup=2
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    NetUpdateFrequency=0.1000000
    CollisionComponent=StaticMeshComponent0
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_RigidBodyCollision'
}