/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoHUDElement_Minimap extends Object
	dependson( NanoTypes, NanoMissionManager, UIIconComponent, NanoCollectableBase)
	config(Game);




/** All of the circle radii drawing textures are off, so we need to fudge them. **/
//var() protected const float CircleRadiusIconFudge;


/** If we have a special icon we want to alternate between the up/down and the icon.  This is how often we do that. **/
var protected float UpDownToNormalAlternateTime;



var protected const Texture2D SearchRadiusIcon;
var() protected const color SearchRadiusIconColorAlert;
var() protected const color SearchRadiusIconColorChasing;


var protected const Texture2D PlayerIcon;
var() protected const float PlayerIconScale;
var() protected const color PlayerIconColor;

var protected const Texture2D NDPIcon;
var protected const Texture2D NDPIcon_AttackRadius;
var protected const Texture2D NDPIcon_DefenseRadius;
var() protected const float NDPIconScale;
var() protected const color NDPIconColor;


var() protected const color ChaosTier0Color;
var() protected const color ChaosTier1Color;
var() protected const color ChaosTier2Color;

var() protected const color NDPIconColor_AboutToBeAttacked;
var() protected const color NDPIconColor_YouWillBeInTrouble;
var() protected const color NDPIconColor_WillBeSafe;



var transient HUD HUDOwner;

/** Whether or not we are drawing the red pacman color **/
var transient bool bPacmanRedColor;
var transient float LastPacmanFlipFlopTime;

var() protected const float PacmanIconScale;
var() protected const color PacmanIconColor_Blue;
var() protected const color PacmanIconColor_Red;



var transient int PrevChaosTier;

var transient LinearColor MiniMapOverlayColor;

var transient float FadeAmount;
var transient bool bDoingMiniMapFlash;
var transient bool bMiniMapFlashAlternateColor;
var transient float MiniMapFlashStartTime;

/** location of NW corner of map */
var vector2D NWMapPos;
/** location of SE corner of map */
var vector2D SEMapPos;


var int CurrChaosTier;


function Init( HUD InHUDOwner )
{
	UpdateMapAnchors( InHUDOwner );
}


function UpdateMapAnchors( HUD InHUDOwner )
{
	local NanoMapSpecificInfo MapInfo;
	local NanoMapAnchor Anchor;

	HUDOwner = InHUDOwner;

	// Init to world min/max
	SEMapPos.X = -262144;
	SEMapPos.Y = 262144;

	NWMapPos.X = 262144;
	NWMapPos.Y = -262144;


	// check for overridden map anchors
	MapInfo = NanoMapSpecificInfo(HUDOwner.WorldInfo.GetMapInfo());

	if( ( MapInfo != None ) && ( MapInfo.OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY != None ) && ( MapInfo.OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY != None ) )
	{
		NWMapPos.X = MapInfo.OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY.Location.X;
		NWMapPos.Y = MapInfo.OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY.Location.Y;

		SEMapPos.X = MapInfo.OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY.Location.X;
		SEMapPos.Y = MapInfo.OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY.Location.Y;

		// use the overridden values
		return;
	}


	// look for default anchor actors
	ForEach HUDOwner.AllActors(class'NanoMapAnchor', Anchor)
	{
		// don't care about non default map anchors
		if( Anchor.bDefaultMapAnchor == FALSE )
		{
			continue;
		}


		if( Anchor.Corner == MC_TopLeft_NW_MaxX_MinY )
		{
			NWMapPos.X = Anchor.Location.X;
			NWMapPos.Y = Anchor.Location.Y;
		}
		else if( Anchor.Corner == MC_BottomRight_SE_MinX_MaxY )
		{ 
			SEMapPos.X = Anchor.Location.X;
			SEMapPos.Y = Anchor.Location.Y;
		}
	}
}

/** 
 *  Internal. Returns scale factor for circle icon meant to represent the given world radius. 
 *  Icon scaling equation:
 *  IconScale = (WorldRadiusInUU * PixelsPerUU) / (0.5 * IconWidthInPixels)
 */
final private function float GetScalingFactorForCircles(MinimapDrawInfo I, float WorldRadius, Texture2D Icon)
{
	return WorldRadius / (0.5f * Icon.GetSurfaceWidth() * I.MinimapToWorldScale);
}

/** Convert from a world position into UV coords of the map */
final private function vector2d WorldPosToMapUV(vector InWorldPos)
{
	local vector2d OutUV;
	
	OutUV.X = ((InWorldPos.Y - NWMapPos.Y)/(SEMapPos.Y - NWMapPos.Y));
	OutUV.Y = 1.0 - ((InWorldPos.X - SEMapPos.X)/(NWMapPos.X - SEMapPos.X));

	return OutUV;
}

/** Draw the mini-map using world-defined texture and achor actors */
final private function DrawMapTexture(Canvas C, MinimapDrawInfo I, vector2d TopLeft, vector2d BotRight)
{
	local Texture2D MapTex;
	local CanvasUVTri TriA, TriB;
	local vector2d BotLeft, TopRight;
	local vector2d BotLeftUV, TopRightUV, TopLeftUV, BotRightUV;
	local NanoMapSpecificInfo MapInfo;
	local array<CanvasUVTri> Tris;
	local vector2d MapRadius_Screen, MapRadius_World;
	local vector MapPos, CornerOffset, CornerPos_World;
	local rotator MapRot;
	local float MinimapToWorldScale;

	MapTex = Texture2D'Overhead_Maps.T_CityScale_Map';

	MapInfo = NanoMapSpecificInfo(HUDOwner.WorldInfo.GetMapInfo());

	if( MapInfo != None )
	{
		if( MapInfo.OverriddenAtRunTimeMapTexture != None )
		{
			MapTex = MapInfo.OverriddenAtRunTimeMapTexture;
		}
		else if( MapInfo.MapTexture != None )
		{
			MapTex = MapInfo.MapTexture;
		}
	}

	UpdateMapAnchors( HUDOwner );


	if( ( MapInfo != None ) && ( MapInfo.OverriddenAtRunTimeMinimapToWorldScale != 0.0f ) )
	{
		MinimapToWorldScale = MapInfo.OverriddenAtRunTimeMinimapToWorldScale;
	}
	else
	{
		MinimapToWorldScale = I.MinimapToWorldScale;
	}



	MapRadius_Screen = I.MinimapSize * C.SizeX * 0.5;
	MapRadius_World = MapRadius_Screen * MinimapToWorldScale;

	MapPos = I.MinimapLocation;
	MapRot.Yaw = I.MinimapRotation * DegToUnrRot;

	// BL
	BotLeft.X = TopLeft.X;
	BotLeft.Y = BotRight.Y;

	CornerOffset.X = -MapRadius_World.X;
	CornerOffset.Y = -MapRadius_World.Y;
	CornerPos_World = MapPos + (CornerOffset >> MapRot);
	BotLeftUV = WorldPosToMapUV(CornerPos_World);


	// TR
	TopRight.X = BotRight.X;
	TopRight.Y = TopLeft.Y;

	CornerOffset.X = MapRadius_World.X;
	CornerOffset.Y = MapRadius_World.Y;
	CornerPos_World = MapPos + (CornerOffset >> MapRot);
	TopRightUV = WorldPosToMapUV(CornerPos_World);

	// TL
	CornerOffset.X = MapRadius_World.X;
	CornerOffset.Y = -MapRadius_World.Y;
	CornerPos_World = MapPos + (CornerOffset >> MapRot);
	TopLeftUV = WorldPosToMapUV(CornerPos_World);

	// BR
	CornerOffset.X = -MapRadius_World.X;
	CornerOffset.Y = MapRadius_World.Y;
	CornerPos_World = MapPos + (CornerOffset >> MapRot);
	BotRightUV = WorldPosToMapUV(CornerPos_World);



	// Make tris and add to list
	TriA.V0_Pos = BotLeft;
	TriA.V0_UV = BotLeftUV;
	TriA.V1_Pos = TopLeft;
	TriA.V1_UV = TopLeftUV;
	TriA.V2_Pos = TopRight;
	TriA.V2_UV = TopRightUV;

	Tris[0] = TriA;

	TriB.V0_Pos = BotLeft;
	TriB.V0_UV = BotLeftUV;
	TriB.V1_Pos = TopRight;
	TriB.V1_UV = TopRightUV;
	TriB.V2_Pos = BotRight;
	TriB.V2_UV = BotRightUV;

	Tris[1] = TriB;

	C.DrawTris(MapTex, Tris);
}

