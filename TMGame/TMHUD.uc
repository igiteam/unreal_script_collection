/**
 * TMHUD
 * TM Heads Up Display
 *
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMHUD extends HUD//GameHUD
    dependson(TMWeapon)
    native(UI)
    config(Game);

var class<TMLocalMessage> WeaponSwitchMessage;

/** Cached reference to the another hud texture */
var const Texture2D AltHudTexture;
var const Texture2D IconHudTexture;
var const Texture2D TalkingTexture;
var const Texture2D TM3GHudTexture;

/** Holds a reference to the font to use for a given console */
var config string ConsoleIconFontClassName;
var font ConsoleIconFont;

var TextureCoordinates ToolTipSepCoords;
var float LastTimeTooltipDrawn;

var const LinearColor LC_White;

var const color LightGoldColor, LightGreenColor;
var const color GrayColor;

/** used to pulse the scaled of several hud elements */
var float LastPickupTime, LastAmmoPickupTime, LastHealthPickupTime, LastArmorPickupTime;

/** The Pawn that is currently owning this hud */
var Pawn PawnOwner;

/** Points to the TM Pawn.  Will be resolved if in a vehicle */
var TMPawn TMPawnOwner;

/** Cached a typed Player controller.  Unlike PawnOwner we only set this once in PostBeginPlay */
var TMPlayerController TMPlayerOwner;

/** Cached typed reference to the PRI */
var TMPlayerReplicationInfo TMOwnerPRI;

/** If true, we will allow Weapons to show their crosshairs */
var bool bCrosshairShow;

/** Debug flag to show AI information */
var bool bShowAllAI;

/** Cached reference to the GRI */
var TMGameReplicationInfo TMGRI;

/** Holds the scaling factor given the current resolution.  This is calculated in PostRender() */
var float ResolutionScale, ResolutionScaleX;

var bool bHudMessageRendered;

/******************************************************************************************
  UI/SCENE data for the hud
 ******************************************************************************************/

/** The Scoreboard. */
//var TMUIScene_Scoreboard ScoreboardSceneTemplate;

/** class of dynamic music manager used with this hud/gametype */
var class<TMMusicManager> MusicManagerClass;

/** A collection of fonts used in the hud */
var array<font> HudFonts;

/** If true, we will alter the crosshair when it's over a friendly */
var bool bCrosshairOnFriendly;

/** Make the crosshair green (found valid friendly */
var bool bGreenCrosshair;

/******************************************************************************************
 Character Portraits
 ******************************************************************************************/

/** The material used to display the portrait */
var material CharPortraitMaterial;

/** The MI that we will set */
var MaterialInstanceConstant CharPortraitMI;

/** How far down the screen will it be rendered */
var float CharPortraitYPerc;

/** When sliding in, where should this image stop */
var float CharPortraitXPerc;

/** How long until we are done */
var float CharPortraitTime;

/** Total Amount of time to display a portrait for */
var float CharPortraitSlideTime;

/** % of Total time to slide In/Out.  It will be used on both sides.  Ex.  If set to 0.25 then
    the slide in will be 25% of the total time as will the slide out leaving 50% of the time settled
    on screen. **/
var float CharPortraitSlideTransitionTime;

/** How big at 1024x768 should this be */
var vector2D CharPortraitSize;

/** Holds the PRI of the person speak */
var TMPlayerReplicationInfo CharPRI;

/** Holds the PRI of who we want to switch to */
var TMPlayerReplicationInfo CharPendingPRI;


/******************************************************************************************
 WEAPONBAR
 ******************************************************************************************/

/** If true, weapon bar is never displayed */
var config bool bShowWeaponbar;

/** If true, only show available weapons on weapon bar */
var config bool bShowOnlyAvailableWeapons;

/** If true, only weapon bar if have pendingweapon */
var config bool bOnlyShowWeaponBarIfChanging;

/** Scaling to apply to entire weapon bar */
var float WeaponBarScale;

var float WeaponBoxWidth, WeaponBoxHeight;

/** Resolution dependent HUD scaling factor */
var float HUDScaleX, HUDScaleY;
var linearcolor TeamHUDColor;
var color TeamTextColor;

/** Weapon bar top left corner at 1024x768, normal scale */
var float WeaponBarY;

/** List of weapons to display in weapon bar */
var TMWeapon WeaponList[10];
var float CurrentWeaponScale[10];

var float SelectedWeaponScale;
var float BounceWeaponScale;
var float SelectedWeaponAlpha;
var float OffWeaponAlpha;
var float EmptyWeaponAlpha;
var float LastHUDUpdateTime;
var int BouncedWeapon;
var float WeaponScaleSpeed;
var float WeaponBarXOffset;
var float WeaponXOffset;
var float SelectedBoxScale;
var float WeaponYScale;
var float WeaponYOffset;
var float WeaponAmmoLength;
var float WeaponAmmoThickness;
var float WeaponAmmoOffsetX;
var float WeaponAmmoOffsetY;
var float SelectedWeaponAmmoOffsetX;
var bool bNoWeaponNumbers;
var float LastWeaponBarDrawnTime;

/******************************************************************************************
 MOTD
 ******************************************************************************************/

//var TMUIScene_MOTD MOTDSceneTemplate;

/******************************************************************************************
 Messaging
 ******************************************************************************************/

/** Y offsets for local message areas - value above 1 = special position in right top corner of HUD */
var float MessageOffset[7];

/** Various colors */
var const color BlackColor, GoldColor;

/******************************************************************************************
 Map / Radar
 ******************************************************************************************/

/** The background texture for the map */
var Texture2D MapBackground;

/** Holds the default size in pixels at 1024x768 of the map */
var config float MapDefaultSize;

/** The orders to display when rendering the map */
var string DisplayedOrders;

/** last time at which displayedorders was updated */
var float OrderUpdateTime;

var Weapon LastSelectedWeapon;


/******************************************************************************************
 Glowing Fonts
 ******************************************************************************************/

var font GlowFonts[2];  // 0 = the Glow, 1 = Text

/******************************************************************************************
 Safe Regions
 ******************************************************************************************/

/** The percentage of the view that should be considered safe */
var config float SafeRegionPct;

/** Holds the full width and height of the viewport */
var float FullWidth, FullHeight;

/******************************************************************************************
 The damage direction indicators
 ******************************************************************************************/
/**
 * Holds the various data for each Damage Type
 */
struct native DamageInfo
{
    var float   FadeTime;
    var float   FadeValue;
    var MaterialInstanceConstant MatConstant;
};

/** Holds the Max. # of indicators to be shown */
var int MaxNoOfIndicators;

/** List of DamageInfos. */
var array<DamageInfo> DamageData;

/** This holds the base material that will be displayed */
var Material BaseMaterial;

/** How fast should it fade out */
var float FadeTime;

/** Name of the material parameter that controls the position */
var name PositionalParamName;

/** Name of the material parameter that controls the fade */
var name FadeParamName;

/******************************************************************************************
 The Distortion Effect (Full Screen)
 ******************************************************************************************/

/** current hit effect intensity (default.HitEffectIntensity is max) */
var float HitEffectIntensity;

/** maximum hit effect color */
var LinearColor MaxHitEffectColor;

/** whether we're currently fading out the hit effect */
var bool bFadeOutHitEffect;

/** the amount the time it takes to fade the hit effect from the maximum values (default.HitEffectFadeTime is max) */
var float HitEffectFadeTime;

/** reference to the hit effect */
var MaterialEffect HitEffect;

/** material instance for the hit effect */
var transient MaterialInstanceConstant HitEffectMaterialInstance;


/******************************************************************************************
 QuickPick Menu
 ******************************************************************************************/
var bool bShowQuickPick;
var config bool bShowAllWeapons;
var array<TMWeapon> QuickPickClasses;
var pawn QuickPickTarget;

var int QuickPickNumCells;
var float QuickPickDeltaAngle;
var float QuickPickRadius;
var int QuickPickCurrentSelection;
/** true when the player has made a new selection since bringing the menu up this time
 * (can't check QuickPickCurrentSelection for that since it defaults to current weapon)
 */
var bool bQuickPickMadeNewSelection;

var texture2D QuickPickBkgImage;
var textureCoordinates QuickPickBkgCoords;

var texture2D QuickPickSelImage;
var textureCoordinates QuickPickSelCoords;

var Texture2D QuickPickCircleImage;
var TextureCoordinates QuickPickCircleCoords;

/** controller rumble to play when switching weapons. */
var ForceFeedbackWaveform QuickPickWaveForm;

/******************************************************************************************
 Widget Locations / Visibility flags
 ******************************************************************************************/

var globalconfig bool bShowClock;
var vector2d ClockPosition;

var globalconfig bool bShowDoll;
var vector2d DollPosition;
var float LastDollUpdate;
var float DollVisibility;

var TextureCoordinates HealthBGCoords;
var float HealthOffsetX;
var float HealthBGOffsetX;   //position of the health bg relative to overall lower left position
var float HealthBGOffsetY;
var float HealthIconX;     //position of the health + icon relative to the overall left position
var float HealthIconY;
var float HealthTextX;    //position of the health text relative to the overall left position
var float HealthTextY;
var int LastHealth;
var float HealthPulseTime;

var TextureCoordinates ArmorBGCoords;
var float ArmorBGOffsetX;   //position of the armor bg relative to overall lower left position
var float ArmorBGOffsetY;
var float ArmorIconX;      //position of the armor shield icon relative to the overall left position
var float ArmorIconY;
var float ArmorTextX;      //position of the armor text relative to the overall left position
var float ArmorTextY;
var int LastArmorAmount;
var float ArmorPulseTime;

var globalconfig bool bShowAmmo;
var vector2d AmmoPosition;
var float AmmoBarOffsetY; //Padding beneath right side ammo/icon
var TextureCoordinates AmmoBGCoords;
var float AmmoTextOffsetX;
var float AmmoTextOffsetY;

var TMWeapon LastWeapon;
var int LastAmmoCount;
var float AmmoPulseTime;

var bool bHasMap;
var globalconfig bool bShowMap;
var vector2d MapPosition;

var globalconfig bool bShowPowerups;
var vector2d PowerupDims;
var float PowerupYPos;

/** How long to fade */
var float PowerupTransitionTime;

/** true while displaying powerups */
var bool bDisplayingPowerups;

var globalconfig bool bShowScoring;
var vector2d ScoringPosition;
var bool bShowFragCount;

var bool bHasLeaderboard;
var bool bShowLeaderboard;

var float FragPulseTime;
var int LastFragCount;

var globalconfig bool bShowVehicle;
var vector2d VehiclePosition;
var bool bShowVehicleArmorCount;

var globalconfig float DamageIndicatorSize;

/** width of background on either side of the nameplate */
var float NameplateWidth;
var float NameplateBubbleWidth;

/** Coordinates of the nameplate background*/
var TextureCoordinates NameplateLeft;
var TextureCoordinates NameplateCenter;
var TextureCoordinates NameplateBubble;
var TextureCoordinates NameplateRight;

var LinearColor BlackBackgroundColor;

/******************************************************************************************
 Pulses
 ******************************************************************************************/

/** How long should the pulse take total */
var float PulseDuration;
/** When should the pulse switch from Out to in */
var float PulseSplit;
/** How much should the text pulse - NOTE this will be added to 1.0 (so PulseMultipler 0.5 = 1.5) */
var float PulseMultiplier;


/******************************************************************************************
 Localize Strings -- TODO - Go through and make sure these are all localized
 ******************************************************************************************/

var localized string WarmupString;              // displayed when playing warmup round
var localized string WaitingForMatch;           // Waiting for the match to begin
var localized string PressFireToBegin;          // Press [Fire] to begin
var localized string SpectatorMessage;          // When you are a spectator
var localized string DeadMessage;               // When you are dead
var localized string FireToRespawnMessage;      // Press [Fire] to Respawn
var localized string YouHaveWon;                // When you win the match
var localized string YouHaveLost;               // You have lost the match

