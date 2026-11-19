class SPStoryDataProvider extends UIDynamicDataProvider
    transient
    native;

var SPPDAMessage StoryDataSource;

event ProviderInstanceBound(Object DataSourceInstance)
{
    local SPPDAMessage msg;

    msg = SPPDAMessage(DataSourceInstance);
    // End:0x26
    if(msg != none)
    {
        StoryDataSource = msg;
    }
    //return;    
}
