class SPDroppedPickup extends DroppedPickup;

var class<SPWeapon> SPWeaponType;
var SoundCue PickupSound;
var int AmmoCount;
var int AmmoCountInMagazine;
var bool bDoNotRemoveIfEmpty;
var SPDroppedPickupTrigger touchTrigger;

function AddToNavigation()
{
    //return;    
}

function RemoveFromNavigation()
{
    //return;    
}

simulated function bool ValidTouchMPFriendly(Pawn Other)
{
    // End:0x52
    if(((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none)
    {
        return false;
    }
    // End:0x8F
    if(((int(Physics) == int(2)) && Other == Instigator) && Velocity.Z > float(0))
    {
        return false;
    }
    // End:0xD9
    if((Other != none) && Other.InvManager != none)
    {
        return Other.InvManager.HandlePickupQuery(InventoryClass, self);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    // End:0x29
    if(int(Role) == int(ROLE_SimulatedProxy))
    {
        SetPickupMesh(InventoryClass.default.DroppedPickupMesh);
    }
    super(Actor).PostBeginPlay();
    // End:0x54
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        LifeSpan = 45.0000000;
    }
    touchTrigger = Spawn(Class'SPDroppedPickupTrigger', self,, Location, Rotation);
    //return;    
}

simulated function Destroyed()
{
    touchTrigger.Destroy();
    super.Destroyed();
    //return;    
}

function PickedUpBy(Pawn P)
{
    // End:0x2A
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        PlaySound(PickupSound);
    }
    super.PickedUpBy(P);
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    super.Landed(HitNormal, FloorActor);
    // End:0x45
    if(Inventory != none)
    {
        AmmoCount = Inventory.CurrentDroppedWeaponAmmoCount;
        AmmoCountInMagazine = Inventory.CurrentDroppedWeaponAmmoCountInMagazine;
    }
    GotoState('FadeOut');
    //return;    
}

function int TransferAmmoFromPickupToGun(Actor Other, int AmmoNeeded)
{
    local int AmmoFromPickup, AmmoCounter;

    // End:0x15C
    if(AmmoNeeded > 0)
    {
        // End:0x15C
        if((AmmoCountInMagazine >= 0) && AmmoCount >= 0)
        {
            // End:0x4C
            if(AmmoCount > AmmoNeeded)
            {
                AmmoCount -= AmmoNeeded;
                AmmoFromPickup = AmmoNeeded;                
            }
            else
            {
                AmmoCounter = AmmoCount;
                AmmoCount = 0;
                // End:0x95
                if(AmmoCountInMagazine > (AmmoNeeded - AmmoCounter))
                {
                    AmmoCountInMagazine -= (AmmoNeeded - AmmoCounter);
                    AmmoFromPickup = AmmoNeeded;                    
                }
                else
                {
                    AmmoFromPickup = AmmoCountInMagazine + AmmoCounter;
                    AmmoCountInMagazine = 0;
                }
            }
            // End:0xED
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0xED
                if(PickupSound != none)
                {
                    Other.PlaySound(PickupSound);
                }
            }
            SPInventoryManager(SPPawn(Other).InvManager).AddAmmoToWeapon(AmmoFromPickup, SPWeaponType, "NoType");
            SPInventoryManager(SPPawn(Other).InvManager).SetPickupAmmoMessage(SPWeaponType, AmmoFromPickup);
        }
    }
    return AmmoFromPickup;
    //return ReturnValue;    
}

function AmmoCopyForFirstPickup(Actor Other)
{
    // End:0x3F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x3F
        if(PickupSound != none)
        {
            Other.PlaySound(PickupSound);
        }
    }
    SPInventoryManager(SPPawn(Other).InvManager).AddAmmoToWeapon(AmmoCount, SPWeaponType, "NoType", true, AmmoCountInMagazine);
    SPInventoryManager(SPPawn(Other).InvManager).SetPickupAmmoMessage(SPWeaponType, AmmoCount + AmmoCountInMagazine);
    AmmoCountInMagazine = 0;
    AmmoCount = 0;
    //return;    
}

