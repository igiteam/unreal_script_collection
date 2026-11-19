class ActorFactoryR6Vehicle extends ActorFactoryPhysicsAsset
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() R6VehicleTemplate m_pVehicleTemplate;

defaultproperties
{
    bStartAwake=false
    MenuName="Add Vehicle"
    NewActorClass=Class'R6Vehicle'
}