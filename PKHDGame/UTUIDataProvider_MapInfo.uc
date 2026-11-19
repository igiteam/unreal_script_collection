class UTUIDataProvider_MapInfo extends UDKUIDataProvider_MapInfo
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config bool FromWorkshop;
var config bool SoloSurvivalSupported;
var config bool CooperativeSupported;
var config int SoloSVDescription;
var config int SoloSVDiffuculty;
var config int SoloSVTimeLimit;
var config int SoloSVFragLimit;
var config int SoloSVLivesLimit;
var config int SoloSVAddiditonalScore;
var config string Author;
var config string WorkshopPackageName;
var config string CustomGameType;

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
    // End:0x9F
    if(ThisMapPrefix == "")
    {
        ThisMapPrefix = "DM";
    }
    // End:0x18A
    if(Registry.GetData("SelectedGameModePrefix", GameModePrefixes) && GameModePrefixes != "")
    {
        bResult = false;
        ParseStringIntoArray(GameModePrefixes, PrefixList, "|", true);
        I = 0;
        J0x12B:

        // End:0x18A [Loop If]
        if(I < PrefixList.Length)
        {
            bResult = ThisMapPrefix ~= PrefixList[I];
            // End:0x17C
            if(bResult)
            {
                // [Explicit Break]
                goto J0x18A;
            }
            I++;
            // [Loop Continue]
            goto J0x12B;
        }
    }
    J0x18A:

    return bResult;
    //return ReturnValue;    
}
