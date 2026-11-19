class TurokUITextPairList extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const MAX_LIST_ITEMS = 20;

var protected @NULL HighlightImage;
var @NULL Items[20];
var protected int SelectedItemIndex;
var() protected float HorizontalOffset[20];
var() protected int NumItems;
var protected int NumVisibleItems;
var protected int PrevNumItems;
var() protected float fSpacing;
var() protected bool bScrollWrapped;
var() protected bool bHasHighlightImage;
var() protected bool bHasBlurEffect;
var(Anims) @NULL HighlightColor_Title;
var(Anims) @NULL UnHighlightColor_Title;
var(Anims) @NULL HighlightColor_Data;
var(Anims) @NULL UnHighlightColor_Data;
var(Anims) float fAnimTime;
var(Anims) protected float fFadeDelay;

// Export UTurokUITextPairList::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUITextPairList::execSetSelection(FFrame&, void* const)
native function SetSelection(int Index);

// Export UTurokUITextPairList::execSetTitleString(FFrame&, void* const)
native function SetTitleString(int Index, string the_string);

// Export UTurokUITextPairList::execSetTitleHash(FFrame&, void* const)
native function SetTitleHash(int Index, int hash_str);

// Export UTurokUITextPairList::execSetDataString(FFrame&, void* const)
native function SetDataString(int Index, string the_string);

// Export UTurokUITextPairList::execSetDataHash(FFrame&, void* const)
native function SetDataHash(int Index, int hash_str);

// Export UTurokUITextPairList::execSetDescriptionHash(FFrame&, void* const)
native function SetDescriptionHash(int Index, int hash_str);

// Export UTurokUITextPairList::execGetDescriptionHash(FFrame&, void* const)
native function int GetDescriptionHash(int Index);

// Export UTurokUITextPairList::execSetID(FFrame&, void* const)
native function SetID(int Index, int Id);

// Export UTurokUITextPairList::execGetID(FFrame&, void* const)
native function int GetID(int Index);

// Export UTurokUITextPairList::execGetSelectedItemIndex(FFrame&, void* const)
native function int GetSelectedItemIndex();

// Export UTurokUITextPairList::execFocus(FFrame&, void* const)
native function Focus(bool IsFocused);

// Export UTurokUITextPairList::execAdjustItemPositions(FFrame&, void* const)
native function AdjustItemPositions();

// Export UTurokUITextPairList::execScroll(FFrame&, void* const)
native function bool Scroll(int Dir);

// Export UTurokUITextPairList::execHighlight(FFrame&, void* const)
native function Highlight(int Index);

// Export UTurokUITextPairList::execUnHighlight(FFrame&, void* const)
native function UnHighlight(int Index);

// Export UTurokUITextPairList::execFadeInComplete(FFrame&, void* const)
native function FadeInComplete();

// Export UTurokUITextPairList::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional int Index);

// Export UTurokUITextPairList::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

// Export UTurokUITextPairList::execSetTitleOnly(FFrame&, void* const)
native function SetTitleOnly(int Index, bool titleOnly);

function Editor_SetNumItems(int Num)
{
    NumItems = Clamp(Num, 0, 20);
    NumVisibleItems = NumItems;
    Editor_UpdateNumItems();
    //return;    
}

function StartFadeIn()
{
    FadeInComplete();
    //return;    
}

function StartFadeOut()
{
    // End:0x1D
    if(bHasHighlightImage)
    {
        HighlightImage.SetVisibility(false);
    }
    //return;    
}

function Deinitialize()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < NumItems)
    {
        Items[I].Deinitialize();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateNumItems()
{
    local int I;
    local @NULL Item;

    NumItems = Clamp(NumItems, 0, 20);
    // End:0x17F
    if(NumItems > PrevNumItems)
    {
        I = PrevNumItems;
        J0x2A:

        // End:0x17C [Loop If]
        if(I < NumItems)
        {
            Item = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUITextPair', name((string(WidgetTag) $ "_Item") $ string(I)), GetScene(), self);
            // End:0x172
            if(Item != none)
            {
                Item.SetTitleString("Title_" $ string(I));
                Item.SetDataString("Data_" $ string(I));
                Item.HighlightColor_Title = HighlightColor_Title;
                Item.UnHighlightColor_Title = UnHighlightColor_Title;
                Item.HighlightColor_Data = HighlightColor_Data;
                Item.UnHighlightColor_Data = UnHighlightColor_Data;
                Class'TurokUI'.static.SetSize(Item, 200.0000000, 25.0000000);
                Class'TurokUI'.static.SetPosition(Item, 0.0000000, 25.0000000 * float(I));
                Items[I] = Item;
            }
            I++;
            // [Loop Continue]
            goto J0x2A;
        }        
    }
    else
    {
        // End:0x1D0
        if(NumItems < PrevNumItems)
        {
            I = PrevNumItems;
            J0x199:

            // End:0x1D0 [Loop If]
            if(I >= NumItems)
            {
                RemoveChild(Items[I]);
                Items[I] = none;
                I--;
                // [Loop Continue]
                goto J0x199;
            }
        }
    }
    SelectedItemIndex = 0;
    PrevNumItems = NumItems;
    AdjustItemPositions();
    //return;    
}

event Editor_UpdateHasHighlightImage_TextPairList()
{
    // End:0xA3
    if(bHasHighlightImage)
    {
        HighlightImage = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_HighlightImage"), GetScene(), self);
        // End:0xA0
        if(HighlightImage != none)
        {
            HighlightImage.Position.ScaleType[0] = 3;
            HighlightImage.Position.ScaleType[1] = 3;
            HighlightImage.bUseOverrides = true;
        }        
    }
    else
    {
        // End:0xC0
        if(HighlightImage != none)
        {
            RemoveChild(HighlightImage);
            HighlightImage = none;
        }
    }
    //return;    
}

defaultproperties
{
    HighlightColor_Title=(R=201,G=135,B=60,A=255)
    UnHighlightColor_Title=(R=88,G=53,B=26,A=255)
    HighlightColor_Data=(R=255,G=161,B=0,A=255)
    UnHighlightColor_Data=(R=140,G=96,B=47,A=255)
    fAnimTime=0.1250000
    fFadeDelay=0.0625000
    Position=(Value[2]=200.0000000,Value[3]=200.0000000)
    // Reference: UIComp_Event'Default__TurokUITextPairList.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}