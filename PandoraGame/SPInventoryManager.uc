class SPInventoryManager extends InventoryManager
    native;

enum GrenadeTypes
{
    GrenadeType_Flare,              // 0
    GrenadeType_Explosive,          // 1
    GrenadeType_Molotov,            // 2
    GrenadeType_Stun,               // 3
    GrenadeType_None,               // 4
    NUM_GRENADETYPES,               // 5
    GrenadeTypes_MAX                // 6
};

var private int FlareAmmo;
var private int ExplosiveAmmo;
var private int MolotovAmmo;
var private int StunAmmo;
var SPInventoryManager.GrenadeTypes curGrenadeType;
var int maxLargeWeapons;
var int maxMeleeWeapons;
var bool m_bUseWeaponSlots;
var const localized string WordPickup;
var const localized string WordRounds;
var const localized string WordFlares;
var const localized string WordGrenades;
var const localized string WordMolotovs;
var const localized string WordTasers;

replication
{
    // Pos:0x000
    if(bNetDirty
        ExplosiveAmmo, FlareAmmo, 
        MolotovAmmo, StunAmmo, 
        curGrenadeType;
}

simulated event int GetGrenadeAmmo(int Type)
{
    local SPInventoryManager.GrenadeTypes eType;

    eType = byte(Type);
    switch(eType)
    {
        // End:0x20
        case 0:
            return FlareAmmo;
        // End:0x2B
        case 1:
            return ExplosiveAmmo;
        // End:0x36
        case 2:
            return MolotovAmmo;
        // End:0x41
        case 3:
            return StunAmmo;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

simulated event SetGrenadeAmmo(int Type, int newAmmoCount)
{
    local SPInventoryManager.GrenadeTypes eType;

    eType = byte(Type);
    switch(eType)
    {
        // End:0x28
        case 0:
            FlareAmmo = newAmmoCount;
            // End:0x64
            break;
        // End:0x3B
        case 1:
            ExplosiveAmmo = newAmmoCount;
            // End:0x64
            break;
        // End:0x4E
        case 2:
            MolotovAmmo = newAmmoCount;
            // End:0x64
            break;
        // End:0x61
        case 3:
            StunAmmo = newAmmoCount;
            // End:0x64
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function bool HandlePickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local Inventory Inv;

    // End:0x0D
    if(InventoryChain == none)
    {
        return true;
    }
    // End:0x64
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x63
        if(ItemClass == Inv.Class)
        {
            // End:0x60
            if(SPPickup(Pickup) != none)
            {
                SPPickup(Pickup).m_bAquiredPickup = true;
            }            
            return false;
        }        
    }    
    return true;
    //return ReturnValue;    
}

simulated function int CountLargeWeapons()
{
    local Inventory Item;
    local int LargeWeaponsFound;
    local SPWeapon theWeapon;

    LargeWeaponsFound = 0;
    Item = InventoryChain;
    J0x12:

    // End:0x9D [Loop If]
    if(Item != none)
    {
        theWeapon = SPWeapon(Item);
        // End:0x3B
        if(theWeapon == none)
        {            
        }
        else
        {
            // End:0x53
            if(!theWeapon.IsLargeWeapon)
            {                
            }
            else
            {
                // End:0x69
                if(theWeapon.IsMeleeWeapon)
                {                    
                }
                else
                {
                    // End:0x85
                    if(!theWeapon.m_bMarkedForDeath)
                    {
                        LargeWeaponsFound++;
                    }
                }
            }
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x12;
    }
    return LargeWeaponsFound;
    //return ReturnValue;    
}

simulated function int CountMeleeWeapons()
{
    local Inventory Item;
    local int MeleeWeaponsFound;
    local SPWeapon theWeapon;

    MeleeWeaponsFound = 0;
    Item = InventoryChain;
    J0x12:

    // End:0x83 [Loop If]
    if(Item != none)
    {
        theWeapon = SPWeapon(Item);
        // End:0x6B
        if(((theWeapon != none) && theWeapon.IsMeleeWeapon) && !theWeapon.m_bMarkedForDeath)
        {
            MeleeWeaponsFound++;
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x12;
    }
    return MeleeWeaponsFound;
    //return ReturnValue;    
}

simulated function bool IsCurrentWeaponMelee()
{
    // End:0x40
    if((SPWeapon(Instigator.Weapon) != none) && SPWeapon(Instigator.Weapon).IsMeleeWeapon)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function SPWeapon GetMeleeWeaponInInventory()
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x51 [Loop If]
    if(Item != none)
    {
        // End:0x39
        if(SPWeapon(Item).IsMeleeWeapon)
        {
            return SPWeapon(Item);
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

simulated function SPWeapon GetRightWeaponInInventory()
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x51 [Loop If]
    if(Item != none)
    {
        // End:0x39
        if(Weapon(Item).bIsStoredRightWeapon)
        {
            return SPWeapon(Item);
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

simulated function SPWeapon GetLeftWeaponInInventory()
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x51 [Loop If]
    if(Item != none)
    {
        // End:0x39
        if(Weapon(Item).bIsStoredLeftWeapon)
        {
            return SPWeapon(Item);
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

simulated function SelectWeapon(int theWeapon)
{
    local Weapon CandidateWeapon, StartWeapon;
    local SPWeapon W;
    local name ClassToSwitchTo;

    // End:0x23
    if(PendingWeapon == none)
    {
        StartWeapon = Instigator.Weapon;        
    }
    else
    {
        StartWeapon = PendingWeapon;
    }
    switch(theWeapon)
    {
        // End:0x4C
        case 1:
            ClassToSwitchTo = 'HK_UMP';
            // End:0xAB
            break;
        // End:0x63
        case 2:
            ClassToSwitchTo = 'shotgun';
            // End:0xAB
            break;
        // End:0x7A
        case 3:
            ClassToSwitchTo = 'Flame';
            // End:0xAB
            break;
        // End:0x91
        case 4:
            ClassToSwitchTo = 'SPRocketLauncher';
            // End:0xAB
            break;
        // End:0xA8
        case 4:
            ClassToSwitchTo = 'SPAssaultRifle';
            // End:0xAB
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xF0
    foreach InventoryActors(Class'SPWeapon', W)
    {
        // End:0xEF
        if(W.IsA(ClassToSwitchTo))
        {
            // End:0xE4
            if(W == StartWeapon)
            {
                // End:0xF0
                break;
            }
            CandidateWeapon = W;
        }        
    }    
    // End:0x126
    if((CandidateWeapon != none) && CandidateWeapon != Instigator.Weapon)
    {
        SetCurrentWeapon(CandidateWeapon);
    }
    //return;    
}

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local class<SPWeapon> spWeaponClass;

    spWeaponClass = class<SPWeapon>(NewInventoryItemClass);
    // End:0x75
    if(((spWeaponClass != none) && Pawn(Owner) != none) && PlayerPawn(Owner) == none)
    {
        spWeaponClass = Class'SPWeapon'.static.ByClassGetNPCWeaponClass(spWeaponClass);
        // End:0x75
        if(spWeaponClass != none)
        {
            NewInventoryItemClass = spWeaponClass;
        }
    }
    return super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
    //return ReturnValue;    
}

simulated function bool CanAddToInventory(Inventory NewItem)
{
    local SPWeapon Weap;
    local PlayerPawn OwnerPawn;

    OwnerPawn = PlayerPawn(Owner);
    Weap = Weapon(NewItem);
    // End:0x2B
    if(m_bUseWeaponSlots)
    {
        return true;
    }
    // End:0x4D
    if((FindInventoryType(NewItem.Class, false)) != none)
    {
        return false;
    }
    // End:0x85
    if(((Weap != none) && Weap.IsLargeWeapon) && (CountLargeWeapons()) >= maxLargeWeapons)
    {
        return false;
    }
    // End:0xC1
    if(((Weap != none) && Weap.IsMelee()) && (CountMeleeWeapons()) >= maxMeleeWeapons)
    {
        return false;
    }
    // End:0x10B
    if((OwnerPawn != none) && !OwnerPawn.HasReachedMaxLargeWeaponCount())
    {
        // End:0x10B
        if((CountLargeWeapons()) == 1)
        {
            OwnerPawn.SetHasReachedMaxLargeWeaponCount();
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local SPWeapon SPWeapon;
    local PlayerController PC;
    local LocalPlayer LP;
    local PlayerPawn OwnerPawn;
    local DataStoreClient DataStoreManager;
    local SPPlayerOwnerDataStore CurrentPlayerData;
    local bool bAddedItem;

    // End:0x17
    if(!CanAddToInventory(NewItem))
    {
        return false;
    }
    OwnerPawn = PlayerPawn(Owner);
    // End:0x157
    if(OwnerPawn != none)
    {
        SPWeapon = SPWeapon(NewItem);
        // End:0x157
        if(SPWeapon != none)
        {
            SPWeapon.m_bMarkedForDeath = false;
            SPWeapon.SavedTossVel = vect(0.0000000, 0.0000000, 0.0000000);
            SPWeapon.bBindDataStore = true;
            SPWeapon.bPlayPickupSound = true;
            PC = PlayerController(OwnerPawn.Controller);
            // End:0x157
            if(PC != none)
            {
                LP = LocalPlayer(PC.Player);
                // End:0x157
                if(LP != none)
                {
                    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
                    // End:0x157
                    if(DataStoreManager != none)
                    {
                        CurrentPlayerData = SPPlayerOwnerDataStore(DataStoreManager.FindDataStore('SPPlayerOwner', LP));
                        // End:0x157
                        if(CurrentPlayerData != none)
                        {
                            CurrentPlayerData.CreateCurrentWeaponDataProvider(SPWeapon);                            
                        }
                    }
                }
            }
        }
    }
    bAddedItem = super.AddInventory(NewItem, bDoNotActivate);
    // End:0x187
    if(bAddedItem)
    {
        AddStoredWeapon(NewItem);
    }
    m_bUseWeaponSlots = false;
    return bAddedItem;
    //return ReturnValue;    
}

simulated function GetWeaponList(out array<SPWeapon> WeaponList)
{
    local SPWeapon Weap;

    // End:0x36
    foreach InventoryActors(Class'SPWeapon', Weap)
    {
        WeaponList[WeaponList.Length] = Weap;
        WeaponList.Length = WeaponList.Length + 1;        
    }    
    //return;    
}

function bool CurrentWeaponHasAmmo(class<SPWeapon> TestWeapon)
{
    local array<SPWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0xA2 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x3A
        if(WeaponList[I] == none)
        {
            // [Explicit Continue]
            goto J0x98;
        }
        // End:0x98
        if(WeaponList[I].Class == TestWeapon)
        {
            // End:0x96
            if((WeaponList[I].AmmoCount <= 0) && WeaponList[I].ammoInMagazine <= 0)
            {
                return false;
                // [Explicit Continue]
                goto J0x98;
            }
            return true;
        }
        J0x98:

        I++;
        // [Loop Continue]
        goto J0x16;
    }
    return true;
    //return ReturnValue;    
}

simulated function SetPickupAmmoMessage(class<SPWeapon> TestWeapon, int AmmoNeeded, optional int GrenadeType)
{
    local array<SPWeapon> WeaponList;
    local string WeaponName;
    local name GrenadeID;
    local PandoraPlayerController PC;
    local int I;
    local bool bIsInInventory;

    GetWeaponList(WeaponList);
    bIsInInventory = false;
    I = 0;
    J0x1F:

    // End:0x1AB [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x43
        if(WeaponList[I] == none)
        {
            // [Explicit Continue]
            goto J0x1A1;
        }
        // End:0x1A1
        if(WeaponList[I].Class == TestWeapon)
        {
            WeaponName = string(Class'SPWeapon'.static.GetWeaponName(TestWeapon));
            bIsInInventory = true;
            PC = PandoraPlayerController(PlayerPawn(Owner).Controller);
            // End:0x109
            if(WeaponName != "GrenadeLauncher")
            {
                // End:0x104
                if(PC != none)
                {
                    PC.ClientSetNewAmmoPickupDisplay(WeaponList[I].WeapID, 0.0000000, AmmoNeeded);
                }
                return;
                // [Explicit Continue]
                goto J0x1A1;
            }
            switch(GrenadeType)
            {
                // End:0x127
                case 0:
                    GrenadeID = 'Flare';
                    // End:0x16E
                    break;
                // End:0x13D
                case 1:
                    GrenadeID = 'Grenade';
                    // End:0x16E
                    break;
                // End:0x154
                case 2:
                    GrenadeID = 'Molotov';
                    // End:0x16E
                    break;
                // End:0x16B
                case 3:
                    GrenadeID = 'Taser';
                    // End:0x16E
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x1A1
            if(PC != none)
            {
                PC.ClientSetNewAmmoPickupDisplay(GrenadeID, 0.0000000, AmmoNeeded, GrenadeType);
            }
        }
        J0x1A1:

        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    // End:0x218
    if(!bIsInInventory)
    {
        PC = PandoraPlayerController(PlayerPawn(Owner).Controller);
        // End:0x218
        if(PC != none)
        {
            PC.ClientSetNewAmmoPickupDisplay(Class'SPWeapon'.static.GetWeaponName(TestWeapon), 0.0000000, AmmoNeeded);
        }
    }
    //return;    
}

simulated function bool IsWeaponInInventory(class<SPWeapon> TestWeapon)
{
    local array<SPWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0x65 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x3A
        if(WeaponList[I] == none)
        {
            // [Explicit Continue]
            goto J0x5B;
        }
        // End:0x5B
        if(WeaponList[I].Class == TestWeapon)
        {
            return true;
        }
        J0x5B:

        I++;
        // [Loop Continue]
        goto J0x16;
    }
    return false;
    //return ReturnValue;    
}

simulated function int ClearAmmoFromInventoryItem(class<SPWeapon> TestWeapon, bool bClearMagazine)
{
    local array<SPWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0xDE [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x3A
        if(WeaponList[I] == none)
        {
            // [Explicit Continue]
            goto J0xD4;
        }
        // End:0xD4
        if(WeaponList[I].Class == TestWeapon)
        {
            WeaponList[I].AmmoCount = 0;
            // End:0x93
            if(bClearMagazine)
            {
                WeaponList[I].ammoInMagazine = 0;                
            }
            else
            {
                WeaponList[I].ammoInMagazine = WeaponList[I].magazineSize;
            }
            return WeaponList[I].magazineSize;
        }
        J0xD4:

        I++;
        // [Loop Continue]
        goto J0x16;
    }
    return -1;
    //return ReturnValue;    
}

function bool NeedsAmmo(class<SPWeapon> TestWeapon, out int AmmoNeeded, optional string AmmoType)
{
    local array<SPWeapon> WeaponList;
    local string WeaponName;
    local int I;

    AmmoNeeded = -1;
    GetWeaponList(WeaponList);
    I = 0;
    J0x22:

    // End:0x3EE [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x46
        if(WeaponList[I] == none)
        {
            // [Explicit Continue]
            goto J0x3E4;
        }
        // End:0x3E4
        if(WeaponList[I].Class == TestWeapon)
        {
            WeaponName = string(Class'SPWeapon'.static.GetWeaponName(TestWeapon));
            // End:0x10C
            if(WeaponName != "GrenadeLauncher")
            {
                // End:0x107
                if(WeaponList[I].AmmoCount < WeaponList[I].MaxAmmoCount)
                {
                    AmmoNeeded = WeaponList[I].MaxAmmoCount - WeaponList[I].AmmoCount;
                    return true;                    
                }
                else
                {
                    return false;
                }
                // [Explicit Continue]
                goto J0x3E4;
            }
            // End:0x3DB
            if((((FlareAmmo + ExplosiveAmmo) + MolotovAmmo) + StunAmmo) < WeaponList[I].GetMaxGrenadeCanCarry())
            {
                AmmoNeeded = WeaponList[I].GetMaxGrenadeCanCarry() - (((FlareAmmo + ExplosiveAmmo) + MolotovAmmo) + StunAmmo);
                switch(AmmoType)
                {
                    // End:0x216
                    case "Flare":
                        // End:0x213
                        if((FlareAmmo + AmmoNeeded) > WeaponList[I].GetMaxFlareCount())
                        {
                            // End:0x1EC
                            if(FlareAmmo >= WeaponList[I].GetMaxFlareCount())
                            {
                                AmmoNeeded = 0;                                
                            }
                            else
                            {
                                AmmoNeeded = WeaponList[I].GetMaxFlareCount() - FlareAmmo;
                            }
                        }
                        // End:0x3D6
                        break;
                    // End:0x2A5
                    case "Grenade":
                        // End:0x2A2
                        if((ExplosiveAmmo + AmmoNeeded) > WeaponList[I].GetMaxGrenadeCount())
                        {
                            // End:0x27B
                            if(ExplosiveAmmo >= WeaponList[I].GetMaxGrenadeCount())
                            {
                                AmmoNeeded = 0;                                
                            }
                            else
                            {
                                AmmoNeeded = WeaponList[I].GetMaxGrenadeCount() - ExplosiveAmmo;
                            }
                        }
                        // End:0x3D6
                        break;
                    // End:0x33C
                    case "MolotovCocktail":
                        // End:0x339
                        if((MolotovAmmo + AmmoNeeded) > WeaponList[I].GetMaxMolotovCount())
                        {
                            // End:0x312
                            if(MolotovAmmo >= WeaponList[I].GetMaxMolotovCount())
                            {
                                AmmoNeeded = 0;                                
                            }
                            else
                            {
                                AmmoNeeded = WeaponList[I].GetMaxMolotovCount() - MolotovAmmo;
                            }
                        }
                        // End:0x3D6
                        break;
                    // End:0x3D0
                    case "TaserGrenade":
                        // End:0x3CD
                        if((StunAmmo + AmmoNeeded) > WeaponList[I].GetMaxTaserGrenadeCount())
                        {
                            // End:0x3A6
                            if(StunAmmo >= WeaponList[I].GetMaxTaserGrenadeCount())
                            {
                                AmmoNeeded = 0;                                
                            }
                            else
                            {
                                AmmoNeeded = WeaponList[I].GetMaxTaserGrenadeCount() - StunAmmo;
                            }
                        }
                        // End:0x3D6
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x3D6
                        break;
                        break;
                }
                return true;
                // [Explicit Continue]
                goto J0x3E4;
            }
            AmmoNeeded = 0;
            return false;
        }
        J0x3E4:

        I++;
        // [Loop Continue]
        goto J0x22;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool ShouldSwitchToBestWeapon()
{
    local PandoraPlayerController MyController;

    // End:0x0D
    if(Instigator == none)
    {
        return false;
    }
    MyController = PandoraPlayerController(Instigator.Controller);
    // End:0x34
    if(MyController == none)
    {
        return false;
    }
    // End:0x4D
    if(MyController.ShouldDisableSwitchToBestWeapon())
    {
        return false;
    }
    return super.ShouldSwitchToBestWeapon();
    //return ReturnValue;    
}

simulated function AddSpecialCaseAmmoFromDroppedPickup(int Ammo, int MagAmmo, SPWeapon Weap)
{
    Weap.AddAmmoFromDroppedPickup(Ammo, MagAmmo);
    //return;    
}

function AddAmmoToWeapon(int AmountToAdd, class<SPWeapon> WeaponClassToAddTo, string AmmoType, optional bool bFillFullWeapon, optional int MagAmmo)
{
    local array<SPWeapon> WeaponList;
    local int I;
    local string WeaponName;
    local bool bHasGrenadeType;
    local PlayerPawn pPawn;

    pPawn = PlayerPawn(Owner);
    GetWeaponList(WeaponList);
    I = 0;
    J0x28:

    // End:0x3FC [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x3F2
        if(WeaponList[I] != none)
        {
            // End:0x3F2
            if(WeaponList[I].Class == WeaponClassToAddTo)
            {
                WeaponName = string(Class'SPWeapon'.static.GetWeaponName(WeaponClassToAddTo));
                // End:0x138
                if(WeaponName != "GrenadeLauncher")
                {
                    // End:0xCF
                    if(bFillFullWeapon)
                    {
                        AddSpecialCaseAmmoFromDroppedPickup(AmountToAdd, MagAmmo, WeaponList[I]);                        
                    }
                    else
                    {
                        WeaponList[I].AddAmmo(AmountToAdd);
                    }
                    // End:0x135
                    if((pPawn != none) && WeaponList[I].ammoInMagazine == 0)
                    {
                        pPawn.AutoReloadFromPickup(WeaponList[I]);
                    }                    
                }
                else
                {
                    // End:0x153
                    if(int(curGrenadeType) == int(4))
                    {
                        bHasGrenadeType = false;                        
                    }
                    else
                    {
                        bHasGrenadeType = true;
                    }
                    switch(AmmoType)
                    {
                        // End:0x200
                        case "Flare":
                            // End:0x1BF
                            if((FlareAmmo + AmountToAdd) > WeaponList[I].GetMaxFlareCount())
                            {
                                AmountToAdd = WeaponList[I].GetMaxFlareCount() - FlareAmmo;
                            }
                            FlareAmmo += AmountToAdd;
                            WeaponList[I].AddAmmo(AmountToAdd);
                            // End:0x1FD
                            if(!bHasGrenadeType)
                            {
                                curGrenadeType = 0;
                            }
                            // End:0x3F0
                            break;
                        // End:0x29F
                        case "Grenade":
                            // End:0x25E
                            if((ExplosiveAmmo + AmountToAdd) > WeaponList[I].GetMaxGrenadeCount())
                            {
                                AmountToAdd = WeaponList[I].GetMaxGrenadeCount() - ExplosiveAmmo;
                            }
                            ExplosiveAmmo += AmountToAdd;
                            WeaponList[I].AddAmmo(AmountToAdd);
                            // End:0x29C
                            if(!bHasGrenadeType)
                            {
                                curGrenadeType = 1;
                            }
                            // End:0x3F0
                            break;
                        // End:0x346
                        case "MolotovCocktail":
                            // End:0x305
                            if((MolotovAmmo + AmountToAdd) > WeaponList[I].GetMaxMolotovCount())
                            {
                                AmountToAdd = WeaponList[I].GetMaxMolotovCount() - MolotovAmmo;
                            }
                            MolotovAmmo += AmountToAdd;
                            WeaponList[I].AddAmmo(AmountToAdd);
                            // End:0x343
                            if(!bHasGrenadeType)
                            {
                                curGrenadeType = 2;
                            }
                            // End:0x3F0
                            break;
                        // End:0x3EA
                        case "TaserGrenade":
                            // End:0x3A9
                            if((StunAmmo + AmountToAdd) > WeaponList[I].GetMaxTaserGrenadeCount())
                            {
                                AmountToAdd = WeaponList[I].GetMaxTaserGrenadeCount() - StunAmmo;
                            }
                            StunAmmo += AmountToAdd;
                            WeaponList[I].AddAmmo(AmountToAdd);
                            // End:0x3E7
                            if(!bHasGrenadeType)
                            {
                                curGrenadeType = 3;
                            }
                            // End:0x3F0
                            break;
                        // End:0xFFFF
                        default:
                            // End:0x3F0
                            break;
                            break;
                    }
                }
                return;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x28;
    }
    //return;    
}

simulated function ResetAmmoTotals()
{
    FlareAmmo = 0;
    ExplosiveAmmo = 0;
    MolotovAmmo = 0;
    StunAmmo = 0;
    //return;    
}

simulated function ChangedWeapon()
{
    local SPWeapon OldWeapon;
    local Pawn PawnOwner;

    OldWeapon = SPWeapon(Instigator.Weapon);
    super.ChangedWeapon();
    PawnOwner = Pawn(Owner);
    // End:0xB2
    if(((OldWeapon != none) && OldWeapon.m_bMarkedForDeath) && PawnOwner != none)
    {
        // End:0x89
        if(int(OldWeapon.WeaponType) == int(1))
        {
            RemoveFromInventory(OldWeapon);            
        }
        else
        {
            PawnOwner.TossInventory(OldWeapon, OldWeapon.SavedTossVel);
        }
    }
    //return;    
}

simulated function PrevWeapon()
{
    local InventoryManager slaveInvManager;

    super.PrevWeapon();
    slaveInvManager = GetSlaveInvManager();
    // End:0x35
    if(slaveInvManager != none)
    {
        slaveInvManager.PrevWeapon();
    }
    //return;    
}

simulated function NextWeapon()
{
    local InventoryManager slaveInvManager;

    super.NextWeapon();
    slaveInvManager = GetSlaveInvManager();
    // End:0x35
    if(slaveInvManager != none)
    {
        slaveInvManager.NextWeapon();
    }
    //return;    
}

simulated function DiscardInventory()
{
    local InventoryManager slaveInvManager;

    super.DiscardInventory();
    slaveInvManager = GetSlaveInvManager();
    // End:0x35
    if(slaveInvManager != none)
    {
        slaveInvManager.DiscardInventory();
    }
    //return;    
}

simulated function InventoryManager GetSlaveInvManager()
{
    local PlayerPawn playerPawnOwner;
    local Pawn SlavePawn;

    playerPawnOwner = PlayerPawn(Owner);
    // End:0x1D
    if(playerPawnOwner == none)
    {
        return none;
    }
    SlavePawn = playerPawnOwner.GetSlavePawn();
    // End:0x44
    if(SlavePawn == none)
    {
        return none;
    }
    return SlavePawn.InvManager;
    //return ReturnValue;    
}

simulated function Weapon ScrollAllWeapons(bool bNextWeapon)
{
    local Weapon StartWeapon, CandidateWeapon, W;
    local bool bBreakNext;

    StartWeapon = Instigator.Weapon;
    // End:0x2B
    if(PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    // End:0xC0
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0x5B
        if(!W.IsEquippable())
        {
            continue;            
        }
        // End:0xA2
        if(bNextWeapon)
        {
            // End:0x88
            if(bBreakNext || StartWeapon == none)
            {
                CandidateWeapon = W;
                // End:0xC0
                break;
            }
            // End:0x9F
            if(W == StartWeapon)
            {
                bBreakNext = true;
            }
            // End:0xBF
            continue;
        }
        // End:0xB4
        if(W == StartWeapon)
        {
            // End:0xC0
            break;
        }
        CandidateWeapon = W;        
    }    
    // End:0x115
    if(CandidateWeapon == none)
    {
        // End:0x114
        foreach InventoryActors(Class'Engine.Weapon', W)
        {
            // End:0xFC
            if(!W.IsEquippable())
            {
                continue;                
            }
            CandidateWeapon = W;
            // End:0x113
            if(bNextWeapon)
            {
                // End:0x114
                break;
            }            
        }        
    }
    // End:0x141
    if((CandidateWeapon == Instigator.Weapon) || CandidateWeapon == none)
    {
        return CandidateWeapon;
    }
    SetCurrentWeapon(CandidateWeapon);
    return CandidateWeapon;
    //return ReturnValue;    
}

simulated function PlayGrenadeSwitchSound(class<SPWeapon> TestWeapon)
{
    local array<SPWeapon> WeaponList;
    local int I;
    local string WeaponName;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0xB2 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0xA8
        if(WeaponList[I] != none)
        {
            WeaponName = string(Class'SPWeapon'.static.GetWeaponName(TestWeapon));
            // End:0xA8
            if(WeaponName == "GrenadeLauncher")
            {
                // End:0xA8
                if(SPGrenadeLauncherPersistent(WeaponList[I]) != none)
                {
                    SPGrenadeLauncherPersistent(WeaponList[I]).PlayGrenadeSwitchSound();
                }
            }
        }
        I++;
        // [Loop Continue]
        goto J0x16;
    }
    //return;    
}

simulated function Weapon GetWeaponForNoAmmoSwitch(SPWeapon CurrWeapon)
{
    local array<SPWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0x9E [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x94
        if(((WeaponList[I] != none) && WeaponList[I] != CurrWeapon) && !WeaponList[I].IsMeleeWeapon)
        {
            // End:0x94
            if(WeaponList[I].HasAnyAmmo())
            {
                return WeaponList[I];
            }
        }
        I++;
        // [Loop Continue]
        goto J0x16;
    }
    return GetMeleeWeaponInInventory();
    //return ReturnValue;    
}

simulated function Weapon SwitchToMeleeWeapon()
{
    local Weapon StartWeapon, CandidateWeapon, W;
    local bool bBreakNext;

    StartWeapon = Instigator.Weapon;
    // End:0x2B
    if(PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    // End:0xB4
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0x78
        if((W.IsEquippable() == false) || W.IsMelee() == false)
        {
            continue;            
        }
        // End:0x9C
        if(bBreakNext || StartWeapon == none)
        {
            CandidateWeapon = W;
            // End:0xB4
            break;
        }
        // End:0xB3
        if(W == StartWeapon)
        {
            bBreakNext = true;
        }        
    }    
    // End:0x11D
    if(CandidateWeapon == none)
    {
        // End:0x11C
        foreach InventoryActors(Class'Engine.Weapon', W)
        {
            // End:0x10D
            if((W.IsEquippable() == false) || W.IsMelee() == false)
            {
                continue;                
            }
            CandidateWeapon = W;
            // End:0x11C
            break;            
        }        
    }
    // End:0x160
    if((CandidateWeapon == Instigator.Weapon) || CandidateWeapon == none)
    {
        // End:0x15E
        if(CandidateWeapon != none)
        {
            return Instigator.Weapon;
        }
        return none;
    }
    SetCurrentWeapon(CandidateWeapon);
    return CandidateWeapon;
    //return ReturnValue;    
}

simulated function Weapon SwitchStoredWeapon(bool bRightWeapon)
{
    local Weapon CandidateWeapon, W;

    // End:0xA0
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0x49
        if(!W.IsEquippable() || W.IsMelee())
        {
            continue;            
        }
        // End:0x7A
        if(bRightWeapon)
        {
            // End:0x77
            if(W.IsRightWeapon())
            {
                CandidateWeapon = W;
                // End:0xA0
                break;
            }
            // End:0x9F
            continue;
        }
        // End:0x9F
        if(W.IsLeftWeapon())
        {
            CandidateWeapon = W;
            // End:0xA0
            break;
        }        
    }    
    // End:0xE4
    if((CandidateWeapon == Instigator.Weapon) || CandidateWeapon == none)
    {
        // End:0xE2
        if(CandidateWeapon != none)
        {
            return Instigator.Weapon;
        }
        return none;
    }
    SetCurrentWeapon(CandidateWeapon);
    return CandidateWeapon;
    //return ReturnValue;    
}

simulated function SetStoredSwapFlags(bool bUseWeaponSlots)
{
    m_bUseWeaponSlots = bUseWeaponSlots;
    //return;    
}

simulated function AddStoredWeapon(Inventory WeaponToAdd)
{
    local Weapon WeaponItem, W;
    local bool bCanAddStoredWeaponR, bCanAddStoredWeaponL;

    bCanAddStoredWeaponR = true;
    bCanAddStoredWeaponL = true;
    WeaponItem = Weapon(WeaponToAdd);
    // End:0x3B
    if(!WeaponItem.IsEquippable())
    {
        return;
    }
    // End:0xD9
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0x84
        if(!W.IsEquippable() || W.IsMelee())
        {
            continue;            
        }
        // End:0xD8
        if(!m_bUseWeaponSlots)
        {
            // End:0xB5
            if(W.IsRightWeapon())
            {
                bCanAddStoredWeaponR = false;
                continue;                
                // End:0xD8
                continue;
            }
            // End:0xD8
            if(W.IsLeftWeapon())
            {
                bCanAddStoredWeaponL = false;
                continue;                
            }
        }        
    }    
    // End:0x1EC
    if(!m_bUseWeaponSlots)
    {
        // End:0x167
        if(bCanAddStoredWeaponR)
        {
            // End:0x164
            if(((WeaponItem != none) && WeaponItem.IsEquippable()) && !WeaponItem.IsMelee())
            {
                WeaponItem.bIsStoredRightWeapon = true;
                // End:0x164
                if(WeaponItem.bIsStoredLeftWeapon)
                {
                    WeaponItem.bIsStoredLeftWeapon = false;
                }
            }            
        }
        else
        {
            // End:0x1E9
            if(bCanAddStoredWeaponL)
            {
                // End:0x1E6
                if(((WeaponItem != none) && WeaponItem.IsEquippable()) && !WeaponItem.IsMelee())
                {
                    WeaponItem.bIsStoredLeftWeapon = true;
                    // End:0x1E6
                    if(WeaponItem.bIsStoredRightWeapon)
                    {
                        WeaponItem.bIsStoredRightWeapon = false;
                    }
                }                
            }
        }        
    }
    else
    {
        // End:0x25F
        if(Instigator.Weapon.bIsStoredLeftWeapon)
        {
            Instigator.Weapon.bIsStoredLeftWeapon = false;
            WeaponItem.bIsStoredLeftWeapon = true;
            // End:0x25C
            if(WeaponItem.bIsStoredRightWeapon)
            {
                WeaponItem.bIsStoredRightWeapon = false;
            }            
        }
        else
        {
            Instigator.Weapon.bIsStoredRightWeapon = false;
            WeaponItem.bIsStoredRightWeapon = true;
            // End:0x2B2
            if(WeaponItem.bIsStoredLeftWeapon)
            {
                WeaponItem.bIsStoredLeftWeapon = false;
            }
        }
    }
    //return;    
}
