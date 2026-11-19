class APA_EmergeFrozen extends EPA_Emerge;

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    local AdvPawn_SkinnyMummy_Base MummyPawn;

    super.PawnActionEnded(PrevMove, NextMove);
    MummyPawn = AdvPawn_SkinnyMummy_Base(PawnOwner);
    // End:0x116
    if(MummyPawn != none)
    {
        MummyPawn.SetFrozenEffect(false);
        MummyPawn.bFlashlightBeamActive = false;
        MummyPawn.bInFlashlightCone = false;
        MummyPawn.ClearTimer('LightDissolve_T');
        MummyPawn.LightDissolveAlpha = 0.0000000;
        MummyPawn.UpdateLightDissolveMaterialEffect();
    }
    //return;    
}

defaultproperties
{
    ReactCondClass=Class'EvilGame.EvilAIReactCond_EmergeEnemyBurned'
}