var localized string PlaceMarks[4];

/************************************************************************/
/*  Pawndoll                                                            */
/************************************************************************/
var TextureCoordinates PawnDollBGCoords;
var float DollOffsetX;      //position of the armor bg relative to overall lower left position
var float DollOffsetY;
var float DollWidth;
var float DollHeight;
var float VestX;            //Body armor position relative to doll
var float VestY;
var float VestWidth;
var float VestHeight;
var float ThighX;           //Thigh armor position relative to doll
var float ThighY;
var float ThighWidth;
var float ThighHeight;
var float HelmetX;          //Helmet armor position relative to doll
var float HelmetY;
var float HelmetWidth;
var float HelmetHeight;
var float BootX;            //Jump boot position relative to doll
var float BootY;
var float BootWidth;
var float BootHeight;

/******************************************************************************************
 Misc vars used for laying out the hud
 ******************************************************************************************/

var float THeight;
var float TX;
var float TY;

// Colors
var const linearcolor AmmoBarColor, RedLinearColor, BlueLinearColor, DMLinearColor, WhiteLinearColor, GoldLinearColor, SilverLinearColor;

/******************************************************************************************
 Splitscreen
 ******************************************************************************************/

/** This will be true if the hud is in splitscreen */
var bool bIsSplitScreen;

/** This will be true if this is the first player */
var bool bIsFirstPlayer;

/** Configurable crosshair scaling */
var float ConfiguredCrosshairScaling;

var() texture2D BkgTexture;
var() TextureCoordinates BkgTexCoords;
var() color BkgTexColor;

var FontRenderInfo TextRenderInfo;

/**
 * Draw a glowing string
 */
native function DrawGlowText(string Text, float X, float Y, optional float MaxHeightInPixels=0.0, optional float PulseTime=-100.0, optional bool bRightJustified);

/**
 * Draws a textured centered around the current position
 */
function DrawTileCentered(texture2D Tex, float xl, float yl, float u, float v, float ul, float vl, LinearColor C)
{
    local float x,y;

    x = Canvas.CurX - (xl * 0.5);
    y = Canvas.CurY - (yl * 0.5);

    Canvas.SetPos(x,y);
    Canvas.DrawTile(Tex, xl,yl,u,v,ul,vl,C);
}

function SetDisplayedOrders(string OrderText)
{
    DisplayedOrders = OrderText;
    OrderUpdateTime = WorldInfo.TimeSeconds;
}

/** Add missing elements to HUD */
exec function GrowHUD()
{
    if ( Class'WorldInfo'.Static.IsConsoleBuild() )
    {
        return;
    }

    if ( !bShowDoll )
    {
        bShowDoll = true;
    }
    else if ( !bShowAmmo || !bShowVehicle )
    {
        bShowAmmo = true;
        bShowVehicle = true;
    }
    else if ( !bShowScoring )
    {
        bShowScoring = true;
    }
    else if ( !bShowWeaponbar )
    {
        bShowWeaponBar = true;
    }
    else if ( bShowOnlyAvailableWeapons )
    {
        bShowOnlyAvailableWeapons = false;
    }
    else if ( !bShowVehicleArmorCount )
    {
        bShowVehicleArmorCount = true;
    }
    else if ( !bShowPowerups )
    {
        bShowPowerups = true;
    }
    else if ( !bShowMap || !bShowLeaderboard )
    {
        bShowMap = true;
        bShowLeaderboard = true;
    }
    else if ( !bShowClock )
    {
        bShowClock = true;
    }
}

/** Remove elements from HUD */
exec function ShrinkHUD()
{
    if ( Class'WorldInfo'.Static.IsConsoleBuild() )
    {
        return;
    }

    if ( bShowClock )
    {
        bShowClock = false;
    }
    else if ( bShowMap || bShowLeaderboard )
    {
        bShowMap = false;
        bShowLeaderboard = false;
    }
    else if ( bShowPowerups )
    {
        bShowPowerups = false;
    }
    else if ( bShowVehicleArmorCount )
    {
        bShowVehicleArmorCount = false;
    }
    else if ( !bShowOnlyAvailableWeapons )
    {
        bShowOnlyAvailableWeapons = true;
    }
    else if ( bShowWeaponbar )
    {
        bShowWeaponBar = false;
    }
    else if ( bShowScoring )
    {
        bShowScoring = false;
    }
    else if ( bShowAmmo || bShowVehicle )
    {
        bShowAmmo = false;
        bShowVehicle = false;
    }
    else if ( bShowDoll )
    {
        bShowDoll = false;
    }
}

/**
 * This function will attempt to auto-link up HudWidgets to their associated transient
 * property here in the hud.
 */
native function LinkToHudScene();

/**
 * Create a list of actors needing post renders for.  Also Create the Hud Scene
 */
simulated function PostBeginPlay()
{
    local Pawn P;
    local TMGameObjective O;
    local int i;
    local MaterialEffect OtherME;

    super.PostBeginPlay();
    SetTimer(1.0, true);

    TMPlayerOwner = TMPlayerController(PlayerOwner);

    // add actors to the PostRenderedActors array
    ForEach DynamicActors(class'Pawn', P)
    {
        if ( (TMPawn(P) != None) || (TMVehicle(P) != None) )
            AddPostRenderedActor(P);
    }

    foreach WorldInfo.AllNavigationPoints(class'TMGameObjective',O)
    {
        AddPostRenderedActor(O);
    }

    if ( TMConsolePlayerController(PlayerOwner) != None )
    {
        bShowOnlyAvailableWeapons = true;
        bNoWeaponNumbers = true;
    }

    // Cache data that will be used a lot
    TMPlayerOwner = TMPlayerController(Owner);

    // Setup Damage indicators,etc.

    // Create the 3 Damage Constants
    DamageData.Length = MaxNoOfIndicators;

    for (i = 0; i < MaxNoOfIndicators; i++)
    {
        DamageData[i].FadeTime = 0.0f;
        DamageData[i].FadeValue = 0.0f;
        DamageData[i].MatConstant = new(self) class'MaterialInstanceConstant';
        if (DamageData[i].MatConstant != none && BaseMaterial != none)
        {
            DamageData[i].MatConstant.SetParent(BaseMaterial);
        }
    }

    // create hit effect material instance
    HitEffect = MaterialEffect(LocalPlayer(TMPlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('HitEffect'));
    if (HitEffect != None)
    {
        if (MaterialInstanceConstant(HitEffect.Material) != None && HitEffect.Material.GetPackageName() == 'Transient')
        {
            // the runtime material already exists; grab it
            HitEffectMaterialInstance = MaterialInstanceConstant(HitEffect.Material);
        }
        else
        {
            HitEffectMaterialInstance = new(HitEffect) class'MaterialInstanceConstant';
            HitEffectMaterialInstance.SetParent(HitEffect.Material);
            HitEffect.Material = HitEffectMaterialInstance;
        }
        HitEffect.bShowInGame = false;
    }
    //clear the latest level effect
    OtherME = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('LDEffect'));
    if(OtherME != None)
    {
        OtherME.bShowInGame = false;
    }

    // find the controller icons font
    ConsoleIconFont=Font(DynamicLoadObject(ConsoleIconFontClassName, class'font', true));

    if( TMPlayerOwner.Announcer == None )
    {
        TMPlayerOwner.Announcer = Spawn( class'TMAnnouncer', TMPlayerOwner );
    }

    if (TMPlayerOwner.MusicManager == None)
    {
        TMPlayerOwner.MusicManager = Spawn( MusicManagerClass, TMPlayerOwner );
    }
}

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime )
{
    local class<LocalMessage> MsgClass;

//  if ( bMessageBeep )
//  {
//      PlayerOwner.PlayBeepSound();
//  }

    MsgClass = class'TMSayMsg';
    if (MsgType == 'Say' || MsgType == 'TeamSay')
    {
        Msg = PRI.PlayerName$": "$Msg;
        if (MsgType == 'TeamSay')
        {
            MsgClass = class'TMTeamSayMsg';
        }
    }

    AddConsoleMessage(Msg, MsgClass, PRI, LifeTime);
}

/**
 * Given a default screen position (at 1024x768) this will return the hud position at the current resolution.
 * NOTE: If the default position value is < 0.0f then it will attempt to place the right/bottom face of
 * the "widget" at that offset from the ClipX/Y.
 *
 * @Param Position      The default position (in 1024x768 space)
 * @Param Width         How wide is this "widget" at 1024x768
 * @Param Height        How tall is this "widget" at 1024x768
 *
 * @returns the hud position
 */
function Vector2D ResolveHUDPosition(vector2D Position, float Width, float Height)
{
    local vector2D FinalPos;
    FinalPos.X = (Position.X < 0) ? Canvas.ClipX - (Position.X * ResolutionScale) - (Width * ResolutionScale)  : Position.X * ResolutionScale;
    FinalPos.Y = (Position.Y < 0) ? Canvas.ClipY - (Position.Y * ResolutionScale) - (Height * ResolutionScale) : Position.Y * ResolutionScale;

    return FinalPos;
}


/* toggles displaying scoreboard (used by console controller)
*/
exec function ReleaseShowScores()
{
    SetShowScores(false);
}

exec function SetShowScores(bool bNewValue)
{
//  local TMGameReplicationInfo GRI;

    if (!bNewValue && (WorldInfo.IsInSeamlessTravel() || (TMPlayerOwner != None && TMPlayerOwner.bDedicatedServerSpectator)))
    {
        return;
    }

//  GRI = TMGameReplicationInfo(WorldInfo.GRI);

//  if ( GRI != none )
//  {
//      GRI.ShowScores(bNewValue, TMPlayerOwner, ScoreboardSceneTemplate);
//  }
}

function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage )
{
    local float Offset, MapSize;

    if ( PosY > 1.0 )
    {
        // position under minimap
        Offset = PosY - int(PosY);
        if ( Offset < 0 )
        {
            Offset = Offset + 1.0;
        }
        if ( bIsSplitScreen )
        {
            ScreenY = (0.15 + Offset) * Canvas.ClipY;
        }
        else
        {
        ScreenY = (0.38 + Offset) * Canvas.ClipY;
        }
        ScreenX = 0.98 * Canvas.ClipX - InMessage.DX;
        return;
    }

    ScreenX = 0.5 * Canvas.ClipX;
    ScreenY = (PosY * HudCanvasScale * Canvas.ClipY) + (((1.0f - HudCanvasScale) * 0.5f) * Canvas.ClipY);

    ScreenX -= InMessage.DX * 0.5;
    ScreenY -= InMessage.DY * 0.5;

    // make sure not behind minimap
    if ( bHasMap && bShowMap && !bIsSplitScreen )
    {
        MapSize = MapDefaultSize * Canvas.ClipY/768;
        if ( (ScreenY < MapPosition.Y*Canvas.ClipY + MapSize)
            && (ScreenX + InMessage.DX > MapPosition.X*Canvas.ClipX - MapSize) )
        {
            // adjust left from minimap
            ScreenX = FMax(1, MapPosition.X*Canvas.ClipX - MapSize - InMessage.DX);
        }
    }
}


function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
    local color CanvasColor;
    local string StringMessage;

    if ( Canvas.Font == none )
    {
        Canvas.Font = GetFontSizeIndex(0);
    }

    StringMessage = LocalMessage.StringMessage;
    if ( LocalMessage.Count > 0 )
    {
        if ( Right(StringMessage, 1) ~= "." )
        {
            StringMessage = Left(StringMessage, Len(StringMessage) -1);
        }
        StringMessage = StringMessage$" X "$LocalMessage.Count;
    }

    CanvasColor = Canvas.DrawColor;

    // first draw drop shadow string
    Canvas.DrawColor = BlackColor;
    Canvas.DrawColor.A = CanvasColor.A;
    Canvas.SetPos( ScreenX+2, ScreenY+2 );
    Canvas.DrawText( StringMessage, false, , , TextRenderInfo );

    // now draw string with normal color
    Canvas.DrawColor = CanvasColor;
    Canvas.SetPos( ScreenX, ScreenY );
    Canvas.DrawText( StringMessage, false, , , TextRenderInfo );
}

