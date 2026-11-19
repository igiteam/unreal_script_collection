class MOHAWeaponCSA extends MOHACSASpawnable
    native
    nativereplication
    hidecategories(Navigation);

var MOHAWeaponPickupFactory WeaponPickup;
var MOHAWeaponDroppedPickup DroppedWeaponPickup;
var Class DroppedWeaponPickupClass;
var MOHAIncludeClass.EWeaponType CSAWeaponType;
var MOHAIncludeClass.EWeaponType SavedCSAWeaponType;
var name SavedPawnWeaponName;
var const localized string SwapWeaponMsg;
var const localized string PickupWeaponMsg;

replication
{
    // Pos:0x000
    if((bNetInitial || bNetDirty) && int(Role) == int(ROLE_Authority)
        CSAWeaponType, DroppedWeaponPickupClass;
}

simulated function ComputeWeaponCSAText(MOHAPlayerPawn PlayerPawn)
{
    local class<EALAWeapon> SwappedInWeapon, SwappedOutWeapon;
    local MOHAInventoryManager InvManager;
    local array<string> LocalizedStringVars;

    InvManager = MOHAInventoryManager(PlayerPawn.InvManager);
    // End:0x26
    if(InvManager == none)
    {
        return;
    }
    SwappedInWeapon = GetSwappedInWeapon();
    SwappedOutWeapon = InvManager.GetSwappedOutWeapon(SwappedInWeapon).Class;
    // End:0xAC
    if(SwappedOutWeapon != none)
    {
        csaText = SwapWeaponMsg;
        LocalizedStringVars[LocalizedStringVars.Length] = SwappedOutWeapon.default.DisplayName;
        LocalizedStringVars[LocalizedStringVars.Length] = SwappedInWeapon.default.DisplayName;        
    }
    else
    {
        csaText = PickupWeaponMsg;
        LocalizedStringVars[LocalizedStringVars.Length] = SwappedInWeapon.default.DisplayName;
    }
    csaText = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(csaText, LocalizedStringVars);
    SavedPawnWeaponName = ((PlayerPawn.Weapon != none) ? PlayerPawn.Weapon.Name : 'None');
    SavedCSAWeaponType = CSAWeaponType;
    //return;    
}

simulated function class<EALAWeapon> GetSwappedInWeapon()
{
    // End:0x1D
    if(WeaponPickup != none)
    {
        return WeaponPickup.WeaponPickupClass;        
    }
    else
    {
        // End:0x36
        if(DroppedWeaponPickupClass != none)
        {
            return class<EALAWeapon>(DroppedWeaponPickupClass);            
        }
        else
        {
            // End:0x6F
            if(EALAWeapon(DroppedWeaponPickup.Inventory) != none)
            {
                return class<EALAWeapon>(DroppedWeaponPickup.Inventory.Class);                
            }
            else
            {
                return none;
            }
        }
    }
    //return ReturnValue;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(Other);
    // End:0x102
    if(PlayerPawn != none)
    {
        // End:0xC2
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            // End:0x9B
            if(((DroppedWeaponPickup != none) && !DroppedWeaponPickup.ValidTouch(Pawn(Other))) && !PlayerPawn.IsWeaponDisabled())
            {
                bEnabled = false;
                DroppedWeaponPickup.bGiveAmmo = true;
                return;                
            }
            else
            {
                // End:0xBF
                if(DroppedWeaponPickup != none)
                {
                    bEnabled = true;
                    DroppedWeaponPickup.bGiveAmmo = false;
                }
            }            
        }
        else
        {
            // End:0xEB
            if(PlayerPawn.GetWeaponType() == int(CSAWeaponType))
            {
                bEnabled = false;
                return;
            }
            bEnabled = true;
        }
        ComputeWeaponCSAText(PlayerPawn);
    }
    super(MOHACSA).Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0x13D
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        bRecentlyTriggered = false;
    }
    //return;    
}

simulated function string GetCSAText(MOHAPlayerController mpc)
{
    local string ReplacedText;

    // End:0x24
    if((mpc == none) || mpc.Pawn == none)
    {
        return "";
    }
    // End:0xA8
    if((((mpc.Pawn.Weapon != none) ? mpc.Pawn.Weapon.Name : 'None') != SavedPawnWeaponName) || int(SavedCSAWeaponType) != int(CSAWeaponType))
    {
        ComputeWeaponCSAText(MOHAPlayerPawn(mpc.Pawn));
    }
    ReplacedText = csaText;
    ReplaceText(ReplacedText, "%b", mpc.GetUseButtonToken());
    return ReplacedText;
    //return ReturnValue;    
}

simulated function UnTrigger()
{
    bRecentlyTriggered = false;
    //return;    
}

simulated event bool UsedBy(Pawn User)
{
    local MOHAPlayerController LocalPlayer;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    // End:0x26
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return true;
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0x62
    if((LocalPlayer == none) || !IsUsableBy(LocalPlayer))
    {
        return false;
    }
    // End:0x88
    if(WeaponPickup != none)
    {
        WeaponPickup.GiveTo(User);        
    }
    else
    {
        // End:0xAB
        if(DroppedWeaponPickup != none)
        {
            DroppedWeaponPickup.GiveTo(User);
        }
    }
    LocalPlayer.RemoveCSA(self);
    // End:0xF1
    if(bDisplayed)
    {
        MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
        bDisplayed = false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableBy(MOHAPlayerController PC)
{
    local MOHAPlayerPawn PlayerPawn;
    local MOHAInventoryManager InvMgr;

    // End:0x12
    if(!super(MOHACSA).IsUsableBy(PC))
    {
        return false;
    }
    PlayerPawn = MOHAPlayerPawn(PC.Pawn);
    // End:0x4C
    if((PlayerPawn != none) && PlayerPawn.bMountedOnMG)
    {
        return false;
    }
    // End:0x78
    if((WeaponPickup != none) && !WeaponPickup.ValidSwap(PlayerPawn))
    {
        return false;
    }
    // End:0xA4
    if((DroppedWeaponPickup != none) && !DroppedWeaponPickup.ValidTouch(PlayerPawn))
    {
        return false;
    }
    InvMgr = MOHAInventoryManager(PC.Pawn.InvManager);
    return (InvMgr != none) && !InvMgr.HasWeapon(GetSwappedInWeapon());
    //return ReturnValue;    
}

function LoadLocalizedStrings()
{
    csaText = SwapWeaponMsg;
    //return;    
}

defaultproperties
{
    SwapWeaponMsg="Hold %b to swap %1 for %2"
    PickupWeaponMsg="Hold %b to pickup %1"
    bLookAt=false
    fWeightScale=1.0000000
    // Reference: CylinderComponent'Default__MOHAWeaponCSA.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=100.0000000
        CollisionRadius=200.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAWeaponCSA.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    RemoteRole=1
    bAlwaysRelevant=true
    NetUpdateFrequency=0.1000000
    fDeferredNetUpdateFrequency=0.1000000
    CollisionComponent=CollisionCylinder
}