class PainItem_Treasure_Base extends PainItemKActorBase
    abstract;

var(Treasure) int Value;
var(Treasure) bool bIsBonusItem;
var(Treasure) bool bIsHolyItem;
var bool bFromFallenEnemy;

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    // End:0xA5
    if(PRI != none)
    {
        // End:0x51
        if(bIsBonusItem)
        {
            PRI.ScoreBonusItemTaken(Value, bFromFallenEnemy);            
        }
        else
        {
            PRI.ScoreMoneyTaken(Value);
        }
        // End:0xA5
        if(bIsHolyItem)
        {
            PRI.ScoreHolyItemTaken();
        }
    }
    super.Pickup(P, PRI);
    //return;    
}

defaultproperties
{
    Value=1
    // Reference: CylinderComponent'Default__PainItem_Treasure_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemKActorBase.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound=SoundCue'a_Treasures.Cue.item-treasures'
    // Reference: StaticMeshComponent'Default__PainItem_Treasure_Base.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Default__PainItemKActorBase.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItem_Treasure_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Treasure_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemKActorBase.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    CollisionComponent=StaticMeshComponent0
}