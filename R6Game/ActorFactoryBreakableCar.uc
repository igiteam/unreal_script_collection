class ActorFactoryBreakableCar extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() R6BreakableCarTemplate m_pBreakableCarTemplate;

defaultproperties
{
    MenuName="Add BreakableCar"
    NewActorClass=Class'R6BreakableCar'
}