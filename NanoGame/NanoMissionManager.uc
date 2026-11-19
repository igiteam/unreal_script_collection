/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMissionManager extends Actor;

/** Information about a particular mission */
struct native MissionInfo
{
	var transient SeqAct_NanoMission	MissionAction;
	var transient SeqAct_NanoMission	ParentMission;

	var transient array<NanoInterface_Objective>	RadarObjectives;
};

/** Set of all missions that are currently active */
var transient array<MissionInfo> Missions;

/** Currently selected mission - this will show on radar */
var transient SeqAct_NanoMission SelectedMission;

/** Additional Objectives that are not from a specific Mission **/
var transient array<NanoInterface_Objective>	AdditionalRadarObjectives;

/** 
 *	Mapping from the display order of mission to their index in the Missions array.
 *	This is used by UI code to handle selection
 */
var transient array<int>	DisplayToMissionMap;

/** Where cursor is to select missions */
var transient int	SelectedRow;

/** location of NW corner of map */
var transient vector2D NWMapPos;
/** location of SE corner of map */
var transient vector2D SEMapPos;

/** Origin for whole window */
var() vector2D	ManagerUIOrigin;

/** Info used to draw the map when mission manager is up */
var MinimapDrawInfo MapDrawInfo;

var Texture2D   MapCrosshairTex;

/** Currently set waypoint. If empty, will be spawned when one is placed. */
var NanoPlayerWaypoint WaypointActor;

/** How fast to pan map using the left joystick */
var float MapPanSpeed;
/** How fast to zoom the map using right joystick */
var float MapZoomSpeed;
/* Current pan offset (from player location) */
var vector MapPanOffset;

// Colors used by menu
var	LinearColor	MenuBG_LColor;
var Color       MenuCarat_Color;
var	Color		MenuText_Color;
var	Color		MenuText_ActiveColor;

var Material	Map_Background;
var Texture2D   ManagerUITabTex;


var transient MaterialInstance	ObjMI, ActiveObjMI, PlayerMI, BackgroundMI;

var()	float	MapFadeTime;
var	transient float	TargetMapOpacity;

/**  */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	BackgroundMI = new(self) class'MaterialInstanceConstant';
	BackgroundMI.SetParent(Map_Background);
	BackgroundMI.SetScalarParameterValue('IngameMenuOpacity', 0.0);
}

/** Update top-left and bottom-right map positions in world space, using map anchor actors*/
simulated function OnMenuOpened(NanoHUD_Base HUD)
{
	// Also re-zero the current map pan, so it always start centered on you
	MapPanOffset = vect(0,0,0);

	// reset zoom
	MapDrawInfo.MinimapToWorldScale = default.MapDrawInfo.MinimapToWorldScale;
}

