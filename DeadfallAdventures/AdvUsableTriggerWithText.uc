class AdvUsableTriggerWithText extends EvilUsableTriggerWithText
    hidecategories(Navigation);

simulated function PostBeginPlay()
{
    local AdvGameMP_Base Game;

    // End:0x17B
    if((WorldInfo.Game != none) && AdvGameMP_Base(WorldInfo.Game) != none)
    {
        Game = AdvGameMP_Base(WorldInfo.Game);
        // End:0x17B
        if((CaptionComponent.LocString == "ExchangeMP") && ((class<AdvGameTreasureHuntBase>(Game.Class) == none) && class<AdvGameTeamTreasureHuntBase>(Game.Class) == none) || Game.bOracle == false)
        {
            CaptionComponent.Hide();
            Enabled = false;
            bForceNetUpdate = true;
            ForceNetRelevant();
            return;
        }
    }
    super.PostBeginPlay();
    // End:0x1B3
    if(!Enabled)
    {
        CaptionComponent.Hide();
    }
    //return;    
}

function bool UsedBy(Pawn User)
{
    // End:0x45
    if((CaptionComponent.LocString == "ExchangeMP") && !Enabled)
    {
        return false;        
    }
    else
    {
        return super.UsedBy(User);
    }
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvUsableTriggerWithText.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: StaticMeshComponent'Default__AdvUsableTriggerWithText.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    MeshComp=PickupMeshComp
    // Reference: CylinderComponent'Default__AdvUsableTriggerWithText.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__AdvUsableTriggerWithText.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=PickupMeshComp
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}