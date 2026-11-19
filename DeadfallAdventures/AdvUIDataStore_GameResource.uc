class AdvUIDataStore_GameResource extends UIDataStore_GameResource
    transient
    native(UIPrivate)
    config(Game)
    hidecategories(Object,UIRoot);

static function AdvGamePlaylistGameTypeProvider GetPlaylistGameTypeProviderByIndex(int ProviderIndex)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> PlaylistGameTypeProviders;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0xE5
    if(GameResourceDS != none)
    {
        // End:0xE5
        if(GameResourceDS.GetResourceProviders('PlaylistGameTypes', PlaylistGameTypeProviders))
        {
            // End:0xC8
            if((ProviderIndex < 0) || ProviderIndex >= PlaylistGameTypeProviders.Length)
            {
                ProviderIndex = 0;
            }
            return AdvGamePlaylistGameTypeProvider(PlaylistGameTypeProviders[ProviderIndex]);
        }
    }
    return none;
    //return ReturnValue;    
}

static function AdvGamePlaylistGameTypeProvider GetPlaylistGameTypeProviderById(int ProviderId)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> PlaylistGameTypeProviders;
    local int I;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x121
    if(GameResourceDS != none)
    {
        // End:0x121
        if(GameResourceDS.GetResourceProviders('PlaylistGameTypes', PlaylistGameTypeProviders))
        {
            I = 0;
            J0x9F:

            // End:0x121 [Loop If]
            if(I < PlaylistGameTypeProviders.Length)
            {
                // End:0x113
                if(AdvGamePlaylistGameTypeProvider(PlaylistGameTypeProviders[I]).GameTypeId == ProviderId)
                {
                    return AdvGamePlaylistGameTypeProvider(PlaylistGameTypeProviders[I]);
                }
                ++I;
                // [Loop Continue]
                goto J0x9F;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

static function int GetGameTypeProviderIndex(AdvTypes.EMultiGameMode GameType)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> Providers;
    local int I;
    local AdvGameInfoSummary CurrGameType;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x136
    if(GameResourceDS != none)
    {
        // End:0x136
        if(GameResourceDS.GetResourceProviders('GameTypes', Providers))
        {
            I = 0;
            J0x9F:

            // End:0x136 [Loop If]
            if(I < Providers.Length)
            {
                CurrGameType = AdvGameInfoSummary(Providers[I]);
                // End:0x128
                if((CurrGameType != none) && int(CurrGameType.MPGameMode) == int(GameType))
                {
                    return I;
                }
                ++I;
                // [Loop Continue]
                goto J0x9F;
            }
        }
    }
    return -1;
    //return ReturnValue;    
}

static function int GetGameTypeProvidersCount()
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> Providers;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x9F
    if(GameResourceDS != none)
    {
        // End:0x9F
        if(GameResourceDS.GetResourceProviders('GameTypes', Providers))
        {
            return Providers.Length;
        }
    }
    return 0;
    //return ReturnValue;    
}

static function AdvGameInfoSummary GetGameTypeProvider(AdvTypes.EMultiGameMode GameType)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> Providers;
    local int ProviderIndex;
    local AdvGameInfoSummary GameSummaryInfo;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x125
    if(GameResourceDS != none)
    {
        // End:0x125
        if(GameResourceDS.GetResourceProviders('GameTypes', Providers))
        {
            ProviderIndex = 0;
            J0x9F:

            // End:0x125 [Loop If]
            if(ProviderIndex < Providers.Length)
            {
                GameSummaryInfo = AdvGameInfoSummary(Providers[ProviderIndex]);
                // End:0x117
                if(int(GameSummaryInfo.MPGameMode) == int(GameType))
                {
                    return GameSummaryInfo;
                }
                ++ProviderIndex;
                // [Loop Continue]
                goto J0x9F;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

static function AdvGameInfoSummary GetGameTypeProviderUsingProviderIndex(int ProviderIndex)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local array<UIResourceDataProvider> Providers;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0xB1
    if(GameResourceDS != none)
    {
        // End:0xB1
        if(GameResourceDS.GetResourceProviders('GameTypes', Providers))
        {
            return AdvGameInfoSummary(Providers[ProviderIndex]);
        }
    }
    return none;
    //return ReturnValue;    
}

static function int ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderId(OnlinePlaylistProvider PlaylistProvider, int GameTypeNameIndex)
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local name NameId;
    local array<UIResourceDataProvider> PlaylistGameTypeProviders;
    local int I;
    local AdvGamePlaylistGameTypeProvider PlaylistGameType;

    // End:0x70
    if((GameTypeNameIndex >= 0) && GameTypeNameIndex < PlaylistProvider.PlaylistGameTypeNames.Length)
    {
        NameId = PlaylistProvider.PlaylistGameTypeNames[GameTypeNameIndex];
    }
    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x1B7
    if(GameResourceDS != none)
    {
        // End:0x1B7
        if(GameResourceDS.GetResourceProviders('PlaylistGameTypes', PlaylistGameTypeProviders))
        {
            I = 0;
            J0x10F:

            // End:0x1B7 [Loop If]
            if(I < PlaylistGameTypeProviders.Length)
            {
                PlaylistGameType = AdvGamePlaylistGameTypeProvider(PlaylistGameTypeProviders[I]);
                // End:0x1A9
                if((PlaylistGameType != none) && PlaylistGameType.Name == NameId)
                {
                    return PlaylistGameType.GameTypeId;
                }
                ++I;
                // [Loop Continue]
                goto J0x10F;
            }
        }
    }
    return 0;
    //return ReturnValue;    
}

// Export UAdvUIDataStore_GameResource::execInitializeProvidersInternal(FFrame&, void* const)
private native final function InitializeProvidersInternal();

static function InitializeProviders()
{
    local AdvUIDataStore_GameResource GameResourceDS;

    GameResourceDS = AdvUIDataStore_GameResource(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'AdvUIDataStore_GameResource'.default.Tag));
    // End:0x7F
    if(GameResourceDS != none)
    {
        GameResourceDS.InitializeProvidersInternal();
    }
    //return;    
}

defaultproperties
{
    ElementProviderTypes=/* Array type was not detected. */
}