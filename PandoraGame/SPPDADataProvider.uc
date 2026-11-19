class SPPDADataProvider extends UIDynamicDataProvider
    transient
    native
    config(Game);

var string ProviderName;
var config array<config PDAMessage> msgList;

event ProviderInstanceBound(Object DataSourceInstance)
{
    //return;    
}
