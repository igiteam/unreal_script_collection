class TurokMPTeamFlagBase extends TurokMPPickupFactory
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var protected int mTeamIndex;
var(Multiplayer) protected const export editinline @NULL mBaseMeshComponent;
var protected duplicatetransient transient @NULL mFlagTranslation;
var protected duplicatetransient transient @NULL mFlagRotation;
var protected const class<Class> mFlagClassTeam0;
var protected const class<Class> mFlagClassTeam1;
var const @NULL mPickupDroppedFlagSound;
var protected @NULL mBaseMaterialConstant;
var protected const class<Class> mFlagStolenMessage;
var protected const class<Class> mFlagCapturedMessage;
var protected const class<Class> mFlagDroppedMessage;
var protected const class<Class> mFlagRecoveredMessage;

// Export UTurokMPTeamFlagBase::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function InitializePickup()
{
    local class<Class> FlagClass;

    FlagClass = ((mTeamIndex == 0) ? mFlagClassTeam0 : mFlagClassTeam1);
    mBaseMaterialConstant = new (self) Class'Engine.MaterialInstanceConstant';
    mBaseMaterialConstant.SetParent(mBaseMeshComponent.GetMaterial(0));
    mBaseMeshComponent.SetMaterial(0, mBaseMaterialConstant);
    mBaseMaterialConstant.SetScalarParameterValue('SEmssInt', FlagClass.default.mSEmssInt);
    mBaseMaterialConstant.SetVectorParameterValue('VEmssHue', FlagClass.default.mVEmssHue);
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x54
    if(int(Role) == int(ROLE_Authority))
    {
        InventoryType = GetFlagType(byte(mTeamIndex));
        // End:0x44
        if(InventoryType == none)
        {
            DisablePickup();
        }
        UpdateFlagStatus(mPickupEnabled);
    }
    //return;    
}

function Reset()
{
    mPickupEnabled = default.mPickupEnabled;
    SetInitialState();
    //return;    
}

protected simulated function class<Class> GetFlagType(byte TeamIndex)
{
    // End:0x16
    if(int(TeamIndex) == 0)
    {
        return mFlagClassTeam0;        
    }
    else
    {
        // End:0x29
        if(int(TeamIndex) == 1)
        {
            return mFlagClassTeam1;
        }
    }
    // DebugMode: 0
    assert(false);
    return none;
    //return ReturnValue;    
}

simulated function SetPickupHidden()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = true;
    // End:0x3E
    if(PickupMesh != none)
    {
        DetachComponent(PickupMesh);
        PickupMesh = none;
    }
    //return;    
}

simulated function SetFlagColor(class<Class> FlagClass)
{
    local @NULL FlagMaterialInstanceConstant, FlagFlareMaterialInstanceConstant1, FlagFlareMaterialInstanceConstant2;

    FlagMaterialInstanceConstant = new (self) Class'Engine.MaterialInstanceConstant';
    FlagFlareMaterialInstanceConstant1 = new (self) Class'Engine.MaterialInstanceConstant';
    FlagFlareMaterialInstanceConstant2 = new (self) Class'Engine.MaterialInstanceConstant';
    FlagMaterialInstanceConstant.SetParent(MeshComponent(PickupMesh).GetMaterial(0));
    MeshComponent(PickupMesh).SetMaterial(0, FlagMaterialInstanceConstant);
    FlagFlareMaterialInstanceConstant1.SetParent(MeshComponent(PickupMesh).GetMaterial(1));
    MeshComponent(PickupMesh).SetMaterial(1, FlagFlareMaterialInstanceConstant1);
    FlagFlareMaterialInstanceConstant2.SetParent(MeshComponent(PickupMesh).GetMaterial(2));
    MeshComponent(PickupMesh).SetMaterial(2, FlagFlareMaterialInstanceConstant2);
    FlagMaterialInstanceConstant.SetScalarParameterValue('SEmssInt', FlagClass.default.mSEmssInt);
    FlagMaterialInstanceConstant.SetVectorParameterValue('VEmssHue', FlagClass.default.mVEmssHue);
    FlagFlareMaterialInstanceConstant1.SetVectorParameterValue('VEmssHue', FlagClass.default.mVEmssHue);
    FlagFlareMaterialInstanceConstant2.SetVectorParameterValue('VEmssHue', FlagClass.default.mVEmssHue);
    //return;    
}

simulated function SetPickupVisible()
{
    local class<Class> FlagClass;

    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = false;
    FlagClass = class<TurokMPTeamFlag>(InventoryType);
    // End:0xF5
    if(FlagClass != none)
    {
        // End:0x8B
        if(PickupMesh == none)
        {
            PickupMesh = PrimitiveComponent(FlagClass.default.PickupFactoryMesh.Clone(self));
            PickupMesh.SetLightEnvironment(LightEnvironment);
            AttachComponent(PickupMesh);
        }
        // End:0xE6
        if(PickupMesh != none)
        {
            ManageFlagTranslationRotation(FlagClass);
            PickupMesh.SetTickGroup(3);
            PickupMesh.SetTranslation(mFlagTranslation);
            PickupMesh.SetRotation(mFlagRotation);
        }
        SetFlagColor(FlagClass);
    }
    //return;    
}

