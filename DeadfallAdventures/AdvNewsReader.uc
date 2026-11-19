class AdvNewsReader extends Object
    native
    config(Game);

const kRegionHeaderSizeWithSpace = 16;
const kHeaderSizeWithSpace = 13;
const kNumTrailingSpaces = 1;

var string MessageOfTheDay;
var string Date;
var config string MOTDFilename;
var bool bDownloadingMOTD;
var bool bDownloadedAtLeastOnce;
var int LastDownloadTime;
var config int MinDownloadIntervalSec;
var array< delegate<OnMOTDUpdated> > MOTDObservers;
//var delegate<OnMOTDUpdated> __OnMOTDUpdated__Delegate;

delegate OnMOTDUpdated()
{
    //return;    
}

// Export UAdvNewsReader::execDebugLoadFile(FFrame&, void* const)
native function string DebugLoadFile(string Filename);

// Export UAdvNewsReader::execConvertToString(FFrame&, void* const)
native function string ConvertToString(array<byte> Contents);

// Export UAdvNewsReader::execGetTime(FFrame&, void* const)
native function int GetTime();

function DebugLoadMOTD(string Filename)
{
    local string FileContents;

    FileContents = DebugLoadFile(Filename);
    ProcessMOTDFile(FileContents);
    //return;    
}

protected function bool IsLoggedInOnline()
{
    local WorldInfo WI;
    local PlayerController PC;
    local int LocalPlayerIndex;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x119
    if(WI != none)
    {
        // End:0xE0
        foreach WI.LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0xDF
            if(LocalPlayer(PC.Player) != none)
            {
                LocalPlayerIndex = LocalPlayer(PC.Player).ControllerId;
            }            
        }        
        // End:0x116
        if(int(Class'Engine.UIInteraction'.static.GetLoginStatus(LocalPlayerIndex)) == int(2))
        {
            return true;
        }        
    }
    return false;
    //return ReturnValue;    
}

function DownloadMOTD()
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x111
    if(((none != OnlineSub) && NotEqual_InterfaceInterface(OnlineSystemInterface(none), OnlineSub.SystemInterface)) && IsLoggedInOnline())
    {
        OnlineSub.SystemInterface.AddReadTitleFileCompleteDelegate(OnReadFileFromTitleStorage);
        OnlineSub.SystemInterface.ReadTitleFile(MOTDFilename);
        bDownloadingMOTD = true;        
    }
    //return;    
}

function bool IsDownloading()
{
    return bDownloadingMOTD;
    //return ReturnValue;    
}

function bool HasDownloadedMOTD()
{
    // End:0x25
    if((LastDownloadTime + MinDownloadIntervalSec) < (GetTime()))
    {
        return false;
    }
    return bDownloadedAtLeastOnce;
    //return ReturnValue;    
}

function string GetMOTD()
{
    return MessageOfTheDay;
    //return ReturnValue;    
}

function string GetMOTDDate()
{
    return Date;
    //return ReturnValue;    
}

function AddMOTDUpdatedDelegate(delegate<OnMOTDUpdated> Callback)
{
    // End:0x36
    if(-1 == MOTDObservers.Find(Callback))
    {        
        MOTDObservers.AddItem(Callback);        
    }
    //return;    
}

function ClearMOTDUpdatedDelegate(delegate<OnMOTDUpdated> Callback)
{
    local int RemoveIndex;

    RemoveIndex = MOTDObservers.Find(Callback);    
    // End:0x48
    if(-1 != RemoveIndex)
    {
        MOTDObservers.Remove(RemoveIndex, 1);        
    }
    //return;    
}

protected function FireCallbacks()
{
    local delegate<OnMOTDUpdated> Observer;

    // End:0x3A
    foreach MOTDObservers(Observer)
    {
        // End:0x39
        if(Observer != none)
        {
            OnMOTDUpdated();
        }        
    }    
    //return;    
}

function Cleanup()
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xC1
    if((none != OnlineSub) && NotEqual_InterfaceInterface(OnlineSystemInterface(none), OnlineSub.SystemInterface))
    {
        OnlineSub.SystemInterface.ClearReadTitleFileCompleteDelegate(OnReadFileFromTitleStorage);
        bDownloadingMOTD = false;
    }
    //return;    
}

protected function OnReadFileFromTitleStorage(bool bWasSuccessful, string Filename)
{
    local OnlineSubsystem OnlineSub;
    local array<byte> RawMOTDContent;
    local string MOTDFile;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xCA
    if(bWasSuccessful)
    {
        // End:0xCA
        if(MOTDFilename == Filename)
        {
            // End:0xCA
            if(OnlineSub.SystemInterface.GetTitleFileContents(Filename, RawMOTDContent))
            {
                MOTDFile = ConvertToString(RawMOTDContent);
                ProcessMOTDFile(MOTDFile);                
            }
        }
    }
    OnlineSub.SystemInterface.ClearReadTitleFileCompleteDelegate(OnReadFileFromTitleStorage);
    LastDownloadTime = GetTime();
    bDownloadingMOTD = false;
    //return;    
}

// Export UAdvNewsReader::execGetCurrentRegionAndLanguage(FFrame&, void* const)
protected native final function GetCurrentRegionAndLanguage(out string RegionExt, out string LanguageExt);

protected function ProcessMOTDFile(string FileContents)
{
    local array<string> Lines;
    local string Line, RegionExt, LanguageExt;

    GetCurrentRegionAndLanguage(RegionExt, LanguageExt);
    ParseStringIntoArray(FileContents, Lines, "\n", true);
    // End:0x95
    foreach Lines(Line)
    {
        // End:0x94
        if(ParseGameNews(Line, RegionExt, LanguageExt))
        {
            bDownloadedAtLeastOnce = true;
            FireCallbacks();            
            return;
        }        
    }    
    //return;    
}

function bool ParseGameNews(string StringToParse, string RegionExt, string LanguageExt)
{
    local int Index, EndDateIndex, EndIndex;
    local bool bForceEnglish;
    local string ParsedNews, ParsedDate;

    bForceEnglish = InStr(StringToParse, "<!--ForceINT-->",, true) > 0;
    // End:0x49
    if(bForceEnglish)
    {
        LanguageExt = "INT";
    }
    Index = InStr(StringToParse, (("<!--MOTD-" $ RegionExt) $ "-") $ LanguageExt,, true) + 16;
    EndIndex = InStr(StringToParse, ((LanguageExt $ "-") $ RegionExt) $ "-ENDMOTD-->",, true);
    // End:0x14D
    if((Index < 0) || EndIndex < 0)
    {
        Index = InStr(StringToParse, "<!--MOTD-" $ LanguageExt,, true) + 13;
        EndIndex = InStr(StringToParse, LanguageExt $ "-ENDMOTD-->",, true);
    }
    // End:0x16F
    if((Index < 0) || EndIndex < 0)
    {
        return false;
    }
    ParsedNews = Mid(StringToParse, Index, (EndIndex - Index) - 1);
    EndDateIndex = InStr(ParsedNews, "*D*",, true);
    // End:0x1D2
    if(EndDateIndex < 0)
    {
        return false;
    }
    ParsedDate = Mid(ParsedNews, 0, EndDateIndex);
    ParsedNews = Mid(ParsedNews, EndDateIndex + 3, Len(ParsedNews) - 1);
    MessageOfTheDay = ParsedNews;
    Date = ParsedDate;
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MOTDFilename="motd"
    MinDownloadIntervalSec=3700
}