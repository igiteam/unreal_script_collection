/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoHUDElement_Forge extends Actor
	dependson(NanoTypes)
	config(Game);

var StaticMesh ForgeMenuSlotBackgroundMesh;
var StaticMesh ForgeMenuSlotHighlightInsideMesh;
var StaticMesh ForgeMenuSlotHighlightOutsideMesh;

var transient HUD HUDOwner;

var() const float DistFromCamera;
var() const vector SelectedMeshOffset;
var transient int SelectedSlot;

//debug
var transient float LastInputAng;

var protected const string PlanSlotNames[ENanoPlanSlot.EnumCount];
var() protected const vector2d PlanSlotNameOffset;

var() protected const vector2d PlanNameTextOffset;
var() protected const vector2d PlanDescTextOffset;
var() protected const vector PlanIconOffset;

struct ForgeMenuSlot
{
	var StaticMeshComponent Mesh;
	var StaticMeshComponent HighlightOutsideMesh;
	var StaticMeshComponent HighlightInsideMesh;
	
	var StaticMeshComponent IconMesh;

	var int Roll;

	var class<NanoPlan> PlanClass;
	var ENanoPlanSlot PlanType;
};
var() protected array<ForgeMenuSlot> ForgeMenuSlots;

var() protected const color ForgeUITextColor;

var() protected const SoundCue SelectSoundCue;
var() protected const SoundCue MoveSoundCue;
var() protected const SoundCue MenuUpSoundCue;
var() protected const SoundCue MenuDownSoundCue;

function PostBeginPlay()
{
	local int Idx;
	local Rotator TmpRot;
	local StaticMeshComponent Mesh;

	Super.PostBeginPlay();

	for (Idx=0; Idx<ForgeMenuSlots.Length; ++Idx)
	{
		TmpRot.Roll = ForgeMenuSlots[Idx].Roll;
		
		// main bg mesh
		Mesh = new(self) class'StaticMeshComponent';
		Mesh.SetStaticMesh(ForgeMenuSlotBackgroundMesh);
		AttachComponent(Mesh);
		Mesh.SetRotation(TmpRot);
		Mesh.SetDepthPriorityGroup(SDPG_World);
		ForgeMenuSlots[Idx].Mesh = Mesh;

		// inner highlight
		Mesh = new(self) class'StaticMeshComponent';
		Mesh.SetStaticMesh(ForgeMenuSlotHighlightOutsideMesh);
		AttachComponent(Mesh);
		Mesh.SetRotation(TmpRot);
		Mesh.SetDepthPriorityGroup(SDPG_World);
		Mesh.SetHidden(true);
		ForgeMenuSlots[Idx].HighlightOutsideMesh = Mesh;

		// outer highlight
		Mesh = new(self) class'StaticMeshComponent';
		Mesh.SetStaticMesh(ForgeMenuSlotHighlightInsideMesh);
		AttachComponent(Mesh);
		Mesh.SetRotation(TmpRot);
		Mesh.SetDepthPriorityGroup(SDPG_World);
		Mesh.SetHidden(true);
		ForgeMenuSlots[Idx].HighlightInsideMesh = Mesh;

		// icon mesh
		Mesh = new(self) class'StaticMeshComponent';
		AttachComponent(Mesh);
		Mesh.SetTranslation(PlanIconOffset >> TmpRot);
		Mesh.SetDepthPriorityGroup(SDPG_Foreground);
		Mesh.SetHidden(true);
		ForgeMenuSlots[Idx].IconMesh = Mesh;
	}

	SetForgeMenuHidden(true);
}

function protected bool SlotPlanIsActive(int SlotIdx)
{
	local NanoPRI PRI;
	PRI = NanoPRI(HUDOwner.PlayerOwner.PlayerReplicationInfo);

	if ( (PRI != None) && (ForgeMenuSlots[SlotIdx].PlanClass != None) &&
		( ForgeMenuSlots[SlotIdx].PlanClass == PRI.GunPlan || 
		  ForgeMenuSlots[SlotIdx].PlanClass == PRI.MeleePlan || 
		  ForgeMenuSlots[SlotIdx].PlanClass == PRI.UtilityPlan )
		)
	{
		return TRUE;
	}

	return FALSE;
}

