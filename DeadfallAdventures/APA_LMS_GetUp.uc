class APA_LMS_GetUp extends EPA_BasePlaySingleAnim;

function bool CanOverrideAction(byte inAction)
{
    return (int(inAction) == 40) || int(inAction) == 38;
    //return ReturnValue;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    // End:0x5C
    if(AdvPlayerPawnMP(PawnOwner) != none)
    {
        AdvPlayerPawnMP(PawnOwner).RescueFinished();
    }
    //return;    
}

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local AdvPlayerControllerMP PC;

    PC = AdvPlayerControllerMP(PawnOwner.Controller);
    // End:0x81
    if(PC != none)
    {
        PC.IgnoreMoveInput(false);
        PC.bForceNetUpdate = true;
    }
    PawnOwner.ZeroMovementVariables();
    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.Mesh.RootMotionDelta.Translation = vect(0.0000000, 0.0000000, 0.0000000);
    PawnOwner.Mesh.RootMotionMode = 2;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    //return;    
}

defaultproperties
{
    AnimName="LMS_Wounded_GetUp"
}