/** Add a mission to the manager, as a child of the supplied ParentMission. **/
simulated function AddMission( SeqAct_NanoMission MissionAct, SeqAct_NanoMission ParentMission )
{
	local int MissionIdx;

	`log("MM: Adding Mission"@MissionAct@"(Parent:"@ParentMission@")");

	MissionIdx = Missions.Find( 'MissionAction', MissionAct);

	if( MissionIdx == INDEX_NONE )
	{
		MissionIdx = Missions.Add(1);

		Missions[MissionIdx].MissionAction = MissionAct;
		Missions[MissionIdx].ParentMission = ParentMission;

		NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( MissionAct.MissionName, MissionAct.DurationMissionNameStaysOnScreen, class'Engine'.static.GetLargeFont(), None  );


		// If no mission selected, or this is a child of current mission - make this new one selected
		if(SelectedMission == none || SelectedMission == ParentMission)
		{
			SelectedMission = MissionAct;
		}
	}
}

/** Remove a mission from the set of active ones */
simulated function RemoveMission( SeqAct_NanoMission MissionAct )
{
	local int MissionIdx;

	// Find this mission in the array and remove the entry
	MissionIdx = Missions.Find( 'MissionAction', MissionAct );
	if( MissionIdx != INDEX_NONE )
	{
		Missions.Remove( MissionIdx, 1 );
	}

	// Clear selection if this was it
	if(SelectedMission == MissionAct)
	{
		SelectedMission = none;
	}
}

/** Utility which finds the indices of sub-missions of supplied parent */
simulated function array<int> GetChildrenMissions(SeqAct_NanoMission ParentMission)
{
	local int Idx;
	local array<int> OutChildIndices;

	for (Idx = 0; Idx < Missions.Length; Idx++)
	{
		if(Missions[Idx].ParentMission == ParentMission)
		{
			OutChildIndices.AddItem(Idx);
		}
	}

	return OutChildIndices;
}

/** Change the currently active mission */
simulated function SetSelectedMission(SeqAct_NanoMission MissionAction)
{
	SelectedMission = MissionAction;
}

/** Drop a waypoint at the current center of the map */
simulated function SetWaypoint()
{
	local vector HitLoc, HitNorm, TraceStart, TraceEnd;
	local Actor HitActor;

	if(WaypointActor == None)
	{
		WaypointActor = Spawn(class'NanoGame.NanoPlayerWaypoint');
	}

	// we are spawning this in the world as it now has a mesh for IRIS to show in world

	TraceStart = MapDrawInfo.MinimapLocation;
	TraceStart.Z = 20000;

	TraceEnd = TraceStart;
	TraceEnd.Z = 0;

	HitActor = Trace( HitLoc, HitNorm, TraceEnd, TraceStart,,,, class'Actor'.const.TRACEFLAG_Bullet );
	//DrawDebugLine(HitLoc,TraceStart,0,255,0,TRUE);

	if( HitActor != None )
	{
		//DrawDebugCoordinateSystem( HitLoc, rot(0,0,0), 10.0f, TRUE );
		WaypointActor.SetLocation(HitLoc);
		WaypointActor.SetHidden( FALSE );
	}
	else
	{
		WaypointActor.SetLocation(MapDrawInfo.MinimapLocation);
	}

	//`log( `showvar(MapDrawInfo.MinimapLocation) @ `showvar(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location) @ `showvar(WaypointActor.Location) );
}

/** Clear currently set waypoint */
simulated function ClearWaypoint()
{
	if(WaypointActor != None)
	{
		WaypointActor.Destroy();
		WaypointActor = None;
	}
}

/** Mission screen controls */
simulated function HandleMenuInput(Name ButtonName)
{
	switch( ButtonName )
	{
	case 'DPad_Up':
		SelectedRow = Max(SelectedRow-1, 0);
		break;

	case 'DPad_Down':
		SelectedRow = Min(SelectedRow+1, DisplayToMissionMap.length-1);
		break;

	case 'A':
		SetSelectedMission( Missions[DisplayToMissionMap[SelectedRow]].MissionAction );
		break;

	case 'X':
		SetWaypoint();
		break;

	case 'Y':
		ClearWaypoint();
		break;
	}
}


/** Draw one mission onto the HUD */
simulated function DrawMissionHUD(NanoHUD_Base HUD, int MissionIndex, float DrawX)
{
	local SeqAct_NanoMission Mission;
	local array<int> ChildMissions;
	local int Idx, RowNum;
	local color RowColor;

	Mission = Missions[MissionIndex].MissionAction;
	RowNum = DisplayToMissionMap.length;

	// Draw carat if selected row
	if(RowNum == SelectedRow)
	{
		HUD.Canvas.SetPos(ManagerUIOrigin.X+30, ManagerUIOrigin.Y+30+(20*RowNum)-4);
		HUD.Canvas.SetDrawColor(MenuCarat_Color.R, MenuCarat_Color.G, MenuCarat_Color.B);
		HUD.Canvas.DrawTile(ManagerUITabTex, 11,22, 339,2, 11,22);
	}

	// Draw this mission info
	RowColor = (Missions[MissionIndex].MissionAction == SelectedMission) ? MenuText_ActiveColor : MenuText_Color;
	HUD.Canvas.SetDrawColor(RowColor.R, RowColor.G, RowColor.B, 255);
	HUD.Canvas.SetPos(DrawX, ManagerUIOrigin.Y+30+(20*RowNum));

	// Draw info - dont show time if no limit
	if(Mission.DurationAllowed < 0.01)
	{
		HUD.Canvas.DrawText(Mission.MissionDescription,,,, HUD.TextRenderInfo);
	}
	else
	{
		HUD.Canvas.DrawText(Mission.MissionDescription@"["$HUD.FormatTime(Mission.TimerCount)$"]",,,, HUD.TextRenderInfo);
	}

	// Add to row mapping
	DisplayToMissionMap.AddItem(MissionIndex);

	// Then iterate over child missions
	ChildMissions = GetChildrenMissions(Mission);
	for (Idx = 0; Idx < ChildMissions.Length; Idx++)
	{
		DrawMissionHUD(HUD, ChildMissions[Idx], DrawX+15);
	}

}


/** Draw info about all missions onto the in-game hud */
simulated function DrawAllMissionHUDInfo(NanoUIPage_Map MapPage)
{
	local int Idx;
	local float DrawX;
	local vector2d CenterMapLoc;
	local NanoHUD_Base HUD;
	local NanoPawn NP;

	HUD = MapPage.NanoHUD;
	NP = MapPage.GetNanoPawn();

	TargetMapOpacity = 1.0;
	BackgroundMI.SetScalarParameterValue('IngameMenuOpacity', TargetMapOpacity);

	// Draw background
	HUD.Canvas.SetPos(ManagerUIOrigin.X, ManagerUIOrigin.Y);
	HUD.Canvas.SetDrawColor(255, 255, 255, 255);
	HUD.Canvas.DrawMaterialTile(BackgroundMI, 1024, 512, 0, 0, 1, 1);

	MapPage.DrawInGameTabBar(ManagerUIOrigin.X, ManagerUIOrigin.Y, 0);

	// Draw map
	MapDrawInfo.MinimapLocation = NP.Location + MapPanOffset;
	MapDrawInfo.MinimapLocation.Z = 0.0;
	HUD.MinimapHUDElement.DrawHUDElements(HUD.Canvas, MapDrawInfo);

	// Draw crosshair in middle of map
	HUD.MinimapHUDElement.CalcMiniMapLocation(HUD.Canvas, MapDrawInfo, MapDrawInfo.MinimapLocation, CenterMapLoc, FALSE);
	HUD.MinimapHUDElement.DrawTextureCentered(HUD.Canvas, MapDrawInfo, MapCrosshairTex, CenterMapLoc, 0.1 );

	// Init numbers
	DrawX = ManagerUIOrigin.X + 50;
	DisplayToMissionMap.length = 0;

	// Then draw missions
	HUD.Canvas.Font = class'Engine'.static.GetSmallFont();
	for (Idx = 0; Idx < Missions.Length; Idx++)
	{
		// Look for active, top-level mission
		if( (Missions[Idx].ParentMission == None) )
		{
			DrawMissionHUD(HUD, Idx, DrawX);
		}
	}
}

/** Return all objectives for the current active mission that should appear on the radar */
simulated function array<NanoInterface_Objective> GetActiveMissionObjectives()
{
	local array<NanoInterface_Objective> Objectives;
	local int Idx, TempIdx;

	for(Idx=0; Idx<Missions.length; Idx++)
	{
		if(Missions[Idx].MissionAction == SelectedMission)
		{
			// No += operator for arrays (boooo) so add each element
			for(TempIdx=0; TempIdx<Missions[Idx].RadarObjectives.length; TempIdx++)
			{
				Objectives.AddItem(Missions[Idx].RadarObjectives[TempIdx]);
			}
		}
	}

	// add all of the additional objectives that have been added to the MissionManager
	for( Idx = 0; Idx < AdditionalRadarObjectives.length; Idx++ )
	{
		Objectives.AddItem( AdditionalRadarObjectives[Idx] );
	}

	return Objectives;
}

/** Called when menu is not supposed to be shown, to fade out menu */
simulated function UpdateHidingState(NanoHUD_Base HUD)
{
	local float FadeAmount;

	TargetMapOpacity = 0.0;

	// If still visible, draw background
	BackgroundMI.GetScalarParameterValue('IngameMenuOpacity', FadeAmount);
	if(FadeAmount > 0.01)
	{
		HUD.Canvas.SetPos(ManagerUIOrigin.X, ManagerUIOrigin.Y);
		HUD.Canvas.SetDrawColor(255, 255, 255, 255);
		HUD.Canvas.DrawMaterialTile(BackgroundMI, 1024, 512, 0, 0, 1, 1);
	}
}

/** Update map opacity for fading in/out */
simulated event Tick(float DeltaSeconds)
{
	local float FadeAmount, Delta, MaxChange;
	local NanoPC NPC; 
	local NanoHUD_Base NanoHUD;

	Super.Tick(DeltaSeconds);

	BackgroundMI.GetScalarParameterValue('IngameMenuOpacity', FadeAmount);

	MaxChange = (DeltaSeconds / MapFadeTime);
	Delta = FClamp(TargetMapOpacity - FadeAmount, -MaxChange, MaxChange);
	BackgroundMI.SetScalarParameterValue('IngameMenuOpacity', FadeAmount + Delta);


	NPC = NanoGRI(WorldInfo.GRI).GetNanoPC();
	NanoHUD = NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD);

	if( NanoUIPage_Map(NanoHUD.GetCurrentUIPage()) != None )
	{
		MapPanOffset.Y += (DeltaSeconds * MapPanSpeed * NPC.PlayerInput.RawJoyRight);
		MapPanOffset.X += (DeltaSeconds * MapPanSpeed * NPC.PlayerInput.RawJoyUp);

		MapDrawInfo.MinimapToWorldScale += (DeltaSeconds * MapZoomSpeed * NPC.PlayerInput.RawJoyLookUp);
		MapDrawInfo.MinimapToWorldScale = FClamp(MapDrawInfo.MinimapToWorldScale, 10.0, 300.0);
	}
}

defaultproperties
{
	MapDrawInfo=(Minimap_UL=(X=0.461,Y=0.108),MinimapSize=(X=0.345,Y=0.345),MinimapToWorldScale=150.0,bDrawBorder=FALSE,bEnableAboveBelowIcons=FALSE)
	MapPanSpeed=20000.0
	MapZoomSpeed=100.0

	bMovable=FALSE
	bCanBeDamaged=FALSE
	bReplicateMovement=FALSE
	bAlwaysRelevant=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysTick=TRUE

	ManagerUIOrigin=(X=128,Y=104)

	MapFadeTime=0.25

	MenuBG_LColor=(R=0.0,G=0.25,B=0.4,A=0.5)
	MenuCarat_Color=(R=25,G=25,B=230,A=255)
	MenuText_Color=(R=220,G=220,B=220)
	MenuText_ActiveColor=(R=220,G=64,B=64)

	Map_Background=Material'Nano_ProtoHUD_Ingame.M_UI_HUD_Ingame_Menu_Background'
	ManagerUITabTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'
	MapCrosshairTex=Texture2D'UI_HUD.MiniMap.MapCrosshair'
}
