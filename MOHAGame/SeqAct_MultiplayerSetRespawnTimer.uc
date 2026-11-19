class SeqAct_MultiplayerSetRespawnTimer extends SequenceAction
    native
    hidecategories(Object);

var() int Track;
var() float AxisRespawnTime;
var() float AlliedRespawnTime;

defaultproperties
{
    VariableLinks=none
    ObjName="Set Respawn Timer"
    ObjCategory="MPGame"
}