class UTMapInfo extends UDKMapInfo
    native
    editinlinenew;

var() int RecommendedPlayersMin;
var() int RecommendedPlayersMax;
var() UTMapMusicInfo MapMusicInfo;
var(Minimap) Texture MapTexture;
var(Minimap) float MapTextureYaw;
var(Minimap) Vector MapCenter;
var(Minimap) float MapExtent;
var(Minimap) int MapYaw;
var(Minimap) float RotatingMiniMapRange;
var(Map) float DefaultMapSize;
var array<EvilGameObjective> Objectives;
var transient bool bMapUpToDate;
var transient Actor CurrentActor;
var transient Actor WatchedActor;
var transient Material HudIcons;
var transient Texture2D HUDIconsT;
var Vector MapRotX;
var Vector MapRotY;
var int CurrentMapRotYaw;
var transient MaterialInstanceConstant MapMaterialInstance;
var Material MapMaterialReference;
var float UseableRadius;
var transient Vector ActualMapCenter;
var transient float RadarWidth;
var transient float RadarRange;
var transient Vector CenterPos;
var transient float MapScale;
var transient float ColorPercent;
var transient MaterialInstanceConstant GreenIconMaterialInstance;
var TextureCoordinates PlayerIconCoords;
var UDKVehicle KeyVehicles[2];
var array<EvilGameObjective> Sensors;

simulated function VerifyMapExtent()
{
    local int NumNodes;
    local EvilGameObjective O;
    local WorldInfo WI;

    // End:0x156
    if(MapExtent == float(0))
    {
        WI = WorldInfo(Outer);
        MapCenter = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0xA7
        foreach WI.AllActors(Class'EvilGameObjective', O)
        {
            MapCenter += O.Location;
            NumNodes++;            
        }        
        // End:0x156
        if(NumNodes > 0)
        {
            MapCenter = MapCenter / float(NumNodes);
            // End:0x155
            foreach WI.AllActors(Class'EvilGameObjective', O)
            {
                MapExtent = FMax(MapExtent, 2.7500000 * VSize2D(MapCenter - O.Location));                
            }            
        }
    }
    //return;    
}

function FindObjectives()
{
    local EvilGameObjective Obj;

    bMapUpToDate = true;
    // End:0x68
    foreach WorldInfo(Outer).AllNavigationPoints(Class'EvilGameObjective', Obj)
    {
        Objectives[Objectives.Length] = Obj;        
    }    
    // End:0xF1
    if(MapMaterialInstance == none)
    {
        MapMaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
        MapMaterialInstance.SetParent(MapMaterialReference);
        MapMaterialInstance.SetTextureParameterValue('LevelMap', MapTexture);
    }
    //return;    
}

