/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class HDPlatform_DerrickWheels extends Actor
	native(TG);

/** The pawn's light environment */
//var DynamicLightEnvironmentComponent LightEnvironment;

var() protected const SkeletalMeshComponent Mesh;
var() protected KActorSpawnable DestoryKActorBase;
var() protected StaticMesh DestoryMesh;
var TMParticleSystemComponent  DestroyPSC;
var array<TMParticleSystemComponent> DestroySmokePSC;
var() const ParticleSystem			DestroySmokeParticle;
var() const ParticleSystem			DestroyFireParticle;
var() const ParticleSystem			DestroyParticle;
var array<name>			            DestroySmokeSocketName;
var protected const name            DestroyPSCSocketName;
var transient HDPlatform_Derrick	DerrickBody;

var() transient SkelControlSingleBone BodyCtrl;
var() protected const name                      BodyCtrlName;
var() protected transient SkelControlLookAt SteeringLookatControl;
var() protected const Name					SteeringLookatControlName;

var() protected const Name					SteeringPivotBoneName;
var protected transient vector				LastSteeringPivotLoc;
var protected const name                    TurretSocketName;
var protected const name                    R_Wheel_DustSocketName;
var protected const name                    L_Wheel_DustSocketName;
var protected const name					OnTurretNpcSocketName;
var protected const name					OnCarNpcSocketName1;
var protected const name					OnCarNpcSocketName2;

var rotator					BodyDispPerFrameAdjust;
var int 					FramesSinceLastTrace;
var int						BodyTraceInterval;
var float 					VehBodyDisPFrameAdjust;

/** Last steering rotation, in this actor's local space. */
var protected transient rotator				LastLocalSteerRot;

/** Controls how fast the steering wheels rotate */
var() protected const float					SteerInterpSpeed;
var() bool                                  SimpleWheelSim;
//
// Audio!
//

// Audio for player derrick
// main engine loop is nonspatialized stereo loop controlled on the derrick interpactor
//var transient AudioComponent	EngineAudio_Player_Left;
//var protected const SoundCue	EngineAudio_Player_LeftCue;
//var transient AudioComponent	EngineAudio_Player_Right;
//var protected const SoundCue	EngineAudio_Player_RightCue;
//
//// suspension audio
//var protected AudioComponent	SuspensionAudio_Player_FrontRight;
//var protected const SoundCue	SuspensionAudio_Player_FrontRightCue;
//var protected AudioComponent	SuspensionAudio_Player_FrontLeft;
//var protected const SoundCue	SuspensionAudio_Player_FrontLeftCue;
//
//var() protected const vector2d	SuspensionAudioRandomTimeRange;
//var() protected const float		SuspensionAudioVelocityThreshold;
//
//
//// Audio for non-player derricks
///** Just one big composite cue attached to the derrick's center. */
//var transient AudioComponent	DerrickAudio_NonPlayer;
//var protected const SoundCue	DerrickAudio_NonPlayerCue;

var bool                        FirstRotTire;

var ParticleSystemComponent     R_WheelDust;
var ParticleSystemComponent     L_WheelDust;
var SkeletalMeshComponent 		NPCOnTurretCpnt;
var SkeletalMeshComponent 		NPCOnCarCpnt1;
var SkeletalMeshComponent 		NPCOnCarCpnt2;
var SkeletalMeshComponent 		TurretCpnt;


//
// Wheels
//

enum WheelType
{
		WType_FL,
		WType_FR,
		WType_BL,
		WType_BR,
};

struct native DerrickWheel
{

	var() float				WheelRadius;
	var() name				BoneName;
	var() name				SkelControlName;
	var SkelControlWheel	WheelControl;

	var matrix				WheelRefPoseTM;

	/** Controls how fast a free-spinning wheel will decelerate. */
	var() float				FreeSpinningFrictionDecel;

	/** Contact information */
	var bool				bHasContact;
	var	bool				bHadContact;
	var vector				LastContactPos;

	/** How fast the wheel is rolling, in deg/sec. */
	var float				RollVel;

	var rotator				LastRot;

	var vector				Location;
	var rotator				Rotation;

	var() float				WheelRoll;

