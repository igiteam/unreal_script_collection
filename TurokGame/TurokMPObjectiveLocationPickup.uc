class TurokMPObjectiveLocationPickup extends TurokMPPickupFactory
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer,Multiplayer);

var(Multiplayer) protected const byte mOwningTeamIndex;
var(Multiplayer) protected const bool mCanBeRecaptured;
var(Multiplayer) protected const bool mRecaptureReturn;
var(Multiplayer) protected const export editinline @NULL mBaseMesh;
var(Multiplayer) protected const export editinline @NULL mCompletedMesh;
var(Multiplayer) protected const editinline @NULL mAttachmentTranslation;
var(Multiplayer) protected const editinline @NULL mAttachmentRotation;
var protected int mCaptorTeamIndex;
var protected @NULL mMPPickupFactory;

// Export UTurokMPObjectiveLocationPickup::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function InitializePickup()
{
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x38
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2E
        if(mPickupEnabled)
        {
            EnablePickup();            
        }
        else
        {
            DisablePickup();
        }
    }
    //return;    
}

function Reset()
{
    mPickupEnabled = default.mPickupEnabled;
    mMPPickupFactory = none;
    SetInitialState();
    //return;    
}

function int GetCaptorTeamIndex()
{
    return mCaptorTeamIndex;
    //return ReturnValue;    
}

simulated function class<Class> GetObjectiveItemClass()
{
    return class<TurokMPObjectiveItem>(InventoryType);
    //return ReturnValue;    
}

function EnablePickup()
{
    mPickupEnabled = true;
    SetPickupVisible();
    // End:0x2C
    if(mCanBeRecaptured)
    {
        GotoState('Pickup');        
    }
    else
    {
        GotoState('Complete');
    }
    //return;    
}

function DisablePickup()
{
    mPickupEnabled = false;
    SetPickupHidden();
    // End:0x32
    if(!IsInState('Sleeping'))
    {
        GotoState('Sleeping');
    }
    //return;    
}

simulated function SetPickupHidden()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = true;
    // End:0x4E
    if(PickupMesh != none)
    {
        PickupMesh.SetHidden(true);
        DetachComponent(PickupMesh);
        PickupMesh = none;
    }
    //return;    
}

simulated function SetPickupVisible()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = false;
    // End:0xA7
    if(PickupMesh == none)
    {
        PickupMesh = mCompletedMesh;
        PickupMesh.SetHidden(false);
        PickupMesh.SetLightEnvironment(LightEnvironment);
        AttachComponent(PickupMesh);
        PickupMesh.SetTickGroup(3);
        PickupMesh.SetTranslation(mAttachmentTranslation);
        PickupMesh.SetRotation(mAttachmentRotation);
    }
    //return;    
}

protected function ObjectiveGained(@NULL InstigatorPawn)
{
    TriggerEventClass(Class'TurokSeqEvent_GoalGained', self);
    // End:0x6D
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(InstigatorPawn.Controller, static.GetObjectiveItemClass().default.mCompletedObjectiveType);
    }
    //return;    
}

protected function ObjectiveStolen(@NULL InstigatorPawn)
{
    TriggerEventClass(Class'TurokSeqEvent_GoalLost', self);
    // End:0x6D
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(InstigatorPawn.Controller, static.GetObjectiveItemClass().default.mPickupObjectiveType);
    }
    //return;    
}

