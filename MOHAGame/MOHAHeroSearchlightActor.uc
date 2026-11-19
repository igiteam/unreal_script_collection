class MOHAHeroSearchlightActor extends Actor
    native
    placeable
    hidecategories(Navigation);

enum SpotLightState
{
    SpotLightState_Off,             // 0
    SpotLightState_MannedIdle,      // 1
    SpotLightState_MannedTargetTracking,// 2
    SpotLightState_Locked,          // 3
    SpotLightState_MAX              // 4
};

var() float OffsetAngle;
var() export editinline SkeletalMeshComponent SpotLightMesh;
var(BeamMesh) export editinline StaticMeshComponent BeamMesh;
var bool bIncP;
var bool bIncY;
var(Light) bool bCastActualSpotLight;
var(BeamMesh) bool bLightMeshVisibleEditor;
var SkelControlSingleBone PitchControl;
var SkelControlSingleBone YawControl;
var float fPitch;
var float fYaw;
var float yawChangeRate;
var float pitchChangeRate;
var(MannedIdle) float yawDegreesPerSecond;
var(MannedIdle) float pitchDegreesPerSecond;
var(MannedIdle) float minPitchAngle;
var(MannedIdle) float maxPitchAngle;
var(MannedIdle) float maxYawAngle;
var(MannedIdle) float minYawAngle;
var(MannedIdle) float maxTimeUntilYawReverse;
var(MannedIdle) float minTimeUntilYawReverse;
var(MannedIdle) float initialPitchAngle;
var(MannedIdle) float initialYawAngle;
var(MannedIdle) float CylinderRadius;
var(Light) export editinline SpotLightComponent SearchLightComponent;
var() float previewVolumeSkewHeight;
var() int numPreviewVerts;
var() float fPlayerSearchInterval;
var float timeUntilYawReverse;
var name BeamSocket;
var name SpotlightSocket;
var name BlindPlayerFunction;
var export editinline MOHADrawSearchAreaComponent previewVolume;
var protected MaterialInstance NormalMaterial;
var protected MaterialInstance OffMaterial;
var protected MaterialInstance BrokenMaterial;
var export editinline ParticleSystemComponent GlassFX;
var export editinline PrimitiveComponent GlassCollision;
var SoundCue GlassBreakingSound;

// Export UMOHAHeroSearchlightActor::execUpdateMannedIdle(FFrame&, void* const)
native function UpdateMannedIdle(float DeltaSeconds);

event SwitchYaw()
{
    // End:0x14
    if(bIncY)
    {
        bIncY = false;        
    }
    else
    {
        bIncY = true;
    }
    timeUntilYawReverse = (FRand() * (maxTimeUntilYawReverse - minTimeUntilYawReverse)) + minTimeUntilYawReverse;
    //return;    
}

event OutOfRange()
{
    fPitch = float(PitchControl.BoneRotation.Pitch);
    fYaw = float(Rotation.Yaw);
    GotoState('MannedIdle');
    //return;    
}

simulated function CheckForBlindedPlayer()
{
    local MOHAPlayerController PC;
    local float fMaxAngle, fPlayerMaxAngle;
    local Vector vLightPos, vLightRotation, vPlayerRotation, vLightToPlayer;
    local Rotator rLightRotation;

    SpotLightMesh.GetSocketWorldLocationAndRotation(BeamSocket, vLightPos, rLightRotation);
    GetAxes(rLightRotation, vLightToPlayer, vLightToPlayer, vLightRotation);
    fMaxAngle = (SearchLightComponent.OuterConeAngle * 0.0174533) * 2.0000000;
    fPlayerMaxAngle = (35.0000000 * 0.0174533) * 2.0000000;
    // End:0x163
    foreach LocalPlayerControllers(PC)
    {
        // End:0x162
        if(PC != none)
        {
            vLightToPlayer = Normal(PC.PlayerCamera.ViewTarget.POV.Location - vLightPos);
            vPlayerRotation = Vector(PC.PlayerCamera.ViewTarget.POV.Rotation);
            // End:0x14D
            if((Abs(Acos(vLightToPlayer Dot vLightRotation)) < fMaxAngle) && Abs(Acos(vPlayerRotation Dot -vLightToPlayer)) < fPlayerMaxAngle)
            {
                PC.BlindedBySpotlight(self, true);
                // End:0x162
                continue;
            }
            PC.BlindedBySpotlight(self, false);
        }        
    }    
    //return;    
}

