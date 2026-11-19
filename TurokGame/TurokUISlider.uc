class TurokUISlider extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const TUROK_UI_SLIDER_Y_PIXEL_OFFSET_FROM_TOP = 0;
const TUROK_UI_SLIDER_END_ARROW_INTENSITY = 125;

enum ESliderState
{
    SLIDERSTATE_HasFocus,           // 0
    SLIDERSTATE_NotInFocus,         // 1
    SLIDERSTATE_Disabled,           // 2
    SLIDERSTATE_MAX                 // 3
};

var(Anims) float fAnimTime;
var(Slider) int NotchOffsetIntoBackground;
var(Slider) int SliderBGWidth;
var(Slider) bool bValueAndArrowsFollowPositionImage;
var(Slider) bool mDynamicallyDrawNotches;
var(Slider) @NULL PositionImageMoving;
var(Slider) @NULL PositionImageIdle;
var(Slider) @NULL SliderBackgroundImageActive;
var(Slider) @NULL SliderBackgroundImageInActive;
var(Slider) @NULL SliderNotchImage;
var(Slider) @NULL GradientImage;
var(Slider) @NULL MuteGradientImage;
var @NULL SliderValueLabel;
var @NULL LeftArrow;
var @NULL RightArrow;
var @NULL PositionImage;
var @NULL SliderBackgroundImage;
var @NULL LeftGradient;
var @NULL RightGradient;
var @NULL LeftMuteGradient;
var @NULL RightMuteGradient;
var @NULL RightMuteExtension;
var @NULL NotchContainer;
var(Slider) byte State;
var(Slider) float Value;
var(Slider) float MinVal;
var(Slider) float MaxVal;
var(Slider) int NumNotches;
var(Slider) int CappedAtNotch;
var transient bool Captured;

function Focus()
{
    SetState(0);
    //return;    
}

function UnFocus()
{
    SetState(1);
    //return;    
}

// Export UTurokUISlider::execCreateNotches(FFrame&, void* const)
native function CreateNotches();

// Export UTurokUISlider::execSetNumNotches(FFrame&, void* const)
native function SetNumNotches(int notches);

// Export UTurokUISlider::execSetSliderCapNotch(FFrame&, void* const)
native function SetSliderCapNotch(int Cap);

// Export UTurokUISlider::execSetIdlePosition(FFrame&, void* const)
native function SetIdlePosition();

// Export UTurokUISlider::execSetState(FFrame&, void* const)
native function SetState(byte inState);

// Export UTurokUISlider::execSetValue(FFrame&, void* const)
native function SetValue(float val);

// Export UTurokUISlider::execGetValue(FFrame&, void* const)
native function float GetValue();

// Export UTurokUISlider::execScrollLeft(FFrame&, void* const)
native function bool ScrollLeft();

// Export UTurokUISlider::execScrollRight(FFrame&, void* const)
native function bool ScrollRight();

// Export UTurokUISlider::execRefreshPosition(FFrame&, void* const)
native function RefreshPosition();

// Export UTurokUISlider::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUISlider::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, float AmountDepressed);

