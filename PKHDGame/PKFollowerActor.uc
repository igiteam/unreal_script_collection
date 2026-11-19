class PKFollowerActor extends Actor
    placeable
    hidecategories(Navigation);

var() export editinline CylinderComponent CylinderComponent;
var Actor FollowedActor;
var float CurrentFollowVelocity;
var() float FollowAccel;
var() float FollowMaxSpeed;
var() array<ParticleSystem> BindParticles;
var export editinline array<export editinline ParticleSystemComponent> BindParticlesPSC;
var EvilLightActor BindedLightActor;
var() EvilLightActor BindedLightArchetype;
var() bool bWaitForEffects;
var transient bool bDestroying;
var() bool bDestroyAfterTouchFollowedActor;
var() float TimeToLive;
var Actor DestroyAfterTouchThisActor;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        DestroyAfterTouchThisActor, FollowedActor;
}

simulated function PreBeginPlay()
{
    local ParticleSystem BindFX;
    local editinline ParticleSystemComponent PSC;

    super.PreBeginPlay();
    // End:0xCC
    foreach BindParticles(BindFX)
    {
        PSC = new (self) Class'Engine.ParticleSystemComponent';
        PSC.SetTemplate(BindFX);
        PSC.bUpdateComponentInTick = true;
        AttachComponent(PSC);
        BindParticlesPSC.AddItem(PSC);
        PSC.ActivateSystem();        
    }    
    // End:0xE6
    if(BindedLightArchetype != none)
    {
        CreateLight();
    }
    // End:0x10E
    if(TimeToLive > float(0))
    {
        SetTimer(TimeToLive, false, 'TimedDestroy');
    }
    //return;    
}

simulated function CreateLight()
{
    BindedLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, BindedLightArchetype);
    BindedLightActor.SetBase(self);
    BindedLightActor.Activate();
    //return;    
}

simulated function DestoryLight()
{
    // End:0x39
    if(BindedLightActor != none)
    {
        BindedLightActor.Deactivate();
        BindedLightActor = none;
    }
    //return;    
}

simulated function ShowLight(bool bShow)
{
    // End:0x3A
    if(BindedLightActor != none)
    {
        BindedLightActor.DisableLight(!bShow);
    }
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super.OnToggleHidden(Action);
    ShowLight(bHidden);
    //return;    
}

simulated function StopEffects()
{
    local editinline ParticleSystemComponent PSC;

    // End:0x37
    foreach BindParticlesPSC(PSC)
    {
        PSC.DeactivateSystem();        
    }    
    DestoryLight();
    //return;    
}

function SetFollowedActor(Actor Target)
{
    FollowedActor = Target;
    //return;    
}

function SetOtherTouchDestroyActor(Actor Target)
{
    DestroyAfterTouchThisActor = Target;
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0xBE
    if(FollowedActor != none)
    {
        // End:0x4E
        if(FollowedActor.bDeleteMe && !bDestroying)
        {
            DestroyItem();
            return;
        }
        MoveSmooth((Normal(FollowedActor.Location - Location) * DeltaTime) * CurrentFollowVelocity);
        CurrentFollowVelocity = FMin(CurrentFollowVelocity + FollowAccel, FollowMaxSpeed);        
    }
    else
    {
        // End:0xEA
        if((CurrentFollowVelocity > float(0)) && !bDestroying)
        {
            DestroyItem();
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0x88
    if((((Other == FollowedActor) || Other == DestroyAfterTouchThisActor) && bDestroyAfterTouchFollowedActor) && !bDestroying)
    {
        DestroyItem();
    }
    //return;    
}

simulated function DestroyItem()
{
    bDestroying = true;
    // End:0x35
    if(bWaitForEffects)
    {
        StopEffects();
        LifeSpan = 1.0000000;        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function TimedDestroy()
{
    ClearTimer('TimedDestroy');
    DestroyItem();
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__PKFollowerActor.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=20.0000000
        CollisionRadius=20.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    FollowAccel=8.0000000
    FollowMaxSpeed=600.0000000
    bDestroyAfterTouchFollowedActor=true
    Components[0]=CollisionCylinder
    bCollideActors=true
    bCollideWorld=true
    CollisionComponent=CollisionCylinder
}