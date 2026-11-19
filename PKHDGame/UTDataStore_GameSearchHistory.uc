class UTDataStore_GameSearchHistory extends UTDataStore_GameSearchPersonal
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var class<UTDataStore_GameSearchFavorites> FavoritesGameSearchDataStoreClass;
var transient UTDataStore_GameSearchFavorites FavoritesGameSearchDataStore;

event Registered(LocalPlayer PlayerOwner)
{
    local DataStoreClient DSClient;

    super(UIDataStore).Registered(PlayerOwner);
    DSClient = GetDataStoreClient();
    // End:0x112
    if(DSClient != none)
    {
        // End:0x58
        if(FavoritesGameSearchDataStoreClass == none)
        {
            FavoritesGameSearchDataStoreClass = Class'UTDataStore_GameSearchFavorites';
        }
        FavoritesGameSearchDataStore = DSClient.CreateDataStore(FavoritesGameSearchDataStoreClass);
        // End:0x112
        if(FavoritesGameSearchDataStore != none)
        {
            FavoritesGameSearchDataStore.HistoryGameSearchDataStore = self;
            FavoritesGameSearchDataStore.PrimaryGameSearchDataStore = PrimaryGameSearchDataStore;
            DSClient.RegisterDataStore(FavoritesGameSearchDataStore, PlayerOwner);
        }
    }
    //return;    
}

function bool HasOutstandingQueries(optional bool bRestrictCheckToSelf)
{
    local bool bResult;

    bResult = super.HasOutstandingQueries(bRestrictCheckToSelf);
    // End:0x7C
    if((!bResult && !bRestrictCheckToSelf) && FavoritesGameSearchDataStore != none)
    {
        bResult = FavoritesGameSearchDataStore.HasOutstandingQueries(true);
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    FavoritesGameSearchDataStoreClass=Class'UTDataStore_GameSearchFavorites'
    GameSearchCfgList=/* Array type was not detected. */
    Tag="UTGameHistory"
}