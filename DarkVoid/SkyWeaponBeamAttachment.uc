class SkyWeaponBeamAttachment extends SkyWeaponAttachment
    notplaceable;

var ParticleSystem BeamTemplate[2];
var export editinline transient SkyParticleSystemComponent BeamEmitter[2];
var name BeamSockets[2];
var SkyPawn PawnOwner;
var name EndPointParamName;
var Color LinkBeamColors[3];
var ParticleSystem LinkBeamSystems[3];
var ParticleSystem TeamBeamEndpointTemplates[3];
var Color HighPowerBeamColor;
var ParticleSystem HighPowerSystem;
var ParticleSystem HighPowerBeamEndpointTemplate;

static function GetTeamBeamInfo(byte TeamNum, optional out Color BeamColor, optional out ParticleSystem BeamSystem, optional out ParticleSystem BeamEndpointTemplate)
{
    BeamColor = default.LinkBeamColors[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
    BeamSystem = default.LinkBeamSystems[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
    BeamEndpointTemplate = default.TeamBeamEndpointTemplates[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
    //return;    
}

simulated function AddBeamEmitter()
{
    local int I;
    local editinline SkeletalMeshComponent SkelMesh;

    I = 0;
    J0x07:

    // End:0xED [Loop If]
    if(I < 2)
    {
        // End:0xE3
        if(BeamTemplate[I] != none)
        {
            BeamEmitter[I] = new (self) Class'SkyParticleSystemComponent';
            BeamEmitter[I].SetTemplate(BeamTemplate[I]);
            BeamEmitter[I].SetHidden(true);
            BeamEmitter[I].SetTickGroup(2);
            BeamEmitter[I].bUpdateComponentInTick = true;
            SkelMesh = SkeletalMeshComponent(Mesh);
            // End:0xE3
            if(SkelMesh != none)
            {
                SkelMesh.AttachComponentToSocket(BeamEmitter[I], BeamSockets[I]);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function HideEmitter(int Index, bool bHide)
{
    // End:0x2D
    if(BeamEmitter[Index] != none)
    {
        BeamEmitter[Index].SetHidden(bHide);
    }
    //return;    
}

simulated function UpdateBeam(byte FireModeNum)
{
    // End:0x3F
    if(BeamEmitter[int(FireModeNum)] != none)
    {
        BeamEmitter[int(FireModeNum)].SetVectorParameter(EndPointParamName, PawnOwner.FlashLocation);
    }
    HideEmitter(int(FireModeNum), false);
    HideEmitter(int(Abs(float(int(FireModeNum) - int(1)))), true);
    //return;    
}

state CurrentlyAttached
{
    simulated function BeginState(name PreviousStateName)
    {
        PawnOwner = SkyPawn(Owner);
        // End:0x1D
        if(PawnOwner == none)
        {
            return;
        }
        AddBeamEmitter();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x61
        if(((PawnOwner == none) || PawnOwner.IsFirstPerson()) || PawnOwner.FlashLocation == vect(0.0000000, 0.0000000, 0.0000000))
        {
            HideEmitter(0, true);
            HideEmitter(1, true);
            return;
        }
        UpdateBeam(PawnOwner.FiringMode);
        //return;        
    }
    stop;    
}
