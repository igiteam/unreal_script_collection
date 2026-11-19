class ActorFactoryAI extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() class<AIController> ControllerClass;
var() class<Pawn> PawnClass;
var() string PawnName;
var() array< class<Inventory> > InventoryList;
var() int TeamIndex;

defaultproperties
{
    ControllerClass=Class'AIController'
    PawnClass=Class'Pawn'
    TeamIndex=255
    bPlaceable=false
}