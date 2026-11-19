class PainItem_Health_Base extends PainItemBaseSkelMesh
    placeable
    hidecategories(Navigation);

var(Health) int HealthToAdd;
var Pawn CatchingTarget;
var bool ForceMoveToCatchingTarget;
var float CurrentCatchVelocity;
var() float CatchAccel;
var() float CatchMaxSpeed;
var() int MaxHealthLimit;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        CatchAccel, CatchMaxSpeed, 
        CatchingTarget, ForceMoveToCatchingTarget;
}

function PostBeginPlay()
{
    super(PainItemBase).PostBeginPlay();
    //return;    
}

function SetCatchingTarget(Pawn Target)
{
    CatchingTarget = Target;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x1EB
    if((CatchingTarget != none) && ForceMoveToCatchingTarget || (PKGame(WorldInfo.Game) != none) && PKGame(WorldInfo.Game).bAttractSouls)
    {
        // End:0xBA
        if(IsTimerActive('TimedDestroy'))
        {
            ClearTimer('TimedDestroy');
        }
        MoveSmooth((Normal(CatchingTarget.Location - Location) * DeltaTime) * CurrentCatchVelocity);
        CurrentCatchVelocity = FMin(CurrentCatchVelocity + CatchAccel, CatchMaxSpeed);
        // End:0x1EB
        if((VSize(CatchingTarget.Location - Location) <= ItemTakeDistance) && CanPickUp(PKPlayerPawn(CatchingTarget), PainPRI(CatchingTarget.PlayerReplicationInfo)))
        {
            Pickup(PKPlayerPawn(CatchingTarget), PainPRI(CatchingTarget.PlayerReplicationInfo));
        }
    }
    //return;    
}

function bool CanHealPawn(PKPlayerPawn P, PainPRI PRI)
{
    return true;
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    // End:0x8C
    if(CanHealPawn(P, PRI))
    {
        P.HealDamageLimit(HealthToAdd, Max(P.HealthMax, MaxHealthLimit));
    }
    // End:0xC2
    if(bHidePickupFromLastPicker)
    {
        LastPRIPicker = PRI;
        bForceNetUpdate = true;
        HideFromLastPicker();
    }
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    local int MaxLimit;

    // End:0x2A
    if((LastPRIPicker != none) && LastPRIPicker == PRI)
    {
        return false;
    }
    // End:0x91
    if(((bCanPickupWhenOwnerDies && Owner != none) && EvilPawn(Owner) != none) && EvilPawn(Owner).IsAliveAndWell())
    {
        return false;
    }
    // End:0xA2
    if(MaxHealthLimit <= 0)
    {
        return true;
    }
    MaxLimit = Max(P.HealthMax, MaxHealthLimit);
    // End:0x103
    if(P.Health >= MaxLimit)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function HideFromLastPicker()
{
    local editinline ParticleSystemComponent Comp;

    // End:0x9A
    if(LastPRIPicker.IsLocalPlayerPRI())
    {
        SetOwner(Controller(LastPRIPicker.Owner).Pawn);
        // End:0x99
        foreach BindParticlesPSC(Comp)
        {
            Comp.SetOwnerNoSee(true);            
        }        
    }
    //return;    
}

defaultproperties
{
    CatchAccel=8.0000000
    CatchMaxSpeed=600.0000000
    MaxHealthLimit=-1
    // Reference: SkeletalMeshComponent'Default__PainItem_Health_Base.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'ps_all_Levels.Mesh.e_soul_01'
        // Reference: AnimNodeSequence'Default__PainItem_Health_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'ps_all_Levels.Anim.as_soul_01'
        ReplacementPrimitive=none
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="e_soul_01"
    // Reference: CylinderComponent'Default__PainItem_Health_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=50.0000000
        CollisionRadius=45.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Health_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bWaitForEffects=true
    RespawnItemTime=25.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    bAlwaysRelevant=true
    CollisionComponent=CollisionCylinder
}