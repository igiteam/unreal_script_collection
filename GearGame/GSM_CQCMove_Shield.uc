
/**
 * CQC Move (Close Quarter Combat) Shield execution
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_Shield extends GSM_CQC_Killer_Base;

var Array<CameraAnim>	CameraAnims;

function PlayExecution()
{
	// Play execution Camera Animation.
	if( CameraAnims.Length > 0 )
	{
		PlayExecutionCameraAnim(CameraAnims);
	}

	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_BoltokLongExecutionEffort, true);

	Super.PlayExecution();

	PawnOwner.SetTimer(BlendInTime/SpeedModifier, FALSE, nameof(AttachShieldToHand), Self);
	PawnOwner.SetTimer(AnimLength - BlendOutTime/SpeedModifier, FALSE, nameof(AttachShieldToArm), Self);
}

function AttachShieldToHand()
{
	local SkeletalMeshComponent ShieldMesh;
	local Name		SocketName;
	local float     ShieldScale;
	local Vector	RelativeLocation;
	local Rotator	RelativeRotation;
	local SkeletalMeshSocket	ShieldSocket;

	ShieldSocket = PawnOwner.Mesh.GetSocketByName(PawnOwner.GetLeftHandSocketName());
	if( ShieldSocket != None )
	{	
		ShieldMesh = PawnOwner.EquippedShield.Mesh;
		PawnOwner.GetShieldAttachBone(SocketName, RelativeRotation, RelativeLocation, ShieldScale);
		ShieldMesh.SetScale(ShieldScale);
		PawnOwner.Mesh.AttachComponent(ShieldMesh, ShieldSocket.BoneName, ShieldSocket.RelativeLocation, ShieldSocket.RelativeRotation);
	}
}

function AttachShieldToArm()
{
	local SkeletalMeshComponent ShieldMesh;
	local Name		SocketName;
	local float     ShieldScale;
	local Vector	RelativeLocation;
	local Rotator	RelativeRotation;

	ShieldMesh = PawnOwner.EquippedShield.Mesh;
	PawnOwner.GetShieldAttachBone(SocketName, RelativeRotation, RelativeLocation, ShieldScale);
	ShieldMesh.SetScale(ShieldScale);
	PawnOwner.Mesh.AttachComponent(ShieldMesh, PawnOwner.Mesh.GetSocketBoneName(SocketName), RelativeLocation, RelativeRotation);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Clear timers if aborted early
	if( PawnOwner.IsTimerActive(nameof(AttachShieldToHand), Self) )
	{
		PawnOwner.ClearTimer(nameof(AttachShieldToHand), Self);
	}
	if( PawnOwner.IsTimerActive(nameof(AttachShieldToArm), Self) )
	{
		PawnOwner.ClearTimer(nameof(AttachShieldToArm), Self);
		AttachShieldToArm();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_KillerAnim=(Stance=((Slot=BS_FullBody,AnimName="CTRL_Shield")))
	BS_VictimAnim=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Shield")))

	CameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Shield_Cam01'
	CameraAnims(1)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Shield_Cam02'
	CameraAnims(2)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Shield_Cam03'

	VictimDeathTime=1.58f
	ExecutionDamageType=class'GDT_ShieldExecute'
	MarkerRelOffset=(X=54.06,Y=12.39,Z=0.0)
	VictimRotInterpSpeed=0.f

	BlendInTime=0.2f
	BlendOutTime=0.2f
}
