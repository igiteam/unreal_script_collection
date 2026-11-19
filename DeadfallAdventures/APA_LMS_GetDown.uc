class APA_LMS_GetDown extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local AdvPlayerControllerMP PC;

    PC = AdvPlayerControllerMP(PawnOwner.Controller);
    // End:0x81
    if(PC != none)
    {
        PC.IgnoreMoveInput(true);
        PC.bForceNetUpdate = true;
    }
    PawnOwner.ZeroMovementVariables();
    PawnOwner.bForceNetUpdate = true;
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.Mesh.RootMotionDelta.Translation = vect(0.0000000, 0.0000000, 0.0000000);
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    //return;    
}

defaultproperties
{
    AnimName="LMS_Wounded_Long1"
}