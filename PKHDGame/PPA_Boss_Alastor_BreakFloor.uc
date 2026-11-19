class PPA_Boss_Alastor_BreakFloor extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PlayAnimation();
    //return;    
}

defaultproperties
{
    AnimName="break_flor_new"
    BlendInTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}