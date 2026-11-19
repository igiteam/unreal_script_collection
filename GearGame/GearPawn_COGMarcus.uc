/**
 * Marcus Fenix
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_COGMarcus extends GearPawn_COGGear
	config(Pawn)
	native(Pawn);


// marcus is always played IN SP so set his textures to always be resident
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}


simulated event Destroyed()
{
	CharacterTexturesForceMipsNonResident();

	Super.Destroyed();
}

simulated function ClientRestart()
{
	Super.ClientRestart();

	if( GearPC(Controller) != None )
	{
		// for all human controlled pawns we want to make certain their textures are streamed in
		CharacterTexturesForceMipsResident();
	}
}

defaultproperties
{
	CharacterFootStepType=CFST_COG_Marcus

	HeadIcon=MaterialInstanceConstant'UI_CharPortraits.HUDHeads.UI_HUDHeads_COG_MarcusG3'
	ArcadeCharacterPortrait=Texture2D'UI_CharPortraits.T_CharPortraits_LG_COG_MarcusG3'

	ControllerClass=class'GearAI_Marcus'
	SoundGroup=GearSoundGroup'GearSoundGroupArchetypes.GSG_COGMarcus'
	MasterGUDBankClassNames(0)="GearGameContent.GUDData_COGMarcus"	
	FAS_ChatterNames.Add("COG_Marcus_Summer.FaceFX.COG_Marcus_FaceFX_Chatter")
	FAS_Efforts(0)=FaceFXAnimSet'COG_Marcus_Summer.FaceFX.COG_Marcus_FaceFX_Efforts'

	RagdollLimitScaleTable(8)=(RB_ConstraintName="b_MF_Head",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.5)

	Begin Object Name=GearPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Marcus_Summer.Skel_Mesh.COG_Marcus_Fenix_CamSkel'
		PhysicsAsset=PhysicsAsset'COG_Marcus_Summer.Skel_Mesh.COG_Marcus_Fenix_CamSkel_Physics'
		MorphSets.Add(MorphTargetSet'COG_Marcus_Summer.Skel_Mesh.Marcus_Game_Correctives')
	End Object

	DefaultInventory.Empty()
	DefaultInventory(0)=class'GearGame.GearWeap_AssaultRifle'
	DefaultInventory(1)=class'GearGame.GearWeap_COGPistol'
	DefaultInventory(2)=class'GearGame.GearWeap_Shotgun'
	// no smoke grenade for SP DefaultInventory(3)=class'GearGame.GearWeap_SmokeGrenade'
	//DefaultInventory(3)=class'GearGame.GearWeap_ShotGun'

	bKillDuringLevelTransition=FALSE

	GoreSettings=GearPawnGoreSettings'GearGoreSettings.Marcus_GoreSettings'
}
