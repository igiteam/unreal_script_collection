class PPA_FarAttackPrepare extends EPA_BasePlaySingleASTAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    PawnActionFlags = PawnOwner.GetFarAttackPreparePackedIndex();
    super.PawnActionStarted(bForced, PrevAction);
    //return;    
}

defaultproperties
{
    DefaultAICommand=none
}