class AdvPuzzleHudComponent extends Object
    config(Game);

var AdvPlayerController APC;
var AdvGFxHud AGFxHud;
var HUD myHUD;
var GFxObject Cursor;
var Vector CursorWorldOrigin;
var Vector CursorWorldDirection;
var Vector Extent;
var Vector2D Cursor2Dposition;
var Vector2D Cursor2Dboundries;
var Vector2D ViewportRatio;
var Vector2D Cursor2DlowerBoundries;
var Vector2D Cursor2DUpperBoundries;
var Vector2D Cursor2DpositionAUX;
var float FlashResolutionX0;
var float FlashResolutionY0;
var float FlashResolutionX1;
var float FlashResolutionY1;
var bool bFixed;
var Vector2D BoundriesModifier;
var() config float GamepadSensitivity;
var() config float MouseSensitivity;
var string CursorPath;

function Init(HUD currentHUD, string Path, bool Fixed)
{
    myHUD = currentHUD;
    CursorPath = Path;
    Cursor = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject(CursorPath);
    Cursor.SetVisible(true);
    Extent.X = 1.0000000;
    Extent.Y = 1.0000000;
    Extent.Z = 1.0000000;
    bFixed = Fixed;
    Cursor2DlowerBoundries.X = 0.0000000;
    Cursor2DlowerBoundries.Y = 0.0000000;
    //return;    
}

simulated function DrawHUD(HUD H)
{
    H.Canvas.DeProject(Cursor2DpositionAUX, CursorWorldOrigin, CursorWorldDirection);
    //return;    
}

function PlayerMove(float DeltaTime, PlayerInput PlayerInputReference, int Offset)
{
    // End:0xD8
    if(Cursor != AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject(CursorPath))
    {
        Cursor = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject(CursorPath);
        Cursor.SetVisible(true);
    }
    AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetGameViewportClient().GetViewportSize(Cursor2Dboundries);
    AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVisibleFrameRect(FlashResolutionX0, FlashResolutionY0, FlashResolutionX1, FlashResolutionY1);
    ViewportRatio.X = Cursor2Dboundries.X / FlashResolutionX1;
    ViewportRatio.Y = Cursor2Dboundries.Y / FlashResolutionY1;
    // End:0x2D2
    if(bFixed)
    {
        Cursor.SetPosition(Cursor2Dposition.X / ViewportRatio.X, Cursor2Dposition.Y / ViewportRatio.Y);        
    }
    else
    {
        Cursor.SetPosition((Cursor2Dposition.X + float(Offset)) / ViewportRatio.X, (Cursor2Dposition.Y + float(Offset)) / ViewportRatio.Y);
        Cursor2DpositionAUX.X = Cursor2Dposition.X + (Cursor2Dboundries.X / float(2));
        Cursor2DpositionAUX.Y = Cursor2Dposition.Y + (Cursor2Dboundries.Y / float(2));
        // End:0x510
        if(PlayerInputReference.bUsingGamepad)
        {
            Cursor2Dposition.X += (((PlayerInputReference.aStrafe * DeltaTime) * GamepadSensitivity) / 5.4000000);
            Cursor2Dposition.Y -= (((PlayerInputReference.aForward * DeltaTime) * GamepadSensitivity) / 5.4000000);            
        }
        else
        {
            Cursor2Dposition.X += ((PlayerInputReference.aMouseX * DeltaTime) * MouseSensitivity);
            Cursor2Dposition.Y -= ((PlayerInputReference.aMouseY * DeltaTime) * MouseSensitivity);
        }
        CutTheBoundriesByModifier(BoundriesModifier);
        Cursor2Dposition.X = FClamp(Cursor2Dposition.X, Cursor2DlowerBoundries.X, Cursor2DUpperBoundries.X);
        Cursor2Dposition.Y = FClamp(Cursor2Dposition.Y, Cursor2DlowerBoundries.Y, Cursor2DUpperBoundries.Y);
    }
    //return;    
}

function CutTheBoundriesByModifier(Vector2D Modifier)
{
    Cursor2DlowerBoundries.X = (-Cursor2Dboundries.X / float(2)) + ((Cursor2Dboundries.X * Modifier.X) / float(2));
    Cursor2DlowerBoundries.Y = (-Cursor2Dboundries.Y / float(2)) + ((Cursor2Dboundries.Y * Modifier.Y) / float(2));
    Cursor2DUpperBoundries.X = (Cursor2Dboundries.X / float(2)) - ((Cursor2Dboundries.X * Modifier.X) / float(2));
    Cursor2DUpperBoundries.Y = (Cursor2Dboundries.Y / float(2)) - ((Cursor2Dboundries.Y * Modifier.Y) / float(2));
    //return;    
}

defaultproperties
{
    GamepadSensitivity=3.0000000
    MouseSensitivity=5.0000000
}