class SeqAct_BlimpNazis 
    extends SequenceAction
    dependson(TPAssaultBlimp_Persistent)
	native;


struct native BlimpNazisSpawnInfo
{
    var() class<WehrmachtPawn> WehrmachtClass;
    var() ABS_Side             Side;
    var() AB_Action            InitialAction;
    var() nopersistentconv array<class<Inventory> > InventoryList;

    structdefaultproperties
    {
        WehrmachtClass=class'WehrmachtPawn'
    }
};

struct native BlimpNazisActionInfo
{
    var() ABS_Side   Side;
    var() AB_Action NewAction;
    var() int       HowManyToModify;
};

// struct BlimpNazisActionInfo
// {
//     var() ABS_Side   Side;
//     var() AB_Action NewAction;
//     var() int       Count;
// };

var() array<BlimpNazisSpawnInfo>  SpawnInfo;
var() array<BlimpNazisActionInfo> ActionInfo;

