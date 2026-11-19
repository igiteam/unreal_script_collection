class TurokUIList extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const MAX_LIST_SLOTS = 20;

struct native TurokUIListItem
{
    var string string_data;
    var int string_hash;
    var @NULL img_data;
    var int Id;
    var bool is_label_visible;
    var bool is_image_visible;
    var bool is_inactive;

    structdefaultproperties
    {
        string_data=""
        string_hash=0
        img_data=none
        Id=0
        is_label_visible=true
        is_image_visible=true
        is_inactive=false
    }
};

var() bool ShowArrows;
var() bool bFillsFromBottomToTop;
var() bool bScrollWrapped;
var private bool bJustWrapped;
var() bool bUseImages;
var() bool bUseLabels;
var() bool mbAlignImageWithLabelSide;
var() bool bUseDynamicSpacing;
var() bool bHighlightImages;
var() bool bNoShadowOnHighlight;
var bool bHighlightNoLoop;
var() bool bHasHighlightImage;
var() bool bScaleHighlightImage;
var() bool bHasBlurEffect;
var(Anims) bool bHasHighlight;
var() bool ScrollHorizontal;
var @NULL UpArrow;
var @NULL DownArrow;
var private @NULL Images[20];
var protected @NULL Slots[20];
var private int SelectedSlotIndex;
var() private float HorizontalOffset[20];
var array Data;
var private int SelectedDataIndex;
var() int NumSlots;
var private int PrevNumSlots;
var() float fSpacing;
var() byte ImageAlignment;
var() float fImageSpacing;
var() float fImageSpacingY;
var private @NULL mHighlightImage;
var() private int mHighlightImageHeight;
var(Anims) @NULL HighlightOffset;
var(Anims) @NULL HighlightColor;
var(Anims) @NULL UnHighlightColor;
var(Anims) @NULL cImageHighlightColor;
var(Anims) @NULL cImageUnHighlightColor;
var(Anims) @NULL InactiveColor;
var(Anims) @NULL UnHighlightInactiveColor;
var(Anims) @NULL ImageInactiveColor;
var(Anims) @NULL UnHighlightImageInactiveColor;
var(Anims) float fAnimTime;
var(Anims) private float fFadeDelay;
var(Anims) float fHighlightScale;
var(Anims) float fUnHighlightScale;

// Export UTurokUIList::execSetNumData(FFrame&, void* const)
native function SetNumData(int Num);

// Export UTurokUIList::execGetNumData(FFrame&, void* const)
native final function int GetNumData();

// Export UTurokUIList::execGetNumUsedSlots(FFrame&, void* const)
native final function int GetNumUsedSlots();

// Export UTurokUIList::execGetMinSlotIndex(FFrame&, void* const)
native final function int GetMinSlotIndex();

// Export UTurokUIList::execGetSelectedDataIndex(FFrame&, void* const)
native final function int GetSelectedDataIndex();

// Export UTurokUIList::execGetSelectedDataID(FFrame&, void* const)
native final function int GetSelectedDataID();

// Export UTurokUIList::execGetSelectedData(FFrame&, void* const)
native final function @NULL GetSelectedData();

// Export UTurokUIList::execPositionData(FFrame&, void* const)
native function PositionData();

// Export UTurokUIList::execFindDataStrHash(FFrame&, void* const)
private native final event int FindDataStrHash(int string_hash);

// Export UTurokUIList::execFindDataString(FFrame&, void* const)
private native final event int FindDataString(string the_string);

// Export UTurokUIList::execAddDataStrHash(FFrame&, void* const)
native final function AddDataStrHash(int string_hash, int Id);

// Export UTurokUIList::execRemoveDataByIndex(FFrame&, void* const)
native final function RemoveDataByIndex(int Index);

// Export UTurokUIList::execRemoveDataStrHash(FFrame&, void* const)
native final function RemoveDataStrHash(int str_hash);

// Export UTurokUIList::execRemoveDataString(FFrame&, void* const)
native final function RemoveDataString(string the_string);

// Export UTurokUIList::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIList::execSetSelection(FFrame&, void* const)
native function SetSelection(int Index);

// Export UTurokUIList::execGetSelectedSlotIndex(FFrame&, void* const)
native function int GetSelectedSlotIndex();

// Export UTurokUIList::execSetImageDataVisibility(FFrame&, void* const)
native function SetImageDataVisibility(int data_index, bool visible);

// Export UTurokUIList::execSetLabelDataVisibility(FFrame&, void* const)
native function SetLabelDataVisibility(int data_index, bool visible);

