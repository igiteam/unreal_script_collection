class UIDataStore_Script extends UIDataStore
    transient
    native
    hidecategories(Object,UIRoot);

var array<UIDataProviderField> DataFields;

event bool GetFieldValue(string FieldName, out string OutFieldValue, optional int ArrayIndex = -1)
{
    //return ReturnValue;    
}

event bool SetFieldValue(string FieldName, string OutFieldValue, optional int ArrayIndex = -1)
{
    //return ReturnValue;    
}

defaultproperties
{
    WriteAccessType=1
}