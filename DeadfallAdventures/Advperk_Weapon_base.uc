class Advperk_Weapon_base extends AdvPerk_Base
    config(Perks)
    notplaceable
    hidecategories(Navigation);

var config int AmmoCount;
var config int SecondAmmoCount;
var config int HealthBonus;
var config int PerkWeaponDamageMultiplier;
var config int SecondWeaponDamageMultiplier;
var class<EvilWeap_Base> PerkWeapon;
var class<EvilWeap_Base> SecondPerkWeapon;
var class<EvilDmgType_Base> PerkWeaponDamageType;
var class<EvilDmgType_Base> SecondWeaponDamageType;

function bool ActivatePerk(Controller PC)
{
    local bool Result;
    local Weapon W;
    local int I;

    // End:0x84
    if(AdvPlayerPawnMP(PC.Pawn).bQuickHidenWeapon || AdvPlayerPawnMP(PC.Pawn).bQuickHidenLeftWeapon)
    {
        return false;
    }
    // End:0x105
    if(HealthBonus != 0)
    {
        PC.Pawn.Health = PC.Pawn.HealthMax + HealthBonus;
    }
    // End:0x384
    if(SecondPerkWeapon != none)
    {
        W = Weapon(PC.Pawn.CreateInventory(SecondPerkWeapon, true));
        // End:0x384
        if(W != none)
        {
            EvilWeap_Base(W).AmmoCount = SecondAmmoCount;
            EvilWeap_Base(W).DefaultAmmoCount = SecondAmmoCount;
            EvilWeap_Base(W).MaxAmmoCount = SecondAmmoCount;
            // End:0x35A
            if(SecondWeaponDamageMultiplier != 0)
            {
                I = 0;
                J0x221:

                // End:0x35A [Loop If]
                if(I < EvilWeap_Base(W).WeaponDamage.Length)
                {
                    EvilWeap_Base(W).WeaponDamage[I] *= float(SecondWeaponDamageMultiplier);
                    EvilWeap_Base(W).InstantHitDamage[I] *= float(SecondWeaponDamageMultiplier);
                    EvilWeap_Base(W).WeaponZoomDamage[I] *= float(SecondWeaponDamageMultiplier);
                    EvilWeap_Base(W).InstantHitDamageTypes[I] = SecondWeaponDamageType;
                    I++;
                    // [Loop Continue]
                    goto J0x221;
                }
            }
            EvilWeap_Base(W).bForceNetUpdate = true;
        }
    }
    W = Weapon(PC.Pawn.CreateInventory(PerkWeapon, true));
    // End:0x665
    if(W != none)
    {
        EvilWeap_Base(W).AmmoCount = AmmoCount;
        EvilWeap_Base(W).DefaultAmmoCount = AmmoCount;
        EvilWeap_Base(W).MaxAmmoCount = AmmoCount;
        // End:0x5CA
        if(PerkWeaponDamageMultiplier != 0)
        {
            I = 0;
            J0x491:

            // End:0x5CA [Loop If]
            if(I < EvilWeap_Base(W).WeaponDamage.Length)
            {
                EvilWeap_Base(W).WeaponDamage[I] *= float(PerkWeaponDamageMultiplier);
                EvilWeap_Base(W).InstantHitDamage[I] *= float(PerkWeaponDamageMultiplier);
                EvilWeap_Base(W).WeaponZoomDamage[I] *= float(PerkWeaponDamageMultiplier);
                EvilWeap_Base(W).InstantHitDamageTypes[I] = PerkWeaponDamageType;
                I++;
                // [Loop Continue]
                goto J0x491;
            }
        }
        AdvPlayerPawnMP(PC.Pawn).SetCurrentWeaponClass(EvilWeap_Base(W).Class, true);
        EvilWeap_Base(W).bForceNetUpdate = true;
        Result = true;
    }
    super.ActivatePerk(PC);
    return Result;
    //return ReturnValue;    
}
