class SeqAct_BlimpNaziModifier
    extends SequenceAction
    dependson(TPAssaultBlimp_Persistent)
	dependson(SeqAct_BlimpNazis)
	native;

// native struct BlimpNazisActionInfo
// {
//     var() ABS_Side   Side;
//     var() AB_Action NewAction;
//     var() int       HowManyToModify;
// };

var() array<BlimpNazisActionInfo> NewBehaviorInfo;

