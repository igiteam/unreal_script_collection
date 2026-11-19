class UIDataStore_MOHAPlayerStats extends UIDataStore
    transient
    native
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

var private native const noexport Pointer VfTable_IUIListElementProvider;
var GlobalStatsDataProvider GlobalStatsProvider;
var MissionStatsDataProvider MissionStatsProvider;
var GlobalMPStatsDataProvider GlobalMPStatsProvider;
var MissionMPStatsDataProvider MissionMPStatsProvider;

final function ClearDataProviders()
{
    // End:0x1E
    if(GlobalStatsProvider != none)
    {
        GlobalStatsProvider.CleanupDataProvider();
    }
    // End:0x3C
    if(MissionStatsProvider != none)
    {
        MissionStatsProvider.CleanupDataProvider();
    }
    // End:0x5A
    if(GlobalMPStatsProvider != none)
    {
        GlobalMPStatsProvider.CleanupDataProvider();
    }
    // End:0x78
    if(MissionMPStatsProvider != none)
    {
        MissionMPStatsProvider.CleanupDataProvider();
    }
    GlobalStatsProvider = none;
    MissionStatsProvider = none;
    GlobalMPStatsProvider = none;
    MissionMPStatsProvider = none;
    //return;    
}

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return super.NotifyGameSessionEnded();
    //return ReturnValue;    
}

function bool IsMedalAwarded(MOHAIncludeClass.EMedalTypeSP Medal)
{
    // End:0x55
    if((GlobalStatsProvider != none) && GlobalStatsProvider.pStatsData != none)
    {
        return GlobalStatsProvider.pStatsData.PRI.SPStatsMedal[int(Medal)].bHasMedal;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    Tag="MOHAPlayerStats"
}