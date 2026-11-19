class MonsterMachineLFHolder extends SPLifeForceHolder
    placeable;

struct StreamStruct
{
    var PlayerPawn StreamTaker;
    var bool StreamAdd;

    structdefaultproperties
    {
        StreamTaker=none
        StreamAdd=false
    }
};

var repnotify StreamStruct RepStream;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        RepStream;
}

simulated function PostBeginPlay()
{
    InitialLifeForceAmount = LifeForceAmount;
    //return;    
}

simulated function CreateParticleStream(PlayerPawn taker)
{
    local Vector SourceVector, targetVector, differenceVector, scalerVector;
    local int numAnimusEmitters;
    local string sourceString;
    local editinline ParticleSystemComponent Comp;

    taker.AddSiphonStream(self);
    // End:0x30
    if(int(Role) == int(ROLE_Authority))
    {
        ParentActor = Owner;
    }
    targetVector = taker.Location;
    numAnimusEmitters = 0;
    // End:0x1D0
    if(1 == 1)
    {
        AnimusEmitter[numAnimusEmitters] = Spawn(Class'SPEmitterSpawnable', self);
        AnimusEmitter[numAnimusEmitters].bKillDuringLevelTransition = true;
        sourceString = "Center_3";
        SourceVector = Location;
        differenceVector = SourceVector - targetVector;
        scalerVector = Normal(differenceVector) * 0.2000000;
        scalerVector.Z += float(100);
        // End:0x112
        if(m_bIsAnimusPack)
        {
            AnimusEmitter[numAnimusEmitters].SetFloatParameter('particleLifetime', 10000.0000000);
        }
        AnimusEmitter[numAnimusEmitters].SetTemplate(SyphoningParticleSystem, false);
        // End:0x16F
        if(ParentActor != none)
        {
            InitializePathFollowingSignetCurve(ParentActor, taker, scalerVector, scalerVector, AnimusEmitter[numAnimusEmitters], sourceString,,,, true, true);            
        }
        else
        {
            InitializePathFollowingSignetCurve(none, taker, scalerVector, scalerVector, AnimusEmitter[numAnimusEmitters], sourceString, ParentLoc, true, Location, true, true);
        }
        Comp = AnimusEmitter[numAnimusEmitters].ParticleSystemComponent;
        Comp.ActivateSystem();
        return;
    }
    //return;    
}

simulated function TerminateParticleStream(PlayerPawn taker)
{
    local int I;

    taker.RemoveSiphonStream(self);
    I = 0;
    J0x1C:

    // End:0x69 [Loop If]
    if(I < AnimusEmitter.Length)
    {
        AnimusEmitter[I].ParticleSystemComponent.DeactivateSystem();
        AnimusEmitter[I].Destroy();
        I++;
        // [Loop Continue]
        goto J0x1C;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x61
    if(VarName == 'RepStream')
    {
        // End:0x44
        if(RepStream.StreamAdd)
        {
            CreateParticleStream(RepStream.StreamTaker);            
        }
        else
        {
            TerminateParticleStream(RepStream.StreamTaker);
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}
