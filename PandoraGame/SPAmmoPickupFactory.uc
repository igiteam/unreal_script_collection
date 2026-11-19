class SPAmmoPickupFactory extends SPItemPickupFactory
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
var int AmmoNeeded;
var string PDAMessageUIScene;

simulated function int GetDefaultAmmoAmount()
{
    return default.AmmoAmount;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    SpawnAmmoAmount = AmmoAmount;
    super(Actor).PostBeginPlay();
    //return;    
}

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x4E
    if(SPInventoryManager(Recipient.InvManager) != none)
    {
        SPInventoryManager(Recipient.InvManager).AddAmmoToWeapon(AmmoAmount, TargetWeapon, AmmoType);
    }
    super.SpawnCopyFor(Recipient);
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
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function bool ValidTouch(Pawn Other)
    {
        local SPInventoryManager InvManager;
        local PandoraGameInfo PGI;

        // End:0x12
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        InvManager = SPInventoryManager(Other.InvManager);
        PGI = PandoraGameInfo(WorldInfo.Game);
        // End:0x285
        if(InvManager != none)
        {
            m_bRemovePickup = InvManager.NeedsAmmo(TargetWeapon, AmmoNeeded, AmmoType);
            // End:0x27E
            if(m_bRemovePickup)
            {
                // End:0x27C
                if(AmmoNeeded > 0)
                {
                    // End:0xB3
                    if(AmmoAmount <= AmmoNeeded)
                    {
                        AmmoNeeded = AmmoAmount;
                        AmmoAmount = 0;                        
                    }
                    else
                    {
                        AmmoAmount -= AmmoNeeded;
                    }
                    // End:0xE0
                    if(int(WorldInfo.NetMode) != int(NM_Standalone))
                    {
                        AmmoAmount = 0;
                    }
                    InvManager.AddAmmoToWeapon(AmmoNeeded, TargetWeapon, AmmoType);
                    // End:0x139
                    if((PGI != none) && PDAMessageUIScene != "")
                    {
                        PGI.UnlockPDAMessage(3, PDAMessageUIScene);
                    }
                    switch(AmmoType)
                    {
                        // End:0x16D
                        case "Flare":
                            InvManager.SetPickupAmmoMessage(TargetWeapon, AmmoNeeded, 0);
                            // End:0x22B
                            break;
                        // End:0x19B
                        case "Grenade":
                            InvManager.SetPickupAmmoMessage(TargetWeapon, AmmoNeeded, 1);
                            // End:0x22B
                            break;
                        // End:0x1D2
                        case "MolotovCocktail":
                            InvManager.SetPickupAmmoMessage(TargetWeapon, AmmoNeeded, 2);
                            // End:0x22B
                            break;
                        // End:0x206
                        case "TaserGrenade":
                            InvManager.SetPickupAmmoMessage(TargetWeapon, AmmoNeeded, 3);
                            // End:0x22B
                            break;
                        // End:0xFFFF
                        default:
                            InvManager.SetPickupAmmoMessage(TargetWeapon, AmmoNeeded);
                            // End:0x22B
                            break;
                            break;
                    }
                    // End:0x238
                    if(AmmoAmount <= 0)
                    {
                        return true;
                    }
                    // End:0x277
                    if(int(WorldInfo.NetMode) == int(NM_Standalone))
                    {
                        // End:0x277
                        if(PickupSound != none)
                        {
                            Other.PlaySound(PickupSound);
                        }
                    }
                    return false;                    
                }
                else
                {
                    return false;
                }
            }
            return m_bRemovePickup;
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}