/**
 * Perform any value precaching, and set up various safe regions
 *
 * NOTE: NO DRAWING should ever occur in PostRender.  Put all drawing code in DrawHud().
 */
event PostRender()
{
    local int TeamIndex;
    local LocalPlayer Lp;

    //@debug: display giant "BROKEN DATA" message when the campaign bots aren't configured correctly












    bIsSplitscreen = class'Engine'.static.IsSplitScreen();
    LP = LocalPlayer(PlayerOwner.Player);
    bIsFirstPlayer = (LP != none) && (LP.Outer.GamePlayers[0] == LP);

    // Clear the flag
    bHudMessageRendered = false;

    PawnOwner = Pawn(PlayerOwner.ViewTarget);
    if ( PawnOwner == None )
    {
        PawnOwner = PlayerOwner.Pawn;
    }

    TMPawnOwner = TMPawn(PawnOwner);
    if ( TMPawnOwner == none )
    {
        if ( TMVehicleBase(PawnOwner) != none )
        {
            TMPawnOwner = TMPawn( TMVehicleBase(PawnOwner).Driver);
        }
        else if(TGTurret(PawnOwner) != none)
        {
            TMPawnOwner = TMPawn(TGTurret(PawnOwner).Driver);
        }
    }

    TMOwnerPRI = TMPlayerReplicationInfo(TMPlayerOwner.PlayerReplicationInfo);

    // Cache the current Team Index of this hud and the GRI
    TeamIndex = 2;
    if ( PawnOwner != None )
    {
        if ( (PawnOwner.PlayerReplicationInfo != None) && (PawnOwner.PlayerReplicationInfo.Team != None) )
        {
            TeamIndex = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
        }
    }
    else if ( (PlayerOwner.PlayerReplicationInfo != None) && (PlayerOwner.PlayerReplicationInfo.team != None) )
    {
        TeamIndex = PlayerOwner.PlayerReplicationInfo.Team.TeamIndex;
    }

    TMGRI = TMGameReplicationInfo(WorldInfo.GRI);

    HUDScaleX = Canvas.ClipX/1280;
    HUDScaleY = Canvas.ClipX/1280;

    ResolutionScaleX = Canvas.ClipX/1024;
    ResolutionScale = Canvas.ClipY / 768;
    if ( bIsSplitScreen )
        ResolutionScale *= 2.0;

    GetTeamColor(TeamIndex, TeamHUDColor, TeamTextColor);

    FullWidth = Canvas.ClipX;
    FullHeight = Canvas.ClipY;

    // Always update the Damage Indicator
    UpdateDamage();

    // Handle displaying the scoreboard.  Allow the Mid Game Menu to override displaying
    // it.
    if ( bShowScores || (TMGRI == None) /*|| (TMGRI.CurrentMidGameMenu != none)*/ )
    {
        return;
    }

    if ( TMPlayerOwner.bViewingMap )
    {
        return;
    }

    if ( bShowHud )
    {
        DrawHud();
    }
}

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
    local float x,y,w,h,xl,yl;
    local vector ViewPoint;
    local rotator ViewRotation;

    // post render actors before creating safe region
    if (TMGRI != None && !TMGRI.bMatchIsOver && bShowHud && PawnOwner != none  )
    {
        Canvas.Font = GetFontSizeIndex(0);
        PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
        DrawActorOverlays(Viewpoint, ViewRotation);
    }

    // Create the safe region
    w = FullWidth * SafeRegionPct;
    X = Canvas.OrgX + (Canvas.ClipX - w) * 0.5;

    // We have some extra logic for figuring out how things should be displayed
    // in split screen.

    h = FullHeight * SafeRegionPct;

    if ( bIsSplitScreen )
    {
        if ( bIsFirstPlayer )
        {
            Y = Canvas.ClipY - H;
        }
        else
        {
            Y = 0.0f;
        }
    }
    else
    {
        Y = Canvas.OrgY + (Canvas.ClipY - h) * 0.5;
    }

    Canvas.OrgX = X;
    Canvas.OrgY = Y;

    Canvas.ClipX = w;
    Canvas.ClipY = h;
    Canvas.Reset(true);

    // Set up delta time
    RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
    LastHUDRenderTime = WorldInfo.TimeSeconds;

    // If we are not over, draw the hud
    if (TMGRI != None && !TMGRI.bMatchIsOver)
    {
        PlayerOwner.DrawHud( Self );
        DrawGameHud();
    }
    else    // Match is over
    {
        DrawPostGameHud();

        // still draw pause message
        if ( WorldInfo.Pauser != None )
        {
            Canvas.Font = GetFontSizeIndex(2);
            Canvas.Strlen(class'TMGameViewportClient'.default.LevelActionMessages[1],xl,yl);
            Canvas.SetDrawColor(255,255,255,255);
            Canvas.SetPos(0.5*(Canvas.ClipX - XL), 0.44*Canvas.ClipY);
            Canvas.DrawText(class'TMGameViewportClient'.default.LevelActionMessages[1]);
        }
    }

    LastHUDUpdateTime = WorldInfo.TimeSeconds;
}

exec function ShowAllAI()
{
    bShowAllAI = !bShowAllAI;
}

exec function ShowSquadRoutes()
{
    local TMBot B;
    local int i, j;
    local byte Red, Green, Blue;

    if (PawnOwner != None)
    {
        B = TMBot(PawnOwner.Controller);
        if (B != None && B.Squad != None)
        {
            FlushPersistentDebugLines();
            for (i = 0; i < B.Squad.SquadRoutes.length; i++)
            {
                Red = Rand(255);
                Green = Rand(255);
                Blue = Rand(255);
                for (j = 0; j < B.Squad.SquadRoutes[i].RouteCache.length - 1; j++)
                {
                    DrawDebugLine( B.Squad.SquadRoutes[i].RouteCache[j].Location,
                            B.Squad.SquadRoutes[i].RouteCache[j + 1].Location,
                            Red, Green, Blue, true );
                }
            }
        }
    }
}

/**
 * This function is called to draw the hud while the game is still in progress.  You should only draw items here
 * that are always displayed.  If you want to draw something that is displayed only when the player is alive
 * use DrawLivingHud().
 */
function DrawGameHud()
{
    local float xl, yl, ypos;
    local float TempResScale;

    if ( bCrosshairOnFriendly )
    {
        // verify that crosshair trace might hit friendly
        bGreenCrosshair = CheckCrosshairOnFriendly();
        bCrosshairOnFriendly = false;
    }
    else
    {
        bGreenCrosshair = false;
    }

    if ( bShowDebugInfo )
    {
        Canvas.Font = GetFontSizeIndex(0);
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0;
        PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);

        if (ShouldDisplayDebug('AI') && (Pawn(PlayerOwner.ViewTarget) != None))
        {
            DrawRoute(Pawn(PlayerOwner.ViewTarget));
        }
        return;
    }

    if (bShowAllAI)
    {
        DrawAIOverlays();
    }

    if ( WorldInfo.Pauser != None )
    {
        Canvas.Font = GetFontSizeIndex(2);
        Canvas.Strlen(class'TMGameViewportClient'.default.LevelActionMessages[1],xl,yl);
        Canvas.SetDrawColor(255,255,255,255);
        Canvas.SetPos(0.5*(Canvas.ClipX - XL), 0.44*Canvas.ClipY);
        Canvas.DrawText(class'TMGameViewportClient'.default.LevelActionMessages[1]);
    }

    DisplayLocalMessages();
    DisplayConsoleMessages();
    DisplayKismetMessages();

    Canvas.Font = GetFontSizeIndex(1);

    // Draw the character portrait
    if ( CharPRI != None  )
    {
        DisplayPortrait(RenderDelta);
    }

    if ( bShowClock && !bIsSplitScreen )
    {
        DisplayClock();
    }

    if (bIsSplitScreen && bShowScoring)
    {
        DisplayScoring();
    }

    // If the player isn't dead, draw the living hud
    if ( !TMPlayerOwner.IsDead() )
    {
        DrawLivingHud();
    }

    if ( bHasMap && bShowMap )
    {
        TempResScale = ResolutionScale;
        if (bIsSplitScreen)
        {
            ResolutionScale *=2;
        }
        DisplayMap();
        ResolutionScale = TempResScale;
    }

    DisplayDamage();

    if (TMPlayerOwner.bIsTyping && WorldInfo.NetMode != NM_Standalone)
    {
        DrawMicIcon();
    }

    if ( bShowQuickPick )
    {
        DisplayQuickPickMenu();
    }
}

function DrawMicIcon()
{
    local vector2d Pos;
    Pos.X = 0.0;
    Pos.Y = Canvas.ClipY * (CharPortraitYPerc + 0.05) + CharPortraitSize.Y * (Canvas.ClipY/768.0) + 6;
    Canvas.SetPos(Pos.X,Pos.Y);
    Canvas.DrawTile(TalkingTexture, 64, 64, 0, 0, 64, 64);
}

function DisplayLocalMessages()
{
    if (!PlayerOwner.bCinematicMode)
    {
        MaxHUDAreaMessageCount = bIsSplitScreen ? 1 : 2;
        Super.DisplayLocalMessages();
    }
}

/**
 * Anything drawn in this function will be displayed ONLY when the player is living.
 */
function DrawLivingHud()
{
    local TMWeapon Weapon;
    local float Alpha;

    if ( !bIsSplitScreen && bShowScoring )
    {
        DisplayScoring();
    }

    // Pawn Doll
    if ( bShowDoll && TMPawnOwner != none )
    {
        DisplayPawnDoll();
    }

    // If we are driving a vehicle, give it hud time
//  if ( bShowVehicle && TMVehicleBase(PawnOwner) != none )
//  {
//      TMVehicleBase(PawnOwner).DisplayHud(self, Canvas, VehiclePosition);
//  }

    // Powerups
    if ( bShowPowerups && TMPawnOwner != none && TMPawnOwner.InvManager != none )
    {
        DisplayPowerups();
    }

    // Manage the weapon.  NOTE: Vehicle weapons are managed by the vehicle
    // since they are integrated in to the vehicle health bar
    if( PawnOwner != none )
    {
        Alpha = TeamHUDColor.A;
        if ( bShowWeaponBar )
        {
            DisplayWeaponBar();
        }
        else if ( (Vehicle(PawnOwner) != None) && (PawnOwner.Weapon != LastSelectedWeapon) )
        {
            LastSelectedWeapon = PawnOwner.Weapon;
            PlayerOwner.ReceiveLocalizedMessage( class'TMWeaponSwitchMessage',,,, LastSelectedWeapon );
        }
        else if ( (PawnOwner.InvManager != None) && (PawnOwner.InvManager.PendingWeapon != None) && (PawnOwner.InvManager.PendingWeapon != LastSelectedWeapon) )
        {
            LastSelectedWeapon = PawnOwner.InvManager.PendingWeapon;
            PlayerOwner.ReceiveLocalizedMessage( class'TMWeaponSwitchMessage',,,, LastSelectedWeapon );
        }

        // The weaponbar potentially tweaks TeamHUDColor's Alpha.  Reset it here
        TeamHudColor.A = Alpha;

        if ( bShowAmmo )
        {
            Weapon = TMWeapon(PawnOwner.Weapon);
            if ( Weapon != none && TMVehicleWeapon(Weapon) == none )
            {
                DisplayAmmo(Weapon);
            }
        }
    }
}

/**
 * This function is called when we are drawing the hud but the match is over.
 */
