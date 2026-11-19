class TurokMPPickupFactoryPowerCoreNative extends TurokMPObjectiveItemPickup
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer,Multiplayer);

var(Multiplayer) protected const int mOwningTeamIndex;

// Export UTurokMPPickupFactoryPowerCoreNative::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

event bool IsAllowedTouch(@NULL pwn)
{
    // End:0x39
    if(super(TurokMPPickupFactory).IsAllowedTouch(pwn))
    {
        return (mOwningTeamIndex == 255) || mOwningTeamIndex == int(pwn.GetTeamNum());
    }
    return false;
    //return ReturnValue;    
}

state Pickup
{
    function BeginState(name prevState)
    {
        super.BeginState(prevState);
        // End:0x30
        if(prevState == 'Sleeping')
        {
            TriggerEventClass(Class'TurokSeqEvent_PowerCoreReturned', self);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mOwningTeamIndex=255
    // Reference: TurokMPGameModeRestriction'Default__TurokMPPickupFactoryPowerCoreNative.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPPickupFactoryPowerCoreNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPPickupFactoryPowerCoreNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPPickupFactoryPowerCoreNative.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPPickupFactoryPowerCoreNative.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bCollideWorld=true
    bBlockActors=true
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPPickupFactoryPowerCoreNative.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPPickupFactoryPowerCoreNative.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}