class TurokUIOptionPair extends TurokUITextPair
    native
    hidecategories(Object,UIRoot,Object);

enum eTurokUIOptionPairScriptType
{
    TUROK_UI_OPTION_PAIR_SCRIPT_HIGHLIGHT_TITLE,// 0
    TUROK_UI_OPTION_PAIR_SCRIPT_UNHIGHLIGHT_TITLE,// 1
    TUROK_UI_OPTION_PAIR_SCRIPT_HIGHLIGHT_DATA,// 2
    TUROK_UI_OPTION_PAIR_SCRIPT_UNHIGHLIGHT_DATA,// 3
    TUROK_UI_OPTION_PAIR_SCRIPT_NONE,// 4
    TUROK_UI_OPTION_PAIR_SCRIPT_MAX // 5
};

var @NULL mOptionData;
var int mCurrentIndex;
var @NULL mArrowImageLeft;
var @NULL mArrowImageRight;
var @NULL mHorizontalTexture;
var @NULL mHorizontalTextureDisabled;
var bool mbIsInitialized;
var bool mbScrollWrapped;
var bool mbIsHighlit;
var int mCenterOffset;
var int mArrowOffset;
var @NULL mArrowFull;

// Export UTurokUIOptionPair::execAdjustPositions(FFrame&, void* const)
native function AdjustPositions();

// Export UTurokUIOptionPair::execDetermineTitleHighlightPosition(FFrame&, void* const)
native function DetermineTitleHighlightPosition(out @NULL pos, out @NULL Size);

// Export UTurokUIOptionPair::execDetermineTitleUnHighlightPosition(FFrame&, void* const)
native function DetermineTitleUnHighlightPosition(out @NULL pos, out @NULL Size);

// Export UTurokUIOptionPair::execDetermineDataHighlightPosition(FFrame&, void* const)
native function DetermineDataHighlightPosition(out @NULL pos, out @NULL Size);

// Export UTurokUIOptionPair::execDetermineDataUnHighlightPosition(FFrame&, void* const)
native function DetermineDataUnHighlightPosition(out @NULL pos, out @NULL Size);

// Export UTurokUIOptionPair::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIOptionPair::execGetLocalizedString(FFrame&, void* const)
native function string GetLocalizedString(int Hash);

// Export UTurokUIOptionPair::execGetWidth(FFrame&, void* const)
native function float GetWidth();

// Export UTurokUIOptionPair::execGetHighlightedHeight(FFrame&, void* const)
native function float GetHighlightedHeight();

// Export UTurokUIOptionPair::execSetFontMasking(FFrame&, void* const)
native function SetFontMasking(name StyleName, @NULL titleTex, @NULL dataTex, @NULL maskMaterial);

event Highlight_TextPair()
{
    Class'TurokUI'.static.PlayScript(Title, "highlight");
    Class'TurokUI'.static.PlayScript(Data, "highlight");
    Class'TurokUI'.static.PlayScript(mArrowImageLeft, "fadein");
    Class'TurokUI'.static.PlayScript(mArrowImageRight, "fadein");
    mbIsHighlit = true;
    //return;    
}

event UnHighlight_TextPair()
{
    Class'TurokUI'.static.PlayScript(Title, "unhighlight");
    Class'TurokUI'.static.PlayScript(Data, "unhighlight");
    Class'TurokUI'.static.PlayScript(mArrowImageLeft, "fadeout");
    Class'TurokUI'.static.PlayScript(mArrowImageRight, "fadeout");
    mbIsHighlit = false;
    //return;    
}

