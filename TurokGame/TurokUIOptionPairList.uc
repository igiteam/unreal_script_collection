class TurokUIOptionPairList extends TurokUITextPairList
    native
    hidecategories(Object,UIRoot,Object);

var array mOptions;
var array mValues;
var int mVisibleOptions;
var int mVisibleStartIndex;
var int mVerticalItemSpacing;
var int mArrowSpacing;
var int mListHeight;
var bool mbShowDescription;
var bool mbScrollingDown;
var bool mbHoldSelectionInMiddleOfList;
var bool mbShowArrows;
var float fHighlightScale;
var float fUnHighlightScale;
var name mLabelStyle;
var @NULL mBackgroundTitle;
var @NULL mBackgroundData;
var @NULL mMaterial;
var @NULL mUpArrow;
var @NULL mDownArrow;
var @NULL mDescription;
var @NULL mVerticalTexture;
var @NULL mVerticalTextureDisabled;
var @NULL mArrowFull;
var @NULL mDescriptionTextColor;

// Export UTurokUIOptionPairList::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIOptionPairList::execGetLocalizedString(FFrame&, void* const)
native function string GetLocalizedString(int Hash);

// Export UTurokUIOptionPairList::execSetOptionData(FFrame&, void* const)
native function SetOptionData(array OptionsList);

// Export UTurokUIOptionPairList::execGetValueAt(FFrame&, void* const)
native final function int GetValueAt(int Index);

// Export UTurokUIOptionPairList::execGetValue(FFrame&, void* const)
native final function int GetValue(byte Id);

// Export UTurokUIOptionPairList::execSetValueAt(FFrame&, void* const)
native final function SetValueAt(int Index, int Value, optional bool doUpdate);

// Export UTurokUIOptionPairList::execSetValue(FFrame&, void* const)
native final function SetValue(byte Id, int Value, optional bool doUpdate);

// Export UTurokUIOptionPairList::execGetNumOptions(FFrame&, void* const)
native final function int GetNumOptions();

// Export UTurokUIOptionPairList::execGetOptionAt(FFrame&, void* const)
native final function @NULL GetOptionAt(int Index);

event CreateChildWidgets()
{
    // End:0x197
    if(mUpArrow == none)
    {
        mUpArrow = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_Up"), GetScene(), self);
        mUpArrow.Position.ScaleType[0] = 3;
        mUpArrow.Position.ScaleType[1] = 3;
        mUpArrow.Position.ScaleType[2] = 3;
        mUpArrow.Position.ScaleType[3] = 3;
        mUpArrow.Position.Value[2] = float(mVerticalTexture.SizeX);
        mUpArrow.Position.Value[3] = float(mVerticalTexture.SizeY);
        mUpArrow.SetValue(mVerticalTexture);
        Class'TurokUI'.static.SetUV(mUpArrow, 0.0000000, float(mVerticalTexture.SizeY), float(mVerticalTexture.SizeX), float(-mVerticalTexture.SizeY));
        mUpArrow.bUseOverrides = true;
        mUpArrow.OverrideColor = mArrowFull;
    }
    // End:0x323
    if(mDownArrow == none)
    {
        mDownArrow = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_Down"), GetScene(), self);
        mDownArrow.Position.ScaleType[0] = 3;
        mDownArrow.Position.ScaleType[1] = 3;
        mDownArrow.Position.ScaleType[2] = 3;
        mDownArrow.Position.ScaleType[3] = 3;
        mDownArrow.Position.Value[2] = float(mVerticalTexture.SizeX);
        mDownArrow.Position.Value[3] = float(mVerticalTexture.SizeY);
        mDownArrow.SetValue(mVerticalTexture);
        Class'TurokUI'.static.SetUV(mDownArrow, 0.0000000, 0.0000000, float(mVerticalTexture.SizeX), float(mVerticalTexture.SizeY));
        mDownArrow.bUseOverrides = true;
        mDownArrow.OverrideColor = mArrowFull;
    }
    // End:0x43D
    if(mDescription == none)
    {
        mDescription = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UILabel', name(string(WidgetTag) $ "_Description"), GetScene(), self);
        mDescription.StringRenderComponent.EnableAutoSizing(0);
        mDescription.StringRenderComponent.EnableAutoSizing(1);
        mDescription.Position.ScaleType[0] = 3;
        mDescription.Position.ScaleType[1] = 3;
        mDescription.Position.ScaleType[2] = 3;
        mDescription.Position.ScaleType[3] = 3;
        mDescription.mbOverrideFontDefaults = true;
        mDescription.mFontColor = mDescriptionTextColor;
    }
    // End:0x471
    if(false == mbShowArrows)
    {
        mUpArrow.SetVisibility(false);
        mDownArrow.SetVisibility(false);
    }
    UpdateDescriptionLabel();
    UpdateArrows();
    //return;    
}

// Export UTurokUIOptionPairList::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

