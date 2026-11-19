class PPA_Melee extends EPA_Melee;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local PKAIController PKAI;

    // End:0xEA
    if(AIOwner != none)
    {
        PKAI = PKAIController(AIOwner);
        // End:0xEA
        if(PKAI != none)
        {
            bShouldLoop = PKAIController(AIOwner).ContinousAttack;
            // End:0xEA
            if(PKGame(PKAI.WorldInfo.Game).bConfuseEnemies)
            {
                SpeedModifier = PKAI.ConfusedAttackSpeedScaling;
            }
        }
    }
    super.PawnActionStarted(bForced, PrevAction);
    //return;    
}