/** This function is our entry point and is called by the HUD, so put all of your "draw <type>" in here **/
function DrawHUDElements(Canvas C, MinimapDrawInfo I)
{
	local ChaosPacifismManager CM;
	local int ChaosLevel;
	local vector2d TopLeft, BotRight, PawnMapLoc;
	local rotator PlayerIconRot;


	//// Draw the mini map border
	CM = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}

	if( ChaosLevel > 1 )
	{
		C.SetDrawColor( ChaosTier2Color.R, ChaosTier2Color.G, ChaosTier2Color.B, ChaosTier2Color.A );
	}
	else if( ChaosLevel > 0 )
	{
		C.SetDrawColor( ChaosTier1Color.R, ChaosTier1Color.G, ChaosTier1Color.B, ChaosTier1Color.A );
	}
	else
	{
		C.SetDrawColor( ChaosTier0Color.R, ChaosTier0Color.G, ChaosTier0Color.B, ChaosTier0Color.A );
	}

	// Draw map
	TopLeft.X = I.Minimap_UL.X*C.SizeX;
	TopLeft.Y = I.Minimap_UL.Y*C.SizeX;

	BotRight.X = TopLeft.X + I.MinimapSize.X*C.SizeX;
	BotRight.Y = TopLeft.Y + I.MinimapSize.Y*C.SizeX;
	DrawMapTexture(C, I, TopLeft, BotRight);

	if(I.bDrawBorder)
	{
		// upper left
		C.SetPos(I.Minimap_UL.X*C.SizeX, I.Minimap_UL.Y*C.SizeX);
		C.DrawBox(I.MinimapSize.X*C.SizeX, I.MinimapSize.Y*C.SizeX); // this is drawing the box for the mini map
	}

	// for chaos levels 2+ we draw a double box
// 	if( ChaosLevel > 1 )
// 	{
// 		C.SetPos(Minimap_UL.X*C.SizeX-5, Minimap_UL.Y*C.SizeX-5);
// 		C.DrawBox(MinimapSize.X*C.SizeX*1.05f, MinimapSize.Y*C.SizeX*1.05f); // this is drawing the box for the mini map
// 	}


	DrawOverlay( C, I, ChaosLevel );

	//// draw all of the specific data types we want on the map
	DrawHUDElements_SubElements( C, I );

	//// dot for player, in the center
	SetDrawColor(C, PlayerIconColor);
	PlayerIconRot = GetPawnRotationInMapSpace(I);

	CalcMiniMapLocation( C, I, HUDOwner.PlayerOwner.Pawn.Location, PawnMapLoc, FALSE );

	DrawTextureCentered(C, I, PlayerIcon, PawnMapLoc, PlayerIconScale, PlayerIconRot );
}


function rotator GetPawnRotationInMapSpace(MinimapDrawInfo I)
{
	local rotator MapRot;
	local rotator PawnMinimapRot;

	// this is the rot of the minimap
	MapRot.Yaw = I.MinimapRotation * DegToUnrRot;

	// find player pawn rot in minimaps space
	PawnMinimapRot = class'NanoTypes'.static.RInverseTransform(HUDOwner.PlayerOwner.Pawn.Rotation, MapRot);
	PawnMinimapRot.Pitch = 0;

	return PawnMinimapRot;
}


