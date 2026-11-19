class PPA_Boss_Reaper_Strafe extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    switch(PKPawn_Boss_Reaper_Base(PawnOwner).StrafeDirection)
    {
        // End:0x53
        case 'Forward':
            AnimName = 'Strafe_Forward';
            // End:0xBE
            break;
        // End:0x75
        case 'Backward':
            AnimName = 'Strafe_Backward';
            // End:0xBE
            break;
        // End:0x97
        case 'Left':
            AnimName = 'Strafe_Left';
            // End:0xBE
            break;
        // End:0xB9
        case 'Right':
            AnimName = 'Strafe_Right';
            // End:0xBE
            break;
        // End:0xFFFF
        default:
            return;
            break;
    }
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PlayAnimation();
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    super(EvilPawnAction).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    // End:0xC2
    if((PKPawn_Boss_Reaper_Base(PawnOwner).StrafeDirection == 'Forward') || PKPawn_Boss_Reaper_Base(PawnOwner).StrafeDirection == 'Backward')
    {
        PKPawn_Boss_Reaper_Base(PawnOwner).StrafeDirection = 'None';
    }
    //return;    
}

defaultproperties
{
    AnimName="Strafe_Forward"
    BlendInTime=0.1000000
    BlendOutTime=0.1000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
    SpeedModifier=1.2000000
}