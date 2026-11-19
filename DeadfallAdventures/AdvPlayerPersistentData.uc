class AdvPlayerPersistentData extends OnlinePlayerStorage
    native;

// Export UAdvPlayerPersistentData::execAddSettingBlob(FFrame&, void* const)
native function AddSettingBlob(int SettingId);

// Export UAdvPlayerPersistentData::execGetBlob(FFrame&, void* const)
native function bool GetBlob(int ProfileSettingId, out array<byte> Blob);

// Export UAdvPlayerPersistentData::execSetBlob(FFrame&, void* const)
native function bool SetBlob(int ProfileSettingId, out array<byte> Blob);

simulated function int GetValue(int PersistentDataID)
{
    local int Data;

    // End:0x29
    if(GetProfileSettingValueInt(PersistentDataID, Data))
    {
        return Data;
    }
    AddSettingInt(PersistentDataID);
    return 0;
    //return ReturnValue;    
}

simulated function SetValue(int PersistentDataID, int NewValue)
{
    local int OldValue;

    OldValue = GetValue(PersistentDataID);
    // End:0x50
    if(NewValue != OldValue)
    {
        SetProfileSettingValueInt(PersistentDataID, NewValue);
    }
    //return;    
}

simulated function bool GetBlobValue(int PersistentDataID, out array<byte> Blob)
{
    // End:0x21
    if(GetBlob(PersistentDataID, Blob))
    {
        return true;
    }
    AddSettingInt(PersistentDataID);
    return false;
    //return ReturnValue;    
}

simulated function SetBlobValue(int PersistentDataID, array<byte> Blob)
{
    SetBlob(PersistentDataID, Blob);
    //return;    
}

simulated function ClearData()
{
    //return;    
}

defaultproperties
{
    VersionNumber=11
}