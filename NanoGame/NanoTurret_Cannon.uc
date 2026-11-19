/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTurret_Cannon extends NanoRideableForgeableBase
	implements(NanoInterface_Forgeable);

var protected transient NanoPawn ForgingPawn;

var protected const SoundCue ForgeSound;
var() protected class<NanoWeapon> WeaponClass;

var protectedwrite transient bool bForging;

var protected transient SkelControlLookAt AimLookatYaw;
var protected transient SkelControlLookAt AimLookatPitch;

var() protected const float TrackingInterpSpeed;

var protected transient rotator IdealAimDir;
var protected transient rotator LastAimDir;
var() protected const float AimDirInterpSpeed;

delegate OnFinishedForging();

simulated function PostBeginPlay()
{
//	local int Idx;

	Super.PostBeginPlay();

// 	SpawnDefaultController();
// 
// 	Health = DefaultHealth;
// 
// 	// start Assembly anim
// 	AssembleAnimSeq	= NanoAnimNodeSequence(Mesh.FindAnimNode('Assemble'));
// 
// 	MIC_TurretMat = Mesh.CreateAndSetMaterialInstanceConstant(0);
// 	Mesh.SetMaterial(1, MIC_TurretMat);
// 	Mesh.SetMaterial(2, MIC_TurretMat);
// 	Mesh.SetMaterial(3, MIC_TurretMat);
// 	Mesh.SetMaterial(4, MIC_TurretMat);
// 	Mesh.SetMaterial(5, MIC_TurretMat);
// 	
// 	Mesh.AttachComponent(PSC_ForgeEffect0, 'Object12');
// 	Mesh.AttachComponent(PSC_ForgeEffect1, 'Object12');
// 	Mesh.AttachComponent(PSC_ForgeEffect2, 'Object12');
// 
// 	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
// 	{
// 		Mesh.AttachComponentToSocket(PSC_ForgeTrails[Idx], PSC_ForgeTrailSockets[Idx]);
// 	}
// 
 	AimLookatYaw = SkelControlLookAt(Mesh.FindSkelControl('AimYaw'));
 	AimLookatPitch = SkelControlLookAt(Mesh.FindSkelControl('AimPitch'));
 	AimLookatYaw.TargetLocationInterpSpeed = TrackingInterpSpeed;
 	AimLookatPitch.TargetLocationInterpSpeed = TrackingInterpSpeed;
// 	

	// do the actual forge
	ForgeActor();

	// Create it and add to inventory chain, only activate if we don't have a weapon currently selected
	CreateInventory(WeaponClass);
}

/** from NanoInterface_Forgeable */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback)
{
//	local int Idx;

// 	if (AssembleAnimSeq != None)
// 	{
// 		AssembleAnimSeq.PlayAnim();
// 	}
// 
// 	PSC_ForgeEffect0.ActivateSystem();
// 
// 	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
// 	{
// 		PSC_ForgeTrails[Idx].ActivateSystem();
// 	}
// 
// 	SetTimer(0.05f, FALSE, nameof(StartBoomForgeEffect));
// 	SetTimer(0.2f, FALSE, nameof(StartMICParamInterp));
// 	SetTimer(1.2f, FALSE, nameof(StartFinalPopEffect));
// 	SetTimer(1.2f, FALSE, nameof(StopCoalesceForgeEffect));
 	SetTimer(1.75f, FALSE, nameof(ForgeFinished));

	PlaySound(ForgeSound);

	bForging = true;
	OnFinishedForging = OnFinishCallback;
}

protected function ForgeFinished()
{
//	local int Idx;

// 	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
// 	{
// 		PSC_ForgeTrails[Idx].DeactivateSystem();
// 	}

	// put forging pawn into the cannon turret seat
	DriverEnter(ForgingPawn);
	//ForgingPawn.StartDriving(self);

	// call delegate
	if (OnFinishedForging != None)
	{
		OnFinishedForging();
	}
	bForging = false;
}


function Init(Pawn InForgingPawn)
{
	local AIController AI;

	ForgingPawn = NanoPawn(InForgingPawn);

	// set the team
	AI = AIController(Controller);
	if (AI != None)
	{
		AI.SetTeam(InForgingPawn.GetTeamNum());
	}
}

simulated function Tick( float DeltaTime )
{
	local vector TargetLoc, TargetLocBoneSpace;
	local rotator UnusedRot;
	local NanoPC NPC;

	Super.Tick(DeltaTime);

	// update
	NPC = NanoPC(Controller);
	if (NPC != None)
	{
		IdealAimDir += NPC.LastDeltaRot;
	}
	LastAimDir = RInterpTo(LastAimDir, IdealAimDir, DeltaTime, AimDirInterpSpeed);

	// feed aim direction to skel controls

	TargetLoc = Mesh.GetBoneLocation('Object12') + vector(LastAimDir) * 300.f;
	AimLookatPitch.SetTargetLocation(TargetLoc);
	AimLookatPitch.InterpolateTargetLocation(DeltaTime);

	// for yaw control, clamp Targetloc in bone space to bone's XZ plane
	// this is a hack to get around a bug in the skelcontrollookat stuff
	Mesh.TransformToBoneSpace('Object12', TargetLoc, UnusedRot, TargetLocBoneSpace, UnusedRot);
	TargetLocBoneSpace.Y = 0.f;
	Mesh.TransformFromBoneSpace('Object12', TargetLocBoneSpace, UnusedRot, TargetLoc, UnusedRot);

	AimLookatYaw.SetTargetLocation(TargetLoc);
	AimLookatYaw.InterpolateTargetLocation(DeltaTime);

	//DrawDebugBox(TargetLoc, vect(6,6,6), 255, 255, 0, false);
}

simulated function rotator GetViewRotation()
{
	return LastAimDir;
}


defaultproperties
{
	bDriverIsVisible=true
	AimDirInterpSpeed=8.f

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh0
		SkeletalMesh=SkeletalMesh'TurretAssembleTest_01.Meshes.SK_AssembleTurret'
		PhysicsAsset=PhysicsAsset'TurretAssembleTest_01.Meshes.SK_AssembleTurret_Physics'
		AnimTreeTemplate=AnimTree'TurretAssembleTest_01.Meshes.Turret_AnimTree'
		AnimSets(0)=AnimSet'TurretAssembleTest_01.Meshes.TurretAssembleAnimset'
		//Scale=1.f
		Translation=(X=0,Z=-80)
		Rotation=(Yaw=16384)
	End Object
	Mesh=TurretMesh0
	Components.Add(TurretMesh0)

	// define here as lot of sub classes which have moving parts will utilize this
	Begin Object Class=DynamicLightEnvironmentComponent Name=TurretLightEnvironment
	    bDynamic=FALSE
		bCastShadows=FALSE
		AmbientGlow=(R=0.3f,G=0.3f,B=0.3f,A=1.0f)
		TickGroup=TG_DuringAsyncWork
	End Object
//	MyLightEnvironment=TurretLightEnvironment
	Components.Add(TurretLightEnvironment)

	ForgeSound=SoundCue'Gameplay_Audio.Forging.Player_ForgeSmg_Stereo_Cue'

	WeaponClass=class'NanoWeap_CannonTurret'

}
