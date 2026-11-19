class UTDroppedPickup extends DroppedPickup
    hidecategories(Navigation);

var export editinline PrimitiveComponent PickupMesh;
var export editinline ParticleSystemComponent PickupParticles;
var float StartScale;
var bool bPickupable;
var export editinline LightEnvironmentComponent MyLightEnvironment;

event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    bPickupable = (Instigator == none) || Instigator.Health <= 0;
    //return;    
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    // End:0x106
    if((NewPickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        PickupMesh = new (self) NewPickupMesh.Class (NewPickupMesh);
        // End:0xCB
        if(class<EvilWeap_Base>(InventoryClass) != none)
        {
            PickupMesh.SetScale(PickupMesh.Scale * 1.2000000);
        }
        PickupMesh.SetLightEnvironment(MyLightEnvironment);
        AttachComponent(PickupMesh);
    }
    //return;    
}

simulated event SetPickupParticles(ParticleSystemComponent NewPickupParticles)
{
    // End:0xA3
    if((NewPickupParticles != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        PickupParticles = new (self) NewPickupParticles.Class (NewPickupParticles);
        AttachComponent(PickupParticles);
        PickupParticles.SetActive(true);
    }
    //return;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    local float DotP, Offset;

    super.Landed(HitNormal, FloorActor);
    // End:0x18E
    if(PickupMesh != none)
    {
        DotP = HitNormal Dot vect(0.0000000, 0.0000000, 1.0000000);
        // End:0xC7
        if((DotP != 0.0000000) && DotP < 1.0000000)
        {
            Offset = (Sqrt(1.0000000 - Square(DotP)) * CylinderComponent(CollisionComponent).CollisionRadius) / DotP;
        }
        // End:0x111
        if(class<EvilWeap_Base>(InventoryClass) != none)
        {
            Offset += class<EvilWeap_Base>(InventoryClass).default.DroppedPickupOffsetZ;
        }
        PickupMesh.SetTranslation(vect(0.0000000, 0.0000000, -1.0000000) * Offset);
        // End:0x18E
        if(PickupParticles != none)
        {
            PickupParticles.SetTranslation(vect(0.0000000, 0.0000000, -1.0000000) * Offset);
        }
    }
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        return ((bPickupable) ? super.ValidTouch(Other) : false);
        //return ReturnValue;        
    }

    simulated event Landed(Vector HitNormal, Actor FloorActor)
    {
        global.Landed(HitNormal, FloorActor);
        // End:0x57
        if((int(Role) == int(ROLE_Authority)) && !bPickupable)
        {
            bPickupable = true;
            CheckTouching();
        }
        //return;        
    }
    stop;    
}

state FadeOut
{
    simulated event Tick(float DeltaSeconds)
    {
        // End:0x48
        if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || PickupMesh == none)
        {
            Disable('Tick');            
        }
        else
        {
            PickupMesh.SetScale(FMax(0.0100000, PickupMesh.Scale - (StartScale * DeltaSeconds)));
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        bFadeOut = true;
        // End:0x43
        if(PickupMesh != none)
        {
            StartScale = PickupMesh.Scale;
        }
        // End:0x71
        if(PickupParticles != none)
        {
            PickupParticles.DeactivateSystem();
        }
        LifeSpan = 1.0000000;
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPickupable=true
    // Reference: DynamicLightEnvironmentComponent'Default__UTDroppedPickup.DroppedPickupLightEnvironment'
    begin object name=DroppedPickupLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        AmbientGlow=(R=0.2000000,G=0.2000000,B=0.2000000,A=1.0000000)
        bCastShadows=false
        bDynamic=false
    end object
    MyLightEnvironment=DroppedPickupLightEnvironment
    Components[0]=none
    // Reference: CylinderComponent'Default__UTDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    Components[1]=CollisionCylinder
    Components[2]=DroppedPickupLightEnvironment
    bDestroyedByInterpActor=true
    CollisionComponent=CollisionCylinder
}