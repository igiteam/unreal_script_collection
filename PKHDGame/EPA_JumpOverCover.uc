class EPA_JumpOverCover extends EvilPawnAction;

var name AnimCov_Mid_L_Mantle;
var name AnimCov_Mid_R_Mantle;
var name AnimCov_Std_L_Mantle;
var name AnimCov_Std_R_Mantle;

protected function bool InternalCanDoPawnAction()
{
    // End:0x51
    if((int(PawnOwner.CoverType) == int(0)) || PawnOwner.CurrentLink == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    // End:0x142
    if(int(PawnOwner.CoverType) == int(1))
    {
        // End:0xD5
        if(PawnOwner.bIsMirrored)
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Std_L_Mantle, SpeedModifier, 0.1000000 / SpeedModifier, 0.1500000 / SpeedModifier, false);            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Std_R_Mantle, SpeedModifier, 0.1000000 / SpeedModifier, 0.1500000 / SpeedModifier, false);
        }        
    }
    else
    {
        // End:0x1D1
        if(PawnOwner.bIsMirrored)
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Mid_L_Mantle, SpeedModifier, 0.1000000 / SpeedModifier, 0.1500000 / SpeedModifier, false);            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Mid_R_Mantle, SpeedModifier, 0.1000000 / SpeedModifier, 0.1500000 / SpeedModifier, false);
        }
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.SetPhysics(4);
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.ChangeMoveMode(2);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.SetPhysics(2);
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.Velocity = PawnOwner.Mesh.RootMotionVelocity;
    PawnOwner.Acceleration = Normal(PawnOwner.Velocity) * PawnOwner.AccelRate;
    //return;    
}

defaultproperties
{
    AnimCov_Mid_L_Mantle="Cov_Mid_L_Mantle_Full"
    AnimCov_Mid_R_Mantle="Cov_Mid_R_Mantle_Full"
    AnimCov_Std_L_Mantle="Cov_Mid_L_Mantle_Full"
    AnimCov_Std_R_Mantle="Cov_Mid_R_Mantle_Full"
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
    bLockPawnRotation=true
    bCoverExitMirrorTransition=true
    bDisableMovement=true
    bBreakFromCover=true
}