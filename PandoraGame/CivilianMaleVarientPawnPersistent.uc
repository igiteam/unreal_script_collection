class CivilianMaleVarientPawnPersistent extends CivilianStandardPawnPersistent
    config(Game);

enum EVarientStyle
{
    VS_TypeA,                       // 0
    VS_TypeB,                       // 1
    VS_TypeC,                       // 2
    VS_MAX                          // 3
};

var array<MaterialInstanceConstant> m_VarientMaterialInstances;
var() bool bGenerateRandomCharacter;
var() array<CivilianMaleVarientPawnPersistent.EVarientStyle> MtlStyle;

function DBG_MsgPV(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function AssignRandomCharacter()
{
    local int I;
    local float rndval;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < m_VarientMaterialInstances.Length)
    {
        rndval = float(Rand(3));
        m_VarientMaterialInstances[I].SetScalarParameterValue('TypeSelect', rndval);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function AssignExplicitCharacter()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xC2 [Loop If]
    if(I < MtlStyle.Length)
    {
        switch(MtlStyle[I])
        {
            // End:0x55
            case 0:
                m_VarientMaterialInstances[I].SetScalarParameterValue('TypeSelect', 0.0000000);
                // End:0xB8
                break;
            // End:0x85
            case 1:
                m_VarientMaterialInstances[I].SetScalarParameterValue('TypeSelect', 1.0000000);
                // End:0xB8
                break;
            // End:0xB5
            case 2:
                m_VarientMaterialInstances[I].SetScalarParameterValue('TypeSelect', 2.0000000);
                // End:0xB8
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I, nMaterials;

    nMaterials = Mesh.GetNumElements();
    m_VarientMaterialInstances.Insert(0, nMaterials);
    I = 0;
    J0x2D:

    // End:0xB3 [Loop If]
    if(I < nMaterials)
    {
        m_VarientMaterialInstances[I] = new (none) Class'Engine.MaterialInstanceConstant';
        m_VarientMaterialInstances[I].SetParent(Mesh.GetMaterial(I));
        Mesh.SetMaterial(I, m_VarientMaterialInstances[I]);
        I++;
        // [Loop Continue]
        goto J0x2D;
    }
    // End:0xC9
    if(bGenerateRandomCharacter)
    {
        AssignRandomCharacter();        
    }
    else
    {
        AssignExplicitCharacter();
    }
    super(SoldierPawn).PostBeginPlay();
    //return;    
}
