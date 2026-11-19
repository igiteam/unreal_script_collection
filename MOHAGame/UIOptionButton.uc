class UIOptionButton extends UILabelButton
    native
    hidecategories(Object,UIRoot,Object);

const UIKEY_MoveCursorLeft = 'UIKEY_MoveCursorLeft';
const UIKEY_MoveCursorRight = 'UIKEY_MoveCursorRight';

enum EButtonArrow
{
    ARROW_Left,                     // 0
    ARROW_Right,                    // 1
    ARROW_MAX                       // 2
};

var(Data) private UIDataStoreBinding OptionDataSource;
var transient UIListElementProvider DataProvider;
var transient name FieldName;
var transient int CurrentIndex;
var UIStyleReference LeftArrowStyle;
var UIStyleReference RightArrowStyle;
var class<UIState> LeftArrowState;
var class<UIState> RightArrowState;
var(Image) export editinlineuse UITexture LeftArrowTexture;
var(Image) export editinlineuse UITexture RightArrowTexture;
var(Sound) name IncrementCue;
var(Sound) name DecrementCue;
var bool bWrapOptions;

// Export UUIOptionButton::execRefreshSubscriberValue(FFrame&, void* const)
native function bool RefreshSubscriberValue(optional int BindingIndex);

// Export UUIOptionButton::execGetBoundDataStores(FFrame&, void* const)
native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

// Export UUIOptionButton::execSaveSubscriberValue(FFrame&, void* const)
native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex);

defaultproperties
{
    OptionDataSource=(Subscriber=none,RequiredFieldType=0,MarkupString="Enter Settings Markup",DataStoreName="None",DataStoreField="None",ResolvedDataStore=none)
    LeftArrowStyle=(DefaultStyleTag="DefaultOptionButtonLeftArrowStyle",RequiredStyleClass=Class'Engine.UIStyle_Image',AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle=none)
    RightArrowStyle=(DefaultStyleTag="DefaultOptionButtonRightArrowStyle",RequiredStyleClass=Class'Engine.UIStyle_Image',AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle=none)
    LeftArrowState=Class'Engine.UIState_Enabled'
    RightArrowState=Class'Engine.UIState_Enabled'
    IncrementCue="SliderIncrement"
    DecrementCue="SliderDecrement"
    bWrapOptions=true
    CaptionDataSource=(MarkupString="Option Button Text")
    // Reference: UIComp_DrawString'Default__UIOptionButton.LabelStringRenderer'
    begin object name=LabelStringRenderer
    end object
    StringRenderComponent=LabelStringRenderer
    // Reference: UIComp_DrawImage'Default__UIOptionButton.BackgroundImageTemplate'
    begin object name=BackgroundImageTemplate
    end object
    BackgroundImageComponent=BackgroundImageTemplate
    PrimaryStyle=(DefaultStyleTag="DefaultOptionButtonStyle")
    // Reference: UIComp_Event'Default__UIOptionButton.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}