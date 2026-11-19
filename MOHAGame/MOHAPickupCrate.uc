class MOHAPickupCrate extends PickupFactory
    hidecategories(Navigation,Lighting,LightColor,Force);

enum EPickupCrateType
{
    PICKUP_CRATE_AMMO,              // 0
    PICKUP_CRATE_GRENADE,           // 1
    PICKUP_CRATE_HEALTH,            // 2
    PICKUP_CRATE_MAX                // 3
};

var MOHAPickupCrate.EPickupCrateType PickupCrateType;
var MOHAPlayerPawn PlayerPawn;
var MOHAPickupCrateCSA CSATrigger;
var() float CSATriggerRadius;
var() export editinline MOHASkeletalMeshComponent CrateMesh;
var() export editinline StaticMeshComponent PickupStaticMesh;
var protected MaterialInstanceConstant CrateMaterialInstance;
var float fMaxGlowAmount;
var float fAnimPlayRate;
var() float SleepTime;
var() bool bInfinite;
var const localized string AmmoDisplayName;
var const localized string GrenadeDisplayName;
var const localized string HealthDisplayName;
var const localized string AmmoPickupName;
var const localized string GrenadePickupName;

simulated event SetInitialState()
{
    GotoState('Pickup');
    //return;    
}

simulated function PostBeginPlay()
{
    local float Height, Radius;

    super.PostBeginPlay();
    // End:0x7C
    if(CSATrigger == none)
    {
        CSATrigger = __NFUN_278__(Class'MOHAPickupCrateCSA',,, Location);
        // End:0x7C
        if(CSATrigger != none)
        {
            Height = CSATriggerRadius;
            Radius = CSATriggerRadius;
            CSATrigger.CylinderComponent.SetCylinderSize(Radius, Height);
            CSATrigger.InventoryPickup = self;
        }
    }
    SetupMaterialInstance();
    //return;    
}

function SetupMaterialInstance()
{
    local MaterialInstance CrateMaterial;

    CrateMaterial = CrateMesh.GetMaterial(0);
    // End:0x66
    if(CrateMaterial != none)
    {
        CrateMaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
        CrateMesh.SetMaterial(0, CrateMaterialInstance);
        CrateMaterialInstance.SetParent(CrateMaterial);
    }
    //return;    
}

function SetGlowAmount(float A)
{
    // End:0x28
    if(CrateMaterialInstance != none)
    {
        CrateMaterialInstance.SetScalarParameterValue('GlowAmount', A);
    }
    //return;    
}

function PickedUpBy(Pawn P)
{
    PlayerPawn = MOHAPlayerPawn(P);
    TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', P, 1);
    //return;    
}

function GiveTo(Pawn P)
{
    // End:0x0D
    if(P == none)
    {
        return;
    }
    // End:0x2F
    if(int(PickupCrateType) == int(0))
    {
        GiveAmmo(P);        
    }
    else
    {
        // End:0x51
        if(int(PickupCrateType) == int(1))
        {
            GiveGrenades(P);            
        }
        else
        {
            // End:0x70
            if(int(PickupCrateType) == int(2))
            {
                Heal(P);
            }
        }
    }
    PickedUpBy(P);
    PlayAnimation('Open', fAnimPlayRate);
    CrateMesh.AttachComponentToSocket(PickupStaticMesh, 'PickupMeshSocket');
    StartSleeping();
    //return;    
}

simulated function bool Heal(Pawn P)
{
    local int iHealAmount;

    iHealAmount = HealAmount(P);
    // End:0x22
    if(0 == iHealAmount)
    {
        return false;
    }
    P.SetHealth(P.Health + iHealAmount);
    return true;
    //return ReturnValue;    
}

simulated function GiveAmmo(Pawn P)
{
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(P.InvManager);
    // End:0x37
    if(InvManager != none)
    {
        InvManager.GiveFullGunAmmo();
    }
    //return;    
}

simulated function GiveGrenades(Pawn P)
{
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(P.InvManager);
    // End:0x37
    if(InvManager != none)
    {
        InvManager.GiveFullGrenadeAmmo();
    }
    //return;    
}

simulated function int HealAmount(Pawn Recipient)
{
    return Recipient.default.Health - Recipient.Health;
    //return ReturnValue;    
}

function string GetPickupName()
{
    // End:0x19
    if(int(PickupCrateType) == int(0))
    {
        return AmmoDisplayName;        
    }
    else
    {
        // End:0x32
        if(int(PickupCrateType) == int(1))
        {
            return GrenadeDisplayName;            
        }
        else
        {
            // End:0x48
            if(int(PickupCrateType) == int(2))
            {
                return HealthDisplayName;
            }
        }
    }
    return "";
    //return ReturnValue;    
}

