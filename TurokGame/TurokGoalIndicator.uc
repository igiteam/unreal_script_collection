class TurokGoalIndicator extends TurokIndicatorRepInfo
    native
    nativereplication
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var private @NULL mGoalOwner;

replication
{
    // Pos:0x000
    if(bNetInitial
        mGoalOwner;
}

function Initialize(@NULL Goal)
{
    mGoalOwner = Goal;
    //return;    
}

simulated function bool CanDraw(@NULL HUD)
{
    // DebugMode: 0
    assert(HUD != none);
    // DebugMode: 0
    assert(mGoalOwner != none);
    return int(mGoalOwner.GetCoopTeamGoalType()) == int(1);
    //return ReturnValue;    
}

simulated function Draw(@NULL HUD)
{
    Render(mGoalOwner.Location, HUD);
    //return;    
}
