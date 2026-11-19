class MOHAPlayerControllerWithPhysics extends MOHAPlayerController
    config(Game)
    hidecategories(Navigation);

var() export editinline RB_Handle PhysicsGrabber;
var() float WeaponImpulse;
var() float HoldDistanceMin;
var() float HoldDistanceMax;
var() float ThrowImpulse;
var() float ChangeHoldDistanceIncrement;
var float HoldDistance;
var Quat HoldOrientation;

exec function PrevWeapon()
{
    super(PlayerController).PrevWeapon();
    HoldDistance += ChangeHoldDistanceIncrement;
    HoldDistance = FMin(HoldDistance, HoldDistanceMax);
    //return;    
}

exec function NextWeapon()
{
    super(PlayerController).NextWeapon();
    HoldDistance -= ChangeHoldDistanceIncrement;
    HoldDistance = FMax(HoldDistance, HoldDistanceMin);
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    local Vector CamLoc, StartShot, EndShot, X, Y, Z,
	    HitLocation, HitNormal, ZeroVec;

    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local Rotator CamRot;

    GetPlayerViewPoint(CamLoc, CamRot);
    GetAxes(CamRot, X, Y, Z);
    ZeroVec = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0xC4
    if(PhysicsGrabber.GrabbedComponent == none)
    {
        StartShot = CamLoc;
        EndShot = StartShot + (10000.0000000 * X);
        HitActor = Trace(HitLocation, HitNormal, EndShot, StartShot, true, ZeroVec, HitInfo);
        // End:0xC1
        if((HitActor != none) && HitInfo.HitComponent != none)
        {
        }        
    }
    else
    {
        PhysicsGrabber.GrabbedComponent.AddImpulse(X * ThrowImpulse,, PhysicsGrabber.GrabbedBoneName);
        PhysicsGrabber.ReleaseComponent();
    }
    super.StartFire(FireModeNum);
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    local Vector CamLoc, StartShot, EndShot, X, Y, Z,
	    HitLocation, HitNormal, Extent;

    local Actor HitActor;
    local float HitDistance;
    local Quat PawnQuat, InvPawnQuat, ActorQuat;
    local TraceHitInfo HitInfo;
    local editinline SkeletalMeshComponent SkelComp;
    local Rotator CamRot;

    GetPlayerViewPoint(CamLoc, CamRot);
    GetAxes(CamRot, X, Y, Z);
    StartShot = CamLoc;
    EndShot = StartShot + (10000.0000000 * X);
    Extent = vect(0.0000000, 0.0000000, 0.0000000);
    HitActor = Trace(HitLocation, HitNormal, EndShot, StartShot, true, Extent, HitInfo);
    HitDistance = VSize(HitLocation - StartShot);
    // End:0x1FF
    if((((HitActor != none) && HitActor != WorldInfo) && HitDistance > HoldDistanceMin) && HitDistance < HoldDistanceMax)
    {
        PhysicsGrabber.GrabComponent(HitInfo.HitComponent, HitInfo.BoneName, HitLocation, int(bRun) == 0);
        // End:0x1FF
        if(PhysicsGrabber.GrabbedComponent != none)
        {
            HoldDistance = HitDistance;
            PawnQuat = QuatFromRotator(CamRot);
            InvPawnQuat = QuatInvert(PawnQuat);
            // End:0x1BD
            if(HitInfo.BoneName != 'None')
            {
                SkelComp = SkeletalMeshComponent(HitInfo.HitComponent);
                ActorQuat = SkelComp.GetBoneQuaternion(HitInfo.BoneName);                
            }
            else
            {
                ActorQuat = QuatFromRotator(PhysicsGrabber.GrabbedComponent.Owner.Rotation);
            }
            HoldOrientation = QuatProduct(InvPawnQuat, ActorQuat);
        }
    }
    super.StartAltFire(FireModeNum);
    //return;    
}

exec function StopAltFire(optional byte FireModeNum)
{
    // End:0x28
    if(PhysicsGrabber.GrabbedComponent != none)
    {
        PhysicsGrabber.ReleaseComponent();
    }
    //return;    
}

function PlayerTick(float DeltaTime)
{
    local Vector CamLoc, NewHandlePos, X, Y, Z;

    local Quat PawnQuat, NewHandleOrientation;
    local Rotator CamRot;

    super.PlayerTick(DeltaTime);
    // End:0x21
    if(PhysicsGrabber.GrabbedComponent == none)
    {
        return;
    }
    PhysicsGrabber.GrabbedComponent.WakeRigidBody(PhysicsGrabber.GrabbedBoneName);
    GetPlayerViewPoint(CamLoc, CamRot);
    GetAxes(CamRot, X, Y, Z);
    NewHandlePos = CamLoc + (HoldDistance * X);
    PhysicsGrabber.SetLocation(NewHandlePos);
    PawnQuat = QuatFromRotator(CamRot);
    NewHandleOrientation = QuatProduct(PawnQuat, HoldOrientation);
    PhysicsGrabber.SetOrientation(NewHandleOrientation);
    //return;    
}

defaultproperties
{
    // Reference: RB_Handle'Default__MOHAPlayerControllerWithPhysics.RB_Handle0'
    begin object name=RB_Handle0 class=Class'Engine.RB_Handle'
    end object
    PhysicsGrabber=RB_Handle0
    WeaponImpulse=600.0000000
    HoldDistanceMin=50.0000000
    HoldDistanceMax=750.0000000
    ThrowImpulse=800.0000000
    ChangeHoldDistanceIncrement=50.0000000
    // Reference: MOHAPlayerStatsComponent'Default__MOHAPlayerControllerWithPhysics.PlayerStatsComponent'
    begin object name=PlayerStatsComponent
    end object
    playerStats=PlayerStatsComponent
    // Reference: MOHAPostProcessComponent'Default__MOHAPlayerControllerWithPhysics.PostProcessComponent0'
    begin object name=PostProcessComponent0
    end object
    PostProcessComponent=PostProcessComponent0
    // Reference: KynapseEntityComponent'Default__MOHAPlayerControllerWithPhysics.KynapsePlayerEnt0'
    begin object name=KynapsePlayerEnt0
    end object
    KynapseEntityComponent=KynapsePlayerEnt0
    // Reference: StimulusComponent'Default__MOHAPlayerControllerWithPhysics.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: CylinderComponent'Default__MOHAPlayerControllerWithPhysics.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPlayerControllerWithPhysics.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=KynapsePlayerEnt0
    Components[3]=Stimulus0
    Components[4]=PlayerStatsComponent
    Components[5]=PostProcessComponent0
    Components[6]=RB_Handle0
    CollisionComponent=CollisionCylinder
}