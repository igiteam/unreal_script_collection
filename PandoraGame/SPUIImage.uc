class SPUIImage extends SPFadeObject
    native;

var private native const noexport Pointer VfTable_IUIDataStorePublisher;
/** the data store that this image retrieves its value from */
var(Data) private UIDataStoreBinding ImageDataSource;
/** Component for rendering the actual image */
var(Image) noclear const export editinline UIComp_DrawImage ImageComponent;
var deprecated UITexture Image;
var deprecated TextureCoordinates Coordinates;

final function SetValue(Surface NewImage)
{
    ImageComponent.SetImage(NewImage);
    //return;    
}

// Export USPUIImage::execSetDataStoreBinding(FFrame&, void* const)
native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

// Export USPUIImage::execGetDataStoreBinding(FFrame&, void* const)
native final function string GetDataStoreBinding(optional int BindingIndex = -1);

// Export USPUIImage::execRefreshSubscriberValue(FFrame&, void* const)
native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

// Export USPUIImage::execNotifyDataStoreValueUpdated(FFrame&, void* const)
native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

// Export USPUIImage::execGetBoundDataStores(FFrame&, void* const)
native final function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

// Export USPUIImage::execClearBoundDataStores(FFrame&, void* const)
native final function ClearBoundDataStores();

// Export USPUIImage::execSaveSubscriberValue(FFrame&, void* const)
native final function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);

// Export USPUIImage::execSetColor(FFrame&, void* const)
native function SetColor(LinearColor NewColor);
