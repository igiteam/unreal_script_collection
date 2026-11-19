class MOHAAmmoDroppedPickup extends MOHADroppedPickup
    hidecategories(Navigation);

const MAX_AMMO_DROPPED_PICKUPS = 20;
const MAX_AMMO_DROPPED_PICKUPS_MP = 10;

var() int AmmoAmount;
var class<EALAAmmoInventoryClass> AmmoClass;

function PostBeginPlay()
{
    local int local_MAX_AMMO_DROPPED_PICKUPS;

    super.PostBeginPlay();
    WorldInfo.AmmoDroppedPickups.AddItem(self);
    local_MAX_AMMO_DROPPED_PICKUPS = 20;
    // End:0x3F
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        local_MAX_AMMO_DROPPED_PICKUPS = 10;
    }
    // End:0x71
    if(WorldInfo.AmmoDroppedPickups.Length > local_MAX_AMMO_DROPPED_PICKUPS)
    {
        DeleteLeastRelevantPickup(WorldInfo.AmmoDroppedPickups, self);
    }
    //return;    
}

event Destroyed()
{
    WorldInfo.AmmoDroppedPickups.RemoveItem(self);
    super(DroppedPickup).Destroyed();
    //return;    
}

function PickedUpBy(Pawn P)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(P);
    // End:0x43
    if(PlayerPawn != none)
    {
        MOHAPlayerController(PlayerPawn.Controller).NotifyPickupAmmoClass(0, AmmoClass);
    }
    super(DroppedPickup).PickedUpBy(P);
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x12
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        // End:0x24
        if(MOHAPlayerPawn(Other) == none)
        {
            return false;
        }
        // End:0x64
        if(MOHAInventoryManager(Other.InvManager) != none)
        {
            return MOHAInventoryManager(Other.InvManager).NeedsAmmo(AmmoClass);
        }
        return false;
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0x138
        if(P != none)
        {
            // End:0xDA
            if(ValidTouch(P))
            {
                // End:0xD7
                if(MOHAInventoryManager(P.InvManager) != none)
                {
                    Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "Pickup", "Ammo", 0, float(AmmoAmount), string(AmmoClass.Name), P.Location);
                    MOHAInventoryManager(P.InvManager).AddReserveAmmo(AmmoClass, AmmoAmount);
                    PickedUpBy(P);
                }                
            }
            else
            {
                // End:0x138
                if((P.Controller != none) && P.Controller.IsA('PlayerController'))
                {
                    MOHAPlayerController(P.Controller).NotifyPickupFailureAmmoClass(0, AmmoClass);
                }
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAmmoDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAAmmoDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAAmmoDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}