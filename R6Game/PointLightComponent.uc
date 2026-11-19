class PointLightComponent extends LightComponent
    native
    editinlinenew
    hidecategories(Object);

var() float Radius;
var() float FallOff;
var const Matrix CachedParentToWorld;
var() const Vector Translation;

// Export UPointLightComponent::execSetTranslation(FFrame&, void* const)
native function SetTranslation(Vector NewTranslation);
