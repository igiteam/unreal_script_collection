class SPBaseFlyZone extends TriggerVolume
    abstract
    native;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(Debug) transient bool bShowExtents;
var MaterialInterface FlightVolumeMaterial;
var MaterialInterface FlightPortalMaterial;
var export editinline SpriteComponent SpriteComponent;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}