	/** local space offset from the wheelbone, defines the position from which to derive the raycast endpoints */
	var() vector			WheelRayBaseOffset;

	/** How long since this wheel did a trace */
	var int					FramesSinceLastTrace;

	/** How much to move wheel each frame to achieve desired displacement */
	var float				WheelDispPerFrameAdjust;

	//factor which can affect the body performance
	var float 				BodyRotFactor;
	var WheelType			PosType;

	structdefaultproperties
	{
	   BodyRotFactor=0.f
    }
};

struct native stKActorDestory
{
	var StaticMesh KActorDestoryMesh;
	var KActorSpawnable DestoryKActor;
	var const name DestroyRootSocketName;
	var const float MassScale;
};

enum VehicleState
{
  state_Start,
  state_Moving,
  state_Breaking,
  state_Idle,
};

var VehicleState 				MoveState;
var protected array<stKActorDestory>  DestoryActors;
var() array<DerrickWheel>	Wheels;
var() name                  BodyBoneName;

/** How many frames between doing traces against the world for each wheel */
var()	int					WheelTraceInterval;

var protected transient bool bForceUpdateWheelsNextTick;

/** If the size of the derrick on screen is less than this, don't update wheels */
var()	float				MinDistFactorForUpdate;

/** Cached anim node refs we use to control the derrick anims. */
//var protected transient GearAnim_BlendList	HatchAnimControl;
//var protected transient GearAnim_BlendList	CabinDoorAnimControl;
//var protected transient GearAnim_BlendList	LeftArmAnimControl;
//var protected transient GearAnim_BlendList	RightArmAnimControl;

//var protected transient bool				bHatchOpen;
//var protected transient bool				bCabinDoorOpen;
//var protected transient bool				bLeftArmPrepared;
//var protected transient bool				bLeftArmDeployed;
//var protected transient bool				bRightArmPrepared;
//var protected transient bool				bRightArmDeployed;

//var protected SkeletalMeshComponent			LeftGrindLift;
//var protected transient GearAnim_BlendList	LeftGrindLiftAnimControl;
//var protected SkeletalMeshComponent			RightGrindLift;
//var protected transient GearAnim_BlendList	RightGrindLiftAnimControl;

//var protected const SoundCue				HatchOpenCue;
//var protected const SoundCue				HatchCloseCue;
//var protected const SoundCue				CabinDoorOpenCue;
//var protected const SoundCue				CabinDoorCloseCue;
//var protected const SoundCue				ArmPrepareCue;
//var protected const SoundCue				ArmDeployCue;

/** Jiggle vars */
var protected transient AnimNodeBlend		JiggleAnimControl;
var protected transient vector 				LastVelocity;
var() protected const float					AccelJiggleScalar;
var() protected const float					JiggleFadeTime;
var float 					                LastForwardVel;

/** Internal.  True to skip any interpolation in the steering/wheel code.  Useful for coming back from a delay in updates. */
var protected transient bool				bResetInterpolation;
var SoundCue                                StartEngineSound;
var SoundCue                                StopEngineSound;
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


simulated native final function CacheWheelRefPoseTMs();
simulated native function UpdateVehicleState(FLOAT CurrForwardVel);
simulated event VehicleStart()
{
	Mesh.PlayAnim('VehStart', 0.0, false);
    PlaySound(StartEngineSound, true);
    DerrickBody.PlayerEngineMainLoop.Play();
    DerrickBody.PlayerEngineMainLoop.FadeIn(1.5f,1.f);
    MoveState = state_Moving;
}

simulated event VehicleBreak()
{
    Mesh.PlayAnim('VehBreak', 0.0, false);
    PlaySound(StopEngineSound, true);
    DerrickBody.PlayerEngineMainLoop.FadeOut(1.5f,0.0f);
}

simulated function HiddenWheelMesh(bool bInHidden)
{
  mesh.SetHidden(true);
  mesh.SetActorCollision(false,false);
  mesh.SetBlockRigidBody(false);
}

