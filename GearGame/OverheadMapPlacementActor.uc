/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OverheadMapPlacementActor extends Actor
	native(Camera)
	autoexpandcategories(OverheadMapPlacementActor)
	placeable;

var() Texture2D MapTexture;

var transient MaterialInstanceConstant MIC_MapMaterial;

var protected SpriteComponent EditorSprite;

var() editoronly transient bool bEditorPreview;
var() editoronly float EditorPreviewOpacity<ClampMin=0.0 | ClampMax=1.0>;

/** The scaling factor for the map is stored in the Z component, the X and Y are world space offsets */
var() protected vector WorldOffset;

var(Debug) editoronly protected StaticMeshComponent EditorPreviewMesh;

/** The icon to draw for pawns */
var CanvasIcon PawnIcon;
var protected const float PawnIconScale;

/** The icon to draw for leaders */
var CanvasIcon COGLeaderIcon;
/** The icon to draw for leaders */
var CanvasIcon LocustLeaderIcon;

var protected const Texture2D GoalRingTexture;
var protected const float GoalRingIconScale;

/** The color to draw our arrow */
var protected const color SelfArrowColor;

var protected const color COGTeamColor;
var protected const color COGTeamColor_DBNO;
var protected const color LocustTeamColor;
var protected const color LocustTeamColor_DBNO;
var protected const color WeaponPickupColor;
var protected const color COGRingColor;
var protected const color LocustRingColor;
var protected const color NeutralRingColor;

var protected const float WeaponIconScale;

/** True if MapTexture isn't 16x9 but is intended to be stretched to that aspect ratio. */
var() protected const bool bForceTextureTo16by9;

var localized string MatchBeginText;

/** Texture for the b button */
var Texture2D BButtonImage;

/** Text to draw for b button */
var localized string CloseText;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
#if WITH_EDITOR
	virtual void EditorApplyScale(const FVector& DeltaScale, const FMatrix& ScaleMatrix, const FVector* PivotLocation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown);
	virtual void EditorApplyRotation(const FRotator& DeltaRotation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown);
#endif
};

simulated event PostBeginPlay()
{
	if (class'Engine'.static.IsEditor())
	{
		UpdateEditorPreview();
	}

	Super.PostBeginPlay();
}

native protected function UpdateEditorPreview();

simulated protected function vector2d GetMapPosFromWorldPos(vector WorldPos, float MapScale)
{
	local vector2d MapPos;
	local vector LocalPos;

	LocalPos = ((WorldPos - Location) << Rotation) + WorldOffset;

	LocalPos /= DrawScale;
	LocalPos /= WorldOffset.Z;

	LocalPos.X /= DrawScale3D.X;
	LocalPos.Y /= DrawScale3D.Y;

	MapPos.X = LocalPos.X * MapTexture.SizeX * MapScale + MapTexture.SizeX * MapScale / 2.f;
	MapPos.Y = LocalPos.Y * MapTexture.SizeY * MapScale + MapTexture.SizeY * MapScale / 2.f;

	return MapPos;

}

// find UL coord to draw this icon
simulated protected function vector2d GetIconPos(Texture2D Icon, float IconScale, vector2d PosOnMap, vector2d MapCoords, optional float IconUL, optional float IconVL)
{
	local vector2d IconPos;

	if (IconUL == 0.f)
	{
		IconUL = Icon.GetSurfaceWidth();
	}
	if (IconVL == 0.f)
	{
		IconVL = Icon.GetSurfaceHeight();
	}

	IconPos.X = PosOnMap.X + MapCoords.X - IconUL * IconScale / 2;
	IconPos.Y = PosOnMap.Y + MapCoords.Y - IconVL * IconScale / 2;
	return IconPos;
}

/** syntactic sugar */
simulated private function SetDrawColor(Canvas Canvas, Color Col)
{
	Canvas.SetDrawColor(Col.R, Col.G, Col.B, Col.A);
}

