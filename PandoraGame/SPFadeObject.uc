class SPFadeObject extends SPUIObject
    abstract
    native;

var(Widget) bool bAlwaysTick;
//var delegate<OnFadeCompleted> __OnFadeCompleted__Delegate;

delegate OnFadeCompleted()
{
    //return;    
}
