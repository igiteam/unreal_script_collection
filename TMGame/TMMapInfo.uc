/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMMapInfo extends MapInfo
	dependson(TMMapMusicInfo)
	native;

/** recommended player count range - for display on the UI and the auto number of bots setting */
var() int RecommendedPlayersMin, RecommendedPlayersMax;

/** This is stored in a content package and then pointed to by the map **/
var() TMMapMusicInfo MapMusicInfo;

/** This is stored Current TaskTipHud **/
var HDGFxTaskTipHud CurrentTaskTipHud;
var bool bTaskTipAutoClose;
var array <int> TaskTipType;

/** modifier to visibility/range calculations for AI (0 to 1) */
var() float VisibilityModifier;

/*********************  Map Rendering ***********************/

/** reference to the texture to use for the HUD map */
var(Minimap) Texture MapTexture;

/** Allows for additional rotation on the texture to be applied */
var(Minimap) float MapTextureYaw;

/** Location which is used as center for minimap (onslaught) */
var(Minimap) vector MapCenter;

/** Radius of map (how far it extends from center) used by minimap */
var(Minimap) float MapExtent;

/** Default yaw to apply to minimap */
var(Minimap) int MapYaw;

/** range for rotating minimap */
var(Minimap) float RotatingMiniMapRange;

/** Holds the Size of the map when designed */
var(Map) float DefaultMapSize;

/** Holds a list of objectives */
var array<TMGameObjective> Objectives;

/** Holds a list of TaskTipActor */
var array<Actor> TaskTipActors;

/** If true, this map and all of the associated data is up to date. */
var transient bool bMapUpToDate;

//var transient TMGameObjective CurrentNode;
var transient Actor CurrentActor;

/** Holds the node that is currently being hovered over by the mouse */
var transient actor WatchedActor;

/** Holds a reference to the material to use for rendering hud icons */
var transient Material HUDIcons;
var transient Texture2D 	HUDIconsT;

/** Current map coordinate axes */
var vector MapRotX, MapRotY;

/** Current map yaw */
var int CurrentMapRotYaw;

/** Holds the MIC that will be used to scale/rotate the map Background */
var transient MaterialInstanceConstant MapMaterialInstance;

var Material MapMaterialReference;

var	float UseableRadius;

var transient vector ActualMapCenter;
var transient float RadarWidth, RadarRange;
var transient vector CenterPos;
var transient float MapScale;
var transient float ColorPercent;

var transient MaterialInstanceConstant GreenIconMaterialInstance;

var texturecoordinates PlayerIconCoords;

// show up to 2 key vehicles on minimap
var TMVehicle KeyVehicles[2];

var array<TMGameObjective> Sensors;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/******************************************************
 * Map Rendering
 ******************************************************/

// -- We can probably remove these as soon as the map is 100% in the MI
simulated function VerifyMapExtent()
{
	local int NumNodes;
	local TMGameObjective O;
	local WorldInfo WI;

	if ( MapExtent == 0 )
	{
		;
		WI = WorldInfo(Outer);
		MapCenter = vect(0,0,0);
		ForEach WI.AllActors(class'TMGameObjective', O)
		{
			MapCenter += O.Location;
			NumNodes++;
		}

		MapCenter = MapCenter/NumNodes;

		// Calculate the radar range and reset the nodes as not having been rendered
		ForEach WI.AllActors(class'TMGameObjective', O)
		{
			MapExtent = FMax(MapExtent, 2.75 * vsize2D(MapCenter - O.Location));
		}
	}
}

function FindObjectives()
{
	local TMGameObjective Obj;

    bMapUpToDate = true;
	ForEach WorldInfo(Outer).AllNavigationPoints(class'TMGameObjective', Obj)
	{
		Objectives[Objectives.length] = Obj;
	}

    if ( MapMaterialInstance == none )
    {
    	MapMaterialInstance = new(Outer) class'MaterialInstanceConstant';
    	MapMaterialInstance.SetParent(MapMaterialReference);
		MapMaterialInstance.SetTextureParameterValue('LevelMap', MapTexture);
	}
}

/**
  *  Tell all the nodes to render themselves
  */
simulated native function RenderLinks(Canvas Canvas, TMPlayerController PlayerOwner);