function DrawOverlay( Canvas C, MinimapDrawInfo I, int ChaosLevel )
{
	local float TransparentRatio;
	local float TransAmt;

	// draw minimap overlay
	if( ChaosLevel > PrevChaosTier )
	{
		FadeAmount = 2.5f;
		MiniMapOverlayColor = MakeLinearColor( 255, 0, 0, 128 );
	}
	// if we reset
	else if( ( ChaosLevel < PrevChaosTier ) && ( ChaosLevel == 0 ) )
	{
		bDoingMiniMapFlash = FALSE;
		FadeAmount = 2.5f;
		MiniMapOverlayColor = MakeLinearColor( 248, 248, 255, 128.0f );
	}
	else
	{
		//	MiniMapOverlayColor = MakeLinearColor( 0, 0, 0, 0 );
	}

	TransparentRatio = FMax( FadeAmount, 0.001f ) / 2.5f;
	FadeAmount -= HUDOwner.RenderDelta;
	//FadeAmount = FInterpConstantTo( FadeAmount, 0.0f, HUDOwner.RenderDelta, 1 );

	TransAmt = MiniMapOverlayColor.A * TransparentRatio;

	//`log( `showvar(FadeAmount) @ `showvar(TransparentRatio) @ `showvar(HUDOwner.RenderDelta) @ `showvar(MiniMapOverlayColor.A) @ `showvar(MiniMapOverlayColor.A * TransparentRatio) @ `showvar(TransAmt));


	C.SetDrawColor( MiniMapOverlayColor.R, MiniMapOverlayColor.G, MiniMapOverlayColor.B, TransAmt );
	C.SetPos(I.Minimap_UL.X*C.SizeX, I.Minimap_UL.Y*C.SizeX);
	C.DrawRect(I.MinimapSize.X*C.SizeX, I.MinimapSize.Y*C.SizeX); // this is drawing the box for the mini map



	if( ChaosLevel > PrevChaosTier )
	{
		bDoingMiniMapFlash = TRUE;
		MiniMapFlashStartTime = HUDOwner.WorldInfo.TimeSeconds;
	}


	if( bDoingMiniMapFlash == TRUE )
	{
		if( `TimeSinceEx(HUDOwner, MiniMapFlashStartTime) > 1.000f )
		{
			bDoingMiniMapFlash = FALSE;
			FadeAmount = 2.5f;
			MiniMapOverlayColor = MakeLinearColor( 255, 0, 0, 128 );
			bMiniMapFlashAlternateColor = FALSE;
			HUDOwner.ClearTimer( nameof(FlipMiniMapFlashAlternateColor), self );
		}

		if( bMiniMapFlashAlternateColor == TRUE )
		{
			MiniMapOverlayColor = MakeLinearColor( 0, 0, 255, 128 );
		}
		else
		{
			MiniMapOverlayColor = MakeLinearColor( 255, 0, 0, 128 );
		}


		C.SetDrawColor( MiniMapOverlayColor.R, MiniMapOverlayColor.G, MiniMapOverlayColor.B, MiniMapOverlayColor.A );
		C.SetPos(I.Minimap_UL.X*C.SizeX, I.Minimap_UL.Y*C.SizeX);
		C.DrawRect(I.MinimapSize.X*C.SizeX, I.MinimapSize.Y*C.SizeX); // this is drawing the box for the mini map


		if( HUDOwner.IsTimerActive( nameof(FlipMiniMapFlashAlternateColor), self ) == FALSE )
		{
			HUDOwner.SetTimer( 0.100f, FALSE, nameof(FlipMiniMapFlashAlternateColor), self );
		}
	}


	PrevChaosTier = ChaosLevel;

}


function FlipMiniMapFlashAlternateColor()
{
	bMiniMapFlashAlternateColor = !bMiniMapFlashAlternateColor;
}



function DrawHUDElements_SubElements(Canvas C, MinimapDrawInfo I)
{
	local bool bDebug;

	local NanoPawnBase NP;
	local Pawn PlayerPawn;

	local NanoDefensivePoint NDP;
	//local NanoTargetPoint NTP;
	//local GameCrowdAgent Agent;

	local NanoGRI NGRI;

	local MissionInfo Mission;
	local NanoInterface_Objective MissionObj;
	local NanoTargetPoint NTP;

	local NanoCollectableBase Collectable;

	local RebelHandPrint HandPrint;
	local RebelSuperBomb SuperBomb;

	bDebug = NanoPC(HUDOwner.PlayerOwner).bDebugAI;


	// this will draw the PacMan aggro radius
	if( bDebug == TRUE )
	{
		DrawPacMan_Debug( C, I );
	}
	else
	{
		DrawPacMan( C, I );
	}

	// testing for scaling code
	//SetDrawColor(C, SearchRadiusIconColorChasing);
	//PlayerIconScale = 2048.0f / (SearchRadiusIcon.GetSurfaceWidth() * MinimapToWorldScale); 
	//DrawTextureCentered(C, SearchRadiusIcon, MinimapCenter_Screen, PlayerIconScale);

	PlayerPawn = HUDOwner.PlayerOwner.Pawn;
	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	CurrChaosTier = NGRI.GetCurrentChaosLevel();


	foreach HUDOwner.DynamicActors(class'RebelHandPrint', HandPrint)
	{
		if( HandPrint.OwnerID == class'NanoTypes'.static.GetLocalPlayerUserName() )
		{
			continue;
		}

		if( bDebug == TRUE )
		{
			DrawMissionObjective_Debug( C, I, HandPrint );
		}
		else
		{
			DrawMissionObjective( C, I, HandPrint );
		}
	}

	foreach HUDOwner.DynamicActors(class'RebelSuperBomb', SuperBomb)
	{
		if( bDebug == TRUE )
		{
			DrawMissionObjective_Debug( C, I, SuperBomb );
		}
		else
		{
			DrawMissionObjective( C, I, SuperBomb );
		}
	}



	foreach HUDOwner.DynamicActors(class'NanoCollectableBase', Collectable)
	{
		if( bDebug == TRUE )
		{
			DrawMissionObjective_Debug( C, I, Collectable );
		}
		else
		{
			DrawMissionObjective( C, I, Collectable );
		}
	}


	// hurts us
	foreach HUDOwner.WorldInfo.AllActors(class'NanoDefensivePoint', NDP)
	{
		if( bDebug == TRUE )
		{
			DrawDefensivePoint_Debug(C, I, NDP);
		}
		else
		{
			DrawDefensivePoint(C, I, NDP);
		}
	}

	//if( NGRI.GetCurrentChaosLevel() > 0 )
	//{
	//foreach HUDOwner.WorldInfo.AllActors(class'NanoTargetPoint', NTP)
	//{
		// hack ish for now.  We want to eventually have just a huge list of all UIIconComponents that we add and remove dynamically and then just draw those

//	}
	//}

	foreach HUDOwner.WorldInfo.AllActors(class'NanoTargetPoint', NTP)
	{

		if( NTP.Class.Name == 'NanoRooftopAccessIndicator' )
		{
			if( bDebug == TRUE )
			{
				DrawNanoRooftopAccessIndicator_Debug(C, I, NTP);
			}
			else
			{
				DrawNanoRooftopAccessIndicator(C, I, NTP);
			}
		}


		// hack ish for now.  We want to eventually have just a huge list of all UIIconComponents that we add and remove dynamically and then just draw those
		if(!( ( NTP.Class.Name == 'NanoRooftopAccessIndicator' ) // hack!
			   || ( NTP.Class.Name == 'NanoMissionWayPoint' ) // hack
			  )
			)
		{
			// don't draw non unlocked safehouses
			if( ( SafeHouse(NTP) != None ) && ( SafeHouse(NTP).bUnlocked == FALSE ) ) // hack
			{
				continue;
			}

			// don't draw non unlocked safehouse entrances
			if( ( SafeHouseEntrance(NTP) != None ) && ( SafeHouseEntrance(NTP).bUnlocked == FALSE ) ) // hack
			{
				continue;
			}


			if( bDebug == TRUE )
			{
				DrawMissionObjective_Debug(C, I, NTP);
			}
			else
			{
				DrawMissionObjective(C, I, NTP);
			}
		}
	}



	if( CurrChaosTier < 1 )
	{
		foreach HUDOwner.WorldInfo.AllPawns(class'NanoPawnBase', NP)
		{
			if( NP.Class.Name == 'NanoPawn_Rebels_ShopKeeper' )
			{
				//if( NP.IsAliveAndWell() && NP.IsSameTeam(PlayerPawn) )
				//{
				if( bDebug == TRUE )
				{
					DrawFriendly_Debug(C, I, NP);
				}
				else
				{
					//`log( NP );
					DrawFriendly(C, I, NP);
				}
				//}
			}
		}
	}



	foreach NGRI.TheMissionManager.Missions( Mission )
	{
		foreach Mission.RadarObjectives( MissionObj )
		{
			// basically someone has not cleaned themselves up and we need to wait for GC to occur
			if( MissionObj == None )
			{
				continue;
			}

			if( bDebug == TRUE )
			{
				DrawMissionObjective_Debug( C, I, MissionObj );
			}
			else
			{
				DrawMissionObjective( C, I, MissionObj );
			}
		}
	}

	foreach NGRI.TheMissionManager.AdditionalRadarObjectives( MissionObj )
	{
		// basically someone has not cleaned themselves up and we need to wait for GC to occur
		if( MissionObj == None )
		{
			continue;
		}

		if( bDebug == TRUE )
		{
			DrawMissionObjective_Debug( C, I, MissionObj );
		}
		else
		{
			DrawMissionObjective( C, I, MissionObj );
		}
	}



	// only draw when chaos is up is what we want now
	if( CurrChaosTier > -1 )
	{
		foreach HUDOwner.WorldInfo.AllPawns(class'NanoPawnBase', NP)
		{
			if (NP.IsAliveAndWell() && !NP.IsSameTeam(PlayerPawn))
			{
				if( bDebug == TRUE )
				{
					DrawEnemy_Debug(C, I, NP);
				}
				else
				{
					DrawEnemy(C, I, NP);
				}
			}
			// should be friendly combatants
			// combatants is key word there.  Don't show shopkeepers on the map
			else if( (NP.IsAliveAndWell() && NP.IsSameTeam(PlayerPawn)) && ( NP.Class.Name != 'NanoPawn_Rebels_ShopKeeper' ) )
			{
				if( bDebug == TRUE )
				{
					DrawFriendly_Debug(C, I, NP);
				}
				else
				{
					DrawFriendly(C, I, NP);
				}
			}
		}


		// we currently will never see any "bad guy" crowd members when chaos is up as
		// they stop spawning
		// and they all turn into Foes immediately when chaos triggers

// 		foreach HUDOwner.DynamicActors(class'GameCrowdAgent', Agent)
// 		{
// 			if( bDebug == TRUE )
// 			{
// 				DrawCrowdMember_Debug( C, I, Agent );
// 			}
// 			else
// 			{
// 				DrawCrowdMember( C, I, Agent );
// 			}
// 		}
	}

}







