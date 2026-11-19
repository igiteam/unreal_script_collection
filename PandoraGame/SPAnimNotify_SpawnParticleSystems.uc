class SPAnimNotify_SpawnParticleSystems extends AnimNotify
    native
    editinlinenew
    collapsecategories;

struct native SpawnParticleSystemInfo
{
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() name SocketName;
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() ParticleSystem ParticleSystem;
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() float Scale;
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() bool CastShadows;
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() bool InForeGround;

    structdefaultproperties
    {
        SocketName="None"
        ParticleSystem=none
        Scale=1.0000000
        CastShadows=false
        InForeGround=false
    }
};

var() bool AttachToSpawner;
var() bool DeleteOnDetach;
var() bool SpawnWhenOwnerHidden;
var() array<SpawnParticleSystemInfo> SpawnParticleInfoTable;

simulated function GetSpawnInformation(Actor NewParent, name SocketName, out SkeletalMeshComponent SkelMesh, out name BoneName, out Vector NewLoc, out Rotator NewRot)
{
    local bool socketExists;

    socketExists = false;
    SkelMesh = none;
    // End:0x96
    if(SocketName != 'None')
    {
        SkelMesh = NewParent.GetSkeletalMeshComponent();
        // End:0x96
        if(SkelMesh != none)
        {
            socketExists = SkelMesh.GetSocketWorldLocationAndRotation(SocketName, NewLoc, NewRot);
            // End:0x96
            if(socketExists)
            {
                BoneName = Class'SPPawn'.static.GenericSocketNameToBoneName(SkelMesh, SocketName);
            }
        }
    }
    // End:0xD2
    if(!socketExists)
    {
        SkelMesh = none;
        NewLoc = NewParent.Location;
        NewRot = NewParent.Rotation;
    }
    //return;    
}

simulated event CreateEmitters(Actor NewParent)
{
    local int I;
    local SPEmitter newEmitter;
    local Vector emitterLoc;
    local Rotator emitterRot;
    local editinline SkeletalMeshComponent SkelMesh;
    local name BoneName;
    local editinline ParticleSystemComponent psComp;

    // End:0x22
    if(!SpawnWhenOwnerHidden && NewParent.bHidden)
    {
        return;
    }
    I = 0;
    J0x29:

    // End:0x23E [Loop If]
    if(I < SpawnParticleInfoTable.Length)
    {
        GetSpawnInformation(NewParent, SpawnParticleInfoTable[I].SocketName, SkelMesh, BoneName, emitterLoc, emitterRot);
        newEmitter = NewParent.Spawn(Class'SPEmitterSpawnable',,, emitterLoc, emitterRot);
        // End:0x234
        if(newEmitter != none)
        {
            newEmitter.SetTemplate(SpawnParticleInfoTable[I].ParticleSystem, true);
            psComp = newEmitter.ParticleSystemComponent;
            psComp.SetScale(SpawnParticleInfoTable[I].Scale);
            psComp.CastShadow = SpawnParticleInfoTable[I].CastShadows;
            newEmitter.bDestroyOnSystemFinish = true;
            // End:0x178
            if(SpawnParticleInfoTable[I].InForeGround)
            {
                psComp.SetDepthPriorityGroup(2);
            }
            // End:0x222
            if(AttachToSpawner)
            {
                newEmitter.SetOwner(NewParent);
                newEmitter.SetBase(NewParent, vect(0.0000000, 0.0000000, 1.0000000), SkelMesh, BoneName, true);
                newEmitter.bDeleteOnDetach = DeleteOnDetach;
                // End:0x222
                if(SPSkeletalMeshComponent(SkelMesh) != none)
                {
                    newEmitter.ParticleSystemComponent.SetFOV(SPSkeletalMeshComponent(SkelMesh).GetFOV());
                }
            }
            newEmitter.bKillDuringLevelTransition = true;
        }
        I++;
        // [Loop Continue]
        goto J0x29;
    }
    //return;    
}

defaultproperties
{
    DeleteOnDetach=true
}