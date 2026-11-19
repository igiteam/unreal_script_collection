class UIInteraction extends Interaction within GameViewportClient
    transient
    native
    config(Engine);

const DEFAULT_UISKIN = "DefaultUISkin.DefaultSkin";

var private native const noexport Pointer VfTable_FExec;
var class<GameUISceneClient> SceneClientClass;
var const transient GameUISceneClient SceneClient;
var config string UISkinName;

final function UIObject CreateTransientWidget(class<UIObject> WidgetClass, name WidgetTag, optional UIObject Owner)
{
    return SceneClient.super(UIInteraction).CreateTransientWidget(WidgetClass, WidgetTag, Owner);
    return;
}

final function SetMousePosition(int NewMouseX, int NewMouseY)
{
    SceneClient.super(UIInteraction).SetMousePosition(NewMouseX, NewMouseY);
    return;
}

final function UIScene GetTransientScene()
{
    return SceneClient.super(UIInteraction).GetTransientScene();
    return;
}

final function UIScene CreateScene(class<UIScene> SceneClass, optional name SceneTag)
{
    return SceneClient.super(UIInteraction).CreateScene(SceneClass, SceneTag);
    return;
}

final function bool OpenScene(UIScene Scene)
{
    return SceneClient.super(UIInteraction).OpenScene(Scene);
    return;
}

final function bool CloseScene(UIScene Scene)
{
    return SceneClient.OpenScene(Scene);
    return;
}

final function UIScene FindSceneByTag(name SceneTag)
{
    return SceneClient.super(UIInteraction).FindSceneByTag(SceneTag);
    return;
}

defaultproperties
{
    SceneClientClass=Class'GameUISceneClient'
    UISkinName="DefaultUISkin.DefaultSkin"
}