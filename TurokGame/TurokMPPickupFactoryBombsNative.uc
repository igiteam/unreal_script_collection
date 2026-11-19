class TurokMPPickupFactoryBombsNative extends TurokMPObjectiveItemPickup
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer,PickupFactory);

var(Multiplayer) protected const int mMaxBombs;
var protected byte mTeamIndex;
var protected int mRemainingBombs;

// Export UTurokMPPickupFactoryBombsNative::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function InitializePickup()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        ResetBombPool();
    }
    super(PickupFactory).InitializePickup();
    //return;    
}

event Reset()
{
    ResetBombPool();
    EnablePickup();
    //return;    
}

function SetRespawn()
{
    RemoveBombFromPool();
    // End:0x23
    if(!HasBombs())
    {
        DisablePickup();
    }
    //return;    
}

event bool IsAllowedTouch(@NULL Other)
{
    // End:0x12
    if(!super(TurokMPPickupFactory).IsAllowedTouch(Other))
    {
        return false;
    }
    // End:0x23
    if(!HasBombs())
    {
        return false;
    }
    // End:0x63
    if((Other.InvManager == none) || Other.InvManager.FindInventoryType(Class'TurokMPObjectiveItem', true) != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event SetTeamNum(byte TeamIndex)
{
    mTeamIndex = TeamIndex;
    //return;    
}

function bool HasBombs()
{
    return mRemainingBombs > 0;
    //return ReturnValue;    
}

function AddBombToPool()
{
    mRemainingBombs = Min(mRemainingBombs + 1, mMaxBombs);
    //return;    
}

function RemoveBombFromPool()
{
    // DebugMode: 0
    assert(mRemainingBombs > 0);
    --mRemainingBombs;
    //return;    
}

function ResetBombPool()
{
    mRemainingBombs = mMaxBombs;
    //return;    
}

state Pickup
{    stop;    
}

state Sleeping
{
    function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mMaxBombs=1
    mTeamIndex=255
    // Reference: TurokMPGameModeRestriction'Default__TurokMPPickupFactoryBombsNative.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPPickupFactoryBombsNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPPickupFactoryBombsNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPPickupFactoryBombsNative.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPPickupFactoryBombsNative.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPPickupFactoryBombsNative.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPPickupFactoryBombsNative.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    CollisionComponent=CollisionCylinder
}