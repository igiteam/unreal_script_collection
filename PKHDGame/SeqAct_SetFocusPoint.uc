class SeqAct_SetFocusPoint extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var Actor Instigator;
var Actor Focus;
var Actor TargetLocationActor;
var() float MoveToTargetVelocity;
var() float InterpSpeed;
var() float AngleActivation;
var bool AngleOutputActivated;
var bool bUsesRotation;
var bool bUsesMove;
var EvilPlayerController PCInstigator;
var Actor.EPhysics MovePhysics;
var Actor.EPhysics OldMovePhysics;

event Deactivated()
{
    PCInstigator.Pawn.SetPhysics(OldMovePhysics);
    //return;    
}

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x1FD
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x1FC
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
        {
            P = EvilPawn(ObjVar.GetObjectValue());
            // End:0xBF
            if(P != none)
            {
                PC = EvilPlayerController(P.Controller);
            }
            // End:0x1FB
            if(PC != none)
            {
                bUsesRotation = Focus != none;
                bUsesMove = TargetLocationActor != none;
                // End:0x155
                if(bUsesRotation)
                {
                    PC.SetFocusActor(true, Focus, InterpSpeed,, 3, 1.0000000,, ContinueCameraRotation);
                }
                // End:0x193
                if(bUsesMove)
                {
                    PC.ForcedMoveLocation(TargetLocationActor, MoveToTargetVelocity);
                }
                PCInstigator = PC;
                OldMovePhysics = P.Physics;
                P.SetPhysics(MovePhysics);
                AngleOutputActivated = false;
            }            
        }        
    }
    bAborted = false;
    //return;    
}

function bool IsRotating()
{
    return (PCInstigator != none) && int(PCInstigator.GetFocusType()) == int(3);
    //return ReturnValue;    
}

function bool IsMoving()
{
    return (PCInstigator != none) && PCInstigator.IsInState('ForcedMove');
    //return ReturnValue;    
}

function bool ContinueCameraRotation(float InDiffAngleDeg, float InDirDot)
{
    // End:0x56
    if(!AngleOutputActivated && InDiffAngleDeg <= AngleActivation)
    {
        OutputLinks[2].bHasImpulse = true;
        AngleOutputActivated = true;
    }
    // End:0x6B
    if(InDiffAngleDeg >= 0.0100000)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool Update(float DeltaTime)
{
    local bool Result, bBoth;

    // End:0x11
    if(PCInstigator == none)
    {
        return false;
    }
    bBoth = bUsesRotation && bUsesMove;
    // End:0x69
    if(bBoth)
    {
        Result = (IsRotating()) && IsMoving();        
    }
    else
    {
        // End:0x8E
        if(bUsesRotation)
        {
            Result = IsRotating();            
        }
        else
        {
            // End:0xB0
            if(bUsesMove)
            {
                Result = IsMoving();
            }
        }
    }
    // End:0x100
    if((!Result && bUsesRotation) && PCInstigator != none)
    {
        PCInstigator.ClearFocus(true);
    }
    return Result;
    //return ReturnValue;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}

defaultproperties
{
    MoveToTargetVelocity=500.0000000
    InterpSpeed=4.0000000
    MovePhysics=EPhysics.PHYS_Flying
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="AngleReached",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Look at Focus",LinkVar="None",PropertyName="Focus",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Location",LinkVar="None",PropertyName="TargetLocationActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Focus Point"
}