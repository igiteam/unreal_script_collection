class TurokUIOverlayParent extends TurokUISceneController
    native;

var bool bHasFocus;

// Export UTurokUIOverlayParent::execSetHasFocus(FFrame&, void* const)
native function SetHasFocus(bool bFocus);

// Export UTurokUIOverlayParent::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

defaultproperties
{
    bHasFocus=true
}