class MOHAAxisAIPawn extends MOHAAIPawn
    config(Game)
    hidecategories(Navigation);

state Dying
{
    function NotifyDeathRagdoll()
    {
        // End:0x71
        if(!bNoRagdoll)
        {
            // End:0x71
            if((LastRenderTime > (WorldInfo.TimeSeconds - 1.0000000)) && VSize(Velocity) > 600.0000000)
            {
                BroadcastStimulus("MOHA_CC.Stimuli.SurprisePleasant", self, 10000.0000000, 1);
            }
        }
        super.NotifyDeathRagdoll();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: OirInstance'Default__MOHAAxisAIPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAAxisAIPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAAxisAIPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAAxisAIPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAAxisAIPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAAxisAIPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAAxisAIPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    CCNationality=3
    // Reference: AxonScriptEventObserverComponent'Default__MOHAAxisAIPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAxisAIPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__MOHAAxisAIPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAxisAIPawn.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAAxisAIPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAAxisAIPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAAxisAIPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAAxisAIPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    ActorType=7
    CollisionComponent=MOHACollisionCylinder
}