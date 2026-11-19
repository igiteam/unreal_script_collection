class SPStoryDataStore extends UIDataStore_GameState
    transient
    native;

struct native SPStoryDataProviderTypes
{
    var const class<SPStoryDataProvider> SPStoryDataProviderClass;

    structdefaultproperties
    {
        SPStoryDataProviderClass=none
    }
};

var const SPStoryDataProviderTypes ProviderTypes;
var protected SPStoryDataProvider StoryData;

final function CreateStoryDataProvider(SPPDAMessage msg)
{
    // End:0x43
    if(msg != none)
    {
        StoryData = new ProviderTypes.SPStoryDataProviderClass;
        // End:0x40
        if(!StoryData.BindProviderInstance(msg))
        {
        }        
    }
    //return;    
}

final function SPStoryDataProvider GetStoryDataProvider()
{
    return StoryData;
    //return ReturnValue;    
}

final function ClearDataProviders()
{
    // End:0x1F
    if(StoryData != none)
    {
        StoryData.CleanupDataProvider();
    }
    StoryData = none;
    //return;    
}

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return false;
    //return ReturnValue;    
}