simulated function DrawOverheadMap(HUD HUD)
{
	local Canvas Canvas;
	local GearPawn GP;
	local int TeamIdx;
	local rotator IconRotation;
	local vector2d PosOnMap;
	local vector2d IconPos;
	local GearGRI GRI;
	local GearGRI_MP GRI_MP;
	local GearGRI_Horde GRI_Horde;
	local GearWeaponPickupFactory WeapPickup;
	local class<GearShield> ShieldClass;
	local CanvasIcon Icon;
	local vector2d MapCoords;
	local int i;
	local float XL, YL;
	local float MapXL, MapYL;
	local float AspectRatio, MapScale, LocationNameScale;
	local OverheadMapLocation NamedLocation;
	local FontRenderInfo FRI;
	local color CountdownColor;
	local float ExitButtonScale;
	local GearMapSpecificInfo GearMapInfo;
	local GearPRI PRI;

	if (MapTexture != None)
	{
		Canvas = HUD.Canvas;

		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		FRI = Canvas.CreateFontRenderInfo(FALSE, TRUE);

		// Wipe the background
		Canvas.SetPos(0, 0);
		Canvas.SetDrawColor(0,0,0,255);
		Canvas.DrawRect(Canvas.SizeX, Canvas.SizeY);

		// draw the actual map
		AspectRatio = MapTexture.GetSurfaceWidth() / MapTexture.GetSurfaceHeight();

		MapYL = Canvas.SizeY;
		MapXL = MapYL * AspectRatio;
		
		MapScale = MapYL / MapTexture.GetSurfaceHeight();

		MapCoords.X = (Canvas.SizeX - MapXL) * 0.5f;
		MapCoords.Y = (Canvas.SizeY - MapYL) * 0.5f;
		Canvas.SetPos(MapCoords.X, MapCoords.Y);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawTile(MapTexture, MapXL, MapYL, 0, 0, MapTexture.GetSurfaceWidth(), MapTexture.GetSurfaceHeight());

		ExitButtonScale = Canvas.SizeY / 720.0f;
		Canvas.TextSize(CloseText, XL, YL);
		Canvas.SetPos(Canvas.SizeX - 100 - XL * ExitButtonScale, Canvas.SizeY - 100);
		Canvas.DrawTexture(BButtonImage, ExitButtonScale);
		Canvas.SetPos(Canvas.SizeX - 100 - (XL - BButtonImage.GetSurfaceWidth()) * ExitButtonScale, Canvas.SizeY - 100 + (BButtonImage.GetSurfaceHeight() - YL) / 2.0f * ExitButtonScale);
		Canvas.DrawText(CloseText, false, ExitButtonScale, ExitButtonScale, FRI);

		GearMapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
		if (GearMapInfo != None && GearMapInfo.MapLocations.length > 0)
		{
			foreach GearMapInfo.MapLocations(NamedLocation)
			{
				// StringScale was chosen with a 720 pixel high map in mind
				LocationNameScale = NamedLocation.StringScale * (MapYL / 720.0f);

				PosOnMap = GetMapPosFromWorldPos(NamedLocation.Location, MapScale);
				Canvas.TextSize(NamedLocation.LocationName, XL, YL);
				Canvas.SetPos(PosOnMap.X + MapCoords.X - XL * LocationNameScale / 2.0f, PosOnMap.Y + MapCoords.Y - YL * LocationNameScale / 2.0f);
				SetDrawColor(Canvas, NamedLocation.StringColor);
				Canvas.DrawText(NamedLocation.LocationName, false, LocationNameScale, LocationNameScale, FRI);
			}
			CountdownColor = Canvas.DrawColor;
		}
		else
		{
			CountdownColor = class'GearHUD_Base'.default.HudColors[eWARHUDCOLOR_WHITE];
		}

		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None && GRI.GameStatus != GS_WaitingForHost)
		{
			if (class<GearGame>(GRI.GameClass).default.bShouldDisplayWeaponPickupsViaTaccom)
			{
				// show all weapon pickup locs
				SetDrawColor(Canvas, WeaponPickupColor);
				foreach GRI.WeaponPickups(WeapPickup)
				{
					if (WeapPickup.bSkipOverheadmapDisplay)
					{
						continue;
					}

					Icon.Texture = None;

					PosOnMap = GetMapPosFromWorldPos(WeapPickup.Location, MapScale);

					if (WeapPickup.WeaponPickupClass != None)
					{
						Icon = WeapPickup.WeaponPickupClass.default.WeaponIcon;
					}
					else if (WeapPickup.PlaceholderClass != None)
					{
						ShieldClass = class<GearShield>(WeapPickup.PlaceholderClass);
						if (ShieldClass != None)
						{
							Icon = ShieldClass.default.PickupIcon;
						}
					}

					if (Icon.Texture != None)
					{
						IconPos = GetIconPos(Texture2D(Icon.Texture), WeaponIconScale, PosOnMap, MapCoords, Icon.UL, Icon.VL);
						Canvas.DrawIcon(Icon, IconPos.X, IconPos.Y, WeaponIconScale);
					}
				}
			}

			// show all active ring locations
			GRI_MP = GearGRI_MP(GRI);
			GRI_Horde = GearGRI_Horde(GRI);

			if (GRI_Horde != None)
			{
				for (i = 0; i < GRI_Horde.FortificationMarkersFlags.Length; i++)
				{
					if (GRI_Horde.FortificationMarkersFlags[i].SpawnedFortification != None)
					{
						SetDrawColor(Canvas, COGRingColor);
					}
					else
					{
						SetDrawColor(Canvas, NeutralRingColor);
					}

					PosOnMap = GetMapPosFromWorldPos(GRI_Horde.FortificationMarkersFlags[i].Location, MapScale);
					IconPos = GetIconPos(GoalRingTexture, GoalRingIconScale * 0.5f, PosOnMap, MapCoords);
					Canvas.SetPos(IconPos.X, IconPos.Y);
					Canvas.DrawTexture(GoalRingTexture, GoalRingIconScale * 0.5f);
				}
			}
			else if (GRI_MP != None && GRI_MP.CommandPoint != None)
			{
				// annex or koth ring
				switch (GRI_MP.CPControlTeam)
				{
				case 0:
					SetDrawColor(Canvas, COGRingColor);
					break;
				case 1:
					SetDrawColor(Canvas, LocustRingColor);
					break;
				default:
					SetDrawColor(Canvas, NeutralRingColor);
				}

				PosOnMap = GetMapPosFromWorldPos(GRI_MP.CommandPoint.Location, MapScale);
				IconPos = GetIconPos(GoalRingTexture, GoalRingIconScale, PosOnMap, MapCoords);
				Canvas.SetPos(IconPos.X, IconPos.Y);
				Canvas.DrawTexture(GoalRingTexture, GoalRingIconScale);
			}

			if (GRI.GameStatus == GS_PreMatch)
			{
				Canvas.SetPos(96, 72); // safezone top left
				Canvas.DrawColor = CountdownColor;
				Canvas.DrawText(MatchBeginText @ GRI.RoundTime,,,, FRI);
			}
		}


		// show all alive pawns
		foreach WorldInfo.AllPawns(class'GearPawn', GP)
		{
			if (GP.IsAliveAndWell() || GP.IsDBNO())
			{
				TeamIdx = GP.GetTeamNum();

				PRI = GearPRI(GP.PlayerReplicationInfo);
				if (HUD.PlayerOwner.GetTeamNum() == 255 || HUD.PlayerOwner.GetTeamNum() == TeamIdx || GP.SpottedByTeam[TeamIdx] > 0 || PRI.bIsLeader)
				{					
					PosOnMap = GetMapPosFromWorldPos(GP.Location, MapScale);
					IconRotation.Yaw = GP.Rotation.Yaw - Rotation.Yaw;

					// If the map isn't flipped, flip the yaw
					if (WorldOffset.Z >= 0)
					{
						IconRotation.Yaw += 32768;
					}

					if (PRI.bIsLeader)
					{
						SetDrawColor(Canvas, SelfArrowColor);
						IconPos = GetIconPos(Texture2D(COGLeaderIcon.Texture), 1, PosOnMap, MapCoords, COGLeaderIcon.UL, COGLeaderIcon.VL);
						Canvas.SetPos(IconPos.X, IconPos.Y);

						if (TeamIdx == 0)
						{
							Canvas.DrawRotatedTile(COGLeaderIcon.Texture, IconRotation, COGLeaderIcon.UL, COGLeaderIcon.VL, COGLeaderIcon.U, COGLeaderIcon.V, COGLeaderIcon.UL, COGLeaderIcon.VL);
						}
						else
						{
							Canvas.DrawRotatedTile(LocustLeaderIcon.Texture, IconRotation, LocustLeaderIcon.UL, LocustLeaderIcon.VL, LocustLeaderIcon.U, LocustLeaderIcon.V, LocustLeaderIcon.UL, LocustLeaderIcon.VL);
						}				
					}
					else
					{
						if (GP.Controller == HUD.PlayerOwner)
						{
							SetDrawColor(Canvas, SelfArrowColor);
						}
						else if (GP.IsAliveAndWell())
						{
							switch (TeamIdx)
							{
							case 0:
								SetDrawColor(Canvas, COGTeamColor);
								break;
							case 1:
								SetDrawColor(Canvas, LocustTeamColor);
								break;
							}
						}
						else if (GP.IsDBNO())
						{
							switch (TeamIdx)
							{
							case 0:
								SetDrawColor(Canvas, COGTeamColor_DBNO);
								break;
							case 1:
								SetDrawColor(Canvas, LocustTeamColor_DBNO);
								break;
							}
						}

						IconPos = GetIconPos(Texture2D(PawnIcon.Texture), 1, PosOnMap, MapCoords, PawnIcon.UL, PawnIcon.VL);

						Canvas.SetPos(IconPos.X, IconPos.Y);
						Canvas.DrawRotatedTile(PawnIcon.Texture, IconRotation, PawnIcon.UL, PawnIcon.VL, PawnIcon.U, PawnIcon.V, PawnIcon.UL, PawnIcon.VL);
					}
				}
			}
		}
	}
}

