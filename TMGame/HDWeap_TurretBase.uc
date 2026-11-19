class HDWeap_TurretBase	extends HDWeapon
      native(HDGame);

var HDHUD                   WeapHDHUD;

var float	TopOverload;
var float   OverloadPerBullet;
var float   CurrOverload;
var float	CoolDownRate;
var bool  bOverload;
var TMParticleSystemComponent FirstMuzzleFlashPSC;
var TMParticleSystemComponent ThirdMuzzleFlashPSC;

simulated state PendingClientWeaponSet
{
	simulated function PendingWeaponSetTimer()
	{

	}
}

simulated event Tick( float DeltaTime )
{
   //UpdateHUD();
//   local HDTurret_Base HDT;
//   HDT = HDTurret_Base(Instigator);
//   if(HDT != none)
//   {
//       if(bOverload && FireLoopAC.IsPlaying())
//           StopLoopFireSound();
//   }
   UpdateCoolDownMat();
   super.Tick(DeltaTime);
}

native function UpdateCoolDownMat();
//function UpdateHUD();
//function CloseHUD();
// weapon calc camera
simulated function WeaponCalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot)
{
	local HDTurret_Base HDT;

	HDT = HDTurret_Base(Instigator);

	if ( HDT == none )
		return;

	out_CamRot.Pitch += (punch_angle.X) / 360.0 * 65535.0;
	out_CamRot.Yaw += (punch_angle.Y) / 360.0 * 65535.0;

	UpdatePunch(fDeltaTime);
}

//simulated function FireAmmunition()
//{
//    local HDTurret_Base HDH;
//	local TGPawn	TGP;
//	super.FireAmmunition();
//	HDH = HDTurret_Base(Instigator);
//	if(HDH != none)
//	{
//        TGP = TGPawn(HDH.Driver);
//        if(TGP != none)
//            TriFireCount = 0;
//    }
//}

simulated function HandleFinishedFiring()
{
//    local HDTurret_Base HDH;
//	local TGPawn	TGP;
//	HDH = HDTurret_Base(Instigator);
//	if(HDH != none)
//	{
//        TGP = TGPawn(HDH.Driver);
//        if(TGP != none)
//            TriFireCount = 0;
//    }
    super.HandleFinishedFiring();
}

