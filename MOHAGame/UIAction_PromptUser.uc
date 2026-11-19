class UIAction_PromptUser extends UIAction
    native
    hidecategories(Object);

enum EPromptType
{
    ePrompt_NEWCAMPAIGN,            // 0
    ePrompt_SELECTCAMPAIGN,         // 1
    ePrompt_AUTOSAVE,               // 2
    ePrompt_RESTARTMISSION,         // 3
    ePrompt_SAVECHECKPOINT,         // 4
    ePrompt_LOADCHECKPOINT,         // 5
    ePrompt_QUIT,                   // 6
    ePrompt_PROFILECHANGED,         // 7
    ePrompt_ACCEPTCHEATS,           // 8
    ePROMPT_NONE,                   // 9
    EPromptType_MAX                 // 10
};

var() UIAction_PromptUser.EPromptType PromptType;

defaultproperties
{
    PromptType=9
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=3
    ObjName="Prompt User"
    ObjCategory="Profile Manager"
}