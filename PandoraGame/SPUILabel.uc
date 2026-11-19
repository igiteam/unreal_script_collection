class SPUILabel extends SPFadeObject
    native;

enum EShadowDir
{
    ESD_None,                       // 0
    ESD_UpperLeft,                  // 1
    ESD_UpperMid,                   // 2
    ESD_UpperRight,                 // 3
    ESD_Left,                       // 4
    ESD_Glow,                       // 5
    ESD_Right,                      // 6
    ESD_LowerLeft,                  // 7
    ESD_LowerMid,                   // 8
    ESD_LowerRight,                 // 9
    ESD_MAX                         // 10
};

/** If true, this label will stop and reset and fading when it changes it's caption */
var(Widget) bool bResetFadeWhenChanged;
/** The string to display */
var(Widget) const editinline string Caption;
/** The Font to use */
var(Widget) const editinlineuse Font Font;
/** The color of this text */
var(Widget) const editinline LinearColor FontColor;
var(Widget) const editinline LinearColor normalFontColor;
/** The glowing color of this text */
var(Widget) const editinline LinearColor startGlowColor;
var LinearColor endGlowColor;
var LinearColor diffColor;
var float glowTime;
var float glowDelay;
var Font normalFont;
var(Widget) editinline UIRoot.EUIAlignment Justification;
/** If set, the font will be dawn with a shadow */
var(Widget) SPUILabel.EShadowDir ShadowedType;
/** If the above is set, use this color for the shadow */
var(Widget) LinearColor ShadowColor;
var private const transient float TextBounds[EUIWidgetFace];
var private const transient float FontScaling;
var private const transient int FontPageIndex;
var private const transient int DrawX;
var private const transient int DrawY;
var private const transient int LeftBoundary;
var private const transient int RightBoundary;
var name CaptionPropertyName;
var name JustificationPropertyName;
var name FontPropertyName;

// Export USPUILabel::execSetCaption(FFrame&, void* const)
native function SetCaption(string NewCaption);

// Export USPUILabel::execSetFont(FFrame&, void* const)
native function SetFont(Font NewFont);

// Export USPUILabel::execGetColor(FFrame&, void* const)
native function LinearColor GetColor();

// Export USPUILabel::execSetColor(FFrame&, void* const)
native function SetColor(LinearColor NewColor);

// Export USPUILabel::execSetGlow(FFrame&, void* const)
native function SetGlow(float glowingTime, float glowingDelay);

// Export USPUILabel::execSetGlowFont(FFrame&, void* const)
native function SetGlowFont(Font NewFont);
