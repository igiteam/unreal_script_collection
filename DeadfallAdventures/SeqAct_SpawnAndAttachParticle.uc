class SeqAct_SpawnAndAttachParticle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() ParticleSystem ParticleToSpawn;

event Activated()
{
    local SeqVar_Object ObjVar;
    local editinline ParticleSystemComponent PSC;
    local Actor A;

    // End:0x16C
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        A = Actor(ObjVar.GetObjectValue());
        // End:0x16B
        if(A != none)
        {
            PSC = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI).GOP.GetImpactParticleSystemComponent(ParticleToSpawn);
            // End:0x16B
            if(PSC != none)
            {
                A.AttachComponent(PSC);
                PSC.SetActorParameter('BoneSocketActor', A);
                PSC.ActivateSystem();
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    ObjName="Spawn And Attach Particle"
}