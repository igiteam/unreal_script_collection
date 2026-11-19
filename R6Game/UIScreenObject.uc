class UIScreenObject extends UIRoot
    abstract
    native
    hidecategories(Object);

var() UIScreenValue_Bounds Position;
var() private bool bHidden;

// Export UUIScreenObject::execRequestSceneUpdate(FFrame&, void* const)
native final function RequestSceneUpdate(bool bDockingStackChanged, bool bPositionsChanged);

// Export UUIScreenObject::execGetViewportSize(FFrame&, void* const)
native final function bool GetViewportSize(out Vector2D ViewportSize);

event Initialized()
{
    return;
}

event PostInitialize()
{
    return;
}

event SetVisibility(bool bIsVisible)
{
    bHidden = !bIsVisible;
    return;
}

defaultproperties
{
    Position=(Value=0.0000000,Value[1]=0.0000000,Value[2]=1.0000000,Value[3]=1.0000000,ScaleType=5,ScaleType[1]=5,ScaleType[2]=5,ScaleType[3]=5)
}