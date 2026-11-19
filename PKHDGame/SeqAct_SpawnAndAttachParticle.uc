class SeqAct_SpawnAndAttachParticle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() ParticleSystem ParticleToSpawn;

event Activated()
{
    local SeqVar_Object ObjVar;
    local editinline ParticleSystemComponent PSC;
    local PKPawn P;

    // End:0x16C
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
    {
        P = PKPawn(ObjVar.GetObjectValue());
        // End:0x16B
        if(P != none)
        {
            PSC = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI).GOP.GetImpactParticleSystemComponent(ParticleToSpawn);
            // End:0x16B
            if(PSC != none)
            {
                P.AttachComponent(PSC);
                PSC.SetActorParameter('BoneSocketActor', P);
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