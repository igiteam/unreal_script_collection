//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeaponAttachment extends TMWeaponAttachment;

var name                         RecoilAddAnims[2];
var name                         RecoilZoomAddAnims[2];

// 3rd custom animation
var array<AnimSet>              CustomAnimSets;
var vector                      LeftHandIKEffector, LeftHandIKJoint;
var rotator                     LeftHandRot;
var vector                      RightHandIKEffector, RightHandIKJoint;
var rotator                     RightHandRot;
var rotator                     WeaponRot;
var vector                      ZoomTranslation, UnZoomTranslation;
var rotator                     ZoomRotation, UnZoomRotation;
var bool                        bStopHumanIK;
var vector                      HighProneWeaponOffset;
var rotator                     HighProneWeaponRotOffset;
var rotator                     NeckZoomAimRot;

/** Looping SoundCue for firing. */
var() AudioComponent FireLoopAC;

/*********************************************************************************************
 Muzzle Flash
********************************************************************************************* */

/** Holds the name of the socket to attach a muzzle flash too */
var name					ClipBulletSocket;

/** Muzzle flash PSC and Templates*/

var ParticleSystemComponent	ClipBulletPSC;
var ParticleSystem			ClipBulletPSCTemplate;
var bool					bClipBulletPSCLoops;
/** How long the Muzzle Flash should be there */
var float					ClipBulletDuration;

var SoundCue                ThirdPersonReloadSound;


// Weapon Attachment type for mpgame matching
enum    EWeaponAttachType
{
    EAttachPrimaryOne,
    EAttachPrimaryTwo,
    EAttachSpecial,
    EAttachNone,
};

var const EWeaponAttachType           AttachType;


// weapon attachment offset
var vector                            WeaponAttachOffset;

/** returns the impact sound that should be used for hits on the given physical material */
simulated function MaterialImpactEffect GetImpactEffect(PhysicalMaterial HitMaterial)
{
	local int i;
	local TMPhysicalMaterialProperty PhysicalProperty;
	if (HitMaterial != None)
	{
		PhysicalProperty = TMPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(class'TMPhysicalMaterialProperty'));
	}

	if (PhysicalProperty != None && PhysicalProperty.MaterialType != 'None')
	{
		i = ImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);
		if (i != -1)
		{
			return ImpactEffects[i];
		}
	}
	return DefaultImpactEffect;
}

