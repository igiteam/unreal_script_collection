class TurokMPViewpoint extends TurokMPNavPoint
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

enum ViewpointReason
{
    ViewpointReason_JustConnected,  // 0
    ViewpointReason_GameJustEnded,  // 1
    ViewpointReason_MAX             // 2
};

enum ViewpointAssign
{
    ViewpointAssign_Team0,          // 0
    ViewpointAssign_Team1,          // 1
    ViewpointAssign_MAX             // 2
};

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) private byte mViewpointReason;
var(Multiplayer) private byte mViewpointAssign;

simulated function byte GetViewpointReason()
{
    return mViewpointReason;
    //return ReturnValue;    
}

simulated function byte GetViewpointAssign()
{
    return mViewpointAssign;
    //return ReturnValue;    
}

simulated function NotifyActivation(@NULL TPC)
{
    local @NULL MPViewPointEvent;
    local array MPEventIndices;

    // End:0x71
    if((TPC != none) && TPC.IsLocalPlayerController())
    {
        // End:0x71
        if(GeneratedEvents.Length != 0)
        {
            MPViewPointEvent = TurokSeqEvent_MPViewpoint(GeneratedEvents[0]);
            // End:0x71
            if(MPViewPointEvent != none)
            {
                MPEventIndices[0] = 0;
                MPViewPointEvent.CheckActivate(self, TPC, false, MPEventIndices);
            }
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPViewpoint.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: CylinderComponent'Default__TurokMPViewpoint.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPViewpoint.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPViewpoint.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPViewpoint.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPViewpoint.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}