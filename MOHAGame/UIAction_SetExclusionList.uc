class UIAction_SetExclusionList extends UIAction
    hidecategories(Object);

var() editinline array<editinline MOHAIncludeClass.EWeaponType> WeaponExclusionList;
var array<int> ExtraExclusionTypes;

event Activated()
{
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;
    local int I;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xE0
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0xE0
        if(GameDataStore != none)
        {
            GameDataStore.ExclusionList.Length = 0;
            I = 0;
            J0x67:

            // End:0xA1 [Loop If]
            if(I < WeaponExclusionList.Length)
            {
                GameDataStore.AddExcludedWeapon(int(WeaponExclusionList[I]));
                I++;
                // [Loop Continue]
                goto J0x67;
            }
            I = 0;
            J0xA8:

            // End:0xE0 [Loop If]
            if(I < ExtraExclusionTypes.Length)
            {
                GameDataStore.AddExcludedWeapon(ExtraExclusionTypes[I]);
                I++;
                // [Loop Continue]
                goto J0xA8;
            }
        }
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Excluded Weapons",LinkVar="None",PropertyName="ExtraExclusionTypes",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Weapon Exclusion List"
}