event PostSetupInitialize(float min_val, float max_val, float cur_val)
{
    local @NULL startColour, endColour;
    local float totalAnimTime, animInterval, CurrentTime;
    local @NULL script;

    MinVal = min_val;
    MaxVal = max_val;
    SetValue(cur_val);
    totalAnimTime = 0.2500000;
    animInterval = totalAnimTime / float(2);
    startColour.A = byte(255);
    startColour.R = byte(255);
    startColour.G = byte(255);
    startColour.B = byte(255);
    endColour.A = byte(255);
    endColour.R = 50;
    endColour.G = 50;
    endColour.B = 50;
    Class'TurokUI'.static.InitScriptCtrl(LeftArrow);
    Class'TurokUI'.static.InitScriptCtrl(RightArrow);
    script = Class'TurokUI'.static.AddScript(LeftArrow, "Flash");
    // DebugMode: 0
    assert(script != none);
    CurrentTime = 0.0000000;
    J0x148:

    // End:0x1BA [Loop If]
    if(CurrentTime < totalAnimTime)
    {
        script.AddColorKey(CurrentTime, startColour);
        CurrentTime = CurrentTime + animInterval;
        script.AddColorKey(CurrentTime, endColour);
        CurrentTime = CurrentTime + animInterval;
        // [Loop Continue]
        goto J0x148;
    }
    script.AddColorKey(CurrentTime, startColour).SetDelegate(SetIdlePosition);
    script = Class'TurokUI'.static.AddScript(LeftArrow, "FlashToEnd");
    // DebugMode: 0
    assert(script != none);
    CurrentTime = 0.0000000;
    J0x231:

    // End:0x2A3 [Loop If]
    if(CurrentTime < totalAnimTime)
    {
        script.AddColorKey(CurrentTime, startColour);
        CurrentTime = CurrentTime + animInterval;
        script.AddColorKey(CurrentTime, endColour);
        CurrentTime = CurrentTime + animInterval;
        // [Loop Continue]
        goto J0x231;
    }
    startColour.R = 125;
    startColour.B = 125;
    startColour.G = 125;
    script.AddColorKey(CurrentTime, startColour).SetDelegate(SetIdlePosition);
    startColour.R = byte(255);
    startColour.B = byte(255);
    startColour.G = byte(255);
    script = Class'TurokUI'.static.AddScript(LeftArrow, "Reset");
    // DebugMode: 0
    assert(script != none);
    script.AddColorKey(0.2500000, startColour);
    script = Class'TurokUI'.static.AddScript(RightArrow, "Flash");
    // DebugMode: 0
    assert(script != none);
    CurrentTime = 0.0000000;
    J0x3D7:

    // End:0x44F [Loop If]
    if(CurrentTime < totalAnimTime)
    {
        script.AddColorKey(CurrentTime, startColour);
        CurrentTime = CurrentTime + animInterval;
        script.AddColorKey(CurrentTime / float(2), endColour);
        CurrentTime = CurrentTime + animInterval;
        // [Loop Continue]
        goto J0x3D7;
    }
    script.AddColorKey(CurrentTime, startColour).SetDelegate(SetIdlePosition);
    script = Class'TurokUI'.static.AddScript(RightArrow, "FlashToEnd");
    // DebugMode: 0
    assert(script != none);
    CurrentTime = 0.0000000;
    J0x4C6:

    // End:0x53E [Loop If]
    if(CurrentTime < totalAnimTime)
    {
        script.AddColorKey(CurrentTime, startColour);
        CurrentTime = CurrentTime + animInterval;
        script.AddColorKey(CurrentTime / float(2), endColour);
        CurrentTime = CurrentTime + animInterval;
        // [Loop Continue]
        goto J0x4C6;
    }
    startColour.R = 125;
    startColour.B = 125;
    startColour.G = 125;
    script.AddColorKey(CurrentTime, startColour).SetDelegate(SetIdlePosition);
    startColour.R = byte(255);
    startColour.B = byte(255);
    startColour.G = byte(255);
    script = Class'TurokUI'.static.AddScript(RightArrow, "Reset");
    // DebugMode: 0
    assert(script != none);
    script.AddColorKey(0.2500000, startColour);
    // End:0x668
    if(bValueAndArrowsFollowPositionImage)
    {
        SliderValueLabel.SetDataStoreBinding(Class'TurokUI'.static.FloatToString(GetValue(), 1));
    }
    // End:0x67B
    if(mDynamicallyDrawNotches)
    {
        CreateNotches();
    }
    //return;    
}

function Deinitialize()
{
    // End:0x1B
    if(LeftArrow != none)
    {
        LeftArrow.ScriptCtrl = none;
    }
    // End:0x36
    if(RightArrow != none)
    {
        RightArrow.ScriptCtrl = none;
    }
    //return;    
}

defaultproperties
{
    fAnimTime=0.2500000
    SliderBGWidth=-1
    State=1
    NumNotches=10
    CappedAtNotch=-1
    // Reference: UIComp_Event'Default__TurokUISlider.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}