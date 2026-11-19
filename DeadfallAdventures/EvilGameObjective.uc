class EvilGameObjective extends UDKGameObjective
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,VehicleUsage,VehicleUsage);

struct native ScorerRecord
{
    var EvilPlayerReplicationInfo PRI;
    var float Pct;

    structdefaultproperties
    {
        PRI=none
        Pct=0.0000000
    }
};

var bool bAlreadyRendered;
var bool bAllowRemoteUse;
var bool bFirstObjective;
var bool bHasSensor;
var bool bIsConstructing;
var bool bIsDisabled;
var bool bIsActive;
var bool bPostRenderTraceSucceeded;
var bool bHasLocationSpeech;
var bool bScriptRenderAdditionalMinimap;
var byte StartTeam;
var(Objective) byte DefensePriority;
var(Objective) const localized string ObjectiveName;
var() Volume MyBaseVolume;
var() float BaseRadius;
var array<ScorerRecord> Scorers;
var int Score;
var EvilGameObjective NextObjective;
var LinearColor ControlColor[3];
var TextureCoordinates AttackCoords;
var float IconPosX;
var float IconPosY;
var float IconExtentX;
var float IconExtentY;
var Material HudMaterial;
var float MaxSensorRange;
var float CameraViewDistance;
var array<UTVehicleFactory> VehicleFactories;
var array<PlayerStart> PlayerStarts;
var array<UTTeamStaticMesh> TeamStaticMeshes;
var(Announcements) ObjectiveAnnouncementInfo AttackAnnouncement;
var(Announcements) ObjectiveAnnouncementInfo DefendAnnouncement;
var float HighlightScale;
var float MaxHighlightScale;
var float HighlightSpeed;
var float MinimapIconScale;
var float LastHighlightUpdate;
var float LastPostRenderTraceTime;
var float MaxBeaconDistance;
var(VoiceMessage) array<SoundNodeWave> LocationSpeech;
var LinearColor AttackLinearColor;

simulated function PostBeginPlay()
{
    local EvilGameObjective O, CurrentObjective;
    local PlayerController PC;

    super(Actor).PostBeginPlay();
    StartTeam = DefenderTeamIndex;
    // End:0xBB
    if(bFirstObjective)
    {
        CurrentObjective = self;
        // End:0xBA
        foreach AllActors(Class'EvilGameObjective', O)
        {
            // End:0xB9
            if(O != self)
            {
                CurrentObjective.NextObjective = O;
                O.bFirstObjective = false;
                CurrentObjective = O;
            }            
        }        
    }
    // End:0x111
    if(int(Role) == int(ROLE_Authority))
    {
        StartTeam = DefenderTeamIndex;
        // End:0x111
        if(MyBaseVolume != none)
        {
            MyBaseVolume.AssociatedActor = self;
        }
    }
    // End:0x18A
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x189
        if(PC.myHUD != none)
        {
            PC.myHUD.AddPostRenderedActor(self);
        }        
    }    
    //return;    
}

simulated function bool IsStandalone()
{
    return false;
    //return ReturnValue;    
}

simulated function Vector GetHUDOffset(PlayerController PC, Canvas Canvas)
{
    local float Z;

    Z = 460.0000000;
    // End:0x85
    if(PC.ViewTarget != none)
    {
        Z += (0.1000000 * VSize(PC.ViewTarget.Location - Location));
    }
    return Z * vect(0.0000000, 0.0000000, 1.0000000);
    //return ReturnValue;    
}

simulated function SoundNodeWave GetLocationSpeechFor(PlayerController PC, int LocationSpeechOffset, int MessageIndex)
{
    return ((LocationSpeechOffset < LocationSpeech.Length) ? LocationSpeech[LocationSpeechOffset] : none);
    //return ReturnValue;    
}

function Actor GetAutoObjectiveActor(PlayerController PC)
{
    return self;
    //return ReturnValue;    
}

simulated function Destroyed()
{
    local PlayerController PC;

    super(Actor).Destroyed();
    // End:0x83
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x82
        if(PC.myHUD != none)
        {
            PC.myHUD.RemovePostRenderedActor(self);
        }        
    }    
    //return;    
}

simulated function AddTeamStaticMesh(UTTeamStaticMesh SMesh)
{
    TeamStaticMeshes[TeamStaticMeshes.Length] = SMesh;
    SMesh.SetTeamNum(DefenderTeamIndex);
    //return;    
}

