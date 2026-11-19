class SkyAnimNotify_Effect extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() ParticleSystem Effect;
var() name Bone;
var() name MirroredBone;
var() Vector Offset;
var() Rotator Rotation;
var() bool bDebug;
var() bool bFollowSocket;
var() name SocketToFollow;
var() name EffectContext;

// Export USkyAnimNotify_Effect::execDrawEffectDebug(FFrame&, void* const)
native function DrawEffectDebug(Vector Loc, Rotator Rot);

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;
    local SkyVehicle V;
    local SkyGameInteractor SGI;
    local Emitter EffectEmitter;
    local Vector EffectLocation;
    local Rotator EffectRotation;
    local ParticleSystem Template;
    local SkyGameReplicationInfo GRI;
    local editinline SkyParticleSystemComponent PSC;
    local name BoneName;

    P = SkyPawn(Owner);
    V = SkyVehicle(Owner);
    // End:0x292
    if((P != none) && P.Mesh != none)
    {
        // End:0x6F
        if(Effect == none)
        {
            Template = P.GetContextualEffect(EffectContext);            
        }
        else
        {
            Template = Effect;
        }
        // End:0x87
        if(Template == none)
        {
            return;
        }
        // End:0xF5
        if(bFollowSocket)
        {
            PSC = new (self) Class'SkyParticleSystemComponent';
            P.Mesh.AttachComponentToSocket(PSC, SocketToFollow);
            PSC.SetTemplate(Template);
            PSC.__OnSystemFinished__Delegate = KillPSCOnSystemFinished;            
        }
        else
        {
            // End:0x131
            if((SkyAnimNodeSequence(AnimSeqInstigator) != none) && SkyAnimNodeSequence(AnimSeqInstigator).IsNodeMirrored())
            {
                BoneName = MirroredBone;                
            }
            else
            {
                BoneName = Bone;
            }
            P.Mesh.TransformFromBoneSpace(BoneName, Offset, Rotation, EffectLocation, EffectRotation);
            // End:0x18C
            if(bDebug)
            {
                DrawEffectDebug(EffectLocation, EffectRotation);
            }
            // End:0x28F
            if(P.EffectIsRelevant(EffectLocation, false))
            {
                GRI = SkyGameReplicationInfo(P.WorldInfo.GRI);
                // End:0x21A
                if(GRI.SOP != none)
                {
                    EffectEmitter = GRI.SOP.CreateEmitter(Template, P, EffectLocation, EffectRotation);                    
                }
                else
                {
                    EffectEmitter = P.Spawn(Class'SkyEmitter', P,, EffectLocation, EffectRotation);
                    // End:0x26C
                    if(EffectEmitter != none)
                    {
                        EffectEmitter.SetTemplate(Template, true);
                    }
                }
                EffectEmitter.SetMovingLevel(P.MovingLevel);
            }
        }        
    }
    else
    {
        // End:0x322
        if((V != none) && V.Mesh != none)
        {
            // End:0x31F
            if(bFollowSocket)
            {
                PSC = new (self) Class'SkyParticleSystemComponent';
                V.Mesh.AttachComponentToSocket(PSC, SocketToFollow);
                PSC.SetTemplate(Effect);
                PSC.__OnSystemFinished__Delegate = KillPSCOnSystemFinished;
            }            
        }
        else
        {
            // End:0x444
            if((P == none) && SkyGameInteractor(Owner) != none)
            {
                SGI = SkyGameInteractor(Owner);
                SGI.SkeletalMeshComponent.TransformFromBoneSpace(Bone, Offset, Rotation, EffectLocation, EffectRotation);
                GRI = SkyGameReplicationInfo(P.WorldInfo.GRI);
                // End:0x3F2
                if(GRI.SOP != none)
                {
                    EffectEmitter = GRI.SOP.CreateEmitter(Effect, SGI, EffectLocation, EffectRotation);                    
                }
                else
                {
                    EffectEmitter = SGI.Spawn(Class'SkyEmitter', SGI,, EffectLocation, EffectRotation);
                    // End:0x444
                    if(EffectEmitter != none)
                    {
                        EffectEmitter.SetTemplate(Effect, true);
                    }
                }
            }
        }
    }
    //return;    
}

simulated function KillPSCOnSystemFinished(ParticleSystemComponent PSC)
{
    PSC.KillParticlesForced();
    PSC.DeactivateSystem();
    SkyParticleSystemComponent(PSC).MyOnParticleSystemFinished(PSC);
    PSC.DetachFromAny();
    //return;    
}
