class AdvRailCar_Base extends EvilRailCar_Vehicle_Base
    hidecategories(Navigation);

var() bool bForceManTurret;

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    local AdvTurret_Base AttachedTurret;

    super.OnToggleHidden(Action);
    // End:0x55
    foreach BasedActors(Class'AdvTurret_Base', AttachedTurret)
    {
        AttachedTurret.SetHidden(bHidden);        
    }    
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local AdvTurret_Base AttachedTurret;

    super.ApplyCheckpointRecord(Record);
    // End:0x55
    foreach BasedActors(Class'AdvTurret_Base', AttachedTurret)
    {
        AttachedTurret.SetHidden(bHidden);        
    }    
    //return;    
}

function bool HasTurret()
{
    local AdvTurret_Base Turret;

    // End:0x1C
    foreach BasedActors(Class'AdvTurret_Base', Turret)
    {        
        return true;        
    }    
    return false;
    //return ReturnValue;    
}

function ManTurret(EvilPawn P)
{
    local AdvTurret_Base Turret, closest;
    local float Dist, D;

    Dist = 1000000000.0000000;
    // End:0xAF
    foreach BasedActors(Class'AdvTurret_Base', Turret)
    {
        D = VSizeSq(Turret.Location - P.Location);
        // End:0xAE
        if(Dist > D)
        {
            Dist = D;
            closest = Turret;
        }        
    }    
    // End:0xEE
    if((closest == none) || !closest.TryToDrive(P))
    {
    }
    //return;    
}

function UpdateTurrets()
{
    local AdvTurret_Base Turret;
    local Rotator Rot;

    // End:0x77
    foreach BasedActors(Class'AdvTurret_Base', Turret)
    {
        Rot = Turret.Rotation;
        Rot += RotDelta;
        Turret.SetRotation(Rot);        
    }    
    //return;    
}

simulated function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    // End:0x70
    if(((HasTurret()) && bForceManTurret) && EvilPawn(Attachment) != none)
    {
        ManTurret(EvilPawn(Attachment));
        super(Actor).DoKismetAttachment(Attachment, Action);
        return;
    }
    super(EvilRailCar_Base).DoKismetAttachment(Attachment, Action);
    //return;    
}

simulated function DetachPawn(EvilPawn P, optional bool ByDeath = false)
{
    // End:0xF4
    if((((P.ClampedBase == self) || (P.DrivenVehicle != none) && P.DrivenVehicle.Base == self) && bForceManTurret) && P.DrivenVehicle != none)
    {
        P.DrivenVehicle.DriverLeave(true);
    }
    super(EvilRailCar_Base).DetachPawn(P, ByDeath);
    //return;    
}

simulated function bool ShouldTryToFixPlayer(EvilPawn P)
{
    // End:0x48
    if(bForceManTurret && P.DrivenVehicle == none)
    {
        ManTurret(P);
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x2A
    if(bInterpolating)
    {
        UpdateTurrets();
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_Base.EditorWheelsPreviewMesh0'
    begin object name=EditorWheelsPreviewMesh0
        ReplacementPrimitive=none
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    // Reference: StaticMeshComponent'Default__AdvRailCar_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvRailCar_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvRailCar_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    CollisionComponent=StaticMeshComponent0
}