class AdvOracleBase extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

var() export editinline ParticleSystemComponent Particle;
var() export editinline StaticMeshComponent Statue;
var() MaterialInstanceConstant SpecialMaterial;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTHMaterial();
    //return;    
}

simulated function SetTHMaterial()
{
    local MaterialInstance MI;

    // End:0x13A
    if((WorldInfo.GRI != none) && WorldInfo.GRI.GameClass != none)
    {
        // End:0x137
        if((class<AdvGameTeamTreasureHuntBase>(WorldInfo.GRI.GameClass) != none) || class<AdvGameTreasureHuntBase>(WorldInfo.GRI.GameClass) != none)
        {
            MI = Statue.CreateAndSetMaterialInstanceConstant(0);
            MI.SetParent(SpecialMaterial);
        }        
    }
    else
    {
        SetTimer(0.0100000, false, 'SetTHMaterial');
    }
    //return;    
}

simulated function SetPArticleActivation(bool bEnabled)
{
    Particle.SetActive(bEnabled);
    //return;    
}

defaultproperties
{
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bNoDelete=true
    bCollideActors=true
    bCollideWorld=true
    bEdShouldSnap=true
}