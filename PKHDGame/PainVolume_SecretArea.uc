class PainVolume_SecretArea extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() const localized string Message;
var SoundCue ActivationSound;
var() bool bActive;

event PawnEnteredVolume(Pawn Other)
{
    local PKPlayerPawn P;
    local PKPlayerController PKPC;
    local PKPostProcessManager PKPP;

    // End:0x12
    if(bActive == false)
    {
        return;
    }
    P = PKPlayerPawn(Other);
    // End:0x1A1
    if(P != none)
    {
        PKPC = PKPlayerController(P.Controller);
        PKPP = PKPostProcessManager(PKPC.GetPPManager());
        PainGFxHudWrapper(PKPC.myHUD).HudMovie.SetLocalizedMessageText(Message, false, false);
        P.PlaySound(ActivationSound);
        PainPRI(PKPC.PlayerReplicationInfo).ScoreSecretFound();
        // End:0x195
        if(PKPP != none)
        {
            PKPP.SecretAreaFlash();
        }
        bActive = false;
    }
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super.CreateCheckpointRecord(Record);
    Record.bActive = bActive;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    bActive = Record.bActive;
    //return;    
}

defaultproperties
{
    Message="Secret Area discovered!"
    ActivationSound=SoundCue'a_SecretArea.Cue.light_from_hole'
    bActive=true
    bVelocityAffectsWalking=false
    // Reference: BrushComponent'Default__PainVolume_SecretArea.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__PhysicsVolume.BrushComponent0'
    begin object name="BrushComponent0"
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}