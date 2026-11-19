class MOHAWeaponPickupFactory extends PickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

var() repnotify class<EALAWeapon> WeaponPickupClass;
var() bool bStartDisabled;
var MOHAWeaponCSA CSATrigger;
var EALAWeapon SpawnedWeapon;
var export editinline DynamicLightEnvironmentComponent LightEnvComponent;
var MaterialInstanceConstant WeaponSkin;

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2A
    if(VarName == 'WeaponPickupClass')
    {
        PickupClassChanged();
        SetPickupMesh();        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    PickupClassChanged();
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x44
    if(CSATrigger == none)
    {
        CSATrigger = __NFUN_278__(Class'MOHAWeaponCSA',,, Location);
        // End:0x44
        if(CSATrigger != none)
        {
            CSATrigger.WeaponPickup = self;
        }
    }
    //return;    
}

event Destroyed()
{
    // End:0x17
    if(CSATrigger != none)
    {
        CSATrigger.Destroy();
    }
    super(Actor).Destroyed();
    //return;    
}

event StreamOutCleanup()
{
    // End:0x17
    if(CSATrigger != none)
    {
        CSATrigger.Destroy();
    }
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    SpawnedWeapon = __NFUN_278__(WeaponPickupClass);
    // End:0x4B
    if(SpawnedWeapon != none)
    {
        SpawnedWeapon.GiveTo(Recipient);
        SpawnedWeapon.AnnouncePickup(Recipient);
    }
    //return;    
}

function PickedUpBy(Pawn P)
{
    local MOHAPlayerPawn PlayerPawn;

    // End:0x64
    if((P.Controller != none) && P.Controller.MoveTarget == self)
    {
        P.SetAnchor(self);
        P.Controller.MoveTimer = -1.0000000;
    }
    // End:0x80
    if(CSATrigger != none)
    {
        CSATrigger.bEnabled = false;
    }
    PlayerPawn = MOHAPlayerPawn(P);
    // End:0xFF
    if(PlayerPawn != none)
    {
        MOHAInventoryManager(PlayerPawn.InvManager).SwapWeapon(SpawnedWeapon, Location + vect(0.0000000, 0.0000000, 50.0000000), Rotation);
        MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(1);
    }
    TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', P, 1);
    GotoState('Disabled');
    //return;    
}

function bool ValidSwap(Pawn Other)
{
    //return ReturnValue;    
}

simulated function SetPickupMesh()
{
    super.SetPickupMesh();
    PickupMesh.SetLightEnvironment(self.LightEnvComponent);
    // End:0xA6
    if(MeshComponent(PickupMesh) != none)
    {
        WeaponSkin = new (Outer) Class'Engine.MaterialInstanceConstant';
        WeaponSkin.SetParent(MeshComponent(PickupMesh).GetMaterial(0));
        MeshComponent(PickupMesh).SetMaterial(0, WeaponSkin);
        WeaponSkin.SetScalarParameterValue('GlowToggle', 1.0000000);
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2F
    if(Action.InputLinks[0].bHasImpulse)
    {
        GotoState('Pickup');        
    }
    else
    {
        // End:0x5E
        if(Action.InputLinks[1].bHasImpulse)
        {
            GotoState('Disabled');            
        }
        else
        {
            // End:0xAD
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x9F
                if(GetStateName() == 'Disabled')
                {
                    GotoState('Pickup');                    
                }
                else
                {
                    GotoState('Disabled');
                }
            }
        }
    }
    //return;    
}

simulated function PickupClassChanged()
{
    // End:0x2B
    if((WeaponPickupClass != none) && ClassIsChildOf(WeaponPickupClass, Class'Engine.Inventory'))
    {
        InventoryType = WeaponPickupClass;        
    }
    else
    {
        InventoryType = none;
    }
    //return;    
}

auto state Pickup
{
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local MOHAPlayerPawn P;

        P = MOHAPlayerPawn(Other);
        // End:0xE3
        if((MOHAInventoryManager(P.InvManager) != none) && MOHAInventoryManager(P.InvManager).HasWeapon(WeaponPickupClass))
        {
            MOHAInventoryManager(P.InvManager).AddReserveAmmo(WeaponPickupClass.default.AmmoClass[0], WeaponPickupClass.default.MaxAmmoCount[0]);
            MOHAPlayerController(P.Controller).NotifyPickupAmmoClass(0, WeaponPickupClass.default.AmmoClass[0]);
            // End:0xE0
            if(CSATrigger != none)
            {
                CSATrigger.Destroy();
            }
            Destroy();
        }
        //return;        
    }

    event float DetourWeight(Pawn Other, float PathWeight)
    {
        return InventoryType.static.DetourWeight(Other, PathWeight);
        //return ReturnValue;        
    }

    function bool ReadyToPickup(float MaxWait)
    {
        return true;
        //return ReturnValue;        
    }

    function bool ValidSwap(Pawn Other)
    {
        // End:0x4F
        if(((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none)
        {
            return false;
        }
        // End:0x8D
        if((PickupMesh == none) || !FastTrace(Other.Location, PickupMesh.Bounds.Origin))
        {
            return false;
        }
        // End:0xBC
        if((MOHAPlayerPawn(Other) != none) && MOHAPlayerPawn(Other).IsWeaponDisabled())
        {
            return false;
        }
        // End:0xE8
        if(WorldInfo.Game.PickupQuery(Other, InventoryType, self))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    event BeginState(name PreviousStateName)
    {
        // End:0x21
        if(bStartDisabled)
        {
            bStartDisabled = false;
            GotoState('Disabled');
            return;
        }
        SetHidden(false);
        CSATrigger.bEnabled = true;
        TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', none, 0);
        //return;        
    }
    stop;    
}

state Disabled
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        CSATrigger.bEnabled = false;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAWeaponPickupFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvComponent=MyLightEnvironment
    bNotBased=true
    // Reference: CylinderComponent'Default__MOHAWeaponPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=10.0000000
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAWeaponPickupFactory.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAWeaponPickupFactory.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAWeaponPickupFactory.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAWeaponPickupFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=MyLightEnvironment
    bNoDelete=false
    bBlockActors=true
    CollisionComponent=CollisionCylinder
    CollisionType=7
}