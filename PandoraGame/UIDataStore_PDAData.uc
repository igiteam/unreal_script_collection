class UIDataStore_PDAData extends UIDataStore_GameState
    transient
    native;

struct native SPPDADataProviderTypes
{
    var const class<SPPDAObjectiveProvider> SPPDAObjectiveProviderClass;
    var const class<SPPDAEquipmentProvider> SPPDAEquipmentProviderClass;
    var const class<SPPDACreatureProvider> SPPDACreatureProviderClass;
    var const class<SPPDAContactProvider> SPPDAContactProviderClass;
    var const class<SPPDAUnlockedMessageProvider> SPPDAUnlockedMessageProviderClass;

    structdefaultproperties
    {
        SPPDAObjectiveProviderClass=none
        SPPDAEquipmentProviderClass=none
        SPPDACreatureProviderClass=none
        SPPDAContactProviderClass=none
        SPPDAUnlockedMessageProviderClass=none
    }
};

var private native const noexport Pointer VfTable_IUIListElementProvider;
var const SPPDADataProviderTypes ProviderTypes;
var protected SPPDAObjectiveProvider objectiveData;
var protected SPPDAEquipmentProvider equipData;
var protected SPPDACreatureProvider creatureData;
var protected SPPDAContactProvider contactData;
var protected SPPDAUnlockedMessageProvider UnlockedMsgsData;

final function CreatePDADataProvider()
{
    objectiveData = new ProviderTypes.SPPDAObjectiveProviderClass;
    equipData = new ProviderTypes.SPPDAEquipmentProviderClass;
    creatureData = new ProviderTypes.SPPDACreatureProviderClass;
    contactData = new ProviderTypes.SPPDAContactProviderClass;
    UnlockedMsgsData = new ProviderTypes.SPPDAUnlockedMessageProviderClass;
    // End:0x92
    if(objectiveData == none)
    {
    }
    // End:0x9D
    if(equipData == none)
    {
    }
    // End:0xA8
    if(creatureData == none)
    {
    }
    // End:0xB3
    if(contactData == none)
    {
    }
    // End:0xBE
    if(UnlockedMsgsData == none)
    {
    }
    //return;    
}

final function SPPDAObjectiveProvider GetPDAObjectiveDataProvider()
{
    return objectiveData;
    //return ReturnValue;    
}

final function SPPDAEquipmentProvider GetPDAEquipmentDataProvider()
{
    return equipData;
    //return ReturnValue;    
}

final function SPPDACreatureProvider GetPDACreatureDataProvider()
{
    return creatureData;
    //return ReturnValue;    
}

final function SPPDAContactProvider GetPDAContactDataProvider()
{
    return contactData;
    //return ReturnValue;    
}

final function SPPDAUnlockedMessageProvider GetPDAUnlockedMessageDataProvider()
{
    return UnlockedMsgsData;
    //return ReturnValue;    
}

final function ClearDataProviders()
{
    // End:0x1F
    if(objectiveData != none)
    {
        objectiveData.CleanupDataProvider();
    }
    objectiveData = none;
    // End:0x45
    if(equipData != none)
    {
        equipData.CleanupDataProvider();
    }
    equipData = none;
    // End:0x6B
    if(creatureData != none)
    {
        creatureData.CleanupDataProvider();
    }
    creatureData = none;
    // End:0x91
    if(contactData != none)
    {
        contactData.CleanupDataProvider();
    }
    contactData = none;
    // End:0xB7
    if(UnlockedMsgsData != none)
    {
        UnlockedMsgsData.CleanupDataProvider();
    }
    UnlockedMsgsData = none;
    //return;    
}

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return false;
    //return ReturnValue;    
}
