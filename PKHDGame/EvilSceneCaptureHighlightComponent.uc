class EvilSceneCaptureHighlightComponent extends SceneCapture2DComponent
    native(SceneCapture)
    hidecategories(Object);

var LocalPlayer Player;

defaultproperties
{
    bEnabled=false
    ClearColor=(R=255,G=0,B=255,A=0)
    ViewMode=ESceneCaptureViewMode.SceneCapView_Unlit
}