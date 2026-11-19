class UIObject extends UIScreenObject
    abstract
    native
    hidecategories(Object);

var WIDGET_ID WidgetID;
var() name WidgetTag;
var private UIObject Owner;
var private UIScene OwnerScene;
var private array<UIObject> Children;
var name DefaultStyleTag;
var const transient UIStyle Style;
var UIDockingSet DockTargets;
var private const float RenderBounds[4];
var() Rotator Rotation;
var() float Opacity;
var() UIScreenValue_Position Anchor;
var() UIObject AnimationParent;
var export editinline UIComp_Event EventProvider;
//var delegate<OnCreate> __OnCreate__Delegate;

// Export UUIObject::execInsertChild(FFrame&, void* const)
native final function int InsertChild(UIObject NewChild, optional int InsertIndex);

// Export UUIObject::execRemoveChild(FFrame&, void* const)
native final function bool RemoveChild(UIObject ExistingChild);

// Export UUIObject::execFindChild(FFrame&, void* const)
native final function UIObject FindChild(name WidgetName, optional bool bRecurse);

// Export UUIObject::execFindChildIndex(FFrame&, void* const)
native final function int FindChildIndex(name WidgetName);

// Export UUIObject::execGetObjectCount(FFrame&, void* const)
native final function int GetObjectCount();

delegate OnCreate(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
    return;
}

function UIScene GetScene()
{
    return OwnerScene;
    return;
}

function UIObject GetOwner()
{
    return Owner;
    return;
}

function SetDockTarget(UIRoot.EUIWidgetFace SourceFace, UIObject Target, UIRoot.EUIWidgetFace TargetFace, optional float Padding)
{
    // End:0x3A
    if(Target == self)
    {
        WarnInternal("Cannot dock a widget to itself!" @ string(Name));
        return;
    }
    // End:0x11E
    if((Target != none) && Target.DockTargets.TargetWidget[int(TargetFace)] == self)
    {
        WarnInternal((((((((("Cannot create recursive docking relationship!" @ "Source:") @ string(Name)) $ ",") $ string(GetEnum(Enum'UIRoot.EUIWidgetFace', int(SourceFace)))) @ "Target:") $ "Target:") $ ((Target != none) ? string(Target.Name) : "None")) $ ",") $ string(GetEnum(Enum'UIRoot.EUIWidgetFace', int(TargetFace))));
    }
    DockTargets.TargetWidget[int(SourceFace)] = Target;
    DockTargets.TargetFace[int(SourceFace)] = TargetFace;
    DockTargets.DockPadding[int(SourceFace)] = Padding;
    return;
}

function LogRenderBounds(int Indent)
{
    return;
}

defaultproperties
{
    DockTargets=(TargetWidget=none,TargetWidget[1]=none,TargetWidget[2]=none,TargetWidget[3]=none,DockPadding=0.0000000,DockPadding[1]=0.0000000,DockPadding[2]=0.0000000,DockPadding[3]=0.0000000,TargetFace=4,TargetFace[1]=4,TargetFace[2]=4,TargetFace[3]=4)
    Opacity=1.0000000
    // Reference: UIComp_Event'Default__UIObject.WidgetEventComponent'
    begin object name="WidgetEventComponent" class=Class'UIComp_Event'
    end object
    EventProvider=WidgetEventComponent
}