/** Internal.  Syntactic sugar. */
final private function SetDrawColor(Canvas C, const Color Col)
{
	C.SetDrawColor(Col.R, Col.G, Col.B, Col.A);
}

/** This can be used to see if the entire portion of texture being drawn will fit inside the minimap area or not **/
final private function bool TestTextureVisible(Canvas C, MinimapDrawInfo I, const out Texture2D Tex, const out vector2d Loc, float Scale)
{
	local float IconX, IconY;
	local vector2d TopLeft, BottomRight;
	local vector2d MapMin, MapMax;

	IconX = Tex.GetSurfaceWidth() * Scale;
	IconY = Tex.GetSurfaceHeight() * Scale;

	// Get desired texture corners
	TopLeft.X = Loc.X - IconX * 0.5;
	TopLeft.Y = Loc.Y - IconY * 0.5;
	BottomRight.X = Loc.X + IconX * 0.5;
	BottomRight.Y = Loc.Y + IconY * 0.5;

	// Calc bounds for map rectangle
	MapMin.X = I.Minimap_UL.X * C.SizeX;
	MapMin.Y = I.Minimap_UL.Y * C.SizeX;

	MapMax.X = MapMin.X + I.MinimapSize.X*C.SizeX;
	MapMax.Y = MapMin.Y + I.MinimapSize.X*C.SizeX;

	if( (TopLeft.X > MapMax.X) || (TopLeft.Y > MapMax.Y) || (BottomRight.X < MapMin.X) || (BottomRight.X < MapMin.X) )
	{
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}

/** 
 **/
final function DrawTextureCentered(Canvas C, MinimapDrawInfo I, const out Texture2D Tex, const out vector2d Loc, float Scale, optional rotator TexRotation, optional bool bDoNotClamp )
{
	local float IconX, IconY;
	local vector2d TopLeft, TL_UV, BottomRight, BR_UV;
	local vector2d MapMin, MapMax, ClipTL, ClipBR;
	local float TexX, TexY;

	TexX = Tex.GetSurfaceWidth();
	TexY = Tex.GetSurfaceHeight();

	IconX = TexX * Scale;
	IconY = TexY * Scale;

	// Get desired texture corners
	TopLeft.X = Loc.X - IconX * 0.5;
	TopLeft.Y = Loc.Y - IconY * 0.5;
	BottomRight.X = Loc.X + IconX * 0.5;
	BottomRight.Y = Loc.Y + IconY * 0.5;

	// Calc bounds for map rectangle
	MapMin.X = I.Minimap_UL.X * C.SizeX;
	MapMin.Y = I.Minimap_UL.Y * C.SizeX;

	MapMax.X = MapMin.X + I.MinimapSize.X*C.SizeX;
	MapMax.Y = MapMin.Y + I.MinimapSize.X*C.SizeX;

	if( bDoNotClamp == FALSE )
	{
		// test visibility
		if( (TopLeft.X > MapMax.X) || (TopLeft.Y > MapMax.Y) || (BottomRight.X < MapMin.X) || (BottomRight.X < MapMin.X) )
		{
			return;
		}

		// Clamp texture to bounds
		ClipTL.X = FClamp(TopLeft.X, MapMin.X, MapMax.X);
		TL_UV.X = ((ClipTL.X - TopLeft.X)/(BottomRight.X - TopLeft.X)) * TexX;

		ClipTL.Y = FClamp(TopLeft.Y, MapMin.Y, MapMax.Y);
		TL_UV.Y = ((ClipTL.Y - TopLeft.Y)/(BottomRight.Y - TopLeft.Y)) * TexY;

		ClipBR.X = FClamp(BottomRight.X, MapMin.X, MapMax.X);
		BR_UV.X = ((ClipBR.X - TopLeft.X)/(BottomRight.X - TopLeft.X)) * TexX;

		ClipBR.Y = FClamp(BottomRight.Y, MapMin.Y, MapMax.Y);
		BR_UV.Y = ((ClipBR.Y - TopLeft.Y)/(BottomRight.Y - TopLeft.Y)) * TexY;
	}
	else
	{
		ClipTL.X = TopLeft.X;
		TL_UV.X = ((ClipTL.X - TopLeft.X)/(BottomRight.X - TopLeft.X)) * TexX;

		ClipTL.Y = TopLeft.Y;
		TL_UV.Y = ((ClipTL.Y - TopLeft.Y)/(BottomRight.Y - TopLeft.Y)) * TexY;

		ClipBR.X = BottomRight.X;
		BR_UV.X = ((ClipBR.X - TopLeft.X)/(BottomRight.X - TopLeft.X)) * TexX;

		ClipBR.Y = BottomRight.Y;
		BR_UV.Y = ((ClipBR.Y - TopLeft.Y)/(BottomRight.Y - TopLeft.Y)) * TexY;
	}


	C.SetPos(ClipTL.X, ClipTL.Y);

	C.DrawRotatedTile( Tex, TexRotation, ClipBR.X-ClipTL.X, ClipBR.Y-ClipTL.Y, TL_UV.X, TL_UV.Y, BR_UV.X-TL_UV.X, BR_UV.Y-TL_UV.Y );
}

/** 
 * @param  bClamp  if  TRUE, and the location is outside of the minmap then place the representation on the edge of the screen. If FALSE then if the location is outside of the current minimap view then do not draw
 *
 **/
final function CalcMiniMapLocation( Canvas C, MinimapDrawInfo I, const out vector LocationInWorldSpace, out vector2d OutMiniMapLocation, bool bClamp )
{
	local vector2d PlayerRelative2DLoc;
	local vector2d MiniMapCenter_Screen, MinimapUL_Screen, MinimapLR_Screen, MinimapSize_Screen;
	local vector PlayerRelativeLocation;

	local rotator ViewRot;

	MinimapUL_Screen = I.Minimap_UL * C.SizeX;
	MinimapSize_Screen = I.MinimapSize * C.SizeX;
	MiniMapCenter_Screen = MinimapUL_Screen + MinimapSize_Screen * 0.5f;
	MinimapLR_Screen = MinimapUL_Screen + MinimapSize_Screen;

	ViewRot.Yaw = I.MinimapRotation * DegToUnrRot;

	PlayerRelativeLocation = (LocationInWorldSpace - I.MinimapLocation) << ViewRot;

	// drop to 2d, adjust for axis differences
	PlayerRelative2DLoc.X = PlayerRelativeLocation.Y;
	PlayerRelative2DLoc.Y = -PlayerRelativeLocation.X;

	OutMiniMapLocation = PlayerRelative2DLoc / I.MinimapToWorldScale + MiniMapCenter_Screen;

	// clamp
	if(bClamp)
	{
		OutMiniMapLocation.X = FClamp(OutMiniMapLocation.X, MinimapUL_Screen.X, MinimapLR_Screen.X);
		OutMiniMapLocation.Y = FClamp(OutMiniMapLocation.Y, MinimapUL_Screen.Y, MinimapLR_Screen.Y);
	}
}


private function DrawPacMan_Debug( Canvas C, MinimapDrawInfo I )
{
	DrawPacMan( C, I );
}


private function DrawPacMan( Canvas C, MinimapDrawInfo I )
{
	local float IconScale;
	local vector2d MiniMapLocation;

	if( NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
	{
		return;
	}

	// if the pacman has not been set
	if( VSize(NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).NPES.Cloud_PacManCenter) == 0.0f )
	{
		return;
	}


	//// Draw PacMan Circle


// 	// alternate color of the circle
// 	if( bPacmanRedColor == FALSE )
// 	{
// 		SetDrawColor( C, PacmanIconColor_Blue );
// 	}
// 	else
// 	{
// 		SetDrawColor( C, PacmanIconColor_Red );
// 	}
// 
// 	// determine whether to flip flop colors or not
// 	if( `TimeSinceEx(HUDOwner.PlayerOwner.Pawn.WorldInfo, LastPacmanFlipFlopTime) > 1.0f )
// 	{
// 		bPacmanRedColor = !bPacmanRedColor;
// 		LastPacmanFlipFlopTime = HUDOwner.PlayerOwner.Pawn.WorldInfo.TimeSeconds;
// 	}

	SetDrawColor( C, PacmanIconColor_Red );

	IconScale = GetScalingFactorForCircles( I, NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).NPES.GetHotZoneRadius(), SearchRadiusIcon);

	// we don't care if the point is off the map
	CalcMiniMapLocation( C, I, NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).NPES.Cloud_PacManCenter, MiniMapLocation, FALSE );

	DrawTextureCentered( C, I, SearchRadiusIcon, MiniMapLocation, IconScale );


}


