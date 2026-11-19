class PPA_Boss_Giant_Death extends PPA_Boss_Giant_Base_Action;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PlayAnimation();
    //return;    
}

defaultproperties
{
    AnimName="Death"
    BlendInTime=2.0000000
    BlendOutTime=0.0000000
}