class TurokHudPriorityDraw extends Object
    native;

var @NULL PrioritizedObject;
var byte Priority;
//var delegate<@NULL> __DrawPrioritizedObject__Delegate;

delegate DrawPrioritizedObject(@NULL kHud)
{
    //return;    
}

function Init(byte kPriority, delegate<@NULL> kDelegate, @NULL kCaller)
{
    PrioritizedObject = kCaller;
    Priority = kPriority;
    __DrawPrioritizedObject__Delegate = kDelegate;
    //return;    
}
