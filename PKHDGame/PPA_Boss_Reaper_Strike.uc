class PPA_Boss_Reaper_Strike extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevAction);
    PKPawn_Boss_Reaper_Base(PawnOwner).Mesh.RootMotionMode = 2;
    PKPawn_Boss_Reaper_Base(PawnOwner).bHitAlready = false;
    // End:0x110
    if(PKPawn_Boss_Reaper_Base(PawnOwner).StrikeHandBoneName == PKPawn_Boss_Reaper_Base(PawnOwner).LeftHandStrikeBone)
    {
        // End:0xFA
        if(Rand(100) > 25)
        {
            AnimName = 'Attack_LeftWing';            
        }
        else
        {
            AnimName = 'Attack_RightWing';
        }        
    }
    else
    {
        // End:0x131
        if(Rand(100) > 25)
        {
            AnimName = 'Attack_RightWing';            
        }
        else
        {
            AnimName = 'Attack_LeftWing';
        }
    }
    // End:0x1AD
    if(AnimName == 'Attack_LeftWing')
    {
        PKPawn_Boss_Reaper_Base(PawnOwner).StrikeHandBoneName = PKPawn_Boss_Reaper_Base(PawnOwner).LeftHandStrikeBone;        
    }
    else
    {
        PKPawn_Boss_Reaper_Base(PawnOwner).StrikeHandBoneName = PKPawn_Boss_Reaper_Base(PawnOwner).RightHandStrikeBone;
    }
    PlayAnimation();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PKPawn_Boss_Reaper_Base(PawnOwner).bIsStriking = false;
    //return;    
}

defaultproperties
{
    AnimName="Attack_RightWing"
    BlendInTime=0.5000000
    BlendOutTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
    SpeedModifier=2.0000000
}