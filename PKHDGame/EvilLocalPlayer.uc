class EvilLocalPlayer extends LocalPlayer within Engine
    transient
    config(Engine);

var string PlayerPawnClass;
var transient float LastSaveTime;

defaultproperties
{
    PlayerPawnClass="EvilGameContent.EvilPawn_Tom"
}