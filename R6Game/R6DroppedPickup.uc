class R6DroppedPickup extends DroppedPickup
    native
    hidecategories(lighting);

var R6WeaponAttachments m_WeaponAttachments;
var R6Weapon m_Weapon;
var class<R6Weapon> m_WeaponClass;
var repnotify class<R6SoundSuppressor> m_SoundSuppressorAttachmentClass;
var repnotify class<R6Scope> m_ScopeAttachmentClass;
var repnotify class<R6UnderbarrelOption> m_UnderbarrelAttachmentClass;
var int m_iNbAmmo;
var bool m_bSoundSuppressorOn;
var bool m_bRegisteredInGameManager;
var transient R6EngineEnums.ESoundSurfaceType m_eGroundSurfaceType;
var transient int m_iCollisionSoundTick;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_ScopeAttachmentClass, m_SoundSuppressorAttachmentClass, 
        m_UnderbarrelAttachmentClass, m_WeaponClass, 
        m_bSoundSuppressorOn, m_iNbAmmo;
}

simulated event ReplicatedEvent(name VarName)
{
    InitMesh();
    InitPhysics();
    return;
}

function Inventory.EPickupResult PickupItem(Pawn pickingPawn)
{
    local Inventory.EPickupResult eResult;

    eResult = Inventory.CanGiveTo(pickingPawn);
    // End:0x5B
    if(int(eResult) == int(0))
    {
        eResult = Inventory.GiveTo(pickingPawn);
        TermPhysics();
        DestroyMesh();
        Inventory = none;
        Destroy();
    }
    return eResult;
    return;
}

function float BotDesireability(Actor PickupHolder, Pawn P)
{
    return Inventory.BotDesireability(PickupHolder, P);
    return;
}

defaultproperties
{
    UsePawnLights=true
    LifeSpan=0.0000000
}