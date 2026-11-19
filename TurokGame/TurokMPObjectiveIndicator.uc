class TurokMPObjectiveIndicator extends TurokActorIndicator
    native
    nativereplication
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var private int mObjectiveHashID;
var private repnotify int mObjectiveToggle;
var private int mDelayedTryCount;

replication
{
    // Pos:0x000
    if(bNetDirty
        mObjectiveHashID, mObjectiveToggle;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2C
    if(VarName == 'mObjectiveToggle')
    {
        mDelayedTryCount = 0;
        SetObjectiveHashID(mObjectiveHashID);        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function bool CanDraw(@NULL HUD)
{
    // DebugMode: 0
    assert(HUD != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner.PlayerReplicationInfo != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner.PlayerReplicationInfo.Team != none);
    // End:0xB7
    if(((mActorPos.X == 524288.0000000) || mActorPos.Y == 524288.0000000) || mActorPos.Z == 524288.0000000)
    {
        return false;
    }
    return int(mActorTeamIndex) == int(HUD.PlayerOwner.GetTeamNum());
    //return ReturnValue;    
}

simulated function int GetObjectiveHashID()
{
    return mObjectiveHashID;
    //return ReturnValue;    
}

simulated function SetObjectiveHashIDDelayedTry()
{
    // End:0x16
    if(mDelayedTryCount > 9)
    {
        mDelayedTryCount = 0;        
    }
    else
    {
        SetObjectiveHashID(mObjectiveHashID);
        mDelayedTryCount++;
    }
    //return;    
}

simulated function SetObjectiveHashID(int hashID)
{
    local @NULL TPC, H;

    // End:0x47
    if((int(Role) == int(ROLE_Authority)) && (mDelayedTryCount == 0) || mObjectiveHashID != hashID)
    {
        mObjectiveHashID = hashID;
        mObjectiveToggle++;
        mDelayedTryCount = 0;
    }
    // End:0xEC
    foreach LocalPlayerControllers(TPC)
    {
        H = TurokWarGameHud(TPC.myHUD);
        // End:0xAD
        if((H == none) || int(TPC.GetTeamNum()) == 255)
        {
            SetTimer(0.5000000, false, 'SetObjectiveHashIDDelayedTry');            
        }
        else
        {
            // End:0xE8
            if(int(mActorTeamIndex) == int(TPC.GetTeamNum()))
            {
                H.ShowChangedObjective();
                mDelayedTryCount = 0;
            }
        }
        // End:0xEC
        break;        
    }    
    //return;    
}