/**
  * Give objectives a chance to add information to minimap
  */
simulated native function RenderAdditionalInformation(Canvas Canvas, TMPlayerController PlayerOwner);

/**
  * Update Node positions and sensor array
  */
simulated native function UpdateNodes(TMPlayerController PlayerOwner);

/**
 * Draw a map on a canvas.
 *
 * @Param	Canvas			The Canvas to draw on
 * @Param	PlayerOwner	    Who is this map being shown to
 * @Param	XPos, YPos		Where on the Canvas should it be drawn
 * @Param   Width,Height	How big
 */
simulated function DrawMap(Canvas Canvas, TMPlayerController PlayerOwner, float XPos, float YPos, float Width, float Height, bool bFullDetail, float AspectRatio)
{
	local int i, j, PlayerYaw, SecondPlayerYaw, NumObjectives, TeamNum;
	local vector PlayerLocation, SecondPlayerLocation, ScreenLocation, SecondScreenLocation, WatchedLocation, CurrentObjectiveHUDLocation, NorthLocation, NorthDir;
	local float MinRadarRange, hw,hh,DotScale;
	local Pawn PawnOwner, P, SecondPawn;
	local linearcolor FinalColor, TC;
	local bool bInSensorRange, bIsSplitScreen;
	local TMPlayerReplicationInfo PRI;
	local TMPawn TMP;
	local TMPlayerController PC;
	local TMVehicle V;
	local TMTeamInfo Team;
	local TMGameObjective SpawnObjective;
	local rotator MapRot;
	local WorldInfo WI;

	// If we aren't rendering for anyone, exit
	if ( (PlayerOwner == None) || (PlayerOwner.PlayerReplicationInfo == None) )
	{
		 return;
	}

	TC = ((PlayerOwner.PlayerReplicationInfo.Team != None) && (PlayerOwner.PlayerReplicationInfo.Team.TeamIndex == 1))
			? MakeLinearColor(0.f,0.f,0.4f,1.0f)
			: MakeLinearColor(0.2f,0.f,0.f,1.0f);

	VerifyMapExtent();


	// Make sure we have tracked all of the nodes
	if ( !bMapUpToDate )
	{
		FindObjectives();
	}

	NumObjectives = Objectives.Length;
	if ( NumObjectives == 0 )
	{
		//return;
	}

	WI = WorldInfo(Outer);
	ColorPercent = 0.5f + Cos((WI.RealTimeSeconds * 4.0) * 3.14159 * 0.5f) * 0.5f;

	PawnOwner = Pawn(PlayerOwner.ViewTarget);
	SpawnObjective = TMPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).StartObjective;

	// Refresh all Positional Data
	CenterPos.Y = YPos + (Height * 0.5);		//0.5*Canvas.ClipY;
	CenterPos.X = XPos + (Width * 0.5); 		//0.5*Canvas.ClipX;

	// MapScale is the different between the original map and this map
	MapScale = 1.5 * Height/DefaultMapSize;
	RadarWidth = Height * UseableRadius * 2;

	// determine player position on minimap
	ScreenLocation = (PawnOwner != None) ? PawnOwner.Location : PlayerOwner.Location;
	PlayerYaw = PlayerOwner.Rotation.Yaw & 65535;

	RadarRange = MapExtent;
	MapRot.Yaw = (MapYaw * 182.04444444);

	ActualMapCenter = MapCenter;
	bIsSplitScreen = class'Engine'.static.IsSplitScreen();
	PlayerOwner.bRotateMinimap = PlayerOwner.bRotateMinimap && !bIsSplitScreen;

	// Look to see if we are a rotating map and not full screen
	if ( !bFullDetail && PlayerOwner.bRotateMinimap  )
	{
		// map center and rotation based on player position
		ActualMapCenter = ScreenLocation;
		MapRot.Yaw = PlayerYaw;//  + 16384;
		MinRadarRange = RotatingMiniMapRange;

		// Setup the rotating/scaling on the map image. (Subtract off the alignment of the map)
		DrawMapImage(Canvas, XPos, YPos, Width, Height, PlayerYaw - (MapYaw * 182.0444)/* + 16384*/, (MinRadarRange/RadarRange) );
		RadarRange = MinRadarRange;
	}
	else
	{
		DrawMapImage(Canvas, XPos, YPos, Width, Height, 0, 1.0 );
		RadarWidth = Width;
	}

	// Draw the Ring
    hw = Width * 0.5;
    hh = Height * 0.5;

	// UL
    Canvas.SetPos(XPos,YPos);
    Canvas.DrawTile(class'TMHUD'.default.IconHudTexture, hw, hh, 215,579,347,347,TC);

    // UR
    Canvas.SetPos(XPos+hw,YPos);
    Canvas.DrawTile(class'TMHUD'.default.IconHudTexture, hw, hh, 562,579,-347,347,TC);

	// LL
    Canvas.SetPos(XPos,YPos+hh);
    Canvas.DrawTile(class'TMHUD'.default.IconHudTexture, hw, hh, 215,926,347,-347,TC);

    // LR
    Canvas.SetPos(XPos+hw,YPos+hh);
    Canvas.DrawTile(class'TMHUD'.default.IconHudTexture, hw, hh, 562,926,-347,-347,TC);

	// North indicator
    DotScale = hw / 347;
	if ( !bFullDetail && PlayerOwner.bRotateMinimap )
	{
		NorthDir = MapRotY;
		NorthDir.X *= -1.0;
		NorthLocation = CenterPos - 0.92 * hh * NorthDir;
		NorthLocation .X -=  29.5*DotScale;
		NorthLocation.Y -= 33.5*DotScale;
		Canvas.DrawColor = class'TMHUD'.default.RedColor;
		Canvas.DrawColor.R = 128;
		Canvas.SetPos(NorthLocation.X, NorthLocation.Y);
		NorthDir = MapRotX;
		NorthDir.Y *= -1.0;
		Canvas.DrawRotatedTile(class'TMHUD'.default.IconHudTexture, rotator(NorthDir), 59*DotScale, 67*DotScale, 725,175,59,67);
	}
	else
	{
		Canvas.SetPos(XPos + hw - (29.5 * DotScale), YPos - (5 * DotScale));    // 42-37 = 5 :)
		Canvas.DrawTile(class'TMHUD'.default.IconHudTexture, 59*DotScale, 67*DotScale, 725,175,59,67,TC);
	}

	ChangeMapRotation(MapRot);

	// draw onslaught map
	Canvas.SetPos(CenterPos.X - 0.5*RadarWidth, CenterPos.Y - 0.5*RadarWidth);

	// draw your player
	if ( (PawnOwner != None) && (PlayerOwner.Pawn == PawnOwner) )
	{
		PlayerLocation = UpdateHUDLocation(ScreenLocation);
		Canvas.DrawColor = class'TMTeamInfo'.Default.BaseTeamColor[2];
		DrawRotatedTile(Canvas, class'TMHUD'.default.IconHudTexture, PlayerLocation, PlayerYaw/* + 16384*/, 2.0, PlayerIconCoords, MakeLinearColor(0.4,1.0,0.4,1.0));
	}

	if ( bIsSplitScreen )
	{
		ForEach PlayerOwner.LocalPlayerControllers(class'TMPlayerController', PC)
		{
			if ( PC != PlayerOwner )
			{
				break;
			}
		}
		if ( (PC != None) && (PC.Pawn != None) )
		{
			SecondPawn = PC.Pawn;

			// draw second player
			SecondScreenLocation = SecondPawn.Location;
			SecondPlayerYaw = PC.Rotation.Yaw & 65535;
			SecondPlayerLocation = UpdateHUDLocation(SecondScreenLocation);
			Canvas.DrawColor = class'TMTeamInfo'.Default.BaseTeamColor[2];
			DrawRotatedTile(Canvas, class'TMHUD'.default.IconHudTexture, SecondPlayerLocation, SecondPlayerYaw + 16384, 2.0, PlayerIconCoords, MakeLinearColor(1.0,1.0,0.4,1.0));
		}
	}

	FinalColor = class'TMHUD'.default.WhiteLinearColor;

	// Resolve all node positions before rendering the links
	UpdateNodes(PlayerOwner);

	if ( bFullDetail )
	{
		for (i = 0; i < NumObjectives; i++)
		{
			if (  WI.GRI.OnSameTeam(Objectives[i], PlayerOwner) )
			{
				FinalColor = Objectives[i].ControlColor[Objectives[i].DefenderTeamIndex];
				FinalColor.A = 1.0;

				// draw associated vehicle factories with vehicles
				for ( j=0; j<Objectives[i].VehicleFactories.Length; j++ )
				{
					if ( Objectives[i].VehicleFactories[j].bHasLockedVehicle )
					{
						Objectives[i].VehicleFactories[j].SetHUDLocation(UpdateHUDLocation(Objectives[i].VehicleFactories[j].Location));
						Objectives[i].VehicleFactories[j].RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
					}
				}
			}
		}

		// Handle Selection Differently
		if ( WatchedActor != none )
		{
			WatchedLocation = GetActorHudLocation(WatchedActor);

			// Draw the Watched graphic
			Canvas.SetPos(WatchedLocation.X - 15 * MapScale, WatchedLocation.Y - 15 * MapScale * Canvas.ClipY / Canvas.ClipX);
			Canvas.SetDrawColor(255,255,255,128);
			Canvas.DrawTile(class'TMHUD'.default.AltHudTexture,31*MapScale,31*MapScale,273,494,12,13);
		}

		if ( SpawnObjective != none )
		{
			// TEMP - Need a icon or background
			Canvas.SetPos(SpawnObjective.HUDLocation.X - 11 * MapScale, SpawnObjective.HUDLocation.Y - 11 * MapScale * AspectRatio); // * Canvas.ClipY / Canvas.ClipX);
			Canvas.SetDrawColor(64,255,64,128);
			Canvas.DrawTile(class'TMHUD'.default.AltHudTexture,31*MapScale,31*MapScale,273,494,12,13);
		}
	}

	RenderLinks(Canvas, PlayerOwner);

	if ( bFullDetail )
	{
		for (i = 0; i < NumObjectives; i++)
		{
			Objectives[i].RenderExtraDetails(self, Canvas, PlayerOwner, ColorPercent, Objectives[i] == CurrentActor);
		}

		For ( i=0; i<WI.GRI.PRIArray.Length; i++ )
		{
			PRI = TMPlayerReplicationInfo(WI.GRI.PRIArray[i]);
			if ( PRI != None )
			{
				PRI.bHUDRendered = false;
			}
		}

		// Draw all vehicles in sensor range that aren't locked (locked vehicles handled by vehicle factory)
		ForEach WI.AllPawns(class'Pawn', P)
		{
			bInSensorRange = false;
			if ( P.bHidden || (P.Health <=0) || P.IsInvisible() || (P.DrivenVehicle != None) )
			{
				continue;
			}
			V = TMVehicle(P);
			if ( V != None )
			{
				if ( (V.bTeamLocked && !V.bKeyVehicle) || ((V == PawnOwner) && V.IsA('TMVehicle_Hoverboard')) )
		        {
			        continue;
		        }
			}
			else
			{
				TMP = TMPawn(P);
				if ( (TMP == None) || (TMP == PawnOwner) )
				{
					continue;
				}
			}
			PRI = TMPlayerReplicationInfo(P.PlayerReplicationInfo);

			if ( PRI != none )
			{
				PRI.bHUDRendered = true;
			}

			if ( WI.GRI.OnSameTeam(PlayerOwner, P) )
			{
				bInSensorRange = true;
			}
			else
			{
			    // only draw if close to a sensor
			    for ( i=0; i<Sensors.Length; i++ )
			    {
				    if ( VSize(P.Location - Sensors[i].Location) < Sensors[i].MaxSensorRange )
				    {
					    bInSensorRange = true;
					    break;
				    }
			    }
			}

			if ( bInSensorRange )
			{
				P.SetHUDLocation(UpdateHUDLocation(P.Location));
				if ( V != None )
				{
					class'TMHud'.static.GetTeamColor(V.Team, FinalColor);
					V.RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
				}
				else
				{
					TeamNum = ((TMP.PlayerReplicationInfo != None) && (TMP.PlayerReplicationInfo.Team != None))
								? TMP.PlayerReplicationInfo.Team.TeamIndex
								: 2;
					class'TMHud'.static.GetTeamColor(TeamNum, FinalColor);
					TMP.RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
				}
			}
		}

		// on clients, get map info for non-relevant clients from PRIs
		if ( PlayerOwner.Role < ROLE_Authority )
		{
			For ( i=0; i<WI.GRI.PRIArray.Length; i++ )
			{
				PRI = TMPlayerReplicationInfo(WI.GRI.PRIArray[i]);
				if ( (PRI != None) && !PRI.bHUDRendered )
				{
					bInSensorRange = false;
					if ( PRI.HUDPawnClass == None )
					{
						continue;
					}
					else if ( WI.GRI.OnSameTeam(PlayerOwner, PRI) )
					{
						bInSensorRange = true;
					}
					else
					{
						// only draw if close to a sensor
						for ( j=0; j<Sensors.Length; j++ )
						{
							if ( VSize(PRI.HUDPawnLocation - Sensors[j].Location) < Sensors[j].MaxSensorRange )
							{
								bInSensorRange = true;
								break;
							}
						}
					}

					if ( bInSensorRange )
					{
						class'TMHud'.static.GetTeamColor(PRI.Team.TeamIndex, FinalColor);
						PRI.RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
					}
				}
			}
		}
	}
	else
	{
		// draw "key vehicles" on minimap
		for ( i=0; i<2; i++ )
		{
			if ( KeyVehicles[i] == None )
			{
				continue;
			}

			if ( !KeyVehicles[i].bKeyVehicle || (KeyVehicles[i].Health <=0) || KeyVehicles[i].bDeleteMe )
			{
				KeyVehicles[i] = None;
				continue;
			}

			KeyVehicles[i].SetHUDLocation(UpdateHUDLocation(KeyVehicles[i].Location));
			class'TMHud'.static.GetTeamColor(KeyVehicles[i].Team, FinalColor);
			KeyVehicles[i].RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
		}
	}

	// draw flags after vehicles/other players
	if ( TMTeamInfo(PlayerOwner.PlayerReplicationInfo.Team) != None )
	{
		// show flag if within sensor range
		for ( j=0; j<2; j++ )
		{
			Team = TMTeamInfo(WI.GRI.Teams[j]);
			if (Team != None && Team.TeamFlag != None)
			{
				bInSensorRange = Team.TeamFlag.ShouldMinimapRenderFor(PlayerOwner);
				i = 0;
				if ( !bInSensorRange )
				{
					for ( i=0; i<Sensors.Length; i++ )
					{
						if ( VSizeSq(Team.TeamFlag.Location - Sensors[i].Location) < Square(Sensors[i].MaxSensorRange) )
						{
							bInSensorRange = true;
							break;
						}
					}
				}
				if ( bInSensorRange )
				{
					Team.TeamFlag.SetHUDLocation(UpdateHUDLocation(Team.TeamFlag.Location));
					if ( Team == PlayerOwner.PlayerReplicationInfo.Team )
					{
						Team.TeamFlag.RenderMapIcon(self, Canvas,PlayerOwner);
					}
					else
					{
						Team.TeamFlag.RenderEnemyMapIcon(self, Canvas, PlayerOwner, Sensors[i]);
					}
				}
			}
		}
	}

	RenderAdditionalInformation(Canvas, PlayerOwner);

	// highlight current objective
	if ( PlayerOwner.LastAutoObjective != None )
	{
		CurrentObjectiveHUDLocation = UpdateHUDLocation(PlayerOwner.LastAutoObjective.Location);
		Canvas.SetPos(CurrentObjectiveHUDLocation.X - 12*MapScale, CurrentObjectiveHUDLocation.Y - 12*MapScale);//*AspectRatio);
		Canvas.SetDrawColor(255,255,0,255 * (1.0-ColorPercent));
		Canvas.DrawTile(class'TMHUD'.default.IconHudTexture,23*MapScale, 23*MapScale, 669,266,75,75);
	}
	Canvas.SetDrawColor(255,255,255,255);
}

