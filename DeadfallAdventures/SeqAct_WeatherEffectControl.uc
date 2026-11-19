class SeqAct_WeatherEffectControl extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() MaterialInterface CylinderMaterial;
var() class<EmitterCameraLensEffectBase> CameraLensEffect;
var() float EffectIntensity;
var() float InterpSpeed;
var() ParticleSystem FloorParticleSystem;
var() Vector2D SlantRangePitch;
var() Vector2D SlantRangeRoll;
var() float SlantFixedTime;
var() float SlantRandomTime;
var() float SlantInterpExponent;

event Activated()
{
    local WeatherEffectProperties Wep;
    local AdvPlayerController PC;
    local Object O;
    local Actor A;

    // End:0x40F
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x2A5
        if(int(GetWorldInfo().NetMode) < int(NM_Client))
        {
            Wep.CylinderMaterial = CylinderMaterial;
            Wep.CameraLensEffect = CameraLensEffect;
            Wep.EffectIntensity = EffectIntensity;
            Wep.InterpSpeed = InterpSpeed;
            Wep.FloorParticleSystem = FloorParticleSystem;
            Wep.SlantRangePitch = SlantRangePitch;
            Wep.SlantRangeRoll = SlantRangeRoll;
            Wep.SlantFixedTime = SlantFixedTime;
            Wep.SlantRandomTime = SlantRandomTime;
            Wep.SlantInterpExponent = SlantInterpExponent;
            AdvGRI(GetWorldInfo().GRI).WeatherEffectProps = Wep;
            AdvGRI(GetWorldInfo().GRI).bWeatherEffectEnabled = true;
            // End:0x2A4
            foreach GetWorldInfo().LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                PC.UpdateWeatherEffects();                
            }            
        }
        PublishLinkedVariableValues();
        // End:0x40B
        foreach GetWorldInfo().LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            // End:0x40A
            if(PC.WeatherEffect != none)
            {
                // End:0x388
                foreach PC.WeatherEffect.ChildActors(Class'Engine.Actor', A)
                {
                    PC.WeatherEffect.DetachWeatherActor(A);                    
                }                
                // End:0x409
                foreach Targets(O)
                {
                    A = Actor(O);
                    // End:0x408
                    if(A != none)
                    {
                        PC.WeatherEffect.AttachWeatherActor(A);
                    }                    
                }                
            }            
        }                
    }
    else
    {
        // End:0x577
        if(InputLinks[1].bHasImpulse)
        {
            // End:0x49B
            if(int(GetWorldInfo().NetMode) < int(NM_Client))
            {
                AdvGRI(GetWorldInfo().GRI).bWeatherEffectEnabled = false;
            }
            // End:0x576
            foreach GetWorldInfo().LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                // End:0x575
                if(PC.WeatherEffect != none)
                {
                    // End:0x574
                    foreach PC.WeatherEffect.ChildActors(Class'Engine.Actor', A)
                    {
                        PC.WeatherEffect.DetachWeatherActor(A);                        
                    }                    
                }                
            }            
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    CylinderMaterial=MaterialInstanceConstant'adv_AtmosphericEffects.Materials.mi_rain_01_player'
    CameraLensEffect=Class'AdvEmitterCamera_RainDrops'
    EffectIntensity=1.0000000
    InterpSpeed=1.0000000
    FloorParticleSystem=ParticleSystem'adv_AtmosphericEffects.Effects.ps_RainDropSplash'
    SlantRangePitch=(X=-5.0000000,Y=5.0000000)
    SlantRangeRoll=(X=-5.0000000,Y=5.0000000)
    SlantFixedTime=0.3000000
    SlantRandomTime=4.7000000
    SlantInterpExponent=3.0000000
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Attachments",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Weather Effects Control"
}