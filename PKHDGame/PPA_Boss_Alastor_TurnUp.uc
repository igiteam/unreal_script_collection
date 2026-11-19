class PPA_Boss_Alastor_TurnUp extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 1);
    PawnOwner.Mesh.RootMotionMode = 2;
    PlayAnimation();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}

defaultproperties
{
    AnimName="Break_flor4Fly_up"
    BlendInTime=0.5000000
    BlendOutTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}