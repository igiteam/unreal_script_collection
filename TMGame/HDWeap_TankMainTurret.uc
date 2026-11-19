/**
*
*/
class	HDWeap_TankMainTurret	extends HDWeap_TurretBase;

var ParticleSystem	TankFireWavePSCTemplate;
var TMParticleSystemComponent	TankFireWavePSC;
var ParticleSystem	TankMGMuzzlePSCTemplate;
var TMParticleSystemComponent	TankMGMuzzlePSC;
var name					TankFireWaveSocket;
var name					TankMGunSocket;
var float 					FRBlurScale;
var float 					ReduceFRBlurSpeed;
// do not reload
simulated function Reload()
{
	return;
}

simulated event vector GetMuzzleLoc()
{
	local vector RealStarLoc;
    local HDTurret_Base HDH;
    local SkeletalMeshComponent MeshComponent;
    HDH = HDTurret_Base(Instigator);
	MeshComponent = HDH.DerrickWheelsBody.GetMesh();
    if(HDH != None)
    {
		 MeshComponent.GetSocketWorldLocationAndRotation( 'TankMGunMuzzle', RealStarLoc,,0);
		 return RealStarLoc;
    }

	return Super.GetMuzzleLoc();
}

simulated event Tick( float DeltaTime )
{
	super.Tick(DeltaTime);
	ReduceFireRadialBlur(DeltaTime);
}

simulated function InstantFire()
{
	local vector StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int i, FinalImpactIndex;

    local HDPawn HDP;
    local HDTurret_Base HDH;
	//local float t;
	local SkeletalMeshComponent MeshComponent;
    //HDP = HDPawn(Instigator);

    //if (HDP == none)
    HDH = HDTurret_Base(Instigator);
    if(HDH != None)
       HDP = HDPawn(HDH.Driver);
    else
        return;

//    if(bOverload)
//	 	return;

	if (BulletCount > 0)
	{
//		t = (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
//		t = t ** 0.5;
//		angle = min_angle * (1 - t) + max_angle * t;
//		CrosshairScaling = max_scaling;
		//Clamp(CrosshairScaling, min_scaling, max_scaling);
		//bullet has no limit
		//BulletCount -= 1;

    	// define range to use for CalcWeaponFire()
    	StartTrace = InstantFireStartTrace();
    	EndTrace = InstantFireEndTrace(StartTrace);
    	bUsingAimingHelp = false;
    	// Perform shot
    	MeshComponent = HDH.DerrickWheelsBody.GetMesh();
    	if ( MeshComponent != none && !bDummyWeapon )
		{
			MeshComponent.GetSocketWorldLocationAndRotation( 'Muzzle', StartTrace,,0);
		}
		else
		{
			StartTrace = GetPhysicalFireStartLoc();
		}

    	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
		//you cant shoot yourself! I guess...
    	for(i = 0;i < ImpactList.Length;++i)
    	{
    	 if(ImpactList[i].HitActor == HDP)
    	 {
    	   ImpactList.Remove(i,1);
		 }
		}

		FinalImpactIndex = ImpactList.length - 1;
    	if (FinalImpactIndex >= 0 && (ImpactList[FinalImpactIndex].HitActor == None || !ImpactList[FinalImpactIndex].HitActor.bProjTarget))
    	{
    		// console aiming help
    		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
    		if ( NearImpact.HitActor != None )
    		{
    			bUsingAimingHelp = true;
    			ImpactList[FinalImpactIndex] = NearImpact;
    		}
    	}

    	for (i = 0; i < ImpactList.length; i++)
    	{
    		ProcessInstantHit(CurrentFireMode, ImpactList[i]);
    	}

    	if (Role == ROLE_Authority)
    	{
    		// Set flash location to trigger client side effects.
    		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
    		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
    		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
    		// would probably have to run a full simulation on remote clients.
    		if ( NearImpact.HitActor != None )
    		{
    			SetFlashLocation(NearImpact.HitLocation);
    			PlayOwnedFireEffects(CurrentFireMode,NearImpact.HitLocation);
    		}
    		else
    		{
    			SetFlashLocation(RealImpact.HitLocation);
    			PlayOwnedFireEffects(CurrentFireMode,RealImpact.HitLocation);
    		}
			if (HDP.CurrentWeaponAttachment != none)
			{
				for (i = 1; i < ImpactList.length; i++)
				{
					if (ImpactList[i].HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone) )
					{
						HDWeaponAttachment(HDP.CurrentWeaponAttachment).TPlayImpactEffects(ImpactList[i]);
					}
				}
			}
    	}


		shots_fired ++;
//		if (ZoomState == ZST_Zoomed)
//			KickBack(0.15f, 0.1f, 0.10f, 0.05f, 2.5f, 0.25f, 7);
//		else
        //KickBack(0.35f, 0.15f, 0.15f, 0.025f, 3.0f, 0.3f, 7);

        //overload
//        CurrOverload += OverloadPerBullet;
//        LastFireTime = WorldInfo.TimeSeconds;
//        if(CurrOverload >= TopOverload)
//        {
//	        bOverload = true;
//	        CurrOverload = TopOverload;
//		}
	}

    if (BulletCount == 0)
	{
		Reload();
	}
	return;
}

