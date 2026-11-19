//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDDummyPawn extends HDPawn
native(HDGame);

/** pointer back to the Kismet action that created us */
var HDSeqAct_DummyWeaponFire FireAction;

simulated function InitHod();
simulated function TickHod();
simulated function PostBeginPlay()
{
	Super(Pawn).PostBeginPlay();

	TMInventoryManager(InvManager).bInfiniteAmmo = true;
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	// force update LastRenderTime so attachment doesn't cull effects due to its mesh being hidden
	LastRenderTime = WorldInfo.TimeSeconds;

	Super.WeaponFired(InWeapon, bViaReplication, HitLocation);

	FireAction.NotifyDummyFire();
}

simulated function SetPawnAmbientSound(SoundCue NewAmbientSound)
{
	if (!FireAction.bSuppressAudio)
	{
		Super.SetPawnAmbientSound(NewAmbientSound);
	}
}

simulated function SetWeaponAmbientSound(SoundCue NewAmbientSound)
{
	if (!FireAction.bSuppressAudio)
	{
		Super.SetWeaponAmbientSound(NewAmbientSound);
	}
}

simulated function rotator GetAdjustedAimFor(Weapon InWeapon, vector ProjStart)
{
	local rotator BaseRotation;
	local float AimErrorUnr;

	if (FireAction.TheTarget != None)
	{
		BaseRotation = rotator(FireAction.TheTarget.Location - ProjStart);
	}
	else
	{
		BaseRotation = (CurrentWeaponAttachment != none) ? CurrentWeaponAttachment.Rotation : Rotation;
	}

    if(FireAction.InaccuracyDegrees != 0)
    {
       	AimErrorUnr = FireAction.InaccuracyDegrees * 182.044;
    	BaseRotation.Pitch += AimErrorUnr * (0.5 - FRand());
    	BaseRotation.Yaw   += AimErrorUnr * (0.5 - FRand());
    }

	return BaseRotation;
}

simulated function WeaponAttachmentChanged()
{
	if ((CurrentWeaponAttachment == None || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass))
	{
		// Detach/Destroy the current attachment if we have one
		if (CurrentWeaponAttachment!=None)
		{
			CurrentWeaponAttachment.DetachFrom(Mesh);
			CurrentWeaponAttachment.Destroy();
		}

		// Create the new Attachment.
		if (CurrentWeaponAttachmentClass!=None)
		{
			CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass,self);
			CurrentWeaponAttachment.Instigator = self;
		}
		else
			CurrentWeaponAttachment = none;

		// If all is good, attach it to the Pawn's Mesh.
		if (CurrentWeaponAttachment != None)
		{
			CurrentWeaponAttachment.bSuppressSounds = FireAction.bSuppressAudio;
			CurrentWeaponAttachment.AttachTo(self);
			CurrentWeaponAttachment.SetDualWielding(bDualWielding);

           	// hide the weapon attachment mesh, but leave effects visible
            CurrentWeaponAttachment.SetHidden(false);

            //CurrentWeaponAttachment.Mesh.SetRotation(rot(0, -16384, 0)); // all are weapon attachments are sideways
            CurrentWeaponAttachment.AttachComponent(CurrentWeaponAttachment.Mesh);
            CurrentWeaponAttachment.Mesh.SetHidden(true);

			if(FireAction.bSuppressMuzzleFlash)
			{
			    CurrentWeaponAttachment.MuzzleFlashLightClass = none;
			    CurrentWeaponAttachment.MuzzleFlashPSCTemplate = none;
			    CurrentWeaponAttachment.MuzzleFlashAltPSCTemplate = none;
            }
		}
	}
}

simulated function vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return GetPawnViewLocation();
}

simulated function vector GetPawnViewLocation()
{
	//if (CurrentWeaponAttachment != None && CurrentWeaponAttachment.MuzzleFlashPSC != None)
//	{
//		return CurrentWeaponAttachment.MuzzleFlashPSC.GetPosition();
//	}

    if(CurrentWeaponAttachment != None)
    {
		return (CurrentWeaponAttachment.MuzzleFlashPSC != None) ? CurrentWeaponAttachment.MuzzleFlashPSC.GetPosition() : CurrentWeaponAttachment.Location;
    }
	else
	{
		return Super.GetPawnViewLocation();
	}
}

simulated function UpdateFireLocRot()
{
  	// move the weapon attachment to the right location each frame
	if(FireAction.TheOrigin != None && FireAction.TheTarget != None)
	{
        if(CurrentWeaponAttachment != None)
        {
      		CurrentWeaponAttachment.SetLocation(FireAction.TheOrigin.Location);
		    CurrentWeaponAttachment.SetRotation( rotator(FireAction.TheTarget.Location - FireAction.TheOrigin.Location) );
        }
        else //????weapon attachment
        {
      		SetLocation(FireAction.TheOrigin.Location);
		    SetRotation( rotator(FireAction.TheTarget.Location - FireAction.TheOrigin.Location) );
        }
		//DrawDebugLine(FireAction.TheOrigin.Location, FireAction.TheTarget.Location, 0, 255, 0);
	}
}

//[ WK ADD: rewrite tick function override HDPawn::Tick
simulated event Tick(float DeltaTime)
{
    Super(TMPawn).Tick(DeltaTime);
}

simulated function SetHandIKEnabled(bool bEnabled, optional float Time = 0.f );

// WK ADD]

