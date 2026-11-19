//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_Launcher extends HDSpecialWeapon
      abstract;

var transient   bool                    bFireHudFlag;
var editinline  export  HDTelescope     Telescope;


simulated  function bool ToggleNightVision( bool bIsNightVision );
simulated  function bool ToggleGasMask( bool bIsEquip );

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Telescope.Owner = Self;
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	Telescope.DrawWeaponCrosshair(HUD);
}

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	local TMSkeletalMeshComponent MeshComponent;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		MeshComponent = TMSkeletalMeshComponent(Mesh);
		if ( (MeshComponent != none && !bDummyWeapon) && Instigator != None && Instigator.IsFirstPerson() )
		{
			MeshComponent.GetSocketWorldLocationAndRotation( 'MuzzleFlashSocket', RealStartLoc,,0);
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

/**
* We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
*/

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[CurrentFireMode];
}


simulated function StartZoom(TMPlayerController PC)
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if (HDP==none)
		return;

//	if ( HDP.bSprintTag )
//		return;

    Super.StartZoom(PC);
    SetZoomedState(ZST_ZoomingIn);  // set zoom state in ChangeHUD
    SetTimer( ZoomTime-0.1f, false, 'ChangeHUD' );

}

// Goto Zoom
simulated function Gotozoom()
{
}

simulated function ChangeHUD()
{
	local TMPlayerController PC;
	PC = TMPlayerController(Instigator.Controller);
    if ( Telescope.ZoomFunction == EZF_HUD )
    {
	     bForceHidden = TRUE;
	     Telescope.SetDispalyCrosshair(TRUE);
     	 if ( PC != None )
	     {
	         SyncSetCurrentSceneFOV(PC.DefaultFOV - SceneFOVDiff);
		     PC.StartZoomNonlinear( CurrentSceneFOV, 0 );
	     }
	     SetZoomedState(ZST_Zoomed);
	}
}

simulated function LeaveZoom( optional bool bFastLeave )
{
    if ( Telescope.ZoomFunction == EZF_HUD )
    {
    	if (IsTimerActive('ChangeHUD'))
	    {
		    ClearTimer('ChangeHUD');
	    }
        bForceHidden = FALSE;
        bPendingShow = TRUE;
        Telescope.SetDispalyCrosshair(FALSE);
    }
    SceneFOVDiff = Default.SceneFOVDiff;
    Super.LeaveZoom(bFastLeave);
}


simulated function PreloadTextures(bool bForcePreload)
{
	Super.PreloadTextures(bForcePreload);
    Telescope.PreloadTextures(bForcePreload);
}

simulated state WeaponFiring
{
	ignores WeaponSprintOut, WeaponSprintIn;

	simulated function BeginState(Name PrevStateName)
	{
		local TMPlayerController PC;
		PC = TMPlayerController(Instigator.Controller);

        if ( ZoomState >= ZST_ZoomingIn )
        {
            bFireHUDFlag = TRUE;
            FireInternal();
            return;
        }
        else
        {
            StartZoom(PC);
        }
        SetTimer( 0.4, false, 'FireInternal');
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}

    simulated function FireInternal()
    {
        FireAmmunition();
        TimeWeaponFiring( CurrentFireMode );
        SetTimer( 1.0, false, 'FireEndZoom' );
    }
    simulated function FireEndZoom()
    {
		local TMPlayerController PC;
		PC = TMPlayerController(Instigator.Controller);

    	if ( !bFireHUDFlag ) // un zoom
		{
		    EndZoom(PC);
		}
		bFireHUDFlag = FALSE;
    }

    simulated event EndState( Name NextStateName )
	{
        ClearTimer('RefireCheckTimer');
        ClearTimer('FireInternal');
        ClearTimer('FireEndZoom');
		//TriFireCount = 0;
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}
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

simulated function UpdateCameraBreath( out rotator out_CamRot )
{
    if ( ZoomState == ZST_Zoomed )
    {
      out_CamRot.Pitch += Amplitude_Zoom.x * Sin(WorldInfo.TimeSeconds * Omiga_Zoom.x + Phi_Zoom.x) / 360.0 * 65535.0;
	  out_CamRot.Yaw += Amplitude_Zoom.y * Sin(WorldInfo.TimeSeconds * Omiga_Zoom.y + Phi_Zoom.y) / 360.0 * 65535.0;
    }
}

