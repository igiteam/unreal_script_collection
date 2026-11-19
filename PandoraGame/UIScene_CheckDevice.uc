class UIScene_CheckDevice extends UIScene
    native;

//var delegate<OnSceneClose> __OnSceneClose__Delegate;

delegate OnSceneClose()
{
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    OnSceneClose();
    //return;    
}
