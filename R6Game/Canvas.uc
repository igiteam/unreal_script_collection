class Canvas extends Object
    transient
    native
    noexport;

var Font Font;
var float SpaceX;
var float SpaceY;
var float OrgX;
var float OrgY;
var float ClipX;
var float ClipY;
var float CurX;
var float CurY;
var float CurYL;
var Color DrawColor;
var bool bCenter;
var bool bNoSmooth;
var const int SizeX;
var const int SizeY;
var native const Pointer RenderInterface;
var native const Pointer SceneView;
var Plane ColorModulate;
var Texture2D DefaultTexture;
var int m_iViewportSizeX;
var int m_iViewportSizeY;
var int m_iViewportPosX;
var int m_iViewportPosY;
var float m_fDistortionStrength;
var float m_fDistortionScale;
var int m_iSavedXOrigin2D;
var int m_iSavedYOrigin2D;

// Export UCanvas::execDrawTile(FFrame&, void* const)
native(466) final function DrawTile(Texture2D Tex, float XL, float YL, float U, float V, float UL, float VL);

// Export UCanvas::execDrawRotatedTile(FFrame&, void* const)
native final function DrawRotatedTile(Texture2D Tex, float XL, float YL, float fRadianAngle);

// Export UCanvas::execDrawCircle(FFrame&, void* const)
native final function DrawCircle(float fXPos, float fYPos, float fRadius, int iNbSides);

// Export UCanvas::execDrawLine(FFrame&, void* const)
native final function DrawLine(float fX1, float fY1, float fX2, float fY2, optional float fWidth);

// Export UCanvas::execDrawInterpCurve(FFrame&, void* const)
native final function DrawInterpCurve(SInterpParams interpParams, string szCurveName, float fCurrentValue);

// Export UCanvas::execDrawMaterialTile(FFrame&, void* const)
native final function DrawMaterialTile(MaterialInstance Mat, float XL, float YL, optional float U, optional float V, optional float UL, optional float VL);

// Export UCanvas::execStrLen(FFrame&, void* const)
native(464) final function StrLen(coerce string String, out float XL, out float YL);

// Export UCanvas::execTextSize(FFrame&, void* const)
native(470) final function TextSize(coerce string String, out float XL, out float YL);

// Export UCanvas::execDrawText(FFrame&, void* const)
native(465) final function DrawText(coerce string Text, optional bool CR);

// Export UCanvas::execDrawTextClipped(FFrame&, void* const)
native(469) final function DrawTextClipped(coerce string Text);

// Export UCanvas::execDrawTextInHud(FFrame&, void* const)
native final function DrawTextInHud(coerce string Text, optional bool CR);

// Export UCanvas::execDrawTextClippedInHud(FFrame&, void* const)
native final function DrawTextClippedInHud(coerce string Text);

// Export UCanvas::execProject(FFrame&, void* const)
native final function Vector Project(Vector Location);

event Reset()
{
    Font = default.Font;
    SpaceX = default.SpaceX;
    SpaceY = default.SpaceY;
    OrgX = default.OrgX;
    OrgY = default.OrgY;
    CurX = default.CurX;
    CurY = default.CurY;
    DrawColor = default.DrawColor;
    CurYL = default.CurYL;
    bCenter = false;
    bNoSmooth = false;
    return;
}

// Export UCanvas::execSetPos(FFrame&, void* const)
native final function SetPos(float X, float Y);

// Export UCanvas::execSetOrigin(FFrame&, void* const)
native final function SetOrigin(float X, float Y);

// Export UCanvas::execSetClip(FFrame&, void* const)
native final function SetClip(float X, float Y);

final function DrawIcon(Texture2D Tex, float Scale)
{
    // End:0x6B
    if(Tex != none)
    {
        __NFUN_466__(Tex, float(Tex.SizeX) * Scale, float(Tex.SizeY) * Scale, 0.0000000, 0.0000000, float(Tex.SizeX), float(Tex.SizeY));
    }
    return;
}

final function DrawRect(float RectX, float RectY, optional Texture2D Tex)
{
    DefaultTexture
    __NFUN_466__(Tex, RectX, RectY, 0.0000000, 0.0000000, float(Tex.SizeX), float(Tex.SizeY));
    return;
}

final simulated function DrawBox(Canvas Canvas, float Width, float Height)
{
    local float X, Y;

    X = Canvas.CurX;
    Y = Canvas.CurY;
    Canvas.DrawRect(2.0000000, Height);
    Canvas.DrawRect(Width, 2.0000000);
    Canvas.SetPos(X + Width, Y);
    Canvas.DrawRect(2.0000000, Height);
    Canvas.SetPos(X, Y + Height);
    Canvas.DrawRect(Width + float(1), 2.0000000);
    Canvas.SetPos(X, Y);
    return;
}

// Export UCanvas::execSetDrawColor(FFrame&, void* const)
native final function SetDrawColor(byte R, byte G, byte B, optional byte A);

defaultproperties
{
    Font=Font'EngineFonts.SmallFont'
    DrawColor=(R=127,G=127,B=127,A=255)
    ColorModulate=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)
    DefaultTexture=Texture2D'EngineResources.WhiteSquareTexture'
}