class TurokUIHighlightableTable extends TurokUITable
    native
    hidecategories(Object,UIRoot,Object);

var @NULL HighlightImage_Left;
var @NULL HighlightImage_Center;
var @NULL HighlightImage_Right;
var bool bHasFocus;

// Export UTurokUIHighlightableTable::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIHighlightableTable::execScrollHoriz(FFrame&, void* const)
native function bool ScrollHoriz(int Dir);

// Export UTurokUIHighlightableTable::execSetSelection(FFrame&, void* const)
native function SetSelection(int column, int Row);

// Export UTurokUIHighlightableTable::execSetColumnSelection(FFrame&, void* const)
native function SetColumnSelection(int column);

// Export UTurokUIHighlightableTable::execSetRowSelection(FFrame&, void* const)
native function SetRowSelection(int column);

// Export UTurokUIHighlightableTable::execAdjustHighlight(FFrame&, void* const)
native function AdjustHighlight();

// Export UTurokUIHighlightableTable::execFocus(FFrame&, void* const)
native function Focus();

// Export UTurokUIHighlightableTable::execUnFocus(FFrame&, void* const)
native function UnFocus();

// Export UTurokUIHighlightableTable::execSetDataBottomToTop(FFrame&, void* const)
native function SetDataBottomToTop(const int kColumn, const int kRow, string kData, const int kId);

// Export UTurokUIHighlightableTable::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

// Export UTurokUIHighlightableTable::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional int selected_column, optional int selected_row, optional bool bFillFromBottom);

defaultproperties
{
    bHasFocus=true
    bHasRowSelection=true
    // Reference: UIComp_Event'Default__TurokUIHighlightableTable.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}