/**
* If we are locked on, we need to set the Seeking projectiles LockedTarget.
*/

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	local SkeletalMeshComponent MeshComponent;
    local HDTurret_Base TGT;

    TGT = HDTurret_Base(Instigator);
    if(TGT == None)
        return none;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();
	TankFireWavePSC.ActivateSystem();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		MeshComponent = TGT.DerrickWheelsBody.GetMesh();
		HDPlatform_BaseTankWheels(TGT.DerrickWheelsBody).FireRadialBlur.SetBlurScale(FRBlurScale);
		if ( MeshComponent != none && !bDummyWeapon )
		{
			MeshComponent.GetSocketWorldLocationAndRotation( 'Muzzle', RealStartLoc,,0);
		}
		else
		{
			RealStartLoc = GetPhysicalFireStartLoc();
		}

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		if(DummyWeaponDamage > 0.0)
		{
		    SpawnedProjectile.Damage = DummyWeaponDamage;
        }

		if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}

		//KickBack(2.0f, 1.85f, 0.8f, 0.5f, 8.0f, 5.0f, 3);
		HDPlatform_BaseTankWheels(TGT.DerrickWheelsBody).FireBodyShake();

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

function ReduceFireRadialBlur(float DeltaTime)
{
    local HDTurret_Base TGT;
    local RadialBlurComponent tempFireRadialBlur;
    TGT = HDTurret_Base(Instigator);
    tempFireRadialBlur = HDPlatform_BaseTankWheels(TGT.DerrickWheelsBody).FireRadialBlur;
    if(tempFireRadialBlur != none)
    {
    	if(tempFireRadialBlur.BlurScale > 0.f)
    	{
		    tempFireRadialBlur.SetBlurScale(tempFireRadialBlur.BlurScale - ReduceFRBlurSpeed * DeltaTime);
	    }
	    else
	    {
			tempFireRadialBlur.SetBlurScale(0.f);
		}
    }
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    local TGTurret TGT;
	local AnimNodeSequence WeapNode;
	local AnimTree Tree;
    TGT = TGTurret(Instigator);

	if (TGT.Mesh != None && TGT.Mesh.bAttached)
	{
	// do not play on a dedicated server
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( SkelMesh == None )
	{
		SkelMesh = TGT.Mesh;
	}

	if( SkelMesh == none)
	{
	  return;
	}
	// Check we have access to mesh and animations
//	if( SkelMesh == none || GetWeaponAnimNodeSeq() == none )
//	{
//		return;
//	}

	if(fDesiredDuration > 0.0)
	{
		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		SkelMesh.PlayAnim(Sequence, 0.0, bLoop);
	}
	else
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			WeapNode = AnimNodeSequence(SkelMesh.Animations);
		}

		WeapNode.SetAnim(Sequence);
		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
	}
}

