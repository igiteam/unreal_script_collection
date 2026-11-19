class SeqAct_StartBombGoBoomGame extends SeqAct_StartBombGoBoomGamePersistent;

enum eColor {XB_Red, XB_Green, XB_Blue, XB_Yellow};

var() struct BombGameType
{
    var() bool   bRandomGame;

    var() eColor PegTop;
    var() eColor PegMid;
    var() eColor PegLow;

    var() eColor WireTop;
    var() eColor WireMid;
    var() eColor WireLow;

    structdefaultproperties
    {
        PegTop  = XB_Red
        PegMid  = XB_Green
        PegLow  = XB_Blue
        WireTop = XB_Red
        WireMid = XB_Green
        WireLow = XB_Blue
    }

} BombGameOptions;

var BombGoBoomGame BGBGame;
var TPBombGameProp bombProp;



function BombGoBoomInteraction GetInteraction(GameViewportClient viewport)
{
    if (BGBGame == None)
    {
        BGBGame = new(viewport) class'BombGoBoomGame';
    }

    BGBGame.SetBombProp(bombProp);
    BGBGame.SetSeqAct(self);
 
    return BGBGame;
}

