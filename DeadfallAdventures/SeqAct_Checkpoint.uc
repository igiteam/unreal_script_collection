class SeqAct_Checkpoint extends SeqAct_Latent
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var() array< class<Pawn> > TeleportClasses;
var() array<Volume> TeleportVolumes;
var() array<Actor> FallbackTeleportActors;
var() string FailureReason;
var() bool bAlwaysUseFailureReason;
var() bool bOverrideSavedChapter;
var() bool bIsLevelStart;
var() bool bTeleportSkipRadiusSearch;
var bool bOnlyTeleported;
var bool bMessageFinished;
var bool bCheckpointFinished;
var deprecated EvilTypes.EChapterPoint SavedChapterOverride;
var() int OverrideSavedChapter;
var Actor TeleportTargetPlayer;
var transient float ActivationTime;
var() name CheckpointName;
var transient float ForceMFCounter;
var transient float ForceMFTreshold;

event Activated()
{
    local EvilPlayerController PC;
    local EvilPawn EP;
    local EvilEngine Engine;

    bOnlyTeleported = false;
    bMessageFinished = false;
    bCheckpointFinished = false;
    // End:0x213
    if(InputLinks[0].bHasImpulse)
    {
        Engine = EvilEngine(Class'EvilEngine'.static.GetEngine());
        // End:0x1E3
        if(((bIsLevelStart && Engine != none) && Engine.GetAllowSaveFirstCheckpoint()) || !bIsLevelStart)
        {
            ForceMFCounter = 0.0000000;
            Engine.SetAllowSaveFirstCheckpoint(Engine.default.bAllowSaveFirstCheckpoint);
            // End:0x185
            foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllPawns(Class'EvilPawn', EP)
            {
                EP.OnCheckPoint(self);                
            }            
            // End:0x1DF
            foreach GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PC)
            {
                PC.OnCheckPoint(self);
                // End:0x1DF
                break;                
            }                        
        }
        else
        {
            OutputLinks[0].bHasImpulse = true;
            bMessageFinished = true;
        }        
    }
    else
    {
        // End:0x238
        if(InputLinks[1].bHasImpulse)
        {            
        }
        else
        {
            // End:0x2E3
            if(InputLinks[2].bHasImpulse)
            {
                // End:0x2B4
                foreach GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PC)
                {
                    PC.OnCheckPoint(self);
                    // End:0x2B4
                    break;                    
                }                
                bOnlyTeleported = true;
                OutputLinks[2].bHasImpulse = true;
            }
        }
    }
    // End:0x313
    if(!bOnlyTeleported)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    ActivationTime = GetWorldInfo().TimeSeconds;
    //return;    
}

event Deactivated()
{
    local EvilPlayerController PC;

    // End:0x42
    if(OutputLinks.Length > 3)
    {
        // End:0x42
        if(!bOnlyTeleported)
        {
            OutputLinks[3].bHasImpulse = true;
        }
    }
    // End:0x9B
    foreach GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PC)
    {
        PC.CheckpointSeqAct = none;
        // End:0x9B
        break;        
    }    
    //return;    
}

event CheckpointFinished()
{
    // End:0x4C
    if(OutputLinks.Length > 1)
    {
        // End:0x4C
        if(!bOnlyTeleported)
        {
            OutputLinks[1].bHasImpulse = true;
            bCheckpointFinished = true;
        }
    }
    //return;    
}

event MessageFinished()
{
    bMessageFinished = true;
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 5;
    //return ReturnValue;    
}

final function bool ShouldTeleport(Pawn TestPawn, Vector TeleportLocation)
{
    return false;
    //return ReturnValue;    
}

event bool Update(float DeltaTime)
{
    ForceMFCounter += DeltaTime;
    // End:0x37
    if(ForceMFCounter >= ForceMFTreshold)
    {
        bMessageFinished = true;
    }
    // End:0x7F
    if(!bCheckpointFinished && ActivationTime != GetWorldInfo().TimeSeconds)
    {
        CheckpointFinished();
    }
    return !bMessageFinished && !bOnlyTeleported;
    //return ReturnValue;    
}

defaultproperties
{
    ActivationTime=-100000.0000000
    ForceMFTreshold=3.5000000
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Save",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Force Game Over",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Teleport Only",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Only Teleported",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="Message Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teleport Target",LinkVar="None",PropertyName="TeleportTargetPlayer",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teleport Volumes",LinkVar="None",PropertyName="TeleportVolumes",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Fallback Destinations",LinkVar="None",PropertyName="FallbackTeleportActors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Checkpoint"
}