class ActorFactoryDynamicSM extends ActorFactory
    abstract
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() StaticMesh StaticMesh;
var() Vector DrawScale3D;
var() bool bBlockActors;
var() bool bNoEncroachCheck;
var() bool bNotifyRigidBodyCollision;

defaultproperties
{
    DrawScale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    bBlockActors=true
    bNoEncroachCheck=true
}