simulated function TPlayImpactEffects(ImpactInfo impact_info)
{
	local vector HitLocation, HitNormal, FireDir;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local MaterialImpactEffect ImpactEffect;
	local MaterialInterface MI;
	local MaterialInstanceTimeVarying MITV_Decal;
	local int DecalMaterialsLength;
	local Vehicle V;
	local TGPawn P;
	local rotator R;

	HitActor = impact_info.HitActor;
	HitLocation = impact_info.HitLocation;
	HitNormal = impact_info.HitNormal;
	FireDir = impact_info.RayDir;
	HitInfo = impact_info.HitInfo;

	P = TGPawn(Owner);
	if ( (P != None) && EffectIsRelevant(HitLocation, false, MaxImpactEffectDistance) )
	{
		if ( TMWaterVolume(HitActor) != None )
		{
			//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'Envy_Effects.Particles.P_WP_Water_Splash_Small', HitLocation, rotator(vect(0,0,1)));
			return;
		}

		if (Pawn(HitActor) != none)
		{
			CheckHitInfo(HitInfo, Pawn(HitActor).Mesh, -HitNormal, HitLocation);
		}
		SetImpactedActor(HitActor, HitLocation, HitNormal/*, HitInfo*/);
		// figure out the impact sound to use
		ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
		V = Vehicle(HitActor);
		if (ImpactEffect.Sound != None && !bSuppressSounds)
		{
			// if hit a vehicle controlled by the local player, always play it full volume
			if (V != None && V.IsLocallyControlled() && V.IsHumanControlled())
			{
				PlayerController(V.Controller).ClientPlaySound(ImpactEffect.Sound);
			}
			else
			{
				if ( BulletWhip != None )
				{
					CheckBulletWhip(FireDir, HitLocation);
				}
				PlaySound(ImpactEffect.Sound, true,,, HitLocation);
			}
		}
		if ( TMVehicle(V) != none && Role < ROLE_Authority && !WorldInfo.GRI.OnSameTeam(Owner,V) )
		{
			TMVehicle(V).ApplyMorphDamage(HitLocation, WeaponClass.Default.InstantHitDamage[TMPawn(Owner).FiringMode], WeaponClass.Default.InstantHitMomentum[TMPawn(Owner).FiringMode]*FireDir);
		}

		// Pawns handle their own hit effects
		if ( HitActor != None &&
			 (Pawn(HitActor) == None || Vehicle(HitActor) != None) &&
			 AllowImpactEffects(HitActor, HitLocation, HitNormal) )
		{
			// this code is mostly duplicated in:  TMGib, TMProjectile, TMVehicle, TMWeaponAttachment be aware when updating
			if ( !WorldInfo.bDropDetail
				&& (Pawn(HitActor) == None)
				&& (VSizeSQ(Owner.Location - HitLocation) < MaxDecalRangeSq)
				&& (((WorldInfo.GetDetailMode() != DM_Low) && !class'Engine'.static.IsSplitScreen()) || (P.IsLocallyControlled() && P.IsHumanControlled())) )
			{
				// if we have a decal to spawn on impact
				DecalMaterialsLength = ImpactEffect.DecalMaterials.length;
				if( DecalMaterialsLength > 0 )
				{
					MI = ImpactEffect.DecalMaterials[Rand(DecalMaterialsLength)];
					if( MI != None )
					{
						if( MaterialInstanceTimeVarying(MI) != none )
						{
							// hack, since they don't show up on terrain anyway
							if ( Terrain(HitActor) == None )
							{
							MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
							MITV_Decal.SetParent( MI );

							WorldInfo.MyDecalManager.SpawnDecal( MITV_Decal, HitLocation, rotator(-HitNormal), ImpactEffect.DecalWidth,
								ImpactEffect.DecalHeight, 10.0, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex );
							//here we need to see if we are an MITV and then set the burn out times to occur
							MITV_Decal.SetScalarStartTime( ImpactEffect.DecalDissolveParamName, ImpactEffect.DurationOfDecal );
						}
						}
						else
						{
							WorldInfo.MyDecalManager.SpawnDecal( MI, HitLocation, rotator(-HitNormal), ImpactEffect.DecalWidth,
								ImpactEffect.DecalHeight, 10.0, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex );
						}
					}
				}
			}

			if (ImpactEffect.ParticleTemplate != None)
			{
				if (!bAlignToSurfaceNormal)
				{
					HitNormal = normal(FireDir - ( 2 *  HitNormal * (FireDir dot HitNormal) ) ) ;
				}


				R.Pitch = -32768/2;
				WorldInfo.MyEmitterPool.SpawnEmitter(ImpactEffect.ParticleTemplate, HitLocation, R+rotator(HitNormal), HitActor);
			}
		}
	}
	else if ( BulletWhip != None )
	{
		CheckBulletWhip(FireDir, HitLocation);
	}
}

/**
 * Spawn all of the effects that will be seen in behindview/remote clients.  This
 * function is called from the pawn, and should only be called when on a remote client or
 * if the local client is in a 3rd person mode.
*/
simulated function ThirdPersonFireEffects(vector HitLocation)
{
	local HDPawn P;
	P = HDPawn(Instigator);

    ++FireCount;

    if( class<HDWeapon>(WeaponClass).default.ReFireFlag[WeaponClass.default.CurrentFireMode] == EFST_ONE )
    {
      // play spatialized, no replication
	  HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireSoundCue);
    }
    else
    {
        if( (class<HDWeapon>(WeaponClass).default.ReFireFlag[WeaponClass.default.CurrentFireMode] == EFST_TRI)
        && (FireCount == 1) )
        {
            HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireLoopSoundCue);
        }
        else
        {
            if (FireLoopAC == None && FireCount >= 2)
            {
                FireLoopAC = HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireLoopSoundCue, FireLoopAC);
            }
            else if (FireLoopAC != None && (FireCount >= 2) && (!FireLoopAC.IsPlaying()))
            {
                FireLoopAC.Play();
            }

            if(FireLoopAC != none)
            {
                FireLoopAC.Location = p.Location;
            }
        }
    }

	// Have pawn play firing anim
	if (P != None && P.FireNode != None)
	{
		// Use recoil node to move arms when we fire
		P.FireNode.bPlayRecoil = true;
	}
	Super.ThirdPersonFireEffects(HitLocation);
	if ( EffectIsRelevant(Location,false,MaxFireEffectDistance) )
	{
		// Light it up
		CauseClipBullet();
	}
}

