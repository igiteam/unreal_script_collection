class MOHAHUDCursor extends MOHAHUDImg
    native;

enum ECursorType
{
    CURSOR_TYPE_DEFAULT,            // 0
    CURSOR_TYPE_TEAMMATE,           // 1
    CURSOR_TYPE_UPGRADE_1,          // 2
    CURSOR_TYPE_UPGRADE_2,          // 3
    CURSOR_TYPE_UPGRADE_3,          // 4
    CURSOR_TYPE_MAX                 // 5
};

struct native HUDCursorData
{
    var Vector2D Vertical_UVPos;
    var Vector2D Vertical_UVSize;
    var Vector2D Vertical_PixelSize;
    var Vector2D Horizontal_UVPos;
    var Vector2D Horizontal_UVSize;
    var Vector2D Horizontal_PixelSize;

    structdefaultproperties
    {
        Vertical_UVPos=(X=0.0000000,Y=0.0000000)
        Vertical_UVSize=(X=0.0000000,Y=0.0000000)
        Vertical_PixelSize=(X=0.0000000,Y=0.0000000)
        Horizontal_UVPos=(X=0.0000000,Y=0.0000000)
        Horizontal_UVSize=(X=0.0000000,Y=0.0000000)
        Horizontal_PixelSize=(X=0.0000000,Y=0.0000000)
    }
};

var array<HUDCursorData> CursorData;
var MOHAHUDCursor.ECursorType CursorType;
var bool bSprintedLastTick;
var bool CursorRenderingEnabled;
var float DistFromCenterPixels;
var float AccuracySpread;
var float AccuracySpreadUnblended;
var float MaxAccuracyToPixelScale;
var int disableCount;
var MOHAHUDImg RangeFinder;

// Export UMOHAHUDCursor::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

function UpdateCursorType(MOHAHUDCursor.ECursorType new_cursorType)
{
    CursorType = new_cursorType;
    //return;    
}

function ResetCursor()
{
    disableCount = 0;
    RenderWithQuickFade(true);
    //return;    
}

function bool ShouldRender()
{
    // End:0x1B
    if(MOHAHUD.IsCursorDisabledByServer() == true)
    {
        return false;
    }
    return super.ShouldRender();
    //return ReturnValue;    
}

event RenderWithQuickFade(bool bEnabled)
{
    // End:0x16
    if(bEnabled == false)
    {
        disableCount++;        
    }
    else
    {
        disableCount--;
    }
    // End:0x2F
    if(disableCount < 0)
    {
        disableCount = 0;
    }
    // End:0x5F
    if((bEnabled == false) && disableCount == 1)
    {
        StartFadeOut(0.2000000, 0.0000000);        
    }
    else
    {
        // End:0x8C
        if((bEnabled == true) && disableCount == 0)
        {
            StartFadeIn(0.2000000, 0.0000000);
        }
    }
    //return;    
}

function Init()
{
    super(MOHAHUDObj).Init();
    RangeFinder = new Class'MOHAHUDImg';
    RangeFinder.MOHAHUD = MOHAHUD;
    RangeFinder.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    RangeFinder.Link(self, 0, 0);
    RangeFinder.SetSize(85.0000000, 85.0000000);
    RangeFinder.SetTileUV(256.0000000, 384.0000000);
    RangeFinder.SetTileSizeUV(128.0000000, 128.0000000);
    RangeFinder.JustifyXCenter();
    RangeFinder.JustifyYCenter();
    RangeFinder.SetRenderGroup(0);
    RangeFinder.EnableElement(true);
    //return;    
}

defaultproperties
{
    CursorData[0]=(Vertical_UVPos=(X=256.0000000,Y=320.0000000),Vertical_UVSize=(X=64.0000000,Y=64.0000000),Vertical_PixelSize=(X=36.0000000,Y=36.0000000),Horizontal_UVPos=(X=320.0000000,Y=320.0000000),Horizontal_UVSize=(X=64.0000000,Y=64.0000000),Horizontal_PixelSize=(X=36.0000000,Y=36.0000000))
    CursorData[1]=(Vertical_UVPos=(X=448.0000000,Y=256.0000000),Vertical_UVSize=(X=64.0000000,Y=64.0000000),Vertical_PixelSize=(X=40.0000000,Y=40.0000000),Horizontal_UVPos=(X=0.0000000,Y=0.0000000),Horizontal_UVSize=(X=0.0000000,Y=0.0000000),Horizontal_PixelSize=(X=0.0000000,Y=0.0000000))
    CursorData[2]=(Vertical_UVPos=(X=384.0000000,Y=320.0000000),Vertical_UVSize=(X=64.0000000,Y=64.0000000),Vertical_PixelSize=(X=36.0000000,Y=36.0000000),Horizontal_UVPos=(X=448.0000000,Y=320.0000000),Horizontal_UVSize=(X=64.0000000,Y=64.0000000),Horizontal_PixelSize=(X=36.0000000,Y=36.0000000))
    CursorRenderingEnabled=true
    MaxAccuracyToPixelScale=75.0000000
}