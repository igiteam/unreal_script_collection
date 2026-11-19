class AdvStepRotator extends Actor
    placeable
    hidecategories(Navigation)
    classgroup(Adventurer);

var() export editinline StaticMeshComponent RotatorMesh;
var const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var Rotator BaseRotation;
var() Rotator RotationStep;
var() Rotator RotationOffset;
var() float ToDestinationTimeForward;
var() float ToDestinationTimeBackward;
var float MovementTime;
var() int InitialIndex;
var int CurrentIndex;
var bool bMoving;
var bool bDirection;

function PostBeginPlay()
{
    super.PostBeginPlay();
    MovementTime = 0.0000000;
    SetupInitialRotation();
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0xFC
    if(!bStatic && !bMoving)
    {
        // End:0x72
        if(Action.InputLinks[0].bHasImpulse)
        {
            bDirection = true;
            bMoving = true;            
        }
        else
        {
            // End:0xC4
            if(Action.InputLinks[1].bHasImpulse)
            {
                bDirection = false;
                bMoving = true;                
            }
            else
            {
                // End:0xFC
                if(Action.InputLinks[2].bHasImpulse)
                {
                }
            }
        }
    }
    //return;    
}

function SetupInitialRotation()
{
    local Rotator NewRotation;

    NewRotation = Rotation;
    // End:0x30
    if(InitialIndex > 7)
    {
        InitialIndex -= 8;
    }
    // End:0xB4
    if(RotationStep.Roll != 0)
    {
        NewRotation.Roll = RotationOffset.Roll + (InitialIndex * RotationStep.Roll);
    }
    // End:0x138
    if(RotationStep.Pitch != 0)
    {
        NewRotation.Pitch = RotationOffset.Pitch + (InitialIndex * RotationStep.Pitch);
    }
    // End:0x1BC
    if(RotationStep.Yaw != 0)
    {
        NewRotation.Yaw = RotationOffset.Yaw + (InitialIndex * RotationStep.Yaw);
    }
    CurrentIndex = InitialIndex;
    SetRotation(NewRotation);
    BaseRotation = NewRotation;
    //return;    
}

function EndStep()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_RotationStep StepEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x44
    if(bDirection)
    {
        CurrentIndex++;        
    }
    else
    {
        CurrentIndex--;
    }
    // End:0x76
    if(CurrentIndex > 7)
    {
        CurrentIndex = CurrentIndex % 8;
    }
    // End:0x90
    if(CurrentIndex < 0)
    {
        CurrentIndex = 0;
    }
    // End:0x18B
    if(GameSeq != none)
    {
        ActivateIndices[0] = 0;
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_RotationStep', true, ExecutionEvents);
        // End:0x18A
        foreach ExecutionEvents(ExecutionEvent)
        {
            StepEvent = SeqEvent_RotationStep(ExecutionEvent);
            // End:0x189
            if(StepEvent.Originator == self)
            {
                StepEvent.CheckActivate(self, none, false, ActivateIndices);
                StepEvent.Index = CurrentIndex;
            }            
        }        
    }
    //return;    
}

auto state StepRotation
{
    ignores Touch, UnTouch;

    function Tick(float DeltaTime)
    {
        local Rotator CurrentRotation;
        local float Alpha;

        // End:0x123
        if(bMoving)
        {
            MovementTime += DeltaTime;
            // End:0x4F
            if(bDirection)
            {
                Alpha = MovementTime / ToDestinationTimeForward;                
            }
            else
            {
                Alpha = MovementTime / ToDestinationTimeBackward;
            }
            // End:0x8F
            if(Alpha >= 1.0000000)
            {
                Alpha = 1.0000000;
            }
            // End:0xDB
            if(bDirection)
            {
                CurrentRotation = RLerp(BaseRotation, BaseRotation + RotationStep, Alpha, true);                
            }
            else
            {
                CurrentRotation = RLerp(BaseRotation, BaseRotation - RotationStep, Alpha, true);
            }
            SetRotation(CurrentRotation);
        }
        // End:0x195
        if(Alpha >= 1.0000000)
        {
            bMoving = false;
            MovementTime = 0.0000000;
            // End:0x176
            if(bDirection)
            {
                BaseRotation += RotationStep;                
            }
            else
            {
                BaseRotation -= RotationStep;
            }
            EndStep();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvStepRotator.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_en_TestLevels.Meshes.sm_en_Cylinder_01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvStepRotator.MyLightEnvironment'
        AlwaysCheckCollision=true
        Scale=0.5000000
    end object
    RotatorMesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvStepRotator.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    ToDestinationTimeForward=1.0000000
    ToDestinationTimeBackward=1.0000000
    bDirection=true
    Components[0]=MyLightEnvironment
    Components[1]=Mesh
    CollisionComponent=Mesh
    SupportedEvents=/* Array type was not detected. */
}