function SetForgeMenuHidden(bool bNewHidden)
{
	// indices into NanoPRI.OwnedPlans
	local int LastIdx[ENanoPlanSlot.EnumCount];
	local NanoPRI PRI;
	local int Idx, StartIdx, Jdx;

	// does this cover everything, so we can skip the per-component stuff?
	SetHidden(bNewHidden);

	if (bNewHidden)
	{
		Disable('Tick');
		PlaySound(MenuDownSoundCue);
	}
	else
	{
		Enable('Tick');
		PlaySound(MenuUpSoundCue);

		Super.PostBeginPlay();

		// populate menu
		PRI = NanoPRI(HUDOwner.PlayerOwner.PlayerReplicationInfo);

		// init array (compiler warns if you don't do this)
		for (Idx=0; Idx<EPS_MAX; ++Idx)
		{
			LastIdx[Idx] = 0;
		}

		for (Idx=0; Idx<ForgeMenuSlots.Length; ++Idx)
		{
			// find plan in inventory to put in the slot
			StartIdx = LastIdx[ForgeMenuSlots[Idx].PlanType];
			for (Jdx=StartIdx; Jdx<PRI.OwnedPlans.length; ++Jdx)
			{
				if ( ( PRI.OwnedPlans[Jdx].bUnlocked == TRUE )
					&& (PRI.OwnedPlans[Jdx].Plan.default.PlanSlot == ForgeMenuSlots[Idx].PlanType)
					)
				{
					ForgeMenuSlots[Idx].PlanClass = PRI.OwnedPlans[Jdx].Plan;
					LastIdx[ForgeMenuSlots[Idx].PlanType] = Jdx + 1;
					break;
				}
			}

			// start out unselected
			UnselectSlot(Idx);

			// set up icon meshes
			if ( (ForgeMenuSlots[Idx].PlanClass != None) && (ForgeMenuSlots[Idx].IconMesh != None) )
			{
				ForgeMenuSlots[Idx].IconMesh.SetStaticMesh(ForgeMenuSlots[Idx].PlanClass.default.ForgeUIData.UIMesh);

				// set the scale here
				ForgeMenuSlots[Idx].IconMesh.SetScale( ForgeMenuSlots[Idx].PlanClass.default.ForgeUIData.Scale );

				ForgeMenuSlots[Idx].IconMesh.SetRotation( ForgeMenuSlots[Idx].PlanClass.default.ForgeUIData.MeshRotation );

				ForgeMenuSlots[Idx].IconMesh.SetHidden( FALSE );

				// debug only
				ForgeMenuSlots[Idx].IconMesh.SetTranslation(PlanIconOffset >> ForgeMenuSlots[Idx].Mesh.Rotation);
	
				//`log( "RadialMenuDraw:" @ `showvar(ForgeMenuSlots[Idx].PlanType) @ `showvar(ForgeMenuSlots[Idx].PlanClass) @ `showvar(ForgeMenuSlots[Idx].IconMesh) @ `showvar(ForgeMenuSlots[Idx].PlanClass.default.ForgeUIData.UIMesh) @ `showvar(ForgeMenuSlots[Idx].PlanClass.default.ForgeUIData.Scale));
			}
		}
	}
}

function NormVect2d(out vector2d V)
{
	local float SquareSum, Mag;
	
	SquareSum = V.X*V.X + V.Y*V.Y;
	if( SquareSum > 0 )
	{
		Mag = Sqrt(SquareSum);
		V.X /= Mag;
		V.Y /= Mag;
	}
	else
	{
		V.X = 0;
		V.Y = 0;
	}
}

