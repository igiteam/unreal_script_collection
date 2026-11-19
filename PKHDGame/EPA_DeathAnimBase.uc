class EPA_DeathAnimBase extends EPA_BasePlaySingleAnim
    abstract;

function bool CanOverrideAction(byte inAction)
{
    return (((int(inAction) != 13) && int(inAction) != 14) && int(inAction) != 16) && int(inAction) != 19;
    //return ReturnValue;    
}

protected function bool InternalCanDoPawnAction()
{
    // End:0x71
    if(int(PawnOwner.PawnAction) == 1)
    {
        // End:0x71
        if(int(EPA_FullBodyHitReaction(PawnOwner.PawnActions[1]).CurrentAST) == int(105))
        {
            return false;
        }
    }
    return ((PawnOwner.bForcePlayDeathAnimation || PawnOwner.bShouldPlayDeathAnimationToRagdoll) && int(PawnOwner.Physics) != int(10)) && !PawnOwner.IsJumping();
    //return ReturnValue;    
}

function OnAnimBlendToMotors()
{
    DeathAnimBlendToMotors();
    //return;    
}

function OnPawnKnockDown()
{
    DeathAnimRagDoll();
    //return;    
}

simulated function DeathAnimBlendToMotors()
{
    // End:0x15D
    if(int(PawnOwner.Physics) != int(10))
    {
        PawnOwner.Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
        PawnOwner.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        PawnOwner.AddBaseLinearVelocityUponWhenGoingRagDoll();
        PawnOwner.CollisionComponent = PawnOwner.Mesh;
        PawnOwner.SetPawnRBChannels(true);
        PawnOwner.Mesh.WakeRigidBody();
    }
    PawnOwner.Mesh.PhysicsWeight = 1.0000000;
    PawnOwner.Mesh.bUpdateJointsFromAnimation = true;
    PawnOwner.Mesh.bUpdateKinematicBonesFromAnimation = true;
    PawnOwner.Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(5000.0000000, 250.0000000, 0.0000000, PawnOwner.Mesh, true);
    PawnOwner.Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(true, true, PawnOwner.Mesh, true);
    //return;    
}

simulated function TurnToRagDollPhysics()
{
    // End:0x62
    if(int(PawnOwner.Physics) != int(10))
    {
        PawnOwner.SetPhysics(10);
        PawnOwner.AddBaseLinearVelocityUponWhenGoingRagDoll();
    }
    PawnOwner.Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
    PawnOwner.CollisionComponent = PawnOwner.Mesh;
    PawnOwner.SetCollision(true, false);
    PawnOwner.Mesh.PhysicsWeight = 1.0000000;
    PawnOwner.SetPawnRBChannels(true);
    PawnOwner.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
    PawnOwner.Mesh.bUpdateJointsFromAnimation = false;
    PawnOwner.Mesh.bUpdateKinematicBonesFromAnimation = false;
    PawnOwner.Mesh.WakeRigidBody();
    //return;    
}

simulated function DeathAnimRagDoll()
{
    SetSpringForBone(PawnOwner.HipsBoneName, false);
    SetSpringForBone(PawnOwner.RightHandBoneName, false);
    SetSpringForBone(PawnOwner.LeftHandBoneName, false);
    SetSpringForBone(PawnOwner.LeftFootBoneName, false);
    SetSpringForBone(PawnOwner.RightFootBoneName, false);
    TurnToRagDollPhysics();
    PawnOwner.Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, PawnOwner.Mesh, true);
    PawnOwner.StopAllAnimations();
    //return;    
}

final simulated function SetSpringForBone(name InBoneName, bool bEnable)
{
    local int BoneIndex;
    local Matrix BoneMatrix;
    local RB_BodyInstance BoneBody;

    InBoneName = PawnOwner.Mesh.GetSocketBoneName(InBoneName);
    // End:0x60
    if(InBoneName == 'None')
    {
        return;
    }
    BoneIndex = PawnOwner.Mesh.MatchRefBone(InBoneName);
    // End:0x21E
    if(BoneIndex != -1)
    {
        BoneMatrix = PawnOwner.Mesh.GetBoneMatrix(BoneIndex);
        BoneBody = PawnOwner.Mesh.FindBodyInstanceNamed(InBoneName);
        // End:0x21B
        if(BoneBody != none)
        {
            BoneBody.EnableBoneSpring(bEnable, bEnable, BoneMatrix);
            // End:0x218
            if(bEnable)
            {
                BoneBody.OverextensionThreshold = 50.0000000;
                BoneBody.SetBoneSpringParams(10000.0000000, 500.0000000, 10000.0000000, 500.0000000);
                BoneBody.bDisableOnOverextension = true;
            }            
        }        
    }
    //return;    
}

simulated function OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
    local name HipsBoneName;
    local RB_BodyInstance HipsBodyInstance;

    HipsBoneName = PawnOwner.Mesh.GetSocketBoneName(PawnOwner.HipsBoneName);
    HipsBodyInstance = PawnOwner.Mesh.FindBodyInstanceNamed(HipsBoneName);
    // End:0xED
    if(HipsBodyInstance == BodyInstance)
    {
        PawnOwner.ClearTimer('DeathAnimRagDoll', self);
        DeathAnimRagDoll();
    }
    //return;    
}

simulated function OnDeathAnimBodyRest()
{
    DeathAnimRagDoll();
    PawnOwner.DropDecals(PawnOwner.Location, false, true);
    PawnOwner.DropDecals(PawnOwner.Location, false, true);
    //return;    
}

defaultproperties
{
    bDisablePOIs=true
}