class SPShellCasingPersistent extends DynamicSMActor
    abstract;

var Rotator InitialShellRotation;
var float InitialBaseVelocityScaler;
var float InitialRotationalRate;
var float VelocitySpeedScaler;
var float ZShellArch;
var SoundCue Sound_Shell;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    RandSpin();
    //return;    
}

function Init(Vector Forward, Vector Direction, float FOV)
{
    local float TossZ;
    local Rotator NewRotation;

    SetPhysics(2);
    Forward *= -1.0000000;
    NewRotation = Rotator(Forward);
    NewRotation.Pitch += int(float(-InitialShellRotation.Pitch) + (float(InitialShellRotation.Pitch * 2) * FRand()));
    NewRotation.Yaw += int(float(-InitialShellRotation.Yaw) + (float(InitialShellRotation.Yaw * 2) * FRand()));
    NewRotation.Roll += int(float(-InitialShellRotation.Roll) + (float(InitialShellRotation.Roll * 2) * FRand()));
    SetRotation(NewRotation);
    Velocity = InitialBaseVelocityScaler * Direction;
    Velocity *= VelocitySpeedScaler;
    TossZ = ZShellArch;
    TossZ = (TossZ + ((FRand() * TossZ) / 2.0000000)) - (TossZ / 4.0000000);
    Velocity.Z += TossZ;
    StaticMeshComponent.SetRBLinearVelocity(Velocity);
    StaticMeshComponent.SetRBRotation(Rotation);
    StaticMeshComponent.WakeRigidBody();
    StaticMeshComponent.SetFOV(FOV);
    SetTimer(3.0000000, false, 'Die');
    SetTimer(0.5000000, false, 'PlayShellDrop');
    //return;    
}

simulated function RandSpin()
{
    RotationRate.Yaw = int(-InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand()));
    RotationRate.Pitch = int(-InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand()));
    RotationRate.Roll = int(-InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand()));
    ApplyRotationRate();
    //return;    
}

simulated function ApplyRotationRate()
{
    local Vector W;

    W.X = -InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand());
    W.Y = -InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand());
    W.Z = -InitialRotationalRate + ((InitialRotationalRate * float(2)) * FRand());
    StaticMeshComponent.SetRBAngularVelocity(W);
    //return;    
}

function PlayShellDrop()
{
    local editinline AudioComponent AC;

    AC = WorldInfo.CreateAudioComponent(Sound_Shell, false, true);
    // End:0x74
    if(AC != none)
    {
        AC.bUseOwnerLocation = false;
        AC.Location = Location;
        AC.bAutoDestroy = true;
        AC.Play();
    }
    //return;    
}

function Die()
{
    Destroy();
    //return;    
}
