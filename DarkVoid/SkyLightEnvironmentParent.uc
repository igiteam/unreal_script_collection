class SkyLightEnvironmentParent extends Actor
    native
    placeable;

struct native PreviousPrimitiveProperties
{
    var export editinline PrimitiveComponent Component;
    var export editinline PrimitiveComponent ShadowParent;
    var export editinline LightEnvironmentComponent LightEnvironment;

    structdefaultproperties
    {
        Component=none
        ShadowParent=none
        LightEnvironment=none
    }
};

struct native PreviousActorProperties
{
    var Actor Actor;
    var export editinline LightEnvironmentComponent LightEnvironment;
    var array<PreviousPrimitiveProperties> CachedPrimitiveProperties;

    structdefaultproperties
    {
        Actor=none
        LightEnvironment=none
        CachedPrimitiveProperties=none
    }
};

var() array<Actor> LightEnvironmentActors;
var editoronly array<PreviousActorProperties> CachedActorProperties;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var() export editinline DrawBoxComponent DummyComponent;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    InitializeShadowParents();
    // End:0x48
    if(DynamicLightEnvironmentComponent(LightEnvironment).bForcePostUpdate)
    {
        LightEnvironment.SetTickGroup(3);
        DummyComponent.SetTickGroup(3);
    }
    //return;    
}

// Export USkyLightEnvironmentParent::execInitializeShadowParents(FFrame&, void* const)
native final function InitializeShadowParents();