simulated function AddKeyVehicle(TMVehicle V)
{
	local int i;

	// make sure not already in list
	for ( i=0; i<2; i++ )
	{
		if ( KeyVehicles[i] == V )
		{
			return;
		}
	}

	// find an empty slot
	for ( i=0; i<2; i++ )
	{
		if ( (KeyVehicles[i] == None) || KeyVehicles[i].bDeleteMe || (KeyVehicles[i].Health <= 0) )
		{
			KeyVehicles[i] = V;
			return;
		}
	}
	KeyVehicles[1] = V;
}

function DrawRotatedTile(Canvas Canvas, Texture2D T, vector MapLocation, int InYaw, float IconScale, TextureCoordinates TexCoords, LinearColor DrawColor)
{
	local Rotator R;
	local float Width, Height;

	R.Yaw = InYaw - CurrentMapRotYaw;

	Width = TexCoords.UL * (MapScale/4) * IconScale;
	Height = TexCoords.VL * (MapScale/4) * IconScale;

	Canvas.SetPos(MapLocation.X - (0.5*Width), MapLocation.Y - (0.5*Height) );
	Canvas.DrawColor = MakeColor( DrawColor.R * 255, DrawColor.G * 255, DrawColor.B * 255, DrawColor.A * 255);
	Canvas.DrawRotatedTile(T, R, Width, Height, TexCoords.U, TexCoords.V, TexCoords.UL, TexCoords.VL);
}

