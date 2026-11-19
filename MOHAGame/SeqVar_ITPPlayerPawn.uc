class SeqVar_ITPPlayerPawn extends SeqVar_Object
    native
    hidecategories(Object);

var transient array<MOHAPlayerPawn> Players;
var() bool bAllPlayers;
var() int PlayerIdx;

defaultproperties
{
    ObjName="MOHAPlayerPawn"
}