/**
* We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
*/

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[CurrentFireMode];
}

simulated function AttachMuzzleFlash()
{
	local SkeletalMeshComponent SKMesh;
    local HDTurret_Base HDH;

    HDH = HDTurret_Base(Instigator);
	if(HDH != none)
	{
		bMuzzleFlashAttached = true;
		SKMesh = HDH.DerrickWheelsBody.GetMesh();
		if (  SKMesh != none )
		{
			if ( (MuzzleFlashPSCTemplate != none) || (MuzzleFlashAltPSCTemplate != none) )
			{
				MuzzleFlashPSC = new(Outer) class'TMParticleSystemComponent';
				MuzzleFlashPSC.bAutoActivate = false;
				//MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_Foreground);
				MuzzleFlashPSC.SetFOV(TMSkeletalMeshComponent(SKMesh).FOV);
				SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
			}
			if(TankFireWavePSCTemplate != none)
			{
				TankFireWavePSC = new(Outer) class'TMParticleSystemComponent';
				TankFireWavePSC.bAutoActivate = false;
				TankFireWavePSC.SetFOV(TMSkeletalMeshComponent(SKMesh).FOV);
				SKMesh.AttachComponentToSocket(TankFireWavePSC, TankFireWaveSocket);
				TankFireWavePSC.SetTemplate(TankFireWavePSCTemplate);
			}
			if(TankMGMuzzlePSCTemplate != none)
			{
				TankMGMuzzlePSC = new(Outer) class'TMParticleSystemComponent';
				TankMGMuzzlePSC.bAutoActivate = false;
				TankMGMuzzlePSC.SetFOV(TMSkeletalMeshComponent(SKMesh).FOV);
				SKMesh.AttachComponentToSocket(TankMGMuzzlePSC, TankMGunSocket);
				TankMGMuzzlePSC.SetTemplate(TankMGMuzzlePSCTemplate);
			}
		}
	}
	else
	{
	 super.AttachMuzzleFlash();
	}

}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated event CauseMuzzleFlash()
{
	local HDTurret_Base HDH;
	local ParticleSystem MuzzleTemplate;

	if ( WorldInfo.NetMode != NM_Client )
	{
		HDH = HDTurret_Base(Instigator);
		if ( HDH == None )
		{
			return;
		}
	}

	CauseMuzzleFlashLight();

	if (GetHand() != HAND_Hidden || (bShowAltMuzzlePSCWhenWeaponHidden && Instigator != None && Instigator.FiringMode == 1 && MuzzleFlashAltPSCTemplate != None))
	{
		if ( !bMuzzleFlashAttached )
		{
			AttachMuzzleFlash();
		}
		if (MuzzleFlashPSC != None)
		{
		if(Instigator.FiringMode == 0)
		{
			if (!bMuzzleFlashPSCLoops || (!MuzzleFlashPSC.bIsActive || MuzzleFlashPSC.bWasDeactivated))
			{
				if (MuzzleFlashPSCTemplate != None)
				{
					MuzzleTemplate = MuzzleFlashPSCTemplate;
				}
				if (MuzzleTemplate != MuzzleFlashPSC.Template)
				{
					MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
				}
				//SetMuzzleFlashParams(MuzzleFlashPSC);
				MuzzleFlashPSC.ActivateSystem();
			}
		}
		else if(Instigator.FiringMode == 1)
		{
   			if ((!TankMGMuzzlePSC.bIsActive || TankMGMuzzlePSC.bWasDeactivated))
			{
				//SetMuzzleFlashParams(MuzzleFlashPSC);
				TankMGMuzzlePSC.ActivateSystem();
			}
		}
		}

		// Set when to turn it off.
		SetTimer(MuzzleFlashDuration,false,'MuzzleFlashTimer');
	}

	if(HDH != none)
	{
      HDH.BulletShellsComponent.ActivateSystem();
	}
}

