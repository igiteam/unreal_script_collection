class UIDataStore_MOHAPlayerData extends UIDataStore_OnlinePlayerData
    transient
    native
    config(Engine)
    hidecategories(Object,UIRoot);

event OnRegister(LocalPlayer InPlayer)
{
    super.OnRegister(InPlayer);
    //return;    
}

event OnUnregister()
{
    super.OnUnregister();
    //return;    
}

event RegisterDelegates()
{
    ProfileProvider.AddPropertyNotificationChangeRequest(OnProviderChanged);
    //return;    
}

defaultproperties
{
    Tag="MOHAPlayerData"
}