protected function UnselectSlot(int SlotIdx)
{
	local bool bActiveSlot;

	// move back
	ForgeMenuSlots[SlotIdx].Mesh.SetTranslation(vect(0,0,0));

	// highlight slot if it's active
	bActiveSlot = SlotPlanIsActive(SlotIdx);
	if (bActiveSlot)
	{
		ForgeMenuSlots[SlotIdx].HighlightOutsideMesh.SetHidden(false);
		ForgeMenuSlots[SlotIdx].HighlightOutsideMesh.SetTranslation(vect(0,0,0));
		ForgeMenuSlots[SlotIdx].HighlightInsideMesh.SetHidden(false);
		ForgeMenuSlots[SlotIdx].HighlightInsideMesh.SetTranslation(vect(0,0,0));
	}
	else
	{
		// hide highlight meshes
		ForgeMenuSlots[SlotIdx].HighlightOutsideMesh.SetHidden(true);
		ForgeMenuSlots[SlotIdx].HighlightInsideMesh.SetHidden(true);		
	}

	ForgeMenuSlots[SlotIdx].IconMesh.SetTranslation(PlanIconOffset >> ForgeMenuSlots[SlotIdx].Mesh.Rotation);
}

protected function SelectSlot(int SlotIdx)
{
	// move forward
	ForgeMenuSlots[SlotIdx].Mesh.SetTranslation(SelectedMeshOffset);

	// show highlight meshes
	ForgeMenuSlots[SlotIdx].HighlightOutsideMesh.SetHidden(false);
	ForgeMenuSlots[SlotIdx].HighlightOutsideMesh.SetTranslation(SelectedMeshOffset);
	ForgeMenuSlots[SlotIdx].HighlightInsideMesh.SetHidden(false);
	ForgeMenuSlots[SlotIdx].HighlightInsideMesh.SetTranslation(SelectedMeshOffset);

	ForgeMenuSlots[SlotIdx].IconMesh.SetTranslation((PlanIconOffset >> ForgeMenuSlots[SlotIdx].Mesh.Rotation) + SelectedMeshOffset);
}

protected function SetSelectedSlot(int SlotIdx)
{
	if (SelectedSlot != SlotIdx)
	{
		UnselectSlot(SelectedSlot);
		SelectSlot(SlotIdx);
		SelectedSlot = SlotIdx;

		PlaySound(MoveSoundCue, TRUE);
	}
}

function Tick( float DeltaTime )
{
	local vector CamLoc;
	local rotator CamRot;
	local int Idx, MinIdx;
	local float RollRad, DeltaAng, MinDeltaAng;
	local vector2d InputVector;
	local float InputAngRad;

	if (bHidden)
	{
		return;
	}

	Super.Tick(DeltaTime);

	HUDOwner.PlayerOwner.GetPlayerViewPoint(CamLoc, CamRot);
	SetLocation(CamLoc + vector(CamRot) * DistFromCamera);
	SetRotation(CamRot);

//	DrawDebugBox(Location, vect(8,8,8), 255, 255, 0, FALSE);

	InputVector.X = HUDOwner.PlayerOwner.PlayerInput.RawJoyLookRight;
	InputVector.Y = HUDOwner.PlayerOwner.PlayerInput.RawJoyLookUp;
	NormVect2d(InputVector);

	if (InputVector.X != 0.f || InputVector.Y != 0.f)
	{
		// possible selection change!
		InputAngRad = ACos(-InputVector.Y);
 		if (InputVector.X < 0.f)
 		{
 			InputAngRad = -InputAngRad;
 		}

		// find closest (min delta angle)
		MinDeltaAng = 99999.f;
		MinIdx = INDEX_NONE;
		for (Idx=0; Idx<ForgeMenuSlots.length; ++Idx)
		{
			RollRad = ForgeMenuSlots[Idx].Roll * UnrRotToRad;
			DeltaAng = Abs(FindDeltaAngle(InputAngRad, RollRad));

			if (DeltaAng < MinDeltaAng)
			{
				MinDeltaAng = DeltaAng;
				MinIdx = Idx;
			}
		}

		LastInputAng = InputAngRad;
		SetSelectedSlot(MinIdx);
	}
}

