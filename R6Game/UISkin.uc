class UISkin extends UIDataStore
    native;

var const array<UIStyle> Styles;
var native const transient map{VOID,VOID} StyleLookupTable;
var native const map{VOID,VOID} WidgetStyleMap;

// Export UUISkin::execSetWidgetStyle(FFrame&, void* const)
native final function SetWidgetStyle(UIObject Widget, name StyleName);

// Export UUISkin::execGetWidgetStyle(FFrame&, void* const)
native final function UIStyle GetWidgetStyle(UIObject Widget);
