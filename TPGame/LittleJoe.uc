class LittleJoe extends TPWeapon
	deprecated;

var TPProjectile Proj;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//Proj = Spawn(class'Proj_LittleJoeBolt',,,GetPhysicalFireStartLoc());
	//SkeletalMeshComponent(Mesh).AttachComponentToSocket(Proj.StaticMeshComponent,MuzzleFlashSocket);
}

simulated function Projectile ProjectileFire()
{
	//Proj.StaticMeshComponent.SetHidden(true);
	return super.ProjectileFire();
}
simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / (Percent*Percent);
}

simulated state Reloading
{
	simulated function BeginState( Name PreviousStateName )
	{
		local int AmountToReload;
		//local int AmmoDifference;

		//log(self @ "In state Reloading");


        //bPendingAimDownSight = IsAimDownSight();
        //if (bPendingAimDownSight)
        //    ToggleAimDownSight(GetPlayerController());

        bLockAimDownSight = true;

		if(AmmoCount > 0)
		{
			TimeWeaponReload();

			// Find how much ammo is needed if there is still ammo in the magazine

			AmountToReload = MagazineSize - AmmoInMagazine;

            if (AmountToReload <= AmmoCount)
            {
                AmmoInMagazine += AmountToReload;

                if( !bInfiniteAmmo )
					AmmoCount -= AmountToReload;
            }
            else
            {
                AmmoInMagazine += AmmoCount;
                AmmoCount = 0;
            }
		}
		else
		{
			//when would this happpen?
			GotoState('Active');
		}
	}

	simulated function EndState(Name NextStateName)
	{
		//Proj.StaticMeshComponent.SetHidden(false);
		bLockAimDownSight = false;

        //if (bPendingAimDownSight)
        //    ToggleAimDownSight(GetPlayerController());

        ClearTimer('WeaponReloaded');
	}

	simulated function WeaponReloaded()
	{
		GotoState('Active');
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		//animation has ended
		WeaponReloaded();
	}

}

