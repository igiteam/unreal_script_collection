class EvilNavMeshGame extends EvilGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

defaultproperties
{
    DefaultPawnClass=Class'EvilNavMeshPlayerPawn'
    PlayerControllerClass=Class'EvilNavMeshPlayerController'
}