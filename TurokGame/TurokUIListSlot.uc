class TurokUIListSlot extends UILabel
    native
    hidecategories(Object,UIRoot,Object);

enum eTurokUIListScriptType
{
    TUROK_UI_SCRIPT_HIGHLIGHT,      // 0
    TUROK_UI_SCRIPT_UNHIGHLIGHT,    // 1
    TUROK_UI_SCRIPT_NONE,           // 2
    TUROK_UI_SCRIPT_MAX             // 3
};

var float mAnimTime;
var float mHighlightScale;
var float mUnHighlightScale;
var bool bHasBlurEffect;
var @NULL mInitialPosition;

// Export UTurokUIListSlot::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(const float kAnimTime, const float kHighlightScale, const float kUnHighlightScale, const @NULL kHighlightColor, const @NULL kUnHighlightColor, const @NULL kUnHighlightInactiveColor, const @NULL kInactiveColor);

// Export UTurokUIListSlot::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokUIListSlot::execHighlight(FFrame&, void* const)
native function Highlight(optional bool no_loop);

// Export UTurokUIListSlot::execHighlightAndInactive(FFrame&, void* const)
native function HighlightAndInactive();

// Export UTurokUIListSlot::execUnHighlight(FFrame&, void* const)
native function UnHighlight();

// Export UTurokUIListSlot::execUnHighlightAndInactive(FFrame&, void* const)
native function UnHighlightAndInactive();

// Export UTurokUIListSlot::execSetCrisp(FFrame&, void* const)
native function SetCrisp();

// Export UTurokUIListSlot::execSetBlur(FFrame&, void* const)
native function SetBlur();

// Export UTurokUIListSlot::execGetHighlightedPosSize(FFrame&, void* const)
native function GetHighlightedPosSize(out float X, out float Y, out float Width, out float Height);

// Export UTurokUIListSlot::execSetPositionKeys(FFrame&, void* const)
native function SetPositionKeys(string kScriptName, bool bIsHighlighting);

// Export UTurokUIListSlot::execAdjustInitialPosition(FFrame&, void* const)
native function AdjustInitialPosition(float prevOffset, float newOffset);

// Export UTurokUIListSlot::execTick(FFrame&, void* const)
native function Tick();

defaultproperties
{
    // Reference: UIComp_DrawString'Default__TurokUIListSlot.LabelStringRenderer'
    begin object name=LabelStringRenderer
    end object
    StringRenderComponent=LabelStringRenderer
    // Reference: UIComp_Event'Default__TurokUIListSlot.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}