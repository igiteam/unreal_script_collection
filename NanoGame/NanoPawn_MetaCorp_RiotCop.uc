/**
 * MetaCorp RiotCop
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop extends NanoPawn_MetaCorp_NanoInfantry;


/** Bool that indicates if trooper should have a shield */
var transient bool bEquipShield;

/** Effort of the pawn throwing the stick **/
var SoundCue TeslaThrowSound;

/** The baton type this pawn should use **/
var class<NanoWeap_Baton> BatonClass;

var name RiotShieldSocket;

simulated function PostBeginPlay()
{
	// see if we should have shield
	if(bEquipShield && ( ResistenceToBullets != 1.0f) )
	{
		CreateShield();
	}
	Super.PostBeginPlay();

	// set all bodies to be "not physical"
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed( TRUE );

	MITV_GoreOverlay = Mesh.CreateAndSetMaterialInstanceTimeVarying(0);
	MITV_Gore = Mesh.CreateAndSetMaterialInstanceTimeVarying(1);
}


simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('GunAimNode'));
	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('CamAimNode'));	
	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('SwordAimNode'));	

	PhysBlend = NanoAnimBlendByPhysics(Mesh.FindAnimNode('PhysBlend'));

	TopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
	FullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
	RunningFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningFullBodySlot'));
	RunningTopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningTopHalfSlot'));
	FallingFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FallingFullBodySlot'));

	TackleRunSeqNode = NanoAnimNodeSequence(Mesh.FindAnimNode('TackleRun'));

	HandGunAimOffset = AnimNodeAimOffset(Mesh.FindAnimNode('HandGunAimOffset'));

	HeadTrackSkelControl = SkelControlLookAt(Mesh.FindSkelControl('HeadLook'));
}

simulated function ClearAnimNodes()
{
	AimNodes.Length = 0;

	PhysBlend = None;

	TopHalfSlot = None;
	FullBodySlot = None;
	RunningFullBodySlot = None;
	RunningTopHalfSlot = None;
	FallingFullBodySlot = None;

	TackleRunSeqNode = None;

	HeadTrackSkelControl = None;
}

simulated function float SpawnNanoBaton()
{
	local float AnimTime;

	if (NanoWeapon(Weapon) != None)
	{
		AnimTime = RunningFullBodySlot.PlayCustomAnim(NanoWeapon(Weapon).ThrowAwayAnimName, 1.0, 0.1, 0.1, FALSE, TRUE);
	}

	SpawnANanoWeapon( BatonClass );

	return AnimTime;
}


/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.RiotTrooperKilled;
}

function CreateShield()
{
	if (!bHasShield)
	{
		Super.CreateShield();
		if (ShieldMeshComp == None)
		{
			bHasShield = TRUE;
			ShieldMeshComp = new(self) class'SkeletalMeshComponent';
			ShieldMeshComp.SetSkeletalMesh(SkeletalMesh'MET_RiotShield.SK_MET_RiotShield');
			ShieldMeshComp.SetPhysicsAsset(PhysicsAsset'MET_RiotShield.SK_MET_RiotShield_Physics');
			ShieldMeshComp.SetActorCollision(TRUE,FALSE);
			ShieldMeshComp.SetTraceBlocking(TRUE,FALSE);
			ShieldMeshComp.SetShadowParent( Mesh );
			Mesh.AttachComponentToSocket(ShieldMeshComp,RiotShieldSocket);
		}
	}
}

function DropShield()
{
	local NanoDroppedWeapon Asset;
	local vector BoneLoc;
	if (bHasShield)
	{
		Super.DropShield();
		bHasShield = FALSE;
		Mesh.GetSocketWorldLocationAndRotation(RiotShieldSocket,BoneLoc);
		Mesh.DetachComponent(ShieldMeshComp);
		Asset = Spawn(class'NanoDroppedWeapon',,,BoneLoc);
		if (Asset != None)
		{
			Asset.Instigator = self;
			Asset.SetMeshAndPhysAsset(ShieldMeshComp.SkeletalMesh,ShieldMeshComp.PhysicsAsset);
			Asset.SkeletalMeshComponent.WakeRigidBody();
			Asset.SkeletalMeshComponent.SetRBAngularVelocity(VRand() * RandRange(-64,64),TRUE);
		}
		ShieldMeshComp = None;
	}
}

function DeployTesla()
{
	bDeployingTesla = TRUE;
	SetTimer(FullBodySlot.PlayCustomAnim('TeslaCoil_Deploy',1.f,0.1f,0.1f),FALSE,nameof(TeslaCoilDeployed));
}

function TeslaCoilDeployed()
{
	bDeployingTesla = FALSE;
	SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_MeleeWeaponOut' ); // once a guy is aggro I guess just keep him aggro? (for demo that works)
}

function CreatePlantedTesla()
{
	Spawn(class'TeslaCoil',,,Location + vector(Rotation) * 128.f + vect(0,0,1) * -GetCollisionHeight());
	DestroyCurrentWeapon();
}

/** This is called by the AI and triggers and anim and then at the end of that anim it will fire off functin which will actually throw the teslas coil **/
function ThrowTesla()
{
/*
	bThrowingTesla = TRUE;
	SetTimer(FullBodySlot.PlayCustomAnim('Baton_Attack_A',1.f,0.1f,0.1f),FALSE,nameof(ThrowThrowTesla));
	PlaySound( TeslaThrowSound );  // prob should be moved to anim notify once we get a real anim
*/
}

