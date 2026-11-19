//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDLauncherWeaponAttachment extends HDWeaponAttachment;

/*********************************************************************************************
 Trail Flash
********************************************************************************************* */

/** Holds the name of the socket to attach a muzzle flash too */
var name					TrailFlashSocket;

/** Muzzle flash PSC and Templates*/

var ParticleSystemComponent	TrailFlashPSC;
var ParticleSystem			TrailFlashPSCTemplate;
var bool					bTrailFlashPSCLoops;
/** How long the Muzzle Flash should be there */
var float					TrailFlashDuration;

simulated function AttachTo(TMPawn OwnerPawn)
{
    super.AttachTo(OwnerPawn);
    if (TrailFlashSocket != '')
	{
		if (TrailFlashPSCTemplate != None)
		{
			TrailFlashPSC = new(self) class'TMParticleSystemComponent';
			TrailFlashPSC.bAutoActivate = false;
			TrailFlashPSC.SetOwnerNoSee(true);
			Mesh.AttachComponentToSocket(TrailFlashPSC, TrailFlashSocket);
		}
	}
}

simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
    super.DetachFrom(MeshCpnt);
    // detach ClipBulletPSC
	if ( Mesh != None )
	{
		// muzzle flash effects
		if (TrailFlashPSC != None)
		{
			Mesh.DetachComponent(TrailFlashPSC);
		}
	}
}

/**
 * Turns the MuzzleFlashlight off
 */
simulated function TrailFlashTimer()
{
	if (TrailFlashPSC != none && (!bTrailFlashPSCLoops) )
	{
		TrailFlashPSC.DeactivateSystem();
	}
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated function CauseTrailFlash()
{
	local ParticleSystem TrailFlashTemplate;

	if (TrailFlashPSC != none)
	{
		if ( !bTrailFlashPSCLoops || !TrailFlashPSC.bIsActive)
		{
			TrailFlashTemplate = TrailFlashPSCTemplate;
			if (TrailFlashTemplate != TrailFlashPSC.Template)
			{
				TrailFlashPSC.SetTemplate(TrailFlashTemplate);
			}
			TrailFlashPSC.ActivateSystem();
		}
	}
	// Set when to turn it off.
	SetTimer(TrailFlashDuration,false,'TrailFlashTimer');

}

/**
 * Stops the muzzle flash
 */
simulated function StopTrailFlash()
{
	ClearTimer('TrailFlashTimer');
	TrailFlashTimer();

	if ( TrailFlashPSC != none )
	{
		TrailFlashPSC.DeactivateSystem();
	}
}

/**
 * Spawn all of the effects that will be seen in behindview/remote clients.  This
 * function is called from the pawn, and should only be called when on a remote client or
 * if the local client is in a 3rd person mode.
*/
simulated function ThirdPersonFireEffects(vector HitLocation)
{
	Super.ThirdPersonFireEffects(HitLocation);
	if ( EffectIsRelevant(Location,false,MaxFireEffectDistance) )
	{
		// Light it up
		CauseTrailFlash();
	}
}

simulated event StopThirdPersonFireEffects()
{
  super.StopThirdPersonFireEffects();
  // stop clip bullet effect
  StopTrailFlash();
}