simulated event Destoryed()
{
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
//  DestoryKactor.Length = KActorDestoryMesh.Length;
  for(i = 0;i < DestoryActors.Length;++i)
  {
      if(DestoryActors[i].KActorDestoryMesh != none)
      {
          mesh.GetSocketWorldLocationAndRotation(DestoryActors[i].DestroyRootSocketName,tmploc,tmprot);
          DestoryActors[i].DestoryKActor = Spawn(class'KActorSpawnable',self,,tmploc,Rotation,,TRUE);
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

final function DisablePhysics()
{
   local int i;
   for(i = 0;i < DestoryActors.Length;++i)
   {
     if(DestoryActors[i].DestoryKActor != none)
     {
         DestoryActors[i].DestoryKActor.SetPhysics(PHYS_None);  //bNoDelete=true, couldn't use Destroy
     }
   }
   if(DestoryKActorBase != none)
   {
       DestoryKActorBase.SetPhysics(PHYS_None);  //bNoDelete=true, couldn't use Destroy
   }
}

/** Internal.  Sets up an audiocomponent. */
simulated function AudioComponent CreateAndAttachAudioComponent(SoundCue Cue, Name SocketName, optional bool bPlayImmediately)
{
	local AudioComponent AC;
	AC = CreateAudioComponent(Cue, FALSE, TRUE,,, FALSE);
	if (AC != None)
	{
		AC.bUseOwnerLocation = TRUE;
		Mesh.AttachComponentToSocket(AC, SocketName);
		AC.bAutoDestroy = FALSE;
		AC.bShouldRemainActiveIfDropped = TRUE;

		if (bPlayImmediately)
		{
			AC.Play();
		}
	}

	return AC;
}

//simulated protected function TriggerSuspensionSound_FrontRight()
//{
//	// maybe scale to velocity?
//	if (VSize(Velocity) > SuspensionAudioVelocityThreshold)
//	{
//		SuspensionAudio_Player_FrontRight = PlayDerrickAudioComponent(SuspensionAudio_Player_FrontRight, SuspensionAudio_Player_FrontRightCue, 'SuspensionAudio_FrontRight');
//	}
//	SetTimer( RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), FALSE, nameof(TriggerSuspensionSound_FrontRight) );
//}
//
//simulated protected function TriggerSuspensionSound_FrontLeft()
//{
//	if (VSize(Velocity) > SuspensionAudioVelocityThreshold)
//	{
//		SuspensionAudio_Player_FrontLeft = PlayDerrickAudioComponent(SuspensionAudio_Player_FrontLeft, SuspensionAudio_Player_FrontLeftCue, 'SuspensionAudio_FrontLeft');
//	}
//	SetTimer( RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), FALSE, nameof(TriggerSuspensionSound_FrontLeft) );
//}


simulated function AttachToDerrick(HDPlatform_Derrick Derrick)
{
    local int i,j;
    //local SkeletalMeshSocket tmpsocket;
	DerrickBody = Derrick;
    SimpleWheelSim = DerrickBody.SimpleSim;
	SetBase(Derrick);
	SetRelativeLocation(vect(0,0,0));
	SetRelativeRotation(rot(0,0,0));

	//Mesh.SetShadowParent(DerrickBody.StaticMeshComponent);
	Mesh.ForcedLODModel = Derrick.StaticMeshComponent.ForcedLODModel;
	DynamicLightEnvironmentComponent(mesh.LightEnvironment).MaxModulatedShadowColor = DerrickBody.LightEnvironment.MaxModulatedShadowColor;
	//LightEnvironment = DerrickBody.LightEnvironment;
//    AttachComponent(LightEnvironment);
//    ForceUpdateComponents();
    Derrick.StaticMeshComponent.SetHidden(TRUE);

   	R_WheelDust = new(self) class'TMParticleSystemComponent';
   	L_WheelDust = new(self) class'TMParticleSystemComponent';
   	R_WheelDust.bAutoActivate = true;
    L_WheelDust.bAutoActivate = true;
    if(Derrick.WheelDust != none)
    {
     	R_WheelDust.SetTemplate(Derrick.WheelDust);
     	L_WheelDust.SetTemplate(Derrick.WheelDust);
	}
	mesh.AttachComponentToSocket(R_WheelDust,R_Wheel_DustSocketName);
	mesh.AttachComponentToSocket(L_WheelDust,L_Wheel_DustSocketName);

	DestroyPSC = new(self) class'TMParticleSystemComponent';
	if(DestroyParticle != none)
	{
	    DestroyPSC.SetTemplate(DestroyParticle);
	    mesh.AttachComponentToSocket(DestroyPSC,DestroyPSCSocketName);
	    DestroyPSC.SetActive(false);
    }

    DestroySmokePSC.Length = (Rand(2) == 0) ? 2 : 3;
    if(DestroySmokeParticle != none)
    {
        DestroySmokePSC[0] = new(self) class'TMParticleSystemComponent';
        DestroySmokePSC[0].SetTemplate(DestroySmokeParticle);
	    mesh.AttachComponentToSocket(DestroySmokePSC[0],DestroyPSCSocketName);
	    DestroySmokePSC[0].SetActive(false);
    }
    for(i = 1; i < DestroySmokePSC.Length;++i)
    {
        if(DestroyFireParticle != none)
        {
          DestroySmokePSC[i] = new(self) class'TMParticleSystemComponent';
          DestroySmokePSC[i].SetTemplate(DestroyFireParticle);
          j = Rand(DestroySmokeSocketName.Length);
          mesh.AttachComponentToSocket(DestroySmokePSC[i],DestroySmokeSocketName[j]);
          DestroySmokePSC[i].SetActive(false);
          DestroySmokeSocketName.Remove(j,1);
        }
    }
//    if(DestoryMesh != none)
//        DestoryMesh.SetHidden(true);

	if(Derrick.bHasInCarNpc)
	{
	  mesh.AttachComponentToSocket(NPCOnTurretCpnt,OnTurretNpcSocketName);
	  mesh.AttachComponentToSocket(TurretCpnt,TurretSocketName);
  	  mesh.AttachComponentToSocket(NPCOnCarCpnt1,OnCarNpcSocketName1);
      mesh.AttachComponentToSocket(NPCOnCarCpnt2,OnCarNpcSocketName2);
	  NPCOnCarCpnt1.PlayAnim('HM_pose');
  	  NPCOnCarCpnt2.PlayAnim('HM_pose');

      NPCOnTurretCpnt.SetShadowParent(mesh);
	  NPCOnTurretCpnt.SetLightEnvironment(mesh.LightEnvironment);
      TurretCpnt.SetShadowParent(mesh);
	  TurretCpnt.SetLightEnvironment(mesh.LightEnvironment);
      NPCOnCarCpnt1.SetShadowParent(mesh);
	  NPCOnCarCpnt1.SetLightEnvironment(mesh.LightEnvironment);
      NPCOnCarCpnt2.SetShadowParent(mesh);
	  NPCOnCarCpnt2.SetLightEnvironment(mesh.LightEnvironment);

	}

    //change Materials
    for(i = 0;i < DerrickBody.VehMaterials.Length;++i)
    {
        if(i < mesh.GetNumElements())
        {
          mesh.SetMaterial(i,DerrickBody.VehMaterials[i]);
        }
    }

    if(DerrickBody.DestoryVehMeshs.Length > 0)
    {
        DestoryMesh = DerrickBody.DestoryVehMeshs[0];
        for(i = 1;i < DerrickBody.DestoryVehMeshs.Length;++i)
        {
             if(i < DerrickBody.DestoryVehMeshs.Length)
             {
                  DestoryActors[i - 1].KActorDestoryMesh = DerrickBody.DestoryVehMeshs[i];
             }
         }
    }

	if (Derrick.bHidden)
	{
		SetWheelsHidden(TRUE);
	}

	SetCollisionType(DerrickBody.CollisionType);
	mesh.SetHasPhysicsAssetInstance(TRUE);
	mesh.WakeRigidBody();
}

simulated protected function AudioComponent PlayDerrickAudioComponent(AudioComponent AC, SoundCue Cue, Name SocketName)
{
	if (AC == None)
	{
		AC = CreateAndAttachAudioComponent(Cue, SocketName);
	}
	if (AC != None)
	{
		AC.Play();
	}
	return AC;
}

simulated protected function StopAudioComponent(AudioComponent AC, optional float FadeOutTime)
{
	if (AC != None)
	{
		AC.FadeOut(FadeOutTime, 0.f);
	}
}

//simulated function SetupAudio(bool bDoingPlayerAudio, bool bDoingNonPlayerAudio)
//{
//	if (bDoingPlayerAudio)
//	{
//		EngineAudio_Player_Left = PlayDerrickAudioComponent(EngineAudio_Player_Left, EngineAudio_Player_LeftCue, 'EngineAudio_Left');
//		EngineAudio_Player_Right = PlayDerrickAudioComponent(EngineAudio_Player_Right, EngineAudio_Player_RightCue, 'EngineAudio_Right');
//
//		SetTimer( RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), FALSE, nameof(TriggerSuspensionSound_FrontRight) );
//		SetTimer( RandRange(SuspensionAudioRandomTimeRange.X, SuspensionAudioRandomTimeRange.Y), FALSE, nameof(TriggerSuspensionSound_FrontLeft) );
//	}
//	else
//	{
//		StopAudioComponent(EngineAudio_Player_Left);
//		StopAudioComponent(EngineAudio_Player_Right);
//
//		ClearTimer('TriggerSuspensionSound_FrontRight');
//		ClearTimer('TriggerSuspensionSound_FrontLeft');
//	}
//
//	if (bDoingNonPlayerAudio)
//	{
//		DerrickAudio_NonPlayer = PlayDerrickAudioComponent(DerrickAudio_NonPlayer, DerrickAudio_NonPlayerCue, 'EngineAudio_Center');
//	}
//	else
//	{
//		StopAudioComponent(DerrickAudio_NonPlayer);
//	}
//}

//simulated function Tick(float DeltaTime)
//{
//	super.Tick(DeltaTime);
//	//DebugRenderAudio();
//}

//function DebugRenderAudioComponent(AudioComponent AC)
//{
//	if (AC != None)
//		if (AC.IsPlaying())
//			DrawDebugBox(AC.ComponentLocation, vect(64,64,64), 0, 255, 0, FALSE);
//		else
//			DrawDebugBox(AC.ComponentLocation, vect(64,64,64), 255, 0, 0, FALSE);
//}

//function DebugRenderAudio()
//{
//	if (!DerrickBody.bHidden)
//	{
//		DebugRenderAudioComponent(SuspensionAudio_Player_FrontRight);
//		DebugRenderAudioComponent(SuspensionAudio_Player_FrontLeft);
//
//		DebugRenderAudioComponent(EngineAudio_Player_Left);
//		DebugRenderAudioComponent(EngineAudio_Player_Right);
//	}
//}

function PostBeginPlay()
{
	local int Idx;

	super.PostBeginPlay();

	CacheWheelRefPoseTMs();

	for (Idx=0; Idx<Wheels.length; ++Idx)
	{
		Wheels[Idx].WheelControl = SkelControlWheel(Mesh.FindSkelControl(Wheels[Idx].SkelControlName));
		Wheels[Idx].FramesSinceLastTrace = Rand(WheelTraceInterval-1);
	}
	BodyCtrl = SkelControlSingleBone(Mesh.FindSkelControl(BodyCtrlName));
//	LightEnvironment = DerrickBody.LightEnvironment;
//	HatchAnimControl = GearAnim_BlendList(Mesh.FindAnimNode('HatchControl'));
//	CabinDoorAnimControl = GearAnim_BlendList(Mesh.FindAnimNode('CabinDoorControl'));
//	LeftArmAnimControl = GearAnim_BlendList(Mesh.FindAnimNode('LeftArmControl'));
//	RightArmAnimControl = GearAnim_BlendList(Mesh.FindAnimNode('RightArmControl'));
//	JiggleAnimControl = AnimNodeBlend(Mesh.FindAnimNode('JiggleControl'));
}


///** Anim control functions. */
//simulated function OpenHatch()
//{
//	if (!bHatchOpen)
//	{
//		HatchAnimControl.SetActiveChild(0, 0.f);
//		bHatchOpen = TRUE;
//	}
//}
//simulated function CloseHatch()
//{
//	if (bHatchOpen)
//	{
//		HatchAnimControl.SetActiveChild(1, 0.f);
//		bHatchOpen = FALSE;
//	}
//}
//simulated function OpenCabinDoor()
//{
//	if (!bCabinDoorOpen)
//	{
//		CabinDoorAnimControl.SetActiveChild(0, 0.f);
//		bCabinDoorOpen = TRUE;
//	}
//}
//simulated function CloseCabinDoor()
//{
//	if (bCabinDoorOpen)
//	{
//		CabinDoorAnimControl.SetActiveChild(1, 0.f);
//		bCabinDoorOpen = FALSE;
//	}
//}

// move to content object!!
//simulated protected function SkeletalMeshComponent CreateGrindliftMesh(Name AttachName);

//simulated function LeftArmPrepare()
//{
//	if (!bLeftArmPrepared)
//	{
//		LeftArmAnimControl.SetActiveChild(1, 0.f);
//
//		LeftGrindLift = CreateGrindliftMesh('b_Lt_Boom_Pod');
//		LeftGrindLiftAnimControl = GearAnim_BlendList(LeftGrindLift.FindAnimNode('GrindliftAnims'));
//
//		LeftGrindLiftAnimControl.SetActiveChild(3, 0.f);
//
//		bLeftArmPrepared = TRUE;
//	}
//}
//simulated function LeftArmDeploy()
//{
//	if (!bLeftArmDeployed && bLeftArmPrepared)
//	{
//		LeftArmAnimControl.SetActiveChild(2, 0.f);
//		LeftGrindLiftAnimControl.SetActiveChild(5, 0.f);
//		bLeftArmDeployed = TRUE;
//	}
//}
//simulated function RightArmPrepare()
//{
//	if (!bRightArmPrepared)
//	{
//		RightArmAnimControl.SetActiveChild(1, 0.f);
//
//		RightGrindLift = CreateGrindliftMesh('b_Rt_Boom_Pod');
//		RightGrindLiftAnimControl = GearAnim_BlendList(RightGrindLift.FindAnimNode('GrindliftAnims'));
//
//		RightGrindLiftAnimControl.SetActiveChild(0, 0.f);
//
//		bRightArmPrepared = TRUE;
//	}
//}
//simulated function RightArmDeploy()
//{
//	if (!bRightArmDeployed && bRightArmPrepared)
//	{
//		RightArmAnimControl.SetActiveChild(2, 0.f);
//		RightGrindLiftAnimControl.SetActiveChild(2, 0.f);
//		bRightArmDeployed = TRUE;
//	}
//}

//simulated function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
//{
//	if (RightGrindLiftAnimControl.Children[0].Anim == SeqNode)
//	{
//		// rightdeploystart finished, play rightidle
//		RightGrindLiftAnimControl.SetActiveChild(1, 0.f);
//	}
//	else if (LeftGrindLiftAnimControl.Children[3].Anim == SeqNode)
//	{
//		// leftdeploystart finished, play leftidle
//		LeftGrindLiftAnimControl.SetActiveChild(4, 0.f);
//	}
//
//	// @todo, advance new anim by ExcessTime so it's seamless?
//
//	super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
//}

simulated function SetWheelsHidden(bool bNewHidden)
{
	SetHidden(bNewHidden);

	if (bNewHidden)
	{
		bResetInterpolation = TRUE;
		SetCollision(FALSE, FALSE, TRUE);
	}
	else
	{
		bForceUpdateWheelsNextTick = TRUE;
		SetCollision(default.bCollideActors, default.bBlockActors, default.bIgnoreEncroachers);
	}
}

function SkeletalMeshComponent GetMesh()
{
  return Mesh;
}

function name GetTurretSocketName()
{
  return  TurretSocketName;
}

event RanInto( Actor Other )
{
	local HDBasePawn GP;
	GP = HDBasePawn(Other);
	if( GP != none && DerrickBody.TurretActor.Driver != Other /*&& GP.Base != none && GP.ClampedBase != self */)
	{
		GP.TakeDamage( 2, None, GP.Location, Velocity, class'DmgType_Crushed');
	}
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
  if(DerrickBody != none)
  {
  	DerrickBody.BodyTakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
  }
}

//simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
//{
//	if(SeqNode.AnimSeq.SequenceName == 'VehStart')
//	{
//        MoveState = state_Moving;
//	}
//}


