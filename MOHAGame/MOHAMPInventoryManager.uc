class MOHAMPInventoryManager extends MOHAInventoryManager
    hidecategories(Navigation);

simulated function DropRandomPickup(Controller Killer)
{
    //return;    
}

simulated function DropMedkit(MOHAMultiplayerPawn Pawn)
{
    local Inventory Inv;

    Inv = __NFUN_278__(Class'MOHAMedkitClass',,, Pawn.Location);
    // End:0x99
    if(Inv != none)
    {
        Inv.DropFrom(Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000),, true);
        Class'Engine.JuiceSubsystem'.static.GameStatI("Gameplay", "PickupGeneration", Inv.InventoryId);
    }
    //return;    
}

simulated function DropAmmoPickup(MOHAMultiplayerPawn Pawn)
{
    local EALAWeapon Weapon;
    local MOHAGunAmmoClass Ammo;

    Weapon = EALAWeapon(Pawn.Weapon);
    // End:0x40
    if((Weapon == none) || Weapon != SecondaryWeapon)
    {
        Weapon = PrimaryWeapon;
    }
    // End:0x4D
    if(Weapon == none)
    {
        return;
    }
    Ammo = MOHAGunAmmoClass(__NFUN_278__(Weapon.AmmoClass[0],,, Pawn.Location,,, true));
    // End:0xF6
    if(Ammo != none)
    {
        Ammo.DropFrom(Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
        Class'Engine.JuiceSubsystem'.static.GameStatI("Gameplay", "PickupGeneration", Ammo.InventoryId);
    }
    //return;    
}

simulated function SwitchGammon()
{
    // End:0x0D
    if(GammonGrenadeWeapon == none)
    {
        return;
    }
    super.SwitchGammon();
    //return;    
}

simulated function SwitchFragGrenade()
{
    // End:0x11
    if(FragGrenadeWeapon != none)
    {
        super.SwitchFragGrenade();
    }
    //return;    
}

simulated function SwitchStick()
{
    // End:0x11
    if(StickGrenadeWeapon != none)
    {
        super.SwitchStick();
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
    return false;
    //return ReturnValue;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local bool localReturnValue;

    localReturnValue = super.AddInventory(NewItem, bDoNotActivate);
    MOHAMultiplayerController(Instigator.Controller).SetCurrentExperience();
    return localReturnValue;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    local Weapon W;
    local Canvas Canvas;

    super(Actor).DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(0, byte(255), 0);
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Primary:" @ string(PrimaryWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Secondary:" @ string(SecondaryWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Pistol:" @ string(PistolWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Grenade:" @ string(FragGrenadeWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Grenade:" @ string(GammonGrenadeWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Grenade:" @ string(StickGrenadeWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("DemoCharge:" @ string(DemoChargeWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("Pending:" @ string(PendingWeapon));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.SetDrawColor(0, 200, 0);
    // End:0x305
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        Canvas.__NFUN_465__("Inventory:" @ string(W));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);        
    }    
    //return;    
}
