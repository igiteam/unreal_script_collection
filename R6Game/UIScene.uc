class UIScene extends UIScreenObject
    native
    hidecategories(Object);

var() name SceneTag;
var const transient UISceneClient SceneClient;
var const transient LocalPlayer PlayerOwner;
var private native const transient array<UIDockingNode> DockingStack;
var native const transient MultiMap_Mirror InputSubscriptions;
var array<UIObject> SceneChildren;
var transient bool bUpdateDockingStack;
var transient bool bUpdateScenePositions;
var transient bool bInitialized;

// Export UUIScene::execInsertChild(FFrame&, void* const)
native final function int InsertChild(UIObject NewChild, optional int InsertIndex);

// Export UUIScene::execRemoveChild(FFrame&, void* const)
native final function bool RemoveChild(UIObject ExistingChild);

// Export UUIScene::execFindChild(FFrame&, void* const)
native final function UIObject FindChild(name WidgetName, optional bool bRecurse);

// Export UUIScene::execFindChildIndex(FFrame&, void* const)
native final function int FindChildIndex(name WidgetName);

// Export UUIScene::execRebuildDockingStack(FFrame&, void* const)
native final function RebuildDockingStack();

// Export UUIScene::execResolveScenePositions(FFrame&, void* const)
native final function ResolveScenePositions();

function SceneCreated(UIScene CreatedScene)
{
    return;
}

event SceneActivated()
{
    return;
}

event SceneDeactivated()
{
    return;
}

function LogDockingStack()
{
    return;
}

function LogRenderBounds()
{
    return;
}

defaultproperties
{
    bUpdateDockingStack=true
    bUpdateScenePositions=true
}