simulated function bool PawnCanUsePickup(Pawn P)
{
    // End:0x54
    if(int(PickupCrateType) == int(0))
    {
        // End:0x4F
        if(!CanUseAmmo(P))
        {
            MOHAPlayerController(P.Controller).NotifyPickupFailure(0, AmmoPickupName);            
        }
        else
        {
            return true;
        }        
    }
    else
    {
        // End:0xBC
        if((int(PickupCrateType) == int(1)) && CanUseGrenades(P))
        {
            // End:0xB7
            if(!CanUseGrenades(P))
            {
                MOHAPlayerController(P.Controller).NotifyPickupFailure(0, GrenadePickupName);                
            }
            else
            {
                return true;
            }            
        }
        else
        {
            // End:0x109
            if(int(PickupCrateType) == int(2))
            {
                // End:0x107
                if(!CanUseHealth(P))
                {
                    MOHAPlayerController(P.Controller).NotifyPickupFailure(2);                    
                }
                else
                {
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanUseAmmo(Pawn P)
{
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(P.InvManager);
    // End:0x3E
    if((InvManager != none) && InvManager.NeedsGunAmmo())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanUseGrenades(Pawn P)
{
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(P.InvManager);
    // End:0x3E
    if((InvManager != none) && InvManager.NeedsGrenadeAmmo())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanUseHealth(Pawn P)
{
    return (HealAmount(P)) > 0;
    //return ReturnValue;    
}

simulated function PlayAnimation(name AnimationName, optional float Rate = 1.0000000, optional bool loop = false)
{
    // End:0x42
    if(CrateMesh != none)
    {
        CrateMesh.PlayAnimAtRate(AnimationName, Rate, 0.0000000, loop, false);
    }
    //return;    
}

function bool ValidSwap(Pawn Other)
{
    //return ReturnValue;    
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
    // End:0xD0
    if(CSATrigger != none)
    {
        CSATrigger.OnToggle(Action);
    }
    //return;    
}

function CreateAnimationDone()
{
    CrateMesh.DetachComponent(PickupStaticMesh);
    // End:0xC9
    if(PlayerPawn != none)
    {
        // End:0x5A
        if(int(PickupCrateType) == int(0))
        {
            MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(0, AmmoPickupName);            
        }
        else
        {
            // End:0x95
            if(int(PickupCrateType) == int(1))
            {
                MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(0, GrenadePickupName);                
            }
            else
            {
                // End:0xC9
                if(int(PickupCrateType) == int(2))
                {
                    MOHAPlayerController(PlayerPawn.Controller).NotifyPickup(2);
                }
            }
        }
    }
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

auto state Pickup
{
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

    simulated event BeginState(name PreviousStateName)
    {
        // End:0x1C
        if(CSATrigger != none)
        {
            CSATrigger.bEnabled = true;
        }
        SetGlowAmount(fMaxGlowAmount);
        PlayAnimation('Close', fAnimPlayRate);
        //return;        
    }
    stop;    
}

state Sleeping
{
    ignores EndState;

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        CreateAnimationDone();
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        SetGlowAmount(0.0000000);
        // End:0x3B
        if(PreviousStateName == 'Disabled')
        {
            PlayAnimation('Close', fAnimPlayRate);
        }
        //return;        
    }
Begin:

    // End:0x22
    if(bInfinite)
    {
        Sleep(SleepTime);
        GotoState('Pickup');        
    }
    else
    {
        GotoState('Disabled');
    }
    stop;                
}

state Disabled
{
    ignores Reset, StartSleeping;

    function bool ReadyToPickup(float MaxWait)
    {
        return false;
        //return ReturnValue;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        CreateAnimationDone();
        //return;        
    }

    simulated event BeginState(name PreviousStateName)
    {
        SetGlowAmount(0.0000000);
        // End:0x3C
        if(CSATrigger != none)
        {
            CSATrigger.bEnabled = false;
            CSATrigger.bDirty = true;
        }
        // End:0x68
        if(PreviousStateName == 'Pickup')
        {
            PlayAnimation('Open', fAnimPlayRate);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    CSATriggerRadius=200.0000000
    fMaxGlowAmount=10.0000000
    fAnimPlayRate=3.0000000
    SleepTime=10.0000000
    bInfinite=true
    AmmoDisplayName="Weapon Ammo"
    GrenadeDisplayName="Explosive Ammo"
    HealthDisplayName="Health"
    AmmoPickupName="Weapon"
    GrenadePickupName="Explosive"
    bNotBased=true
    // Reference: CylinderComponent'Default__MOHAPickupCrate.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=1.0000000
        BlockActors=true
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPickupCrate.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAPickupCrate.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAPickupCrate.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAPickupCrate.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    bIgnoreEncroachers=false
    bCollideWhenPlacing=true
    bCollideWorld=true
    bBlockActors=true
    bPathColliding=true
    CollisionComponent=CollisionCylinder
    CollisionType=2
}