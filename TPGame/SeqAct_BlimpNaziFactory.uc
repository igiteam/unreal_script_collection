class SeqAct_BlimpNaziFactory
    //extends SequenceAction
    extends SeqAct_Latent
    native
    dependson(TPAssaultBlimp_Persistent)
	dependson(SeqAct_BlimpNazis);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// struct native BlimpNazisSpawnInfo
// {
//     var() class<WehrmachtPawn> WehrmachtClass;
//     var() ABS_Side             Side;
//     var() AB_Action            InitialAction;
//     var() nopersistentconv array<class<Inventory> > InventoryList;
// 
//     structdefaultproperties
//     {
//         WehrmachtClass=class'WehrmachtPawn'
//     }
// };

var() array<BlimpNazisSpawnInfo>        SpawnInfo;
var() float                             PeripheralVision;
var() float                             SightRadius;
var() export editinline TPSquadSelector SquadType;

var   WehrmachtPawn               SpawnTarget;
var   int                         CurrentIndex;
var   bool                        bDone;

