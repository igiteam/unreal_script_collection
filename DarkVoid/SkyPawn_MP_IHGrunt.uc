class SkyPawn_MP_IHGrunt extends SkyPawn_MP
    config(Game);

var MaterialInstanceConstant MatInst;
var int MatInstIndex;
var repnotify LinearColor GruntColor;
var repnotify LinearColor UniformColor;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        GruntColor, UniformColor;
}

simulated function PostBeginPlay()
{
    super(SkyPawnCoverUser).PostBeginPlay();
    MatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    MatInst.SetParent(Mesh.GetMaterial(MatInstIndex));
    Mesh.SetMaterial(MatInstIndex, MatInst);
    //return;    
}

simulated function ClientRestart()
{
    ServerInitGruntColor();
    super(Pawn).ClientRestart();
    //return;    
}

simulated function NotifyTeamChanged()
{
    ServerInitGruntColor();
    //return;    
}

reliable server function ServerInitGruntColor()
{
    //return;    
}

exec function SetGruntColor(float colorRed, float colorGreen, float colorBlue)
{
    // End:0x29
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetGruntColor(colorRed, colorGreen, colorBlue);
    }
    // End:0x52
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetGruntTeamColor(colorRed, colorGreen, colorBlue);
    }
    //return;    
}

reliable server function ServerSetGruntColor(float R, float G, float B)
{
    local LinearColor C;

    C.R = R * float(6);
    C.G = G * float(6);
    C.B = B * float(6);
    GruntColor = C;
    ReplicatedEvent('GruntColor');
    //return;    
}

reliable server function ServerSetGruntTeamColor(float R, float G, float B)
{
    local LinearColor C;

    C.R = R;
    C.G = G;
    C.B = B;
    UniformColor = C;
    ReplicatedEvent('UniformColor');
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x43
    if(VarName == 'GruntColor')
    {
        // End:0x40
        if(MatInst != none)
        {
            MatInst.SetVectorParameterValue('LightColor', GruntColor);
        }        
    }
    else
    {
        // End:0x86
        if(VarName == 'UniformColor')
        {
            // End:0x83
            if(MatInst != none)
            {
                MatInst.SetVectorParameterValue('TeamColor', UniformColor);
            }            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}
