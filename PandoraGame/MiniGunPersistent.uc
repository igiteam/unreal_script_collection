class MiniGunPersistent extends MountedWeapon
    abstract;

var float BarrelSpeed;
var float LastTime;

simulated function PostBeginPlay()
{
    local SkelControlSingleBone xpivot, ypivot;

    super.PostBeginPlay();
    xpivot = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('pivotx'));
    // End:0x46
    if(xpivot != none)
    {
        xpivot.SetSkelControlActive(true);
    }
    ypivot = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('pivoty'));
    // End:0x86
    if(ypivot != none)
    {
        ypivot.SetSkelControlActive(true);
    }
    //return;    
}

function Tick(float Time)
{
    local AnimNodeSequence SeqNode;
    local Vector gloc;
    local Rotator Rot, grot;

    super.Tick(Time);
    // End:0xEF
    if(Target != none)
    {
        // End:0xEF
        if(SkeletalMeshComponent != none)
        {
            SkeletalMeshComponent.GetSocketWorldLocationAndRotation('root', gloc, grot);
            Rot = Rotator(Normal(Target.Location - gloc));
            Rot = Rot - grot;
            // End:0xB8
            if(Rot.Yaw < 0)
            {
                Rot.Yaw = Rot.Yaw + 49152;                
            }
            else
            {
                Rot.Yaw = Rot.Yaw - 16384;
            }
            SetWeaponRotation(Rot);
        }
    }
    // End:0x13C
    if(Firing)
    {
        BarrelSpeed = BarrelSpeed + (0.5000000 * ((300.0000000 * Time) * Time));
        // End:0x139
        if(BarrelSpeed > 1.0000000)
        {
            BarrelSpeed = 1.0000000;
        }        
    }
    else
    {
        // End:0x159
        if(BarrelSpeed <= 0.0100000)
        {
            BarrelSpeed = 0.0000000;            
        }
        else
        {
            BarrelSpeed = BarrelSpeed - (0.5000000 * ((100.0000000 * Time) * Time));
            // End:0x198
            if(BarrelSpeed < float(0))
            {
                BarrelSpeed = 0.0000000;
            }
        }
    }
    // End:0x210
    if(SkeletalMeshComponent.Animations != none)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations.FindAnimNode('barrel'));
        // End:0x210
        if(SeqNode != none)
        {
            SeqNode.Rate = BarrelSpeed;
            LastTime = SeqNode.CurrentTime;
        }
    }
    //return;    
}

function SetWeaponRotation(Rotator Rot)
{
    local SkelControlSingleBone xpivot, ypivot;

    // End:0x40
    if(float(Rot.Pitch) > (maxPitch * float(182)))
    {
        Rot.Pitch = int(maxPitch * float(182));
    }
    // End:0x80
    if(float(Rot.Pitch) < (MinPitch * float(182)))
    {
        Rot.Pitch = int(MinPitch * float(182));
    }
    // End:0xC0
    if(float(Rot.Yaw) > (MaxYaw * float(182)))
    {
        Rot.Yaw = int(MaxYaw * float(182));
    }
    // End:0x100
    if(float(Rot.Yaw) < (MinYaw * float(182)))
    {
        Rot.Yaw = int(MinYaw * float(182));
    }
    WeaponRotation = Rot;
    xpivot = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('pivotx'));
    ypivot = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('pivoty'));
    // End:0x1ED
    if((xpivot != none) && ypivot != none)
    {
        xpivot.ControlStrength = 1.0000000;
        ypivot.ControlStrength = 1.0000000;
        xpivot.BoneRotation.Roll = -Rot.Pitch;
        ypivot.BoneRotation.Pitch = Rot.Yaw;
    }
    //return;    
}

function PlayMWAnim()
{
    local AnimNodeSequence SeqNode;

    // End:0x9E
    if(SkeletalMeshComponent.Animations != none)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations.FindAnimNode('barrel'));
        // End:0x9E
        if(SeqNode != none)
        {
            SeqNode.SetAnim(FireAnimation);
            SeqNode.PlayAnim(true, 1.0000000);
            SeqNode.SetPosition(LastTime, false);
        }
    }
    //return;    
}

function StopMWAnim()
{
    local AnimNodeSequence SeqNode;

    // End:0x63
    if(SkeletalMeshComponent.Animations != none)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations.FindAnimNode('barrel'));
        // End:0x63
        if(SeqNode != none)
        {
            LastTime = SeqNode.CurrentTime;
        }
    }
    //return;    
}
