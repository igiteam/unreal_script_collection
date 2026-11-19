class SPPedVarientPersistent extends SPPawn
    abstract
    config(Game);

var array<MaterialInstanceConstant> m_VarientMaterialInstances;

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

event CycleCharacter()
{
    AssignRandomCharacter();
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
    AssignRandomCharacter();
    SetTimer(2.0000000, true, 'CycleCharacter');
    super.PostBeginPlay();
    //return;    
}
