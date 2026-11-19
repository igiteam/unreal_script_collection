class UIVisibilityPanel extends UIPanel
    native
    config(UI);

var private native const noexport Pointer VfTable_IUIDataStoreSubscriber;
var(Data) private UIDataStoreBinding DataSource;

// Export UUIVisibilityPanel::execSetDataStoreBinding(FFrame&, void* const)
native final function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

// Export UUIVisibilityPanel::execGetDataStoreBinding(FFrame&, void* const)
native final function string GetDataStoreBinding(optional int BindingIndex = -1);

// Export UUIVisibilityPanel::execRefreshSubscriberValue(FFrame&, void* const)
native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

// Export UUIVisibilityPanel::execNotifyDataStoreValueUpdated(FFrame&, void* const)
native final function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

// Export UUIVisibilityPanel::execGetBoundDataStores(FFrame&, void* const)
native final function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

// Export UUIVisibilityPanel::execClearBoundDataStores(FFrame&, void* const)
native final function ClearBoundDataStores();
