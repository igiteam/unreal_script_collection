class UTUIDataProvider_Mutator extends UTUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string ClassName;
var const config localized string Description;
var config string GroupNames;
var config array<config string> SupportedGameTypes;
var config bool bStandaloneOnly;
var private const bool bOfficialMutator;

event bool ShouldBeFiltered()
{
    return super(UDKUIResourceDataProvider).ShouldBeFiltered() || !SupportsCurrentGameMode();
    //return ReturnValue;    
}

event bool SupportsCurrentGameMode()
{
    local string GameMode;
    local class<EvilGame> GameModeClass;
    local bool bResult, bGameTypeSupported;
    local string StandaloneMatch;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    bResult = true;
    // End:0xAB
    if(bStandaloneOnly && Registry.GetData("StandaloneGame", StandaloneMatch))
    {
        bResult = StandaloneMatch == "1";
    }
    Registry.GetData("SelectedGameMode", GameMode);
    // End:0x28F
    if(GameMode != "")
    {
        // End:0x1BB
        if(SupportedGameTypes.Length > 0)
        {
            bGameTypeSupported = SupportedGameTypes.Find(GameMode) != -1;
            // End:0x1BB
            if(!bGameTypeSupported)
            {
                GameMode = Repl(GameMode, "UTGameContent.", "EvilGame.");
                GameMode = Repl(GameMode, "_Content", "");
                // End:0x1BB
                if(SupportedGameTypes.Find(GameMode) == -1)
                {
                    bResult = false;
                }
            }
        }
        // End:0x28F
        if(bResult)
        {
            GameMode = Repl(GameMode, "UTGameContent.", "EvilGame.");
            GameMode = Repl(GameMode, "_Content", "");
            GameModeClass = class<EvilGame>(FindObject(GameMode, Class'Core.Class'));
            // End:0x28F
            if(GameModeClass != none)
            {
                bResult = GameModeClass.static.AllowMutator(ClassName);                
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bSearchAllInis=true
}