simulated function UpdateTeamStaticMeshes()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x63 [Loop If]
    if(I < TeamStaticMeshes.Length)
    {
        TeamStaticMeshes[I].SetTeamNum(DefenderTeamIndex);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'DefenderTeamIndex')
    {
        UpdateTeamStaticMeshes();        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

function EvilGameObjective FindNearestFriendlyNode(int TeamIndex)
{
    return none;
    //return ReturnValue;    
}

function bool UsedBy(Pawn P)
{
    return false;
    //return ReturnValue;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitNormal, DesiredCamLoc;

    DesiredCamLoc = Location - (Vector(out_CamRot) * CameraViewDistance);
    // End:0x7B
    if(Trace(out_CamLoc, HitNormal, DesiredCamLoc, Location, false, vect(12.0000000, 12.0000000, 12.0000000)) == none)
    {
        out_CamLoc = DesiredCamLoc;
    }
    return false;
    //return ReturnValue;    
}

simulated function HighlightOnMinimap(int Switch)
{
    // End:0x4E
    if(HighlightScale < 1.2500000)
    {
        HighlightScale = MaxHighlightScale;
        LastHighlightUpdate = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated event RenderMinimap(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, float ColorPercent)
{
    //return;    
}

simulated function RenderExtraDetails(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, float ColorPercent, bool bSelected)
{
    // End:0x32
    if(bSelected)
    {
        DrawMapSelection(MP, Canvas, PlayerOwner);
    }
    //return;    
}

simulated function DrawMapSelection(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner)
{
    Canvas.SetPos(HUDLocation.X - (float(12) * MP.MapScale), HUDLocation.Y - (((float(12) * MP.MapScale) * Canvas.ClipY) / Canvas.ClipX));
    Canvas.SetDrawColor(255, 255, 0, 255);
    Canvas.DrawTile(Class'UTHUD'.default.AltHudTexture, 25.0000000 * MP.MapScale, 25.0000000 * MP.MapScale, 273.0000000, 494.0000000, 12.0000000, 13.0000000);
    //return;    
}

simulated event bool IsCritical()
{
    return false;
    //return ReturnValue;    
}

simulated function bool IsNeutral()
{
    return false;
    //return ReturnValue;    
}

simulated event bool IsActive()
{
    return false;
    //return ReturnValue;    
}

function bool Shootable()
{
    return false;
    //return ReturnValue;    
}

simulated function bool TeamLink(int TeamNum)
{
    return false;
    //return ReturnValue;    
}

simulated function bool NeedsHealing()
{
    return false;
    //return ReturnValue;    
}

function bool CanDoubleJump(Pawn Other)
{
    return true;
    //return ReturnValue;    
}

function bool NearObjective(Pawn P)
{
    local Volume V;

    // End:0x5D
    if(MyBaseVolume != none)
    {
        // End:0x57
        foreach P.TouchingActors(Class'Engine.Volume', V)
        {
            // End:0x56
            if(V == MyBaseVolume)
            {                
                return true;
            }            
        }        
        return false;        
    }
    else
    {
        return (VSize(Location - P.Location) < BaseRadius) && P.LineOfSightTo(self);
    }
    //return ReturnValue;    
}

simulated function string GetHumanReadableName()
{
    return ObjectiveName;
    //return ReturnValue;    
}

function int GetNumDefenders()
{
    return 0;
    //return ReturnValue;    
}

function bool BetterObjectiveThan(EvilGameObjective Best, byte DesiredTeamNum, byte RequesterTeamNum)
{
    // End:0x2C
    if(bIsDisabled || int(DefenderTeamIndex) != int(DesiredTeamNum))
    {
        return false;
    }
    // End:0x6F
    if((Best == none) || int(Best.DefensePriority) < int(DefensePriority))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Reset()
{
    super(Actor).Reset();
    DefenderTeamIndex = StartTeam;
    Scorers.Length = 0;
    bForceNetUpdate = true;
    //return;    
}

simulated function ClientReset()
{
    //return;    
}

function AddScorer(EvilPlayerReplicationInfo PRI, float Pct)
{
    local ScorerRecord S;
    local int I;

    // End:0xA8
    if(Scorers.Length > 0)
    {
        I = 0;
        J0x1B:

        // End:0xA8 [Loop If]
        if(I < Scorers.Length)
        {
            // End:0x9A
            if(Scorers[I].PRI == PRI)
            {
                Scorers[I].Pct += Pct;
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x1B;
        }
    }
    S.PRI = PRI;
    S.Pct = Pct;
    Scorers[Scorers.Length] = S;
    //return;    
}

function ShareScore(int TotalScore, string EventDesc)
{
    local int I;
    local float SharedScore;

    I = 0;
    J0x0B:

    // End:0x135 [Loop If]
    if(I < Scorers.Length)
    {
        // End:0x93
        if((Scorers[I].PRI == none) || Scorers[I].PRI.bDeleteMe)
        {            
        }
        else
        {
            SharedScore = float(TotalScore) * Scorers[I].Pct;
            // End:0x127
            if(SharedScore > float(0))
            {
                Scorers[I].PRI.Score += SharedScore;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function SetTeam(byte TeamIndex)
{
    DefenderTeamIndex = TeamIndex;
    UpdateTeamStaticMeshes();
    //return;    
}

simulated function FindGoodEndView(PlayerController PC, out Rotator GoodRotation)
{
    local Vector CameraLoc;
    local Rotator CameraRot, ViewRotation;
    local int tries;
    local float bestDist, newdist, FOVAngle;

    ViewRotation = GoodRotation;
    ViewRotation.Pitch = 56000;
    tries = 0;
    bestDist = 0.0000000;
    tries = 0;
    J0x5A:

    // End:0x148 [Loop If]
    if(tries < 16)
    {
        CameraLoc = Location;
        CameraRot = ViewRotation;
        CalcCamera(0.0000000, CameraLoc, CameraRot, FOVAngle);
        newdist = VSize(CameraLoc - Location);
        // End:0x117
        if(newdist > bestDist)
        {
            bestDist = newdist;
            GoodRotation = CameraRot;
        }
        ViewRotation.Yaw += 4096;
        tries++;
        // [Loop Continue]
        goto J0x5A;
    }
    //return;    
}

function bool TeleportTo(UTPawn Traveler)
{
    return false;
    //return ReturnValue;    
}

function bool ValidSpawnPointFor(byte TeamIndex)
{
    return (int(DefenderTeamIndex) == int(TeamIndex)) && !bUnderAttack;
    //return ReturnValue;    
}

function EvilCarriedObject GetFlag()
{
    //return ReturnValue;    
}

function SetAlarm(bool bNowOn)
{
    //return;    
}

function TriggerFlagEvent(name EventType, Controller EventInstigator)
{
    local UTSeqEvent_FlagEvent FlagEvent;
    local int I;

    I = 0;
    J0x0B:

    // End:0x97 [Loop If]
    if(I < GeneratedEvents.Length)
    {
        FlagEvent = UTSeqEvent_FlagEvent(GeneratedEvents[I]);
        // End:0x89
        if(FlagEvent != none)
        {
            FlagEvent.Trigger(EventType, EventInstigator);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function MarkShootSpotsFor(Pawn P)
{
    local float Range;
    local int I;

    // End:0x11C
    if(P.Weapon != none)
    {
        Range = P.Weapon.MaxRange();
        I = 0;
        J0x6D:

        // End:0x11C [Loop If]
        if(I < ShootSpots.Length)
        {
            // End:0x10E
            if((ShootSpots[I] != none) && VSize(ShootSpots[I].Location - Location) < Range)
            {
                ShootSpots[I].bTransientEndPoint = true;
            }
            I++;
            // [Loop Continue]
            goto J0x6D;
        }
    }
    //return;    
}

defaultproperties
{
    bFirstObjective=true
    BaseRadius=2000.0000000
    Score=5
    ControlColor[0]=(R=1.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    ControlColor[1]=(R=0.0000000,G=0.0000000,B=1.0000000,A=1.0000000)
    ControlColor[2]=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
    AttackCoords=(U=583.0000000,V=266.0000000,UL=52.0000000,VL=57.0000000)
    MaxSensorRange=2800.0000000
    CameraViewDistance=400.0000000
    MaxHighlightScale=8.0000000
    HighlightSpeed=10.0000000
    MinimapIconScale=20.0000000
    AttackLinearColor=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
    IconCoords=(U=537.0000000,V=296.0000000,UL=46.0000000,VL=31.0000000)
    DefenderTeamIndex=2
    // Reference: CylinderComponent'Default__EvilGameObjective.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=none
    Components[3]=CollisionCylinder
    Components[4]=none
    bReplicateMovement=false
    bOnlyDirtyReplication=true
    NetUpdateFrequency=1.0000000
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}