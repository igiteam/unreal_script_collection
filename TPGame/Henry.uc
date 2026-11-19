
class Henry extends TPWeaponUniqueReload;

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

