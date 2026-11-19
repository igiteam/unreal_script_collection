class UTHUDBase extends UDKHUD
    transient
    config(Game)
    hidecategories(Navigation);

var EvilGFxUI_PauseMenu PauseMenuMovie;
var class<UTMusicManager> MusicManagerClass;
var UTPlayerController UTPlayerOwner;
var UTGameReplicationInfo UTGRI;
var bool bIsSplitScreen;
var bool bEnableActorOverlays;
var bool bCrosshairShow;
var bool bCrosshairOnFriendly;
var bool bGreenCrosshair;
var TextureCoordinates ToolTipSepCoords;
var float LastTimeTooltipDrawn;
var const Texture2D IconHudTexture;
var config string ConsoleIconFontClassName;
var float ConfiguredCrosshairScaling;
var float LastPickupTime;
var const Color BlackColor;
var const Color GoldColor;
var const Color LightGoldColor;
var const Color LightGreenColor;
var float ResolutionScale;
var float ResolutionScaleX;
var int ViewX;
var int ViewY;

simulated function PostBeginPlay()
{
    local Pawn P;
    local EvilGameObjective O;

    super(MobileHUD).PostBeginPlay();
    UTPlayerOwner = UTPlayerController(PlayerOwner);
    SetTimer(1.0000000, true);
    // End:0x90
    foreach DynamicActors(Class'Engine.Pawn', P)
    {
        // End:0x8F
        if((EvilPawn(P) != none) || EvilVehicle_Base(P) != none)
        {
            AddPostRenderedActor(P);
        }        
    }    
    // End:0xD9
    foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
    {
        AddPostRenderedActor(O);        
    }    
    ConsoleIconFont = Font(DynamicLoadObject(ConsoleIconFontClassName, Class'Engine.Font', true));
    // End:0x16E
    if(UTPlayerOwner.Announcer == none)
    {
        UTPlayerOwner.Announcer = Spawn(Class'UTAnnouncer', UTPlayerOwner);
    }
    // End:0x1E3
    if((UTPlayerOwner.MusicManager == none) && MusicManagerClass != none)
    {
        UTPlayerOwner.MusicManager = Spawn(MusicManagerClass, UTPlayerOwner);
    }
    //return;    
}

simulated event Timer()
{
    super(Actor).Timer();
    // End:0x74
    if(UTGameReplicationInfo(WorldInfo.GRI) != none)
    {
        UTGameReplicationInfo(WorldInfo.GRI).SortPRIArray();
    }
    //return;    
}

exec function ShowMenu()
{
    //return;    
}

function ResolutionChanged()
{
    //return;    
}

event PostRender()
{
    RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
    LastHUDRenderTime = WorldInfo.TimeSeconds;
    bIsSplitScreen = Class'Engine.Engine'.static.IsSplitScreen();
    ResolutionScaleX = Canvas.ClipX / float(1024);
    ResolutionScale = Canvas.ClipY / float(768);
    // End:0x104
    if(bIsSplitScreen)
    {
        ResolutionScale *= 2.0000000;
    }
    // End:0x1C0
    if((float(ViewX) != Canvas.ClipX) || float(ViewY) != Canvas.ClipY)
    {
        ResolutionChanged();
        ViewX = int(Canvas.ClipX);
        ViewY = int(Canvas.ClipY);
    }
    UTGRI = UTGameReplicationInfo(WorldInfo.GRI);
    //return;    
}

function OnCloseAnimComplete()
{
    //return;    
}

function OnOpenAnimComplete()
{
    //return;    
}

function RemoveMovies()
{
    // End:0x3A
    if(PauseMenuMovie != none)
    {
        PauseMenuMovie.Close(true);
        PauseMenuMovie = none;
    }
    //return;    
}

function SetVisible(bool bNewVisible)
{
    bEnableActorOverlays = bNewVisible;
    bShowHUD = bNewVisible;
    //return;    
}

function CloseOtherMenus()
{
    //return;    
}

