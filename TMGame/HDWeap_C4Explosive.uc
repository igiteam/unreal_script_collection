//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_C4Explosive extends HDSpecialWeapon;

var array<HDProj_C4Explosive>       Targets;

var name                            ArmThrowPackage;
var name                            WeaponThrowPackage;
var name                            ArmExplode;
var name                            WeaponExplode;

simulated function SetTargetsExplode()
{
    local int index;
    for ( index = 0; index < Targets.Length; ++index )
    {
        if ( Targets[index] != None && !Targets[index].bDeleteMe )
            Targets[index].Explode(Targets[index].GetExplodeLocation(), Targets[index].GetExplodeNormal() );
    }
    Targets.Length = 0;
}


simulated function DoExplodeTarget()
{
    if ( ArmExplode != '' && ArmsAnimSet != None )
        PlayArmAnimation( ArmExplode, 0.76 );
    if ( WeaponExplode != '' )
        PlayWeaponAnimation( WeaponExplode, 0.76 );
    SetTargetsExplode();
}
simulated function ZoomFireMode()
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		if( Role < Role_Authority )
		{
			// if we're a client, synchronize server
			ServerZoomFireMode();
		}

		// Start fire locally
        DoExplodeTarget();
	}
}

reliable server function ServerZoomFireMode()
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
       DoExplodeTarget();
	}
}


simulated event Destroyed()
{
    SetTargetsExplode();
    Super.Destroyed();
}

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	local HDProj_C4Explosive   Target;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		RealStartLoc = GetPhysicalFireStartLoc();

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);

		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}
		Target = HDProj_C4Explosive(SpawnedProjectile);
        Targets[Targets.Length] = Target;
		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	local HDDroppedPickup DP;
	local HDPickupObject OldDP;


	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
	    // if ammo max deny pick
        if ( ClipBulletCount[0] >= default.ClipBulletCount[0] )
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
            AddBulletCount(HDWeapon(DP.Inventory).ClipBulletCount[0], 0);
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

// do not switch NV and gasmask
simulated  function bool ToggleNightVision(bool bIsNightVision);
simulated  function bool ToggleGasMask(bool bIsEquip );
simulated  function ToggleMelee();

simulated state WeaponFiring
{
	simulated function BeginState(Name PrevStateName)
	{
        TimeWeaponFiring( CurrentFireMode );
        if ( ArmThrowPackage != '' && ArmsAnimSet != None )
            PlayArmAnimation( ArmThrowPackage, 0.0 );
        if ( WeaponThrowPackage != '' )
            PlayWeaponAnimation( WeaponThrowPackage, 0.0 );
        SetTimer(0.5, false,'ThrowPackage');
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}

	simulated function ThrowPackage()
	{
        FireAmmunition();
	}

	simulated function EndState(Name NextStateName)
	{
	   ClearTimer('ThrowPackage');
	   Super.EndState(NextStateName);
	}
}

/**
 * Draw the Crosshairs
 */
simulated function DrawWeaponCrosshair( Hud HUD );