simulated event StopThirdPersonFireEffects()
{
    if( (FireCount == 1) &&
    class<HDWeapon>(WeaponClass).default.ReFireFlag[WeaponClass.default.CurrentFireMode] == EFST_MORE)
    {
        // play spatialized, no replication
	   HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireSoundCue);
    }
    else
    {
        if(class<HDWeapon>(WeaponClass).default.ReFireFlag[WeaponClass.default.CurrentFireMode] == EFST_TRI
        && FireCount == 3)
        {
            HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireLoopEndSoundCue);
        }
        else
        {
            if(FireCount >= 2) // Weapon Refired
            {
                if ( (FireLoopAC != None) && FireLoopAC.IsPlaying() )
                {
                    //FireLoopAC.FadeOut(0.1, 0);
                    FireLoopAC.Stop();
                    HDWeaponPlaySound(class<HDWeapon>(WeaponClass).default.FireLoopEndSoundCue);
                }
            }
        }
    }

  super.StopThirdPersonFireEffects();
  // stop clip bullet effect
  StopClipBullet();
}


simulated function PlayThridPersonReloadSound()
{
    HDWeaponPlaySound(ThirdPersonReloadSound);
}
simulated function AudioComponent HDWeaponPlaySound(SoundCue Sound, optional AudioComponent AC)
{
    local HDPawn p;

    P = HDPawn(Instigator);

    AC = none;
    if(Sound == none)
    {
        AC = none;
        return AC;
    }
	// play LocalSound non-spatialized
	if ( AC == None)
	{
		AC = p.CreateAudioComponent(Sound, FALSE, TRUE);
	}
	if (AC != None)
	{
		AC.bUseOwnerLocation = TRUE;
		AC.bAllowSpatialization = TRUE;
		AC.Location = p.Location;
		AC.Play();

		return AC;
	}

	return AC;
}

simulated function SetPuttingDownWeapon(bool bNowPuttingDown)
{
  if(FireLoopAC != none)
  {
       if(FireLoopAC.IsPlaying())
       {
         FireLoopAC.Stop();
       }
  }
}

simulated function AttachTo(TMPawn OwnerPawn)
{
    if(FireLoopAC != none)
    {
        if(FireLoopAC.IsPlaying())
        {
            FireLoopAC.Stop();
        }

        FireLoopAC = none;
    }

    super.AttachTo(OwnerPawn);
    if (ClipBulletSocket != '')
	{
		if (ClipBulletPSC != None && !Mesh.IsComponentAttached(ClipBulletPSC) )
		{
//			ClipBulletPSC = new(self) class'TMParticleSystemComponent';
//			ClipBulletPSC.bAutoActivate = false;
			ClipBulletPSC.SetOwnerNoSee(true);
			Mesh.AttachComponentToSocket(ClipBulletPSC, ClipBulletSocket);
		}
	}
}

simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
    if(FireLoopAC != none)
    {
        if(FireLoopAC.IsPlaying())
        {
            FireLoopAC.Stop();
        }
        FireLoopAC = none;
    }

    super.DetachFrom(MeshCpnt);
    // detach ClipBulletPSC
	if ( Mesh != None )
	{
		// muzzle flash effects
		if (ClipBulletPSC != None)
		{
			Mesh.DetachComponent(ClipBulletPSC);
		}
	}
}

simulated function Destroyed ()
{
    if(FireLoopAC != none)
    {
       if(FireLoopAC.IsPlaying())
       {
            FireLoopAC.Stop();
       }

       FireLoopAC = none;
    }

    super.Destroyed();
}

// [ADD WK
// Play FirstPerson Fire Effect locally
simulated function  PlayFPFireEffect( Weapon PawnWeapon )
{
    local HDPawn P;
    local HDWeapon W;
    local name   AnimName;

	// Have pawn play firing anim
	P = HDPawn(Instigator);
	W = HDWeapon(PawnWeapon);
	if ( W == None || P == None || !P.IsLocallyControlled() ) return;
	AnimName = (W.ZoomState != ZST_Zoomed) ? RecoilAddAnims[W.CurrentFireModeType] : RecoilZoomAddAnims[W.CurrentFireModeType];

	if ( AnimName != '' )
	{
 	    P.AddNode.SetAnim(AnimName);
	    P.AddNode.PlayAnim(False,1.f);
        P.AdditiveBlendingNode.SetBlendTarget( 1.0f, 0.0f );
    }
}

