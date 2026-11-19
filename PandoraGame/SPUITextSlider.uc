class SPUITextSlider extends UISlider
    native;

enum ESliderButtonArrow
{
    SLIDERARROW_Left,               // 0
    SLIDERARROW_Right,              // 1
    SLIDERARROW_MAX                 // 2
};

var UIStyleReference LeftArrowStyle;
var UIStyleReference RightArrowStyle;
var class<UIState> LeftArrowState;
var class<UIState> RightArrowState;
/** The resolved image to use for the left arrow. */
var(Image) export editinlineuse UITexture LeftArrowTexture;
/** The resolved image to use for the right arrow. */
var(Image) export editinlineuse UITexture RightArrowTexture;
