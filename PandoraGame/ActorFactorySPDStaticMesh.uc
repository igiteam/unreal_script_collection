class ActorFactorySPDStaticMesh extends ActorFactoryStaticMesh
    native
    config(Editor)
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var() SPDestructibleProperties DestructibleProperties;
var() bool bDisablePathBlocking;
var() bool bUseExpensivePathBlocking;

defaultproperties
{
    bCanChangeNewActorClass=false
    MenuName="Add SPDStaticMesh(Destructible)"
    NewActorClass=Class'SPDStaticMesh'
}