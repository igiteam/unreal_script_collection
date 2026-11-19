class PandoraDMSearch_DataStore extends UIDataStore_OnlineGameSearch
    transient
    native;

var int SearchMapID;
var int SearchCreatureDensity;
var int SearchAnimusMachineLimit;
var bool bSkipBuildSearchResults;

// Export UPandoraDMSearch_DataStore::execBuildSearchResults(FFrame&, void* const)
native function BuildSearchResults();

function ResetSearchCriteria()
{
    SearchMapID = 0;
    SearchCreatureDensity = 0;
    SearchAnimusMachineLimit = 0;
    //return;    
}

function SetSearchCriteria(int MapID, int CreatureDensity, int AnimusMachineLimit)
{
    SearchMapID = MapID;
    SearchCreatureDensity = CreatureDensity;
    SearchAnimusMachineLimit = AnimusMachineLimit;
    //return;    
}
