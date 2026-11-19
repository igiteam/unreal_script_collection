class PKUIDataProvider_DLCCardInfo extends UDKUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config int CardIndex;
var config bool bIsSilver;
var config bool bIsGold;
var config bool bCardPurchased;

defaultproperties
{
    bSearchAllInis=true
}