event TurokUITextPairCreated()
{
    local @NULL FadeOut;

    // End:0x100
    if(Title == none)
    {
        Title = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UILabel', name(string(WidgetTag) $ "_Title"), GetScene(), self);
        Title.StringRenderComponent.EnableAutoSizing(0);
        Title.StringRenderComponent.EnableAutoSizing(1);
        Title.Position.ScaleType[0] = 3;
        Title.Position.ScaleType[1] = 3;
        Title.Position.ScaleType[2] = 3;
        Title.Position.ScaleType[3] = 3;
        Title.mbOverrideFontDefaults = true;
    }
    FadeOut = mArrowFull;
    FadeOut.A = 0;
    // End:0x2B6
    if(mArrowImageLeft == none)
    {
        mArrowImageLeft = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_Left"), GetScene(), self);
        mArrowImageLeft.Position.ScaleType[0] = 3;
        mArrowImageLeft.Position.ScaleType[1] = 3;
        mArrowImageLeft.Position.ScaleType[2] = 3;
        mArrowImageLeft.Position.ScaleType[3] = 3;
        mArrowImageLeft.Position.Value[2] = float(mHorizontalTexture.SizeX);
        mArrowImageLeft.Position.Value[3] = float(mHorizontalTexture.SizeY);
        mArrowImageLeft.SetValue(mHorizontalTexture);
        Class'TurokUI'.static.SetUV(mArrowImageLeft, float(mHorizontalTexture.SizeX), 0.0000000, float(-mHorizontalTexture.SizeX), float(mHorizontalTexture.SizeY));
        mArrowImageLeft.bUseOverrides = true;
        mArrowImageLeft.OverrideColor = FadeOut;
    }
    // End:0x443
    if(mArrowImageRight == none)
    {
        mArrowImageRight = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_Right"), GetScene(), self);
        mArrowImageRight.Position.ScaleType[0] = 3;
        mArrowImageRight.Position.ScaleType[1] = 3;
        mArrowImageRight.Position.ScaleType[2] = 3;
        mArrowImageRight.Position.ScaleType[3] = 3;
        mArrowImageRight.Position.Value[2] = float(mHorizontalTexture.SizeX);
        mArrowImageRight.Position.Value[3] = float(mHorizontalTexture.SizeY);
        mArrowImageRight.SetValue(mHorizontalTexture);
        Class'TurokUI'.static.SetUV(mArrowImageRight, 0.0000000, 0.0000000, float(mHorizontalTexture.SizeX), float(mHorizontalTexture.SizeY));
        mArrowImageRight.bUseOverrides = true;
        mArrowImageRight.OverrideColor = FadeOut;
    }
    // End:0x542
    if(Data == none)
    {
        Data = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UILabel', name(string(WidgetTag) $ "_Data"), GetScene(), self);
        Data.StringRenderComponent.EnableAutoSizing(0);
        Data.StringRenderComponent.EnableAutoSizing(1);
        Data.Position.ScaleType[0] = 3;
        Data.Position.ScaleType[1] = 3;
        Data.Position.ScaleType[2] = 3;
        Data.Position.ScaleType[3] = 3;
        Data.mbOverrideFontDefaults = true;
    }
    //return;    
}

// Export UTurokUIOptionPair::execSetOptionData(FFrame&, void* const)
native function SetOptionData(@NULL MetaData);

// Export UTurokUIOptionPair::execGetCurrentDisplay(FFrame&, void* const)
native function string GetCurrentDisplay();

// Export UTurokUIOptionPair::execGetCurrentValue(FFrame&, void* const)
native function int GetCurrentValue();

// Export UTurokUIOptionPair::execSetCurrentValue(FFrame&, void* const)
native function SetCurrentValue(int Value);

// Export UTurokUIOptionPair::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional float animTime);

// Export UTurokUIOptionPair::execResetHighlightScripts(FFrame&, void* const)
native function ResetHighlightScripts();

// Export UTurokUIOptionPair::execSetupScripts(FFrame&, void* const)
native function SetupScripts(optional float animTime);

// Export UTurokUIOptionPair::execScroll(FFrame&, void* const)
native function bool Scroll(int Direction);

// Export UTurokUIOptionPair::execUpdateDataLabel(FFrame&, void* const)
native function UpdateDataLabel();

event UpdateArrows()
{
    // End:0x26
    if((mbScrollWrapped == false) && mCurrentIndex == 0)
    {
        DisableLeftArrow();        
    }
    else
    {
        // End:0x5E
        if((mbScrollWrapped == false) && mCurrentIndex == (mOptionData.mOptionValues.Length - 1))
        {
            DisableRightArrow();            
        }
        else
        {
            // End:0x74
            if(mbScrollWrapped == false)
            {
                EnableArrows();
            }
        }
    }
    //return;    
}

function DisableLeftArrow()
{
    mArrowImageLeft.SetValue(mHorizontalTextureDisabled);
    mArrowImageRight.SetValue(mHorizontalTexture);
    //return;    
}

function DisableRightArrow()
{
    mArrowImageLeft.SetValue(mHorizontalTexture);
    mArrowImageRight.SetValue(mHorizontalTextureDisabled);
    //return;    
}

function EnableArrows()
{
    mArrowImageLeft.SetValue(mHorizontalTexture);
    mArrowImageRight.SetValue(mHorizontalTexture);
    //return;    
}

defaultproperties
{
    mOptionData=(Id=0,mTitle="",mOptionDisplayLookup=false,mOptionDisplayStrings=none,mOptionValues=none,mDefaultValue=0,mDescription="",mCenterOffset=0,mShowOnMatchmaking=true)
    mHorizontalTexture=Texture2D'TurokFEWidgets.OptionList.NavArrow_Horizontal_On'
    mHorizontalTextureDisabled=Texture2D'TurokFEWidgets.OptionList.NavArrow_Horizontal_Off'
    mbScrollWrapped=true
    mArrowOffset=1
    mArrowFull=(R=255,G=255,B=255,A=255)
    fLabelSpacing=14.0000000
    fHighlightScale=0.4375000
    fUnHighlightScale=0.3500000
    // Reference: UIComp_Event'Default__TurokUIOptionPair.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}