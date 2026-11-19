class EvilTouchPickUp_Base extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

var(Pickup) export editinline CylinderComponent CylinderComponent;
var(Pickup) export editinline StaticMeshComponent PickupMesh;
var(Pickup) SoundCue PickupSound;
var(Pickup) export editinline EvilCaptionComponent CaptionComponent;
var(Pickup) array<MaterialInstance> Materials;
var(Pickup) int MaxPickCount;
var(Pickup) float CheckSameDropDistance;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var transient float TimeToDestroy;

function Pickup(EvilPawn P)
{
    // End:0x0F
    if(bHidden)
    {
        return;
    }
    // End:0x53
    if(PickupSound != none)
    {
        P.PlaySound(PickupSound, false, true, false, Location);
    }
    TriggerEventClass(Class'SeqEvent_Picked', P);
    // End:0xC2
    if((MaxPickCount > 0) && --MaxPickCount <= 0)
    {
        // End:0xBF
        if(TimeToDestroy > float(0))
        {
            SetTimer(TimeToDestroy, false, 'DestroyDelayed');            
        }
        else
        {
            Destroy();
        }
    }
    //return;    
}

function DestroyDelayed()
{
    Destroy();
    //return;    
}

simulated function PostBeginPlay()
{
    local PlayerController PC;
    local int Idx;

    super.PostBeginPlay();
    Idx = 0;
    J0x15:

    // End:0x76 [Loop If]
    if(Idx < Materials.Length)
    {
        PickupMesh.SetMaterial(Idx, Materials[Idx]);
        ++Idx;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0x13F
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xF8
        if(!PC.bIsPlayer || PC.myHUD == none)
        {
            continue;            
        }
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(CaptionComponent);        
    }    
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x0F
    if(bHidden)
    {
        return;
    }
    P = EvilPawn(Other);
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0xBB
    if(P != none)
    {
        PC = EvilPlayerController(P.Controller);
        // End:0xBB
        if(PC != none)
        {
            Pickup(P);
        }
    }
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    // End:0x7B
    if(Action.InputLinks[0].bHasImpulse)
    {
        PickupMesh.SetHidden(true);
        CaptionComponent.Disabled = true;        
    }
    else
    {
        // End:0xF6
        if(Action.InputLinks[1].bHasImpulse)
        {
            PickupMesh.SetHidden(false);
            CaptionComponent.Disabled = false;            
        }
        else
        {
            PickupMesh.SetHidden(!bHidden);
            CaptionComponent.Disabled = !bHidden;
        }
    }
    super.OnToggleHidden(Action);
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilTouchPickUp_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=60.0000000
        CollisionRadius=60.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_Base.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    begin object name="PickupMeshComp" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        LightingChannels=(Dynamic=true,Gameplay_1=true)
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_Base.CaptionComp'
    begin object name="CaptionComp" class=Class'EvilCaptionComponent'
        Use3DCaption=false
    end object
    CaptionComponent=CaptionComp
    MaxPickCount=1
    CheckSameDropDistance=200.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    begin object name="MyLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    bCollideActors=true
    bCollideWorld=true
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}