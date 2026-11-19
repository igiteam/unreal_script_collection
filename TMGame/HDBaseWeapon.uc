//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDBaseWeapon extends Weapon
	config(Game)
	native
	abstract
	notplaceable;


var float DummyWeaponDamage;

var int	  penetrate;

/**
 * This function handles playing sounds for weapons.  How it plays the sound depends on the following:
 *
 * If we are a listen server, then this sound is played and replicated as normal
 * If we are a remote client, but locally controlled (ie: we are on the client) we play the sound and don't replicate it
 * If we are a dedicated server, play the sound and replicate it to everyone BUT the owner (he will play it locally).
 *
 *
 * @param	SoundCue	- The Source Cue to play
 */
simulated function WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
	// if we are a listen server, just play the sound.  It will play locally
	// and be replicated to all other clients.
	if( Sound != None && Instigator != None && !Instigator.bHidden )
	{
		Instigator.PlaySound(Sound, false, true);
	}
}

/**
 * Informs if this weapon is active for the player
 *
 * @return	true if this an active weapon for the player
 */
simulated function bool IsActiveWeapon()
{
	return (Instigator != none && self == Instigator.Weapon);
}

// calculate weapon fire
simulated function ImpactInfo CalcWeaponFire(vector StartTrace, vector EndTrace, optional out array<ImpactInfo> ImpactList, optional vector Extent)
{
	local vector			HitLocation, HitNormal;
	local Actor				HitActor;
	local TraceHitInfo		HitInfo;
	local ImpactInfo		CurrentImpact;
	local PortalTeleporter	Portal;
	local HDDestroyMeshActor  DestroyableActor;
	local TMPhysicalMaterialProperty PhysicalProperty;

	foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, Extent, HitInfo, TRACEFLAG_Bullet)
	{
		// if we didn't hit anything, then set the HitLocation as being the EndTrace location
		if( HitActor == none )
		{
			HitLocation	= EndTrace;
		}
		else
		{
			// trigger
			if (PassThroughDamage(HitActor))
			{
				continue;
			}
			else
			{
				// if we hit a PortalTeleporter, recurse through
				Portal = PortalTeleporter(HitActor);
				if( Portal != None && Portal.SisterPortal != None )
				{
					continue;
				}

				//glasses if any
        		DestroyableActor = HDDestroyMeshActor(HitActor);
        		if(DestroyableActor != none && DestroyableActor.DamagePenetrate(HitInfo))
        		{
        		   continue;
                }

	           if (HitInfo.PhysMaterial != None)
	           {
		          PhysicalProperty = TMPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(class'TMPhysicalMaterialProperty'));
	               if (PhysicalProperty != None && PhysicalProperty.MaterialType == 'GlassMask')
	               {
	                   continue;
	               }
	           }
			}
		}

		// Convert Trace Information to ImpactInfo type.
		CurrentImpact.HitActor		= HitActor;
		CurrentImpact.HitLocation	= HitLocation;
		CurrentImpact.HitNormal		= HitNormal;
		CurrentImpact.RayDir		= Normal(EndTrace-StartTrace);
		CurrentImpact.StartTrace	= StartTrace;
		CurrentImpact.HitInfo		= HitInfo;
        //DrawDebugBox( HitLocation, vect(2,2,2), 255,0,0, true );
		// Add this hit to the ImpactList
		ImpactList[ImpactList.Length] = CurrentImpact;

		penetrate -= 1;
		if(penetrate == 0 || HitActor == none)
			break;
	}

	penetrate = default.penetrate;

	return (ImpactList.Length > 0) ? ImpactList[0] : CurrentImpact;
}

