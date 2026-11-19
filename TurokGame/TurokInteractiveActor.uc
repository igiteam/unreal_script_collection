class TurokInteractiveActor extends Actor
    native
    placeable
    hidecategories(Navigation);

var() export editinline @NULL mpIntactComponent;
var(LightEnvironment) export editinline @NULL LightEnvironment;

// Export UTurokInteractiveActor::execGetIntactComponent(FFrame&, void* const)
native function @NULL GetIntactComponent();

simulated event TakeImpact(class<Class> pDamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
{
    local editinline @NULL pUVAnimComponent;
    local class<Class> pTurokDamageType;

    pUVAnimComponent = TurokUVAnimComponent(HitInfo.HitComponent);
    // End:0x91
    if((pUVAnimComponent != none) && pUVAnimComponent.mEnableUVAnim)
    {
        pTurokDamageType = class<TurokDamageType>(pDamageType);
        // End:0x91
        if(pTurokDamageType != none)
        {
            pUVAnimComponent.Override(pTurokDamageType.default.mUVAnimAmplitude, pTurokDamageType.default.mUVAnimFrequency, pTurokDamageType.default.mUVAnimDuration);
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x24
    if(mpIntactComponent != none)
    {
        mpIntactComponent.Init();
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokUVAnimComponent'Default__TurokInteractiveActor.pIntactComponent0'
    begin object name=pIntactComponent0 class=Class'TurokUVAnimComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokInteractiveActor.MyLightEnvironment'
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object
    mpIntactComponent=pIntactComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokInteractiveActor.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    bNoDelete=true
    bWorldGeometry=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    bGameRelevant=true
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    Components[0]=MyLightEnvironment
    Components[1]=pIntactComponent0
    RemoteRole=1
}