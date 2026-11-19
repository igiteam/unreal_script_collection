class SPInterpActor extends InterpActor
    native;

var export editinline SPKynapseComponent KynapseComponent;
/** Set from the owner during initialization. */
var(Kynapse) bool bUseExpensivePathBlocking;
var(Collision) PathBlockingInfo m_pathBlockInfo;

simulated function Destroyed()
{
    m_pathBlockInfo.movingState = 3;
    UpdateOverlappingNavigation(0.0000000, m_pathBlockInfo);
    super(Actor).Destroyed();
    //return;    
}