/** 
 *  There is a disconnect between what hte pawn has wielded (actual weapon) and what the AI thinks it has.  So we need
 *  spawn the baton if we don't have it currently wielded. 
 **/
function ThrowThrowTesla()
{
/*
	if( NanoWeap_Baton(Weapon) == none )
	{
		//DestroyCurrentWeapon();
		SpawnNanoBaton();
	}

	NanoWeap_Baton(MyNanoWeapon).ThrowTesla();
	DestroyCurrentWeapon();
    TeslaCoilThrown();
*/
}

/** This sets the bool that hte AI state code is looking for to tell it that the teslas has been thrown **/
function TeslaCoilThrown()
{
	bThrowingTesla = FALSE;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	local float Priority;
	local int Idx;

	Priority = Super.GetBasePriority( Askee, AskeePawn );
	if( Priority != INDEX_NONE )
	{
		if( AskeePawn != None )
		{
			for( Idx = 0; Idx < AskeePawn.ActiveAttackerList.Length; Idx++ )
			{
				if( AskeePawn.ActiveAttackerList[Idx] == None )
				{
					AskeePawn.ActiveAttackerList.Remove( Idx--, 1 );
					continue;
				}

				if( AskeePawn.ActiveAttackerList[Idx].GetAttackActor() == self )
				{
					Priority *= 2.f;
				}
			}
		}
	}
	return Priority;
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if( IsHeadTrackingEnabled() )
	{
		HeadTrackSkelControl.DesiredTargetLocation = GetHeadLookTargetLocation();
		//`log( "setting" @ `showvar(HeadTrackSkelControl.DesiredTargetLocation) @ `showvar(HeadTrackSkelControl.ControlStrength));
	}
}

defaultproperties
{
	PreferredRangedWeaponClass=class'NanoWeap_BensGun'
	BatonClass=class'NanoWeap_Baton'
	ControllerClass=class'NanoAI_Trooper'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Soft'	// SkeletalMesh'shocktrooper_GDC.shocktrooper_GDC' 
		PhysicsAsset=PhysicsAsset'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Physics'

//		SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper'
//		PhysicsAsset=PhysicsAsset'MET_ShockTrooperProto.SK_MET_ShockTrooper_Proto_Physics'

		AnimTreeTemplate=AnimTree'MET_ShockTrooperProto_AT.AT_ShockTrooperProto'
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockT_Hit_React')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ST_Combat_Idle')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ST_Combat_Loc')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		AnimSets.Add(AnimSet'MET_ShockTrooper.AS_MET_Shocktrooper_Gore_Deaths')		

		bEnableFullAnimWeightBodies=TRUE
		MinDistFactorForKinematicUpdate=0.0f
		PhysicsWeight=1.0f
		Translation=(Z=-88.0)
	End Object

	//GoreSkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Soft'	
	//GorePhysicsAsset=PhysicsAsset'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Physics'

	KnockdownAnimName="Shield_Knockdown"

	LeftHandSocketName="Weapon_L"
	RightHandSocketName="Weapon_R"
	RiotShieldSocket="RiotShield"

	KnockDownBodySound=SoundCue'Foley_Body.MetaCorps.MetaCorpsB_BodyFall_Cue'
	KnockDownPainSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatThrown_Cue'

	AimAttractors(0)=(OuterRadius=64.f,InnerRadius=4.f,BoneName="b_MF_Spine_02")
	AimAttractors(1)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Head")
	AimAttractors(2)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_L")
	AimAttractors(3)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_R")

	TeslaThrowSound=SoundCue'Weapon_Tesla.Stick.Tesla_ThrowCue'


	GoreEffects=NanoGoreEffectCollection'NanoGoreEffects.Foes.RiotCopGoreEffects'

	GoreBreakableJoints.Empty
	GoreBreakableJoints.Add((ConstraintName="b_MF_Calf_R"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Foot_R"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Calf_L"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Foot_L"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Spine_02"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Head"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Head_Gore01"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_UpperArm_R"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Forearm_R"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Hand_R"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Spine_02_slave"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Head_slave"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Head_Gore01_slave"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_UpperArm_L"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Forearm_L"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Hand_L"))
	GoreBreakableJoints.Add((ConstraintName="b_MF_Pelvis_Slave"))

	SpineSkelControls.Add("b_MF_Spine_01_slave")
	SpineSkelControls.Add("b_MF_Spine_02_slave")
	SpineSkelControls.Add("b_MF_Spine_03_slave")
	SpineSkelControls.Add("b_MF_Neck_slave")
	SpineSkelControls.Add("b_MF_Head_slave")
	SpineSkelControls.Add("b_MF_Pelvis_slave")

	SpineLinks.Add(( DestBody="b_MF_Spine_01_slave", SourceBody="b_MF_Spine_01" ))
	SpineLinks.Add(( DestBody="b_MF_Spine_02_slave", SourceBody="b_MF_Spine_02" ))
	SpineLinks.Add(( DestBody="b_MF_Spine_03_slave", SourceBody="b_MF_Spine_03" ))
	SpineLinks.Add(( DestBody="b_MF_Neck_slave", SourceBody="b_MF_Neck" ))
	SpineLinks.Add(( DestBody="b_MF_Head_slave", SourceBody="b_MF_Head" ))
	SpineLinks.Add(( DestBody="b_MF_Head_Gore01_slave", SourceBody="b_MF_Head_Gore01" ))


	DroppedOrbClasses.Add(class'NanoAbsorbOrb_Body_Trooper')

	ExtraDroppedWeapons.Add(class'NanoWeap_MP7')
}