function DrawPostGameHud()
{
    local bool bWinner;

    if (WorldInfo.GRI != None
        && PlayerOwner.PlayerReplicationInfo != None
        && !PlayerOwner.PlayerReplicationInfo.bOnlySpectator
        && !PlayerOwner.IsInState('InQueue') )
    {
        if ( TMPlayerReplicationInfo(WorldInfo.GRI.Winner) != none )
        {
            bWinner = TMPlayerReplicationInfo(WorldInfo.GRI.Winner) == TMOwnerPRI;
        }
        // automated testing will not have a valid winner
        else if( WorldInfo.GRI.Winner != none )
        {
            bWinner = WorldInfo.GRI.Winner.GetTeamNum() == TMPlayerOwner.GetTeamNum();
        }

        DisplayHUDMessage((bWinner ? YouHaveWon : YouHaveLost));
    }

    DisplayConsoleMessages();
}

function bool CheckCrosshairOnFriendly()
{
    local float Size;
    local vector HitLocation, HitNormal, StartTrace, EndTrace;
    local actor HitActor;
    local TMVehicle V, HitV;
    local TMWeapon W;
    local int SeatIndex;

    if ( PawnOwner == None )
    {
        return false;
    }

    V = TMVehicle(PawnOwner);
    if ( V != None )
    {
        for ( SeatIndex=0; SeatIndex<V.Seats.Length; SeatIndex++ )
        {
            if ( V.Seats[SeatIndex].SeatPawn == PawnOwner )
            {
                HitActor = V.Seats[SeatIndex].AimTarget;
                break;
            }
        }
    }
    else
    {
        W = TMWeapon(PawnOwner.Weapon);
        if ( W != None && W.EnableFriendlyWarningCrosshair())
        {
            StartTrace = W.InstantFireStartTrace();
            EndTrace = StartTrace + W.MaxRange() * vector(PlayerOwner.Rotation);
            HitActor = PawnOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0,0,0),, TRACEFLAG_Bullet);

            if ( Pawn(HitActor) == None )
            {
                HitActor = (HitActor == None) ? None : Pawn(HitActor.Base);
            }
        }
    }

    if ( (Pawn(HitActor) == None) || !Worldinfo.GRI.OnSameTeam(HitActor, PawnOwner) )
    {
        return false;
    }

    // if trace hits friendly, draw "no shoot" symbol
    Size = 28 * (Canvas.ClipY / 768);
    Canvas.SetPos( (Canvas.ClipX * 0.5) - (Size *0.5), (Canvas.ClipY * 0.5) - (Size * 0.5) );
    HitV = TMVehicle(HitActor);
    if ( (HitV != None) && (HitV.Health < HitV.default.Health) && ((V != None) ? false : false/*(TMWeap_Linkgun(W) != None)*/) )
    {
        Canvas.SetDrawColor(255,255,128,255);
        Canvas.DrawTile(AltHudTexture, Size, Size, 600, 262, 28, 27);
    }
    return true;
}

/*
*/
native function DisplayWeaponBar();

/**
 * Draw the Map
 */
function DisplayMap()
{
    local TMMapInfo MI;
    local float ScaleY, W,H,X,Y, ScreenX, ScreenY, XL, YL, OrdersScale, ScaleIn, ScaleAlpha;
    local color CanvasColor;
    local float AdjustedViewportHeight;


    if ( DisplayedOrders != "" )
    {
        // draw orders
        Canvas.Font = GetFontSizeIndex(2);
        Canvas.StrLen(DisplayedOrders, XL, YL);

        // reduce font size if too big
        if( XL > 0.0f )
        {
            OrdersScale = FMin(1.0, 0.3*Canvas.ClipX/XL);
        }

        // scale in initially
        ScaleIn = FMax(1.0, (0.6+OrderUpdateTime-WorldInfo.TimeSeconds)/0.15);
        ScaleAlpha = FMin(1.0, 4.5 - ScaleIn);
        OrdersScale *= ScaleIn;

        ScreenY = 0.01 * Canvas.ClipY;
        ScreenX = 0.98 * Canvas.ClipX - OrdersScale*XL;

        // first draw drop shadow string
        if ( ScaleIn < 1.1 )
        {
            Canvas.DrawColor = BlackColor;
            Canvas.SetPos( ScreenX+2, ScreenY+2 );
            Canvas.DrawText( DisplayedOrders, false, OrdersScale, OrdersScale, TextRenderInfo );
        }

        // now draw string with normal color
        Canvas.DrawColor = LightGoldColor;
        Canvas.DrawColor.A = 255 * ScaleAlpha;
        Canvas.SetPos( ScreenX, ScreenY );
        Canvas.DrawText( DisplayedOrders, false, OrdersScale, OrdersScale, TextRenderInfo );
        Canvas.DrawColor = CanvasColor;
    }

    // no minimap in splitscreen
    if ( bIsSplitScreen )
        return;

    // draw map
    MI = TMMapInfo( WorldInfo.GetMapInfo() );
    if ( MI != none )
    {
        AdjustedViewportHeight = bIsSplitScreen ? Canvas.ClipY * 2 : Canvas.ClipY;

        ScaleY = AdjustedViewportHeight/768;
        H = MapDefaultSize * ScaleY;
        W = MapDefaultSize * ScaleY;

        X = Canvas.ClipX - (Canvas.ClipX * (1.0 - MapPosition.X)) - W;
        Y = (AdjustedViewportHeight * MapPosition.Y);

        MI.DrawMap(Canvas, TMPlayerController(PlayerOwner), X, Y, W ,H, true, (Canvas.ClipX / AdjustedViewportHeight) );
    }
}

/** draws AI goal overlays over each AI pawn */
function DrawAIOverlays()
{
    local TMBot B;
    local vector Pos;
    local float XL, YL;
    local string Text;

    Canvas.Font = GetFontSizeIndex(0);

    foreach WorldInfo.AllControllers(class'TMBot', B)
    {
        if (B.Pawn != None)
        {
            // draw route
            DrawRoute(B.Pawn);
            // draw goal string
            if ((vector(PlayerOwner.Rotation) dot (B.Pawn.Location - PlayerOwner.ViewTarget.Location)) > 0.f)
            {
                Pos = Canvas.Project(B.Pawn.Location + B.Pawn.GetCollisionHeight() * vect(0,0,1.1));
                Text = B.GetHumanReadableName() $ ":" @ B.GoalString;
                Canvas.StrLen(Text, XL, YL);
                Pos.X = FClamp(Pos.X, 0.f, Canvas.ClipX - XL);
                Pos.Y = FClamp(Pos.Y, 0.f, Canvas.ClipY - YL);
                Canvas.SetPos(Pos.X, Pos.Y);
                if (B.PlayerReplicationInfo != None && B.PlayerReplicationInfo.Team != None)
                {
                    Canvas.DrawColor = TMTeamInfo(B.PlayerReplicationInfo.Team).GetHUDColor();
                    // brighten the color a bit
                    Canvas.DrawColor.R = Min(Canvas.DrawColor.R + 64, 255);
                    Canvas.DrawColor.G = Min(Canvas.DrawColor.G + 64, 255);
                    Canvas.DrawColor.B = Min(Canvas.DrawColor.B + 64, 255);
                }
                else
                {
                    Canvas.DrawColor = ConsoleColor;
                }
                Canvas.DrawColor.A = LocalPlayer(PlayerOwner.Player).GetActorVisibility(B.Pawn) ? 255 : 128;
                Canvas.DrawText(Text);
            }
        }
    }
}


/************************************************************************************************************
 * Accessors for the UI system for opening scenes (scoreboard/menus/etc)
 ***********************************************************************************************************/

function UIInteraction GetUIController(optional out LocalPlayer LP)
{
    LP = LocalPlayer(PlayerOwner.Player);
    if ( LP != none )
    {
        return LP.ViewportClient.UIController;
    }

    return none;
}

/**
 * OpenScene - Opens a UIScene
 *
 * @Param Template  The scene template to open
 */
// function TMUIScene OpenScene(TMUIScene Template)
// {
//  return TMUIScene(TMPlayerOwner.OpenUIScene(Template));
// }


/************************************************************************************************************
 Misc / Utility functions
************************************************************************************************************/

exec function ToggleHUD()
{
    bShowHUD = !bShowHUD;
}

exec function StartMusic()
{
    if (TMPlayerOwner.MusicManager == None)
    {
        TMPlayerOwner.MusicManager = Spawn(MusicManagerClass, TMPlayerOwner);
    }
}

static simulated function GetTeamColor(int TeamIndex, optional out LinearColor ImageColor, optional out Color TextColor)
{
    switch ( TeamIndex )
    {
        case 0 :
            ImageColor = Default.RedLinearColor;
            TextColor = Default.LightGoldColor;
            break;
        case 1 :
            ImageColor = Default.BlueLinearColor;
            TextColor = Default.LightGoldColor;
            break;
        default:
            ImageColor = Default.DMLinearColor;
            ImageColor.A = 1.0f;
            TextColor = Default.LightGoldColor;
            break;
    }
}


/************************************************************************************************************
 Damage Indicator
************************************************************************************************************/

/**
 * Called from various functions.  It allows the hud to track when a hit is scored
 * and display any indicators.
 *
 * @Param   HitDir      - The vector to which the hit came at
 * @Param   Damage      - How much damage was done
 * @Param   DamageType  - Type of damage
 */
function DisplayHit(vector HitDir, int Damage, class<DamageType> damageType)
{
    local Vector Loc;
    local Rotator Rot;
    local float DirOfHit_L;
    local vector AxisX, AxisY, AxisZ;
    local vector ShotDirection;
    local bool bIsInFront;
    local vector2D  AngularDist;
    local float PositionInQuadrant;
    local float Multiplier;
    local float DamageIntensity;
    local class<TMDamageType> TMDamage;
    local Pawn P;

    if ( (PawnOwner != None) && (PawnOwner.Health > 0) )
    {
        DamageIntensity = PawnOwner.InGodMode() ? 0.5 : (float(Damage)/100.0 + float(Damage)/float(PawnOwner.Health));
    }
    else
    {
        DamageIntensity = FMax(0.2, 0.02*float(Damage));
    }

    TMDamage = class<TMDamageType>(DamageType);
    if ( TMDamage == none || TMDamage.default.bLocationalHit )
    {
        // Figure out the directional based on the victims current view
        PlayerOwner.GetPlayerViewPoint(Loc, Rot);
        GetAxes(Rot, AxisX, AxisY, AxisZ);

        ShotDirection = Normal(HitDir - Loc);
        bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
        GetAngularDegreesFromRadians(AngularDist);

        Multiplier = 0.26f / 90.f;
        PositionInQuadrant = Abs(AngularDist.X) * Multiplier;

        // 0 - .25  UpperRight
        // .25 - .50 LowerRight
        // .50 - .75 LowerLeft
        // .75 - 1 UpperLeft
        if( bIsInFront )
        {
            DirOfHit_L = (AngularDist.X > 0) ? PositionInQuadrant : -1*PositionInQuadrant;
        }
        else
        {
            DirOfHit_L = (AngularDist.X > 0) ? 0.52+PositionInQuadrant : 0.52-PositionInQuadrant;
        }

        // Cause a damage indicator to appear
        DirOfHit_L = -1 * DirOfHit_L;
        FlashDamage(DirOfHit_L);
    }
    else
    {
        FlashDamage(0.1);
        FlashDamage(0.9);
    }

    // If the owner on the hoverboard, check against the owner health rather than vehicle health
//  if (TMVehicle_Hoverboard(PawnOwner) != None)
//  {
//      P = TMVehicle_Hoverboard(PawnOwner).Driver;
//  }
//  else
//  {
        P = PawnOwner;
//  }

    if (DamageIntensity > 0 && HitEffect != None)
    {
        DamageIntensity = FClamp(DamageIntensity, 0.2, 1.0);
        if ( (P == None) || (P.Health <= 0) )
        {
            // long effect duration if killed by this damage
            HitEffectFadeTime = PlayerOwner.MinRespawnDelay * 2.0;
        }
        else
        {
            HitEffectFadeTime = default.HitEffectFadeTime * DamageIntensity;
        }
        HitEffectIntensity = default.HitEffectIntensity * DamageIntensity;
        MaxHitEffectColor = (TMDamage != None && TMDamage.default.bOverrideHitEffectColor) ? TMDamage.default.HitEffectColor : default.MaxHitEffectColor;
        HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitEffectIntensity);
        HitEffectMaterialInstance.SetVectorParameterValue('HitColor', MaxHitEffectColor);
        HitEffect.bShowInGame = true;
        bFadeOutHitEffect = true;
    }
}