private function DrawDefensivePoint_Debug(Canvas C, MinimapDrawInfo I, NanoDefensivePoint NDP)
{
	local vector2d MiniMapLocation;

	local float IconScale;
	local Texture2D NDPCircle;

	local ChaosPacifismManager CM;
	local int ChaosLevel;

	CalcMiniMapLocation( C, I, NDP.Location, MiniMapLocation, FALSE );

	// Draw Dot
	SetDrawColor(C, NDPIconColor);
	DrawTextureCentered(C, I, NDPIcon, MiniMapLocation, NDPIconScale);

	CM = NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}


	//// now depending on what the status of the NDP is we will draw some other circles


	// NEW Method:
	// if the NDP is red you are about to get pwned
	// if the NDP is yellow then going into that area is going to get you in trouble

	NDPCircle = SearchRadiusIcon;



	// choose which icon to use
	if( ChaosLevel > 0 )
	{
		NDPCircle = NDPIcon_DefenseRadius;
	}
	else
	{
		NDPCircle = NDPIcon_AttackRadius;
	}


	// choose which color to use
	if( ChaosLevel > 0 )
	{
		IconScale = GetScalingFactorForCircles(I, NDP.RadiusToDefend, SearchRadiusIcon);

		if( NDP.IsPlayerWithinUnderDefendRadius() == TRUE )
		{				
			// check depleted
			if( ( NDP.NumPointsToSpendToDefend > 0 ) || ( NDP.AreAIWithinDefendRadius() == TRUE )  )
			{
				SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}
		}
		else
		{
			// check depleted
			if( ( NDP.NumPointsToSpendToDefend > 0 ) || ( NDP.AreAIWithinDefendRadius() == TRUE )  )
			{
				//if( NDP.bUnderAttack == TRUE )
				//{
				//SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
				//}
				//else
				//{
				SetDrawColor( C, NDPIconColor_YouWillBeInTrouble );
				//}
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}
		}

		DrawTextureCentered(C, I, NDPCircle, MiniMapLocation, IconScale);

	}
	else
	{
		if( NDP.bShouldCheckAttackRadius == TRUE )
		{
			IconScale = GetScalingFactorForCircles(I, NDP.UnderAttackRadius, SearchRadiusIcon);

			if( NDP.NumPointsToSpendToDefend > 0 ) 
			{
				if( NDP.IsPlayerWithinUnderAttackRadius() == TRUE )
				{
					SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
				}
				else
				{
					SetDrawColor( C, NDPIconColor_YouWillBeInTrouble );
				}
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}

			DrawTextureCentered(C, I, NDPCircle, MiniMapLocation, IconScale);
		}
	}
	//`log( `showvar(MiniMapSize2) @ `showvar(IconScale) @ `showvar(NDP.UnderAttackRadius) @ `showvar(SearchRadiusIcon.GetSurfaceWidth()) );
}

