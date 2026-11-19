/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoHUDElement_WeaponSelect extends NanoHUDElement_Forge
	dependson(NanoTypes)
	config(Game);


defaultproperties
{
// 	ForgeMenuSlotBackgroundMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegment'
// 	ForgeMenuSlotHighlightOutsideMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegmentHiLightOutside'
// 	ForgeMenuSlotHighlightInsideMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegmentHiLightInside'
// 	DistFromCamera=350

	// -6144 gaps
	ForgeMenuSlots.Empty
	ForgeMenuSlots.Add((Roll=4028,PlanType=EPS_Melee))			// ur left
	ForgeMenuSlots.Add((Roll=10172,PlanType=EPS_Melee))			// ur center
	ForgeMenuSlots.Add((Roll=16316,PlanType=EPS_Melee))			// ur right

	ForgeMenuSlots.Add((Roll=22460,PlanType=EPS_Gun))			// ur right
	ForgeMenuSlots.Add((Roll=28604,PlanType=EPS_Gun))			// ur right

	ForgeMenuSlots.Add((Roll=-4028,PlanType=EPS_Gun))			// ul left
	ForgeMenuSlots.Add((Roll=-10172,PlanType=EPS_Gun))			// ul left
	ForgeMenuSlots.Add((Roll=-16316,PlanType=EPS_Gun))			// ul left
	ForgeMenuSlots.Add((Roll=-22460,PlanType=EPS_Gun))			// ul center
	ForgeMenuSlots.Add((Roll=-28604,PlanType=EPS_Gun))			// ul center

// 
// 	SelectedMeshOffset=(X=-40)
// 
// 	SelectSoundCue=SoundCue'Interface_Audio.Menu.G2UI_LobbyScreenSlideBack01Cue'
// 	MoveSoundCue=SoundCue'Interface_Audio.Menu.G2UI_LobbyCharacterSelect01Cue'
// 	MenuUpSoundCue=SoundCue'Interface_Audio.Menu.MenuWhooshUp01Cue'
// 	MenuDownSoundCue=SoundCue'Interface_Audio.Menu.MenuWhooshDown01Cue'
// 
// 	PlanSlotNames[EPS_Gun]="RANGED WEAPONS"
// 	PlanSlotNames[EPS_Melee]="MELEE WEAPONS"
// 	PlanSlotNames[EPS_Utility]="FREE FORGE"
// 
// 	PlanSlotNameOffset=(X=0,Y=50)
// 	PlanNameTextOffset=(X=0,Y=80)
// 	PlanDescTextOffset=(X=0,Y=150)
// 	ForgeUITextColor=(R=255,G=255,B=255,A=255)
// 	PlanIconOffset=(X=80,Z=140)


}
