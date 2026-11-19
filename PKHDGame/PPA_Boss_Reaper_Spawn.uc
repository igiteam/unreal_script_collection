class PPA_Boss_Reaper_Spawn extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.SetPhysics(0);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.SetPhysics(1);
    //return;    
}

defaultproperties
{
    AnimName="Colloseum_SpawnEnemies"
    BlendInTime=0.5000000
    BlendOutTime=0.5000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}