// WK]
/**
 * The Weapon attachment, though hidden, is also responsible for controlling
 * the first person effects for a weapon.
 */

simulated function FirstPersonFireEffects(Weapon PawnWeapon, vector HitLocation)	// Should be subclassed
{
//    local HDPawn P;
//    local HDWeapon W;
//    local name   AnimName;
//
//	// Have pawn play firing anim
//	P = HDPawn(Instigator);
//	W = HDWeapon(PawnWeapon);
//	if ( W == None || P == None ) return;
//	AnimName = (W.ZoomState != ZST_Zoomed) ? RecoilAddAnims[W.CurrentFireModeType] : RecoilZoomAddAnims[W.CurrentFireModeType];
//
//	if ( AnimName != '' )
//	{
// 	    P.AddNode.SetAnim(AnimName);
//	    P.AddNode.PlayAnim(False,1.f);
//        P.AdditiveBlendingNode.SetBlendTarget( 1.0f, 0.0f );
//    }
    Super.FirstPersonFireEffects( PawnWeapon, HitLocation );
}


/**
 * Called on a client, this function Attaches the WeaponAttachment
 * to the Mesh.
 */
simulated function AttachToBack(TMPawn OwnerPawn, name SocketName )
{
//	local SkeletalMeshSocket   Socket;
    if (OwnerPawn.Mesh != None)
	{
		// Attach Weapon mesh to player skelmesh
		if ( Mesh != None )
		{
			// Weapon Mesh Shadow
			Mesh.SetShadowParent(OwnerPawn.Mesh);
			Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
//			Socket = OwnerPawn.Mesh.GetSocketByName(SocketName);
//			Socket.RelativeLocation += WeaponAttachOffset;
			OwnerPawn.Mesh.AttachComponentToSocket(Mesh, SocketName);
		}
	}
	GotoState('CurrentlyBackAttached');
}

/**
 * Detach weapon from skeletal mesh
 */
simulated function DetachFromBack( SkeletalMeshComponent MeshCpnt, name SocketName )
{
	//local SkeletalMeshSocket   Socket;
    SetSkin(None);

	// Weapon Mesh Shadow
	if ( Mesh != None )
	{
		Mesh.SetShadowParent(None);
		Mesh.SetLightEnvironment(None);
	}
	if ( MeshCpnt != None )
	{
		// detach weapon mesh from player skelmesh
		if ( Mesh != None )
		{
//			Socket = MeshCpnt.GetSocketByName(SocketName);
//			Socket.RelativeLocation -= WeaponAttachOffset;
            MeshCpnt.DetachComponent( mesh );
		}
	}

	GotoState('');
}

/**
 * Turns the MuzzleFlashlight off
 */
simulated function ClipBulletTimer()
{
	if (ClipBulletPSC != none && (!bClipBulletPSCLoops) )
	{
		ClipBulletPSC.DeactivateSystem();
	}
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated function CauseClipBullet()
{
	//local ParticleSystem ClipBulletTemplate;

	if (ClipBulletPSC != none)
	{
		if ( !bClipBulletPSCLoops || !ClipBulletPSC.bIsActive)
		{
//			ClipBulletTemplate = ClipBulletPSCTemplate;
//			if (ClipBulletTemplate != ClipBulletPSC.Template)
//			{
//				ClipBulletPSC.SetTemplate(ClipBulletTemplate);
//			}
			ClipBulletPSC.ActivateSystem();
		}
	}
	// Set when to turn it off.
	SetTimer(ClipBulletDuration,false,'ClipBulletTimer');

}

/**
 * Stops the muzzle flash
 */
simulated function StopClipBullet()
{
	ClearTimer('ClipBulletTimer');
	ClipBulletTimer();

	if ( ClipBulletPSC != none )
	{
		ClipBulletPSC.DeactivateSystem();
	}
}

state CurrentlyBackAttached
{
}

