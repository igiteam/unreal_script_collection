class MOHAInventoryManager extends InventoryManager
    native
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

enum EWeaponFilter
{
    WEAPON_FILTER_NONE,             // 0
    WEAPON_FILTER_GRENADE,          // 1
    WEAPON_FILTER_GUN,              // 2
    WEAPON_FILTER_DEMOCHARGE,       // 3
    WEAPON_FILTER_MG42,             // 4
    WEAPON_FILTER_MAX               // 5
};

var EALAWeapon PrimaryWeapon;
var EALAWeapon SecondaryWeapon;
var EALAWeapon PistolWeapon;
var EALAWeapon FragGrenadeWeapon;
var EALAWeapon DemoChargeWeapon;
var EALAWeapon GammonGrenadeWeapon;
var EALAWeapon StickGrenadeWeapon;
var EALAGrenade LastGrenadeWeapon;
var EALASmallArms LastSmallArmsWeapon;
var EALAWeapon LastNonMGWeapon;
var bool bInfiniteAmmo;
var ReserveAmmo AmmoStorage[10];
var int NumAmmoClasses;

// Export UMOHAInventoryManager::execGetReserveAmmoCount(FFrame&, void* const)
native simulated function int GetReserveAmmoCount(class<EALAAmmoInventoryClass> AmmoClass);

