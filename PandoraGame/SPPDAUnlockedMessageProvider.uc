class SPPDAUnlockedMessageProvider extends SPPDADataProvider
    transient
    native
    config(Game);

var string NewMail_Markup;
var string ViewedMail_Markup;
var string CriticalMail_Markup;
var string RegularFont_Markup;
var string BoldFont_Markup;
var string FontEnd_Markup;
var string NewMsgStyle_Markup;
var string NormalMsgStyle_Markup;
var string EndStyle_Markup;

event ProviderInstanceBound(Object DataSourceInstance)
{
    //return;    
}