function PostBeginPlay()
{
    SpotLightMesh.AttachComponentToSocket(SearchLightComponent, SpotlightSocket);
    SpotLightMesh.AttachComponentToSocket(GlassCollision, BeamSocket);
    SpotLightMesh.AttachComponentToSocket(GlassFX, BeamSocket);
    // End:0x69
    if(!bCastActualSpotLight)
    {
        SearchLightComponent.SetEnabled(false);        
    }
    else
    {
        SearchLightComponent.SetEnabled(true);
    }
    SpotLightMesh.AttachComponentToSocket(BeamMesh, BeamSocket);
    PitchControl = SkelControlSingleBone(SpotLightMesh.FindSkelControl('PitchControl'));
    PitchControl.ControlStrength = 1.0000000;
    PitchControl.SetSkelControlActive(true);
    YawControl = SkelControlSingleBone(SpotLightMesh.FindSkelControl('YawControl'));
    YawControl.ControlStrength = 1.0000000;
    YawControl.SetSkelControlActive(true);
    initialPitchAngle = (initialPitchAngle * 16384.0000000) / 90.0000000;
    initialYawAngle = (initialYawAngle * 16384.0000000) / 90.0000000;
    // End:0x1A7
    if((initialPitchAngle >= ((maxPitchAngle * 16384.0000000) / 90.0000000)) || initialPitchAngle <= ((minPitchAngle * 16384.0000000) / 90.0000000))
    {
        initialPitchAngle = (minPitchAngle * 16384.0000000) / 90.0000000;
    }
    // End:0x1FC
    if((initialYawAngle >= ((maxYawAngle * 16384.0000000) / 90.0000000)) || initialYawAngle <= ((minYawAngle * 16384.0000000) / 90.0000000))
    {
        initialYawAngle = (minYawAngle * 16384.0000000) / 90.0000000;
    }
    PitchControl.BoneRotation.Pitch = int(initialPitchAngle);
    fPitch = initialPitchAngle + ((OffsetAngle * 16384.0000000) / 90.0000000);
    fYaw = initialYawAngle;
    // End:0x261
    if(yawDegreesPerSecond < 0.0000000)
    {
        yawDegreesPerSecond = 15.0000000;
    }
    // End:0x27B
    if(pitchDegreesPerSecond < 0.0000000)
    {
        pitchDegreesPerSecond = 2.0000000;
    }
    yawChangeRate = yawDegreesPerSecond * (16384.0000000 / 90.0000000);
    pitchChangeRate = pitchDegreesPerSecond * (16384.0000000 / 90.0000000);
    timeUntilYawReverse = (FRand() * (maxTimeUntilYawReverse - minTimeUntilYawReverse)) + minTimeUntilYawReverse;
    // End:0x2F4
    if(!Class'MOHAUtilities'.static.IsEditorActive())
    {
        DetachComponent(previewVolume);
        previewVolume = none;
    }
    //return;    
}

function OnHeroSearchLightUpdateProperties(SeqAct_HeroSearchLightUpdateProperties Action)
{
    // End:0x31
    if(Action.InputLinks[1].bHasImpulse)
    {
        SearchLightComponent.SetEnabled(true);        
    }
    else
    {
        // End:0x63
        if(Action.InputLinks[2].bHasImpulse)
        {
            SearchLightComponent.SetEnabled(false);            
        }
        else
        {
            // End:0xA2
            if(Action.InputLinks[3].bHasImpulse)
            {
                SearchLightComponent.SetEnabled(!SearchLightComponent.bEnabled);
            }
        }
    }
    // End:0x109
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0xE6
        if(int(Action.NewState) == int(0))
        {
            TurnOff();            
        }
        else
        {
            // End:0x109
            if(int(Action.NewState) == int(1))
            {
                TurnOn();
            }
        }
    }
    //return;    
}

function OnSetFinalState(SeqAct_SetFinalState inAction)
{
    GotoState('Final');
    //return;    
}

function TurnOff()
{
    GotoState('Off');
    //return;    
}

