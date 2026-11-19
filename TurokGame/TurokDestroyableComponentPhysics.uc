class TurokDestroyableComponentPhysics extends TurokDestroyableComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,Lighting);

var() export editinline @NULL mResidualComponents[3];

simulated event Init()
{
    local int I;

    super.Init();
    mNumResidualComponents = 0;
    I = 0;
    J0x14:

    // End:0x58 [Loop If]
    if(I < 3)
    {
        // End:0x4E
        if(mResidualComponents[I] != none)
        {
            mNumResidualComponents++;
            mResidualComponents[I].SetHidden(true);
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

simulated function PlayDestructionEffects(@NULL HitLocation, @NULL Momentum, class<Class> pDamageType)
{
    local int I;
    local @NULL pResidualActor, drawScaleCopy, ApplyImpulse;

    // End:0x1E5
    if(!IsDestroyed())
    {
        super.PlayDestructionEffects(HitLocation, Momentum, pDamageType);
        I = 0;
        J0x2B:

        // End:0x1E5 [Loop If]
        if(I < mNumResidualComponents)
        {
            // End:0x1DB
            if(mResidualComponents[I] != none)
            {
                pResidualActor = Owner.__NFUN_278__(Class'Engine.KActor');
                // End:0x76
                if(pResidualActor == none)
                {
                    // [Explicit Continue]
                    goto J0x1DB;
                }
                pResidualActor.StaticMeshComponent.SetStaticMesh(mResidualComponents[I].StaticMesh);
                pResidualActor.StaticMeshComponent.PhysMaterialOverride = mResidualComponents[I].PhysMaterialOverride;
                drawScaleCopy.X = Owner.DrawScale3D.X;
                drawScaleCopy.Y = Owner.DrawScale3D.Y;
                drawScaleCopy.Z = Owner.DrawScale3D.Z;
                pResidualActor.SetDrawScale3D(drawScaleCopy);
                pResidualActor.StaticMeshComponent.WakeRigidBody();
                // End:0x1DB
                if(pDamageType.default.KDamageImpulse > float(0))
                {
                    // End:0x1DB
                    if(VSize(Momentum) >= 0.0010000)
                    {
                        ApplyImpulse = Normal(Momentum) * pDamageType.default.KDamageImpulse;
                        pResidualActor.StaticMeshComponent.AddImpulse(ApplyImpulse, HitLocation);
                    }
                }
            }
            J0x1DB:

            I++;
            // [Loop Continue]
            goto J0x2B;
        }
    }
    //return;    
}