// Export UTurokUIList::execSetImageSlotVisibility(FFrame&, void* const)
native function SetImageSlotVisibility(int slot_index, bool visible);

// Export UTurokUIList::execSetLabelSlotVisibility(FFrame&, void* const)
native function SetLabelSlotVisibility(int slot_index, bool visible);

// Export UTurokUIList::execGetSlotLabel(FFrame&, void* const)
native function @NULL GetSlotLabel(int Index);

// Export UTurokUIList::execGetSlotImage(FFrame&, void* const)
native function @NULL GetSlotImage(int Index);

// Export UTurokUIList::execGetDataIndex(FFrame&, void* const)
native function int GetDataIndex(int Id);

// Export UTurokUIList::execClearData(FFrame&, void* const)
native function ClearData();

// Export UTurokUIList::execSetDataActive(FFrame&, void* const)
native function SetDataActive(int Index);

// Export UTurokUIList::execSetDataInactive(FFrame&, void* const)
native function SetDataInactive(int Index);

// Export UTurokUIList::execIsSelectedDataActive(FFrame&, void* const)
native function bool IsSelectedDataActive();

// Export UTurokUIList::execEditor_SetSpacing(FFrame&, void* const)
native function Editor_SetSpacing(float fRowSpacing);

// Export UTurokUIList::execFocus(FFrame&, void* const)
native function Focus();

// Export UTurokUIList::execUnFocus(FFrame&, void* const)
native function UnFocus();

event AddDataString(string the_string, int Id)
{
    Data.Insert(Data.Length, 1);
    Data[Data.Length - 1].string_data = the_string;
    Data[Data.Length - 1].Id = Id;
    Data[Data.Length - 1].is_label_visible = true;
    //return;    
}

event AddDataImage(@NULL the_tex, int Id)
{
    Data.Insert(Data.Length, 1);
    Data[Data.Length - 1].img_data = the_tex;
    Data[Data.Length - 1].Id = Id;
    Data[Data.Length - 1].is_image_visible = true;
    //return;    
}

event SetDataString(int Index, string the_string, int Id)
{
    // DebugMode: 0
    assert(((bUseLabels == true) && Index >= 0) && Index < Data.Length);
    Data[Index].string_data = the_string;
    Data[Index].Id = Id;
    Data[Index].is_label_visible = true;
    //return;    
}

// Export UTurokUIList::execSetDataImage(FFrame&, void* const)
native function SetDataImage(int Index, @NULL the_tex, int Id);

event Editor_SetNumSlots(int Num)
{
    NumSlots = Clamp(Num, 0, 20);
    Editor_UpdateNumSlots();
    //return;    
}

// Export UTurokUIList::execScroll(FFrame&, void* const)
native function bool Scroll(int Dir);

// Export UTurokUIList::execScrollData(FFrame&, void* const)
native function bool ScrollData(int Dir);

// Export UTurokUIList::execScrollHighlight(FFrame&, void* const)
native function bool ScrollHighlight(int Dir);

// Export UTurokUIList::execUnHighlight(FFrame&, void* const)
native function UnHighlight(int Index);

// Export UTurokUIList::execHighlight(FFrame&, void* const)
native function Highlight(int Index);

function StartFadeIn()
{
    FadeInComplete();
    //return;    
}

function FadeInComplete()
{
    // End:0x18
    if(bHasHighlight)
    {
        Highlight(SelectedSlotIndex);
    }
    //return;    
}

function StartFadeOut()
{
    //return;    
}

// Export UTurokUIList::execEditor_UpdateHasHighlightImage(FFrame&, void* const)
native function Editor_UpdateHasHighlightImage();

