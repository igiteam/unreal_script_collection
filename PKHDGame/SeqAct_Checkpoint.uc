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
var deprecated EvilTypes.EChapterPoint SavedChapterOverride;
var() int OverrideSavedChapter;
var Actor TeleportTargetPlayer;
var transient float ActivationTime;
var() name CheckpointName;

event Activated()
{
    local EvilPlayerController PC;
    local EvilPawn EP;

    bOnlyTeleported = false;
    // End:0xF9
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x9B
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllPawns(Class'EvilPawn', EP)
        {
            EP.OnCheckPoint(self);            
        }        
        // End:0xF5
        foreach GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PC)
        {
            PC.OnCheckPoint(self);
            // End:0xF5
            break;            
        }                
    }
    else
    {
        // End:0x11E
        if(InputLinks[1].bHasImpulse)
        {            
        }
        else
        {
            // End:0x1C9
            if(InputLinks[2].bHasImpulse)
            {
                // End:0x19A
                foreach GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PC)
                {
                    PC.OnCheckPoint(self);
                    // End:0x19A
                    break;                    
                }                
                bOnlyTeleported = true;
                OutputLinks[2].bHasImpulse = true;
            }
        }
    }
    // End:0x1F9
    if(!bOnlyTeleported)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    ActivationTime = GetWorldInfo().TimeSeconds;
    //return;    
}

event Deactivated()
{
    // End:0x40
    if(OutputLinks.Length > 1)
    {
        // End:0x40
        if(!bOnlyTeleported)
        {
            OutputLinks[1].bHasImpulse = true;
        }
    }
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
    return ActivationTime == GetWorldInfo().TimeSeconds;
    //return ReturnValue;    
}

defaultproperties
{
    ActivationTime=-100000.0000000
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Save",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Force Game Over",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Teleport Only",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Only Teleported",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teleport Target",LinkVar="None",PropertyName="TeleportTargetPlayer",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teleport Volumes",LinkVar="None",PropertyName="TeleportVolumes",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Fallback Destinations",LinkVar="None",PropertyName="FallbackTeleportActors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Checkpoint"
}