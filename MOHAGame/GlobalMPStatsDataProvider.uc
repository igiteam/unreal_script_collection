class GlobalMPStatsDataProvider extends UIDataProvider
    transient
    native
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var Plasma myPlasma;

function CleanupDataProvider()
{
    myPlasma = none;
    //return;    
}

function BindDataProvider(Plasma P)
{
    // End:0x19
    if(P != none)
    {
        myPlasma = P;        
    }
    //return;    
}

event float GetStatValue(string statName)
{
    return myPlasma.GetStatValue(statName);
    //return ReturnValue;    
}
