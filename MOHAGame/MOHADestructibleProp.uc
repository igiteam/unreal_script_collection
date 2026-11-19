class MOHADestructibleProp extends KActor
    hidecategories(Display,Object);

var() float MassMultiplier;
var() int Health;
var() export editinline array<export editinline MOHAPropState> States;
var() array< class<DamageType> > MyDamageTypes;
var int CurrentState;
var export editinline array<export editinline ParticleSystemComponent> StateChangeParticles;
var export editinline AudioComponent StateChangeSound;
var int MaxHealth;
var int TimerCount;
var int StoredState;
var bool bCancelTimer;

function bool InValidState()
{
    // End:0x32
    if(((CurrentState < 0) || CurrentState >= States.Length) || States[CurrentState] == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function MOHAPropState GetThisState()
{
    return States[CurrentState];
    //return ReturnValue;    
}

function bool InLastState()
{
    // End:0x48
    if((((InValidState()) == false) || GetThisState().IsDeathState()) || GetThisState().bFinalState)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool prevState()
{
    // End:0x1F
    if((CurrentState == 0) || (InLastState()) == true)
    {
        return false;
    }
    CurrentState--;
    return true;
    //return ReturnValue;    
}

function bool NextState()
{
    // End:0x0F
    if(InLastState())
    {
        return false;
    }
    CurrentState++;
    return true;
    //return ReturnValue;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local bool stateChanged;

    stateChanged = false;
    // End:0x118
    if(Class'MOHAUtilities'.static.MatchingDamageType(MyDamageTypes, DamageType))
    {
        Health -= Damage;
        J0x36:

        // End:0x84 [Loop If]
        if(!InLastState() && GetThisState().NeedHealthChange(float(Health), float(MaxHealth)))
        {
            stateChanged = NextState();
            // [Loop Continue]
            goto J0x36;
        }
        // End:0x98
        if(stateChanged)
        {
            LoadState();
        }
        // End:0xF0
        if(HitInfo.HitComponent != none)
        {
            HitInfo.HitComponent.AddImpulse(Momentum / (float(100) * MassMultiplier), HitLocation, HitInfo.BoneName);            
        }
        else
        {
            CollisionComponent.AddImpulse(Momentum / (float(100) * MassMultiplier), HitLocation);
        }
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function SetState()
{
    // End:0x0D
    if(TimerCount == 0)
    {
        return;
    }
    TimerCount--;
    // End:0x43
    if((TimerCount == 0) && bCancelTimer == false)
    {
        CurrentState = StoredState;
        LoadState();
    }
    //return;    
}

function OnPropStateChange(SeqAct_PropStateChange inAction)
{
    // End:0x0F
    if(InLastState())
    {
        return;
    }
    // End:0x50
    if(inAction.InputLinks[0].bHasImpulse)
    {
        // End:0x4D
        if(prevState())
        {
            bCancelTimer = true;
            LoadState();
        }        
    }
    else
    {
        // End:0x91
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0x8E
            if(NextState())
            {
                bCancelTimer = true;
                LoadState();
            }            
        }
        else
        {
            // End:0x122
            if(inAction.InputLinks[2].bHasImpulse)
            {
                // End:0x122
                if(Abs(float(inAction.SpecialState)) < float(States.Length))
                {
                    bCancelTimer = true;
                    CurrentState = ((inAction.SpecialState < 0) ? States.Length - inAction.SpecialState : inAction.SpecialState);
                    LoadState();
                }
            }
        }
    }
    //return;    
}

function ApplyForces(Vector Direction, float Force, float Offset, float random_spin)
{
    local Vector HitLocation;
    local Rotator Axis;
    local Vector Up, at, Right;
    local float Angle, Distance;

    Axis = Rotator(Direction);
    Axis = Normalize(Axis);
    GetAxes(Axis, at, Up, Right);
    Distance = FRand() * Offset;
    Angle = (FRand() * 3.1415930) * 2.0000000;
    HitLocation = Right * Cos(Angle);
    HitLocation += (Up * Sin(Angle));
    HitLocation *= Distance;
    HitLocation += Location;
    CollisionComponent.AddImpulse((Direction * Force) / (100.0000000 * MassMultiplier), HitLocation);
    Axis = RotRand();
    Axis = Normalize(Axis);
    GetAxes(Axis, at, Up, Right);
    at *= (((FRand() * 2.0000000) - 1.0000000) * random_spin);
    CollisionComponent.SetRBAngularVelocity(at, true);
    //return;    
}

function TriggerKismetEvents()
{
    local array<int> actived_indices;
    local int idx;

    actived_indices[actived_indices.Length] = 0;
    // End:0x29
    if(InLastState())
    {
        actived_indices[actived_indices.Length] = 1;
    }
    idx = 0;
    J0x30:

    // End:0xEA [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        // End:0xE0
        if(ClassIsChildOf(GeneratedEvents[idx].Class, Class'SeqEvent_PropStateChange'))
        {
            // End:0xC2
            if(SeqEvent_PropStateChange(GeneratedEvents[idx]).SpecialState == CurrentState)
            {
                actived_indices[actived_indices.Length] = 2;
                GeneratedEvents[idx].CheckActivate(self, self, false, actived_indices);
                actived_indices.Length = actived_indices.Length - 1;
                // [Explicit Continue]
                goto J0xE0;
            }
            GeneratedEvents[idx].CheckActivate(self, self, false, actived_indices);
        }
        J0xE0:

        idx++;
        // [Loop Continue]
        goto J0x30;
    }
    //return;    
}

function LoadState(optional bool TriggerEvent = true)
{
    local editinline MOHAPropState thisState;
    local int numParticles, I;

    // End:0x17
    if((InValidState()) == false)
    {
        return;
    }
    thisState = GetThisState();
    // End:0x54
    if(thisState.IsDeathState())
    {
        SetPhysics(0);
        SetHidden(true);
        SetCollision(false, false);
        Destroy();
        return;
    }
    // End:0xC2
    if(thisState.DoPhysics)
    {
        SetPhysics(10);
        // End:0xBF
        if(thisState.bApplyForce)
        {
            ApplyForces(thisState.Direction, thisState.Force, thisState.Offset, thisState.RandomSpin);
        }        
    }
    else
    {
        SetPhysics(0);
    }
    // End:0xDD
    if(TriggerEvent == true)
    {
        TriggerKismetEvents();
    }
    // End:0x135
    if(thisState.IsTimerState() == true)
    {
        TimerCount++;
        bCancelTimer = false;
        StoredState = CurrentState + 1;
        SetTimer(thisState.GetStateTime(), false, 'SetState');
    }
    // End:0x17D
    if((thisState.SwapMesh != none) && thisState.bRemoveMesh == false)
    {
        StaticMeshComponent.SetStaticMesh(thisState.SwapMesh);
    }
    // End:0x1A8
    if(thisState.bRemoveMesh == true)
    {
        StaticMeshComponent.SetStaticMesh(none);
        SetCollision(false, false);
    }
    // End:0x1DE
    if(thisState.bChangeScale == true)
    {
        StaticMeshComponent.SetScale(thisState.Scale);
    }
    // End:0x229
    if(thisState.bRemoveFX == true)
    {
        I = 0;
        J0x1FA:

        // End:0x229 [Loop If]
        if(I < StateChangeParticles.Length)
        {
            StateChangeParticles[I].DeactivateSystem();
            I++;
            // [Loop Continue]
            goto J0x1FA;
        }
    }
    // End:0x2D3
    if(thisState.SpawnFX != none)
    {
        numParticles = StateChangeParticles.Length;
        StateChangeParticles[numParticles] = new (Outer) Class'Engine.ParticleSystemComponent';
        AttachComponent(StateChangeParticles[numParticles]);
        StateChangeParticles[numParticles].SetTranslation(thisState.FXOffset);
        StateChangeParticles[numParticles].SetTemplate(thisState.SpawnFX);
        StateChangeParticles[numParticles].ActivateSystem();
    }
    // End:0x36A
    if((thisState.SpawnSound != none) && thisState.bRemoveSound == false)
    {
        // End:0x33E
        if(StateChangeSound == none)
        {
            StateChangeSound = WorldInfo.CreateAudioComponent(thisState.SpawnSound, false, false);
            AttachComponent(StateChangeSound);            
        }
        else
        {
            StateChangeSound.SoundCue = thisState.SpawnSound;
        }
        StateChangeSound.Play();
    }
    // End:0x399
    if(thisState.bRemoveSound == true)
    {
        // End:0x399
        if(StateChangeSound != none)
        {
            StateChangeSound.Stop();
        }
    }
    // End:0x3EC
    if(thisState.bExplode)
    {
        HurtRadius(thisState.Damage, thisState.DamageRadius, Class'Engine.DamageType', thisState.Impulse, Location);
    }
    SetCollision(thisState.bNewCollideActors, thisState.bNewBlockActors, thisState.bNewIgnoreEncroachers);
    //return;    
}

simulated function PostBeginPlay()
{
    MaxHealth = Health;
    bDamageAppliesImpulse = false;
    LoadState();
    super.PostBeginPlay();
    //return;    
}

function OnPathGenerationStart()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x52 [Loop If]
    if(I < States.Length)
    {
        // End:0x48
        if(States[I].bPathGenState)
        {
            CurrentState = I;
            LoadState();
            // [Explicit Break]
            goto J0x52;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x52:

    //return;    
}

defaultproperties
{
    MassMultiplier=1.0000000
    Health=100
    MyDamageTypes[0]=Class'Engine.DamageType'
    bDamageAppliesImpulse=false
    // Reference: StaticMeshComponent'Default__MOHADestructibleProp.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        StaticMesh=StaticMesh'EditorMeshes.TexPropCube'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHADestructibleProp.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHADestructibleProp.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    ActorType=28
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}