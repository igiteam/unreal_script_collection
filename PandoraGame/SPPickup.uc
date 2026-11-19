class SPPickup extends PickupFactory
    abstract
    native;

var class<SPWeapon> SPWeaponType;
var export editinline LightEnvironmentComponent LightEnvironment;
/** overrides the item's default respawn time. Item will respawn X seconds after being picked up */
var(Pickup) float RespawnTimeOverride;
var SoundCue PickupSound;
var bool m_bAquiredPickup;
var repnotify Vector RepLocation;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetInitial || bNetDirty
        RepLocation;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x1F
    if(VarName == 'RepLocation')
    {
        SetLocation(RepLocation);        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function SetPickupHidden()
{
    super.SetPickupHidden();
    SetHidden(true);
    //return;    
}

simulated function SetPickupVisible()
{
    super.SetPickupVisible();
    SetHidden(false);
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    RepLocation = Location;
    super(Actor).Landed(HitNormal, FloorActor);
    //return;    
}

function float GetRespawnTime()
{
    // End:0x15
    if(RespawnTimeOverride > 0.0000000)
    {
        return RespawnTimeOverride;
    }
    return super.GetRespawnTime();
    //return ReturnValue;    
}

static function bool QueryToPickUp(Actor Other, class<SPWeapon> mySPWeaponType)
{
    local int numLargeWeapons, maxLargeWeapons, numMeleeWeapons, maxMeleeWeapons;
    local SPPawn SPPawn;
    local SPInventoryManager spInvManager;
    local bool bSameType;

    bSameType = false;
    // End:0x15
    if(Other == none)
    {
        return false;
    }
    SPPawn = SPPawn(Other);
    // End:0xEE
    if((SPPawn != none) && SPPawn.InvManager != none)
    {
        spInvManager = SPInventoryManager(SPPawn.InvManager);
        // End:0xEE
        if(spInvManager != none)
        {
            maxLargeWeapons = spInvManager.maxLargeWeapons;
            numLargeWeapons = spInvManager.CountLargeWeapons();
            maxMeleeWeapons = spInvManager.maxMeleeWeapons;
            numMeleeWeapons = spInvManager.CountMeleeWeapons();
            bSameType = spInvManager.FindInventoryType(mySPWeaponType) != none;
        }
    }
    // End:0x120
    if(mySPWeaponType.default.IsMeleeWeapon)
    {
        // End:0x11D
        if(bSameType || numMeleeWeapons < maxMeleeWeapons)
        {
            return true;
        }        
    }
    else
    {
        // End:0x13C
        if(bSameType || numLargeWeapons < maxLargeWeapons)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

auto state Pickup
{
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        // End:0x46
        if((SPWeaponType == none) || QueryToPickUp(Other, SPWeaponType))
        {
            m_bAquiredPickup = false;
            super.Touch(Other, OtherComp, HitLocation, HitNormal);
        }
        //return;        
    }

    simulated function bool ValidTouch(Pawn Other)
    {
        // End:0x52
        if(((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none)
        {
            return false;
        }
        // End:0x9C
        if((Other != none) && Other.InvManager != none)
        {
            return Other.InvManager.HandlePickupQuery(InventoryType, self);            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
    stop;    
}

state PreDestroy
{
    simulated event BeginState(name PreviousStateName)
    {
        SetHidden(true);
        SetCollision(false, false);
        Destroy();
        //return;        
    }
    stop;    
}
