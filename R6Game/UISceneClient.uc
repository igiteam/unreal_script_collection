class UISceneClient extends UIRoot
    abstract
    native;

var private native const noexport Pointer VfTable_FExec;
var native const transient Pointer RenderViewport;
var transient UISkin ActiveSkin;
var const transient IntPoint MousePosition;

// Export UUISceneClient::execOpenScene(FFrame&, void* const)
native final function bool OpenScene(UIScene Scene);

// Export UUISceneClient::execCloseScene(FFrame&, void* const)
native final function bool CloseScene(UIScene Scene);

// Export UUISceneClient::execSetMousePosition(FFrame&, void* const)
native final function SetMousePosition(int NewMouseX, int NewMouseY);
