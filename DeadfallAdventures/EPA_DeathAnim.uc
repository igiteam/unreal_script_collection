class EPA_DeathAnim extends EPA_DeathAnimBase;

var name DeathAnimName;
var Actor.EPhysics DeathPhys;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.StopCustomAnim(0.0000000);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.StopCustomAnim(0.0000000);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0x17E
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    DeathAnimName = AnimInfo.AnimName;
    super(EPA_BasePlaySingleAnim).PawnActionStarted(bForced, PrevAction);
    PawnOwner.Mesh.RootMotionDelta.Translation = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x2D4
    if((int(PawnOwner.Role) == int(ROLE_Authority)) && !PawnOwner.IsRidingRailCar())
    {
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    DeathAnimBlendToMotors();
    PawnOwner.PlayNoGoreDyingEffects();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.StopAllAnimations();
    PawnOwner.bTearOff = true;
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x2C
    if(SeqNode.AnimSeqName != DeathAnimName)
    {
    }
    PawnOwner.EndPawnAction();
    //return;    
}

simulated function DeathAnimBlendToMotors()
{
    local Actor PawnBase;
    local Vector HitLoc, HitNormal;

    PawnBase = PawnOwner.Base;
    // End:0xBA
    if(PawnBase == none)
    {
        PawnBase = PawnOwner.Trace(HitLoc, HitNormal, PawnOwner.Location + vect(0.0000000, 0.0000000, -128.0000000), PawnOwner.Location);
    }
    // End:0x1C7
    if((PawnBase != none) && PawnBase.bStatic)
    {
        SetSpringForBone(PawnOwner.HipsBoneName, true);
        SetSpringForBone(PawnOwner.RightHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftFootBoneName, true);
        SetSpringForBone(PawnOwner.RightFootBoneName, true);
        super.DeathAnimBlendToMotors();        
    }
    else
    {
        super.DeathAnimBlendToMotors();
        DeathAnimRagDoll();
    }
    //return;    
}

defaultproperties
{
    BlendInTime=0.0000000
}