class AdvMirrorDynamic extends Pawn
    config(Game)
    hidecategories(Navigation)
    classgroup(Adventurer);

var private Pawn User;
var() private bool bUsed;
var() private bool bIsEmmiter;
var private bool bActive;
var private bool bSpawned;
var() private const CameraActor RoomCamera;
var private Rotator RotationRestriction;
var Rotator BaseRotation;
var() const export editinline StaticMeshComponent MirrorMesh;
var private AdvMirrorDynamic AffectedMirror;
var private Vector IncomingRay;
var Vector CamOffset;
var private float CurrentDelay;
var private float CheckDelay;
var AdvLightRay Ray;
var private Vector RayHitLocation;

function PostBeginPlay()
{
    super.PostBeginPlay();
    BaseRotation = Rotation;
    // End:0x7A
    if(BaseRotation.Pitch < 0)
    {
        BaseRotation.Pitch = -BaseRotation.Pitch;
    }
    // End:0xD7
    if(BaseRotation.Yaw < 0)
    {
        BaseRotation.Yaw = -BaseRotation.Yaw;
    }
    // End:0x134
    if(BaseRotation.Pitch < 0)
    {
        BaseRotation.Roll = -BaseRotation.Roll;
    }
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
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
        EvilPlayerController(C).GotoState('MirrorControlling');
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

function Rotator GetRotationRestriction()
{
    return RotationRestriction;
    //return ReturnValue;    
}

function SetIncomingRay(Vector Direction)
{
    IncomingRay = Direction;
    //return;    
}

function SetRayHitLocation(Vector Hit)
{
    RayHitLocation = Hit;
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    // End:0x6A
    if(RoomCamera == none)
    {
        out_CamLoc = Location;
        out_CamLoc.Z += 512.0000000;
        out_CamRot.Pitch = -16384;        
    }
    else
    {
        out_CamLoc = RoomCamera.Location;
        out_CamRot = RoomCamera.Rotation;
    }
    return true;
    //return ReturnValue;    
}

function Activate(bool Activate)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    bActive = Activate;
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x12E
    if(GameSeq != none)
    {
        // End:0x6A
        if(Activate)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x12D
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x12C
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function bool IsActive()
{
    return bActive;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    local Vector HitNorm, HitLoc, EndTrace, reflection;
    local AdvMirrorDynamic Mirror;
    local Actor TraceActor;

    super(Actor).Tick(DeltaTime);
    Mirror = none;
    // End:0x256
    if(bActive)
    {
        // End:0x212
        if(CurrentDelay <= 0.0000000)
        {
            // End:0xB1
            if(bActive && (IncomingRay == vect(0.0000000, 0.0000000, 0.0000000)) || bIsEmmiter)
            {
                // End:0xAE
                if(bSpawned)
                {
                    Ray.SetRayDirection(Vector(Rotation));
                }                
            }
            else
            {
                reflection = FindReflectionVector(Vector(Rotation), IncomingRay);
                EndTrace = self.Location + (reflection * float(10000));
                // End:0x142
                if(bSpawned)
                {
                    Ray.SetRayDirection(reflection);
                }
            }
            RayHitLocation = self.Location;
            // End:0x1DF
            foreach TraceActors(Class'Engine.Actor', TraceActor, HitLoc, HitNorm, EndTrace, RayHitLocation)
            {
                // End:0x1DB
                if(AdvMirrorDynamic(TraceActor) != none)
                {
                    Mirror = AdvMirrorDynamic(TraceActor);
                    // End:0x1DF
                    break;
                    // End:0x1DE
                    continue;
                }
                // End:0x1DF
                break;                
            }            
            UpdateMirror(Mirror, HitLoc);
            CurrentDelay = CheckDelay;            
        }
        else
        {
            CurrentDelay -= DeltaTime;
        }
        // End:0x253
        if(!bSpawned)
        {
            bSpawned = CreateReflection(HitLoc);
        }        
    }
    else
    {
        // End:0x26F
        if(Ray != none)
        {
            DestroyReflection();
        }
    }
    //return;    
}

function UpdateMirror(AdvMirrorDynamic Mirror, Vector HitLocation)
{
    // End:0x116
    if(((Mirror != none) && !Mirror.IsActive()) && (AffectedMirror == none) || AffectedMirror != Mirror)
    {
        // End:0x8E
        if(AffectedMirror != none)
        {
            AffectedMirror.Activate(false);
        }
        Mirror.Activate(true);
        Mirror.SetIncomingRay(Vector(Rotation));
        Mirror.SetRayHitLocation(HitLocation);
        AffectedMirror = Mirror;        
    }
    else
    {
        // End:0x164
        if((Mirror == none) && AffectedMirror != none)
        {
            AffectedMirror.Activate(false);
            AffectedMirror = none;            
        }
        else
        {
            // End:0x1DE
            if((Mirror != none) && Mirror == AffectedMirror)
            {
                AffectedMirror.SetRayHitLocation(HitLocation);
                AffectedMirror.SetIncomingRay(Vector(Rotation));
            }
        }
    }
    //return;    
}

function DestroyReflection()
{
    // End:0x5E
    if(Ray != none)
    {
        Ray.Destroy();
        Ray.SetHidden(true);
        Ray = none;
        bSpawned = false;
    }
    // End:0x98
    if(AffectedMirror != none)
    {
        AffectedMirror.Activate(false);
        AffectedMirror = none;
    }
    //return;    
}

function bool CreateReflection(Vector HitRayLocation)
{
    local Vector reflection;

    HitRayLocation = self.Location;
    reflection = FindReflectionVector(Vector(Rotation), IncomingRay);
    Ray = Spawn(Class'AdvLightRay', self,, RayHitLocation, Rotator(reflection),, true);
    // End:0xFD
    if(Ray != none)
    {
        Ray.SetRayDirection(reflection);
        Ray.SetOwner(self);
        Ray.SetLocation(self.Location);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Vector FindReflectionVector(Vector SurfaceNormal, Vector RayToReflect)
{
    local Vector N, Vpar, reflection;

    N = Normal(SurfaceNormal);
    Vpar = (N Dot RayToReflect) * N;
    reflection = RayToReflect - (float(2) * Vpar);
    return reflection;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x46
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bActive = true;        
    }
    else
    {
        // End:0x8C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bActive = false;            
        }
        else
        {
            // End:0xDB
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bActive = !bActive;
            }
        }
    }
    //return;    
}

defaultproperties
{
    RotationRestriction=(Pitch=3000,Yaw=2000,Roll=0)
    // Reference: StaticMeshComponent'Default__AdvMirrorDynamic.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        Rotation=(Pitch=16384,Yaw=0,Roll=0)
        Scale3D=(X=0.5000000,Y=0.5000000,Z=0.0100000)
    end object
    MirrorMesh=Mesh
    CamOffset=(X=200.0000000,Y=0.0000000,Z=200.0000000)
    CheckDelay=0.0001000
    // Reference: CylinderComponent'Default__AdvMirrorDynamic.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=Mesh
    bCanBeDamaged=false
    CollisionComponent=Mesh
    SupportedEvents=/* Array type was not detected. */
}