defaultproperties
{
	GoalRingTexture=Texture2D'Warfare_HUD.Location.T_Overhead_Map_Location_02'

	PawnIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=357,UL=30,VL=30)
	LocustLeaderIcon=(Texture=Texture2D'Warfare_HUD.HUD.HUD_Leader_Locust',U=0,V=0,UL=32,VL=32)
	COGLeaderIcon=(Texture=Texture2D'Warfare_HUD.HUD.HUD_Leader_COG',U=0,V=0,UL=32,VL=32)

	SelfArrowColor=(R=255,G=255,B=255,A=255)
	COGTeamColor=(R=64,G=64,B=220,A=255)
	COGTeamColor_DBNO=(R=140,G=140,B=255,A=120)
	COGRingColor=(R=150,G=150,B=255,A=255)
	LocustTeamColor=(R=220,G=64,B=64,A=255)
	LocustTeamColor_DBNO=(R=64,G=16,B=16,A=96)
	LocustRingColor=(R=170,G=10,B=10,A=255)
	NeutralRingColor=(R=200,G=200,B=200,A=255)

	WeaponPickupColor=(R=255,G=255,B=64,A=255)

	EditorPreviewOpacity=0.5f

	WeaponIconScale=0.4f
	PawnIconScale=0.125f
	GoalRingIconScale=0.35f

	WorldOffset=(Z=320.0f)

	// note this is 320x320
	Begin Object Class=StaticMeshComponent Name=EditorPreviewSM0
		StaticMesh=StaticMesh'EngineResources_Gears.OverheadMapPlacementActorMesh'
		HiddenGame=TRUE
		HiddenEditor=TRUE
		CollideActors=FALSE
		BlockRigidBody=FALSE
		CastShadow=FALSE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		Rotation=(Pitch=16384,Yaw=16384)
	End Object
	EditorPreviewMesh=EditorPreviewSM0
	Components.Add(EditorPreviewSM0)

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	EditorSprite=Sprite
	Components.Add(Sprite)

	BButtonImage=Texture2D'Warfare_HUD.HUD_Dir_ButtonB'

	bStatic=true
	bNoDelete=true
}
