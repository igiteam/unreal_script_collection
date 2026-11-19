class AdvPartyPRI extends AdvPRI
    hidecategories(Navigation,Movement,Collision);

var int MutatorsUnlockedBitfield;

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
    return false;
    //return ReturnValue;    
}
