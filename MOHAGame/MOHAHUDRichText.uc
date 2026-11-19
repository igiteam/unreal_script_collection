class MOHAHUDRichText extends MOHAHUDObj
    native;

struct native IconInfo
{
    var string IconString;
    var Texture2D IconImage;
    var Vector2D IconUVPos;
    var Vector2D IconUVSize;
    var Vector2D IconPixelSize;

    structdefaultproperties
    {
        IconString=""
        IconImage=none
        IconUVPos=(X=0.0000000,Y=0.0000000)
        IconUVSize=(X=0.0000000,Y=0.0000000)
        IconPixelSize=(X=0.0000000,Y=0.0000000)
    }
};

var string RawText;
var array<IconInfo> MOHAIcons;
var MOHAHUDStr TextString_Start;
var MOHAHUDStr TextString_End;
var MOHAHUDImg IconImage;
var array<MOHAHUDObj> HUDObjects;
var Font DefaultFont;

// Export UMOHAHUDRichText::execUpdateStr(FFrame&, void* const)
native function UpdateStr(Canvas Canvas, string Text);

// Export UMOHAHUDRichText::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDRichText::execEnableElement(FFrame&, void* const)
native function EnableElement(bool new_bRender);

// Export UMOHAHUDRichText::execStartFade(FFrame&, void* const)
native function StartFade(float new_fFadeInTime, float new_fMaxAlpha, float new_fFadeOutTime);

// Export UMOHAHUDRichText::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange(float resolutionScale);

// Export UMOHAHUDRichText::execUpdateFont(FFrame&, void* const)
native function UpdateFont(Font new_strFont);

// Export UMOHAHUDRichText::execSetDirty(FFrame&, void* const)
native function SetDirty(bool bDirty);

// Export UMOHAHUDRichText::execSetAlwaysRender(FFrame&, void* const)
native function SetAlwaysRender(bool bShouldRender);

// Export UMOHAHUDRichText::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

function Setup(float fPosX, float fPosY, Font textFont)
{
    SetPosition(fPosX, fPosY);
    JustifyXCenter();
    JustifyYCenter();
    DefaultFont = textFont;
    TextString_Start = new Class'MOHAHUDStr';
    TextString_Start.MOHAHUD = MOHAHUD;
    TextString_Start.UpdateFont(textFont);
    TextString_Start.Link(self, 1, 0);
    TextString_Start.EnableElement(false);
    IconImage = new Class'MOHAHUDImg';
    IconImage.MOHAHUD = MOHAHUD;
    IconImage.Link(TextString_Start, 2, 0);
    IconImage.JustifyYCenter();
    IconImage.EnableElement(false);
    TextString_End = new Class'MOHAHUDStr';
    TextString_End.MOHAHUD = MOHAHUD;
    TextString_End.UpdateFont(textFont);
    TextString_End.Link(IconImage, 2, 0);
    TextString_End.JustifyYCenter();
    TextString_End.EnableElement(false);
    HUDObjects[0] = TextString_Start;
    HUDObjects[1] = IconImage;
    HUDObjects[2] = TextString_End;
    //return;    
}

defaultproperties
{
    MOHAIcons[0]=(IconString="[$A]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=352.0000000,Y=352.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[1]=(IconString="[$B]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=400.0000000,Y=352.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[2]=(IconString="[$X]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=352.0000000,Y=400.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[3]=(IconString="[$Y]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=400.0000000,Y=400.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[4]=(IconString="[$LS]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=402.0000000,Y=208.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[5]=(IconString="[$RS]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=402.0000000,Y=256.0000000),IconUVSize=(X=48.0000000,Y=48.0000000),IconPixelSize=(X=35.0000000,Y=35.0000000))
    MOHAIcons[6]=(IconString="[$LB]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=256.0000000,Y=80.0000000),IconUVSize=(X=96.0000000,Y=48.0000000),IconPixelSize=(X=70.0000000,Y=35.0000000))
    MOHAIcons[7]=(IconString="[$RB]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=352.0000000,Y=80.0000000),IconUVSize=(X=96.0000000,Y=48.0000000),IconPixelSize=(X=70.0000000,Y=35.0000000))
    MOHAIcons[8]=(IconString="[$INF]",IconImage=Texture2D'HUD.HUDMultiIcons02',IconUVPos=(X=461.0000000,Y=324.0000000),IconUVSize=(X=38.0000000,Y=20.0000000),IconPixelSize=(X=38.0000000,Y=20.0000000))
}