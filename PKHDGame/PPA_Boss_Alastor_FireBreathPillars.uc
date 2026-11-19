class PPA_Boss_Alastor_FireBreathPillars extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PlayAnimation();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}

defaultproperties
{
    AnimName="atak5"
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
    bLockPawnRotation=true
    bDisableMovement=true
    bDisableTurnInPlace=true
}