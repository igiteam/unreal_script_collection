class SPUIObject extends UIObject
    abstract
    native;

var array<SPUIObject> TickStack;
/** If true, this object will render it's bounds */
var(Widget) transient bool bShowBounds;

// Export USPUIObject::execGetSPWidgetOwner(FFrame&, void* const)
native function SPUIObject GetSPWidgetOwner();

// Export USPUIObject::execGetPandoraPlayerOwner(FFrame&, void* const)
native function PandoraPlayerController GetPandoraPlayerOwner(optional int Index);

// Export USPUIObject::execGetPawnOwner(FFrame&, void* const)
native function Pawn GetPawnOwner();

// Export USPUIObject::execGetPRIOwner(FFrame&, void* const)
native function SPPlayerReplicationInfo GetPRIOwner();

// Export USPUIObject::execGetFont(FFrame&, void* const)
native function Font GetFont(name FontName);

// Export USPUIObject::execGetWorldInfo(FFrame&, void* const)
native function WorldInfo GetWorldInfo();

event Initialized()
{
    super(UIScreenObject).Initialized();
    // End:0x3B
    if(bRequiresTick && (GetSPWidgetOwner()) != none)
    {
        GetSPWidgetOwner().AddChildToTickStack(self);
    }
    //return;    
}

event AddChildToTickStack(SPUIObject Child)
{
    // End:0x29
    if(TickStack.Find(Child) == -1)
    {
        TickStack[TickStack.Length] = Child;
    }
    // End:0x69
    if(((GetSPWidgetOwner()) != none) && TickStack.Length > 0)
    {
        bRequiresTick = true;
        GetSPWidgetOwner().AddChildToTickStack(self);
    }
    //return;    
}

event RemoveChildFromTickStack(SPUIObject Child)
{
    local int ChildIndex;

    ChildIndex = TickStack.Find(Child);
    // End:0x2E
    if(ChildIndex != -1)
    {
        TickStack.Remove(ChildIndex, 1);
    }
    // End:0x6E
    if(((GetSPWidgetOwner()) != none) && TickStack.Length <= 0)
    {
        bRequiresTick = false;
        GetSPWidgetOwner().RemoveChildFromTickStack(self);
    }
    //return;    
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    local SPUIObject SPChild;

    super(UIScreenObject).AddedChild(WidgetOwner, NewChild);
    SPChild = SPUIObject(NewChild);
    // End:0x4D
    if(SPChild != none)
    {
        // End:0x4D
        if(SPChild.bRequiresTick)
        {
            AddChildToTickStack(SPChild);
        }
    }
    //return;    
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    local SPUIObject SPChild;

    super(UIScreenObject).RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    SPChild = SPUIObject(OldChild);
    // End:0x53
    if(SPChild != none)
    {
        // End:0x53
        if(SPChild.bRequiresTick)
        {
            RemoveChildFromTickStack(SPChild);
        }
    }
    //return;    
}
