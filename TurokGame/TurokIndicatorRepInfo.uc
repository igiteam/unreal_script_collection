class TurokIndicatorRepInfo extends ReplicationInfo
    abstract
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int mAttachIndex;
var private bool mIsEnabled;
var private float mAnimationPeriod;
var private @NULL mObjectiveIndicator;
var config @NULL IndicatorColour;

// Export UTurokIndicatorRepInfo::execRender(FFrame&, void* const)
native function Render(@NULL positionInWorld, @NULL HUD);

simulated function bool CanDraw(@NULL HUD)
{
    return mIsEnabled;
    //return ReturnValue;    
}

simulated function Draw(@NULL HUD)
{
    //return;    
}

simulated function DrawInitialize()
{
    // End:0x1E
    if(mObjectiveIndicator != none)
    {
        mObjectiveIndicator.ShowIndicator();
    }
    //return;    
}

event Activate()
{
    // DebugMode: 0
    assert(TurokMPGameReplicationInfo(WorldInfo.GRI) != none);
    // End:0x4F
    if(!mIsEnabled)
    {
        mIsEnabled = true;
        TurokMPGameReplicationInfo(WorldInfo.GRI).AddIndicator(self);
    }
    //return;    
}

event Deactivate()
{
    // DebugMode: 0
    assert(TurokMPGameReplicationInfo(WorldInfo.GRI) != none);
    // End:0x4D
    if(mIsEnabled)
    {
        mIsEnabled = false;
        TurokMPGameReplicationInfo(WorldInfo.GRI).RemoveIndicator(self);
    }
    //return;    
}

event Destroyed()
{
    Deactivate();
    super(Actor).Destroyed();
    //return;    
}

defaultproperties
{
    mAttachIndex=-1
    IndicatorColour=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    TickGroup=1
    NetUpdateFrequency=2.0000000
}