simulated function RenderLinks(Canvas Canvas, UTPlayerController PlayerOwner)
{
    local int I;
    local LinearColor NodeColor;
    local float AttackScale, CurrentScale;

    I = 0;
    J0x0B:

    // End:0x94A [Loop If]
    if(I < Objectives.Length)
    {
        // End:0x93C
        if(((Objectives[I] != none) && Objectives[I].IconHudTexture != none) && !Objectives[I].bIsDisabled)
        {
            // End:0x42B
            if(Objectives[I].bUnderAttack)
            {
                AttackScale = (0.0300000 * Canvas.ClipX) * (1.5000000 + (0.5000000 * Sin(6.0000000 * PlayerOwner.WorldInfo.TimeSeconds)));
                Canvas.SetPos(Objectives[I].HUDLocation.X - (0.5000000 * AttackScale), Objectives[I].HUDLocation.Y - (0.5000000 * AttackScale));
                Objectives[I].AttackLinearColor.B = ColorPercent;
                Canvas.DrawTile(Objectives[I].IconHudTexture, AttackScale, (AttackScale * Objectives[I].IconCoords.VL) / Objectives[I].IconCoords.UL, Objectives[I].AttackCoords.U, Objectives[I].AttackCoords.V, Objectives[I].AttackCoords.UL, Objectives[I].AttackCoords.VL, Objectives[I].AttackLinearColor);
            }
            NodeColor = Objectives[I].ControlColor[Min(int(Objectives[I].DefenderTeamIndex), 2)];
            // End:0x677
            if(Objectives[I].bIsConstructing)
            {
                NodeColor.R *= ColorPercent;
                NodeColor.G *= ColorPercent;
                NodeColor.B *= ColorPercent;
                NodeColor.R += (Objectives[I].ControlColor[2].R * (1.0000000 - ColorPercent));
                NodeColor.G += (Objectives[I].ControlColor[2].G * (1.0000000 - ColorPercent));
                NodeColor.B += (Objectives[I].ControlColor[2].B * (1.0000000 - ColorPercent));
            }
            // End:0x898
            if(Objectives[I].HighlightScale > 1.0000000)
            {
                CurrentScale = (PlayerOwner.WorldInfo.TimeSeconds - Objectives[I].LastHighlightUpdate) / Objectives[I].HighlightSpeed;
                Objectives[I].HighlightScale = FMax(1.0000000, Objectives[I].HighlightScale - (CurrentScale * Objectives[I].MaxHighlightScale));
                Objectives[I].DrawIcon(Canvas, Objectives[I].HUDLocation, (Objectives[I].MinimapIconScale * Objectives[I].HighlightScale) * MapScale, 1.0000000, PlayerOwner, NodeColor);                
            }
            else
            {
                Objectives[I].DrawIcon(Canvas, Objectives[I].HUDLocation, Objectives[I].MinimapIconScale * MapScale, 1.0000000, PlayerOwner, NodeColor);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function RenderAdditionalInformation(Canvas Canvas, UTPlayerController PlayerOwner)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xED [Loop If]
    if(I < Objectives.Length)
    {
        // End:0xDF
        if(((Objectives[I] != none) && Objectives[I].bScriptRenderAdditionalMinimap) && !Objectives[I].bIsDisabled)
        {
            Objectives[I].RenderMinimap(self, Canvas, PlayerOwner, ColorPercent);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function UpdateNodes(UTPlayerController PlayerOwner)
{
    local int I;

    Sensors.Length = 0;
    I = 0;
    J0x17:

    // End:0x1E1 [Loop If]
    if(I < Objectives.Length)
    {
        // End:0x1D3
        if(Objectives[I] != none)
        {
            Objectives[I].bAlreadyRendered = false;
            Objectives[I].SetHUDLocation(UpdateHUDLocation(Objectives[I].Location));
            // End:0x1D3
            if((Objectives[I].bHasSensor && Objectives[I].WorldInfo.GRI != none) && Objectives[I].WorldInfo.GRI.OnSameTeam(Objectives[I], PlayerOwner))
            {
                Sensors.AddItem(Objectives[I]);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

simulated function DrawMap(Canvas Canvas, UTPlayerController PlayerOwner, float XPos, float YPos, float Width, float Height, bool bFullDetail, float AspectRatio)
{
    local int I, J, PlayerYaw, SecondPlayerYaw, NumObjectives, TeamNum;

    local Vector PlayerLocation, SecondPlayerLocation, ScreenLocation, SecondScreenLocation, WatchedLocation, CurrentObjectiveHUDLocation,
	    NorthLocation, NorthDir;

    local float MinRadarRange, hw, hh, DotScale;
    local Pawn PawnOwner, P, SecondPawn;
    local LinearColor FinalColor, TC;
    local bool bInSensorRange, bIsSplitScreen;
    local EvilPawn UTP;
    local EvilPlayerController PC;
    local EvilVehicle_Base V;
    local EvilTeamInfo Team;
    local Rotator MapRot;
    local WorldInfo WI;

    // End:0x37
    if((PlayerOwner == none) || PlayerOwner.PlayerReplicationInfo == none)
    {
        return;
    }
    TC = (((PlayerOwner.PlayerReplicationInfo.Team != none) && PlayerOwner.PlayerReplicationInfo.Team.TeamIndex == 1) ? MakeLinearColor(0.0000000, 0.0000000, 0.4000000, 1.0000000) : MakeLinearColor(0.2000000, 0.0000000, 0.0000000, 1.0000000));
    VerifyMapExtent();
    // End:0x12B
    if(!bMapUpToDate)
    {
        FindObjectives();
    }
    NumObjectives = Objectives.Length;
    // End:0x150
    if(NumObjectives == 0)
    {
        return;
    }
    WI = WorldInfo(Outer);
    ColorPercent = 0.5000000 + (Cos(((WI.RealTimeSeconds * 4.0000000) * 3.1415900) * 0.5000000) * 0.5000000);
    PawnOwner = Pawn(PlayerOwner.ViewTarget);
    CenterPos.Y = YPos + (Height * 0.5000000);
    CenterPos.X = XPos + (Width * 0.5000000);
    MapScale = (1.5000000 * Height) / DefaultMapSize;
    RadarWidth = (Height * UseableRadius) * float(2);
    ScreenLocation = ((PawnOwner != none) ? PawnOwner.Location : PlayerOwner.Location);
    PlayerYaw = PlayerOwner.Rotation.Yaw & 65535;
    RadarRange = MapExtent;
    MapRot.Yaw = int(float(MapYaw) * 182.0444000);
    ActualMapCenter = MapCenter;
    bIsSplitScreen = Class'Engine.Engine'.static.IsSplitScreen();
    PlayerOwner.bRotateMinimap = PlayerOwner.bRotateMinimap && !bIsSplitScreen;
    // End:0x51C
    if(!bFullDetail && PlayerOwner.bRotateMinimap)
    {
        ActualMapCenter = ScreenLocation;
        MapRot.Yaw = PlayerYaw + 16384;
        MinRadarRange = RotatingMiniMapRange;
        DrawMapImage(Canvas, XPos, YPos, Width, Height, (float(PlayerYaw) - (float(MapYaw) * 182.0444000)) + float(16384), MinRadarRange / RadarRange);
        RadarRange = MinRadarRange;        
    }
    else
    {
        DrawMapImage(Canvas, XPos, YPos, Width, Height, 0.0000000, 1.0000000);
        RadarWidth = Width;
    }
    hw = Width * 0.5000000;
    hh = Height * 0.5000000;
    Canvas.SetPos(XPos, YPos);
    Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, hw, hh, 215.0000000, 579.0000000, 347.0000000, 347.0000000, TC);
    Canvas.SetPos(XPos + hw, YPos);
    Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, hw, hh, 562.0000000, 579.0000000, -347.0000000, 347.0000000, TC);
    Canvas.SetPos(XPos, YPos + hh);
    Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, hw, hh, 215.0000000, 926.0000000, 347.0000000, -347.0000000, TC);
    Canvas.SetPos(XPos + hw, YPos + hh);
    Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, hw, hh, 562.0000000, 926.0000000, -347.0000000, -347.0000000, TC);
    DotScale = hw / float(347);
    // End:0xAE1
    if(!bFullDetail && PlayerOwner.bRotateMinimap)
    {
        NorthDir = MapRotY;
        NorthDir.X *= -1.0000000;
        NorthLocation = CenterPos - ((0.9200000 * hh) * NorthDir);
        NorthLocation.X -= (29.5000000 * DotScale);
        NorthLocation.Y -= (33.5000000 * DotScale);
        Canvas.DrawColor = Class'UTHUD'.default.RedColor;
        Canvas.DrawColor.R = 128;
        Canvas.SetPos(NorthLocation.X, NorthLocation.Y);
        NorthDir = MapRotX;
        NorthDir.Y *= -1.0000000;
        Canvas.DrawRotatedTile(Class'UTHUD'.default.IconHudTexture, Rotator(NorthDir), 59.0000000 * DotScale, 67.0000000 * DotScale, 725.0000000, 175.0000000, 59.0000000, 67.0000000);        
    }
    else
    {
        Canvas.SetPos((XPos + hw) - (29.5000000 * DotScale), YPos - (float(5) * DotScale));
        Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, 59.0000000 * DotScale, 67.0000000 * DotScale, 725.0000000, 175.0000000, 59.0000000, 67.0000000, TC);
    }
    ChangeMapRotation(MapRot);
    Canvas.SetPos(CenterPos.X - (0.5000000 * RadarWidth), CenterPos.Y - (0.5000000 * RadarWidth));
    // End:0xD5C
    if((PawnOwner != none) && PlayerOwner.Pawn == PawnOwner)
    {
        PlayerLocation = UpdateHUDLocation(ScreenLocation);
        Canvas.DrawColor = Class'EvilTeamInfo'.default.BaseTeamColor[2];
        DrawRotatedTile(Canvas, Class'UTHUD'.default.IconHudTexture, PlayerLocation, PlayerYaw + 16384, 2.0000000, PlayerIconCoords, MakeLinearColor(0.4000000, 1.0000000, 0.4000000, 1.0000000));
    }
    // End:0xF53
    if(bIsSplitScreen)
    {
        // End:0xDB8
        foreach PlayerOwner.LocalPlayerControllers(Class'EvilPlayerController', PC)
        {
            // End:0xDB7
            if(PC != PlayerOwner)
            {
                // End:0xDB8
                break;
            }            
        }        
        // End:0xF53
        if((PC != none) && PC.Pawn != none)
        {
            SecondPawn = PC.Pawn;
            SecondScreenLocation = SecondPawn.Location;
            SecondPlayerYaw = PC.Rotation.Yaw & 65535;
            SecondPlayerLocation = UpdateHUDLocation(SecondScreenLocation);
            Canvas.DrawColor = Class'EvilTeamInfo'.default.BaseTeamColor[2];
            DrawRotatedTile(Canvas, Class'UTHUD'.default.IconHudTexture, SecondPlayerLocation, SecondPlayerYaw + 16384, 2.0000000, PlayerIconCoords, MakeLinearColor(1.0000000, 1.0000000, 0.4000000, 1.0000000));
        }
    }
    FinalColor = Class'UTHUD'.default.WhiteLinearColor;
    UpdateNodes(PlayerOwner);
    // End:0x13B6
    if(bFullDetail)
    {
        I = 0;
        J0xFA6:

        // End:0x1235 [Loop If]
        if(I < NumObjectives)
        {
            // End:0x1227
            if(WI.GRI.OnSameTeam(Objectives[I], PlayerOwner))
            {
                FinalColor = Objectives[I].ControlColor[int(Objectives[I].DefenderTeamIndex)];
                FinalColor.A = 1.0000000;
                J = 0;
                J0x109A:

                // End:0x1227 [Loop If]
                if(J < Objectives[I].VehicleFactories.Length)
                {
                    // End:0x1219
                    if(Objectives[I].VehicleFactories[J].bHasLockedVehicle)
                    {
                        Objectives[I].VehicleFactories[J].SetHUDLocation(UpdateHUDLocation(Objectives[I].VehicleFactories[J].Location));
                        Objectives[I].VehicleFactories[J].RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
                    }
                    J++;
                    // [Loop Continue]
                    goto J0x109A;
                }
            }
            I++;
            // [Loop Continue]
            goto J0xFA6;
        }
        // End:0x13B6
        if(WatchedActor != none)
        {
            WatchedLocation = GetActorHudLocation(WatchedActor);
            Canvas.SetPos(WatchedLocation.X - (float(15) * MapScale), WatchedLocation.Y - (((float(15) * MapScale) * Canvas.ClipY) / Canvas.ClipX));
            Canvas.SetDrawColor(255, 255, 255, 128);
            Canvas.DrawTile(Class'UTHUD'.default.AltHudTexture, 31.0000000 * MapScale, 31.0000000 * MapScale, 273.0000000, 494.0000000, 12.0000000, 13.0000000);
        }
    }
    RenderLinks(Canvas, PlayerOwner);
    // End:0x192C
    if(bFullDetail)
    {
        I = 0;
        J0x13EA:

        // End:0x1472 [Loop If]
        if(I < NumObjectives)
        {
            Objectives[I].RenderExtraDetails(self, Canvas, PlayerOwner, ColorPercent, Objectives[I] == CurrentActor);
            I++;
            // [Loop Continue]
            goto J0x13EA;
        }
        // End:0x1928
        foreach WI.AllPawns(Class'Engine.Pawn', P)
        {
            bInSensorRange = false;
            // End:0x154A
            if(((P.bHidden || P.Health <= 0) || P.IsInvisible()) || P.DrivenVehicle != none)
            {
                continue;                
            }
            V = EvilVehicle_Base(P);
            // End:0x15C4
            if(V != none)
            {
                // End:0x15C1
                if(V.bTeamLocked && !V.bKeyVehicle)
                {
                    continue;                    
                }                
            }
            else
            {
                UTP = EvilPawn(P);
                // End:0x160C
                if((UTP == none) || UTP == PawnOwner)
                {
                    continue;                    
                }
            }
            // End:0x1664
            if(WI.GRI.OnSameTeam(PlayerOwner, P))
            {
                bInSensorRange = true;                
            }
            else
            {
                I = 0;
                J0x166F:

                // End:0x171B [Loop If]
                if(I < Sensors.Length)
                {
                    // End:0x170D
                    if(VSize(P.Location - Sensors[I].Location) < Sensors[I].MaxSensorRange)
                    {
                        bInSensorRange = true;
                        // [Explicit Break]
                        goto J0x171B;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x166F;
                }
            }
            J0x171B:

            // End:0x1927
            if(bInSensorRange)
            {
                P.SetHUDLocation(UpdateHUDLocation(P.Location));
                // End:0x1805
                if(V != none)
                {
                    Class'UTHUD'.static.GetTeamColor(int(V.Team), FinalColor);
                    V.RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
                    // End:0x1927
                    continue;
                }
                TeamNum = (((UTP.PlayerReplicationInfo != none) && UTP.PlayerReplicationInfo.Team != none) ? UTP.PlayerReplicationInfo.Team.TeamIndex : 2);
                Class'UTHUD'.static.GetTeamColor(TeamNum, FinalColor);
                UTP.RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
            }            
        }                
    }
    else
    {
        I = 0;
        J0x1937:

        // End:0x1B1A [Loop If]
        if(I < 2)
        {
            // End:0x1963
            if(KeyVehicles[I] == none)
            {                
            }
            else
            {
                // End:0x1A10
                if((!EvilVehicle_Base(KeyVehicles[I]).bKeyVehicle || KeyVehicles[I].Health <= 0) || KeyVehicles[I].bDeleteMe)
                {
                    KeyVehicles[I] = none;                    
                }
                else
                {
                    KeyVehicles[I].SetHUDLocation(UpdateHUDLocation(KeyVehicles[I].Location));
                    Class'UTHUD'.static.GetTeamColor(int(KeyVehicles[I].Team), FinalColor);
                    EvilVehicle_Base(KeyVehicles[I]).RenderMapIcon(self, Canvas, PlayerOwner, FinalColor);
                }
            }
            I++;
            // [Loop Continue]
            goto J0x1937;
        }
    }
    // End:0x1E9D
    if(EvilTeamInfo(PlayerOwner.PlayerReplicationInfo.Team) != none)
    {
        J = 0;
        J0x1B67:

        // End:0x1E9D [Loop If]
        if(J < 2)
        {
            Team = EvilTeamInfo(WI.GRI.Teams[J]);
            // End:0x1E8F
            if((Team != none) && Team.TeamFlag != none)
            {
                bInSensorRange = Team.TeamFlag.ShouldMinimapRenderFor(PlayerOwner);
                I = 0;
                // End:0x1D2C
                if(!bInSensorRange)
                {
                    I = 0;
                    J0x1C69:

                    // End:0x1D2C [Loop If]
                    if(I < Sensors.Length)
                    {
                        // End:0x1D1E
                        if(VSizeSq(Team.TeamFlag.Location - Sensors[I].Location) < Square(Sensors[I].MaxSensorRange))
                        {
                            bInSensorRange = true;
                            // [Explicit Break]
                            goto J0x1D2C;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x1C69;
                    }
                }
                J0x1D2C:

                // End:0x1E8F
                if(bInSensorRange)
                {
                    Team.TeamFlag.SetHUDLocation(UpdateHUDLocation(Team.TeamFlag.Location));
                    // End:0x1E35
                    if(Team == PlayerOwner.PlayerReplicationInfo.Team)
                    {
                        Team.TeamFlag.RenderMapIcon(self, Canvas, PlayerOwner);                        
                    }
                    else
                    {
                        Team.TeamFlag.RenderEnemyMapIcon(self, Canvas, PlayerOwner, Sensors[I]);
                    }
                }
            }
            J++;
            // [Loop Continue]
            goto J0x1B67;
        }
    }
    RenderAdditionalInformation(Canvas, PlayerOwner);
    // End:0x204F
    if(PlayerOwner.LastAutoObjective != none)
    {
        CurrentObjectiveHUDLocation = UpdateHUDLocation(PlayerOwner.LastAutoObjective.Location);
        Canvas.SetPos(CurrentObjectiveHUDLocation.X - (float(12) * MapScale), CurrentObjectiveHUDLocation.Y - (float(12) * MapScale));
        Canvas.SetDrawColor(255, 255, 0, byte(float(255) * (1.0000000 - ColorPercent)));
        Canvas.DrawTile(Class'UTHUD'.default.IconHudTexture, 23.0000000 * MapScale, 23.0000000 * MapScale, 669.0000000, 266.0000000, 75.0000000, 75.0000000);
    }
    Canvas.SetDrawColor(255, 255, 255, 255);
    //return;    
}

simulated function AddKeyVehicle(EvilVehicle_Base V)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x4C [Loop If]
    if(I < 2)
    {
        // End:0x3E
        if(KeyVehicles[I] == V)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x57:

    // End:0x10B [Loop If]
    if(I < 2)
    {
        // End:0xFD
        if(((KeyVehicles[I] == none) || KeyVehicles[I].bDeleteMe) || KeyVehicles[I].Health <= 0)
        {
            KeyVehicles[I] = V;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x57;
    }
    KeyVehicles[1] = V;
    //return;    
}

function DrawRotatedTile(Canvas Canvas, Texture2D T, Vector MapLocation, int InYaw, float IconScale, TextureCoordinates TexCoords, LinearColor DrawColor)
{
    local Rotator R;
    local float Width, Height;

    R.Yaw = InYaw - CurrentMapRotYaw;
    Width = (TexCoords.UL * (MapScale / float(4))) * IconScale;
    Height = (TexCoords.VL * (MapScale / float(4))) * IconScale;
    Canvas.SetPos(MapLocation.X - (0.5000000 * Width), MapLocation.Y - (0.5000000 * Height));
    Canvas.DrawColor = MakeColor(byte(DrawColor.R * float(255)), byte(DrawColor.G * float(255)), byte(DrawColor.B * float(255)), byte(DrawColor.A * float(255)));
    Canvas.super(UTMapInfo).DrawRotatedTile(T, R, Width, Height, TexCoords.U, TexCoords.V, TexCoords.UL, TexCoords.VL);
    //return;    
}

function DrawRotatedMaterialTile(Canvas Canvas, MaterialInstanceConstant M, Vector MapLocation, int InYaw, float XWidth, float YWidth, float XStart, float YStart, float XLength, float YLength)
{
    local Rotator R;

    R.Yaw = InYaw - CurrentMapRotYaw;
    M.SetScalarParameterValue('TexRotation', 0.0000000);
    Canvas.SetPos(MapLocation.X - ((0.5000000 * XWidth) * MapScale), MapLocation.Y - ((0.5000000 * YWidth) * MapScale));
    Canvas.super(UTMapInfo).DrawRotatedMaterialTile(M, R, XWidth * MapScale, YWidth * MapScale, XStart, YStart, XLength, YLength);
    //return;    
}

function Vector UpdateHUDLocation(Vector InLocation)
{
    local Vector ScreenLocation, NewHUDLocation;
    local float Scaling;

    ScreenLocation = InLocation - ActualMapCenter;
    // End:0x67
    if(VSizeSq(ScreenLocation) > Square(0.5500000 * RadarRange))
    {
        ScreenLocation = (0.5500000 * RadarRange) * Normal(ScreenLocation);
    }
    Scaling = RadarWidth / RadarRange;
    NewHUDLocation.X = CenterPos.X + ((ScreenLocation Dot MapRotX) * Scaling);
    NewHUDLocation.Y = CenterPos.Y + ((ScreenLocation Dot MapRotY) * Scaling);
    NewHUDLocation.Z = 0.0000000;
    return NewHUDLocation;
    //return ReturnValue;    
}

function ChangeMapRotation(Rotator NewMapRotation)
{
    local Vector Z;

    // End:0x2C
    if(CurrentMapRotYaw == NewMapRotation.Yaw)
    {
        return;
    }
    GetAxes(NewMapRotation, MapRotX, MapRotY, Z);
    CurrentMapRotYaw = NewMapRotation.Yaw;
    //return;    
}

function DrawMapImage(Canvas Canvas, float X, float Y, float W, float H, float PlayerYaw, float BkgImgScaling)
{
    local Rotator MapTexRot;
    local Vector Offset;

    // End:0x26C
    if((MapMaterialInstance != none) && MapTexture != none)
    {
        MapMaterialInstance.SetScalarParameterValue('MapScale_Parameter', BkgImgScaling);
        Offset = MapCenter - ActualMapCenter;
        Offset.X = Offset.X / MapExtent;
        Offset.Y = Offset.Y / MapExtent;
        MapMaterialInstance.SetScalarParameterValue('U_Parameter', -Offset.Y);
        MapMaterialInstance.SetScalarParameterValue('V_Parameter', Offset.X);
        MapMaterialInstance.SetScalarParameterValue('Rot_Value', (MapTextureYaw / 360.0000000) * -4.0000000);
        MapTexRot.Yaw = int(PlayerYaw * float(-1));
        Canvas.SetPos(X, Y);
        Canvas.DrawRotatedMaterialTile(MapMaterialInstance, MapTexRot, W, H);
    }
    //return;    
}

function Vector GetActorHudLocation(Actor CActor)
{
    // End:0x43
    if(EvilGameObjective(CActor) != none)
    {
        return EvilGameObjective(CActor).HUDLocation;        
    }
    else
    {
        // End:0x83
        if(EvilVehicle_Base(CActor) != none)
        {
            return EvilVehicle_Base(CActor).HUDLocation;
        }
    }
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

defaultproperties
{
    RecommendedPlayersMin=6
    RecommendedPlayersMax=10
    RotatingMiniMapRange=12000.0000000
    DefaultMapSize=255.0000000
    MapRotX=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    MapRotY=(X=0.0000000,Y=1.0000000,Z=0.0000000)
    UseableRadius=0.3921000
    PlayerIconCoords=(U=657.0000000,V=129.0000000,UL=68.0000000,VL=106.0000000)
}