class EPA_CoverSlip extends EvilPawnAction;

var name AnimCov_Mid_L_Slip;
var name AnimCov_Mid_R_Slip;
var name AnimCov_Std_L_Slip;
var name AnimCov_Std_R_Slip;

protected function bool InternalCanDoPawnAction()
{
    // End:0x51
    if((int(PawnOwner.CoverType) == int(0)) || PawnOwner.CurrentLink == none)
    {
        return false;
    }
    // End:0x229
    if((PawnOwner.bIsMirrored && !PawnOwner.CurrentLink.Slots[PawnOwner.CurrentSlotIdx].bCanCoverSlip_Left || !PawnOwner.CurrentLink.IsLeftEdgeSlot(PawnOwner.CurrentSlotIdx, true)) || !PawnOwner.bIsMirrored && !PawnOwner.CurrentLink.Slots[PawnOwner.CurrentSlotIdx].bCanCoverSlip_Right || !PawnOwner.CurrentLink.IsRightEdgeSlot(PawnOwner.CurrentSlotIdx, true))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    StartCoverSlip();
    //return;    
}

function StartCoverSlip()
{
    // End:0x125
    if(int(PawnOwner.CoverType) == int(1))
    {
        // End:0xB8
        if(PawnOwner.bIsMirrored)
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Std_L_Slip, SpeedModifier, 0.1000000 / SpeedModifier, 0.2500000 / SpeedModifier, false);            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Std_R_Slip, SpeedModifier, 0.1000000 / SpeedModifier, 0.2500000 / SpeedModifier, false);
        }        
    }
    else
    {
        // End:0x1B4
        if(PawnOwner.bIsMirrored)
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Mid_L_Slip, SpeedModifier, 0.1000000 / SpeedModifier, 0.2500000 / SpeedModifier, false);            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimCov_Mid_R_Slip, SpeedModifier, 0.1000000 / SpeedModifier, 0.2500000 / SpeedModifier, false);
        }
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.ChangeMoveMode(2);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.Velocity = PawnOwner.Mesh.RootMotionVelocity;
    PawnOwner.Acceleration = Normal(PawnOwner.Velocity) * PawnOwner.AccelRate;
    // End:0x212
    if(PawnOwner.Controller != none)
    {
        PawnOwner.Controller.SetFocalPoint(PawnOwner.Location + (256.0000000 * Vector(PawnOwner.Rotation)));
    }
    //return;    
}

defaultproperties
{
    AnimCov_Mid_L_Slip="Cov_Mid_L_Slip"
    AnimCov_Mid_R_Slip="Cov_Mid_R_Slip"
    AnimCov_Std_L_Slip="Cov_Std_L_Slip"
    AnimCov_Std_R_Slip="Cov_Std_R_Slip"
    bLockPawnRotation=true
    bCoverExitMirrorTransition=true
    bDisableMovement=true
    bBreakFromCover=true
}