protected simulated function ManageFlagTranslationRotation(class<Class> InFlagClass)
{
    return;
    //return;    
}

function UpdateFlagStatus(bool bHasFlag)
{
    // End:0x20
    if(bHasFlag)
    {
        SetPickupVisible();
        EnablePickup();        
    }
    else
    {
        SetPickupHidden();
        DisablePickup();
    }
    //return;    
}

protected function bool TouchFlagBase(@NULL Other)
{
    // End:0x16
    if(!IsAllowedTouch(Other))
    {
        return false;
    }
    // End:0x44
    if(!WorldInfo.Game.PickupQuery(Other, InventoryType, self))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SpawnCopyFor(@NULL Recipient)
{
    local @NULL flag;

    flag = TurokMPTeamFlag(__NFUN_278__(InventoryType));
    // End:0x70
    if(flag != none)
    {
        flag.SetMPPickupFactory(self);
        flag.GiveTo(Recipient);
        flag.AnnouncePickup(Recipient);
        UpdateFlagStatus(false);
    }
    //return;    
}

function FlagCaptured(@NULL InstigatorPawn)
{
    // End:0x26
    if(TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        return;
    }
    BroadcastLocalizedMessage(mFlagCapturedMessage, int(InstigatorPawn.GetTeamNum()), InstigatorPawn.PlayerReplicationInfo, none, none);
    //return;    
}

function FlagStolen(@NULL InstigatorPawn)
{
    // End:0x26
    if(TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        return;
    }
    BroadcastLocalizedMessage(mFlagStolenMessage, int(InstigatorPawn.GetTeamNum()), InstigatorPawn.PlayerReplicationInfo, none, none);
    //return;    
}

function FlagAutoReturned()
{
    // End:0x26
    if(TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        return;
    }
    BroadcastLocalizedMessage(mFlagRecoveredMessage, mTeamIndex, none, none, self);
    //return;    
}

function FlagReturned(@NULL InstigatorPawn)
{
    // End:0x26
    if(TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        return;
    }
    BroadcastLocalizedMessage(mFlagRecoveredMessage, int(InstigatorPawn.GetTeamNum()), InstigatorPawn.PlayerReplicationInfo, none, none);
    //return;    
}

function FlagDropped(@NULL InstigatorPawn)
{
    // End:0x26
    if(TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        return;
    }
    BroadcastLocalizedMessage(mFlagDroppedMessage, int(InstigatorPawn.GetTeamNum()), InstigatorPawn.PlayerReplicationInfo, none, none);
    //return;    
}

function FlagRespawn(float FlagRespawnTime)
{
    // DebugMode: 0
    assert(false);
    //return;    
}

simulated function OnToggle(@NULL Action)
{
    // DebugMode: 0
    assert(false);
    //return;    
}

state Pickup
{
    event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL TP;

        TP = TurokPawnPlayer(Other);
        // End:0x3C
        if(TP != none)
        {
            // End:0x3C
            if(TouchFlagBase(TP))
            {
                GiveTo(TP);
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x49
        if(TurokFlagGame(WorldInfo.Game) != none)
        {
            TurokFlagGame(WorldInfo.Game).UpdateFlagState(int(GetTeamNum()), 0, self);
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
Begin:

    stop;                
}

state Sleeping
{
    event Touch(@NULL Recipient, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL TP;

        TP = TurokPawnPlayer(Recipient);
        // End:0x2A
        if(TP != none)
        {
            TouchFlagBase(TP);
        }
        //return;        
    }

    function FlagRespawn(float FlagRespawnTime)
    {
        SetTimer(FlagRespawnTime, false, 'RespawnFlag');
        //return;        
    }

    protected function RespawnFlag()
    {
        UpdateFlagStatus(true);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('RespawnFlag');
        //return;        
    }
Begin:

    stop;                
}

defaultproperties
{
    mTeamIndex=255
    // Reference: StaticMeshComponent'Default__TurokMPTeamFlagBase.BaseMesh'
    begin object name=BaseMesh class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Static=true)
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        TickGroup=3
    end object
    mBaseMeshComponent=BaseMesh
    // Reference: TurokMPGameModeRestriction'Default__TurokMPTeamFlagBase.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPTeamFlagBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPTeamFlagBase.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPTeamFlagBase.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPTeamFlagBase.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bBlockActors=true
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPTeamFlagBase.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPTeamFlagBase.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=MyLightEnvironment
    Components[5]=BaseMesh
    CollisionComponent=CollisionCylinder
}