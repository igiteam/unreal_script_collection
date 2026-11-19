class UTUIDataProvider_MapInfo extends UDKUIDataProvider_MapInfo
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config int ContentID;
var config Vector MapLocation;

event bool ShouldBeFiltered()
{
    return super(UDKUIResourceDataProvider).ShouldBeFiltered() || !SupportedByCurrentGameMode();
    //return ReturnValue;    
}

function bool SupportedByCurrentGameMode()
{
    local int pos, I;
    local string ThisMapPrefix, GameModePrefixes;
    local array<string> PrefixList;
    local bool bResult;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    bResult = true;
    pos = InStr(MapName, "-");
    ThisMapPrefix = Left(MapName, pos);
    // End:0x93
    if(ThisMapPrefix == "")
    {
        return false;
    }
    // End:0x17E
    if(Registry.GetData("SelectedGameModePrefix", GameModePrefixes) && GameModePrefixes != "")
    {
        bResult = false;
        ParseStringIntoArray(GameModePrefixes, PrefixList, "|", true);
        I = 0;
        J0x11F:

        // End:0x17E [Loop If]
        if(I < PrefixList.Length)
        {
            bResult = ThisMapPrefix ~= PrefixList[I];
            // End:0x170
            if(bResult)
            {
                // [Explicit Break]
                goto J0x17E;
            }
            I++;
            // [Loop Continue]
            goto J0x11F;
        }
    }
    J0x17E:

    return bResult;
    //return ReturnValue;    
}
