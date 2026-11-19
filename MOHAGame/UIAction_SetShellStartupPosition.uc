class UIAction_SetShellStartupPosition extends UIAction
    hidecategories(Object);

var() MOHAIncludeClass.EShellStartPosition startposition;

event Activated()
{
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x65
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0x65
        if(GameDataStore != none)
        {
            GameDataStore.ShellStartPos = int(startposition);
        }
    }
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Set Shell Startup Position"
}