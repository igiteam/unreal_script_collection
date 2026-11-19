class R6RadarConfig extends R6Config
    native
    hidecategories(Object);

struct RadarIcon
{
    var() bool m_bShowOutOfBoundVertical;
    var() bool m_bShowOutOfBoundHorizontal;
    var() bool m_bUseAllianceColor;
    var() bool m_bUseHudColor;
    var() Color m_Color;
    var() Texture2D m_pTexture;
    var() float m_fRadarTextureScale;
    var() Texture2D m_pWaypointTexture;

    structdefaultproperties
    {
        m_bShowOutOfBoundVertical=false
        m_bShowOutOfBoundHorizontal=false
        m_bUseAllianceColor=false
        m_bUseHudColor=false
        m_Color=(R=255,G=255,B=255,A=255)
        m_pTexture=none
        m_fRadarTextureScale=1.0000000
        m_pWaypointTexture=none
    }
};

var(Icons) RadarIcon m_pIconDefault;
var(Icons) RadarIcon m_pIconBriefcase;
var(Icons) RadarIcon m_pIconBomb;
var(Icons) RadarIcon m_pIconBombInteractive;
var(Icons) RadarIcon m_pIconCanister;
var(Icons) RadarIcon m_pIconDepotStation;
var(Icons) RadarIcon m_pIconDoor;
var(Icons) RadarIcon m_pIconExtractionZone;
var(Icons) RadarIcon m_pIconFastRope;
var(Icons) RadarIcon m_pIconLadder;
var(Icons) RadarIcon m_pIconObjective;
var(Icons) RadarIcon m_pIconOrderClear;
var(Icons) RadarIcon m_pIconOrderEnemySpotted;
var(Icons) RadarIcon m_pIconOrderHold;
var(Icons) RadarIcon m_pIconOrderRegroup;
var(Icons) RadarIcon m_pIconPawn;
var(Icons) RadarIcon m_pIconPawnHostage;
var(Icons) RadarIcon m_pIconPawnIncapacitated;
var(Icons) RadarIcon m_pIconPawnTagged;
var(Icons) RadarIcon m_pIconPawnTeammateActive;
var(Icons) RadarIcon m_pIconPlayer;
var(Icons) RadarIcon m_pIconWindow;
var(Icons) RadarIcon m_pIconSatellite;
var(Colors) Color m_ColorEnemy;
var(Colors) Color m_ColorFriend;
var(Colors) Color m_ColorHud;
var(Colors) Color m_ColorNeutral;
var(Textures) Texture2D m_OutOfBoundHorizontal;
var(Textures) Texture2D m_FloorIndicatorIcon;
var(Textures) Texture2D m_3DWaypointArrowIcon;
var(Textures) Texture2D m_3DWaypointBackground;
var(MapGeneration) Color m_GenerateFloorColor;
var(MapGeneration) Color m_GenerateWallColor;
var(MapGeneration) Color m_GenerateBackgroundColor;
var(Distance) float m_HorizontalScanDistance;
var(Distance) float m_VerticalScanDistance;
var(Distance) Vector2D m_MapDistance;
var(Distance) float m_SnakecamOffset;
var(Distance) int m_DefaultOffset;
var(Distance) float m_SnakecamTransitionSpeed;
var(Distance) float m_WaypointMinDistance;
var(Time) float m_fTimeShowDeadPawn;
var(Time) float m_TimeToShowSpottedEnemies;
var(Time) float m_TimeToShowSpottedCivils;
var(Time) float m_fTimeShowOwnRadarGlitch;
var(Zoom) float m_ZoomMinimapStand;
var(Zoom) float m_ZoomMinimapWalk;
var(Zoom) float m_ZoomTacticalStand;
var(Zoom) float m_ZoomTacticalWalk;
var(Zoom) float m_ZoomPauseMenu;
var(Zoom) float m_ZoomingSpeed;
var(Zoom) float m_fMinWalkSpeed;
var(Zoom) bool m_bScaleTextures;
var(Zoom) bool m_bMinimapRotate;
var(Zoom) bool m_bTacticalRotate;
var(Zoom) float m_f3DWaypointTexutreScaling;
var(Network) float m_UpdateFrequency;
var Vector2D m_ptTopLeft;
var Vector2D m_ptTopRight;
var Vector2D m_ptBottomLeft;
var Vector2D m_ptBottomRight;

defaultproperties
{
    m_pIconDefault=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconBriefcase=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconBomb=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconBombInteractive=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconCanister=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconDepotStation=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconDoor=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconExtractionZone=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconFastRope=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconLadder=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconObjective=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconOrderClear=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconOrderEnemySpotted=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconOrderHold=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconOrderRegroup=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPawn=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPawnHostage=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPawnIncapacitated=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPawnTagged=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPawnTeammateActive=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconPlayer=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconWindow=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_pIconSatellite=(m_bShowOutOfBoundVertical=false,m_bShowOutOfBoundHorizontal=false,m_bUseAllianceColor=false,m_bUseHudColor=false,m_Color=(R=255,G=255,B=255,A=255),m_pTexture=none,m_fRadarTextureScale=1.0000000,m_pWaypointTexture=none)
    m_GenerateFloorColor=(R=46,G=46,B=46,A=51)
    m_GenerateWallColor=(R=230,G=230,B=230,A=236)
    m_GenerateBackgroundColor=(R=81,G=81,B=81,A=255)
    m_HorizontalScanDistance=2000.0000000
    m_VerticalScanDistance=250.0000000
    m_SnakecamOffset=25.0000000
    m_DefaultOffset=25
    m_SnakecamTransitionSpeed=15.0000000
    m_WaypointMinDistance=2.0000000
    m_fTimeShowDeadPawn=10.0000000
    m_TimeToShowSpottedEnemies=3.0000000
    m_TimeToShowSpottedCivils=8.0000000
    m_fTimeShowOwnRadarGlitch=1.2000000
    m_ZoomMinimapStand=0.5000000
    m_ZoomMinimapWalk=0.4000000
    m_ZoomTacticalStand=0.2000000
    m_ZoomTacticalWalk=0.1700000
    m_ZoomPauseMenu=1.0000000
    m_ZoomingSpeed=0.5000000
    m_fMinWalkSpeed=50.0000000
    m_bMinimapRotate=true
    m_f3DWaypointTexutreScaling=0.7500000
    m_UpdateFrequency=0.3000000
}