function TogglePauseMenu()
{
    // End:0x86
    if((PauseMenuMovie != none) && PauseMenuMovie.bMovieIsOpen)
    {
        // End:0x79
        if(!WorldInfo.IsPlayInMobilePreview())
        {
            PauseMenuMovie.PlayCloseAnimation();            
        }
        else
        {
            CompletePauseMenuClose();
        }        
    }
    else
    {
        CloseOtherMenus();
        PlayerOwner.SetPause(true);
        // End:0x198
        if(PauseMenuMovie == none)
        {
            PauseMenuMovie = new Class'EvilGFxUI_PauseMenu';
            PauseMenuMovie.bEnableGammaCorrection = false;
            PauseMenuMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));            
            PauseMenuMovie.SetTimingMode(1);
        }
        SetVisible(false);
        PauseMenuMovie.Start();
        PauseMenuMovie.PlayOpenAnimation();
        // End:0x22E
        if(!WorldInfo.IsPlayInMobilePreview())
        {
            PauseMenuMovie.AddFocusIgnoreKey('Escape');
        }
    }
    //return;    
}

function CompletePauseMenuClose()
{
    PlayerOwner.SetPause(false);
    PauseMenuMovie.Close(false);
    SetVisible(true);
    //return;    
}

exec function ReleaseShowScores()
{
    SetShowScores(false);
    //return;    
}

function int GetLocalPlayerOwnerIndex()
{
    return Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));    
    //return ReturnValue;    
}

exec function SetShowScores(bool bEnableShowScores)
{
    //return;    
}

exec function ToggleLeaderboard()
{
    //return;    
}

exec function SetShowLeaderboard(bool bEnableLeaderboard)
{
    // End:0x18
    if(bEnableLeaderboard)
    {
        SetVisible(false);
    }
    //return;    
}

function DrawToolTip(Canvas Cvs, PlayerController PC, string Command, float X, float Y, float U, float V, float UL, float VL, float ResScale, optional Texture2D IconTexture = default.IconHudTexture, optional float Alpha = 1.0000000)
{
    local float Left, XL, YL, ScaleX, ScaleY, WholeWidth;

    local string MappingStr;
    local Font OrgFont, BindFont;
    local string Key;

    // End:0x7D
    if(PC.PlayerReplicationInfo.bOnlySpectator || LastTimeTooltipDrawn == WorldInfo.TimeSeconds)
    {
        return;
    }
    LastTimeTooltipDrawn = WorldInfo.TimeSeconds;
    OrgFont = Cvs.Font;
    UTPlayerController(PC).BoundEventsStringDataStore.GetStringWithFieldName(Command, MappingStr);
    // End:0x12E
    if(MappingStr == "")
    {
        return;
    }
    TranslateBindToFont(MappingStr, BindFont, Key);
    // End:0x59F
    if(BindFont != none)
    {
        ScaleX = Abs(UL);
        ScaleY = Abs(VL);
        Cvs.DrawColor = default.WhiteColor;
        Cvs.DrawColor.A = byte(Alpha * float(255));
        Cvs.Font = BindFont;
        Cvs.StrLen(Key, XL, YL);
        WholeWidth = (XL + (ScaleX * ResScale)) + (default.ToolTipSepCoords.UL * ResScale);
        Left = X - (WholeWidth * 0.5000000);
        Cvs.SetPos(Left, Y - (YL * 0.5000000));
        Cvs.DrawText(Key, true,,, TextRenderInfo);
        Left += XL;
        Cvs.SetPos(Left, Y - ((default.ToolTipSepCoords.VL * ResScale) * 0.5000000));
        Cvs.DrawTile(default.IconHudTexture, default.ToolTipSepCoords.UL * ResScale, default.ToolTipSepCoords.VL * ResScale, default.ToolTipSepCoords.U, default.ToolTipSepCoords.V, default.ToolTipSepCoords.UL, default.ToolTipSepCoords.VL);
        Left += (default.ToolTipSepCoords.UL * ResScale);
        Cvs.SetPos(Left, Y - ((ScaleY * ResScale) * 0.5000000));
        Cvs.DrawTile(IconTexture, ScaleX * ResScale, ScaleY * ResScale, U, V, UL, VL);
    }
    Cvs.Font = OrgFont;
    //return;    
}

