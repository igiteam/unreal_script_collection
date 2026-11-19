class SeqCond_IsCurrentLevelUnlocked extends SequenceCondition
    hidecategories(Object);

enum eLevel
{
    LEVEL_CURRENT,                  // 0
    LEVEL_HUSKY,                    // 1
    LEVEL_AVALANCHE,                // 2
    LEVEL_NEPTUNE,                  // 3
    LEVEL_MARKET,                   // 4
    LEVEL_VARFAC,                   // 5
    LEVEL_VARFLK,                   // 6
    LEVEL_MAX                       // 7
};

var() SeqCond_IsCurrentLevelUnlocked.eLevel Level;
var int nLevel;

function Activated()
{
    local UIDataStore_MOHAPlayerData MOHAPlayerData;
    local MOHAProfileSettings ProfileSettings;
    local DataStoreClient DataStoreManager;

    // End:0xD0
    if(int(Level) == int(0))
    {
        switch(GetWorldInfo().MapName)
        {
            // End:0x36
            case "Husky1":
                nLevel = 0;
                // End:0xCD
                break;
            // End:0x4F
            case "Avalanche1":
                nLevel = 1;
                // End:0xCD
                break;
            // End:0x67
            case "Neptune1":
                nLevel = 2;
                // End:0xCD
                break;
            // End:0x84
            case "MarketGarden1":
                nLevel = 3;
                // End:0xCD
                break;
            // End:0x9C
            case "Varsity1":
                nLevel = 4;
                // End:0xCD
                break;
            // End:0xB4
            case "Varsity2":
                nLevel = 5;
                // End:0xCD
                break;
            // End:0xFFFF
            default:
                OutputLinks[1].bHasImpulse = true;
                return;
                break;
        }        
    }
    else
    {
        nLevel = int(Level) - 1;
    }
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x1C0
    if(DataStoreManager != none)
    {
        MOHAPlayerData = UIDataStore_MOHAPlayerData(DataStoreManager.FindDataStore('MOHAPlayerData'));
        // End:0x1C0
        if((MOHAPlayerData != none) && MOHAPlayerData.ProfileProvider != none)
        {
            ProfileSettings = MOHAProfileSettings(MOHAPlayerData.ProfileProvider.Profile);
            // End:0x1BD
            if(ProfileSettings != none)
            {
                // End:0x1A7
                if(ProfileSettings.HasCompletedLevel(nLevel, 0))
                {
                    OutputLinks[0].bHasImpulse = true;
                    return;                    
                }
                else
                {
                    OutputLinks[1].bHasImpulse = true;
                    return;
                }
            }            
        }
    }
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Is Current Level Completed"
}