private function DrawDefensivePoint(Canvas C, MinimapDrawInfo I, NanoDefensivePoint NDP)
{
	local vector2d MiniMapLocation;

	local float IconScale;
	local Texture2D NDPCircle;

	local ChaosPacifismManager CM;
	local int ChaosLevel;

	// don't draw if we are not active
	if( NDP.bIsActive == FALSE )
	{
		return;
	}


	// if we are not to draw when out of points
	if( NDP.bDrawDefendRadiusWhenOutOfPointsToDefend == FALSE )
	{
		// check to see if we are out of points
		if( NDP.NumPointsToSpendToDefend <= 0 )
		{
			return;
		}
	}


	// Draw Dot
	//SetDrawColor(C, NDPIconColor);
	//DrawTextureCentered(C, NDPIcon, MiniMapLocation, NDPIconScale);

	CM = NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}

	// check to see if we should even draw the DR
	if( ChaosLevel > 0 )
	{
		if( NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).IsWithinHotZone(NDP.Location) == TRUE )
		{
			// don't draw the DR
			return;
		}
	}

	CalcMiniMapLocation( C, I, NDP.Location, MiniMapLocation, FALSE );

	//// now depending on what the status of the NDP is we will draw some other circles


	// NEW Method:
	// if the NDP is red you are about to get pwned
	// if the NDP is yellow then going into that area is going to get you in trouble

	NDPCircle = SearchRadiusIcon;



	// choose which icon to use
	if( ChaosLevel > 0 )
	{
		NDPCircle = NDPIcon_DefenseRadius;
	}
	else
	{
		NDPCircle = NDPIcon_AttackRadius;
	}


	// choose which color to use
	if( ChaosLevel > 0 )
	{
		IconScale = GetScalingFactorForCircles(I, NDP.RadiusToDefend, SearchRadiusIcon);

		if( NDP.IsPlayerWithinUnderDefendRadius() == TRUE )
		{				
			// check depleted
			if( ( NDP.NumPointsToSpendToDefend > 0 ) || ( NDP.AreAIWithinDefendRadius() == TRUE )  )
			{
				SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}
		}
		else
		{
			// check depleted
			if( ( NDP.NumPointsToSpendToDefend > 0 ) || ( NDP.AreAIWithinDefendRadius() == TRUE )  )
			{
				//if( NDP.bUnderAttack == TRUE )
				//{
					//SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
				//}
				//else
				//{
				SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
				//	SetDrawColor( C, NDPIconColor_YouWillBeInTrouble );
				//}
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}
		}

		DrawTextureCentered(C, I, NDPCircle, MiniMapLocation, IconScale);

	}
	else
	{
		if( NDP.bShouldCheckAttackRadius == TRUE )
		{
			IconScale = GetScalingFactorForCircles(I, NDP.UnderAttackRadius, SearchRadiusIcon);

			if( NDP.NumPointsToSpendToDefend > 0 ) 
			{
				if( NDP.IsPlayerWithinUnderAttackRadius() == TRUE )
				{
					SetDrawColor( C, NDPIconColor_AboutToBeAttacked );
				}
				else
				{
					//	SetDrawColor( C, NDPIconColor_YouWillBeInTrouble );
					SetDrawColor( C, NDPIconColor_WillBeSafe ); // we are switching to grey and red now
				}
			}
			else
			{
				SetDrawColor( C, NDPIconColor_WillBeSafe );
			}

			DrawTextureCentered(C, I, NDPCircle, MiniMapLocation, IconScale);
		}
	}
	//`log( `showvar(MiniMapSize2) @ `showvar(IconScale) @ `showvar(NDP.UnderAttackRadius) @ `showvar(SearchRadiusIcon.GetSurfaceWidth()) );

}



final function DrawAboveBelowIcon( Canvas C, MinimapDrawInfo I, const out Texture2D DefaultIcon, const vector2D InMiniMapLocation, float InIconScale, float InAboveBelowIconScale, int LocationZ, bool bDoNotClamp )
{
	local float ZDifference;
	local Texture2D TempTex;


	// draw visual indicator for whether the ai is above, below, or same level
	ZDifference = I.MinimapLocation.Z - LocationZ;

	if( ZDifference < -512.0f )
	{
		TempTex = class'UIIconComponent'.default.EntityAbove;
		InIconScale = InAboveBelowIconScale;
	}
	else if( ZDifference > 512.0f )
	{
		TempTex = class'UIIconComponent'.default.EntityBelow;
		InIconScale = InAboveBelowIconScale;
	}
	else
	{
		TempTex = DefaultIcon;
	}

	if( TempTex != None )
	{
		DrawTextureCentered(C, I, TempTex, InMiniMapLocation, InIconScale,, bDoNotClamp );
	}
}


private function DrawFriendly_Debug(Canvas C, MinimapDrawInfo I, NanoPawnBase NP)
{
	DrawFriendly(C, I, NP);
}


private function DrawFriendly(Canvas C, MinimapDrawInfo I, NanoPawnBase NP)
{
	DrawEnemy( C, I, NP );
}


private function DrawEnemy_Debug(Canvas C, MinimapDrawInfo I, NanoPawnBase NP)
{
	DrawEnemy(C, I, NP);
}