event PostSetupInitialize(optional int Index = 0)
{
    local int I;
    local @NULL script, fade_out, unhigh_color;

    // End:0x4D
    if(ShowArrows)
    {
        UpArrow = UIImage(FindChild(name("UpArrow"), true));
        DownArrow = UIImage(FindChild(name("DownArrow"), true));        
    }
    else
    {
        UpArrow = none;
        DownArrow = none;
    }
    // End:0x280
    if(UpArrow != none)
    {
        Class'TurokUI'.static.InitScriptCtrl(UpArrow);
        script = Class'TurokUI'.static.AddScript(UpArrow, "blink");
        // End:0x171
        if(script != none)
        {
            fade_out.R = 128;
            fade_out.G = 128;
            fade_out.B = 128;
            fade_out.A = byte(255);
            script.AddColorKey(0.0000000, fade_out);
            fade_out.R = byte(255);
            fade_out.G = byte(255);
            fade_out.B = byte(255);
            script.AddColorKey(0.1666700, fade_out);
        }
        script = Class'TurokUI'.static.AddScript(UpArrow, "dim");
        // End:0x1F4
        if(script != none)
        {
            fade_out.R = 128;
            fade_out.G = 128;
            fade_out.B = 128;
            script.AddColorKey(0.0000000, fade_out);
        }
        script = Class'TurokUI'.static.AddScript(UpArrow, "normal");
        // End:0x280
        if(script != none)
        {
            fade_out.R = byte(255);
            fade_out.G = byte(255);
            fade_out.B = byte(255);
            script.AddColorKey(0.0000000, fade_out);
        }
    }
    // End:0x4A5
    if(DownArrow != none)
    {
        Class'TurokUI'.static.InitScriptCtrl(DownArrow);
        script = Class'TurokUI'.static.AddScript(DownArrow, "blink");
        // End:0x396
        if(script != none)
        {
            fade_out.R = 128;
            fade_out.G = 128;
            fade_out.B = 128;
            fade_out.A = byte(255);
            script.AddColorKey(0.0000000, fade_out);
            fade_out.R = byte(255);
            fade_out.G = byte(255);
            fade_out.B = byte(255);
            script.AddColorKey(0.1666700, fade_out);
        }
        script = Class'TurokUI'.static.AddScript(DownArrow, "dim");
        // End:0x419
        if(script != none)
        {
            fade_out.R = 128;
            fade_out.G = 128;
            fade_out.B = 128;
            script.AddColorKey(0.0000000, fade_out);
        }
        script = Class'TurokUI'.static.AddScript(DownArrow, "normal");
        // End:0x4A5
        if(script != none)
        {
            fade_out.R = byte(255);
            fade_out.G = byte(255);
            fade_out.B = byte(255);
            script.AddColorKey(0.0000000, fade_out);
        }
    }
    I = 0;
    J0x4AC:

    // End:0x8AE [Loop If]
    if(I < NumSlots)
    {
        // End:0x555
        if(bUseLabels)
        {
            Slots[I].bHasBlurEffect = bHasBlurEffect;
            Slots[I].PostSetupInitialize(fAnimTime, fHighlightScale, fUnHighlightScale, HighlightColor, UnHighlightColor, UnHighlightInactiveColor, InactiveColor);
            // End:0x555
            if(bHasHighlightImage)
            {
                // End:0x546
                if(I == SelectedSlotIndex)
                {
                    Highlight(I);                    
                }
                else
                {
                    UnHighlight(I);
                }
            }
        }
        // End:0x8A4
        if(bUseImages)
        {
            Class'TurokUI'.static.InitScriptCtrl(Images[I]);
            // End:0x8A4
            if(Images[I].GetScriptCtrl() != none)
            {
                // End:0x604
                if(!bHighlightImages)
                {
                    unhigh_color.R = byte(255);
                    unhigh_color.G = byte(255);
                    unhigh_color.B = byte(255);
                    unhigh_color.A = byte(255);
                    fade_out = unhigh_color;                    
                }
                else
                {
                    fade_out = cImageUnHighlightColor;
                    unhigh_color = cImageUnHighlightColor;
                }
                fade_out.A = 0;
                // End:0x84C
                if(bHasHighlight && bHighlightImages)
                {
                    script = Class'TurokUI'.static.AddScript(Images[I], "highlight", true);
                    // End:0x6B7
                    if(script != none)
                    {
                        script.AddColorKey(0.0000000, cImageUnHighlightColor);
                        script.AddColorKey(fAnimTime, cImageHighlightColor);
                    }
                    script = Class'TurokUI'.static.AddScript(Images[I], "unhighlight", true);
                    // End:0x730
                    if(script != none)
                    {
                        script.AddColorKey(0.0000000, cImageHighlightColor);
                        script.AddColorKey(fAnimTime, cImageUnHighlightColor);
                    }
                    script = Class'TurokUI'.static.AddScript(Images[I], "highlight_inactive", true);
                    // End:0x7B0
                    if(script != none)
                    {
                        script.AddColorKey(0.0000000, UnHighlightImageInactiveColor);
                        script.AddColorKey(fAnimTime, ImageInactiveColor);
                    }
                    script = Class'TurokUI'.static.AddScript(Images[I], "unhighlight_inactive", true);
                    // End:0x832
                    if(script != none)
                    {
                        script.AddColorKey(0.0000000, ImageInactiveColor);
                        script.AddColorKey(fAnimTime, UnHighlightImageInactiveColor);
                    }
                    Images[I].OverrideColor = cImageUnHighlightColor;
                }
                script = Class'TurokUI'.static.AddScript(Images[I], "inactive", true);
                // End:0x8A4
                if(script != none)
                {
                    script.AddColorKey(0.0000000, ImageInactiveColor);
                }
            }
        }
        I++;
        // [Loop Continue]
        goto J0x4AC;
    }
    // End:0x8C9
    if(Data.Length > 0)
    {
        SetSelection(Index);
    }
    PositionData();
    // End:0x8F0
    if(bHasHighlightImage)
    {
        PositionHighlightImage(fHighlightScale, fHighlightScale);
    }
    // End:0x9B5
    if(ShowArrows)
    {
        // End:0x944
        if(Data.Length <= NumSlots)
        {
            // End:0x925
            if(UpArrow != none)
            {
                UpArrow.bHidden = true;
            }
            // End:0x941
            if(DownArrow != none)
            {
                DownArrow.bHidden = true;
            }            
        }
        else
        {
            // End:0x97A
            if(Index == 0)
            {
                // End:0x977
                if(UpArrow != none)
                {
                    Class'TurokUI'.static.PlayScript(UpArrow, "dim");
                }                
            }
            else
            {
                // End:0x9B5
                if(Index == (Data.Length - 1))
                {
                    // End:0x9B5
                    if(DownArrow != none)
                    {
                        Class'TurokUI'.static.PlayScript(DownArrow, "dim");
                    }
                }
            }
        }
    }
    //return;    
}