function SpawnCopyFor(@NULL pwn)
{
    local @NULL Item;

    Item = TurokMPObjectiveItem(__NFUN_278__(InventoryType));
    // End:0x7C
    if(Item != none)
    {
        // DebugMode: 0
        assert(mMPPickupFactory != none);
        Item.SetMPPickupFactory(mMPPickupFactory);
        mMPPickupFactory = none;
        Item.GiveTo(pwn);
        Item.AnnouncePickup(pwn);
    }
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
    event bool IsAllowedTouch(@NULL pwn)
    {
        // End:0x5E
        if(super(TurokMPPickupFactory).IsAllowedTouch(pwn))
        {
            // End:0x5E
            if(mCaptorTeamIndex != int(pwn.GetTeamNum()))
            {
                return mRecaptureReturn || pwn.InvManager.FindInventoryType(Class'TurokMPObjectiveItem', true) == none;
            }
        }
        return false;
        //return ReturnValue;        
    }

    event Touch(@NULL Recipient, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL itm, pwn;

        // DebugMode: 0
        assert(mMPPickupFactory != none);
        pwn = TurokPawnPlayer(Recipient);
        // End:0x17C
        if((pwn != none) && IsAllowedTouch(pwn))
        {
            // End:0x149
            if(mRecaptureReturn)
            {
                mMPPickupFactory.EnablePickup();
                mMPPickupFactory = none;
                itm = pwn.InvManager.FindInventoryType(Class'TurokMPObjectiveItemPowerCoreNative', true);
                // End:0x134
                if((itm != none) && int(mOwningTeamIndex) == 255)
                {
                    TurokInventoryManager(pwn.InvManager).DropFromInventory(itm);
                    mMPPickupFactory = TurokMPObjectiveItem(itm).ReleaseFactory();
                    // DebugMode: 0
                    assert(mMPPickupFactory != none);
                    itm.Destroy();
                    ObjectiveGained(pwn);
                    mCaptorTeamIndex = int(pwn.GetTeamNum());
                    // DebugMode: 0
                    assert(mCaptorTeamIndex != 255);
                }
                TriggerEventClass(Class'TurokSeqEvent_PowerCoreReturned', self);                
            }
            else
            {
                GiveTo(pwn);
            }
            ObjectiveStolen(pwn);
            // End:0x17C
            if(mMPPickupFactory == none)
            {
                DisablePickup();
            }
        }
        //return;        
    }
    stop;    
}

state Sleeping
{
    event bool IsAllowedTouch(@NULL pwn)
    {
        // End:0x69
        if(super(TurokMPPickupFactory).IsAllowedTouch(pwn))
        {
            // End:0x69
            if(pwn.InvManager.FindInventoryType(InventoryType) != none)
            {
                return (int(mOwningTeamIndex) == 255) || WorldInfo.GRI.OnSameTeam(self, pwn);
            }
        }
        return false;
        //return ReturnValue;        
    }

    event Touch(@NULL tpp, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL itm, pwn;

        pwn = TurokPawnPlayer(tpp);
        // End:0x10B
        if((pwn != none) && IsAllowedTouch(pwn))
        {
            itm = TurokMPObjectiveItem(pwn.InvManager.FindInventoryType(InventoryType));
            // End:0x10B
            if(itm != none)
            {
                // DebugMode: 0
                assert(mMPPickupFactory == none);
                mMPPickupFactory = itm.ReleaseFactory();
                // DebugMode: 0
                assert(mMPPickupFactory != none);
                mCaptorTeamIndex = int(pwn.GetTeamNum());
                // DebugMode: 0
                assert(mCaptorTeamIndex != 255);
                TurokInventoryManager(pwn.InvManager).DropFromInventory(itm);
                ObjectiveGained(pwn);
                itm.Destroy();
                EnablePickup();
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}

state Complete
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mOwningTeamIndex=255
    mCanBeRecaptured=true
    // Reference: StaticMeshComponent'Default__TurokMPObjectiveLocationPickup.BaseMesh'
    begin object name=BaseMesh class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Static=true)
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        TickGroup=3
    end object
    mBaseMesh=BaseMesh
    // Reference: StaticMeshComponent'Default__TurokMPObjectiveLocationPickup.CompletedMesh'
    begin object name=CompletedMesh class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        bCastDynamicShadow=false
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
    end object
    mCompletedMesh=CompletedMesh
    mCaptorTeamIndex=255
    // Reference: TurokMPGameModeRestriction'Default__TurokMPObjectiveLocationPickup.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    mPickupEnabled=false
    bPickupHidden=true
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPObjectiveLocationPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokMPObjectiveLocationPickup.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPObjectiveLocationPickup.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPObjectiveLocationPickup.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bBlockActors=true
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPObjectiveLocationPickup.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPObjectiveLocationPickup.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=MyLightEnvironment
    Components[5]=BaseMesh
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}