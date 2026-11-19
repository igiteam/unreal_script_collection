class AdvConsoleObject_base extends AdvPuzzle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var() export editinline StaticMeshComponent MeshConsole;
var() AdvConsoleObjectButton_base Buttons[12];
var int ButtonHitIndex;
var() CameraActor ExternalCamera;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    AuxiliarySetLocation(Record.Location);
    self.SetRotation(Record.Rotation);
    ButtonUnclick();
    //return;    
}

function PostBeginPlay()
{
    local Vector Offset;
    local int I;

    super.PostBeginPlay();
    Offset.X = 0.0000000;
    Offset.Y = 0.0000000;
    Offset.Z = 80.0000000;
    CaptionComponent.Offset = Offset;
    I = 0;
    J0xA3:

    // End:0x104 [Loop If]
    if(I < 12)
    {
        // End:0xF6
        if(Buttons[I] != none)
        {
            Buttons[I].ParentConsole = self;
        }
        ++I;
        // [Loop Continue]
        goto J0xA3;
    }
    //return;    
}

function bool SetPawn(Pawn P)
{
    local Controller C;

    return false;
    super.SetPawn(P);
    C = P.Controller;
    // End:0xC1
    if(EvilPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        EvilPlayerController(C).GotoState('ConsoleObjectPuzzleControlling');
    }
    ButtonHitIndex = -1;
    //return ReturnValue;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    out_CamLoc = ExternalCamera.Location;
    out_CamRot = ExternalCamera.Rotation;
    out_FOV = ExternalCamera.FOVAngle;
    return false;
    //return ReturnValue;    
}

function ButtonClick(Actor ActorHit)
{
    local int I;

    // End:0xB2
    if((AdvConsoleObjectButton_base(ActorHit) != none) && ButtonHitIndex == -1)
    {
        I = 0;
        J0x38:

        // End:0xA8 [Loop If]
        if(I < 12)
        {
            // End:0x9A
            if((Buttons[I] != none) && Buttons[I] == ActorHit)
            {
                ButtonHitIndex = I;
                // [Explicit Break]
                goto J0xA8;
            }
            ++I;
            // [Loop Continue]
            goto J0x38;
        }
        J0xA8:

        UpdateKismet();
    }
    //return;    
}

function ButtonUnclick()
{
    // End:0x2C
    if(ButtonHitIndex != -1)
    {
        ButtonHitIndex = -1;
        UpdateKismet();
    }
    //return;    
}

function bool OverButton(Actor ActorHit)
{
    // End:0x1A
    if(AdvConsoleObjectButton_base(ActorHit) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateKismet()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0xFC
    if(GameSeq != none)
    {
        ActivateIndices[0] = 0;
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0xFB
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0xFA
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function LeaveThePuzzle()
{
    super.LeaveThePuzzle();
    ButtonUnclick();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvConsoleObject_base.BaseMesh'
    begin object name=BaseMesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
        LightingChannels=(Static=true)
    end object
    MeshConsole=BaseMesh
    ButtonHitIndex=-1
    // Reference: EvilCaptionComponent'Default__AdvConsoleObject_base.CaptionComp'
    begin object name=CaptionComp
        LocString=""
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvConsoleObject_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WalkingPhysics=EPhysics.PHYS_Flying
    CylinderComponent=none
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    Components[4]=BaseMesh
    Physics=EPhysics.PHYS_Interpolating
    CollisionType=ECollisionType.COLLIDE_BlockAll
    CollisionComponent=BaseMesh
}