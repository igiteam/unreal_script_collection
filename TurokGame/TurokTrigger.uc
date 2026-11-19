class TurokTrigger extends Trigger
    native
    hidecategories(Navigation);

struct native tTurokTriggerInitVars
{
    var int mTeamIndex;

    structdefaultproperties
    {
        mTeamIndex=0
    }
};

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) bool mAllowTeamEventsWhenNeutral;
var(Multiplayer) bool mAllowTeamEventsWhenNonTeamGames;
var(Multiplayer) int mTeamIndex;
var private @NULL mInitVars;

simulated event bool AllowTeamSeqEvents(@NULL Other)
{
    local int touchingTeamIndex;

    // End:0x2D
    if(!WorldInfo.GRI.GameClass.default.bTeamGame)
    {
        return mAllowTeamEventsWhenNonTeamGames;
    }
    touchingTeamIndex = int(Other.GetTeamNum());
    return (mAllowTeamEventsWhenNeutral && mTeamIndex == 255) || (mTeamIndex != 255) && touchingTeamIndex == mTeamIndex;
    //return ReturnValue;    
}

function Reset()
{
    mTeamIndex = mInitVars.mTeamIndex;
    super(Actor).Reset();
    //return;    
}

simulated event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    mInitVars.mTeamIndex = mTeamIndex;
    //return;    
}

function OnToggleTeam(@NULL Action)
{
    local bool doSetTeam;
    local @NULL InstigatorInfo;

    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        doSetTeam = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            doSetTeam = false;            
        }
        else
        {
            // End:0x84
            if(Action.InputLinks[2].bHasImpulse)
            {
                doSetTeam = mTeamIndex == 255;                
            }
            else
            {
                return;
            }
        }
    }
    // End:0xD5
    if(doSetTeam)
    {
        Action.GetInstigatorTeamInfo(InstigatorInfo);
        // End:0xD2
        if(InstigatorInfo.mTeamIndex != 255)
        {
            mTeamIndex = InstigatorInfo.mTeamIndex;
        }        
    }
    else
    {
        mTeamIndex = 255;
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokTrigger.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    mAllowTeamEventsWhenNeutral=true
    mAllowTeamEventsWhenNonTeamGames=true
    mTeamIndex=255
    // Reference: CylinderComponent'Default__TurokTrigger.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokTrigger.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}