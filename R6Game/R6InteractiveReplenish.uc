class R6InteractiveReplenish extends R6InteractiveActor
    native
    config(Game)
    placeable
    hidecategories(lighting);

enum EAnimReplenishState
{
    ANIMREPLENISHSTATE_NONE,        // 0
    ANIMREPLENISHSTATE_BEGIN,       // 1
    ANIMREPLENISHSTATE_END,         // 2
    ANIMREPLENISHSTATE_MAX          // 3
};

var(Replenishing) int m_iPouches;
var bool m_bIsOpen;
var bool m_bForceAnimate;
var R6InteractiveReplenish.EAnimReplenishState m_eReplenishState;
var export editinline SkeletalMeshComponent m_pPouch;
var StaticMesh m_StaticMeshPouch;
var int sm_iPouches;

// Export UR6InteractiveReplenish::execEndReplenish(FFrame&, void* const)
native final function EndReplenish();

// Export UR6InteractiveReplenish::execShowOutfitMenu(FFrame&, void* const)
native final function ShowOutfitMenu();

// Export UR6InteractiveReplenish::execFinishReplenish(FFrame&, void* const)
native final function FinishReplenish();

function SaveOriginalData()
{
    sm_iPouches = m_iPouches;
    SaveOriginalData();
    return;
}

event InteractSuccesful(Pawn pInteractor)
{
    EndReplenish();
    InteractSuccesful(pInteractor);
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = 26;
    return true;
    return;
}

defaultproperties
{
    m_iPouches=10
    // Reference: SkeletalMeshComponent'Default__R6InteractiveReplenish.PouchMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="PouchMesh" class=Class'Engine.SkeletalMeshComponent'
        Translation=(X=0.2000000,Y=-23.5400000,Z=65.0000000)
        Rotation=(Pitch=0,Yaw=32768,Roll=0)
    end object
    m_pPouch=PouchMesh
    m_ActorName="Replenish Zone"
    m_bCheckInteractRotation=true
    m_bCanBeUsedByTeam=false
    m_eType=4
    // Reference: SkeletalMeshComponent'Default__R6InteractiveReplenish.ReplenishMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ReplenishMesh" class=Class'Engine.SkeletalMeshComponent'
        BlockActors=true
        BlockNonZeroExtent=true
    end object
    m_Mesh=ReplenishMesh
    // Reference: SpriteComponent'Default__R6InteractiveReplenish.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerEditorMaterials.Replenish_64'
    end object
    Components[0]=Sprite
    Components[1]=ReplenishMesh
    Physics=10
    TickGroup=2
    CollisionComponent=ReplenishMesh
}