function TurnOn()
{
    GotoState('MannedIdle');
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local bool bGlassBulletHit, bExplosiveDamage;

    bGlassBulletHit = HitInfo.HitComponent == GlassCollision;
    bExplosiveDamage = ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType');
    // End:0x97
    if(InstigatedBy.IsA('MOHAPlayerController') && bGlassBulletHit || bExplosiveDamage)
    {
        GotoState('Broken');
        super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

function VerifyRespawnCleanup()
{
    PrintRespawnWarning();
    //return;    
}

state Off
{
    function BeginState(name PreviousStateName)
    {
        local MOHAPlayerController PC;

        BeamMesh.SetOnlyOwnerSee(true);
        SearchLightComponent.SetEnabled(false);
        SpotLightMesh.SetMaterial(2, OffMaterial);
        // End:0x69
        foreach LocalPlayerControllers(PC)
        {
            // End:0x68
            if(PC != none)
            {
                PC.BlindedBySpotlight(self, false);
            }            
        }        
        ClearTimer(BlindPlayerFunction);
        //return;        
    }
    stop;    
}

state Broken
{
    function BeginState(name PreviousStateName)
    {
        GlassFX.ActivateSystem();
        PlaySound(GlassBreakingSound);
        TriggerEventClass(Class'Engine.SeqEvent_Death', self);
        GotoState('Final');
        //return;        
    }
    stop;    
}

state Final extends Off
{
    function BeginState(name PreviousStateName)
    {
        OffMaterial = BrokenMaterial;
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

auto state MannedIdle
{
    function BeginState(name PreviousStateName)
    {
        BeamMesh.SetOnlyOwnerSee(false);
        SpotLightMesh.SetMaterial(2, NormalMaterial);
        //return;        
    }

    function Tick(float DeltaTime)
    {
        UpdateMannedIdle(DeltaTime);
        //return;        
    }
    stop;    
}

defaultproperties
{
    OffsetAngle=20.0000000
    bIncP=true
    bIncY=true
    yawChangeRate=1.0000000
    pitchChangeRate=1.0000000
    yawDegreesPerSecond=15.0000000
    pitchDegreesPerSecond=2.0000000
    minPitchAngle=15.0000000
    maxPitchAngle=90.0000000
    maxYawAngle=360.0000000
    maxTimeUntilYawReverse=30.0000000
    minTimeUntilYawReverse=20.0000000
    initialPitchAngle=50.0000000
    CylinderRadius=1000.0000000
    // Reference: SpotLightComponent'Default__MOHAHeroSearchlightActor.SpotLightComponent0'
    begin object name=SpotLightComponent0 class=Class'Engine.SpotLightComponent'
        InnerConeAngle=2.0000000
        OuterConeAngle=10.0000000
        Radius=9500.0000000
        Brightness=15.0000000
        bEnabled=false
        CastShadows=false
        CastStaticShadows=false
        CastDynamicShadows=false
    end object
    SearchLightComponent=SpotLightComponent0
    previewVolumeSkewHeight=1000.0000000
    numPreviewVerts=8
    fPlayerSearchInterval=0.2000000
    BeamSocket="SpotlightBeam"
    SpotlightSocket="SpotlightSocket"
    BlindPlayerFunction="CheckForBlindedPlayer"
    // Reference: MOHADrawSearchAreaComponent'Default__MOHAHeroSearchlightActor.SearchAreaComponent0'
    begin object name=SearchAreaComponent0 class=Class'MOHADrawSearchAreaComponent'
        maxYaw=360.0000000
        minYaw=0.0000000
        minPitch=15.0000000
        maxPitch=90.0000000
    end object
    previewVolume=SearchAreaComponent0
    // Reference: ParticleSystemComponent'Default__MOHAHeroSearchlightActor.Glass'
    begin object name=Glass class=Class'Engine.ParticleSystemComponent'
        Template=ParticleSystem'HUS_VFX_srchlt.shatter'
    end object
    GlassFX=Glass
    // Reference: StaticMeshComponent'Default__MOHAHeroSearchlightActor.GlassCollision'
    begin object name=GlassCollision class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Searchlight.GlassCollision'
        HiddenGame=true
        HiddenEditor=true
    end object
    GlassCollision=GlassCollision
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAHeroSearchlightActor.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    Components[1]=SpotLightComponent0
    Components[2]=GlassCollision
    Components[3]=SearchAreaComponent0
    Components[4]=Glass
    ActorType=11
    bTakesRadiusDamage=true
    bCollideActors=true
    bBlockActors=true
    CollisionType=0
    SupportedEvents=/* Array type was not detected. */
}