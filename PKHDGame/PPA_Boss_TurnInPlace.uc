class PPA_Boss_TurnInPlace extends EPA_BasePlaySingleAnim;

var int RotDelta;
var int SlotChildIndex;

protected function bool InternalCanDoPawnAction()
{
    local int Delta;
    local PKPawn P;
    local float r2;

    P = PKPawn(PawnOwner);
    // End:0xEA
    if(((P == none) || !P.bIsBoss) || (int(P.CurrentMoveMode) != int(0)) && VSizeSq(P.Velocity) > ((PawnOwner.GroundSpeed * PawnOwner.GroundSpeed) * 0.2500000))
    {
        return false;
    }
    r2 = ((P.IsA('PkPawn_Boss_Giant_Base')) ? 500.0000000 : P.GetCollisionRadius());
    r2 *= r2;
    // End:0x2A2
    if((P.MyEvilAI != none) && ((P.MyEvilAI.Focus != none) && VSizeSq2D(P.MyEvilAI.Focus.Location - P.Location) <= r2) || VSizeSq2D(P.MyEvilAI.GetFocalPoint() - P.Location) <= r2)
    {
        return false;
    }
    RotDelta = NormalizeRotAxis(P.DesiredRotation.Yaw) - NormalizeRotAxis(P.Rotation.Yaw);
    RotDelta = NormalizeRotAxis(RotDelta);
    // End:0x364
    if(RotDelta > 32768)
    {
        RotDelta -= 65536;
    }
    Delta = int(Abs(float(RotDelta)));
    return ((P.bHasTIPAnims45Deg && Delta >= 8192) || P.bHasTIPAnims90Deg && Delta >= 16384) || P.bHasTIPAnims180Deg && Delta >= 32768;
    //return ReturnValue;    
}

private final function PickAnimation()
{
    local string C;
    local int Delta;
    local PKPawn P;

    P = PKPawn(PawnOwner);
    Delta = int(Abs(float(RotDelta)));
    C = ((RotDelta < 0) ? "L" : "R");
    // End:0xB5
    if(P.bHasTIPAnims180Deg && Delta >= 32767)
    {
        AnimName = name(("Rot_" $ C) $ "_180");        
    }
    else
    {
        // End:0x113
        if(P.bHasTIPAnims90Deg && Delta >= 16384)
        {
            AnimName = name(("Rot_" $ C) $ "_90");            
        }
        else
        {
            AnimName = name(("Rot_" $ C) $ "_45");
        }
    }
    // End:0x178
    if(PawnOwner.IsA('PKPawn_Boss_Alastor_Base'))
    {
        BlendInTime = 0.1500000;
        BlendOutTime = 0.1500000;
    }
    //return;    
}

simulated function PlayAnimation()
{
    super.PlayAnimation();
    SlotChildIndex = PKPawn(PawnOwner).FullBodyAnimSlot.CustomChildIndex;
    //return;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local PKPawn P;

    P = PKPawn(PawnOwner);
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.Mesh.RootMotionRotationMode = 1;
    PickAnimation();
    PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify = true;
    PlayAnimation();
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.FullBodyAnimSlot.SetRootBoneRotationOption(2, 2, 2);
    P.bApplyPostTIPYawOffset = false;
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local bool bReallyEnded;

    // End:0x66
    if(PawnOwner == none)
    {
        PawnOwner = EvilPawn(SeqNode.SkelComponent.Owner);
        // End:0x66
        if(PawnOwner == none)
        {
            return;
        }
    }
    // End:0xE0
    if((SeqNode.AnimSeqName != AnimName) || PKPawn(PawnOwner).FullBodyAnimSlot.CustomChildIndex != SlotChildIndex)
    {
        return;
    }
    bReallyEnded = !PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify;
    // End:0x1CA
    if(!bReallyEnded && InternalCanDoPawnAction())
    {
        PickAnimation();
        PlayAnimation();
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
        PawnOwner.FullBodyAnimSlot.SetRootBoneRotationOption(2, 2, 2);        
    }
    else
    {
        // End:0x282
        if(bReallyEnded)
        {
            PKPawn_Boss_Base(PawnOwner).PostTIPYaw = PawnOwner.Rotation.Yaw;
            PKPawn_Boss_Base(PawnOwner).bUsePostTIPYaw = true;
            super(EvilPawnAction).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify = false;
            SeqNode.bCauseActorAnimEnd = true;
        }
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify = true;
    PKPawn(PawnOwner).bApplyPostTIPYawOffset = true;
    PKPawn(PawnOwner).PostRotationYaw = PawnOwner.Rotation.Yaw;
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.Mesh.RootMotionRotationMode = 0;
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    PawnOwner.FullBodyAnimSlot.SetRootBoneRotationOption(1, 1, 1);
    //return;    
}

defaultproperties
{
    BlendInTime=0.5000000
    BlendOutTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}