/**
 * Configures a damage directional indicator and makes it appear
 *
 * @param   FlashPosition       Where it should appear
 */
function FlashDamage(float FlashPosition)
{
    local int i,MinIndex;
    local float Min;

    Min = 1.0;

    // Find an available slot

    for (i = 0; i < MaxNoOfIndicators; i++)
    {
        if (DamageData[i].FadeValue <= 0.0)
        {
            DamageData[i].FadeValue = 1.0;
            DamageData[i].FadeTime = FadeTime;
            DamageData[i].MatConstant.SetScalarParameterValue(PositionalParamName,FlashPosition);
            DamageData[i].MatConstant.SetScalarParameterValue(FadeParamName,1.0);

            return;
        }
        else if (DamageData[i].FadeValue < Min)
        {
            MinIndex = i;
            Min = DamageData[i].FadeValue;
        }
    }

    // Set the data

    DamageData[MinIndex].FadeValue = 1.0;
    DamageData[MinIndex].FadeTime = FadeTime;
    DamageData[MinIndex].MatConstant.SetScalarParameterValue(PositionalParamName,FlashPosition);
    DamageData[MinIndex].MatConstant.SetScalarParameterValue(FadeParamName,1.0);

}


/**
 * Update Damage always needs to be called
 */
function UpdateDamage()
{
    local int i;
    local float HitAmount;
    local LinearColor HitColor;

    for (i=0; i<MaxNoOfIndicators; i++)
    {
        if (DamageData[i].FadeTime > 0)
        {
            DamageData[i].FadeValue += ( 0 - DamageData[i].FadeValue) * (RenderDelta / DamageData[i].FadeTime);
            DamageData[i].FadeTime -= RenderDelta;
            DamageData[i].MatConstant.SetScalarParameterValue(FadeParamName,DamageData[i].FadeValue);
        }
    }

    // Update the color/fading on the full screen distortion
    if (bFadeOutHitEffect)
    {
        HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);
        HitAmount -= HitEffectIntensity * RenderDelta / HitEffectFadeTime;

        if (HitAmount <= 0.0)
        {
            HitEffect.bShowInGame = false;
            bFadeOutHitEffect = false;
        }
        else
        {
            HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitAmount);
            // now scale the color
            HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
            HitColor = HitColor - MaxHitEffectColor * (RenderDelta / HitEffectFadeTime);
            HitEffectMaterialInstance.SetVectorParameterValue('HitColor', HitColor);
        }
    }
}

function DisplayDamage()
{
    local int i;

    // Update the fading on the directional indicators.
    for (i=0; i<MaxNoOfIndicators; i++)
    {
        if (DamageData[i].FadeTime > 0)
        {

            Canvas.SetPos( ((Canvas.ClipX * 0.5) - (DamageIndicatorSize * 0.5 * ResolutionScale)),
                            ((Canvas.ClipY * 0.5) - (DamageIndicatorSize * 0.5 * ResolutionScale)));

            Canvas.DrawMaterialTile( DamageData[i].MatConstant, DamageIndicatorSize * ResolutionScale, DamageIndicatorSize * ResolutionScale, 0.0, 0.0, 1.0, 1.0);
        }
    }
}

/************************************************************************************************************
************************************************************************************************************/


static simulated function DrawBackground(float X, float Y, float Width, float Height, LinearColor DrawColor, Canvas DrawCanvas)
{
    DrawCanvas.SetPos(X,Y);
    DrawColor.R *= 0.25;
    DrawColor.G *= 0.25;
    DrawColor.B *= 0.25;
    DrawCanvas.DrawTile(Default.AltHudTexture, Width, Height, 631,202,98,48, DrawColor);
}

static simulated function DrawBeaconBackground(float X, float Y, float Width, float Height, LinearColor DrawColor, Canvas DrawCanvas)
    {
    DrawCanvas.SetPos(X,Y);
        DrawColor.R *= 0.25;
        DrawColor.G *= 0.25;
        DrawColor.B *= 0.25;
    DrawCanvas.DrawTile(Default.TM3GHudTexture, Width, Height, 137,91,101,34, DrawColor);
}

/**
  * Draw a beacon healthbar
  * @PARAM Width is the actual health width
  * @PARAM MaxWidth corresponds to the max health
  */
static simulated function DrawHealth(float X, float Y, float Width, float MaxWidth, float Height, Canvas DrawCanvas, optional byte Alpha=255)
{
    local float HealthX;
    local color DrawColor, BackColor;

    // Bar color depends on health
    HealthX = Width/MaxWidth;

    DrawColor = Default.GrayColor;
    DrawColor.B = 16;
    if (HealthX > 0.8)
    {
        DrawColor.R = 112;
    }
    else if (HealthX < 0.4 )
    {
        DrawColor.G = 80;
    }
    DrawColor.A = Alpha;
    BackColor = default.GrayColor;
    BackColor.A = Alpha;
    DrawBarGraph(X,Y,Width,MaxWidth,Height,DrawCanvas,DrawColor,BackColor);
}

static simulated function DrawBarGraph(float X, float Y, float Width, float MaxWidth, float Height, Canvas DrawCanvas, Color BarColor, Color BackColor)
{
    // Draw health bar backdrop ticks
    if ( MaxWidth > 24.0 )
    {
        // determine size of health bar caps
        DrawCanvas.DrawColor = BackColor;
        DrawCanvas.SetPos(X,Y);
        DrawCanvas.DrawTile(default.AltHudTexture,MaxWidth,Height,407,479,FMin(MaxWidth,118),16);
    }

    DrawCanvas.DrawColor = BarColor;
    DrawCanvas.SetPos(X, Y);
    DrawCanvas.DrawTile(default.AltHudTexture,Width,Height,277,494,4,13);
}

simulated event Timer()
{
    Super.Timer();
    if ( WorldInfo.GRI != None )
    {
        TMGameReplicationInfo(WorldInfo.GRI).SortPRIArray();
    }
}

/**
 * Creates a string from the time
 */
static function string FormatTime(int Seconds)
{
    local int Hours, Mins;
    local string NewTimeString;

    Hours = Seconds / 3600;
    Seconds -= Hours * 3600;
    Mins = Seconds / 60;
    Seconds -= Mins * 60;
    NewTimeString = "" $ ( Hours > 9 ? String(Hours) : "0"$String(Hours)) $ ":";
    NewTimeString = NewTimeString $ ( Mins > 9 ? String(Mins) : "0"$String(Mins)) $ ":";
    NewTimeString = NewTimeString $ ( Seconds > 9 ? String(Seconds) : "0"$String(Seconds));

    return NewTimeString;
}

static function Font GetFontSizeIndex(int FontSize)
{
    return default.HudFonts[Clamp(FontSize,0,3)];
}

/**
 * Given a PRI, show the Character portrait on the screen.
 *
 * @Param ShowPRI                   The PRI to show
 * @Param bOverrideCurrentSpeaker   If true, we will quickly slide off the current speaker and then bring on this guy
 */
simulated function ShowPortrait(TMPlayerReplicationInfo ShowPRI, optional float PortraitDuration, optional bool bOverrideCurrentSpeaker)
{
    if ( ShowPRI != none && ShowPRI.CharPortrait != none )
    {
        // See if there is a current speaker
        if ( CharPRI != none )  // See if we should override this speaker
        {
            if ( ShowPRI == CharPRI )
            {
                if ( CharPortraitTime >= CharPortraitSlideTime * CharPortraitSlideTransitionTime )
                {
                    CharPortraitSlideTime += 2.0;
                    CharPortraitTime = FMax(CharPortraitTime, CharPortraitSlideTime * CharPortraitSlideTransitionTime);
                }
            }
            else if ( bOverrideCurrentSpeaker )
            {
                CharPendingPRI = ShowPRI;
                HidePortrait();
            }
            return;
        }

        // Noone is sliding in, set us up.
        // Make sure we have the Instance
        if ( CharPortraitMI == none )
        {
            CharPortraitMI = new(Outer) class'MaterialInstanceConstant';
            CharPortraitMI.SetParent(CharPortraitMaterial);
        }

        // Set the image
        CharPortraitMI.SetTextureParameterValue('PortraitTexture',ShowPRI.CharPortrait);
        CharPRI = ShowPRI;
        CharPortraitTime = 0.0;
        CharPortraitSlideTime = FMax(2.0, PortraitDuration);
    }
}

/** If the portrait is visible, this will immediately try and hide it */
simulated function HidePortrait()
{
    local float CurrentPos;

    // Figure out the slide.

    CurrentPos = CharPortraitTime / CharPortraitSlideTime;

    // Slide it back out the equal percentage

    if (CurrentPos < CharPortraitSlideTransitionTime)
    {
        CharPortraitTime = CharPortraitSlideTime * (1.0 - CurrentPos);
    }

    // If we aren't sliding out, do it now

    else if ( CurrentPos < (1.0 - CharPortraitSlideTransitionTime ) )
    {
        CharPortraitTime = CharPortraitSlideTime * (1.0 - CharPortraitSlideTransitionTime);
    }
}

/**
 * Render the character portrait on the screen.
 *
 * @Param   RenderDelta     How long since the last render
 */
simulated function DisplayPortrait(float DeltaTime)
{
    local float CurrentPos, LocalPos, XPos, YPos, W, H;

    H = CharPortraitSize.Y * (Canvas.ClipY/768.0);
    W = CharPortraitSize.X * (Canvas.ClipY/768.0);

    CharPortraitTime += DeltaTime * (CharPendingPRI != none ? 1.5 : 1.0);

    CurrentPos = CharPortraitTime / CharPortraitSlideTime;
    // Figure out what we are doing
    if (CurrentPos < CharPortraitSlideTransitionTime)   // Sliding In
    {
        LocalPos = CurrentPos / CharPortraitSlideTransitionTime;
        XPos = FCubicInterp((W * -1), 0.0, (Canvas.ClipX * CharPortraitXPerc), 0.0, LocalPos);
    }
    else if ( (CurrentPos < 1.0 - CharPortraitSlideTransitionTime) )    // Sitting there
    {
        XPos = Canvas.ClipX * CharPortraitXPerc;
    }
    else if ( PlayerOwner.VoiceInterface.IsRemotePlayerTalking(CharPRI.UniqueID) )
    {
        XPos = Canvas.ClipX * CharPortraitXPerc;
        CharPortraitTime = (1.0 - CharPortraitSlideTransitionTime) * CharPortraitSlideTime;
    }
    else if ( CurrentPos < 1.0 )    // Sliding out
    {
        LocalPos = (CurrentPos - (1.0 - CharPortraitSlideTransitionTime)) / CharPortraitSlideTransitionTime;
        XPos = FCubicInterp((W * -1), 0.0, (Canvas.ClipX * CharPortraitXPerc), 0.0, 1.0-LocalPos);
    }
    else    // Done, reset everything
    {
        CharPRI = none;
        if ( CharPendingPRI != none )   // If we have a pending PRI, then display it
        {
            ShowPortrait(CharPendingPRI);
            CharPendingPRI = none;
        }
        return;
    }

    // Draw the portrait
    YPos = Canvas.ClipY * CharPortraitYPerc;
    Canvas.SetPos(XPos, YPos);
    Canvas.DrawColor = Whitecolor;
    Canvas.DrawMaterialTile(CharPortraitMI,W,H,0.0,0.0,1.0,1.0);
    Canvas.SetPos(XPos,YPos + H + 5);
    Canvas.Font = HudFonts[0];
    Canvas.DrawText(CharPRI.PlayerName);
}

/**
 * Displays the MOTD Scene
 */
function DisplayMOTD()
{
    //OpenScene(MOTDSceneTemplate);
}

