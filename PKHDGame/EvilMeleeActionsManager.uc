class EvilMeleeActionsManager extends Object within EvilPlayerController;

struct TMeleeWeapon
{
    var bool MeleeWeaponStored;
    var EvilWeap_Melee_Base MeleeWeapon;

    structdefaultproperties
    {
        MeleeWeaponStored=false
        MeleeWeapon=none
    }
};

var TMeleeWeapon OldMeleeWeapon;
var() string LocModule;
var() string LocSection;

simulated function bool ChangeMeleeWeapon(class<EvilWeap_Melee_Base> MeleeWeaponClass)
{
    local EvilWeap_Melee_Base NewMeleeWeapon;

    // End:0xCD
    if(Outer.MyEvilPawn != none)
    {
        StoreOldMeleeWeapon();
        NewMeleeWeapon = EvilWeap_Melee_Base(Outer.MyEvilPawn.FindInventoryType(MeleeWeaponClass, true));
        // End:0xCD
        if(NewMeleeWeapon != none)
        {
            Outer.MyEvilPawn.MeleeWeapon = NewMeleeWeapon;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function ForceKick()
{
    // End:0x63
    if(Outer.MyEvilPawn != none)
    {
        StoreOldMeleeWeapon();
        Outer.MyEvilPawn.MeleeWeapon = none;
    }
    //return;    
}

simulated function ShowLocalizedHintMessage(string Key, optional string Section = LocSection, optional string Module = LocModule)
{
    local string Text;

    Text = Localize(Section, Key, Module);
    // End:0xD2
    if(EvilGFxHudWrapper(Outer.myHUD) != none)
    {
        EvilGFxHudWrapper(Outer.myHUD).HudMovie.SetLocalizedHintMessageText(Text, true);
    }
    //return;    
}

simulated function StopHintMessage()
{
    // End:0x7F
    if(EvilGFxHudWrapper(Outer.myHUD) != none)
    {
        EvilGFxHudWrapper(Outer.myHUD).HudMovie.HideLocalizedHintMessage();
    }
    //return;    
}

simulated function StoreOldMeleeWeapon()
{
    // End:0x9A
    if(!OldMeleeWeapon.MeleeWeaponStored)
    {
        OldMeleeWeapon.MeleeWeapon = EvilWeap_Melee_Base(Outer.MyEvilPawn.MeleeWeapon);
        OldMeleeWeapon.MeleeWeaponStored = true;
    }
    //return;    
}

simulated function Reset()
{
    // End:0xD3
    if((Outer.MyEvilPawn != none) && OldMeleeWeapon.MeleeWeaponStored)
    {
        Outer.MyEvilPawn.MeleeWeapon = OldMeleeWeapon.MeleeWeapon;
        OldMeleeWeapon.MeleeWeapon = none;
        OldMeleeWeapon.MeleeWeaponStored = false;
    }
    //return;    
}

defaultproperties
{
    LocModule="EvilGame"
    LocSection="MeleeActions"
}