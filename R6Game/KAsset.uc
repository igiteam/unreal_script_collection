class KAsset extends Actor
    native
    placeable
    hidecategories(lighting);

var(Display) const editconst export editinline SkeletalMeshComponent SkeletalMeshComponent;
var() bool bDamageAppliesImpulse;
var() bool bWakeOnLevelStart;
var(Bump) float BumpImpulse;
var(Bump) float BumpImpulseZOffset;
var(Bump) float BumpImpulseMaxSpeed;
var name BumpBone;

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x20
    if(bWakeOnLevelStart)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
    return;
}

simulated function OnTeleport(SeqAct_Teleport inAction)
{
    return;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    Attachment.SetBase(self,, SkeletalMeshComponent, Action.BoneName);
    return;
}

event Bump(Actor other, PrimitiveComponent pComponent, Vector vBumpNormal)
{
    local Vector vImpulse, vImpulsePoint, vXdir, vSide, vZdir, vCurPos,
	    vSpeed;

    local Rotator rCurRot;

    // End:0x193
    if(((Pawn(other) != none) && SkeletalMeshComponent != none) && BumpImpulse != float(0))
    {
        // End:0xA6
        if(bBlockActors)
        {
            vImpulse = Normal(vBumpNormal) * BumpImpulse;
            vImpulsePoint = other.Location + (Normal(vBumpNormal) * Pawn(other).CylinderComponent.CollisionRadius);
            SkeletalMeshComponent.AddImpulse(vImpulse, vImpulsePoint, BumpBone);            
        }
        else
        {
            SkeletalMeshComponent.GetRBPosition(vCurPos, rCurRot, BumpBone);
            GetAxes(other.Rotation, vXdir, vSide, vZdir);
            // End:0x117
            if(((vCurPos - other.Location) Dot vSide) < float(0))
            {
                vImpulse = -vSide;                
            }
            else
            {
                vImpulse = vSide;
            }
            SkeletalMeshComponent.GetRBLinearVelocity(vSpeed);
            // End:0x193
            if((vSpeed Dot vImpulse) < BumpImpulseMaxSpeed)
            {
                vImpulse *= BumpImpulse;
                vImpulsePoint = vCurPos;
                vImpulsePoint.Z += BumpImpulseZOffset;
                SkeletalMeshComponent.AddImpulse(vImpulse, vImpulsePoint, BumpBone);
            }
        }
    }
    return;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__KAsset.KAssetSkelMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="KAssetSkelMeshComponent" class=Class'SkeletalMeshComponent'
        PhysicsWeight=1.0000000
    end object
    SkeletalMeshComponent=KAssetSkelMeshComponent
    bDamageAppliesImpulse=true
    BumpImpulse=50.0000000
    BumpImpulseZOffset=10.0000000
    BumpImpulseMaxSpeed=1000.0000000
    bNoDelete=true
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    bNetInitialRotation=true
    UseCharacterLights=true
    bCollideActors=true
    bProjTarget=true
    bEdShouldSnap=true
    m_bIgnoreForNavMesh=true
    Components[0]=KAssetSkelMeshComponent
    Physics=10
    RemoteRole=1
    m_eExplosionCollisionOverride=2
    TickGroup=2
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=KAssetSkelMeshComponent
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_ConstraintBroken'
    SupportedEvents[5]=Class'SeqEvent_RigidBodyCollision'
}