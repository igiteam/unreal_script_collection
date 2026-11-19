class UTDataStore_GameSearchFavorites extends UTDataStore_GameSearchPersonal
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var transient UTDataStore_GameSearchHistory HistoryGameSearchDataStore;

function bool HasOutstandingQueries(optional bool bRestrictCheckToSelf)
{
    local bool bResult;

    bResult = super.HasOutstandingQueries(bRestrictCheckToSelf);
    // End:0x7C
    if((!bResult && !bRestrictCheckToSelf) && HistoryGameSearchDataStore != none)
    {
        bResult = HistoryGameSearchDataStore.HasOutstandingQueries(true);
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    GameSearchCfgList=/* Array type was not detected. */
    Tag="UTGameFavorites"
}