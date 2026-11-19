class M1 extends TPWeapon;

//simulated state Reloading
//{
//    simulated function BeginState( Name PreviousStateName )
//    {
//        local PlayerPawn player;
//
//        player = PlayerPawn(Owner);
//        if (player != None)
//        {
//            if (GetAmmoInMagazine() != 0)
//            {
//                bAlternateReload = true;
//            }
//        }
//
//        super.BeginState(PreviousStateName);
//    }
//
//    simulated function EndState(Name NextStateName)
//    {
//        local PlayerPawn player;
//
//        player = PlayerPawn(Owner);
//        if (player != None)
//        {
//            bAlternateReload = false;
//        }
//
//        super.EndState(NextStateName);
//    }
//}

// The M1 can only reload after firing your last shot, not manually
simulated function bool CanReload()
{
    if (Super.CanReload() && GetAmmoInMagazine() == 0 && IsInState('WeaponFiring'))
        return true;
    else if (IsInState('Active') && GetAmmoInMagazine() == 0 && Super.CanReload())
        return true;  // i.e. just picked up ammo after previously running out
    else
        return false;
}

simulated function FireAmmunition()
{
    if (GetAmmoInMagazine() == 1)
        bAltFire = true;

    Super.FireAmmunition();
}

simulated state WeaponFiring
{
    simulated function EndState(name NextStateName)
	{
        bAltFire = false;
		Super.EndState(NextStateName);
    }
}