event Deinitialize()
{
    local int I;

    // End:0x31
    if((UpArrow != none) && UpArrow.ScriptCtrl != none)
    {
        UpArrow.ScriptCtrl = none;
    }
    // End:0x62
    if((DownArrow != none) && DownArrow.ScriptCtrl != none)
    {
        DownArrow.ScriptCtrl = none;
    }
    I = 0;
    J0x69:

    // End:0xE7 [Loop If]
    if(I < NumSlots)
    {
        // End:0x9A
        if(bUseLabels)
        {
            Slots[I].Deinitialize();
        }
        // End:0xDD
        if((Images[I] != none) && Images[I].ScriptCtrl != none)
        {
            Images[I].ScriptCtrl = none;
        }
        I++;
        // [Loop Continue]
        goto J0x69;
    }
    //return;    
}

function Editor_RemoveChildren()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(I < NumSlots)
    {
        RemoveChild(Slots[I]);
        Slots[I] = none;
        RemoveChild(Images[I]);
        Images[I] = none;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UTurokUIList::execPositionHighlightImage(FFrame&, void* const)
native function PositionHighlightImage(float beforeScale, float afterScale);

// Export UTurokUIList::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

event Editor_UpdateNumSlots()
{
    local int I;
    local @NULL Slot, img;

    NumSlots = Clamp(NumSlots, 0, 20);
    // End:0x2FF
    if(NumSlots > PrevNumSlots)
    {
        // End:0x19D
        if(bUseLabels)
        {
            I = PrevNumSlots;
            J0x33:

            // End:0x19D [Loop If]
            if(I < NumSlots)
            {
                Slot = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIListSlot', name((string(WidgetTag) $ "_Slot") $ string(I)), GetScene(), self);
                // End:0x193
                if(Slot != none)
                {
                    Slot.SetDataStoreBinding("Slot_" $ string(I));
                    Slot.Position.ScaleType[0] = 3;
                    Slot.Position.ScaleType[1] = 3;
                    Slot.Position.ScaleType[2] = 3;
                    Slot.Position.ScaleType[3] = 3;
                    Class'TurokUI'.static.SetSize(Slot, 200.0000000, 25.0000000);
                    Class'TurokUI'.static.SetPosition(Slot, 0.0000000, 25.0000000 * float(I));
                    Slot.mbOverrideFontDefaults = true;
                    Slots[I] = Slot;
                }
                I++;
                // [Loop Continue]
                goto J0x33;
            }
        }
        // End:0x2FC
        if(bUseImages)
        {
            I = PrevNumSlots;
            J0x1B1:

            // End:0x2FC [Loop If]
            if(I < NumSlots)
            {
                img = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name((string(WidgetTag) $ "_Image") $ string(I)), GetScene(), self);
                // End:0x2F2
                if(img != none)
                {
                    img.Position.ScaleType[0] = 3;
                    img.Position.ScaleType[1] = 3;
                    img.Position.ScaleType[2] = 3;
                    img.Position.ScaleType[3] = 3;
                    Class'TurokUI'.static.SetSize(img, 20.0000000, 25.0000000);
                    Class'TurokUI'.static.SetPosition(img, 0.0000000, 25.0000000 * float(I));
                    img.bUseOverrides = true;
                    Images[I] = img;
                }
                I++;
                // [Loop Continue]
                goto J0x1B1;
            }
        }        
    }
    else
    {
        // End:0x3A4
        if(NumSlots < PrevNumSlots)
        {
            // End:0x359
            if(bUseLabels)
            {
                I = PrevNumSlots;
                J0x322:

                // End:0x359 [Loop If]
                if(I >= NumSlots)
                {
                    RemoveChild(Slots[I]);
                    Slots[I] = none;
                    I--;
                    // [Loop Continue]
                    goto J0x322;
                }
            }
            // End:0x3A4
            if(bUseImages)
            {
                I = PrevNumSlots;
                J0x36D:

                // End:0x3A4 [Loop If]
                if(I >= NumSlots)
                {
                    RemoveChild(Images[I]);
                    Images[I] = none;
                    I--;
                    // [Loop Continue]
                    goto J0x36D;
                }
            }
        }
    }
    PrevNumSlots = NumSlots;
    //return;    
}

