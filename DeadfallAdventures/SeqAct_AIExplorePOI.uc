class SeqAct_AIExplorePOI extends SeqAct_Latent
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var() array<AdvNavPOI> POIToExplore;
var() float StartExploreDelay;
var() float FinishExploreDelay;
var() bool bFinishImmediately;
var() bool bLoopExploring;
var() bool bRandomOrder;
var bool bFinishedExploring;
var bool bStopedExploring;
var bool bActiveExploring;
var bool bStopUpdate;
var bool bAtLastPoint;
var bool bTurnedOff;

function StopAction()
{
    bStopedExploring = true;
    //return;    
}

function FinishAction()
{
    bFinishedExploring = true;
    //return;    
}

function AtLastPoint()
{
    bAtLastPoint = true;
    //return;    
}

function CallOnExplorePOI()
{
    local Object TargetObj;
    local AdvAIController TargetController;

    // End:0xA4
    foreach Targets(TargetObj)
    {
        TargetController = ((AdvPawn(TargetObj) != none) ? AdvPawn(TargetObj).MyAdvAI : AdvAIController(TargetObj));
        // End:0xA3
        if(TargetController != none)
        {
            TargetController.OnAIExplorePOI(self);
        }        
    }    
    //return;    
}

event bool Update(float DeltaTime)
{
    local bool bActiveInputLink;

    // End:0x31
    if(bStopUpdate)
    {
        LatentActors.Remove(0, LatentActors.Length);        
        bStopUpdate = false;
        return false;
    }
    // End:0x78
    if(bFinishedExploring)
    {
        OutputLinks[2].bHasImpulse = true;
        bFinishedExploring = false;
        bStopUpdate = true;
    }
    // End:0xBE
    if(bStopedExploring)
    {
        OutputLinks[1].bHasImpulse = true;
        bStopedExploring = false;
        bStopUpdate = true;
    }
    // End:0xF9
    if(bAtLastPoint)
    {
        OutputLinks[3].bHasImpulse = true;
        bAtLastPoint = false;
    }
    // End:0x152
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x137
        if(bTurnedOff)
        {
            bStopUpdate = true;            
        }
        else
        {
            bActiveExploring = true;
            bActiveInputLink = true;
        }        
    }
    else
    {
        // End:0x1B6
        if(InputLinks[1].bHasImpulse)
        {
            // End:0x19E
            if(!bActiveExploring)
            {
                bTurnedOff = true;
                bStopUpdate = true;                
            }
            else
            {
                bActiveInputLink = true;
                bActiveExploring = false;
            }
        }
    }
    // End:0x1CD
    if(bActiveInputLink)
    {
        CallOnExplorePOI();
    }
    return super.Update(DeltaTime);
    //return ReturnValue;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 11;
    //return ReturnValue;    
}

defaultproperties
{
    StartExploreDelay=5.0000000
    FinishExploreDelay=5.0000000
    bFinishImmediately=true
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Explored All",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="At last point",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="POI",LinkVar="None",PropertyName="POIToExplore",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Explore POI"
}