simulated function RestoreReserveAmmo(array<ReserveAmmo> RestoredAmmoStorage)
{
    local int I;

    // DebugMode: 0
    assert(RestoredAmmoStorage.Length == 10);
    I = 0;
    J0x15:

    // End:0x46 [Loop If]
    if(I < RestoredAmmoStorage.Length)
    {
        AmmoStorage[I] = RestoredAmmoStorage[I];
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

simulated event AddReserveAmmo(class<EALAAmmoInventoryClass> AmmoClass, int iAmount, optional bool bAbsolute)
{
    local int I, iReserveAmmo;

    I = 0;
    J0x08:

    // End:0xA7 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x9D
        if(AmmoStorage[I].AmmoClass == AmmoClass)
        {
            iReserveAmmo = ((bAbsolute) ? iAmount : AmmoStorage[I].ReserveAmmoAmount + iAmount);
            AmmoStorage[I].ReserveAmmoAmount = Clamp(iReserveAmmo, 0, AmmoStorage[I].MaxAmmoCount);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x08;
    }
    // DebugMode: 0
    assert(NumAmmoClasses < 10);
    // End:0x121
    if(NumAmmoClasses < 10)
    {
        AmmoStorage[NumAmmoClasses].ReserveAmmoAmount = iAmount;
        AmmoStorage[NumAmmoClasses].AmmoClass = AmmoClass;
        AmmoStorage[NumAmmoClasses].MaxAmmoCount = AmmoClass.default.MaxAmmoCount;
        NumAmmoClasses++;
    }
    //return;    
}

function bool NeedsAmmo(class<EALAAmmoInventoryClass> AmmoClass)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x75 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x6B
        if(AmmoStorage[I].AmmoClass == AmmoClass)
        {
            // End:0x69
            if(AmmoStorage[I].ReserveAmmoAmount < AmmoStorage[I].MaxAmmoCount)
            {
                return true;
                // [Explicit Continue]
                goto J0x6B;
            }
            return false;
        }
        J0x6B:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    //return ReturnValue;    
}

function bool NeedsGunAmmo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x71 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x67
        if(ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHAGunAmmoClass'))
        {
            // End:0x67
            if(AmmoStorage[I].ReserveAmmoAmount < AmmoStorage[I].MaxAmmoCount)
            {
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool NeedsGrenadeAmmo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x93 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x89
        if(ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHAGrenadeAmmoClass') || ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHARocketAmmoClass'))
        {
            // End:0x89
            if(AmmoStorage[I].ReserveAmmoAmount < AmmoStorage[I].MaxAmmoCount)
            {
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function SetMaxAmmoCount(class<EALAAmmoInventoryClass> AmmoClass, int newAmmoCount)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x52
        if(AmmoStorage[I].AmmoClass == AmmoClass)
        {
            AmmoStorage[I].MaxAmmoCount = newAmmoCount;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // DebugMode: 0
    assert(NumAmmoClasses < 10);
    // End:0xC9
    if(NumAmmoClasses < 10)
    {
        AmmoStorage[NumAmmoClasses].ReserveAmmoAmount = 0;
        AmmoStorage[NumAmmoClasses].AmmoClass = AmmoClass;
        AmmoStorage[NumAmmoClasses].MaxAmmoCount = newAmmoCount;
        NumAmmoClasses++;
    }
    //return;    
}

function int GetMaxAmmoCount(class<EALAAmmoInventoryClass> AmmoClass)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0x4B
        if(AmmoStorage[I].AmmoClass == AmmoClass)
        {
            return AmmoStorage[I].MaxAmmoCount;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return 0;
    //return ReturnValue;    
}

function GiveFullGunAmmo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xB0 [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0xA6
        if(ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHAGunAmmoClass') && !ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHARocketAmmoClass'))
        {
            AddReserveAmmo(AmmoStorage[I].AmmoClass, AmmoStorage[I].MaxAmmoCount - AmmoStorage[I].ReserveAmmoAmount);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function GiveFullGrenadeAmmo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xAE [Loop If]
    if(I < NumAmmoClasses)
    {
        // End:0xA4
        if(ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHAGrenadeAmmoClass') || ClassIsChildOf(AmmoStorage[I].AmmoClass, Class'MOHARocketAmmoClass'))
        {
            AddReserveAmmo(AmmoStorage[I].AmmoClass, AmmoStorage[I].MaxAmmoCount - AmmoStorage[I].ReserveAmmoAmount);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event SetInfiniteAmmo(bool bInfinite)
{
    local EALAWeapon InvWeapon;

    // End:0x3E
    foreach InventoryActors(Class'EALAWeapon', InvWeapon)
    {
        // End:0x3D
        if(!InvWeapon.default.bInfiniteAmmo)
        {
            InvWeapon.bInfiniteAmmo = bInfinite;
        }        
    }    
    //return;    
}

simulated function bool HasItem(class<Inventory> ItemClass)
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x47 [Loop If]
    if(Item != none)
    {
        // End:0x30
        if(Item.Class == ItemClass)
        {
            return true;
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool HasWeapon(class<EALAWeapon> WeaponClass)
{
    local EALAWeapon Weap;

    // End:0x45
    foreach InventoryActors(Class'EALAWeapon', Weap)
    {
        // End:0x44
        if(int(Weap.Class.default.WeaponType) == int(WeaponClass.default.WeaponType))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated function PlayerPawnDied()
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x55 [Loop If]
    if(Item != none)
    {
        // End:0x3E
        if(EALAWeapon(Item) != none)
        {
            EALAWeapon(Item).PlayerPawnDied();
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function CopyInventoryToWorldInfoLoadout()
{
    local Inventory Item;
    local WeaponInfo WeapInfo;

    WorldInfo.WeaponLoadout.Remove(0, WorldInfo.WeaponLoadout.Length);
    Item = InventoryChain;
    J0x2A:

    // End:0x95 [Loop If]
    if(Item != none)
    {
        // End:0x7E
        if(Item.IsA('EALAWeapon'))
        {
            WeapInfo.WeaponClass = Item.Class;
            WorldInfo.WeaponLoadout.AddItem(WeapInfo);
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x2A;
    }
    //return;    
}

simulated function SetupWeaponPointers()
{
    local Inventory Item;

    Item = InventoryChain;
    J0x0B:

    // End:0x155 [Loop If]
    if(Item != none)
    {
        // End:0x40
        if(Item.IsA('MOHA_MKIIFragGrenade'))
        {
            FragGrenadeWeapon = EALAWeapon(Item);            
        }
        else
        {
            // End:0x6A
            if(Item.IsA('MOHA_GammonGrenade'))
            {
                GammonGrenadeWeapon = EALAWeapon(Item);                
            }
            else
            {
                // End:0x94
                if(Item.IsA('MOHA_StickGrenade'))
                {
                    StickGrenadeWeapon = EALAWeapon(Item);                    
                }
                else
                {
                    // End:0xBE
                    if(Item.IsA('MOHAPistol'))
                    {
                        PistolWeapon = EALAWeapon(Item);                        
                    }
                    else
                    {
                        // End:0xE8
                        if(Item.IsA('EALADemoCharge'))
                        {
                            DemoChargeWeapon = EALAWeapon(Item);                            
                        }
                        else
                        {
                            // End:0x13E
                            if(Item.IsA('EALASmallArms'))
                            {
                                // End:0x11D
                                if(PrimaryWeapon == none)
                                {
                                    PrimaryWeapon = EALAWeapon(Item);                                    
                                }
                                else
                                {
                                    // End:0x13B
                                    if(SecondaryWeapon == none)
                                    {
                                        SecondaryWeapon = EALAWeapon(Item);                                        
                                    }
                                }                                
                            }
                        }
                    }
                }
            }
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function SwitchWeapon()
{
    // End:0x2E
    if((IsHoldingPrimary(true)) && SecondaryWeapon != none)
    {
        SetCurrentWeapon(SecondaryWeapon);        
    }
    else
    {
        // End:0x49
        if(IsHoldingSecondary(true))
        {
            SwitchPistol();            
        }
        else
        {
            // End:0x6A
            if(IsHoldingPistol(true))
            {
                SetCurrentWeapon(PrimaryWeapon);                
            }
            else
            {
                // End:0x8B
                if(IsHoldingAnyGrenade())
                {
                    SetCurrentWeapon(LastSmallArmsWeapon);                    
                }
                else
                {
                    // End:0xAB
                    if(IsHoldingDemoCharge())
                    {
                        SetCurrentWeapon(LastSmallArmsWeapon);                        
                    }
                    else
                    {
                        // End:0xD3
                        if((IsHoldingPrimary()) && SecondaryWeapon == none)
                        {
                            SwitchPistol();                            
                        }
                        else
                        {
                            SetCurrentWeapon(PrimaryWeapon);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function SwitchPreviousWeapon()
{
    // End:0x1B
    if(IsHoldingPrimary(true))
    {
        SwitchPistol();        
    }
    else
    {
        // End:0x49
        if((IsHoldingPistol(true)) && SecondaryWeapon != none)
        {
            SetCurrentWeapon(SecondaryWeapon);            
        }
        else
        {
            // End:0x6A
            if(IsHoldingSecondary(true))
            {
                SetCurrentWeapon(PrimaryWeapon);                
            }
            else
            {
                // End:0x8B
                if(IsHoldingAnyGrenade())
                {
                    SetCurrentWeapon(LastSmallArmsWeapon);                    
                }
                else
                {
                    // End:0xAB
                    if(IsHoldingDemoCharge())
                    {
                        SetCurrentWeapon(LastSmallArmsWeapon);                        
                    }
                    else
                    {
                        // End:0xD9
                        if((IsHoldingPistol()) && SecondaryWeapon == none)
                        {
                            SetCurrentWeapon(PrimaryWeapon);                            
                        }
                        else
                        {
                            SetCurrentWeapon(PrimaryWeapon);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function SwitchPrimary()
{
    // End:0x20
    if(!IsHoldingPrimary())
    {
        SetCurrentWeapon(PrimaryWeapon);
    }
    //return;    
}

simulated function SwitchSecondary()
{
    // End:0x2D
    if(!IsHoldingSecondary() && SecondaryWeapon != none)
    {
        SetCurrentWeapon(SecondaryWeapon);
    }
    //return;    
}

simulated function EALAWeapon GetWeaponOfType(MOHAIncludeClass.EWeaponType Type)
{
    // End:0x2F
    if((PrimaryWeapon != none) && int(PrimaryWeapon.WeaponType) == int(Type))
    {
        return PrimaryWeapon;
    }
    // End:0x5E
    if((SecondaryWeapon != none) && int(SecondaryWeapon.WeaponType) == int(Type))
    {
        return SecondaryWeapon;
    }
    // End:0x8D
    if((PistolWeapon != none) && int(PistolWeapon.WeaponType) == int(Type))
    {
        return PistolWeapon;
    }
    // End:0xBC
    if((FragGrenadeWeapon != none) && int(FragGrenadeWeapon.WeaponType) == int(Type))
    {
        return FragGrenadeWeapon;
    }
    // End:0xEB
    if((GammonGrenadeWeapon != none) && int(GammonGrenadeWeapon.WeaponType) == int(Type))
    {
        return GammonGrenadeWeapon;
    }
    // End:0x11A
    if((StickGrenadeWeapon != none) && int(StickGrenadeWeapon.WeaponType) == int(Type))
    {
        return StickGrenadeWeapon;
    }
    return none;
    //return ReturnValue;    
}

// Export UMOHAInventoryManager::execGetHUDGrenade(FFrame&, void* const)
native simulated function EALAWeapon GetHUDGrenade();

// Export UMOHAInventoryManager::execGetHUDWeapon(FFrame&, void* const)
native simulated function EALAWeapon GetHUDWeapon();

simulated function ChangedWeapon()
{
    super.ChangedWeapon();
    // End:0x10D
    if(Instigator.Weapon != none)
    {
        // End:0x53
        if(Instigator.Weapon.IsA('EALAGrenade'))
        {
            LastGrenadeWeapon = EALAGrenade(Instigator.Weapon);
        }
        // End:0xB0
        if(Instigator.Weapon.IsA('EALASmallArms') && !Instigator.Weapon.IsA('MOHAMountedGunWeapon'))
        {
            LastSmallArmsWeapon = EALASmallArms(Instigator.Weapon);
        }
        // End:0x10D
        if(Instigator.Weapon.IsA('EALAWeapon') && !Instigator.Weapon.IsA('MOHAMountedGunWeapon'))
        {
            LastNonMGWeapon = EALAWeapon(Instigator.Weapon);
        }
    }
    //return;    
}

simulated function SwitchGrenade()
{
    // End:0x149
    if(!IsHoldingAnyGrenade(true))
    {
        // End:0x5E
        if((LastGrenadeWeapon != none) && LastGrenadeWeapon.HasAnyAmmo() || LastGrenadeWeapon.HasReserveAmmo())
        {
            SetCurrentWeapon(LastGrenadeWeapon);            
        }
        else
        {
            // End:0xA6
            if((FragGrenadeWeapon != none) && FragGrenadeWeapon.HasAnyAmmo() || FragGrenadeWeapon.HasReserveAmmo())
            {
                SwitchFragGrenade();                
            }
            else
            {
                // End:0xEE
                if((GammonGrenadeWeapon != none) && GammonGrenadeWeapon.HasAnyAmmo() || GammonGrenadeWeapon.HasReserveAmmo())
                {
                    SwitchGammon();                    
                }
                else
                {
                    // End:0x136
                    if((StickGrenadeWeapon != none) && StickGrenadeWeapon.HasAnyAmmo() || StickGrenadeWeapon.HasReserveAmmo())
                    {
                        SwitchStick();                        
                    }
                    else
                    {
                        SetCurrentWeapon(LastSmallArmsWeapon);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x1FA
        if(IsHoldingFragGrenade(true))
        {
            // End:0x19F
            if((GammonGrenadeWeapon != none) && GammonGrenadeWeapon.HasAnyAmmo() || GammonGrenadeWeapon.HasReserveAmmo())
            {
                SwitchGammon();                
            }
            else
            {
                // End:0x1E7
                if((StickGrenadeWeapon != none) && StickGrenadeWeapon.HasAnyAmmo() || StickGrenadeWeapon.HasReserveAmmo())
                {
                    SwitchStick();                    
                }
                else
                {
                    SetCurrentWeapon(LastSmallArmsWeapon);
                }
            }            
        }
        else
        {
            // End:0x2AB
            if(IsHoldingGammonGrenade(true))
            {
                // End:0x250
                if((StickGrenadeWeapon != none) && StickGrenadeWeapon.HasAnyAmmo() || StickGrenadeWeapon.HasReserveAmmo())
                {
                    SwitchStick();                    
                }
                else
                {
                    // End:0x298
                    if((FragGrenadeWeapon != none) && FragGrenadeWeapon.HasAnyAmmo() || FragGrenadeWeapon.HasReserveAmmo())
                    {
                        SwitchFragGrenade();                        
                    }
                    else
                    {
                        SetCurrentWeapon(LastSmallArmsWeapon);
                    }
                }                
            }
            else
            {
                // End:0x359
                if(IsHoldingStickGrenade(true))
                {
                    // End:0x301
                    if((FragGrenadeWeapon != none) && FragGrenadeWeapon.HasAnyAmmo() || FragGrenadeWeapon.HasReserveAmmo())
                    {
                        SwitchFragGrenade();                        
                    }
                    else
                    {
                        // End:0x349
                        if((GammonGrenadeWeapon != none) && GammonGrenadeWeapon.HasAnyAmmo() || GammonGrenadeWeapon.HasReserveAmmo())
                        {
                            SwitchGammon();                            
                        }
                        else
                        {
                            SetCurrentWeapon(LastSmallArmsWeapon);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function SwitchFragGrenade()
{
    // End:0x53
    if(!IsHoldingFragGrenade() && FragGrenadeWeapon.HasAnyAmmo() || FragGrenadeWeapon.HasReserveAmmo())
    {
        SetCurrentWeapon(FragGrenadeWeapon);        
    }
    else
    {
        // End:0x71
        if(IsHoldingFragGrenade())
        {
            SetCurrentWeapon(LastSmallArmsWeapon);
        }
    }
    //return;    
}

simulated function SwitchGammon()
{
    // End:0x53
    if(!IsHoldingGammonGrenade() && GammonGrenadeWeapon.HasAnyAmmo() || GammonGrenadeWeapon.HasReserveAmmo())
    {
        SetCurrentWeapon(GammonGrenadeWeapon);        
    }
    else
    {
        // End:0x71
        if(IsHoldingGammonGrenade())
        {
            SetCurrentWeapon(LastSmallArmsWeapon);
        }
    }
    //return;    
}

simulated function SwitchStick()
{
    // End:0x53
    if(!IsHoldingStickGrenade() && StickGrenadeWeapon.HasAnyAmmo() || StickGrenadeWeapon.HasReserveAmmo())
    {
        SetCurrentWeapon(StickGrenadeWeapon);        
    }
    else
    {
        // End:0x71
        if(IsHoldingStickGrenade())
        {
            SetCurrentWeapon(LastSmallArmsWeapon);
        }
    }
    //return;    
}

simulated function SwitchPistol()
{
    // End:0x30
    if(!IsHoldingPistol() && PistolWeapon != none)
    {
        SetCurrentWeapon(PistolWeapon);        
    }
    else
    {
        // End:0x4E
        if(IsHoldingPistol())
        {
            SetCurrentWeapon(LastSmallArmsWeapon);
        }
    }
    //return;    
}

simulated function SwitchToLastNonMGWeapon()
{
    // End:0x1E
    if(LastNonMGWeapon != none)
    {
        SetCurrentWeapon(LastNonMGWeapon);        
    }
    else
    {
        SwitchToBestWeapon();
    }
    //return;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local EALAWeapon NewWeapon;
    local MOHAPlayerController PlayerController;
    local editinline MOHAWeaponExperienceComponent ExpComponent;

    // End:0x125
    if(super.AddInventory(NewItem, bDoNotActivate))
    {
        PlayerController = MOHAPlayerController(Instigator.Controller);
        // End:0x51
        if(PlayerController != none)
        {
            PlayerController.OnAddInventory(NewItem);
        }
        NewWeapon = EALAWeapon(NewItem);
        // End:0x123
        if(Instigator.IsA('MOHAPlayerPawn') && NewWeapon != none)
        {
            ExpComponent = PlayerController.playerStats.GetWeaponExpComponent(NewWeapon.Class);
            // End:0xEA
            if(ExpComponent == none)
            {
                PlayerController.playerStats.CreateExperienceComponent(NewWeapon.Class);
            }
            // End:0x123
            if(!NewWeapon.default.bInfiniteAmmo)
            {
                NewWeapon.bInfiniteAmmo = PlayerController.IsCheatActive(2);
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    local Inventory Item;
    local bool bFound;

    // End:0x164
    if(ItemToRemove != none)
    {
        // End:0x33
        if(ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = none;
        }
        // End:0x61
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0x6C:

            // End:0xCE [Loop If]
            if(Item != none)
            {
                // End:0xB7
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0xCE;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0x6C;
            }
        }
        J0xCE:

        // End:0x107
        if(bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
        }
        // End:0x164
        if(((Instigator.Weapon == none) && Instigator.Controller != none) && Instigator.Health > 0)
        {
            Instigator.Controller.ClientSwitchToBestWeapon(false);
        }
    }
    //return;    
}

simulated function SwapWeapon(EALAWeapon NewWeapon, Vector vDropLocation, Rotator rDropRotation, optional bool bNewWeaponPreviouslyOwnedByPlayer = false)
{
    local Weapon DropWeapon;

    DropWeapon = GetSwappedOutWeapon(NewWeapon.Class);
    // End:0x7F
    if(DropWeapon != none)
    {
        // End:0x48
        if(PrimaryWeapon == DropWeapon)
        {
            PrimaryWeapon = NewWeapon;
        }
        // End:0x62
        if(SecondaryWeapon == DropWeapon)
        {
            SecondaryWeapon = NewWeapon;
        }
        // End:0x7C
        if(PistolWeapon == DropWeapon)
        {
            PistolWeapon = NewWeapon;
        }        
    }
    else
    {
        // End:0xA4
        if(NewWeapon.IsA('MOHAPistol'))
        {
            PistolWeapon = NewWeapon;            
        }
        else
        {
            // End:0xBD
            if(SecondaryWeapon == none)
            {
                SecondaryWeapon = NewWeapon;                
            }
            else
            {
                // End:0xD3
                if(PrimaryWeapon == none)
                {
                    PrimaryWeapon = NewWeapon;
                }
            }
        }
    }
    // End:0xF5
    if(Instigator.IsLocallyControlled())
    {
        SetCurrentWeapon(NewWeapon);
    }
    // End:0x164
    if(EALAWeapon(DropWeapon) != none)
    {
        // End:0x142
        if(DropWeapon == Instigator.Weapon)
        {
            EALAWeapon(DropWeapon).DropWeaponWhenPutDownDone(vDropLocation, rDropRotation);            
        }
        else
        {
            EALAWeapon(DropWeapon).DropWeapon(vDropLocation, rDropRotation);
        }
    }
    // End:0x25D
    if(!bNewWeaponPreviouslyOwnedByPlayer && (GetReserveAmmoCount(NewWeapon.AmmoClass[0])) < NewWeapon.PickupMinAmmo)
    {
        // End:0x218
        if((Instigator.IsLocallyControlled() == false) && MOHAMultiplayerController(Instigator.Controller) != none)
        {
            MOHAMultiplayerController(Instigator.Controller).ClientSetMaxAmmoCount(NewWeapon.AmmoClass[0], NewWeapon.AmmoClass[0].default.MaxAmmoCount);
        }
        AddReserveAmmo(NewWeapon.AmmoClass[0], NewWeapon.PickupMinAmmo - (GetReserveAmmoCount(NewWeapon.AmmoClass[0])));
    }
    //return;    
}

simulated function EALAWeapon GetSwappedOutWeapon(class<EALAWeapon> SwappedInWeaponClass)
{
    // End:0x24
    if(ClassIsChildOf(SwappedInWeaponClass, Class'MOHAPistol'))
    {
        return ((PistolWeapon != none) ? PistolWeapon : none);
    }
    // End:0x3E
    if((PrimaryWeapon == none) || SecondaryWeapon == none)
    {
        return none;
    }
    // End:0x52
    if(IsHoldingSecondary())
    {
        return SecondaryWeapon;
    }
    // End:0x66
    if(IsHoldingPrimary())
    {
        return PrimaryWeapon;
    }
    // End:0x77
    if(SecondaryWeapon != none)
    {
        return SecondaryWeapon;
    }
    // End:0x88
    if(PrimaryWeapon != none)
    {
        return PrimaryWeapon;
    }
    return none;
    //return ReturnValue;    
}

simulated function Weapon FilteredNextWeapon(MOHAInventoryManager.EWeaponFilter Filter)
{
    local Weapon StartWeapon;
    local EALAWeapon CandidateWeapon, W;
    local bool bBreakNext;

    StartWeapon = Instigator.Weapon;
    // End:0x2A
    if(PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    // End:0x14C
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0x6C
        if((int(Filter) == int(1)) && !W.IsA('EALAGrenade'))
        {
            continue;            
        }
        // End:0xB2
        if((int(Filter) == int(2)) && W.IsA('EALAGrenade') || W.IsA('EALADemoCharge'))
        {
            continue;            
        }
        // End:0xE1
        if((int(Filter) == int(3)) && !W.IsA('EALADemoCharge'))
        {
            continue;            
        }
        // End:0x110
        if((int(Filter) == int(4)) && !W.IsA('MOHAMG42Weapon'))
        {
            continue;            
        }
        // End:0x134
        if(bBreakNext || StartWeapon == none)
        {
            CandidateWeapon = W;
            // End:0x14C
            break;
        }
        // End:0x14B
        if(W == StartWeapon)
        {
            bBreakNext = true;
        }        
    }    
    // End:0x24E
    if(CandidateWeapon == none)
    {
        // End:0x24D
        foreach InventoryActors(Class'Engine.Weapon', W)
        {
            // End:0x19A
            if((int(Filter) == int(1)) && !W.IsA('EALAGrenade'))
            {
                continue;                
            }
            // End:0x1E0
            if((int(Filter) == int(2)) && W.IsA('EALAGrenade') || W.IsA('EALADemoCharge'))
            {
                continue;                
            }
            // End:0x20F
            if((int(Filter) == int(3)) && !W.IsA('EALADemoCharge'))
            {
                continue;                
            }
            // End:0x23E
            if((int(Filter) == int(4)) && !W.IsA('MOHAMG42Weapon'))
            {
                continue;                
            }
            CandidateWeapon = W;
            // End:0x24D
            break;            
        }        
    }
    // End:0x26C
    if(CandidateWeapon == Instigator.Weapon)
    {
        return CandidateWeapon;
    }
    // End:0x287
    if(int(Filter) == int(3))
    {
        DemoChargeWeapon = CandidateWeapon;
    }
    SetCurrentWeapon(CandidateWeapon);
    return CandidateWeapon;
    //return ReturnValue;    
}

simulated event SetCurrentWeapon(Weapon DesiredWeapon, optional bool bForce)
{
    local Weapon PrevWeapon;

    PrevWeapon = Instigator.Weapon;
    // End:0x7B
    if((!bForce && PrevWeapon != none) && ((DesiredWeapon == PrevWeapon) && !PrevWeapon.IsInState('WeaponPuttingDown')) || (DesiredWeapon == PendingWeapon) && DesiredWeapon != none)
    {
        return;
    }
    // End:0xD9
    if((((DesiredWeapon == none) && none != Instigator) && none != MOHAPlayerController(Instigator.Controller)) && false == MOHAPlayerController(Instigator.Controller).PlayerUsingMountedGun())
    {
        return;
    }
    SetPendingWeapon(DesiredWeapon);
    // End:0x1B1
    if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive'))
    {
        // End:0x19B
        if(!EALAWeapon(PrevWeapon).HasReserveAmmo() && !PrevWeapon.HasAnyAmmo())
        {
            // End:0x18E
            if(EALAWeapon(PrevWeapon).PutWeaponDownWhenEmpty())
            {
                PrevWeapon.TryPutDown();                
            }
            else
            {
                ChangedWeapon();
            }            
        }
        else
        {
            PrevWeapon.TryPutDown();
        }        
    }
    else
    {
        ChangedWeapon();
    }
    // End:0x211
    if(int(Instigator.Controller.Role) < int(ROLE_Authority))
    {
        MOHAMultiplayerController(Instigator.Controller).ServerSetCurrentWeaponType(EALAWeapon(DesiredWeapon).WeaponType);
    }
    //return;    
}

simulated function DiscardInventory()
{
    local Inventory Inv;

    FragGrenadeWeapon = none;
    GammonGrenadeWeapon = none;
    StickGrenadeWeapon = none;
    PistolWeapon = none;
    DemoChargeWeapon = none;
    PrimaryWeapon = none;
    SecondaryWeapon = none;
    // End:0x51
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        Inv.Destroy();        
    }    
    //return;    
}

function class<EALAAmmoInventoryClass> GetPrimaryAmmoClass()
{
    // End:0x1C
    if(PrimaryWeapon != none)
    {
        return PrimaryWeapon.AmmoClass[0];
    }
    //return ReturnValue;    
}

function class<EALAAmmoInventoryClass> GetSecondaryAmmoClass()
{
    // End:0x1C
    if(SecondaryWeapon != none)
    {
        return SecondaryWeapon.AmmoClass[0];
    }
    //return ReturnValue;    
}

function PlayerController FindPlayerController()
{
    local PlayerController PC;

    // End:0x4E
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4D
        if((PC.Pawn != none) && PC.PlayerCamera != none)
        {            
            return PC;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function MOHAPlayerPawn FindPlayerPawn()
{
    local PlayerController PC;

    PC = FindPlayerController();
    // End:0x2F
    if(none != PC)
    {
        return MOHAPlayerPawn(PC.Pawn);
    }
    return none;
    //return ReturnValue;    
}

function Vector GetRandomDropVelocity()
{
    return (200.0000000 * VRand()) + vect(0.0000000, 0.0000000, 150.0000000);
    //return ReturnValue;    
}

simulated function DropRandomPickup(Controller Killer)
{
    local Inventory Inv;
    local MOHAInventoryManager InvManager;
    local DropTableEntry entry;
    local float rand_num;
    local MOHAPlayerPawn P;
    local class<EALAAmmoInventoryClass> AmmoClass;

    // End:0x465
    if(MOHAGameInfo(WorldInfo.Game) != none)
    {
        Inv = none;
        entry = MOHAGameInfo(WorldInfo.Game).GetDropTable(MOHAAIPawn(Instigator));
        P = FindPlayerPawn();
        // End:0x6E
        if(P == none)
        {
            return;
        }
        rand_num = FRand();
        // End:0xCC
        if(Killer.IsA('MOHAPlayerController') && ShouldDropHealth(P, rand_num, entry.HealthFrequency))
        {
            Inv = __NFUN_278__(Class'MOHAMedkitClass');            
        }
        else
        {
            // End:0x1AF
            if(((rand_num < entry.WeaponFrequency) && EALAWeapon(Instigator.Weapon) != none) && EALAWeapon(Instigator.Weapon).IsUsableByPlayer())
            {
                Class'Engine.JuiceSubsystem'.static.LevelStatI("Gameplay", "PickupGeneration", Instigator.Weapon.InventoryId);
                Instigator.Weapon.DropFrom(Instigator.Location, GetRandomDropVelocity());
                DiscardInventory();                
            }
            else
            {
                // End:0x3F0
                if((rand_num > entry.WeaponFrequency) && rand_num <= entry.AmmoFrequency)
                {
                    InvManager = MOHAInventoryManager(P.InvManager);
                    // End:0x209
                    if(InvManager == none)
                    {
                        return;
                    }
                    rand_num = FRand();
                    // End:0x283
                    if(rand_num < entry.AmmoSpecific.PrimaryAmmoFrequency)
                    {
                        AmmoClass = InvManager.GetPrimaryAmmoClass();
                        // End:0x280
                        if((AmmoClass != none) && !ClassIsChildOf(AmmoClass, Class'MOHARocketAmmoClass'))
                        {
                            Inv = __NFUN_278__(AmmoClass);
                        }                        
                    }
                    else
                    {
                        // End:0x2F5
                        if(rand_num < entry.AmmoSpecific.SecondaryAmmoFrequency)
                        {
                            AmmoClass = InvManager.GetSecondaryAmmoClass();
                            // End:0x2F2
                            if((AmmoClass != none) && !ClassIsChildOf(AmmoClass, Class'MOHARocketAmmoClass'))
                            {
                                Inv = __NFUN_278__(AmmoClass);
                            }                            
                        }
                        else
                        {
                            // End:0x32F
                            if(rand_num < entry.AmmoSpecific.PistolAmmoFrequency)
                            {
                                Inv = __NFUN_278__(Class'MOHAPistolAmmoClass');                                
                            }
                            else
                            {
                                // End:0x3F0
                                if(rand_num < entry.AmmoSpecific.GrenadeAmmoFrequency)
                                {
                                    rand_num = FRand();
                                    // End:0x394
                                    if(rand_num <= entry.GrenadeSpecific.FragGrenadeFrequency)
                                    {
                                        Inv = __NFUN_278__(Class'MOHAMKIIFragGrenadeAmmoClass');                                        
                                    }
                                    else
                                    {
                                        // End:0x3F0
                                        if((rand_num > entry.GrenadeSpecific.FragGrenadeFrequency) && rand_num <= entry.GrenadeSpecific.StickGrenadeFrequency)
                                        {
                                            Inv = __NFUN_278__(Class'MOHAStickGrenadeAmmoClass');
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x465
        if(Inv != none)
        {
            Inv.DropFrom(Instigator.Location, GetRandomDropVelocity());
            Class'Engine.JuiceSubsystem'.static.GameStatI("Gameplay", "PickupGeneration", Inv.InventoryId);
        }
    }
    //return;    
}

simulated function bool ShouldDropHealth(MOHAPlayerPawn P, float rand_num, float Frequency)
{
    local float PickupDecayedTime;

    // End:0x53
    if(WorldInfo.HealthDroppedPickups.Length >= 1)
    {
        PickupDecayedTime = WorldInfo.TimeSeconds - WorldInfo.LastHealthDroppedTime;
        // End:0x53
        if(PickupDecayedTime < Class'MOHAHealthDroppedPickup'.default.fHealthDroppedPickupDecay)
        {
            return false;
        }
    }
    // End:0x8C
    if((rand_num <= Frequency) && P.GetHealthRatio() <= P.fHealthPackDropHealthPct)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool IsHoldingPrimary(optional bool bConsiderPendingWeapon)
{
    // End:0x27
    if(bConsiderPendingWeapon && PendingWeapon != none)
    {
        return PendingWeapon == PrimaryWeapon;        
    }
    else
    {
        return (Instigator.Weapon == PrimaryWeapon) && PrimaryWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingSecondary(optional bool bConsiderPendingWeapon)
{
    // End:0x27
    if(bConsiderPendingWeapon && PendingWeapon != none)
    {
        return PendingWeapon == SecondaryWeapon;        
    }
    else
    {
        return (Instigator.Weapon == SecondaryWeapon) && SecondaryWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingPistol(optional bool bConsiderPendingWeapon)
{
    // End:0x34
    if(bConsiderPendingWeapon && PendingWeapon != none)
    {
        return (PendingWeapon == PistolWeapon) && PistolWeapon != none;        
    }
    else
    {
        return (Instigator.Weapon == PistolWeapon) && PistolWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingGrenadesOrPistol()
{
    return (IsHoldingPistol()) || IsHoldingAnyGrenade();
    //return ReturnValue;    
}

simulated function bool IsHoldingAnyGrenade(optional bool bPendingWeap)
{
    return ((IsHoldingFragGrenade(bPendingWeap)) || IsHoldingGammonGrenade(bPendingWeap)) || IsHoldingStickGrenade(bPendingWeap);
    //return ReturnValue;    
}

simulated function bool IsHoldingFragGrenade(optional bool bConsiderPendingWeap)
{
    // End:0x27
    if(bConsiderPendingWeap && PendingWeapon != none)
    {
        return PendingWeapon == FragGrenadeWeapon;        
    }
    else
    {
        return (Instigator.Weapon == FragGrenadeWeapon) && FragGrenadeWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingGammonGrenade(optional bool bConsiderPendingWeap)
{
    // End:0x27
    if(bConsiderPendingWeap && PendingWeapon != none)
    {
        return PendingWeapon == GammonGrenadeWeapon;        
    }
    else
    {
        return (Instigator.Weapon == GammonGrenadeWeapon) && GammonGrenadeWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingStickGrenade(optional bool bConsiderPendingWeap)
{
    // End:0x27
    if(bConsiderPendingWeap && PendingWeapon != none)
    {
        return PendingWeapon == StickGrenadeWeapon;        
    }
    else
    {
        return (Instigator.Weapon == StickGrenadeWeapon) && StickGrenadeWeapon != none;
    }
    //return ReturnValue;    
}

simulated function bool IsHoldingDemoCharge()
{
    return (Instigator.Weapon == DemoChargeWeapon) && DemoChargeWeapon != none;
    //return ReturnValue;    
}

simulated function StopWeaponChange()
{
    Instigator.Weapon.Activate();
    PendingWeapon = none;
    //return;    
}

simulated event OnAtLevelStartCheckpoint()
{
    local EALAWeapon InvWeapon;
    local MOHAPlayerController PlayerController;

    PlayerController = MOHAPlayerController(Instigator.Controller);
    // End:0x50
    foreach InventoryActors(Class'EALAWeapon', InvWeapon)
    {
        // End:0x4F
        if(InvWeapon != none)
        {
            PlayerController.OnAddInventory(InvWeapon);
        }        
    }    
    //return;    
}

defaultproperties
{
    PendingFire=/* Array type was not detected. */
    RemoteRole=0
    bStasis=true
}