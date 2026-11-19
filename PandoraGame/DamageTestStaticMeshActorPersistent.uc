class DamageTestStaticMeshActorPersistent extends SPDStaticMesh
    native;

var MaterialInterface mtlTestMtlInstance;
var Material mtlTestMtl;
var Texture2D srcTex;

// Export UDamageTestStaticMeshActorPersistent::execAddBatchLine(FFrame&, void* const)
native function AddBatchLine(Vector vStart, Vector vEnd, Color Col);

// Export UDamageTestStaticMeshActorPersistent::execClearLines(FFrame&, void* const)
native function ClearLines();

// Export UDamageTestStaticMeshActorPersistent::execGetUVFromHitLoc(FFrame&, void* const)
native function bool GetUVFromHitLoc(Vector vStart, Vector vEnd, out Vector vHitLoc, out float U, out float V);

function DBG_MsgDT(string Str)
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

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector vDir, smHitLocation, smHitNormal, vFinalHitLoc, vHitLoc;

    local Color Col;
    local float U, V;
    local Vector vTri0, vWeaponSocketPos;

    DBG_MsgDT("DamageTestStaticMeshActor Took Damage");
    // End:0x5A
    if(Momentum != vect(0.0000000, 0.0000000, 0.0000000))
    {
        vDir = Normal(Momentum);        
    }
    else
    {
        EventInstigator.Pawn.Mesh.GetSocketWorldLocationAndRotation('AimSocket', vWeaponSocketPos);
        vDir = Normal(HitLocation - vWeaponSocketPos);
    }
    Trace(smHitLocation, smHitNormal, HitLocation, HitLocation + (vDir * 999999.0000000), true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo,, true);
    GetUVFromHitLoc(HitLocation, HitLocation + (vDir * 999999.0000000), vFinalHitLoc, U, V);
    vHitLoc.X = HitLocation.X;
    vHitLoc.Y = HitLocation.Y;
    vHitLoc.Z = HitLocation.Z + 10000.0000000;
    Col.A = 255;
    Col.R = 255;
    Col.G = 0;
    Col.B = 0;
    AddBatchLine(HitLocation, vHitLoc, Col);
    Col.R = 0;
    Col.G = 255;
    AddBatchLine(EventInstigator.Pawn.Location, HitLocation + (vDir * 999999.0000000), Col);
    Col.G = 0;
    Col.B = 255;
    AddBatchLine(vTri0, vTri0 + vect(0.0000000, 0.0000000, 999999.0000000), Col);
    // End:0x2C3
    if(StaticMeshComponent.GetNumElements() < 2)
    {
        mtlTestMtlInstance = StaticMeshComponent.GetMaterial(0);        
    }
    else
    {
        mtlTestMtlInstance = StaticMeshComponent.GetMaterial(1);
    }
    mtlTestMtl = mtlTestMtlInstance.GetMaterial();
    mtlTestMtl.bDebug = true;
    super(Actor).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}