function bool CheckCrosshairOnFriendly()
{
    local float Size;
    local Vector HitLocation, HitNormal, StartTrace, EndTrace;
    local Actor HitActor;
    local EvilVehicle_Base V, HitV;
    local EvilWeap_Base W;
    local int SeatIndex;
    local Pawn MyPawnOwner;

    MyPawnOwner = Pawn(PlayerOwner.ViewTarget);
    // End:0x42
    if(MyPawnOwner == none)
    {
        return false;
    }
    V = EvilVehicle_Base(MyPawnOwner);
    // End:0x147
    if(V != none)
    {
        SeatIndex = 0;
        J0x78:

        // End:0x144 [Loop If]
        if(SeatIndex < V.Seats.Length)
        {
            // End:0x136
            if(V.Seats[SeatIndex].SeatPawn == MyPawnOwner)
            {
                HitActor = V.Seats[SeatIndex].AimTarget;
                // [Explicit Break]
                goto J0x144;
            }
            SeatIndex++;
            // [Loop Continue]
            goto J0x78;
        }
        J0x144:
        
    }
    else
    {
        W = EvilWeap_Base(MyPawnOwner.Weapon);
        // End:0x2DB
        if((W != none) && W.EnableFriendlyWarningCrosshair())
        {
            StartTrace = W.InstantFireStartTrace();
            EndTrace = StartTrace + (W.MaxRange() * Vector(PlayerOwner.Rotation));
            HitActor = MyPawnOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000),, 1);
            // End:0x2DB
            if(Pawn(HitActor) == none)
            {
                HitActor = ((HitActor == none) ? none : Pawn(HitActor.Base));
            }
        }
    }
    // End:0x342
    if((Pawn(HitActor) == none) || !WorldInfo.GRI.OnSameTeam(HitActor, MyPawnOwner))
    {
        return false;
    }
    Size = 28.0000000 * (Canvas.ClipY / float(768));
    Canvas.SetPos((Canvas.ClipX * 0.5000000) - (Size * 0.5000000), (Canvas.ClipY * 0.5000000) - (Size * 0.5000000));
    HitV = EvilVehicle_Base(HitActor);
    // End:0x51B
    if(((HitV != none) && HitV.Health < HitV.default.Health) && ((V != none) ? false : false))
    {
        Canvas.SetDrawColor(255, 255, 128, 255);
        Canvas.DrawTile(Class'UTHUD'.default.AltHudTexture, Size, Size, 600.0000000, 262.0000000, 28.0000000, 27.0000000);
    }
    return true;
    //return ReturnValue;    
}

simulated function DrawShadowedTile(Texture2D Tex, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, optional bool bScaleToRes)
{
    local Color B;

    B = BlackColor;
    B.A = TileColor.A;
    XL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    YL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    Canvas.SetPos(X + float(1), Y + float(1));
    Canvas.DrawColor = B;
    Canvas.DrawTile(Tex, XL, YL, U, V, UL, VL);
    Canvas.SetPos(X, Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawTile(Tex, XL, YL, U, V, UL, VL);
    //return;    
}

simulated function DrawShadowedStretchedTile(Texture2D Tex, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, optional bool bScaleToRes)
{
    local LinearColor C, B;

    C = ColorToLinearColor(TileColor);
    B = ColorToLinearColor(BlackColor);
    B.A = C.A;
    XL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    YL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    Canvas.SetPos(X + float(1), Y + float(1));
    Canvas.DrawTileStretched(Tex, XL, YL, U, V, UL, VL, B);
    Canvas.SetPos(X, Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawTileStretched(Tex, XL, YL, U, V, UL, VL, C);
    //return;    
}

simulated function DrawShadowedRotatedTile(Texture2D Tex, Rotator Rot, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Color TileColor, optional bool bScaleToRes)
{
    local Color B;

    B = BlackColor;
    B.A = TileColor.A;
    XL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    YL *= ((bScaleToRes) ? ResolutionScale : 1.0000000);
    Canvas.SetPos(X + float(1), Y + float(1));
    Canvas.DrawColor = B;
    Canvas.DrawRotatedTile(Tex, Rot, XL, YL, U, V, UL, VL);
    Canvas.SetPos(X, Y);
    Canvas.DrawColor = TileColor;
    Canvas.DrawRotatedTile(Tex, Rot, XL, YL, U, V, UL, VL);
    //return;    
}

defaultproperties
{
    ToolTipSepCoords=(U=260.0000000,V=379.0000000,UL=29.0000000,VL=27.0000000)
    ConsoleIconFontClassName="UI_Fonts.Fonts.UI_Fonts_Xbox18"
    ConfiguredCrosshairScaling=1.0000000
    BlackColor=(R=0,G=0,B=0,A=255)
    GoldColor=(R=255,G=183,B=11,A=255)
    LightGoldColor=(R=255,G=255,B=128,A=255)
    LightGreenColor=(R=128,G=255,B=128,A=255)
}