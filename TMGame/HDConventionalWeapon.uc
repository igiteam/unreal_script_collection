//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDConventionalWeapon extends HDWeapon
    abstract;

/*********************************************************************************************
 Muzzle Flash
********************************************************************************************* */

/** Holds the name of the socket to attach a muzzle flash too */
var array<name>					        MuzzleFlashSockets;

/** Muzzle flash PSC and Templates*/
var array<TMParticleSystemComponent>	MuzzleFlashPSCs;

/** Set this to true if you want the flash to loop (for a rapid fire weapon like a minigun) */
var array<byte>					        bMuzzleFlashPSCLoopss;

/** dynamic light */
var	TMExplosionLight		            MuzzleFlashLights;

/** dynamic light class */
var class<TMExplosionLight>             MuzzleFlashLightClasss;

/** How long the Muzzle Flash should be there */
var() array<float>					    MuzzleFlashDurations;

/** Whether muzzleflash has been initialized */
var array<byte>					        bMuzzleFlashAttacheds;

/**
 * Turns the MuzzleFlashlight off
 */
simulated event MuzzleFlashTimer()
{
	if (MuzzleFlashPSCs[0] != none
        && (bMuzzleFlashPSCLoopss[0] == 0) )
	{
		MuzzleFlashPSCs[0].DeactivateSystem();
	}
	if (MuzzleFlashPSCs[1] != none
        && (bMuzzleFlashPSCLoopss[1] == 0) )
	{
		MuzzleFlashPSCs[1].DeactivateSystem();
	}
}

/**
 * Causes the muzzle flashlight to turn on
 */
simulated event CauseMuzzleFlashLight()
{
	if ( WorldInfo.bDropDetail )
		return;

	if ( MuzzleFlashLights != None )
	{
		MuzzleFlashLights.ResetLight();
	}
	else if ( MuzzleFlashLightClasss != None )
	{
		MuzzleFlashLights = new(Outer) MuzzleFlashLightClasss;
		SkeletalMeshComponent(Mesh).AttachComponentToSocket(MuzzleFlashLights,MuzzleFlashSockets[CurrentFireModeType]);
	}
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated event CauseMuzzleFlash()
{
	local TMPawn P;

	if ( WorldInfo.NetMode != NM_Client )
	{
		P = TMPawn(Instigator);
		if ( (P == None) || !P.bUpdateEyeHeight )
		{
			return;
		}
	}

	CauseMuzzleFlashLight();

	if (GetHand() != HAND_Hidden )
	{
		if ( bMuzzleFlashAttacheds[CurrentFireModeType] == 0 )
		{
			AttachMuzzleFlashs( CurrentFireModeType );
		}
		if (MuzzleFlashPSCs[CurrentFireModeType] != None)
		{
			if ( bMuzzleFlashPSCLoopss[CurrentFireModeType]==0 || (!MuzzleFlashPSCs[CurrentFireModeType].bIsActive || MuzzleFlashPSCs[CurrentFireModeType].bWasDeactivated))
			{
				MuzzleFlashPSCs[CurrentFireModeType].ActivateSystem();
			}
		}

		// Set when to turn it off.
		SetTimer(MuzzleFlashDurations[CurrentFireModeType],false,'MuzzleFlashTimer');
	}
}

simulated event StopMuzzleFlash()
{
	ClearTimer('MuzzleFlashTimer');
	MuzzleFlashTimer();
	if (MuzzleFlashPSCs[0] != none )
	{
		MuzzleFlashPSCs[0].DeactivateSystem();
	}
	if (MuzzleFlashPSCs[1] != none  )
	{
		MuzzleFlashPSCs[1].DeactivateSystem();
	}
}

/**
 * Called on a client, this function Attaches the WeaponAttachment
 * to the Mesh.
 */
simulated function AttachMuzzleFlashs( int FireMode )
{
	local SkeletalMeshComponent SKMesh;
	// Attach the Muzzle Flash
	bMuzzleFlashAttacheds[FireMode] = 1;
	SKMesh = SkeletalMeshComponent(Mesh);
	if ( SKMesh != none && MuzzleFlashPSCs[FireMode] != None
        && !SKMesh.IsComponentAttached(MuzzleFlashPSCs[FireMode]) )
	{
        SKMesh.AttachComponentToSocket(MuzzleFlashPSCs[FireMode], MuzzleFlashSockets[FireMode]);
	}
}

/**
 * Remove/Detach the muzzle flash components
 */
simulated function DetachMuzzleFlash()
{
	local SkeletalMeshComponent SKMesh;

	bMuzzleFlashAttacheds[0] = 0;
	bMuzzleFlashAttacheds[1] = 0;

	SKMesh = SkeletalMeshComponent(Mesh);
	if (  SKMesh != none )
	{
		if (MuzzleFlashPSCs[0] != none)
			SKMesh.DetachComponent( MuzzleFlashPSCs[0] );
		if (MuzzleFlashPSCs[1] != none)
			SKMesh.DetachComponent( MuzzleFlashPSCs[1] );
	}
//	MuzzleFlashPSC = None;
}

// toggle zoom
simulated function ToggleZoomPostProcess()
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if ( HDP == None ) return;

    if ( ZoomState == ZST_NotZoomed )
	{
        HDP.ClientResetDOF();
	}
	else if ( ZoomState == ZST_Zoomed )
	{
		HDP.ClientCacheDefaultDOF();
		HDP.ClientSetDOFPostProcess( DOFSetting );
	}
}

simulated function bool IsPrimaryWeapon(){return True;}

