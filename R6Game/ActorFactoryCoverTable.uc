class ActorFactoryCoverTable extends ActorFactoryDynamicSM
    native
    config(Game)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() R6_BreakableActorTemplate BreakableActorTemplate;

defaultproperties
{
    MenuName="Add CoverTable"
    NewActorClass=Class'R6CoverTable'
}