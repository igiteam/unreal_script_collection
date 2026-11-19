class TurokUITextPair extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

var @NULL Title;
var @NULL Data;
var protected int Id;
var() float fLabelSpacing;
var() bool mbNoDataLabel;
var bool bHasBlurEffect;
var(Anims) @NULL HighlightColor_Title;
var(Anims) @NULL UnHighlightColor_Title;
var(Anims) @NULL HighlightColor_Data;
var(Anims) @NULL UnHighlightColor_Data;
var(Anims) float fAnimTime;
var(Anims) float fHighlightScale;
var(Anims) float fUnHighlightScale;
var int DescriptionHash;
//var delegate<@NULL> __Act_TextPair__Delegate;

// Export UTurokUITextPair::execAdjustPositions(FFrame&, void* const)
native function AdjustPositions();

// Export UTurokUITextPair::execResetToUnHighlightColor(FFrame&, void* const)
native function ResetToUnHighlightColor();

// Export UTurokUITextPair::execSetTitleStrHash(FFrame&, void* const)
native final function SetTitleStrHash(int string_hash);

// Export UTurokUITextPair::execSetTitleString(FFrame&, void* const)
native final function SetTitleString(string Text);

// Export UTurokUITextPair::execSetDataStrHash(FFrame&, void* const)
native final function SetDataStrHash(int string_hash);

// Export UTurokUITextPair::execSetDataString(FFrame&, void* const)
native final function SetDataString(string Text);

// Export UTurokUITextPair::execSetDescriptionHash(FFrame&, void* const)
native function SetDescriptionHash(int hash_str);

// Export UTurokUITextPair::execGetDescriptionHash(FFrame&, void* const)
native function int GetDescriptionHash();

// Export UTurokUITextPair::execSetID(FFrame&, void* const)
native function SetID(int newID);

// Export UTurokUITextPair::execGetID(FFrame&, void* const)
native function int GetID();

// Export UTurokUITextPair::execGetWidth(FFrame&, void* const)
native function float GetWidth();

// Export UTurokUITextPair::execGetHeight(FFrame&, void* const)
native function float GetHeight();

// Export UTurokUITextPair::execGetDataWidth(FFrame&, void* const)
native function float GetDataWidth();

// Export UTurokUITextPair::execGetTitleWidth(FFrame&, void* const)
native function float GetTitleWidth();

// Export UTurokUITextPair::execGetDataPosX(FFrame&, void* const)
native function float GetDataPosX(optional byte positionEvalType);

// Export UTurokUITextPair::execGetDataPosY(FFrame&, void* const)
native function float GetDataPosY(optional byte positionEvalType);

// Export UTurokUITextPair::execGetTitlePosX(FFrame&, void* const)
native function float GetTitlePosX(optional byte positionEvalType);

// Export UTurokUITextPair::execGetTitlePosY(FFrame&, void* const)
native function float GetTitlePosY(optional byte positionEvalType);

// Export UTurokUITextPair::execSetVisibility(FFrame&, void* const)
native function SetVisibility(bool visible);

// Export UTurokUITextPair::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUITextPair::execSetCrispTitle(FFrame&, void* const)
native function SetCrispTitle();

// Export UTurokUITextPair::execSetBlurTitle(FFrame&, void* const)
native function SetBlurTitle();

// Export UTurokUITextPair::execSetCrispData(FFrame&, void* const)
native function SetCrispData();

// Export UTurokUITextPair::execSetBlurData(FFrame&, void* const)
native function SetBlurData();

function ScaleText(float ScaleFactor)
{
    Data.SetScale(ScaleFactor);
    Title.SetScale(ScaleFactor);
    //return;    
}

delegate Act_TextPair()
{
    //return;    
}

event FireDelegate()
{
    Act_TextPair();
    //return;    
}

// Export UTurokUITextPair::execResetHighlightScripts(FFrame&, void* const)
native function ResetHighlightScripts();

// Export UTurokUITextPair::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize(optional float anim_time);

function Deinitialize()
{
    Title.ScriptCtrl = none;
    Data.ScriptCtrl = none;
    //return;    
}

event TurokUITextPairCreated()
{
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
    // End:0x1FF
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

event Highlight_TextPair()
{
    Class'TurokUI'.static.PlayScript(Title, "highlight");
    Class'TurokUI'.static.PlayScript(Data, "highlight");
    //return;    
}

event UnHighlight_TextPair()
{
    Class'TurokUI'.static.PlayScript(Title, "unhighlight");
    Class'TurokUI'.static.PlayScript(Data, "unhighlight");
    //return;    
}

defaultproperties
{
    HighlightColor_Title=(R=224,G=224,B=224,A=255)
    UnHighlightColor_Title=(R=160,G=160,B=160,A=255)
    HighlightColor_Data=(R=255,G=255,B=255,A=255)
    UnHighlightColor_Data=(R=192,G=192,B=192,A=255)
    fAnimTime=0.1250000
    fHighlightScale=1.0000000
    fUnHighlightScale=1.0000000
    Position=(Value[2]=200.0000000,Value[3]=25.0000000)
    // Reference: UIComp_Event'Default__TurokUITextPair.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}