simulated event vector GetMuzzleLoc()
{
	local vector RealStarLoc;
    local HDTurret_Base HDH;
    HDH = HDTurret_Base(Instigator);

    if(HDH != None)
    {
		 HDH.Mesh.GetSocketWorldLocationAndRotation( 'Muzzle', RealStarLoc,,0);
		 return RealStarLoc;
    }

	return Super.GetMuzzleLoc();
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated event CauseMuzzleFlash()
{
	local HDTurret_Base HDH;
	local SkeletalMeshComponent SKMesh;
//	local ParticleSystem MuzzleTemplate;
	local HDPawn	HDP;
	local TGPawn	TGP;
	local vector    Loc;
	local rotator   Rot;

//	if ( WorldInfo.NetMode != NM_Client )
//	{
	HDH = HDTurret_Base(Instigator);
	if ( HDH == None )
	{
		return;
	}
//	}

    HDP = HDPawn(HDH.Driver);
    TGP = TGPawn(HDH.Driver);

	CauseMuzzleFlashLight();

	if (GetHand() != HAND_Hidden || (bShowAltMuzzlePSCWhenWeaponHidden && Instigator != None && Instigator.FiringMode == 1 && MuzzleFlashAltPSCTemplate != None))
	{
		if ( !bMuzzleFlashAttached )
		{
			AttachMuzzleFlash();
		}
		if (FirstMuzzleFlashPSC != none
           || ThirdMuzzleFlashPSC != none)
		{
			if (!bMuzzleFlashPSCLoops
               || (!FirstMuzzleFlashPSC.bIsActive || FirstMuzzleFlashPSC.bWasDeactivated)
               || (!ThirdMuzzleFlashPSC.bIsActive || ThirdMuzzleFlashPSC.bWasDeactivated))
			{
//				if (Instigator != None && Instigator.FiringMode == 1 && MuzzleFlashAltPSCTemplate != None)
//				{
//					MuzzleTemplate = MuzzleFlashAltPSCTemplate;
//
//					// Option to not hide alt muzzle
//					MuzzleFlashPSC.SetIgnoreOwnerHidden(bShowAltMuzzlePSCWhenWeaponHidden);
//				}
//				else
                SKMesh = HDH.Mesh;
                SKMesh.GetSocketWorldLocationAndRotation( MuzzleFlashSocket, Loc, Rot );
				if(HDP != none)
				{
					if (FirstMuzzleFlashPSC != None)
					{
                        FirstMuzzleFlashPSC.SetAbsolute(true, true, true);
				        FirstMuzzleFlashPSC.SetTranslation( Loc );
				        FirstMuzzleFlashPSC.SetRotation( Rot );
					   	FirstMuzzleFlashPSC.ActivateSystem(true);
					}
				}
				else if(TGP != none)
				{
					if (ThirdMuzzleFlashPSC != None)
					{
                        ThirdMuzzleFlashPSC.SetAbsolute(true, true, true);
				        ThirdMuzzleFlashPSC.SetTranslation( Loc );
				        ThirdMuzzleFlashPSC.SetRotation( Rot );
						ThirdMuzzleFlashPSC.ActivateSystem(true);
					}
				}

//				if (MuzzleTemplate != MuzzleFlashPSC.Template)
//				{
//					MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
//				}
				//SetMuzzleFlashParams(MuzzleFlashPSC);

			}
		}

		// Set when to turn it off.
		//SetTimer(MuzzleFlashDuration,false,'MuzzleFlashTimer');
	}

	if(HDH != none)
	{
      HDH.BulletShellsComponent.ActivateSystem();
	}
}

/**
 * Causes the muzzle flashlight to turn on
 */
simulated event CauseMuzzleFlashLight()
{
    local HDTurret_Base HDH;
    HDH = HDTurret_Base(Instigator);
   	if ( WorldInfo.NetMode != NM_Client )
	{
		if ( HDH == None )
		{
			return;
		}
	}

//	if ( WorldInfo.bDropDetail )
//		return;

	if ( MuzzleFlashLight != None )
	{
		MuzzleFlashLight.ResetLight();
	}
	else if ( MuzzleFlashLightClass != None )
	{
		MuzzleFlashLight = new(Outer) MuzzleFlashLightClass;
		HDH.Mesh.AttachComponentToSocket(MuzzleFlashLight,HDH.MuzzleSocketName);
	}
}

simulated function AttachMuzzleFlash()
{
	local SkeletalMeshComponent SKMesh;
    local HDTurret_Base HDH;

    HDH = HDTurret_Base(Instigator);
	if(HDH != none)
	{
		bMuzzleFlashAttached = true;
		SKMesh = HDH.Mesh;
		if (  SKMesh != none )
		{
			if ( (FirstMuzzleFlashPSC != none)
			|| (ThirdMuzzleFlashPSC != none))
			{
				//MuzzleFlashPSC = new(Outer) class'TMParticleSystemComponent';
				//MuzzleFlashPSC.bAutoActivate = false;
				//MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_Foreground);
				//MuzzleFlashPSC.SetFOV(TMSkeletalMeshComponent(SKMesh).FOV);
				SKMesh.AttachComponentToSocket(FirstMuzzleFlashPSC, MuzzleFlashSocket);
				SKMesh.AttachComponentToSocket(ThirdMuzzleFlashPSC, MuzzleFlashSocket);
			}
		    if(HDH.BulletShellsComponent != none)
		    {
//                HDH.BulletShellsComponent = new(Outer) class'TMParticleSystemComponent';
//		     	HDH.BulletShellsComponent.SetTemplate(HDH.BulletShells);
//		     	HDH.BulletShellsComponent.bAutoActivate = false;
                SKMesh.AttachComponentToSocket(HDH.BulletShellsComponent,HDH.BulletShellsSocketName);
			}
		}
	}
	else
	{
	 super.AttachMuzzleFlash();
	}

}

simulated function  SetBackAttachmentClass()
{
    local HDPawn   HDP;
	local TGPawn TGP;
	local Turret T;
    local int      Index;

    // if next weapon is grenade, do not attach current weapon to back or leg slot
    if ( HDWeap_Grenade(InvManager.PendingWeapon) != None )
        return;

    HDP = HDPawn(Instigator);
    // Spawn the 3rd Person Attachment
	if (Role == ROLE_Authority && HDP != None && BackAttachType != EATTACH_NONE )
	{
		index = HDP.SetBackAttachmentWeapon( AttachmentClass, BackAttachType );
		if ( index != -1 && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled())))
		{
			HDP.WeaponBackAttachmentChanged(index);
		}
	}

	T = Turret(Instigator);
	TGP = TGPawn(T.Driver);
	if (TGP != none)
	{
		TGP.WeaponBackAttachmentChanged(AttachmentClass);
	}
}

simulated function EndFire(Byte FireModeNum)
{
	ClearPendingFire(FireModeNum);
    if( ReFireFlag[CurrentFireMode] == EFST_MORE && TriFireCount == 1)
    {
        HDWeaponFirePlaySound (WeaponFireSnd[CurrentFireMode], FireSoundCue);
    }
    StopLoopFireSound();
    TriFireCount = 0;
}

simulated reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{

}

