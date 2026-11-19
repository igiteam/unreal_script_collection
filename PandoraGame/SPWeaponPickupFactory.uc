class SPWeaponPickupFactory extends SPPickup
    abstract
    native;

/** The amount of ammo to give */
var(Pickup) int AmmoAmount;
var int SpawnAmmoAmount;
var class<SPWeapon> TargetWeapon;
var string AmmoType;
var bool m_bRemovePickup;
/** for overriding ammo counts */
var(Pickup) bool m_bOverrideAmmoCount;
var bool bIsItemInInventory;
var bool bDoNotCheckInventory;
var bool bClearedOutAmmoFromWeapon;
var int AmmoNeeded;
var int CachedMagazineSize;
var SPWeaponPickupFactoryTrigger touchTrigger;

simulated function int GetDefaultAmmoAmount()
{
    return default.AmmoAmount;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    SpawnAmmoAmount = AmmoAmount;
    super(Actor).PostBeginPlay();
    CreateTouchTrigger();
    //return;    
}

simulated function DoCreateTouchTrigger()
{
    // End:0x2C
    if(touchTrigger == none)
    {
        touchTrigger = Spawn(Class'SPWeaponPickupFactoryTrigger', self,, Location, Rotation);
    }
    //return;    
}

simulated function CreateTouchTrigger()
{
    DoCreateTouchTrigger();
    CreateTouchTriggerClient();
    //return;    
}

reliable client simulated function CreateTouchTriggerClient()
{
    DoCreateTouchTrigger();
    //return;    
}

simulated function DoDeleteTouchTrigger()
{
    // End:0x1F
    if(touchTrigger != none)
    {
        touchTrigger.Destroy();
        touchTrigger = none;
    }
    //return;    
}

simulated function DeleteTouchTrigger()
{
    DoDeleteTouchTrigger();
    DeleteTouchTriggerClient();
    //return;    
}

reliable client simulated function DeleteTouchTriggerClient()
{
    DoDeleteTouchTrigger();
    //return;    
}

simulated function Destroyed()
{
    DeleteTouchTrigger();
    super(PickupFactory).Destroyed();
    //return;    
}

function PickedUpBy(Pawn P)
{
    DeleteTouchTrigger();
    super(PickupFactory).PickedUpBy(P);
    //return;    
}

function ClearInventoryItem(SPPawn Recipient)
{
    local int MagSize;

    // End:0x7A
    if(Recipient != none)
    {
        MagSize = SPInventoryManager(Recipient.InvManager).ClearAmmoFromInventoryItem(TargetWeapon, false);
        // End:0x7A
        if(MagSize != -1)
        {
            AmmoAmount -= MagSize;
            bClearedOutAmmoFromWeapon = true;
            CachedMagazineSize = MagSize;
            // End:0x7A
            if(AmmoAmount < 0)
            {
                AmmoAmount = 0;
            }
        }
    }
    //return;    
}

auto state Pickup
{
    event BeginState(name PreviousStateName)
    {
        // End:0x1E
        if(!m_bOverrideAmmoCount)
        {
            AmmoAmount = GetDefaultAmmoAmount();            
        }
        else
        {
            AmmoAmount = SpawnAmmoAmount;
        }
        m_bOverrideAmmoCount = default.m_bOverrideAmmoCount;
        bIsItemInInventory = default.bIsItemInInventory;
        bDoNotCheckInventory = default.bDoNotCheckInventory;
        bClearedOutAmmoFromWeapon = default.bClearedOutAmmoFromWeapon;
        CachedMagazineSize = default.CachedMagazineSize;
        CreateTouchTrigger();
        super.BeginState(PreviousStateName);
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        // End:0x12
        if(SPPawn(Other) == none)
        {
            return;
        }
        // End:0x59
        if(!bDoNotCheckInventory && !SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(TargetWeapon))
        {
            bIsItemInInventory = false;
        }
        super.Touch(Other, OtherComp, HitLocation, HitNormal);
        // End:0xD5
        if(!bIsItemInInventory)
        {
            // End:0xCA
            if(SPInventoryManager(SPPawn(Other).InvManager).IsWeaponInInventory(TargetWeapon))
            {
                ClearInventoryItem(SPPawn(Other));
                bDoNotCheckInventory = true;
            }
            bIsItemInInventory = true;            
        }
        else
        {
            bDoNotCheckInventory = true;
        }
        // End:0x2CF
        if((SPPawn(Other) != none) && SPInventoryManager(SPPawn(Other).InvManager) != none)
        {
            // End:0x2CF
            if(SPInventoryManager(SPPawn(Other).InvManager).NeedsAmmo(TargetWeapon, AmmoNeeded))
            {
                // End:0x260
                if(AmmoNeeded > 0)
                {
                    // End:0x173
                    if(AmmoAmount < AmmoNeeded)
                    {
                        AmmoNeeded = AmmoAmount;
                        AmmoAmount = 0;                        
                    }
                    else
                    {
                        AmmoAmount -= AmmoNeeded;
                    }
                    // End:0x1A0
                    if(int(WorldInfo.NetMode) != int(NM_Standalone))
                    {
                        AmmoAmount = 0;
                    }
                    SPInventoryManager(SPPawn(Other).InvManager).AddAmmoToWeapon(AmmoNeeded, TargetWeapon, AmmoType);
                    // End:0x1EE
                    if(bClearedOutAmmoFromWeapon)
                    {
                        AmmoNeeded += CachedMagazineSize;
                    }
                    SPInventoryManager(SPPawn(Other).InvManager).SetPickupAmmoMessage(TargetWeapon, AmmoNeeded);
                    // End:0x260
                    if(int(WorldInfo.NetMode) == int(NM_Standalone))
                    {
                        // End:0x260
                        if(PickupSound != none)
                        {
                            Other.PlaySound(PickupSound);
                        }
                    }
                }
                // End:0x291
                if(int(WorldInfo.NetMode) != int(NM_Standalone))
                {
                    PickedUpBy(SPPawn(Other));                    
                }
                else
                {
                    // End:0x2CF
                    if(AmmoAmount <= 0)
                    {
                        // End:0x2C1
                        if(m_bAquiredPickup)
                        {
                            TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', Pawn(Other), 1);
                        }
                        GotoState('PreDestroy');
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}
