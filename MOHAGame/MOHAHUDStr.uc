class MOHAHUDStr extends MOHAHUDObj
    native;

var string Text;
var Color strColor;
var Font strFont;
var bool bRenderBox;
var bool bDirty;
var float boundsMinX;
var float boundsMinY;
var float boundsMaxX;
var float boundsMaxY;

// Export UMOHAHUDStr::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDStr::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDStr::execUpdateStr(FFrame&, void* const)
native function UpdateStr(Canvas Canvas, string new_text);

// Export UMOHAHUDStr::execGetSize(FFrame&, void* const)
native function GetSize(Canvas Canvas, out int xSizePix, out int ySizePix, optional bool bSetSize);

// Export UMOHAHUDStr::execAdjustStringPos(FFrame&, void* const)
native function AdjustStringPos(Canvas Canvas);

// Export UMOHAHUDStr::execUpdateSize(FFrame&, void* const)
native function UpdateSize(Canvas Canvas);

// Export UMOHAHUDStr::execUpdateFont(FFrame&, void* const)
native function UpdateFont(Font new_strFont);

event RenderBox(Canvas Canvas)
{
    local int posPixX, posPixY, sizeWidth, sizeHeight, xSizePix, ySizePix,
	    MinX, MinY, MaxX, MaxY;

    // End:0x0E
    if(bRenderBox == false)
    {
        return;
    }
    GetSize(Canvas, xSizePix, ySizePix);
    GetTopLeft(posPixX, posPixY);
    Canvas.Font = strFont;
    Canvas.SetDrawColor(strColor.R, strColor.G, strColor.B, currentColor.A);
    Canvas.SetPos(float(posPixX), float(posPixY));
    Canvas.DrawBox(float(xSizePix), float(ySizePix));
    // End:0x239
    if(true)
    {
        Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        Canvas.SetPos(float(posPixX + xSizePix), float(posPixY));
        sizeWidth = xSizePix;
        sizeHeight = ySizePix;
        MinX = int(boundsMinX * Canvas.ClipX);
        MinY = int(boundsMinY * Canvas.ClipY);
        MaxX = int(boundsMaxX * Canvas.ClipX);
        MaxY = int(boundsMaxY * Canvas.ClipY);
        Canvas.__NFUN_465__((((((((((((((((" [" $ string(PosX)) $ ", ") $ string(PosY)) $ "] (") $ string(sizeWidth)) $ ", ") $ string(sizeHeight)) $ ") { L=") $ string(MinX)) $ ", T=") $ string(MinY)) $ ", R=") $ string(MaxX)) $ ", B=") $ string(MaxY)) @ "}");
    }
    //return;    
}

event UpdateFontColor(Color new_strColor)
{
    strColor = new_strColor;
    fMaxAlpha = float(strColor.A) / 255.0000000;
    //return;    
}

event SetBounds(float Left, float Right, float Top, float Bottom)
{
    boundsMinX = Left;
    boundsMinY = Top;
    boundsMaxX = Right;
    boundsMaxY = Bottom;
    bDirty = true;
    //return;    
}

defaultproperties
{
    strColor=(R=255,G=255,B=255,A=255)
    strFont=Font'HUD.Futura_med_bold'
}