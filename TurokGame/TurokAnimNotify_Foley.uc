class TurokAnimNotify_Foley extends TurokAnimNotify_Sound
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

simulated event Notify(@NULL Owner, @NULL SkelComponent)
{
    local @NULL Player;

    Player = TurokPawn(Owner);
    // End:0x2E
    if(Player != none)
    {
        Player.PlayFoleySound();
    }
    //return;    
}

defaultproperties
{
    SoundCue=SoundCue'SndCreatureHuman.CreatureHumanFoleyMediumSndCue'
}