class UTDataStore_GameSearchPersonal extends UDKDataStore_GameSearchBase
    abstract
    transient
    config(Game)
    hidecategories(Object,UIRoot);

const MAX_PERSONALSERVERS = 15;

var transient UDKDataStore_GameSearchBase PrimaryGameSearchDataStore;
var config string ServerUniqueId[15];

function bool HasOutstandingQueries(optional bool bRestrictCheckToSelf)
{
    local bool bResult;

    bResult = super.HasOutstandingQueries(bRestrictCheckToSelf);
    // End:0x7C
    if((!bResult && !bRestrictCheckToSelf) && PrimaryGameSearchDataStore != none)
    {
        bResult = PrimaryGameSearchDataStore.HasOutstandingQueries(true);
    }
    return bResult;
    //return ReturnValue;    
}

protected function bool OverrideQuerySubmission(byte ControllerId, OnlineGameSearch Search)
{
    local int I;
    local string QueryString;
    local UTGameSearchPersonal HistorySearch;
    local array<string> HistoryList;

    HistorySearch = UTGameSearchPersonal(Search);
    // End:0x101
    if(HistorySearch != none)
    {
        GetServerStringList(HistoryList);
        I = 0;
        J0x49:

        // End:0xD9 [Loop If]
        if(I < HistoryList.Length)
        {
            // End:0x8A
            if(QueryString != "")
            {                
                QueryString $= "OR";
            }            
            QueryString $= (("(OwningPlayerId=" $ HistoryList[I]) $ ")");
            I++;
            // [Loop Continue]
            goto J0x49;
        }
        Search.AdditionalSearchCriteria = QueryString;
    }
    // End:0x144
    if(QueryString == "")
    {
        Search.AdditionalSearchCriteria = "(OwningPlayerId=1)";
    }
    return false;
    //return ReturnValue;    
}

function string GetPlayerName(optional int ControllerId = 0)
{
    local string Result;
    local OnlinePlayerInterface PlayerInt;

    PlayerInt = OnlineSub.PlayerInterface;
    // End:0x82
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
        Result = PlayerInt.GetPlayerNickname(byte(ControllerId));
    }
    return Result;
    //return ReturnValue;    
}

function bool GetPlayerNetId(out UniqueNetId out_PlayerId, optional int ControllerId = 0)
{
    local bool bResult;
    local OnlinePlayerInterface PlayerInt;

    PlayerInt = OnlineSub.PlayerInterface;
    // End:0x8C
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
        bResult = PlayerInt.GetUniquePlayerId(byte(ControllerId), out_PlayerId);
    }
    return bResult;
    //return ReturnValue;    
}

function int FindServerIndexByString(int ControllerId, string IdToFind)
{
    local int I, Result;

    Result = -1;
    I = 0;
    J0x1A:

    // End:0x6F [Loop If]
    if(I < 15)
    {
        // End:0x61
        if(ServerUniqueId[I] == IdToFind)
        {
            Result = I;
            // [Explicit Break]
            goto J0x6F;
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    J0x6F:

    return Result;
    //return ReturnValue;    
}

function int FindServerIndexById(int ControllerId, const out UniqueNetId IdToFind)
{
    return FindServerIndexByString(ControllerId, Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(IdToFind));
    //return ReturnValue;    
}

function bool AddServer(int ControllerId, UniqueNetId IdToAdd)
{
    local int I, CurrentIndex;
    local string UniqueIdString;
    local bool bResult;

    UniqueIdString = Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(IdToAdd);
    CurrentIndex = FindServerIndexByString(ControllerId, UniqueIdString);
    // End:0x7A
    if(CurrentIndex == -1)
    {
        CurrentIndex = 15 - 1;
    }
    // End:0x111
    if(CurrentIndex != 0)
    {
        I = CurrentIndex;
        J0x9C:

        // End:0xE3 [Loop If]
        if(I > 0)
        {
            ServerUniqueId[I] = ServerUniqueId[I - 1];
            I--;
            // [Loop Continue]
            goto J0x9C;
        }
        ServerUniqueId[0] = UniqueIdString;
        SaveConfig();
        bResult = true;
        InvalidateCurrentSearchResults();
    }
    return bResult;
    //return ReturnValue;    
}

function bool RemoveServer(int ControllerId, UniqueNetId IdToRemove)
{
    local int I, CurrentIndex;
    local bool bResult;

    CurrentIndex = FindServerIndexById(ControllerId, IdToRemove);
    // End:0xC2
    if(CurrentIndex != -1)
    {
        I = CurrentIndex + 1;
        J0x4F:

        // End:0x97 [Loop If]
        if(I < 15)
        {
            ServerUniqueId[I - 1] = ServerUniqueId[I];
            I++;
            // [Loop Continue]
            goto J0x4F;
        }
        ServerUniqueId[15 - 1] = "";
        SaveConfig();
        bResult = true;
        InvalidateCurrentSearchResults();
    }
    return bResult;
    //return ReturnValue;    
}

function GetServerIdList(out array<UniqueNetId> out_ServerList)
{
    local int I;
    local UniqueNetId ServerNetId;

    out_ServerList.Length = 15;
    I = 0;
    J0x18:

    // End:0xC6 [Loop If]
    if(I < 15)
    {
        // End:0x9B
        if((ServerUniqueId[I] == "") || !Class'Engine.OnlineSubsystem'.static.StringToUniqueNetId(ServerUniqueId[I], ServerNetId))
        {
            out_ServerList.Length = I;
            // [Explicit Break]
            goto J0xC6;
        }
        out_ServerList[I] = ServerNetId;
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    J0xC6:

    //return;    
}

function GetServerStringList(out array<string> out_ServerList)
{
    local int I;

    out_ServerList.Length = 15;
    I = 0;
    J0x18:

    // End:0x8E [Loop If]
    if(I < 15)
    {
        // End:0x59
        if(ServerUniqueId[I] == "")
        {
            out_ServerList.Length = I;
            // [Explicit Break]
            goto J0x8E;
        }
        out_ServerList[I] = ServerUniqueId[I];
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    J0x8E:

    //return;    
}

defaultproperties
{
    Tag="UTGameSearchPersonal"
}