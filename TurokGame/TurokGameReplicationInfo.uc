class TurokGameReplicationInfo extends GameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var protected byte mDifficultyLevel;
var protected bool mInventoryMovementPenalty;

replication
{
    // Pos:0x000
    if(bNetInitial
        mDifficultyLevel, mInventoryMovementPenalty;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mDifficultyLevel = Class'TurokEngine.TurokUI'.static.GetEngine().GetDifficultySystem().GetDifficultyLevel();
    //return;    
}

simulated function byte GetDifficultyLevel()
{
    return mDifficultyLevel;
    //return ReturnValue;    
}

simulated event bool ApplyInventoryMovementPenalty()
{
    return mInventoryMovementPenalty;
    //return ReturnValue;    
}

defaultproperties
{
    mDifficultyLevel=1
}