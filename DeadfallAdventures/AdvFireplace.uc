class AdvFireplace extends Trigger
    hidecategories(Navigation)
    classgroup(Adventurer);

var() bool bIsAlwaysActive;
var bool bActivated;
var() private float Lifetime;
var private float CurrentTime;
var() protected const export editinline StaticMeshComponent Mesh;
var() protected const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() private const export editinline ParticleSystemComponent Fire;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x38
    if(bIsAlwaysActive)
    {
        Fire.SetActive(true);
    }
    //return;    
}

function bool UsedBy(Pawn User)
{
    local AdvTorch torch;

    super(Actor).UsedBy(User);
    // End:0xEF
    if(EvilPawn(User) != none)
    {
        torch = AdvTorch(EvilPawn(User).Weapon);
        // End:0xEF
        if(torch != none)
        {
            // End:0xB4
            if((torch.AmmoCount > 0) && !bActivated)
            {
                ActivateFireplace(true);
            }
            // End:0xEF
            if(bIsAlwaysActive || bActivated)
            {
                torch.Refill();
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x54
    if((bActivated && !bIsAlwaysActive) && CurrentTime <= 0.0000000)
    {
        ActivateFireplace(false);        
    }
    else
    {
        CurrentTime -= DeltaTime;
    }
    //return;    
}

simulated function ActivateFireplace(bool Activate)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    bActivated = Activate;
    // End:0x59
    if(Activate)
    {
        CurrentTime = Lifetime;
        Fire.SetActive(true);        
    }
    else
    {
        Fire.SetActive(false);
    }
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x193
    if(GameSeq != none)
    {
        // End:0xCF
        if(Activate)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x192
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x191
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    Lifetime=20.0000000
    // Reference: StaticMeshComponent'Default__AdvFireplace.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_en_TestLevels.Meshes.sm_en_Fireplace_01'
        ReplacementPrimitive=none
    end object
    Mesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFireplace.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ParticleSystemComponent'Default__AdvFireplace.FireParticles'
    begin object name=FireParticles class=Class'Engine.ParticleSystemComponent'
        Template=ParticleSystem'adv_ps_Fire.Effects.ps_Fireplace'
        bAutoActivate=false
        ReplacementPrimitive=none
    end object
    Fire=FireParticles
    // Reference: CylinderComponent'Default__AdvFireplace.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__AdvFireplace.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=Mesh
    Components[3]=MyLightEnvironment
    Components[4]=FireParticles
    bHidden=false
    CollisionComponent=Mesh
    SupportedEvents=/* Array type was not detected. */
}