class TurokAnimNotify_StopGroggy extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

simulated event Notify(@NULL Owner, @NULL SkelComponent)
{
    local @NULL Player;

    Player = TurokPawnPlayer(Owner);
    // End:0x2E
    if(Player != none)
    {
        Player.StopGroggySound();
    }
    //return;    
}
