//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_DummyWeaponFire extends SeqAct_DummyWeaponFireBase
native(HDSequence);

/** class of weapon to fire */
var() class<HDWeapon> WeaponClass;
var() bool bSpread;

var   HDWeapon SpawnedWeapon;

/** dummy pawn used to fire the weapon */
var HDDummyPawn DummyPawn;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

final function StartFiring()
{
    bFiring = true;

    DummyPawn.StartFire(FiringMode);
    SpawnedWeapon.DummyWeaponFire( FMax(60.0 / float(NewFireRate), 0) ); //????
}

final function StopFiring(int Output = 2)
{
	DummyPawn.StopWeaponFiring();
	bStopped = true;
	bFiring = false;

	OutputLinks[Output].bHasImpulse = true;
}

event Activated()
{
	if(InputLinks[0].bHasImpulse)
	{
	    UpdateOriginTarget(-1.0);
    	bStopped = false;
    	bFinished = false;

		if(WeaponClass == None)
		{
			ScriptLog("Error: DummyWeaponFire with no WeaponClass");
			return;
		}
		else if(TheOrigin == None)
		{
			ScriptLog("Error: DummyWeaponFire with no Origin");
			return;
		}
		else if(TheTarget == None)
		{
			ScriptLog("Error: DummyWeaponFire with no Target");
		}
		else
		{
			// start firing
			ShotsFired = 0;

			if(DummyPawn == None || DummyPawn.bDeleteMe)
			{
				// init the dummy pawn
				DummyPawn = TheOrigin.Spawn(class'HDDummyPawn', ,,,,, true);
				if(DummyPawn == None)
				{
					ScriptLog("Error: Failed to spawn dummy actor");
				}
				else
				{
					DummyPawn.FireAction = self;
					// give it the weapon
					SpawnedWeapon = DummyPawn.Spawn(WeaponClass, DummyPawn);
					SpawnedWeapon.bAllowFiringWithoutController = true;
					SpawnedWeapon.bSuppressSounds = bSuppressAudio;
					SpawnedWeapon.GiveTo(DummyPawn);
					SpawnedWeapon.bDummyWeapon = true;
					SpawnedWeapon.bSpread = bSpread;
                    DummyPawn.InvManager.SetCurrentWeapon(SpawnedWeapon);

					// make sure the weapon attachment is set up
					DummyPawn.WeaponAttachmentChanged();
                    SpawnedWeapon.GotoState('Active');

					//modify
					if(NewDamage > 0)
					{
                        SpawnedWeapon.DummyWeaponDamage = NewDamage;
                        SpawnedWeapon.InstantHitDamage[FiringMode] = NewDamage;
                    }
                    if(NewFireRate > 0)
                    {
                        SpawnedWeapon.FireInterval[FiringMode] =  60.0 / float(NewFireRate);
                    }

				}
			}
			else
			{
				// restart already existing pawn
				DummyPawn.StopWeaponFiring();
			}

            if( HDWeap_Grenade(SpawnedWeapon) != none )  //?????????hack/fix??
            {
                TMInventoryManager(SpawnedWeapon.InvManager).bInfiniteAmmo = false;
                SpawnedWeapon.AddAmmo(-10000);
                SpawnedWeapon.AddAmmo( bShootUntilStopped ? 999 : ShotsToFire );
            }

            if(TheTarget != none)
            {
                StartFiring();
            }

            DummyPawn.UpdateFireLocRot();
		}
	}
	else
	{
		if(DummyPawn != None)
		{
			StopFiring();
		}
	}

	OutputLinks[0].bHasImpulse = true;
}

/** notification that the dummy pawn has fired a shot */
final function NotifyDummyFire()
{
	ShotsFired++;

    if(bShootUntilStopped)
    {
       SpawnedWeapon.AddBulletCount(1, FiringMode);  //HDWeapon??????reload
    }
    else if(ShotsFired >= ShotsToFire)
	{
        StopFiring(1);
        bFinished = true;
	}
}

event bool Update(float DeltaTime)
{
    if(!bStopped && InputLinks[1].bHasImpulse) //Sotp me
	{
        StopFiring();
	}

	if(bFinished || bStopped)
        return false;

    UpdateOriginTarget(DeltaTime);
    DummyPawn.UpdateFireLocRot();

    if(TheOrigin != none && TheTarget != none)
    {
        if(!bFiring)
        {
            StartFiring();
        }
	}
	else if(bFiring)  //Pause
	{
        DummyPawn.StopWeaponFiring();
        bFiring = false;
    }

	// keep ticking as long as the dummy pawn is still going
	return (DummyPawn != None/* && !bStopped*/);
}

