class MOHAWeaponDroppedPickup extends MOHADroppedPickup
    hidecategories(Navigation);

const MAX_WEAPON_DROPPED_PICKUPS = 20;
const MAX_WEAPON_DROPPED_PICKUPS_MP = 10;

var MOHAWeaponCSA WeaponCSA;
var EALAWeapon PickedupWeapon;
var bool bGiveAmmo;
var MaterialInstanceConstant WeaponSkin;

function PostBeginPlay()
{
    local int local_MAX_WEAPON_DROPPED_PICKUPS;

    super.PostBeginPlay();
    WorldInfo.WeaponDroppedPickups.AddItem(self);
    local_MAX_WEAPON_DROPPED_PICKUPS = 20;
    // End:0x3F
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        local_MAX_WEAPON_DROPPED_PICKUPS = 10;
    }
    // End:0x71
    if(WorldInfo.WeaponDroppedPickups.Length > local_MAX_WEAPON_DROPPED_PICKUPS)
    {
        DeleteLeastRelevantPickup(WorldInfo.WeaponDroppedPickups, self);
    }
    //return;    
}

event Destroyed()
{
    WorldInfo.WeaponDroppedPickups.RemoveItem(self);
    // End:0x27
    if(WeaponCSA != none)
    {
        WeaponCSA.Destroy();
    }
    super(DroppedPickup).Destroyed();
    //return;    
}

simulated event SetPickupMesh(PrimitiveComponent PickupMesh)
{
    super.SetPickupMesh(PickupMesh);
    // End:0x92
    if(MeshComponent(CollisionComponent) != none)
    {
        WeaponSkin = new (Outer) Class'Engine.MaterialInstanceConstant';
        WeaponSkin.SetParent(MeshComponent(CollisionComponent).GetMaterial(0));
        MeshComponent(CollisionComponent).SetMaterial(0, WeaponSkin);
        WeaponSkin.SetScalarParameterValue('GlowToggle', 1.0000000);
    }
    //return;    
}

function SpawnCSA()
{
    local EALAWeapon wep;

    // End:0xAC
    if(WeaponCSA == none)
    {
        WeaponCSA = __NFUN_278__(Class'MOHAWeaponCSA',,, Location);
        // End:0xAC
        if(WeaponCSA != none)
        {
            WeaponCSA.DroppedWeaponPickup = self;
            // End:0x74
            if(int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                WeaponCSA.DroppedWeaponPickupClass = Inventory.Class;
            }
            wep = EALAWeapon(Inventory);
            // End:0xAC
            if(wep != none)
            {
                WeaponCSA.CSAWeaponType = wep.WeaponType;
            }
        }
    }
    //return;    
}

function Settled()
{
    super.Settled();
    SpawnCSA();
    //return;    
}

event StreamOutCleanup()
{
    // End:0x17
    if(WeaponCSA != none)
    {
        WeaponCSA.Destroy();
    }
    //return;    
}

function GiveTo(Pawn P)
{
    // End:0x65
    if(Inventory != none)
    {
        Inventory.AnnouncePickup(P);
        Inventory.GotoState('Inactive');
        Inventory.super(Inventory).GiveTo(P);
        PickedupWeapon = EALAWeapon(Inventory);
        Inventory = none;
    }
    PickedUpBy(P);
    //return;    
}

function PickedUpBy(Pawn P)
{
    local MOHAPlayerPawn PlayerPawn;
    local Rotator rRotation;

    // End:0x17
    if(WeaponCSA != none)
    {
        WeaponCSA.Destroy();
    }
    PlayerPawn = MOHAPlayerPawn(P);
    // End:0xD1
    if(PlayerPawn != none)
    {
        PickedupWeapon.SetHidden(false);
        // End:0xD1
        if(!bGiveAmmo)
        {
            rRotation = rRotation - rot(90, 90, 0);
            MOHAInventoryManager(PlayerPawn.InvManager).SwapWeapon(PickedupWeapon, Location + vect(0.0000000, 0.0000000, 50.0000000), rRotation, bDroppedByPlayer);
            MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(1);
        }
    }
    Destroy();
    //return;    
}

simulated function bool ValidTouch(Pawn Other)
{
    //return ReturnValue;    
}

auto state Pickup
{
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local MOHAPlayerPawn P;

        P = MOHAPlayerPawn(Other);
        // End:0xD5
        if(((P != none) && MOHAInventoryManager(P.InvManager) != none) && bGiveAmmo)
        {
            PickedupWeapon = EALAWeapon(Inventory);
            MOHAInventoryManager(P.InvManager).AddReserveAmmo(PickedupWeapon.AmmoClass[0], PickedupWeapon.MaxAmmoCount[0]);
            MOHAPlayerController(P.Controller).NotifyPickupAmmoClass(0, PickedupWeapon.AmmoClass[0]);
            PickedUpBy(P);
        }
        //return;        
    }

    function bool ValidTouch(Pawn Other)
    {
        // End:0x2F
        if((MOHAPlayerPawn(Other) != none) && MOHAPlayerPawn(Other).IsWeaponDisabled())
        {
            return false;
        }
        return super.ValidTouch(Other);
        //return ReturnValue;        
    }
    stop;    
}

state FadeOut
{
    function Tick(float DeltaTime)
    {
        SetDrawScale(FMax(0.0100000, DrawScale - (default.DrawScale * DeltaTime)));
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local MOHAPlayerController LocalPlayer;

        super.BeginState(PreviousStateName);
        // End:0x55
        if(WeaponCSA != none)
        {
            // End:0x48
            foreach LocalPlayerControllers(LocalPlayer)
            {
                // End:0x47
                if(none != LocalPlayer)
                {
                    LocalPlayer.RemoveCSA(WeaponCSA);
                }                
            }            
            WeaponCSA.Destroy();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAWeaponDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAWeaponDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAWeaponDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=10.0000000
        CollisionRadius=50.0000000
        BlockZeroExtent=false
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}