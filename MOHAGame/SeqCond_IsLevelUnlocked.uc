class SeqCond_IsLevelUnlocked extends SequenceCondition
    hidecategories(Object);

enum eLevel
{
    LEVEL_HUSKY,                    // 0
    LEVEL_AVALANCHE,                // 1
    LEVEL_NEPTUNE,                  // 2
    LEVEL_MARKET,                   // 3
    LEVEL_VARFAC,                   // 4
    LEVEL_VARFLK,                   // 5
    LEVEL_MAX                       // 6
};

enum eDifficulty
{
    Easy,                           // 0
    Medium,                         // 1
    Hard,                           // 2
    ANY,                            // 3
    eDifficulty_MAX                 // 4
};

var() SeqCond_IsLevelUnlocked.eLevel Level;
var() SeqCond_IsLevelUnlocked.eDifficulty Difficulty;

function Activated()
{
    local UIDataStore_MOHAPlayerData MOHAPlayerData;
    local MOHAProfileSettings ProfileSettings;
    local DataStoreClient DataStoreManager;
    local int diff;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x163
    if(DataStoreManager != none)
    {
        MOHAPlayerData = UIDataStore_MOHAPlayerData(DataStoreManager.FindDataStore('MOHAPlayerData'));
        // End:0x163
        if((MOHAPlayerData != none) && MOHAPlayerData.ProfileProvider != none)
        {
            ProfileSettings = MOHAProfileSettings(MOHAPlayerData.ProfileProvider.Profile);
            // End:0x160
            if(ProfileSettings != none)
            {
                // End:0x10D
                if(int(Difficulty) == int(3))
                {
                    diff = 0;
                    J0xA9:

                    // End:0xF7 [Loop If]
                    if(diff <= 2)
                    {
                        // End:0xED
                        if(ProfileSettings.IsLevelUnlocked(int(Level), diff))
                        {
                            OutputLinks[0].bHasImpulse = true;
                            return;
                        }
                        diff++;
                        // [Loop Continue]
                        goto J0xA9;
                    }
                    OutputLinks[1].bHasImpulse = true;
                    return;
                }
                // End:0x14A
                if(ProfileSettings.IsLevelUnlocked(int(Level), int(Difficulty)))
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
    ObjClassVersion=3
    ObjName="Is Level Unlocked"
}