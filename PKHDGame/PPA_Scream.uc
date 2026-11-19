class PPA_Scream extends EPA_Scream;

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EPA_BasePlaySingleASTAnim).PawnActionEnded(PrevMove, NextMove);
    // End:0x5C
    if(PKPawn(PawnOwner) != none)
    {
        PKPawn(PawnOwner).OnScreamAttackEnd();
    }
    //return;    
}

defaultproperties
{
    DefaultAICommand=none
    bLockPawnRotation=false
    bDisableMovement=false
    bDisableIK=false
}