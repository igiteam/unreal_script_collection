class TurokActorIndicator extends TurokIndicatorRepInfo
    abstract
    native
    nativereplication
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var protected const float mUpdateRate;
var protected @NULL mActorTgt;
var protected byte mActorTeamIndex;
var protected @NULL mActorPos;

replication
{
    // Pos:0x000
    if(bNetDirty
        mActorPos, mActorTeamIndex;
}

// Export UTurokActorIndicator::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

protected function UpdateTargetActor()
{
    // End:0xB2
    if(mActorTgt != none)
    {
        // End:0xAF
        if(((mActorPos.X != mActorTgt.Location.X) || mActorPos.Y != mActorTgt.Location.Y) || mActorPos.Z != mActorTgt.Location.Z)
        {
            mActorPos = mActorTgt.Location;
            bNetDirty = true;
        }        
    }
    else
    {
        mActorPos.X = 524288.0000000;
        mActorPos.Y = 524288.0000000;
        mActorPos.Z = 524288.0000000;
        bNetDirty = true;
    }
    //return;    
}

protected function SetTargetActor(@NULL Target, int TeamIndex)
{
    mActorTgt = Target;
    mActorTeamIndex = byte(TeamIndex);
    UpdateTargetActor();
    //return;    
}

function SetMovingTarget(@NULL Target, int TeamIndex)
{
    SetTargetActor(Target, TeamIndex);
    GotoState('TargetMoving');
    //return;    
}

function SetStaticTarget(@NULL Target, int TeamIndex)
{
    SetTargetActor(Target, TeamIndex);
    GotoState('TargetStatic');
    //return;    
}

function @NULL GetTargetPos()
{
    return mActorPos;
    //return ReturnValue;    
}

function Reset()
{
    super(Actor).Reset();
    //return;    
}

simulated function Draw(@NULL HUD)
{
    Render(mActorPos, HUD);
    //return;    
}

state TargetMoving
{
    function BeginState(name prevState)
    {
        SetTimer(mUpdateRate, true, 'UpdateTargetActor');
        //return;        
    }

    function EndState(name NextState)
    {
        ClearTimer('UpdateTargetActor');
        //return;        
    }
    stop;    
}

state TargetStatic
{    stop;    
}

defaultproperties
{
    mUpdateRate=0.5000000
    mActorTeamIndex=255
}