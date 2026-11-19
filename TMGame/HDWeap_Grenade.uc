//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_Grenade extends HDWeapon
	abstract;

var bool        animation_finished;
var bool        throw_grenade;
var float       OutHandTime;

simulated function PostBeginPlay()
{
	Super.PostbeginPlay();
}

/**
 * This function is called from the pawn when the visibility of the weapon changes
 */
simulated function ChangeVisibility(bool bIsVisible)
{
	Super.ChangeVisibility(bIsVisible);
}

simulated function StartFire(byte FireModeNum);
//simulated function StopFire(byte FireModeNum);

// rewrite set attachment class
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
    Super.AttachWeaponTo( MeshCpnt, SocketName );
}

simulated function SetAttachmentClass()
{
    Super.SetAttachmentClass();
}
simulated function SetBackAttachmentClass();

/**
 * When StopFire is called on a client, ServerStopFire is used to initiate the sequence on the server.
 * Network: Dedicated Server only, or Listen Server for remote clients.
 */
reliable server function ServerStopFire(byte FireModeNum)
{
	Super.ServerStopFire( FireModeNum );

	if(bDummyWeapon)
    {
       ClearTimer('AutoFireAmmunition');
    }
}

simulated function TestThrowGrenade()
{
}

simulated function ThrowGrenade()
{
	if (throw_grenade)
		return;

	throw_grenade = true;
	TestThrowGrenade();
}


simulated state WeaponEquipping
{
    simulated event BeginState(Name PreviousStateName)
    {
	   Super.BeginState(PreviousStateName);
    }
}

simulated state Active
{
	simulated function TestThrowGrenade()
	{
		if (throw_grenade && animation_finished)
		{
			if (HDInventoryManager(InvManager) != none)
				HDInventoryManager(InvManager).FinishThrowGrenade();
		}
	}

	simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
	{
		super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
		animation_finished = true;
		TestThrowGrenade();
	}

	simulated function ThrowGrenade()
	{
		throw_grenade = true;
		TestThrowGrenade();
	}
}

simulated state Throwing
{
	simulated function ThrowGrenade()
	{
	}

	simulated function ThrowFunc()
	{
		FireAmmunition();
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}

	simulated function FinishedFunc()
	{
		if (HDInventoryManager(InvManager) != none)
			HDInventoryManager(InvManager).FinishThrowGrenade();
	}

	simulated event BeginState(Name PreviousStateName)
	{
		SetTimer(0.3f, FALSE, nameof(ThrowFunc));
		SetTimer(0.4f, FALSE, nameof(FinishedFunc));
	}

	simulated event EndState( Name NextStateName )
	{
		throw_grenade = false;
		animation_finished = false;
	}
}

simulated function Notify_ThrowGrenade();
simulated state WeaponPuttingDown
{
	simulated event BeginState(Name PreviousStateName)
	{
		SetTimer(OutHandTime, FALSE, nameof(FireGrenade));
		super.BeginState(PreviousStateName);
	}

	simulated event EndState( Name NextStateName )
	{
		throw_grenade = false;
		animation_finished = false;
		super.EndState(NextStateName);
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(False);
        }
	}

	simulated function Notify_ThrowGrenade()
	{
	    //FireAmmunition();
	}

	simulated function FireGrenade()
	{
        FireAmmunition();
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}
}


// do not switch NV and gasmask
simulated  function bool ToggleNightVision(bool bIsNightVision);
simulated  function bool ToggleGasMask(bool bIsEquip );
simulated  function ToggleMelee();
simulated function  ZoomFireMode();

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
    return super(Weapon).GetAdjustedAim(StartFireLoc);
}
// Projectile Fire
simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	local HDPawn  HDP;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.ArmsMesh[0] != none && !bDummyWeapon && Instigator.IsFirstPerson() )
		{
			HDP.ArmsMesh[0].GetSocketWorldLocationAndRotation( 'Weapon', RealStartLoc,,0);
		}
		else
		{
			RealStartLoc = GetPhysicalFireStartLoc();
		}
        RealStartLoc = GetPhysicalFireStartLoc();
		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		if(DummyWeaponDamage > 0.0)
		{
		    SpawnedProjectile.Damage = DummyWeaponDamage;
        }

		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

simulated function DummyWeaponFire( float interval )
{
    if ( bDummyWeapon )
    {
       AutoFireAmmunition();
       SetTimer( interval, true, 'AutoFireAmmunition' );
    }
}

simulated function AutoFireAmmunition()
{
   if( HasAmmo(0) )
   {
        FireAmmunition();
   }
   else
   {
        ServerStopFire(0);
   }
}

/*********************************************************************************************
 * Ammunition / Inventory
 *********************************************************************************************/

/**
 * Consumes some of the ammo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	AddAmmoCount( -ShotCost[FireModeNum], FireModeNum );
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	local HDDroppedPickup DP;
	local HDPickupObject OldDP;


	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
	    // if ammo max deny pick
        if ( AmmoBulletCount[0] >= default.AmmoBulletCount[0] && AmmoBulletCount[1] >= default.AmmoBulletCount[1] )
        {
         return true;
        }
        DP = HDDroppedPickup(Pickup);
        OldDP = HDPickupObject(Pickup);
		if (DP != None)
		{
			if ( DP.Instigator == Instigator )
			{
				// weapon was dropped by this player - disallow pickup
				return true;
			}
			// take the ammo that the dropped weapon has
			AddAmmoCount(HDWeapon(DP.Inventory).AmmoBulletCount[0], 0);
			AddAmmoCount(HDWeapon(DP.Inventory).AmmoBulletCount[1], 1);

			if ( OldDP != None && OldDP.bInfinit )
            {
                ;
                OldDP.PickedUpBy(Instigator);
            }
			else
			{
                DP.PickedUpBy(Instigator);
            }
			AnnouncePickup(Instigator);
		}
		return true;
	}

	return false;
}

// Play Fire Effect
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation );

simulated function bool IsPrimaryWeapon(){return False;}