event Editor_UpdateNumItems()
{
    local int I;
    local @NULL Item;

    NumItems = Clamp(NumItems, 0, mVisibleOptions);
    // End:0x241
    if(NumItems > PrevNumItems)
    {
        mListHeight = 0;
        I = PrevNumItems;
        J0x34:

        // End:0x23E [Loop If]
        if(I < NumItems)
        {
            Item = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIOptionPair', name((string(WidgetTag) $ "_Item") $ string(I)), GetScene(), self);
            // End:0x234
            if(Item != none)
            {
                Item.SetFontMasking(mLabelStyle, mBackgroundTitle, mBackgroundData, mMaterial);
                Item.SetOptionData(mOptions[I + mVisibleStartIndex]);
                Item.HighlightColor_Title = HighlightColor_Title;
                Item.UnHighlightColor_Title = UnHighlightColor_Title;
                Item.HighlightColor_Data = HighlightColor_Data;
                Item.UnHighlightColor_Data = UnHighlightColor_Data;
                Item.mbScrollWrapped = false;
                Class'TurokUI'.static.SetPosition(Item, 0.0000000, float(mListHeight));
                Item.fHighlightScale = fHighlightScale;
                Item.fUnHighlightScale = fUnHighlightScale;
                mListHeight += int((Item.GetHeight() * Item.fUnHighlightScale) + float(mVerticalItemSpacing));
                Item.Title.mbShadow = true;
                Item.Title.mShadowBlur = 1;
                Item.Data.mbShadow = true;
                Item.Data.mShadowBlur = 1;
                Items[I] = Item;
            }
            ++I;
            // [Loop Continue]
            goto J0x34;
        }        
    }
    else
    {
        // End:0x292
        if(NumItems < PrevNumItems)
        {
            I = PrevNumItems;
            J0x25B:

            // End:0x292 [Loop If]
            if(I >= NumItems)
            {
                RemoveChild(Items[I]);
                Items[I] = none;
                --I;
                // [Loop Continue]
                goto J0x25B;
            }
        }
    }
    SelectedItemIndex = 0;
    PrevNumItems = NumItems;
    AdjustPositions();
    UpdateDescriptionLabel();
    NumVisibleItems = NumItems;
    //return;    
}

// Export UTurokUIOptionPairList::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional int Index);

// Export UTurokUIOptionPairList::execUpdateVisibleOptionsList(FFrame&, void* const)
native function UpdateVisibleOptionsList();

// Export UTurokUIOptionPairList::execUpdateDescriptionLabel(FFrame&, void* const)
native function UpdateDescriptionLabel();

function AdjustPositions()
{
    Class'TurokUI'.static.SetPosition(mUpArrow, -Class'TurokUI'.static.GetWidthUV(mUpArrow) / float(2), -Abs(Class'TurokUI'.static.GetHeightUV(mUpArrow)) - float(mArrowSpacing));
    Class'TurokUI'.static.SetPosition(mDownArrow, -Class'TurokUI'.static.GetWidthUV(mDownArrow) / float(2), float(mListHeight + mArrowSpacing));
    //return;    
}

// Export UTurokUIOptionPairList::execScroll(FFrame&, void* const)
native function bool Scroll(int Direction);

event UpdateArrows()
{
    // End:0x26
    if((bScrollWrapped == false) && SelectedItemIndex == 0)
    {
        DisableUpArrow();        
    }
    else
    {
        // End:0x54
        if((bScrollWrapped == false) && SelectedItemIndex == (mOptions.Length - 1))
        {
            DisableDownArrow();            
        }
        else
        {
            // End:0x6A
            if(bScrollWrapped == false)
            {
                EnableArrows();
            }
        }
    }
    //return;    
}

function DisableUpArrow()
{
    mUpArrow.SetValue(mVerticalTextureDisabled);
    mDownArrow.SetValue(mVerticalTexture);
    //return;    
}

function DisableDownArrow()
{
    mUpArrow.SetValue(mVerticalTexture);
    mDownArrow.SetValue(mVerticalTextureDisabled);
    //return;    
}

function EnableArrows()
{
    mUpArrow.SetValue(mVerticalTexture);
    mDownArrow.SetValue(mVerticalTexture);
    //return;    
}

function array GetValues()
{
    return mValues;
    //return ReturnValue;    
}

defaultproperties
{
    mVisibleOptions=13
    mVerticalItemSpacing=-1
    mArrowSpacing=6
    mbShowDescription=true
    mbShowArrows=true
    mLabelStyle="TurokMenuFont_TransferDGaugeCombo"
    mVerticalTexture=Texture2D'TurokFEWidgets.OptionList.NavArrow_Vertical_On'
    mVerticalTextureDisabled=Texture2D'TurokFEWidgets.OptionList.NavArrow_Vertical_Off'
    mArrowFull=(R=255,G=255,B=255,A=255)
    mDescriptionTextColor=(R=255,G=200,B=200,A=255)
    bScrollWrapped=true
    // Reference: UIComp_Event'Default__TurokUIOptionPairList.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}