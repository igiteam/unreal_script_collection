class SeqVar_R6CoopPlayerPawn extends SeqVar_R6Pawn
    native
    hidecategories(Object);

var() R6EngineEnums.ECoopPlayers m_eCoopPlayer;

event string GetValueName()
{
    return string(m_eCoopPlayer);
    return;
}

defaultproperties
{
    ObjName="Coop Player Pawn"
}