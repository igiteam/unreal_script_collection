class SeqAct_ShimmyControl
    extends SeqAct_Latent;

enum eShimmyAction {SA_Left, SA_Right, SA_PullUp, SA_Drop};

struct ShimmyAction
{
    var() eShimmyAction Shimmy;
    var() float         Distance;
};

var() array<ShimmyAction> Action;

var   int                 CurrentIndex;
var   float               TotalDistance;

