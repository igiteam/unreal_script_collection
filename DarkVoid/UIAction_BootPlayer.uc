class UIAction_BootPlayer extends UIAction
    native;

var() int PlayerIdx;

event KickPlayer(GameInfo G, string N)
{
    G.Kick(N);
    //return;    
}