/**
 * Displays a HUD message
 */
function DisplayHUDMessage( string Message,
    optional float XOffsetPct = 0.7,
    optional float YOffsetPct = 0.1)
{
    local float XL,YL;
    //local float BarHeight;
    local float Height, YBuffer, XBuffer;
    //local LinearColor LC;
    local Color C;

    if (!bHudMessageRendered)
    {
        // Preset the Canvas
        Canvas.Font = GetFontSizeIndex(1);
        Canvas.StrLen(Message,XL,YL);

        // Figure out sizes/positions
        //BarHeight = YL * 1.5;
        YBuffer = Canvas.ClipY * YOffsetPct;
        XBuffer = Canvas.ClipX * XOffsetPct;
        Height = YL * 2.5;

        if( PlayerOwner != none
        && PlayerOwner.PlayerReplicationInfo != none
        && PlayerOwner.PlayerReplicationInfo.Team != none )
        {
            C = PlayerOwner.PlayerReplicationInfo.Team.TeamColor;
            //LC = ColorToLinearColor( C );
        }
        else
        {
            C = MakeColor( 255, 255, 255, 255 );
            //LC = MakeLinearColor( 64, 64, 64, 255 );
        }

        // Draw the Bar
        //Canvas.SetPos(0,YCenter - (BarHeight * 0.5) );

        //Canvas.DrawTile(AltHudTexture, Canvas.ClipX, BarHeight, 382, 441, 127, 16,
        //      LC, false, BLEND_SoftMasked );

        // Draw the Symbol
        //Canvas.SetPos(XBuffer, YCenter - (Height * 0.5));
        //Canvas.DrawTile(AltHudTexture, Height * 1.33333, Height, 734,190, 82, 70);

        // Draw the Text
        Canvas.SetDrawColor( C.R, C.G, C.B );
        Canvas.SetPos( XBuffer, YBuffer - (Height * 0.5) );
        Canvas.DrawText(Message);

        bHudMessageRendered = true;
    }
}

function DisplayClock()
{
    local string Time;
    local vector2D POS;

    if (TMGRI != None)
    {
        POS = ResolveHudPosition(ClockPosition,183,44);
        Time = FormatTime(TMGRI.TimeLimit != 0 ? TMGRI.RemainingTime : TMGRI.ElapsedTime);

        Canvas.SetPos(POS.X, POS.Y);
        Canvas.DrawTile(AltHudTexture, 183 * ResolutionScale,44 * ResolutionScale,490,395,181,44,TeamHudColor);

        Canvas.DrawColor = WhiteColor;
        DrawGlowText(Time, POS.X + (28 * ResolutionScale), POS.Y, 39 * ResolutionScale);
    }
}

function DisplayPawnDoll()
{
    local vector2d POS;
    local string Amount;
    local int Health;
    local float xl,yl;
    local float ArmorAmount;
    local linearcolor ScaledWhite, ScaledTeamHUDColor;

    POS = ResolveHudPosition(DollPosition,216, 115);
    Canvas.DrawColor = WhiteColor;

    // should doll be visible?
    ArmorAmount = TMPawnOwner.ShieldBeltArmor + TMPawnOwner.VestArmor + TMPawnOwner.HelmetArmor + TMPawnOwner.ThighpadArmor;

    if ( (ArmorAmount > 0) || (TMPawnOwner.JumpbootCharge > 0) )
    {
        DollVisibility = FMin(DollVisibility + 3.0 * (WorldInfo.TimeSeconds - LastDollUpdate), 1.0);
    }
    else
    {
        DollVisibility = FMax(DollVisibility - 3.0 * (WorldInfo.TimeSeconds - LastDollUpdate), 0.0);
    }
    LastDollUpdate = WorldInfo.TimeSeconds;

    POS.X = POS.X + (DollVisibility - 1.0)*HealthOffsetX*ResolutionScale;
    ScaledWhite = LC_White;
    ScaledWhite.A = DollVisibility;
    ScaledTeamHUDColor = TeamHUDColor;
    ScaledTeamHUDColor.A = FMin(DollVisibility, TeamHUDColor.A);

    // First, handle the Pawn Doll
    if ( DollVisibility > 0.0 )
    {
        // The Background
        Canvas.SetPos(POS.X,POS.Y);
        Canvas.DrawTile(AltHudTexture, PawnDollBGCoords.UL * ResolutionScale, PawnDollBGCoords.VL * ResolutionScale, PawnDollBGCoords.U, PawnDollBGCoords.V, PawnDollBGCoords.UL, PawnDollBGCoords.VL, ScaledTeamHUDColor);

        // The ShieldBelt/Default Doll
        Canvas.SetPos(POS.X + (DollOffsetX * ResolutionScale), POS.Y + (DollOffsetY * ResolutionScale));
        if ( TMPawnOwner.ShieldBeltArmor > 0.0f )
        {
            DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 71, 224, 56, 109,ScaledWhite);
        }
        else
        {
            DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 4, 224, 56, 109, ScaledTeamHUDColor);
        }

        if ( TMPawnOwner.VestArmor > 0.0f )
        {
            Canvas.SetPos(POS.X + (VestX * ResolutionScale), POS.Y + (VestY * ResolutionScale));
            DrawTileCentered(AltHudTexture, VestWidth * ResolutionScale, VestHeight * ResolutionScale, 132, 220, 46, 28, ScaledWhite);
        }

        if (TMPawnOwner.ThighpadArmor > 0.0f )
        {
            Canvas.SetPos(POS.X + (ThighX * ResolutionScale), POS.Y + (ThighY * ResolutionScale));
            DrawTileCentered(AltHudTexture, ThighWidth * ResolutionScale, ThighHeight * ResolutionScale, 134, 263, 42, 28, ScaledWhite);
        }

        if (TMPawnOwner.HelmetArmor > 0.0f )
        {
            Canvas.SetPos(POS.X + (HelmetX * ResolutionScale), POS.Y + (HelmetY * ResolutionScale));
            DrawTileCentered(AltHudTexture, HelmetHeight * ResolutionScale, HelmetWidth * ResolutionScale, 193, 265, 22, 25, ScaledWhite);
        }

        if (TMPawnOwner.JumpBootCharge > 0 )
        {
            Canvas.SetPos(POS.X + BootX*ResolutionScale, POS.Y + BootY*ResolutionScale);
            DrawTileCentered(AltHudTexture, BootWidth * ResolutionScale, BootHeight * ResolutionScale, 222, 263, 54, 26, ScaledWhite);

            Canvas.Strlen(string(TMPawnOwner.JumpBootCharge),XL,YL);
            Canvas.SetPos(POS.X + (BootX-1)*ResolutionScale - 0.5*XL, POS.Y + (BootY+3)*ResolutionScale - 0.5*YL);
            Canvas.DrawText(  TMPawnOwner.JumpBootCharge, false, , , TextRenderInfo );
        }
    }

    // Next, the health and Armor widgets

    // Draw the Health Background
    Canvas.SetPos(POS.X + HealthBGOffsetX * ResolutionScale,POS.Y + HealthBGOffsetY * ResolutionScale);

    Canvas.DrawTile(AltHudTexture, HealthBGCoords.UL * ResolutionScale, HealthBGCoords.VL * ResolutionScale, HealthBGCoords.U, HealthBGCoords.V, HealthBGCoords.UL, HealthBGCoords.VL, TeamHudColor);
    Canvas.DrawColor = WhiteColor;

    // Draw the Health Text
    Health = TMPawnOwner.Health;

    // Figure out if we should be pulsing
    if ( Health > LastHealth )
    {
        HealthPulseTime = WorldInfo.TimeSeconds;
    }
    LastHealth = Health;

    Amount = (Health > 0) ? ""$Health : "0";
    DrawGlowText(Amount, POS.X + HealthTextX * ResolutionScale, POS.Y + HealthTextY * ResolutionScale, 60 * ResolutionScale, HealthPulseTime,true);

    // Draw the Health Icon
    Canvas.SetPos(POS.X + HealthIconX * ResolutionScale, POS.Y + HealthIconY * ResolutionScale);
    DrawTileCentered(AltHudTexture, 42 * ResolutionScale , 30 * ResolutionScale, 216, 102, 56, 40, LC_White);

    // Only Draw the Armor if there is any
    // TODO - Add fading
    if ( ArmorAmount > 0 )
    {
        if (ArmorAmount > LastArmorAmount)
        {
            ArmorPulseTime = WorldInfo.TimeSeconds;
        }
        LastArmorAmount = ArmorAmount;

        // Draw the Armor Background
        Canvas.SetPos(POS.X + ArmorBGOffsetX * ResolutionScale,POS.Y + ArmorBGOffsetY * ResolutionScale);
        Canvas.DrawTile(AltHudTexture, ArmorBGCoords.UL * ResolutionScale, ArmorBGCoords.VL * ResolutionScale, ArmorBGCoords.U, ArmorBGCoords.V, ArmorBGCoords.UL, ArmorBGCoords.VL, ScaledTeamHudColor);
        Canvas.DrawColor = WhiteColor;
        Canvas.DrawColor.A = 255.0 * DollVisibility;

        // Draw the Armor Text
        DrawGlowText(""$INT(ArmorAmount), POS.X + ArmorTextX * ResolutionScale, POS.Y + ArmorTextY * ResolutionScale, 45 * ResolutionScale, ArmorPulseTime,true);

        // Draw the Armor Icon
        Canvas.SetPos(POS.X + ArmorIconX * ResolutionScale, POS.Y + ArmorIconY * ResolutionScale);
        DrawTileCentered(AltHudTexture, (33 * ResolutionScale) , (24 * ResolutionScale), 225, 68, 42, 32, ScaledWhite);
    }
}

function DisplayHealth()
{
    local vector2d POS;
    local LinearColor HealthColor;
    local string Amount;
    local float MissingHealthPct;

    POS = ResolveHudPosition(AmmoPosition,112,70);
    POS.X = 0.05 * Canvas.ClipX;
    HealthColor = WhiteLinearColor;

    if ( TMPawnOwner.Health > TMPawnOwner.HealthMax )
    {
        // draw super health cross
        HealthColor.B = 5.0;
        HealthColor.R = 0.3;
        HealthColor.G = 0.3;

        Canvas.SetPos(POS.X - 100*ResolutionScale,POS.Y-60*ResolutionScale);
        Canvas.DrawTile(AltHudTexture, 240 * ResolutionScale , 120 * ResolutionScale, 216, 102, 56, 40, HealthColor);
        HealthColor = WhiteLinearColor;
    }

    HealthColor.R = 0;
    HealthColor.B = 0;

    Canvas.SetPos(POS.X - 80*ResolutionScale,POS.Y - 50*ResolutionScale);
    Canvas.DrawTile(AltHudTexture, 200 * ResolutionScale , 100 * ResolutionScale, 216, 102, 56, 40, HealthColor);

    HealthColor = WhiteLinearColor;
    MissingHealthPct = 100 - FMin(TMPawnOwner.Health,100);
    Canvas.SetPos(POS.X - 80*ResolutionScale,POS.Y - 50*ResolutionScale + MissingHealthPct * ResolutionScale);
    Canvas.DrawTile(AltHudTexture, 200 * ResolutionScale , FMin(TMPawnOwner.Health,100) * ResolutionScale, 216, 102+0.4*MissingHealthPct, 56, 40*(100-MissingHealthPct)/100, HealthColor);

    // Draw the background
    Canvas.SetPos(POS.X+16*ResolutionScale,POS.Y);
    Canvas.DrawTile(BkgTexture,112 * ResolutionScale, 53 * ResolutionScale,BkgTexCoords.U,BkgTexCoords.V,BkgTexCoords.UL,BkgTexCoords.VL, TeamHudColor);

    // Draw the amount
    Amount = ""$TMPawnOwner.Health;
    Canvas.DrawColor = WhiteColor;

        if ( TMPawnOwner.Health != LastHealth )
        {
            HealthPulseTime = WorldInfo.TimeSeconds;
        }

    DrawGlowText(Amount, POS.X + (113 * ResolutionScale), POS.Y + (4 * ResolutionScale), 50 * ResolutionScale, HealthPulseTime,true);

    LastHealth = TMPawnOwner.Health;
}