function DrawRotatedMaterialTile(Canvas Canvas, MaterialInstanceConstant M, vector MapLocation, int InYaw, float XWidth, float YWidth, float XStart, float YStart, float XLength, float YLength)
{
	local Rotator R;

	R.Yaw = InYaw - CurrentMapRotYaw;
	M.SetScalarParameterValue('TexRotation', 0);
	Canvas.SetPos(MapLocation.X - 0.5*XWidth*MapScale, MapLocation.Y - 0.5*YWidth*MapScale);
	Canvas.DrawRotatedMaterialTile(M, R, XWidth * MapScale, YWidth * MapScale, XStart, YStart, XLength, YLength);
}

/**
 * Updates the Map Location for a given world location
 */
native function vector UpdateHUDLocation( Vector InLocation );

function ChangeMapRotation(Rotator NewMapRotation)
{
	local vector Z;

	if ( CurrentMapRotYaw == NewMapRotation.Yaw )
	{
		return;
	}

	GetAxes(NewMapRotation, MapRotX, MapRotY, Z);
	CurrentMapRotYaw = NewMapRotation.Yaw;
}

/**
 * Draws the map image for the mini map
 */
function DrawMapImage(Canvas Canvas, float X, float Y, float W, float H, float PlayerYaw, float BkgImgScaling)
{
	local Rotator MapTexRot;
	local vector Offset;

	if ( MapMaterialInstance != none && MapTexture != none )
	{
		//Zoom level of the map
		MapMaterialInstance.SetScalarParameterValue('MapScale_Parameter', BkgImgScaling);

		// Set Origin.
		// Find out where in the overall map the player is
		Offset = (MapCenter - ActualMapCenter);
		Offset.X = (Offset.X / MapExtent);
		Offset.Y = (Offset.Y / MapExtent);

		//Set the material parameters
		MapMaterialInstance.SetScalarParameterValue('U_Parameter',-Offset.Y);//N/S
		MapMaterialInstance.SetScalarParameterValue('V_Parameter',Offset.X);//E/W

		//Align the texture to the orientation specified by the MapInfo (realign the map to face 'north' always)
		//assume CW rotation (negate), material shader rotation module is speed=PI/2 so scale by 4
		MapMaterialInstance.SetScalarParameterValue('Rot_Value',(MapTextureYaw/360.0f) * -4.0f);

		//Now rotate the 'north' facing map to the player facing direction
		MapTexRot.Yaw = (PlayerYaw * -1);
		Canvas.SetPos(X,Y);
		Canvas.DrawRotatedMaterialTile(MapMaterialInstance, MapTexRot, W, H);
	}
}

function vector GetActorHudLocation(Actor CActor)
{
	if ( TMGameObjective(CActor) != none )
	{
		return TMGameObjective(CActor).HudLocation;
	}
	else if (TMVehicle(CActor) != none )
	{
		return TMVehicle(CActor).HudLocation;
	}

	return vect(0,0,0);
}