function DrawHUDElements()
{
	if (!bHidden)
	{
		// set text to draw
		// slot type name
		HUDOwner.DrawText(PlanSlotNames[ForgeMenuSlots[SelectedSlot].PlanType], PlanSlotNameOffset, Font'EngineFonts.SmallFont', vect2d(1,1), ForgeUITextColor);
		if (ForgeMenuSlots[SelectedSlot].PlanClass != None)
		{
			// plan name
			HUDOwner.DrawText(ForgeMenuSlots[SelectedSlot].PlanClass.default.ForgeUIData.PlanName, PlanNameTextOffset, Font'EngineFonts.SmallFont', vect2d(0.8,0.8), ForgeUITextColor);
			// plan desc
			HUDOwner.DrawText(ForgeMenuSlots[SelectedSlot].PlanClass.default.ForgeUIData.PlanDescription, PlanDescTextOffset, Font'EngineFonts.SmallFont', vect2d(0.6,0.6), ForgeUITextColor);
		}
	}

	//ClientDrawKismetText(KismetDrawTextInfo DrawTextInfo, float DisplayTime)
	// "RANGED WEAPONS", "MELEE WEAPONS", "FREE FORGE"		Font'EngineFonts.MediumFont'
	// description, mediumfont, scale 0.625
	// weapon name, mediumfont, scale 0.75
}

function class<NanoPlan> GetSelectedPlan()
{
	return ForgeMenuSlots[SelectedSlot].PlanClass;
}

defaultproperties
{
	ForgeMenuSlotBackgroundMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegment'
	ForgeMenuSlotHighlightOutsideMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegmentHiLightOutside'
	ForgeMenuSlotHighlightInsideMesh=StaticMesh'UI_HUD.Forge.M_ForgeGridSegmentHiLightInside'
	DistFromCamera=350

	// -6144 gaps
// 	ForgeMenuSlots.Add((Roll=4028,PlanType=EPS_Melee))			// ur left
// 	ForgeMenuSlots.Add((Roll=10172,PlanType=EPS_Melee))			// ur center
// 	ForgeMenuSlots.Add((Roll=16316,PlanType=EPS_Melee))			// ur right
// 	ForgeMenuSlots.Add((Roll=-26848,PlanType=EPS_Utility))		// bottom left
// 	ForgeMenuSlots.Add((Roll=32544,PlanType=EPS_Utility))		// bottom center
// 	ForgeMenuSlots.Add((Roll=26400,PlanType=EPS_Utility))		// bottom right
// 	ForgeMenuSlots.Add((Roll=-17624,PlanType=EPS_Gun))			// ul left
// 	ForgeMenuSlots.Add((Roll=-11480,PlanType=EPS_Gun))			// ul center
// 	ForgeMenuSlots.Add((Roll=-5336,PlanType=EPS_Gun))			// ul center

	// experiment: all forge on this menu, and all weapons on the dpad-up menu (nanohudelement_weaponselect)
	ForgeMenuSlots.Add((Roll=5120,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=11264,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=17408,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=23552,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=29696,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=35840,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=41984,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=48128,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=54272,PlanType=EPS_Utility))	
	ForgeMenuSlots.Add((Roll=60416,PlanType=EPS_Utility))	

	SelectedMeshOffset=(X=-40)

	SelectSoundCue=SoundCue'Interface_Audio.Menu.G2UI_LobbyScreenSlideBack01Cue'
	MoveSoundCue=SoundCue'Interface_Audio.Menu.G2UI_LobbyCharacterSelect01Cue'
	MenuUpSoundCue=SoundCue'Interface_Audio.Menu.MenuWhooshUp01Cue'
	MenuDownSoundCue=SoundCue'Interface_Audio.Menu.MenuWhooshDown01Cue'

	PlanSlotNames[EPS_Gun]="RANGED WEAPONS"
	PlanSlotNames[EPS_Melee]="MELEE WEAPONS"
	PlanSlotNames[EPS_Utility]="FREE FORGE"

	PlanSlotNameOffset=(X=0,Y=50)
	PlanNameTextOffset=(X=0,Y=80)
	PlanDescTextOffset=(X=0,Y=150)
	ForgeUITextColor=(R=255,G=255,B=255,A=255)
	PlanIconOffset=(X=80,Z=140)


}
