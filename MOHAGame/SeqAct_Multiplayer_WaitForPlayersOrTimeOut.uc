class SeqAct_Multiplayer_WaitForPlayersOrTimeOut extends SeqAct_Latent
    native
    hidecategories(Object);

var() float timeOutTime;
var() int numPlayersToWaitFor;
var() string Message;
var() string MessageOver;
var float timeSoFar;

defaultproperties
{
    timeOutTime=60.0000000
    numPlayersToWaitFor=2
    VariableLinks=none
    ObjName="Wait for Players or Time out"
    ObjCategory="MPGame"
}