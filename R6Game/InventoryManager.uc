class InventoryManager extends Actor
    native
    notplaceable
    hidecategories(lighting);

var travel Inventory InventoryChain;
var Weapon PendingWeapon;
var Weapon LastAttemptedSwitchToWeapon;
var bool bMustHoldWeapon;
var array<int> PendingFire;

replication
{
    // Pos:0x000
    if((((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bNetOwner)
        InventoryChain;
}

function PostBeginPlay()
{
    PostBeginPlay();
    Instigator = Pawn(Owner);
    return;
}

// Export UInventoryManager::execInventoryActors(FFrame&, void* const)
native final iterator function InventoryActors(class<Inventory> BaseClass, out Inventory Inv);

simulated exec function DumpWeaponStats()
{
    local Weapon Weap;

    // End:0x24
    foreach InventoryActors(Class'Weapon', Weap)
    {
        Weap.DumpWeaponDebugToLog();        
    }    
    return;
}

function SetupFor(Pawn P)
{
    // End:0x12
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    Instigator = P;
    SetOwner(P);
    return;
}

event Destroyed()
{
    DiscardInventory();
    return;
}

function bool HandlePickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local Inventory Inv;

    // End:0x0D
    if(InventoryChain == none)
    {
        return true;
    }
    // End:0x41
    foreach InventoryActors(Class'Inventory', Inv)
    {
        // End:0x40
        if(Inv.DenyPickupQuery(ItemClass, Pickup))
        {            
            return false;
        }        
    }    
    return true;
    return;
}

simulated event Inventory FindInventoryType(class<Inventory> DesiredClass)
{
    local Inventory Inv;

    // End:0x1B
    foreach InventoryActors(DesiredClass, Inv)
    {        
        return Inv;        
    }    
    return none;
    return;
}

function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local Inventory Inv;

    // End:0xF7
    if(NewInventoryItemClass != none)
    {
        Inv = __NFUN_278__(NewInventoryItemClass);
        // End:0xAE
        if(Inv != none)
        {
            // End:0xAB
            if(int(AddInventory(Inv)) != int(0))
            {
                WarnInternal("InventoryManager::CreateInventory - Couldn't Add newly created inventory" @ string(Inv));
                Inv.Destroy();
                Inv = none;
            }            
        }
        else
        {
            WarnInternal("InventoryManager::CreateInventory - Couldn't spawn inventory" @ string(NewInventoryItemClass));
        }
    }
    return Inv;
    return;
}

// Export UInventoryManager::execCanAddInventory(FFrame&, void* const)
native function Inventory.EPickupResult CanAddInventory(Inventory pNewItem);

// Export UInventoryManager::execAddInventory(FFrame&, void* const)
native function Inventory.EPickupResult AddInventory(Inventory pNewItem, optional bool bDoNotActivate);

// Export UInventoryManager::execRemoveFromInventory(FFrame&, void* const)
native function RemoveFromInventory(Inventory pItemToRemove);

// Export UInventoryManager::execDiscardInventory(FFrame&, void* const)
native function DiscardInventory();

simulated function OwnerEvent(name EventName)
{
    local Inventory Inv;

    // End:0x3B
    foreach InventoryActors(Class'Inventory', Inv)
    {
        // End:0x3A
        if(Inv.bReceiveOwnerEvents)
        {
            Inv.OwnerEvent(EventName);
        }        
    }    
    return;
}

simulated function DrawHUD(HUD H)
{
    local Inventory Inv;

    // End:0x3B
    foreach InventoryActors(Class'Inventory', Inv)
    {
        // End:0x3A
        if(Inv.bRenderOverlays)
        {
            Inv.RenderOverlays(H);
        }        
    }    
    // End:0x6E
    if(Instigator.Weapon != none)
    {
        Instigator.Weapon.ActiveRenderOverlays(H);
    }
    return;
}

// Export UInventoryManager::execIsActiveWeapon(FFrame&, void* const)
native function bool IsActiveWeapon(Weapon ThisWeapon);

simulated function float GetWeaponRatingFor(Weapon W)
{
    local float Rating;

    // End:0x1B
    if(!W.HasAnyAmmo())
    {
        return -1.0000000;
    }
    Rating = 1.0000000;
    // End:0x8C
    if(((!Instigator.IsHumanControlled() && IsActiveWeapon(W)) && Instigator.Controller != none) && Instigator.Controller.Enemy != none)
    {
        Rating += 0.2100000;
    }
    return Rating;
    return;
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W, BestWeapon;
    local float Rating, BestRating;

    // End:0x8E
    foreach InventoryActors(Class'Weapon', W)
    {
        // End:0x8D
        if(W.HasAnyAmmo())
        {
            // End:0x45
            if(bForceADifferentWeapon && IsActiveWeapon(W))
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0x8D
            if((BestWeapon == none) || Rating > BestRating)
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }        
    }    
    return BestWeapon;
    return;
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon BestWeapon;

    // End:0x92
    if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
    {
        BestWeapon = GetBestWeapon(bForceADifferentWeapon);
        // End:0x52
        if(BestWeapon == none)
        {
            return;
        }
        // End:0x92
        if(BestWeapon == Instigator.Weapon)
        {
            BestWeapon = none;
            PendingWeapon = none;
            Instigator.Weapon.Activate();
        }
    }
    Instigator.Controller.StopFiring();
    SetCurrentWeapon(BestWeapon);
    return;
}

simulated function PrevWeapon()
{
    local Weapon CandidateWeapon, StartWeapon, W;

    StartWeapon = Instigator.Weapon;
    // End:0x2A
    if(PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    // End:0x5B
    foreach InventoryActors(Class'Weapon', W)
    {
        // End:0x4F
        if(W == StartWeapon)
        {
            // End:0x5B
            break;
        }
        CandidateWeapon = W;        
    }    
    // End:0x87
    if(CandidateWeapon == none)
    {
        // End:0x86
        foreach InventoryActors(Class'Weapon', W)
        {
            CandidateWeapon = W;            
        }        
    }
    // End:0xA1
    if(CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
    return;
}

simulated function NextWeapon()
{
    local Weapon StartWeapon, CandidateWeapon, W;
    local bool bBreakNext;

    StartWeapon = Instigator.Weapon;
    // End:0x2A
    if(PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    // End:0x79
    foreach InventoryActors(Class'Weapon', W)
    {
        // End:0x61
        if(bBreakNext || StartWeapon == none)
        {
            CandidateWeapon = W;
            // End:0x79
            break;
        }
        // End:0x78
        if(W == StartWeapon)
        {
            bBreakNext = true;
        }        
    }    
    // End:0xA8
    if(CandidateWeapon == none)
    {
        // End:0xA7
        foreach InventoryActors(Class'Weapon', W)
        {
            CandidateWeapon = W;
            // End:0xA7
            break;            
        }        
    }
    // End:0xC2
    if(CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
    return;
}

// Export UInventoryManager::execSetCurrentWeapon(FFrame&, void* const)
native function SetCurrentWeapon(Weapon pDesiredWeapon, optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction);

simulated function bool CancelWeaponChange()
{
    // End:0x48
    if((Instigator.Weapon == PendingWeapon) || PendingWeapon == none)
    {
        Instigator.Weapon.Activate();
        PendingWeapon = none;
        return true;
    }
    return false;
    return;
}

simulated event ChangedWeapon(optional bool bInstantSwitch)
{
    local Weapon OldWeapon;

    OldWeapon = Instigator.Weapon;
    // End:0x57
    if((PendingWeapon == none) && bMustHoldWeapon)
    {
        // End:0x57
        if(OldWeapon != none)
        {
            OldWeapon.Activate(bInstantSwitch);
            PendingWeapon = OldWeapon;
        }
    }
    Instigator.SetWeapon(PendingWeapon);
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, PendingWeapon);
    // End:0xE2
    if(PendingWeapon != none)
    {
        PendingWeapon.Instigator = Instigator;
        // End:0xC5
        if(WorldInfo.Game != none)
        {
        }
        PendingWeapon.Activate(bInstantSwitch);
        PendingWeapon = none;
    }
    // End:0x122
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
    return;
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet)
{
    local Weapon OldWeapon;

    OldWeapon = Instigator.Weapon;
    // End:0x5B
    if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
    {
        SetCurrentWeapon(NewWeapon);
        return;
    }
    // End:0x6C
    if(OldWeapon == NewWeapon)
    {
        return;
    }
    // End:0xCB
    if(bOptionalSet)
    {
        // End:0xCB
        if(OldWeapon.DenyClientWeaponSet() || Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
        {
            LastAttemptedSwitchToWeapon = NewWeapon;
            return;
        }
    }
    // End:0x173
    if(((PendingWeapon == none) || !PendingWeapon.HasAnyAmmo()) || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
    {
        // End:0x173
        if(!Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            SetCurrentWeapon(NewWeapon);
            return;
        }
    }
    NewWeapon.GotoState('Inactive');
    return;
}

// Export UInventoryManager::execRememberWeapon(FFrame&, void* const)
native function RememberWeapon();

simulated event EquipRememberedWeapon(optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction)
{
    true        
    return;
}

function Rotator GetDropRotation()
{
    return;
}

defaultproperties
{
    PendingFire[0]=0
    PendingFire[1]=0
    PendingFire[2]=0
    PendingFire[3]=0
    bHidden=true
    bOnlyRelevantToOwner=true
    bReplicateInstigator=true
    bReplicateMovement=false
    bOnlyDirtyReplication=true
    RemoteRole=1
    TickGroup=1
    NetPriority=1.4000000
}