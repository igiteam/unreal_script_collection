class UIAction_ClearExclusionList extends UIAction
    hidecategories(Object);

event Activated()
{
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x60
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0x60
        if(GameDataStore != none)
        {
            GameDataStore.ExclusionList.Length = 0;
        }
    }
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Clear Weapon Exclusion List"
}