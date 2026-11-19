/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_COGDom extends GearPawn_COGGear
	config(Pawn)
	native(Pawn);

simulated event Destroyed()
{
	CharacterTexturesForceMipsNonResident();

	Super.Destroyed();
}

simulated function ClientRestart()
{
	Super.ClientRestart();

	if (GearPC(Controller) != None)
	{
		// for all human controlled pawns we want to make certain their textures are streamed in
		CharacterTexturesForceMipsResident();
	}
}

defaultproperties
{
	CharacterFootStepType=CFST_COG_Dom

	HeadIcon=MaterialInstanceConstant'UI_CharPortraits.HUDHeads.UI_HUDHeads_COG_Dom'
	ArcadeCharacterPortrait=Texture2D'UI_CharPortraits.T_CharPortraits_LG_COG_DomG3'

	ControllerClass=class'GearAI_Dom'
	SoundGroup=GearSoundGroup'GearSoundGroupArchetypes.GSG_COGDom'
	MasterGUDBankClassNames(0)="GearGameContent.GUDData_COGDom"
	FAS_ChatterNames.Add("COG_Dom_Summer.FaceFX.COG_Dom_Summer_FaceFX_Chatter")
	FAS_Efforts(0)=FaceFXAnimSet'COG_Dom_Summer.FaceFX.COG_Dom_Summer_FaceFX_Efforts'

	Begin Object Name=GearPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Dom_Summer.Mesh.COG_Dom_Summer_CamSkel'
		PhysicsAsset=PhysicsAsset'COG_Dom_Summer.Mesh.COG_Dom_Summer_CamSkel_Physics'
	End Object

	DefaultInventory.Empty()
	DefaultInventory(0)=class'GearGame.GearWeap_AssaultRifle'
	DefaultInventory(1)=class'GearGame.GearWeap_COGPistol'
	DefaultInventory(2)=class'GearGame.GearWeap_ShotGun'

	bKillDuringLevelTransition=false

	GoreSettings=GearPawnGoreSettings'GearGoreSettings.Dom_GoreSettings'
}