private function DrawEnemy(Canvas C, MinimapDrawInfo I, NanoPawnBase NP)
{
	local Pawn PlayerPawn;

	local vector2d MiniMapLocation;

	local NanoAI AI;
	local float IconScale;

	local ChaosPacifismManager CM;
	local int ChaosLevel;

	local UIIconComponent UIComp;
	local IconDatum IconDatum;


	PlayerPawn = HUDOwner.PlayerOwner.Pawn;

	UIComp = NP.GetUIIconComponent();

	UIComp.GetIconDatum( EIT_MiniMap, IconDatum );

	// only draw when chaos is up is what we want now
	if( CurrChaosTier == 0 )
	{
		if( IconDatum.bShowEvenIfNoChaos == FALSE )
		{
			return;
		}
	}


	CalcMiniMapLocation( C, I, NP.Location, MiniMapLocation, IconDatum.bShownEvenIfClamped );


	// draw the dot
	SetDrawColor(C, IconDatum.IconColor);
	if( I.bEnableAboveBelowIcons == TRUE && IconDatum.bAlternateAboveBelowIcon == TRUE )
	{
		//`log( "oh" @ `showvar(IconDatum.bAlternateAboveBelowIcon) @ `showvar(`TimeSinceEx(HUDOwner, IconDatum.LastNormalIconTime) ) @ `showvar(IconDatum.bDisplayAboveBelowIcon) @ `showvar(IconDatum.LastNormalIconTime) @ `showvar(IconDatum.bDisplayAboveBelowIcon ) );

		if( IconDatum.bDisplayAboveBelowIcon == TRUE )
		{
			DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, NP.Location.Z, IconDatum.bShownEvenIfClamped );
		}
		else
		{
			DrawTextureCentered(C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale,, IconDatum.bShownEvenIfClamped );
		}

		// now check to see if we should toggle the icon state
		if( `TimeSinceEx(HUDOwner, IconDatum.LastNormalIconTime) > UpDownToNormalAlternateTime ) 
		{
			UIComp.SetLastNormalIconTime( EIT_MiniMap, HUDOwner.WorldInfo.TimeSeconds );
			UIComp.ToggleDisplayAboveBelowIcon( EIT_MiniMap );
		}
	}
	// draw the normal icon
	else
	{
		DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, NP.Location.Z, IconDatum.bShownEvenIfClamped  );
	}


	// if the dot is not off the screen, draw the aggro circle
	CM = NanoGRI(PlayerPawn.WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}

	if( ChaosLevel > 0 )
	{
		AI = NanoAI(NP.Controller);
		if (AI != None)
		{
			// if we are guarding a NDP don't draw our circle
			if( AI.FindCommandOfClass( class'NanoAIAction_DefensiveBase' ) != None )
			{
				return;
			}

			// check to see if we are inside the pacman.  If we are then do not draw the circle
			if( ( VSize(AI.Pawn.Location-NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(HUDOwner.PlayerOwner.Pawn.WorldInfo.GRI).NPES.GetHotZoneRadius() ) )
			{
				return;
			}


			// if this AI is decently far away, then don't draw its CR on the map
			if( ( VSize(AI.Pawn.Location-PlayerPawn.Location ) > (AI.ConfrontPossibleThreatQuery.MaxDist + 2000) ) )
			{
				return;
			}




			// here we need to check to see if the AI should actually draw its circle
			// do not draw if they belong to a defensive point as that NDP controls whether they attack or not.
			// this includes guys that are running from an RDP. 
			// if running from and RDP you will just ignore any "atrocities" until you get to your NDP guard point
// 				if( AI.CurrNanoDefensivePoint != None )
// 				{
// 					return;
// 				}

			IconScale = GetScalingFactorForCircles(I, AI.ConfrontPossibleThreatQuery.MaxDist, SearchRadiusIcon);

			if( AI.IsActivePursuingARebel() == TRUE )
			{
				SetDrawColor(C, SearchRadiusIconColorChasing);
			}
			else
			{
			//	SetDrawColor(C, SearchRadiusIconColorAlert);
			}

			DrawTextureCentered(C, I, SearchRadiusIcon, MiniMapLocation, IconScale);
		}
	}
}


private function DrawCrowdMember_Debug(Canvas C, MinimapDrawInfo I, GameCrowdAgent Agent)
{
	DrawCrowdMember( C, I, Agent );
}

private function DrawCrowdMember(Canvas C, MinimapDrawInfo I, GameCrowdAgent Agent)
{
	local NanoCrowd_PedestrianBase NCPD;

	local vector2d MiniMapLocation;

	//PlayerPawn = HUDOwner.PlayerOwner.Pawn;

	CalcMiniMapLocation( C, I, Agent.Location, MiniMapLocation, FALSE );

	NCPD = NanoCrowd_PedestrianBase(Agent);
	if( NCPD != None )
	{
		if( NCPD.bShouldShowOnMiniMap == TRUE )
		{
			SetDrawColor(C, NCPD.MiniMapDotColor);	
			DrawTextureCentered(C, I, NDPIcon, MiniMapLocation, NDPIconScale);
		}
	}
}





private function DrawMissionObjective_Debug(Canvas C, MinimapDrawInfo I, NanoInterface_Objective NIO)
{
	DrawMissionObjective(C, I, NIO);
}


private function DrawMissionObjective(Canvas C, MinimapDrawInfo I, NanoInterface_Objective NIO)
{
	local Vector ObjLoc;
	local vector2d MiniMapLocation;

	local UIIconComponent UIComp;
	local IconDatum IconDatum;


	UIComp = NIO.GetUIIconComponent();

	UIComp.GetIconDatum( EIT_MiniMap, IconDatum );

	if( IconDatum.bShown == FALSE )
	{
		return;
	}

	ObjLoc = NIO.GetObjectiveLocation();

	CalcMiniMapLocation( C, I, ObjLoc, MiniMapLocation, IconDatum.bShownEvenIfClamped );

	//`log( `showvar(UIComp.Outer) @ `showvar(IconDatum.Icon) );

	SetDrawColor(C, IconDatum.IconColor);

	if( I.bEnableAboveBelowIcons == TRUE && IconDatum.bAlternateAboveBelowIcon == TRUE )
	{
		if( IconDatum.bDisplayAboveBelowIcon == TRUE )
		{
			DrawAboveBelowIcon(C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, ObjLoc.Z, IconDatum.bShownEvenIfClamped );
		}
		else
		{
			DrawTextureCentered(C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale,, IconDatum.bShownEvenIfClamped );
		}

		// now check to see if we should toggle the icon state
		if( `TimeSinceEx(HUDOwner, IconDatum.LastNormalIconTime) > UpDownToNormalAlternateTime ) 
		{
			UIComp.SetLastNormalIconTime( EIT_MiniMap, HUDOwner.WorldInfo.TimeSeconds );
			UIComp.ToggleDisplayAboveBelowIcon( EIT_MiniMap );
		}
	}
	else
	{
		DrawAboveBelowIcon(C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, ObjLoc.Z, IconDatum.bShownEvenIfClamped );
	}
}


private function DrawNanoTargetPoint_Debug(Canvas C, MinimapDrawInfo I, NanoTargetPoint NTP)
{
	DrawNanoTargetPoint(C, I, NTP);
}


private function DrawNanoTargetPoint(Canvas C, MinimapDrawInfo I, NanoTargetPoint NTP)
{
	local vector2d MiniMapLocation;

	local UIIconComponent UIComp;
	local IconDatum IconDatum;

	UIComp = NTP.GetUIIconComponent();

	UIComp.GetIconDatum( EIT_MiniMap, IconDatum );

	CalcMiniMapLocation( C, I, NTP.Location, MiniMapLocation, NTP.bShowOnMiniMapEvenIfClamped );


	SetDrawColor( C, IconDatum.IconColor );
	if( I.bEnableAboveBelowIcons == TRUE && IconDatum.bAlternateAboveBelowIcon == TRUE )
	{
		DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, NTP.Location.Z, IconDatum.bShownEvenIfClamped );
	}
	else
	{
		DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconDatum.IconScale, IconDatum.AboveBelowIconScale, NTP.Location.Z, IconDatum.bShownEvenIfClamped );
	}
}


private function DrawNanoRooftopAccessIndicator_Debug(Canvas C, MinimapDrawInfo I, NanoTargetPoint NTP)
{
	DrawNanoRooftopAccessIndicator(C, I, NTP);
}


private function DrawNanoRooftopAccessIndicator(Canvas C, MinimapDrawInfo I, NanoTargetPoint NTP)
{
	local vector2d MiniMapLocation;

	local UIIconComponent UIComp;
	local IconDatum IconDatum;
	local bool bChaosIsActive;
	local float IconScale;
	local color IconColor;


	UIComp = NTP.GetUIIconComponent();

	UIComp.GetIconDatum( EIT_MiniMap, IconDatum );

	CalcMiniMapLocation( C, I, NTP.Location, MiniMapLocation, IconDatum.bShownEvenIfClamped );


	bChaosIsActive = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosLevel() > 0;

	if( bChaosIsActive == TRUE )
	{
		IconScale = IconDatum.IconScaleWithChaos;
		IconColor = IconDatum.IconColorWithChaos;
	}
	else
	{
		IconScale = IconDatum.IconScale;
		IconColor = IconDatum.IconColor;
	}

	SetDrawColor( C, IconColor );
	if( I.bEnableAboveBelowIcons == TRUE && IconDatum.bAlternateAboveBelowIcon == TRUE )
	{
		DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconScale, IconDatum.AboveBelowIconScale, NTP.Location.Z, IconDatum.bShownEvenIfClamped );
	}
	else
	{
		DrawAboveBelowIcon( C, I, IconDatum.Icon, MiniMapLocation, IconScale, IconDatum.AboveBelowIconScale, NTP.Location.Z, IconDatum.bShownEvenIfClamped );
	}
}




function DrawDebugPeds(Canvas C, MinimapDrawInfo I)
{
	local Pawn PlayerPawn;
	local vector PlayerRelativeLocation;
	local vector2d PlayerRelative2DLoc, PedLoc_Screen, ScreenCenter;
	local GameCrowdAgent Agent;
	local rotator ViewRot;
	local Texture2D PedIcon;

	PedIcon = Texture2D'UI_HUD.Minimap.GenericEnemy';


	PlayerPawn = HUDOwner.PlayerOwner.Pawn;
	
	ViewRot = PlayerPawn.GetViewRotation();
	ViewRot.Pitch = 0;

	// basically a whole-screen minimap
	ForEach HUDOwner.DynamicActors(class'GameCrowdAgent', Agent)
	{
		ScreenCenter.X = C.SizeX * 0.5f;
		ScreenCenter.Y = C.SizeY * 0.5f;

		PlayerRelativeLocation = (Agent.Location - PlayerPawn.Location) << ViewRot;

		// drop to 2d, adjust for axis differences
		PlayerRelative2DLoc.X = PlayerRelativeLocation.Y;
		PlayerRelative2DLoc.Y = -PlayerRelativeLocation.X;

		PedLoc_Screen = PlayerRelative2DLoc / I.MinimapToWorldScale + ScreenCenter;

		SetDrawColor(C, MakeColor(200,200,128,200));
		DrawTextureCentered(C, I, PedIcon, PedLoc_Screen, 0.06f );
	}

	// dot for player, in the center
	SetDrawColor(C, PlayerIconColor);
	DrawTextureCentered(C, I, PlayerIcon, ScreenCenter, PlayerIconScale);
}




defaultproperties
{
	SearchRadiusIcon=Texture2D'UI_HUD.Minimap.T_ConfrontRadius'
	SearchRadiusIconColorAlert=(R=255,G=255,B=0,A=255)
	SearchRadiusIconColorChasing=(R=255,G=64,B=64,A=255)

	PlayerIcon=Texture2D'UI_HUD.Minimap.PlayerMapIcon'
	PlayerIconScale=0.1f
	PlayerIconColor=(R=255,G=255,B=255,A=255)

	NDPIcon=Texture2D'Envy_Effects.Flares.Materials.T_EFX_Flare_Round_Hard_01'
	NDPIcon_AttackRadius=Texture2D'UI_HUD.Minimap.T_AttackRadius'
	NDPIcon_DefenseRadius=Texture2D'UI_HUD.Minimap.T_DefenseRadius'

	NDPIconScale=0.05f
	NDPIconColor=(R=238,G=230,B=140,A=255)
	NDPIconColor_AboutToBeAttacked=(R=255,G=64,B=64,A=255)
	NDPIconColor_YouWillBeInTrouble=(R=255,G=255,B=0,A=255)
	NDPIconColor_WillBeSafe=(R=211,G=211,B=211,A=255) // ghost

	
	//ScreenSize = 1280x720 pixels
	//MiniMapEdgeLength = MinimapSize.X ( .16  )   ==  204.8 pixels  so we will say 205
	//205 pixels  * MinimapToWorldScale for how much unrealunit space it is
	//So the MiniMap is  15375uu x 15375uu

	ChaosTier0Color=(R=64,G=255,B=64,A=255)
	ChaosTier1Color=(R=255,G=0,B=0,A=255)
	ChaosTier2Color=(R=255,G=0,B=0,A=255)

	//CircleRadiusIconFudge=2.1f

	PacmanIconColor_Red=(R=255,G=64,B=64,A=255)
	PacmanIconColor_Blue=(R=64,G=64,B=255,A=255)

	UpDownToNormalAlternateTime=1.0f;
}