function DisplayAmmo(TMWeapon Weapon)
{
    local vector2d POS;
    local string Amount;
    local float BarWidth, PercValue;
    local int AmmoCount;

    if ( Weapon.AmmoDisplayType == EAWDS_None )
    {
        return;
    }

    // Resolve the position
    POS = ResolveHudPosition(AmmoPosition,AmmoBGCoords.UL,AmmoBGCoords.VL);

    if ( Weapon.AmmoDisplayType != EAWDS_BarGraph )
    {
        // Figure out if we should be pulsing
        AmmoCount = Weapon.GetAmmoCount();

        if ( AmmoCount > LastAmmoCount && LastWeapon == Weapon )
        {
            AmmoPulseTime = WorldInfo.TimeSeconds;
        }

        LastWeapon = Weapon;
        LastAmmoCount = AmmoCount;

        // Draw the background
        Canvas.SetPos(POS.X,POS.Y - (AmmoBarOffsetY * ResolutionScale));
        Canvas.DrawTile(AltHudTexture, AmmoBGCoords.UL * ResolutionScale, AmmoBGCoords.VL * ResolutionScale, AmmoBGCoords.U, AmmoBGCoords.V, AmmoBGCoords.UL, AmmoBGCoords.VL, TeamHudColor);

        // Draw the amount
        Amount = ""$AmmoCount;
        Canvas.DrawColor = WhiteColor;

        DrawGlowText(Amount, POS.X + (AmmoTextOffsetX * ResolutionScale), POS.Y - ((AmmoBarOffsetY + AmmoTextOffsetY) * ResolutionScale), 58 * ResolutionScale, AmmoPulseTime,true);
    }

    // If we have a bar graph display, do it here
    if ( Weapon.AmmoDisplayType != EAWDS_Numeric )
    {
        PercValue = Weapon.GetPowerPerc();

        Canvas.SetPos(POS.X + (40 * ResolutionScale), POS.Y - 8 * ResolutionScale);
        Canvas.DrawTile(AltHudTexture, 76 * ResolutionScale, 18 * ResolutionScale, 376,458, 88, 14, LC_White);

        BarWidth = 70 * ResolutionScale;
        DrawHealth(POS.X + (43 * ResolutionScale), POS.Y - 4 * ResolutionScale, BarWidth * PercValue,  BarWidth, 16, Canvas);
    }
}

function DisplayPowerups()
{
    local TMTimedPowerup TP;
    local float YPos;

    if ( bIsSplitScreen )
    {
        YPos = Canvas.ClipY * 0.55;
    }
    else
    {
        YPos = Canvas.ClipY * PowerupYPos;
    }

    bDisplayingPowerups = false;
    if (bShowPowerups)
    {
        foreach TMPawnOwner.InvManager.InventoryActors(class'TMTimedPowerup', TP)
        {
            TP.DisplayPowerup(Canvas, self, ResolutionScale, YPos);
            bDisplayingPowerups = true;
        }
    }
}

function DisplayScoring()
{
    local vector2d POS;

    if ( bShowFragCount || (bHasLeaderboard && bShowLeaderboard) )
    {
        POS = ResolveHudPosition(ScoringPosition, 115,44);

        if ( bShowFragCount )
        {
            DisplayFragCount(POS);
        }

        if ( bHasLeaderboard )
        {
            DisplayLeaderBoard(POS);
        }
    }
}


function DisplayFragCount(vector2d POS)
{
    local int FragCount;
    local TMPlayerReplicationInfo FragPRI;

    FragPRI = ((PawnOwner != None) && (PawnOwner.PlayerReplicationInfo != None)) ? TMPlayerReplicationInfo(PawnOwner.PlayerReplicationInfo) : TMOwnerPRI;

    Canvas.SetPos(POS.X, POS.Y);
    Canvas.DrawTile(AltHudTexture, 115 * ResolutionScale, 44 * ResolutionScale, 374, 395, 115, 44, TeamHudColor);
    Canvas.DrawColor = WhiteColor;

    // Figure out if we should be pulsing

    FragCount = (FragPRI != None) ? FragPRI.Score : 0.0;
    if ( FragCount > LastFragCount )
    {
        FragPulseTime = WorldInfo.TimeSeconds;
        LastFragCount = FragCount;
    }

    DrawGlowText(""$FragCount, POS.X + (87 * ResolutionScale), POS.Y + (-2 * ResolutionScale), 42 * ResolutionScale, FragPulseTime,true);
}

/*
*   Draws a nameplate behind text
*   @param Pos - top center of the nameplate
*   @param Wordwidth - width the name takes up (already accounts for resolution)
*   @param NameplateColor - linear color for the background texture
*   @param WordHeight - height of the nameplate (already accounts for resolution)
*/
function DrawNameplateBackground(vector2d Pos, float WordWidth, LinearColor NameplateColor, optional float WordHeight = 0.0)
{
    local float NameplateHeight, EndCapWidth;

    if (WordHeight > 0)
    {
        NameplateHeight = WordHeight;
    }
    else
    {
        NameplateHeight = NameplateCenter.VL * ResolutionScale;
    }

    EndCapWidth = NameplateWidth * ResolutionScale;

    //Start to the right half the length of the text
    Canvas.SetPos(Pos.X - (0.5 * WordWidth) - EndCapWidth, Pos.Y);
    Canvas.DrawTile(TM3GHudTexture, EndCapWidth, NameplateHeight, NameplateLeft.U, NameplateLeft.V, NameplateLeft.UL, NameplateLeft.VL, NameplateColor);
    Canvas.DrawTile(TM3GHudTexture, WordWidth, NameplateHeight, NameplateCenter.U, NameplateCenter.V, NameplateCenter.UL, NameplateCenter.VL, NameplateColor);
    Canvas.DrawTile(TM3GHudTexture, EndCapWidth, NameplateHeight, NameplateRight.U, NameplateRight.V, NameplateRight.UL, NameplateRight.VL, NameplateColor);
}

function DisplayLeaderBoard(vector2d POS)
{
    local string Work,MySpreadStr;
    local int i, MySpread, MyPosition, LeaderboardCount;
    local float XL,YL;
    local vector2d BackgroundPos;
    local bool bTravelling;
    local TMPlayerReplicationInfo FragPRI;

    FragPRI = ((PawnOwner != None) && (PawnOwner.PlayerReplicationInfo != None)) ? TMPlayerReplicationInfo(PawnOwner.PlayerReplicationInfo) : TMOwnerPRI;

    if ( (TMGRI == None) || (FragPRI == None) )
    {
        return;
    }

    POS.X = 0.99*Canvas.ClipX;
    POS.Y += 50 * ResolutionScale;

    // Figure out your Spread
    bTravelling = WorldInfo.IsInSeamlessTravel() || FragPRI.bFromPreviousLevel;
    for (i = 0; i < TMGRI.PRIArray.length; i++)
    {
        if (bTravelling || !TMGRI.PRIArray[i].bFromPreviousLevel)
        {
            break;
        }
    }
    if ( TMGRI.PRIArray[i] == FragPRI )
    {
        if ( TMGRI.PRIArray.Length > i + 1 )
        {
            MySpread = FragPRI.Score - TMGRI.PRIArray[i + 1].Score;
        }
        else
    {
        MySpread = 0;
        }
        MyPosition = 0;
    }
    else
    {
        MySpread = FragPRI.Score - TMGRI.PRIArray[i].Score;
        MyPosition = TMGRI.PRIArray.Find(FragPRI);
    }

    if (MySpread >0)
    {
        MySpreadStr = "+"$String(MySpread);
    }
    else
    {
        MySpreadStr = string(MySpread);
    }

    // Draw the Spread
    Work = string(MyPosition+1) $ PlaceMarks[min(MyPosition,3)] $ " / " $ MySpreadStr;

    Canvas.Font = GetFontSizeIndex(2);
    Canvas.SetDrawColor(255,255,255,255);

    Canvas.Strlen(Work,XL,YL);
    BackgroundPos.X = POS.X - (0.5 * XL);
    BackgroundPos.Y = POS.Y;
    DrawNameplateBackground(BackgroundPos, XL, BlackBackgroundColor, YL);
    Canvas.SetPos(POS.X - XL, POS.Y);
    Canvas.DrawText(Work, , , , TextRenderInfo);

    if ( bShowLeaderboard )
    {
        POS.Y += YL * 1.2;

        // Draw the leaderboard
        Canvas.Font = GetFontSizeIndex(1);
        Canvas.SetDrawColor(200,200,200,255);
        for (i = 0; i < TMGRI.PRIArray.Length && LeaderboardCount < 3; i++)
        {
            if ( TMGRI.PRIArray[i] != None && !TMGRI.PRIArray[i].bOnlySpectator &&
                (bTravelling || !TMGRI.PRIArray[i].bFromPreviousLevel) )
            {
                Work = string(i+1) $ PlaceMarks[i] $ ":" @ TMGRI.PRIArray[i].PlayerName;
                Canvas.StrLen(Work,XL,YL);
                BackgroundPos.X = POS.X - (0.5 * XL);
                BackgroundPos.Y = POS.Y;
                DrawNameplateBackground(BackgroundPos, XL, BlackBackgroundColor, (1.05 * YL));
                Canvas.SetPos(POS.X-XL,POS.Y+(2*ResolutionScale));
                Canvas.DrawText( Work, , , , TextRenderInfo );
                POS.Y += (1.05 * YL);

                LeaderboardCount++;
            }
        }
    }
}

/**
 * Toggle the Quick Pick Menu
 */
exec function ShowQuickPickMenu(bool bShow)
{
    if ( PlayerOwner != None && PlayerOwner.Pawn != None && bShow != bShowQuickPick &&
        (!bShow || TMPawn(PlayerOwner.Pawn) == None || !TMPawn(PlayerOwner.Pawn).bFeigningDeath) )
    {
        bShowQuickPick = bShow;
        if ( bShow )
        {
            QuickPickTarget = PlayerOwner.Pawn;
            QuickPickCurrentSelection = -1;
            bQuickPickMadeNewSelection = false;
        }
        else
        {
            if (QuickPickCurrentSelection != -1)
            {
                if (TMPawn(QuickPickTarget) != None)
                {
                    TMPawn(QuickPickTarget).QuickPick(QuickPickCurrentSelection);
                }
//              else if ( TMVehicleBase(QuickPickTarget) != None)
//              {
//                  TMVehicleBase(QuickPickTarget).QuickPick(QuickPickCurrentSelection);
//              }
            }
            QuickPickTarget = None;
        }
    }
}

