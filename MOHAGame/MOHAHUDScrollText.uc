class MOHAHUDScrollText extends MOHAHUDObj
    native;

var array<MOHAHUDStr> stringList;
var array<bool> displayString;
var int currentString;
var() int maxStrings;
var Font strFont;
var array<Font> fontStack;
var array<Color> colorStack;
var float boundsMinX;
var float boundsMinY;
var float boundsMaxX;
var float boundsMaxY;
var bool bRenderBox;
var bool bNeedAdjustment;

// Export UMOHAHUDScrollText::execUpdateAlpha(FFrame&, void* const)
native function UpdateAlpha();

// Export UMOHAHUDScrollText::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

function DisableFade()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3A [Loop If]
    if(I < stringList.Length)
    {
        stringList[I].DisableFade();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetMaxAlpha(float new_fMaxAlpha)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < stringList.Length)
    {
        stringList[I].SetMaxAlpha(new_fMaxAlpha);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function StartFade(float new_fFadeInTime, float new_fMaxAlphaTime, float new_fFadeOutTime)
{
    stringList[currentString].StartFade(new_fFadeInTime, new_fMaxAlphaTime, new_fFadeOutTime);
    stringList[currentString].UpdateAlpha();
    //return;    
}

function JustifyXHelper(MOHAHUDObj.EJustifyX new_justify)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < stringList.Length)
    {
        stringList[I].JustifyXHelper(new_justify);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    super.JustifyXHelper(new_justify);
    //return;    
}

function JustifyYHelper(MOHAHUDObj.EJustifyY new_justify)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < stringList.Length)
    {
        stringList[I].JustifyYHelper(new_justify);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    super.JustifyYHelper(new_justify);
    //return;    
}

// Export UMOHAHUDScrollText::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDScrollText::execGetSize(FFrame&, void* const)
native function GetSize(Canvas Canvas, out int xMaxSizePix, out int yMaxSizePix, optional bool bSetSize);

// Export UMOHAHUDScrollText::execAdjustTextPos(FFrame&, void* const)
native function AdjustTextPos(Canvas Canvas);

// Export UMOHAHUDScrollText::execAdjustPos(FFrame&, void* const)
native function AdjustPos(Canvas Canvas);

// Export UMOHAHUDScrollText::execUpdateStr(FFrame&, void* const)
native function UpdateStr(Canvas Canvas, string new_text);

// Export UMOHAHUDScrollText::execClear(FFrame&, void* const)
native function Clear();

event RenderBox(Canvas Canvas)
{
    local int posPixLeft, posPixTop, sizeWidth, sizeHeight, xSizePix, ySizePix;

    // End:0x0E
    if(bRenderBox == false)
    {
        return;
    }
    GetSize(Canvas, xSizePix, ySizePix);
    GetTopLeft(posPixLeft, posPixTop);
    sizeWidth = xSizePix;
    sizeHeight = ySizePix;
    // End:0x79
    if((posPixLeft - 10) < 0)
    {
        sizeWidth += (posPixLeft - 10);
        posPixLeft = 10;
    }
    // End:0xA0
    if((posPixTop - 10) < 0)
    {
        sizeHeight += (posPixTop - 10);
        posPixTop = 10;
    }
    Canvas.SetPos(float(posPixLeft), float(posPixTop));
    Canvas.DrawBox(float(sizeWidth), float(sizeHeight));
    Canvas.SetPos(float(posPixLeft + sizeWidth), float(posPixTop));
    sizeWidth = xSizePix;
    sizeHeight = ySizePix;
    Canvas.__NFUN_465__((((((((" [" $ string(PosX)) $ ", ") $ string(PosY)) $ "] (") $ string(sizeWidth)) $ ", ") $ string(sizeHeight)) $ ")");
    //return;    
}

event UpdateFont(Font new_strFont)
{
    strFont = new_strFont;
    //return;    
}

event PushFont(Font new_strFont)
{
    fontStack.Length = fontStack.Length + 1;
    fontStack[fontStack.Length - 1] = strFont;
    UpdateFont(new_strFont);
    //return;    
}

event PopFont()
{
    // End:0x35
    if(fontStack.Length > 0)
    {
        UpdateFont(fontStack[fontStack.Length - 1]);
        fontStack.Length = fontStack.Length - 1;
    }
    //return;    
}

event UpdateFontColor(Color new_strColor)
{
    currentColor = new_strColor;
    //return;    
}

event PushFontColor(Color new_strColor)
{
    colorStack.Length = colorStack.Length + 1;
    colorStack[colorStack.Length - 1] = currentColor;
    UpdateFontColor(new_strColor);
    //return;    
}

event PopFontColor()
{
    // End:0x35
    if(colorStack.Length > 0)
    {
        UpdateFontColor(colorStack[colorStack.Length - 1]);
        colorStack.Length = colorStack.Length - 1;
    }
    //return;    
}

event SetBounds(float Left, float Right, float Top, float Bottom)
{
    local int I;

    boundsMinX = Left;
    boundsMinY = Top;
    boundsMaxX = Right;
    boundsMaxY = Bottom;
    I = 0;
    J0x33:

    // End:0x7A [Loop If]
    if(I < stringList.Length)
    {
        stringList[I].SetBounds(Left, Right, Top, Bottom);
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    //return;    
}

defaultproperties
{
    currentString=9
    maxStrings=10
    strFont=Font'HUD.Futura_med_bold'
}