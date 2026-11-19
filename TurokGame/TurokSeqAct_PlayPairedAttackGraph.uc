class TurokSeqAct_PlayPairedAttackGraph extends SequenceAction
    hidecategories(Object);

var @NULL mTurokPawnDefender;
var @NULL mTurokPawnDinoAttacker;
var() bool mbCheckAnimWillEndOkay;
var() name mGraphName;
var() @NULL mGraphSet;

event Activated()
{
    local bool bPlayGraph;
    local @NULL mGraph, mPredController;
    local array endGraphs;

    endGraphs.Length = 0;
    bPlayGraph = true;
    // End:0x13A
    if((mTurokPawnDinoAttacker != none) && mTurokPawnDefender != none)
    {
        mPredController = TurokAIControllerPredator(mTurokPawnDinoAttacker.Controller);
        // End:0x54
        if(mPredController == none)
        {
            bPlayGraph = false;
        }
        // End:0x99
        if(bPlayGraph)
        {
            // End:0x99
            if(mGraphSet != none)
            {
                mGraph = mGraphSet.FindGraph(mGraphName);
                // End:0x99
                if(mGraph == none)
                {
                    bPlayGraph = false;
                }
            }
        }
        // End:0xDE
        if(bPlayGraph && mbCheckAnimWillEndOkay)
        {
            // End:0xDE
            if(!mGraph.CollisionOK(mTurokPawnDinoAttacker, mTurokPawnDefender, endGraphs, 0))
            {
                bPlayGraph = false;
            }
        }
        // End:0x13A
        if(bPlayGraph)
        {
            mTurokPawnDinoAttacker.mTargetingSystem.SetTarget(mPredController, mTurokPawnDefender);
            mPredController.mPreselectedGraph = mGraph;
            mPredController.GotoState('AttackActionGraph');
        }
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Defender",LinkVar="None",PropertyName="mTurokPawnDefender",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Attacker",LinkVar="None",PropertyName="mTurokPawnDinoAttacker",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Play Paired Attack Graph"
    ObjCategory="Turok AI"
}