event Editor_UpdateUseLabels()
{
    local int I;
    local @NULL Slot;

    // End:0x107
    if(bUseLabels)
    {
        I = 0;
        J0x10:

        // End:0x104 [Loop If]
        if(I < NumSlots)
        {
            Slot = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIListSlot', name((string(WidgetTag) $ "_Slot") $ string(I)), GetScene(), self);
            // End:0xFA
            if(Slot != none)
            {
                Slot.SetDataStoreBinding("Slot_" $ string(I));
                Class'TurokUI'.static.SetSize(Slot, 200.0000000, 25.0000000);
                Class'TurokUI'.static.SetPosition(Slot, 0.0000000, 25.0000000 * float(I));
                Slot.mbOverrideFontDefaults = true;
                Slots[I] = Slot;
            }
            I++;
            // [Loop Continue]
            goto J0x10;
        }        
    }
    else
    {
        I = 0;
        J0x10E:

        // End:0x156 [Loop If]
        if(I < NumSlots)
        {
            // End:0x14C
            if(Slots[I] != none)
            {
                RemoveChild(Slots[I]);
                Slots[I] = none;
            }
            I++;
            // [Loop Continue]
            goto J0x10E;
        }
    }
    //return;    
}

event Editor_UpdateUseImages()
{
    local int I;
    local @NULL img;

    // End:0x15E
    if(bUseImages)
    {
        I = 0;
        J0x10:

        // End:0x15B [Loop If]
        if(I < NumSlots)
        {
            img = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name((string(WidgetTag) $ "_Image") $ string(I)), GetScene(), self);
            // End:0x151
            if(img != none)
            {
                img.Position.ScaleType[0] = 3;
                img.Position.ScaleType[1] = 3;
                img.Position.ScaleType[2] = 3;
                img.Position.ScaleType[3] = 3;
                Class'TurokUI'.static.SetSize(img, 20.0000000, 25.0000000);
                Class'TurokUI'.static.SetPosition(img, 0.0000000, 25.0000000 * float(I));
                img.bUseOverrides = true;
                Images[I] = img;
            }
            I++;
            // [Loop Continue]
            goto J0x10;
        }        
    }
    else
    {
        I = 0;
        J0x165:

        // End:0x1AD [Loop If]
        if(I < NumSlots)
        {
            // End:0x1A3
            if(Images[I] != none)
            {
                RemoveChild(Images[I]);
                Images[I] = none;
            }
            I++;
            // [Loop Continue]
            goto J0x165;
        }
    }
    //return;    
}

defaultproperties
{
    bUseLabels=true
    bUseDynamicSpacing=true
    bScaleHighlightImage=true
    ImageAlignment=1
    mHighlightImageHeight=6
    HighlightColor=(R=255,G=255,B=255,A=255)
    UnHighlightColor=(R=100,G=100,B=100,A=255)
    cImageHighlightColor=(R=255,G=255,B=255,A=255)
    cImageUnHighlightColor=(R=100,G=100,B=100,A=255)
    InactiveColor=(R=100,G=100,B=100,A=255)
    UnHighlightInactiveColor=(R=100,G=100,B=100,A=255)
    ImageInactiveColor=(R=100,G=100,B=100,A=255)
    UnHighlightImageInactiveColor=(R=100,G=100,B=100,A=255)
    fAnimTime=0.1250000
    fFadeDelay=0.0625000
    fHighlightScale=1.0000000
    fUnHighlightScale=1.0000000
    Position=(Value[2]=200.0000000,Value[3]=25.0000000)
    // Reference: UIComp_Event'Default__TurokUIList.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}