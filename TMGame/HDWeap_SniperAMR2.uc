//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_SniperAMR2 extends HDWeap_SniperRifle;

/**
* If we are locked on, we need to set the Seeking projectiles LockedTarget.
*/
simulated function RecoverRecoilFuncTwo( float DeltaTime )
{
	if ( bRecoilFlag )
	{
		punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, RecoilValue.X, DeltaTime,  RecoilTime );
		punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, RecoilValue.Y, DeltaTime,  RecoilTime );
        if ( Abs(VSize(punch_angle) - VSize(RecoilValue)) < 0.0001f )
			bRecoilFlag = false;
	}
	else if ( !bRecoilFlag )
	{
		if ( VSize(punch_angle) > 0.0001f )
		{
		    punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, 0, DeltaTime,  RecoilRecoverTime );
		    punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, 0, DeltaTime,  RecoilRecoverTime );
		}
	}
}

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	//local TMSkeletalMeshComponent MeshComponent;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();
    CalculateRecoil();
	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		/*MeshComponent = TMSkeletalMeshComponent(Mesh);
		if ( MeshComponent != none && !bDummyWeapon && ZoomState != ZST_Zoomed )
		{
			MeshComponent.GetSocketWorldLocationAndRotation( 'MuzzleFlashSocket', RealStartLoc,,0);
		}
		else
		{
			RealStartLoc = GetPhysicalFireStartLoc();
		}*/
        RealStartLoc = InstantFireStartTrace();
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

/**
* We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
*/

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[CurrentFireMode];
}

simulated state WeaponFiring
{
	simulated function ChangeZoomFireMode()
	{
		local TMPlayerController PC;
		PC = TMPlayerController(Instigator.Controller);
		if ( WorldInfo.NetMode != NM_DedicatedServer && bZoomMode[CurrentFireModeType]==1 )
		{
			if (PC != None && LocalPlayer(PC.Player) != none )
			{
				(GetZoomedState() != ZST_NotZoomed) ?  EndZoom(PC) : StartZoom(PC);
			}
		}
	}
}

