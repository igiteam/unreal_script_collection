class SeqAct_ManagePOI extends SeqAct_Latent
    config(Game)
    forcescriptorder(true)
    hidecategories(Object);

enum EManagePOIInputType
{
    eMPOIINPUT_On,                  // 0
    eMPOIINPUT_Off,                 // 1
    eMPOIINPUT_MAX                  // 2
};

enum EManagePOIOutputType
{
    eMPOIOUTPUT_Out,                // 0
    eMPOIOUTPUT_Expired,            // 1
    eMPOIOUTPUT_LookAt,             // 2
    eMPOIOUTPUT_LookAway,           // 3
    eMPOIOUTPUT_MAX                 // 4
};

var() config string POI_DisplayName;
var() config bool POI_DisplayLong;
var() config bool POI_DisplayParseTags;
var bool POI_bEnabled;
var() config bool POI_bForceLookCheckLineOfSight;
var() config bool POI_bFOVLineOfSightCheck;
var() config bool POI_bDisableOtherPOIs;
var() config bool POI_bLeavePlayerFacingPOI;
var() config bool POI_bHidePlayerWeapon;
var bool bIsDone;
var() config float POI_IconDuration;
var() config EvilPointOfInterest.EPOIForceLookType POI_ForceLookType;
var() config float POI_ForceLookDuration;
var() config int POI_LookAtPriority;
var() config float POI_DesiredFOV;
var() config int POI_FOVCount;
var() config float POI_EnableDuration;
var EvilPointOfInterest POI;

event Activated()
{
    local Object O;

    // End:0x5A
    foreach Targets(O)
    {
        // End:0x59
        if(O.IsA('EvilPointOfInterest'))
        {
            POI = EvilPointOfInterest(O);            
        }
        else
        {            
        }
    }    
    bIsDone = false;
    POI_bEnabled = POI.bEnabled;
    ProcessInputImpulses();
    ActivateOutputLink(0);
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x1B
    if(bIsDone)
    {
        ActivateOutputLink(1);        
    }
    else
    {
        ProcessInputImpulses();
    }
    return !bIsDone;
    //return ReturnValue;    
}

function ProcessInputImpulses()
{
    local bool bSetValues;

    // End:0x2B
    if(POI == none)
    {
        ActivateOutputLink(1);
        bIsDone = true;
        return;        
    }
    else
    {
        POI.POIAction = self;
    }
    bSetValues = false;
    // End:0xBA
    if(InputLinks[0].bHasImpulse && !POI.bEnabled)
    {
        POI_bEnabled = true;
        bSetValues = true;        
    }
    else
    {
        // End:0x118
        if(InputLinks[1].bHasImpulse && POI.bEnabled)
        {
            POI_bEnabled = false;
            bSetValues = true;
        }
    }
    // End:0x40F
    if(bSetValues)
    {
        POI.DisplayName = POI_DisplayName;
        POI.DisplayLong = POI_DisplayLong;
        POI.DisplayParseTags = POI_DisplayParseTags;
        POI.IconDuration = POI_IconDuration;
        POI.ForceLookType = POI_ForceLookType;
        POI.ForceLookDuration = POI_ForceLookDuration;
        POI.bForceLookCheckLineOfSight = POI_bForceLookCheckLineOfSight;
        POI.LookAtPriority = POI_LookAtPriority;
        POI.LookAtPriority = POI_LookAtPriority;
        POI.DesiredFOV = POI_DesiredFOV;
        POI.FOVCount = POI_FOVCount;
        POI.bDoTraceForFOV = POI_bFOVLineOfSightCheck;
        POI.bDisableOtherPOIs = POI_bDisableOtherPOIs;
        POI.EnableDuration = POI_EnableDuration;
        POI.CurrIconDuration = POI_IconDuration;
        POI.bLeavePlayerFacingPOI = POI_bLeavePlayerFacingPOI;
        POI.bHidePlayerWeapon = POI_bHidePlayerWeapon;
        POI.SetEnabled(POI_bEnabled);
        ActivateOutputLink(0);
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Expired",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Look At",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="Look Away",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="POI",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="POI Manager"
}