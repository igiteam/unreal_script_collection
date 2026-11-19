class PPA_Boss_Giant_Base_Action extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    PawnOwner.Mesh.RootMotionMode = 1;
    PlayAnimation();
    //return;    
}

defaultproperties
{
    BlendInTime=1.5000000
    BlendOutTime=1.0000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}