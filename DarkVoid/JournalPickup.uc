class JournalPickup extends SkyBonusPickupFactory;

var(Bonus) int journalId;

event OnPickupBonus(SkyPlayerControllerBase C)
{
    C.FoundJournalEntry(journalId);
    //return;    
}

event bool BonusIsValid(SkyPlayerControllerBase C)
{
    // End:0x2A
    if(C != none)
    {
        return !C.HasJournalEntry(journalId);        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}
