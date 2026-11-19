class RB_RadialImpulseComponent extends PrimitiveComponent
    native
    collapsecategories
    hidecategories(Object);

var() PrimitiveComponent.ERadialImpulseFalloff ImpulseFalloff;
var() float ImpulseStrength;
var() float ImpulseRadius;
var() bool bVelChange;
var export editinline DrawSphereComponent PreviewSphere;

// Export URB_RadialImpulseComponent::execFireImpulse(FFrame&, void* const)
native function FireImpulse(Vector Origin);
