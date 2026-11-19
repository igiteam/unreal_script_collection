class PainItem_Armour_Base extends PainItemBaseSkelMesh
    placeable
    hidecategories(Navigation);

var() int ArmorAdd;
var() float RescueFactor;
var() int RespawnTime;

function PostBeginPlay()
{
    // End:0x67
    if(PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        MaxPickCount = 2;
        LastPickerClearDelay = 0.0000000;
        bHidePickupFromLastPicker = true;
    }
    super(PainItemBase).PostBeginPlay();
    //return;    
}

static function bool ReduceDamage(out int outDamage, out float OutDamageRemainder, out int OutArmour, out float OutArmourRemainder)
{
    local float HPSaved, ResultDamage, ResultArmour;

    ResultDamage = float(outDamage);
    ResultArmour = float(OutArmour) + OutArmourRemainder;
    HPSaved = ResultDamage * default.RescueFactor;
    // End:0xBF
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
    {
        HPSaved = float(FCeil(HPSaved));
    }
    ResultDamage = (ResultDamage - HPSaved) + OutDamageRemainder;
    ResultArmour = FMax(0.0000000, ResultArmour - HPSaved);
    outDamage = FFloor(ResultDamage);
    OutDamageRemainder = ResultDamage - float(outDamage);
    OutArmour = FFloor(ResultArmour);
    OutArmourRemainder = ResultArmour - float(OutArmour);
    return ResultArmour == 0.0000000;
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    // End:0x52
    if(bHidePickupFromLastPicker)
    {
        LastPRIPicker = PRI;
        bForceNetUpdate = true;
        HideFromLastPicker();
    }
    // End:0x80
    if(PRI != none)
    {
        PRI.ScoreArmourTaken();
    }
    P.Armour = ArmorAdd;
    P.ArmourClass = self.Class;
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x2A
    if((LastPRIPicker != none) && LastPRIPicker == PRI)
    {
        return false;
    }
    // End:0x9C
    if((P.ArmourClass.default.RescueFactor * float(P.Armour)) >= (RescueFactor * float(ArmorAdd)))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function HideFromLastPicker()
{
    local editinline ParticleSystemComponent Comp;

    // End:0xBA
    if(LastPRIPicker.IsLocalPlayerPRI())
    {
        SetOwner(Controller(LastPRIPicker.Owner).Pawn);
        ItemMeshSkel.SetOwnerNoSee(true);
        // End:0xB9
        foreach BindParticlesPSC(Comp)
        {
            Comp.SetOwnerNoSee(true);            
        }        
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PainItem_Armour_Base.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        // Reference: AnimNodeSequence'Default__PainItem_Armour_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'pi_Armors_01.Anim.as_pi_Armor_01_01'
        ReplacementPrimitive=none
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="Idle"
    // Reference: CylinderComponent'Default__PainItem_Armour_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Armour_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    RespawnItemTime=20.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    CollisionComponent=CollisionCylinder
}