class GlobalStatsDataProvider extends UIDataProvider
    transient
    native
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var export editinline MOHAPlayerStatsComponent pStatsData;

function CleanupDataProvider()
{
    pStatsData = none;
    //return;    
}

function BindDataProvider(MOHAPlayerStatsComponent StatsData)
{
    // End:0x16
    if(StatsData != none)
    {
        pStatsData = StatsData;
    }
    //return;    
}
