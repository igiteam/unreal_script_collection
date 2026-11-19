class TPWeaponUniqueReload extends TPWeapon
    abstract;

var int                 AmountToReload;
var bool                bWantsToFire;

simulated function SetPendingFire(int FireMode)
{
    if (bAllowInterruptReload)
        bWantsToFire = true;

    Super.SetPendingFire(FireMode);
}

simulated event DecrementAmmo()
{
    local int Num;

    if (GetMagazineSize() - GetAmmoInMagazine() >= 2)
        Num = 2;
    else
        Num = 1;
    
    Num = min(AmountToReload, Num);

    AmountToReload -= Num;
    AddToAmmoInMagazine(Num);

	if ( !bInfiniteAmmo )
		AmmoCount -= Num;
}

reliable server function ServerPlayReloadFinished()
{
	PlayReloadFinished();
}

simulated event PlayReloadFinished()
{
	// This is not called on the server due to 1st/3rd person anim differences.  So call this to sync up with the server!
	if( WorldInfo.NetMode == NM_Client )
	{
		ServerPlayReloadFinished();
	}

    DecrementAmmo();

    if (AmountToReload <= 2)
    {
        bLoopReload = false;
        bAlternateReload = true;
    }

    bAllowInterruptReload = false;

    if (bWantsToFire)
        SendToFiringState(CurrentSubFireType);
}

simulated state Reloading
{
    simulated function BeginState( Name PreviousStateName )
    {
		if (bIsNPCWeapon)
		{
			Super.BeginState(PreviousStateName);
			return;
		}

        AmountToReload = GetMagazineSize() - GetAmmoInMagazine();

		//`log(" ChadAI - Weapon: " @ Self@ " TPWeaponUniqueReload - Reloading:BeginState AmountToReload: " @ AmountToReload @ " - GetMagazineSize: " @ GetMagazineSize() @ " - GetAmmoInMagazine: " @ GetAmmoInMagazine() @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

        AmountToReload = min(AmmoCount, AmountToReload);

		//`log(" ChadAI - Weapon: " @ Self@ " TPWeaponUniqueReload - Reloading:BeginState after min AmountToReload: " @ AmountToReload @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

        bWantsToFire   = false;

        TPPawn(Owner).bIsReloading = true;

		TryToStoreAimDownSight();

    }

    // Override parent since we can't assume the magazine will be full
    // after the reloading animation sequence ends
    simulated function EndState(Name NextStateName)
    {
		if (bIsNPCWeapon)
		{
			Super.EndState(NextStateName);
			return;
		}

        bLoopReload       = false;
        bAlternateReload  = false;

        bLockAimDownSight = false;

		TPPawn(Owner).bIsReloading = false;

        ClearTimer('WeaponReloaded');
        
		if ( bIsNPCWeapon && Owner != None )
		{
			if ( TPSoldierAIController(Pawn(Owner).Controller) != None )
			{
				TPSoldierAIController(Pawn(Owner).Controller).WeaponReloaded();
			}
		}

		TryToRestoreAimDownSight();
    }

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		if (bIsNPCWeapon)
		{
			Super.OnAnimEnd(SeqNode,PlayedTime,ExcessTime);
			return;
		}

		if (SeqNode != None && SeqNode.NodeName == 'WeaponReloadingAnimations')
		{
			//`log(" ChadAI - Weapon: " @ Self@ " TPWeaponUniqueReload - OnAnimEnd-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

            if (AmountToReload >= 3)
            {
                bLoopReload = true;
                bAlternateReload = false;
            }
            else if (bAlternateReload)
            {
                DecrementAmmo();
                bAlternateReload = false;
                Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
            }
            else
            {
                bAlternateReload = true;
            }
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
		;
		return;
	}
}
