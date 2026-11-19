class SkyActorFactoryAI extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() class<AIController> ControllerClass;
var() AIController ControllerArchetype;
var() SkyPawn PawnArchetype;
var() string PawnName;
var() bool bGiveDefaultInventory;
var() array<Inventory> InventoryList;
var() int TeamIndex;
var() SkyItem_RocketPack RocketPackArchetype;
var() array<name> NavigationSets;
