class PPA_Boss_Reaper_Spin extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PKPawn_Boss_Reaper_Base(PawnOwner).Mesh.RootMotionMode = 2;
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
    AnimName="Attack_Spin"
    BlendInTime=0.5000000
    BlendOutTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
    SpeedModifier=2.0000000
}