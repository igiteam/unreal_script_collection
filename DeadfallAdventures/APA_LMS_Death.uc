class APA_LMS_Death extends EPA_DeathAnimWithoutMotors;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    super(EPA_BasePlaySingleAnim).PawnActionStarted(bForced, PrevAction);
    PawnOwner.Mesh.RootMotionDelta.Translation = vect(0.0000000, 0.0000000, 0.0000000);
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.PlayNoGoreDyingEffects();
    //return;    
}

defaultproperties
{
    AnimName="LMS_Wounded_Death"
}