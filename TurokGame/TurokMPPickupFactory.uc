class TurokMPPickupFactory extends PickupFactory
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var(Multiplayer) protected noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) protected bool mEnabled;
var protected bool mEnabledInitial;
var protected bool mPickupEnabled;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mEnabledInitial = mEnabled;
    //return;    
}

function Reset()
{
    mEnabled = mEnabledInitial;
    mPickupEnabled = default.mPickupEnabled;
    SetInitialState();
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x6A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x42
        if((InventoryType == none) || mEnabled == false)
        {
            GotoState('Disabled');            
        }
        else
        {
            // End:0x5C
            if(mPickupEnabled)
            {
                GotoState('Pickup');                
            }
            else
            {
                GotoState('Sleeping');
            }
        }
    }
    //return;    
}

event PostSaveGameRestore()
{
    SetInitialState();
    //return;    
}

simulated function OnToggle(@NULL Action)
{
    local bool bNewEnabled;

    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        bNewEnabled = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            bNewEnabled = false;            
        }
        else
        {
            // End:0x80
            if(Action.InputLinks[2].bHasImpulse)
            {
                bNewEnabled = !mEnabled;
            }
        }
    }
    // End:0xA8
    if(bNewEnabled != mEnabled)
    {
        mEnabled = bNewEnabled;
        SetInitialState();
    }
    //return;    
}

function EnablePickup()
{
    mPickupEnabled = true;
    // End:0x28
    if(!IsInState('Pickup'))
    {
        GotoState('Pickup');
    }
    //return;    
}

function DisablePickup()
{
    mPickupEnabled = false;
    // End:0x28
    if(!IsInState('Sleeping'))
    {
        GotoState('Sleeping');
    }
    //return;    
}

function bool IsPickupEnabled()
{
    return mPickupEnabled;
    //return ReturnValue;    
}

event bool IsAllowedTouch(@NULL Other)
{
    local @NULL TPC;

    // End:0x6A
    if(((((Other == none) || !Other.bCanPickupInventory) || Other.Controller == none) || Other.DrivenVehicle != none) || Other.IsInState('CannedAnimation'))
    {
        return false;
    }
    // End:0x85
    if(TurokInventoryManager(Other.InvManager) == none)
    {
        return false;
    }
    TPC = TurokPlayerController(Other.Controller);
    // End:0xC7
    if((TPC == none) || TPC.GetStateName() != 'PlayerWalking')
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function ClearItemDropPrompts()
{
    local @NULL Player, invMan;

    // End:0x49
    foreach TouchingActors(Class'TurokPawnPlayer', Player)
    {
        invMan = TurokInventoryManager(Player.InvManager);
        // End:0x48
        if(invMan != none)
        {
            invMan.EndPromptToDropItem(self);
        }        
    }    
    //return;    
}

event GiveInventory(@NULL Other)
{
    GiveTo(Other);
    //return;    
}

function SetRespawn()
{
    DisablePickup();
    //return;    
}

state Pickup
{
    event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
    {
        local @NULL Player, invMan;
        local bool pickupOK;

        Player = TurokPawnPlayer(Other);
        // End:0x116
        if(Player != none)
        {
            // End:0x116
            if(IsAllowedTouch(Player))
            {
                invMan = TurokInventoryManager(Player.InvManager);
                // End:0x116
                if(invMan != none)
                {
                    invMan.ResetPickedUpAmmoOnly();
                    pickupOK = WorldInfo.Game.PickupQuery(Player, InventoryType, self);
                    // End:0xBE
                    if(pickupOK)
                    {
                        invMan.EndPromptToDropItem(self);
                        GiveInventory(Player);
                    }
                    // End:0x116
                    if((pickupOK == false) || invMan.PickedUpAmmoOnly())
                    {
                        // End:0x116
                        if(invMan.ShouldPromptToDropItem(InventoryType))
                        {
                            invMan.StartPromptToDropItem(self, InventoryType);
                        }
                    }
                }
            }
        }
        //return;        
    }

    event UnTouch(@NULL Other)
    {
        local @NULL Player, invMan;

        Player = TurokPawnPlayer(Other);
        // End:0x53
        if(Player != none)
        {
            invMan = TurokInventoryManager(Player.InvManager);
            // End:0x53
            if(invMan != none)
            {
                invMan.EndPromptToDropItem(self);
            }
        }
        //return;        
    }

    function CheckTouching()
    {
        local @NULL Player;

        // End:0x3C
        foreach TouchingActors(Class'TurokPawnPlayer', Player)
        {
            Touch(Player, Location, Normal(Location - Player.Location));            
        }        
        //return;        
    }

    function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        CheckTouching();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearItemDropPrompts();
        super(Object).EndState(NextStateName);
        //return;        
    }
Begin:

    stop;                
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
Begin:

    stop;                
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPPickupFactory.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    mEnabled=true
    mEnabledInitial=true
    mPickupEnabled=true
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPPickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment
        InvisibleUpdateTime=1000000.0000000
    end object
    LightEnvironment=MyLightEnvironment
    bNoAutoConnect=true
    bDestinationOnly=true
    bSourceOnly=true
    // Reference: CylinderComponent'Default__TurokMPPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        TickGroup=3
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPPickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPPickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bOnlyDirtyReplication=true
    bMovable=false
    bNoEncroachCheck=true
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPPickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPPickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    CollisionComponent=CollisionCylinder
}