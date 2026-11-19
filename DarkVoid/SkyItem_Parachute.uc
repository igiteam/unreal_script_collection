class SkyItem_Parachute extends Inventory
    native;

enum EParachuteState
{
    PARASTATE_Closed,               // 0
    PARASTATE_Opening,              // 1
    PARASTATE_Open,                 // 2
    PARASTATE_MAX                   // 3
};

struct native ParachuteMorph
{
    var float MorphTime;
    var name MorphStart;
    var name MorphTarget;
    var float StartValueBegin;
    var float StartValueEnd;
    var float TargetValueBegin;
    var float TargetValueEnd;

    structdefaultproperties
    {
        MorphTime=0.0000000
        MorphStart="None"
        MorphTarget="None"
        StartValueBegin=0.0000000
        StartValueEnd=0.0000000
        TargetValueBegin=0.0000000
        TargetValueEnd=0.0000000
    }
};

var() float EquipTime;
var() float PutDownTime;
var(Audio) SoundCue OpenSound;
var(Audio) SoundCue CutSound;
var transient SkyPawn PlayerOwner;
var transient SkyItem_Parachute.EParachuteState ParaState;
var transient float CurrentMorphTime;
var transient int CurrentMorph;
var array<ParachuteMorph> ParachuteMorphs;
var() export editinline SkeletalMeshComponent Mesh;
var export editinline transient SkeletalMeshComponent OwnerMesh;
var transient name AttachSocket;

// Export USkyItem_Parachute::execInitMorphTarget(FFrame&, void* const)
native function InitMorphTarget();

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    //return;    
}

function ItemRemovedFromInvManager()
{
    super.ItemRemovedFromInvManager();
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    super.GivenTo(thisPawn, bDoNotActivate);
    PlayerOwner = SkyPawn(thisPawn);
    // End:0x3A
    if(!bDoNotActivate && thisPawn != none)
    {
    }
    //return;    
}

simulated event AttachTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    OwnerMesh = MeshCpnt;
    AttachSocket = SocketName;
    Mesh.SetLightEnvironment(MeshCpnt.LightEnvironment);
    //return;    
}

simulated function ParachutePlaySound(SoundCue Sound)
{
    // End:0x1A
    if((Sound == none) || Instigator == none)
    {
        return;
    }
    // End:0x51
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        Owner.PlaySound(Sound, false, true);        
    }
    else
    {
        Owner.PlaySound(Sound);
    }
    //return;    
}

simulated function Activate()
{
    GotoState('Active');
    //return;    
}

simulated event Deactivate()
{
    //return;    
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return FOVAngle;
    //return ReturnValue;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        SetHidden(true);
        // End:0x27
        if(OwnerMesh != none)
        {
            OwnerMesh.DetachComponent(Mesh);
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        SetHidden(false);
        // End:0x2C
        if(OwnerMesh != none)
        {
            OwnerMesh.AttachComponentToSocket(Mesh, AttachSocket);
        }
        ParachutePlaySound(OpenSound);
        InitMorphTarget();
        //return;        
    }

    simulated event Deactivate()
    {
        // End:0x3E
        if(((int(ParaState) != int(2)) && SkyPawn(Owner) != none) && SkyPawn(Owner).bIsParachuting)
        {
            return;
        }
        ParachutePlaySound(CutSound);
        ParaState = 0;
        GotoState('Inactive');
        //return;        
    }
    stop;    
}
