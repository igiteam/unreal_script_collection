class SPUIHyperLinkText extends UIObject
    native;

const UIKEY_Pressed = 'UIKEY_Pressed';

var private native const noexport Pointer VfTable_IUIDataStorePublisher;
/** the text that will be rendered by this label */
var(Data) private UIDataStoreBinding CaptionDataSource;
/** Renders the caption for this button */
var(Data) noclear const export editinline UIComp_DrawString StringRenderComponent;
/** this sound is played when this widget is clicked */
var(Sound) name ClickedCue;

// Export USPUIHyperLinkText::execSetCaption(FFrame&, void* const)
native final function SetCaption(string NewText);

final function string GetCaption()
{
    return StringRenderComponent.GetValue();
    //return ReturnValue;    
}

function OnSetLabelText(UIAction_SetLabelText Action)
{
    SetCaption(Action.NewText);
    //return;    
}

// Export USPUIHyperLinkText::execSetTextAlignment(FFrame&, void* const)
native final function SetTextAlignment(UIRoot.EUIAlignment Horizontal, UIRoot.EUIAlignment Vertical);

// Export USPUIHyperLinkText::execSetDataStoreBinding(FFrame&, void* const)
native final function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

// Export USPUIHyperLinkText::execGetDataStoreBinding(FFrame&, void* const)
native final function string GetDataStoreBinding(optional int BindingIndex = -1);

// Export USPUIHyperLinkText::execRefreshSubscriberValue(FFrame&, void* const)
native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

// Export USPUIHyperLinkText::execNotifyDataStoreValueUpdated(FFrame&, void* const)
native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

// Export USPUIHyperLinkText::execGetBoundDataStores(FFrame&, void* const)
native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

// Export USPUIHyperLinkText::execClearBoundDataStores(FFrame&, void* const)
native final function ClearBoundDataStores();

// Export USPUIHyperLinkText::execSaveSubscriberValue(FFrame&, void* const)
native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);
