class AdvSafeRotator extends Pawn
    config(Game)
    hidecategories(Navigation)
    classgroup(Adventurer);

var private Pawn User;
var() private bool bUsed;
var() const export editinline StaticMeshComponent SafeMesh;
var private Rotator CurrentRotation;
var() private float RotationDelay;
var private float CurrentDelay;
var private float BaseRoll;
var protected int CurrentValue;
var protected float MovementTime;
var protected Rotator OldRotation;
var protected float PressDelay;

function PostBeginPlay()
{
    super.PostBeginPlay();
    CurrentRotation = Rotation;
    CurrentRotation.Roll += 16384;
    BaseRoll = float(CurrentRotation.Roll);
    OldRotation = CurrentRotation;
    SetRotation(CurrentRotation);
    //return;    
}

function bool TryToControl(Pawn P)
{
    // End:0x0F
    if(bUsed)
    {
        return false;
    }
    return PlayerUse(P);
    //return ReturnValue;    
}

function bool PlayerUse(Pawn P)
{
    local Controller C;

    C = P.Controller;
    User = P;
    // End:0x6C
    if(User.Health <= 0)
    {
        User = none;
        return false;
    }
    // End:0xFF
    if(EvilPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        EvilPlayerController(C).GotoState('SafeControlling');
        bUsed = true;        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool DetachUser()
{
    User = none;
    bUsed = false;
    return true;
    //return ReturnValue;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    out_CamLoc = Location - (Normal(Vector(Rotation)) * 200.0000000);
    out_CamRot = Rotator(Location - out_CamLoc);
    out_CamRot.Roll = 0;
    return true;
    //return ReturnValue;    
}

function Rotate(float Value)
{
    // End:0x137
    if(CurrentDelay <= 0.0000000)
    {
        CurrentDelay = RotationDelay;
        MovementTime = 0.0000000;
        OldRotation = CurrentRotation;
        // End:0xC1
        if((Value > float(0)) && float(CurrentRotation.Roll) < (BaseRoll + float(13644)))
        {
            CurrentRotation.Roll += 5461;
            CurrentValue++;            
        }
        else
        {
            // End:0x137
            if((Value < float(0)) && float(CurrentRotation.Roll) > (BaseRoll - float(13644)))
            {
                CurrentRotation.Roll -= 5461;
                CurrentValue--;
            }
        }
    }
    SetRotation(CurrentRotation);
    //return;    
}

function bool CheckSafeValue()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_RotationStep StepEvent;
    local array<int> ActivateIndices;

    // End:0x15
    if(PressDelay > 0.0000000)
    {
        return false;
    }
    PressDelay = 0.2000000;
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x148
    if(GameSeq != none)
    {
        ActivateIndices[0] = 0;
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_RotationStep', true, ExecutionEvents);
        // End:0x147
        foreach ExecutionEvents(ExecutionEvent)
        {
            StepEvent = SeqEvent_RotationStep(ExecutionEvent);
            // End:0x146
            if(StepEvent.Originator == self)
            {
                StepEvent.CheckActivate(self, none, false, ActivateIndices);
                StepEvent.Index = CurrentValue;
            }            
        }        
    }
    //return ReturnValue;    
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
    local Object O;
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Attachment");
    // End:0xDF
    foreach objVars(O)
    {
        // End:0x67
        if(Actor(O) == none)
        {
            continue;            
        }
        else
        {
            // End:0xDE
            if(Action.bDetach)
            {
                // End:0xB6
                if(O.IsA('EvilPawn'))
                {
                    DetachUser();
                }
                AdvPlayerController(O).TryDetachingUser();
            }            
        }
    }    
    //return;    
}

function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x3A
    if(CurrentDelay > 0.0000000)
    {
        CurrentDelay -= DeltaTime;
    }
    // End:0x61
    if(PressDelay > 0.0000000)
    {
        PressDelay -= DeltaTime;
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvSafeRotator.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_en_TestLevels.Meshes.sm_en_Safe_01'
        ReplacementPrimitive=none
        Rotation=(Pitch=16384,Yaw=0,Roll=0)
    end object
    SafeMesh=Mesh
    RotationDelay=0.5000000
    CurrentValue=3
    // Reference: CylinderComponent'Default__AdvSafeRotator.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=Mesh
    bAlwaysTick=true
    CollisionComponent=Mesh
    SupportedEvents=/* Array type was not detected. */
}