simulated function DisplayQuickPickMenu()
{
    local int i, CurrentWeaponIndex;
    local float Angle,x,y;
    local array<QuickPickCell> Cells;
    local rotator r;
    local float AdjustedScale;

    if ( bIsSplitScreen )
    {
        AdjustedScale = 0.63 * ResolutionScale;
    }
    else
    {
        AdjustedScale = ResolutionScale;
    }

    if ( QuickPickTarget == PawnOwner )
    {
        CurrentWeaponIndex = -1;
        if ( TMPawn(QuickPickTarget) != none )
        {
            TMPawn(QuickPickTarget).GetQuickPickCells(Self, Cells, CurrentWeaponIndex);
        }
//      else if ( TMVehicleBase(QuickPickTarget) != none )
//      {
//          TMVehicleBase(QuickPickTarget).GetQuickPickCells(Self, Cells, CurrentWeaponIndex);
//      }
        if (QuickPickCurrentSelection == -1)
        {
            QuickPickCurrentSelection = CurrentWeaponIndex;
        }

        if ( Cells.Length > 0 )
        {
            QuickPickNumCells = Cells.Length;
            QuickPickDeltaAngle = 360.0 / float(QuickPickNumCells);
            Angle = 0.0;

            X = Canvas.ClipX * 0.5;
            Y = Canvas.ClipY * 0.5;

            //  The QuickMenu is offset differently depending if the top or bottom.
            if ( bIsSplitScreen )
            {
                if ( bIsFirstPlayer )
                {
                    Y -= (1.0 - SafeRegionPct) * 0.5 * Canvas.ClipY;
                }
                else
                {
                    Y += (1.0 - SafeRegionPct) * 0.5 * Canvas.ClipY;
                }
            }

            Canvas.SetPos(X - (164 * AdjustedScale * 0.5), Y - (264 * AdjustedScale) );
            R.Yaw = 0;

            // The base image is horz.  So adjust.
            for (i=0; i<8; i++)
            {
                if (Cells[i].Icon == None)
                {
                    //Very transparent for non-existant weapons
                    Canvas.SetDrawColor(128,128,128,128);
                }
                else
                {
            //Weapon icon is present
                    Canvas.SetDrawColor(255,255,255,255);
                }

                Canvas.DrawRotatedTile(IconHudTexture,R, 164 * AdjustedScale, 264 * AdjustedScale,289,315,164,264,0.5,1.0);
                r.Yaw += (QuickPickDeltaAngle * 182.04444);
            }

            Canvas.DrawColor = WHITECOLOR;
            for (i=0; i<Cells.Length; i++)
            {
                DisplayQuickPickCell(Cells[i], Angle, i == QuickPickCurrentSelection);
                Angle += QuickPickDeltaAngle;
            }
        }
        else
        {
            bShowQuickPick = false;
        }
    }
    else
    {
        bShowQuickPick = false;
    }
}

simulated function DisplayQuickPickCell(QuickPickCell Cell, float Angle, bool bSelected)
{
    local float X,Y, rX, rY,w,h;
    local float DrawScaler;
    local rotator r;
    local float AdjustedScale;
    local float SplitScreenOffsetY;

    if ( bIsSplitScreen )
    {
        AdjustedScale = 0.63 * ResolutionScale;
    }
    else
    {
        AdjustedScale = ResolutionScale;
    }

    if (Cell.bDrawCell)
    {
        SplitScreenOffsetY = 0.0;

        //  The QuickMenu is offset differently depending if the top or bottom.
        if ( bIsSplitScreen )
        {
            if ( bIsFirstPlayer )
            {
                SplitScreenOffsetY = -(1.0 - SafeRegionPct) * 0.5 * Canvas.ClipY;
            }
            else
            {
                SplitScreenOffsetY = (1.0 - SafeRegionPct) * 0.5 * Canvas.ClipY;
            }
        }

        if ( bSelected )
        {
            X = Canvas.ClipX * 0.5;
            Y = Canvas.ClipY * 0.5;

            Canvas.SetDrawColor(255,255,255,255);
            Canvas.SetPos( X - (164 * AdjustedScale * 0.5), Y - (264 * AdjustedScale) + SplitScreenOffsetY );
            R.Yaw = (Angle * 182.044444);
            Canvas.DrawRotatedTile(IconHudTexture,R, 164 * AdjustedScale, 264 * AdjustedScale,791,118,164,264,0.5,1.0);
        }

        DrawScaler = AdjustedScale * (bSelected ? 1.5 : 1.25);

        Angle *= (PI / 180);

        X = 0.0;
        Y = QuickPickRadius * AdjustedScale;

        // Tranform the location

        rX = (cos(Angle) * X) - (sin(Angle) * Y);
        rY = (sin(Angle) * X) - (cos(Angle) * Y);

        rX = (Canvas.ClipX * 0.5) + rX * -1;    // Flip the X
        rY = (Canvas.ClipY * 0.5) + rY;

        // Draw the Cell's Icon

        w = Cell.IconCoords.UL * DrawScaler;
        h = Cell.IconCoords.VL * DrawScaler;

        Canvas.SetPos( rX, rY + SplitScreenOffsetY);
        DrawTileCentered(IconHudTexture, (w + 4) * AdjustedScale * 0.75, (h + 4) * AdjustedScale * 0.75,Cell.IconCoords.U,Cell.IconCoords.V,Cell.IconCoords.UL,Cell.IconCoords.VL, MakeLinearColor(0,0,0,1));


        Canvas.SetPos( rX, rY + SplitScreenOffsetY);
        //Cell.Icon
        DrawTileCentered(IconHudTexture, Cell.IconCoords.UL * DrawScaler * AdjustedScale * 0.75, Cell.IconCoords.VL * DrawScaler * AdjustedScale * 0.75,
                        Cell.IconCoords.U,Cell.IconCoords.V,Cell.IconCoords.UL,Cell.IconCoords.VL, WhiteLinearColor);


    }
}

/**
 * Change the selection in a given QuickPick group
 */
simulated function QuickPick(int Quad)
{
    if (QuickPickTarget != none && Quad >= 0 )
    {
        if ( QuickPickCurrentSelection != Quad )
        {
            //PlayerOwner.ClientPlaySound(soundcue'A_interface.Menu.UT3MenuWeaponSelect01Cue');

            if( TMPlayerController(PlayerOwner) != None )
            {
                TMPlayerController(PlayerOwner).ClientPlayForceFeedbackWaveform(QuickPickWaveForm);
            }
        }
        QuickPickCurrentSelection = Quad;
        bQuickPickMadeNewSelection = true;
    }
    else
    {
        QuickPickCurrentSelection = -1;
        bQuickPickMadeNewSelection = false;
        //PlayerOwner.ClientPlaySound(soundcue'A_interface.Menu.UT3MenuNavigateDownCue');
    }
}

/** Convert a string with potential escape sequenced data in it to a font and the string that should be displayed */
native static function TranslateBindToFont(string InBindStr, out Font DrawFont, out string OutBindStr);

//Given a input command of the form GBA_ and its mapping store that in a lookup for future use
function DrawToolTip(Canvas Cvs, PlayerController PC, string Command, float X, float Y, float U, float V, float UL, float VL, float ResScale, optional Texture2D IconTexture = default.IconHudTexture, optional float Alpha=1.0)
{
    local float Left,xl,yl;
    local float ScaleX, ScaleY;
    local float WholeWidth;
    local string MappingStr; //String of key mapping
    local font OrgFont, BindFont;
    local string Key;

    //Catchall for spectators who don't need tooltips
    if (PC.PlayerReplicationInfo.bOnlySpectator || LastTimeTooltipDrawn == WorldInfo.TimeSeconds)
    {
        return;
    }

    //Only draw one tooltip per frame
    LastTimeTooltipDrawn = WorldInfo.TimeSeconds;

    OrgFont = Cvs.Font;

    //Get the fully localized version of the key binding
    TMPlayerController(PC).BoundEventsStringDataStore.GetStringWithFieldName(Command, MappingStr);
    if (MappingStr == "")
    {
       ;
       return;
        }

    TranslateBindToFont(MappingStr, BindFont, Key);

    if ( BindFont != none )
    {
        //These values might be negative (for flipping textures)
        ScaleX = abs(UL);
        ScaleY = abs(VL);
        Cvs.DrawColor = default.WhiteColor;
        Cvs.DrawColor.A = Alpha * 255;

        //Find the size of the string to be draw
        Cvs.Font = BindFont;
        Cvs.StrLen(Key, XL,YL);

        //Figure the offset from center for the left side
        WholeWidth = XL + (ScaleX * ResScale) + (default.ToolTipSepCoords.UL * ResScale);
        Left = X - (WholeWidth * 0.5);

        //Center and draw the key binding string
        Cvs.SetPos(Left, Y - (YL * 0.5));
        Cvs.DrawText(Key, true, , , TextRenderInfo);

        //Position to the end of the keybinding string
        Left += XL;
        Cvs.SetPos(Left, Y - (default.ToolTipSepCoords.VL * ResScale * 0.5));
        //Draw the separation icon (arrow)
        Cvs.DrawTile(default.IconHudTexture,default.ToolTipSepCoords.UL * ResScale, default.ToolTipSepCoords.VL * ResScale,
                     default.ToolTipSepCoords.U,default.ToolTipSepCoords.V,default.ToolTipSepCoords.UL,default.ToolTipSepCoords.VL);

        //Position to the end of the separation icon
        Left += (default.ToolTipSepCoords.UL * ResScale);
        Cvs.SetPos(Left, Y - (ScaleY * ResScale * 0.5) );
        //Draw the tooltip icon
        Cvs.DrawTile(IconTexture, ScaleX * ResScale, ScaleY * ResScale, U, V, UL, VL);
    }

    Cvs.Font = OrgFont;
}

/**
 * Display current messages
 */
function DisplayConsoleMessages()
{
    local int Idx, XPos, YPos;
    local float XL, YL;

    if (ConsoleMessages.Length == 0 || PlayerOwner.bCinematicMode)
    {
        return;
    }

    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
        if ( ConsoleMessages[Idx].Text == "" || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds )
        {
            ConsoleMessages.Remove(Idx--,1);
        }
    }
    ConsoleMessagePosX = bDisplayingPowerups ? 0.1 : 0.0;
    XPos = (ConsoleMessagePosX * HudCanvasScale * Canvas.SizeX) + (((1.0 - HudCanvasScale) / 2.0) * Canvas.SizeX);
    YPos = (ConsoleMessagePosY * HudCanvasScale * Canvas.SizeY) + (((1.0 - HudCanvasScale) / 2.0) * Canvas.SizeY);

    Canvas.Font = GetFontSizeIndex(0);

    Canvas.TextSize ("A", XL, YL);

    YPos -= YL * ConsoleMessages.Length; // DP_LowerLeft
    YPos -= YL; // Room for typing prompt

    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
        if (ConsoleMessages[Idx].Text == "")
        {
            continue;
        }
        Canvas.StrLen( ConsoleMessages[Idx].Text, XL, YL );
        Canvas.SetPos( XPos, YPos );
        Canvas.DrawColor = ConsoleMessages[Idx].TextColor;
        Canvas.DrawText( ConsoleMessages[Idx].Text, false );
        YPos += YL;
    }
}

simulated function DrawShadowedTile(texture2D Tex, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, Optional bool bScaleToRes)
{
    local Color B;

    B = BlackColor;
    B.A = TileColor.A;

    XL *= (bScaleToRes) ? ResolutionScale : 1.0;
    YL *= (bScaleToRes) ? ResolutionScale : 1.0;

    Canvas.SetPos(X+1,Y+1);
    Canvas.DrawColor = B;
    Canvas.DrawTile(Tex,XL,YL,U,V,UL,VL);
    Canvas.SetPos(X,Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawTile(Tex,XL,YL,U,V,UL,VL);
}

simulated function DrawShadowedStretchedTile(texture2D Tex, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, Optional bool bScaleToRes)
{
    local LinearColor C,B;

    C = ColorToLinearColor(TileColor);
    B = ColorToLinearColor(BlackColor);
    B.A = C.A;

    XL *= (bScaleToRes) ? ResolutionScale : 1.0;
    YL *= (bScaleToRes) ? ResolutionScale : 1.0;

    Canvas.SetPos(X+1,Y+1);
    Canvas.DrawTileStretched(Tex,XL,YL,U,V,UL,VL,B);
    Canvas.SetPos(X,Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawTileStretched(Tex,XL,YL,U,V,UL,VL,C);
}

simulated function DrawShadowedRotatedTile(texture2D Tex, Rotator Rot, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, Optional bool bScaleToRes)
{
    local Color B;

    B = BlackColor;
    B.A = TileColor.A;

    XL *= (bScaleToRes) ? ResolutionScale : 1.0;
    YL *= (bScaleToRes) ? ResolutionScale : 1.0;

    Canvas.SetPos(X+1,Y+1);
    Canvas.DrawColor = B;
    Canvas.DrawRotatedTile(Tex,Rot,XL,YL,U,V,UL,VL);
    Canvas.SetPos(X,Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawRotatedTile(Tex,Rot,XL,YL,U,V,UL,VL);
}

