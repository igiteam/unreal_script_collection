class SPMaterialTestPawnPersistent extends SPPawn
    config(Game);

struct BoneRegion
{
    var array<name> Bones;

    structdefaultproperties
    {
        Bones=none
    }
};

var BoneRegion boneRegions[4];
var float regionHealth[4];
var Material mtlHeadNorm;
var Material mtlHeadDamage;
var Material mtlHeadLADamage;
var Material mtlHeadRADamage;
var Material mtlHeadLARADamage;
var Material mtlLARA;
var Material mtlLA;
var Material mtlRA;
var Material mtlBodyNorm;
var Material mtlBodyDamage;

function DBG_WWDTPMsg(string Str)
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

function ResetDamageTextures()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2E [Loop If]
    if(I < 4)
    {
        regionHealth[I] = 80.0000000;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    AssignDamageTextures();
    //return;    
}

simulated function PostBeginPlay()
{
    ResetDamageTextures();
    //return;    
}

function int GetRegionFromBone(name BoneName)
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0x7B [Loop If]
    if(I < 4)
    {
        J = 0;
        J0x1A:

        // End:0x71 [Loop If]
        if(J < boneRegions[I].Bones.Length)
        {
            // End:0x67
            if(boneRegions[I].Bones[J] == BoneName)
            {
                return I;
            }
            J++;
            // [Loop Continue]
            goto J0x1A;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function AssignDamageTextures()
{
    // End:0xB6
    if(regionHealth[0] == float(0))
    {
        // End:0x6A
        if(regionHealth[1] == float(0))
        {
            // End:0x4C
            if(regionHealth[2] == float(0))
            {
                Mesh.SetMaterial(2, mtlHeadLARADamage);                
            }
            else
            {
                Mesh.SetMaterial(2, mtlHeadLADamage);
            }            
        }
        else
        {
            // End:0x98
            if(regionHealth[2] == float(0))
            {
                Mesh.SetMaterial(2, mtlHeadRADamage);                
            }
            else
            {
                Mesh.SetMaterial(2, mtlHeadDamage);
            }
        }        
    }
    else
    {
        // End:0x111
        if(regionHealth[1] == float(0))
        {
            // End:0xF3
            if(regionHealth[2] == float(0))
            {
                Mesh.SetMaterial(2, mtlLARA);                
            }
            else
            {
                Mesh.SetMaterial(2, mtlLA);
            }            
        }
        else
        {
            // End:0x13F
            if(regionHealth[2] == float(0))
            {
                Mesh.SetMaterial(2, mtlRA);                
            }
            else
            {
                Mesh.SetMaterial(2, mtlHeadNorm);
            }
        }
    }
    // End:0x188
    if(regionHealth[3] == float(0))
    {
        Mesh.SetMaterial(3, mtlBodyDamage);        
    }
    else
    {
        Mesh.SetMaterial(3, mtlBodyNorm);
    }
    //return;    
}

function UpdateDamageTextures(float Damage, name BoneName)
{
    local int RegionID;

    RegionID = GetRegionFromBone(BoneName);
    // End:0x26
    if(RegionID == -1)
    {
        return;
    }
    // End:0x54
    if((regionHealth[RegionID] - Damage) <= float(0))
    {
        regionHealth[RegionID] = 0.0000000;        
    }
    else
    {
        regionHealth[RegionID] -= Damage;
    }
    AssignDamageTextures();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    mtlTestMtlInstance = Mesh.GetMaterial(2);
    mtlTestMtl = mtlTestMtlInstance.GetMaterial();
    mtlTestMtl.bDebug = true;
    UpdateDamageTextures(DamageAmount, HitInfo.BoneName);
    //return;    
}
