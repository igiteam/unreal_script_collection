/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class HDPlatform_BaseTankWheels extends HDPlatform_DerrickWheels
	native(TG);

var RadialBlurComponent	FireRadialBlur;


var() array<DerrickWheel>	RollWheels;
var MaterialInstanceConstant 		LeftTrackMat;
var MaterialInstanceConstant 		RightTrackMat;
var float 					LeftTrack_TravelledDist;
var float 					RightTrack_TravelledDist;
var name					CannonbaseSkelControlName;
var name					CannonbodySkelControlName;
var name					ShellSkelControlName;
var SkelControlLookAt		CannonbaseControl;
var SkelControlLookAt		CannonbodyControl;
var SkelControlSingleBone	ShellControl;
var bool					bCannonRotating;

var	class<Projectile>		TankProjectiles;
var name					TankMuzzleName;
var name					TankCannonBaseSocketName;
var name                    TankForwardPosSocketName;
var Vector 					TankAimLocation;
var bool					bTankFire;
var float                   MinFireInterval;
var float                   MaxFireInterval;
var float                   CurrFireInterval;
var float                   LastFireTime;
var float 					ShellShakePitchTarget;
var float 					ShellShakeRollTarget;
var ParticleSystem			MuzzleFlashPSCTemplateThird;
var Actor                   CurrAimActor;
var SoundCue                CannonFireSound;
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function FireBodyShake();

function PostBeginPlay()
{
	local int Idx;
	//local Vector		RealStartLoc;
	super.PostBeginPlay();
	for (Idx=0; Idx<RollWheels.length; ++Idx)
	{
		RollWheels[Idx].WheelControl = SkelControlWheel(Mesh.FindSkelControl(RollWheels[Idx].SkelControlName));
		//RollWheels[Idx].FramesSinceLastTrace = Rand(WheelTraceInterval-1);
	}

	CannonbaseControl = SkelControlLookAt(Mesh.FindSkelControl(CannonbaseSkelControlName));
	CannonbodyControl = SkelControlLookAt(Mesh.FindSkelControl(CannonbodySkelControlName));
	ShellControl = SkelControlSingleBone(Mesh.FindSkelControl(ShellSkelControlName));
//	Mesh.GetSocketWorldLocationAndRotation( TankMuzzleName, RealStartLoc,,0);
//	CannonbaseControl.TargetLocation=RealStartLoc;
//	CannonbodyControl.TargetLocation=RealStartLoc;
	CannonbaseControl.SetSkelControlStrength(0.f,0.f);
	CannonbodyControl.SetSkelControlStrength(0.f,0.f);
}

simulated event Destoryed()
{
//    local rotator tmprot;
//    super.Destoryed();
//    tmprot = DestoryKActor.Rotation;
//    tmprot.Yaw = rotator(CannonbaseControl.TargetLocation - Location).Yaw;
//    DestoryKActor.SetRotation(tmprot);

      local vector tmploc;
      local rotator tmprot;
      local int i;
      if(DestroyPSC != none)
          DestroyPSC.SetActive(true);
      for(i = 0;i < DestroySmokePSC.Length;++i)
      {
         if(DestroySmokePSC[i] != none)
           DestroySmokePSC[i].SetActive(true);
      }
      DerrickBody.SetPhysics(PHYS_None);
      SetPhysics(PHYS_None);
      if(DestoryMesh != none)
      {
        HiddenWheelMesh(true);
        DestoryKActorBase = Spawn(class'KActorSpawnable',self,,Location,Rotation,,TRUE);
        if(DestoryKActorBase != none)
        {
           DestoryKActorBase.SetStaticMesh(DestoryMesh);
           DestoryKActorBase.Initialize();
           DestoryKActorBase.SetCollision(true,true);
        }
      }
//      DestoryKactor.Length = KActorDestoryMesh.Length;
    for(i = 0;i < DestoryActors.Length;++i)
    {
        if(DestoryActors[i].KActorDestoryMesh != none)
        {
          mesh.GetSocketWorldLocationAndRotation(DestoryActors[i].DestroyRootSocketName,tmploc,tmprot);
          tmprot = Rotation;
          if(CannonbaseControl.ControlStrength > 0.f)
              tmprot.Yaw = rotator(CannonbaseControl.TargetLocation - Location).Yaw;
          DestoryActors[i].DestoryKactor = Spawn(class'KActorSpawnable',self,,tmploc,tmprot,,TRUE);
          if(DestoryActors[i].DestoryKActor != none)
          {
            DestoryActors[i].DestoryKactor.SetStaticMesh(DestoryActors[i].KActorDestoryMesh);
            DestoryActors[i].DestoryKactor.Initialize();
            DestoryActors[i].DestoryKactor.SetCollision(true,true);
          }
        }
        if(DestoryActors[i].DestoryKActor != none)
        {
        DestoryActors[i].DestoryKActor.ApplyImpulse(DestoryActors[i].DestoryKActor.Location - Location, RandRange(1000.f,2000.f) * DestoryActors[i].MassScale, DestoryActors[i].DestoryKActor.Location);
        }
    }

    SetTimer(5.0f, false, 'DisablePhysics');
}

simulated function AttachToDerrick(HDPlatform_Derrick Derrick)
{
	super.AttachToDerrick(Derrick);
	mesh.AttachComponentToSocket(FireRadialBlur,TankMuzzleName);
}


native function SetAimTarget(Actor AimActor,bool bFireImmediately,float MinFireInt,float MaxFireInt);

event TankFire()
{
	local Vector		RealStartLoc,FireDir;
	local Projectile	SpawnedProjectile;
	local HDWeap_TankMainTurret	TankWeapon;
	if(DerrickBody.bDestroyed)
       return;
	Mesh.GetSocketWorldLocationAndRotation( TankMuzzleName, RealStartLoc,,0);
    TankWeapon = HDWeap_TankMainTurret(DerrickBody.TurretActor.MyWeapon);
    if ( !TankWeapon.bMuzzleFlashAttached )
	{
		TankWeapon.AttachMuzzleFlash();
	}

	// Spawn projectile
	SpawnedProjectile = Spawn(TankProjectiles,,, RealStartLoc);

	TankWeapon.TankFireWavePSC.ActivateSystem();
    if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
	{
		FireDir = Normal(TankAimLocation - RealStartLoc);
		SpawnedProjectile.Init(FireDir);
		TankWeapon.MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplateThird);
		TankWeapon.MuzzleFlashPSC.ActivateSystem();
	}
	PlaySound(CannonFireSound,true);
}

simulated event VehicleStart()
{
	Mesh.PlayAnim('TankStart', 0.0, false);
    PlaySound(StartEngineSound, true);
    //DerrickBody.PlayerEngineMainLoop.Play();
    DerrickBody.PlayerEngineMainLoop.FadeIn(1.5f,1.f);
}

simulated event VehicleBreak()
{
    Mesh.PlayAnim('TankBreak', 0.0, false);
    PlaySound(StopEngineSound, true);
    DerrickBody.PlayerEngineMainLoop.FadeOut(1.5f,0.0f);
}

simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
	if(SeqNode.AnimSeq.SequenceName == 'TankStart')
	{
        MoveState = state_Moving;
	}
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  if(DerrickBody != none)
  {
   if(DamageType != class'HDDmgType_Rocket'
      && DamageType != class'HDDmgType_PF89'
      && DamageType != class'HDDmgType_PF98'
      && DamageType != class'HDDmgType_Track'
      && DamageType != class'HDDmgType_Satellite'
      && DamageType != class'HDDmgType_CSAirAttack')
         return;
  	DerrickBody.BodyTakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
  }
}


