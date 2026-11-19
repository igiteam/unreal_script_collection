class SPProgressBar extends UIProgressBar
    native;

var bool bValueChanged;
var(Image) bool bDrawOverlayOnly;
var float NewValue;
var(Image) float overlayLeft;
var(Image) float overlayWidth;

// Export USPProgressBar::execSetFillBarColor(FFrame&, void* const)
native function SetFillBarColor(LinearColor NewColor);

// Export USPProgressBar::execSetOverlayColor(FFrame&, void* const)
native function SetOverlayColor(LinearColor NewColor);

function SetOverlay(float Left, float Width)
{
    local float ProgressBarSize;

    ProgressBarSize = ProgressBarValue.MaxValue - ProgressBarValue.MinValue;
    // End:0x63
    if((ProgressBarSize > float(0)) && Left >= ProgressBarValue.MinValue)
    {
        overlayLeft = Left / ProgressBarSize;
    }
    // End:0x91
    if((Width >= float(0)) && ProgressBarSize > float(0))
    {
        overlayWidth = Width / ProgressBarSize;
    }
    //return;    
}
