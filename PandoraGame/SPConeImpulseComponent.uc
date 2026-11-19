class SPConeImpulseComponent extends RB_RadialImpulseComponent
    native
    collapsecategories;

var() float AngleInDegrees;
var float AngleDot;
//var delegate<ShouldApplyImpulseToCallback> __ShouldApplyImpulseToCallback__Delegate;

delegate bool ShouldApplyImpulseToCallback(PrimitiveComponent Component)
{
    //return ReturnValue;    
}

// Export USPConeImpulseComponent::execFireImpulse(FFrame&, void* const)
native function FireImpulse(Vector Origin);

function bool DefaultShouldApplyImpulseToCallback(PrimitiveComponent Component)
{
    return true;
    //return ReturnValue;    
}

event bool ShouldApplyImpulseTo(PrimitiveComponent Component)
{
    return ShouldApplyImpulseToCallback(Component);
    //return ReturnValue;    
}
