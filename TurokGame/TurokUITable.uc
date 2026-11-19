class TurokUITable extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const MAX_NUM_COLUMNS = 15;

var int PrevNumRows;
var() int NumRows;
var int PrevNumColumns;
var() int NumColumns;
var() bool bHasHeadings;
var() bool bHasRowSelection;
var() bool bHasColumnSelection;
var() bool bHasBGImages;
var @NULL Columns[15];
var int SelectedIndex;
var(Layout) float fRowSpacing;
var(Layout) float fColumnSpacing;
var(Layout) float fColumnWidth;
var(Layout) float fTableHeight;
var(Layout) float fDataOffsetX;
var(Layout) float fDataOffsetY;
var int TickCount;

// Export UTurokUITable::execSetRowVisibility(FFrame&, void* const)
native function SetRowVisibility(int Row, bool bVisible);

// Export UTurokUITable::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUITable::execScrollHoriz(FFrame&, void* const)
native function bool ScrollHoriz(int Dir);

// Export UTurokUITable::execSetSelection(FFrame&, void* const)
native function SetSelection(int column, int Row);

// Export UTurokUITable::execSetColumnSelection(FFrame&, void* const)
native function SetColumnSelection(int column);

// Export UTurokUITable::execSetRowSelection(FFrame&, void* const)
native function SetRowSelection(int column);

// Export UTurokUITable::execSetNumDataRows(FFrame&, void* const)
native function SetNumDataRows(int Num);

// Export UTurokUITable::execGetNumDataRows(FFrame&, void* const)
native function int GetNumDataRows();

// Export UTurokUITable::execGetNumColumns(FFrame&, void* const)
native function int GetNumColumns();

// Export UTurokUITable::execGetNumRows(FFrame&, void* const)
native function int GetNumRows();

// Export UTurokUITable::execStartFadeIn(FFrame&, void* const)
native function StartFadeIn();

// Export UTurokUITable::execGetSelectedColumn(FFrame&, void* const)
native function @NULL GetSelectedColumn();

// Export UTurokUITable::execGetSelectedColumnIndex(FFrame&, void* const)
native function int GetSelectedColumnIndex();

// Export UTurokUITable::execGetSelectedRowIndex(FFrame&, void* const)
native function int GetSelectedRowIndex();

// Export UTurokUITable::execSetImageDataVisibility(FFrame&, void* const)
native function SetImageDataVisibility(int column, int data_index, bool visible);

// Export UTurokUITable::execSetLabelDataVisibility(FFrame&, void* const)
native function SetLabelDataVisibility(int column, int data_index, bool visible);

// Export UTurokUITable::execSetImageSlotVisibility(FFrame&, void* const)
native function SetImageSlotVisibility(int column, int slot_index, bool visible);

// Export UTurokUITable::execSetLabelSlotVisibility(FFrame&, void* const)
native function SetLabelSlotVisibility(int column, int slot_index, bool visible);

// Export UTurokUITable::execSetRowActive(FFrame&, void* const)
native function SetRowActive(int data_index);

// Export UTurokUITable::execSetRowInactive(FFrame&, void* const)
native function SetRowInactive(int data_index);

// Export UTurokUITable::execIsSelectedRowActive(FFrame&, void* const)
native function bool IsSelectedRowActive();

// Export UTurokUITable::execClearData(FFrame&, void* const)
native function ClearData();

// Export UTurokUITable::execFocus(FFrame&, void* const)
native function Focus();

// Export UTurokUITable::execUnFocus(FFrame&, void* const)
native function UnFocus();

// Export UTurokUITable::execRefreshColumnsHeadingText(FFrame&, void* const)
native function RefreshColumnsHeadingText();

// Export UTurokUITable::execSetData(FFrame&, void* const)
native function SetData(const int kColumn, const int kRow, string kData, const int kId);

// Export UTurokUITable::execSetDataImage(FFrame&, void* const)
native function SetDataImage(const int column, const int Row, @NULL Data, const int Id);

function int GetDataIndexById(int column, int data_id)
{
    local int Index;

    Index = -1;
    // End:0x48
    if((column >= 0) && column < (NumColumns - 1))
    {
        Columns[column].GetDataIndex(data_id);
    }
    return Index;
    //return ReturnValue;    
}

function bool AddData(int column, string Data, int Id)
{
    // End:0x41
    if((column >= 0) && column < NumColumns)
    {
        Columns[column].AddDataString(Data, Id);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool AddDataImage(int column, @NULL Data, int Id)
{
    // End:0x41
    if((column >= 0) && column < NumColumns)
    {
        Columns[column].AddDataImage(Data, Id);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function PositionColumns()
{
    local int I;
    local float pos;

    pos = 0.0000000;
    I = 0;
    J0x12:

    // End:0x80 [Loop If]
    if(I < NumColumns)
    {
        Class'TurokUI'.static.SetPosition(Columns[I], pos, 0.0000000);
        pos += (Class'TurokUI'.static.GetWidth(Columns[I]) + fColumnSpacing);
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    //return;    
}

function StartFadeOut()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < NumColumns)
    {
        Columns[I].StartFadeOut();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UTurokUITable::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

// Export UTurokUITable::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional int selected_column, optional int selected_row, optional bool bFillFromBottom);

event Refresh()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < NumColumns)
    {
        Columns[I].PositionData();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UTurokUITable::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

event Editor_UpdateNumRows()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < NumColumns)
    {
        Columns[I].Editor_SetNumSlots(NumRows);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateNumColumns()
{
    local int I;
    local @NULL Item;

    NumColumns = Clamp(NumColumns, 0, 15);
    // End:0x10E
    if(NumColumns > PrevNumColumns)
    {
        I = PrevNumColumns;
        J0x2A:

        // End:0x101 [Loop If]
        if(I < NumColumns)
        {
            Item = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIColumn', name((string(WidgetTag) $ "_Column") $ string(I)), GetScene(), self);
            // End:0xF7
            if(Item != none)
            {
                Item.bHasHighlight = bHasRowSelection;
                Item.Editor_SetHasBGImage(bHasBGImages);
                Item.Editor_SetHasHeading(bHasHeadings);
                Item.Editor_SetNumSlots(NumRows);
                Columns[I] = Item;
            }
            I++;
            // [Loop Continue]
            goto J0x2A;
        }
        PositionColumns();        
    }
    else
    {
        // End:0x178
        if(NumColumns < PrevNumColumns)
        {
            I = PrevNumColumns;
            J0x128:

            // End:0x178 [Loop If]
            if(I >= NumColumns)
            {
                Columns[I].Editor_RemoveChildren();
                RemoveChild(Columns[I]);
                Columns[I] = none;
                I--;
                // [Loop Continue]
                goto J0x128;
            }
        }
    }
    PrevNumColumns = NumColumns;
    //return;    
}

event Editor_UpdateHasHeading()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < NumColumns)
    {
        Columns[I].Editor_SetHasHeading(bHasHeadings);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateHasSelection()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(I < NumColumns)
    {
        Columns[I].bHasHighlight = bHasRowSelection;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateHasBGImages()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < NumColumns)
    {
        Columns[I].Editor_SetHasBGImage(bHasBGImages);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateColumnSpacing()
{
    PositionColumns();
    //return;    
}

defaultproperties
{
    Position=(Value[2]=200.0000000,Value[3]=300.0000000)
    // Reference: UIComp_Event'Default__TurokUITable.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}