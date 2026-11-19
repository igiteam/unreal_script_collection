//-----------------------------------------------------------
// PNode Evaluators are connected to PNodes in order to
// chain logical conditions together that the PNode evaluates
// on an object
//-----------------------------------------------------------
class TpPNodeEvaluator extends TPAnimNodeConnectableBase
	native;

native function bool CanUsePerformance( TPPerformance perf, string strCondition );

