class MOHAHealthDroppedPickup extends MOHADroppedPickup
    hidecategories(Navigation);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

var() float fHealthDroppedPickupDecay;

function PostBeginPlay()
{
    local int local_MAX_HEALTH_DROPPED_PICKUPS;

    super.PostBeginPlay();
    WorldInfo.HealthDroppedPickups.AddItem(self);
    WorldInfo.LastHealthDroppedTime = WorldInfo.TimeSeconds;
    local_MAX_HEALTH_DROPPED_PICKUPS = 1;
    // End:0x5B
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        local_MAX_HEALTH_DROPPED_PICKUPS = 10;
    }
    // End:0x8D
    if(WorldInfo.HealthDroppedPickups.Length > local_MAX_HEALTH_DROPPED_PICKUPS)
    {
        DeleteLeastRelevantPickup(WorldInfo.HealthDroppedPickups, self);
    }
    //return;    
}

event Destroyed()
{
    WorldInfo.HealthDroppedPickups.RemoveItem(self);
    super(DroppedPickup).Destroyed();
    //return;    
}

function int HealAmount(Pawn Recipient)
{
    local int iHealAmount, iSegmentSize;

    // End:0x92
    if(MOHAPlayerPawn(Recipient) != none)
    {
        iSegmentSize = MOHAPlayerPawn(Recipient).HealthManager.SegmentSize;
        // End:0x61
        if((float(Recipient.Health) % float(iSegmentSize)) == float(0))
        {
            iHealAmount = iSegmentSize;            
        }
        else
        {
            iHealAmount = int(float(2 * iSegmentSize) - (float(Recipient.Health) % float(iSegmentSize)));
        }        
    }
    else
    {
        iHealAmount = 0;
    }
    return Clamp(Recipient.default.Health - Recipient.Health, 0, iHealAmount);
    //return ReturnValue;    
}

function PickedUpBy(Pawn P)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(P);
    // End:0x3F
    if(PlayerPawn != none)
    {
        MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(2);
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
        return (HealAmount(Other)) > 0;
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0x73
        if((P != none) && ValidTouch(P))
        {
            P.SetHealth(P.Health + (HealAmount(P)));
            PickedUpBy(P);            
        }
        else
        {
            // End:0xDA
            if(((P != none) && P.Controller != none) && P.Controller.IsA('PlayerController'))
            {
                MOHAPlayerController(P.Controller).NotifyPickupFailure(2);
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    fHealthDroppedPickupDecay=30.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAHealthDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAHealthDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAHealthDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}