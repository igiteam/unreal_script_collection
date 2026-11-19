class GameUISceneClient extends UISceneClient
    native;

var const transient array<UIScene> ActiveScenes;
var const transient LocalPlayer CurrentPlayer;

// Export UGameUISceneClient::execGetTransientScene(FFrame&, void* const)
native final function UIScene GetTransientScene();

// Export UGameUISceneClient::execCreateScene(FFrame&, void* const)
native final function UIScene CreateScene(class<UIScene> SceneClass, optional name SceneTag);

// Export UGameUISceneClient::execCreateTransientWidget(FFrame&, void* const)
native final function UIObject CreateTransientWidget(class<UIObject> WidgetClass, name WidgetTag, optional UIObject Owner);

// Export UGameUISceneClient::execFindSceneByTag(FFrame&, void* const)
native final function UIScene FindSceneByTag(name SceneTag);

exec function TestLabel(string LabelText, optional int PosX, optional int PosY, optional int Width, optional int Height)
{
    local UIScene TransientScene;
    local UILabel Label;

    200
    200
    400
    400
    TransientScene = GetTransientScene();
    Label = UILabel(TransientScene.FindChild('TempLabel'));
    // End:0x6C
    if(Label == none)
    {
        Label = CreateTransientWidget(Class'UILabel', 'TempLabel');
    }
    Label.Position.ScaleType[int(0)] = 3;
    Label.Position.ScaleType[int(1)] = 3;
    Label.Position.ScaleType[int(2)] = 3;
    Label.Position.ScaleType[int(3)] = 3;
    Label.SetValue(LabelText);
    Label.Position.Value[int(0)] = float(PosX);
    Label.Position.Value[int(1)] = float(PosY);
    Label.Position.Value[int(2)] = float(Width);
    Label.Position.Value[int(3)] = float(Height);
    return;
}

exec function ShowDockingStacks()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(I < ActiveScenes.Length)
    {
        ActiveScenes[I].LogDockingStack();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

exec function ShowRenderBounds()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(I < ActiveScenes.Length)
    {
        ActiveScenes[I].LogRenderBounds();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}