auto state Pickup
{
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local int AmmoNeeded;
        local bool bIsSpecialCaseInInventory, bIsInInventory;

        bIsSpecialCaseInInventory = false;
        // End:0xF1
        if((SPPawn(Other) != none) && SPInventoryManager(SPPawn(Other).InvManager) != none)
        {
            // End:0xB9
            if(SPInventoryManager(SPPawn(Other).InvManager).NeedsAmmo(SPWeaponType, AmmoNeeded))
            {
                TransferAmmoFromPickupToGun(Other, AmmoNeeded);
                // End:0xB6
                if(((AmmoCount <= 0) && AmmoCountInMagazine <= 0) && !bDoNotRemoveIfEmpty)
                {
                    GotoState('FadeOut');
                }                
            }
            else
            {
                // End:0xF1
                if((PlayerPawn(Other) != none) && !PlayerPawn(Other).HasReachedMaxLargeWeaponCount())
                {
                    bIsSpecialCaseInInventory = true;
                }
            }
        }
        // End:0x207
        if(Class'SPPickup'.static.QueryToPickUp(Other, SPWeaponType))
        {
            // End:0x15A
            if(!SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(SPWeaponType) && bIsSpecialCaseInInventory)
            {
                bIsInInventory = false;                
            }
            else
            {
                bIsInInventory = true;
            }
            super.Touch(Other, OtherComp, HitLocation, HitNormal);
            // End:0x207
            if(!bIsInInventory)
            {
                // End:0x207
                if(SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(SPWeaponType))
                {
                    SPInventoryManager(SPPawn(Other).InvManager).ClearAmmoFromInventoryItem(SPWeaponType, true);
                    AmmoCopyForFirstPickup(Other);
                    bFadeOut = true;
                    LifeSpan = 0.5000000;
                }
            }
        }
        //return;        
    }

    simulated function bool ValidTouch(Pawn Other)
    {
        return ValidTouchMPFriendly(Other);
        //return ReturnValue;        
    }
    stop;    
}

state FadeOut
{
    simulated event BeginState(name PreviousStateName)
    {
        // End:0x3B
        if(((AmmoCount <= 0) && AmmoCountInMagazine <= 0) && !bDoNotRemoveIfEmpty)
        {
            bFadeOut = true;
            LifeSpan = 0.5000000;            
        }
        else
        {
            bFadeOut = false;
        }
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local int AmmoNeeded;
        local bool bIsSpecialCaseInInventory, bIsInInventory;

        bIsSpecialCaseInInventory = false;
        // End:0xF6
        if((SPPawn(Other) != none) && SPInventoryManager(SPPawn(Other).InvManager) != none)
        {
            // End:0xBE
            if(SPInventoryManager(SPPawn(Other).InvManager).NeedsAmmo(SPWeaponType, AmmoNeeded))
            {
                TransferAmmoFromPickupToGun(Other, AmmoNeeded);
                // End:0xBB
                if(((AmmoCount <= 0) && AmmoCountInMagazine <= 0) && !bDoNotRemoveIfEmpty)
                {
                    bFadeOut = true;
                    LifeSpan = 0.5000000;
                }                
            }
            else
            {
                // End:0xF6
                if((PlayerPawn(Other) != none) && !PlayerPawn(Other).HasReachedMaxLargeWeaponCount())
                {
                    bIsSpecialCaseInInventory = true;
                }
            }
        }
        // End:0x20C
        if(Class'SPPickup'.static.QueryToPickUp(Other, SPWeaponType))
        {
            // End:0x15F
            if(!SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(SPWeaponType) && bIsSpecialCaseInInventory)
            {
                bIsInInventory = false;                
            }
            else
            {
                bIsInInventory = true;
            }
            super(Pickup).Touch(Other, OtherComp, HitLocation, HitNormal);
            // End:0x20C
            if(!bIsInInventory)
            {
                // End:0x20C
                if(SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(SPWeaponType))
                {
                    SPInventoryManager(SPPawn(Other).InvManager).ClearAmmoFromInventoryItem(SPWeaponType, true);
                    AmmoCopyForFirstPickup(Other);
                    bFadeOut = true;
                    LifeSpan = 0.5000000;
                }
            }
        }
        //return;        
    }

    simulated function bool ValidTouch(Pawn Other)
    {
        return ValidTouchMPFriendly(Other);
        //return ReturnValue;        
    }
    stop;    
}
