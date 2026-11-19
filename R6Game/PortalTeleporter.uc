class PortalTeleporter extends SceneCaptureReflectActor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var() PortalTeleporter SisterPortal;
var export editinline StaticMeshComponent PortalMirror;
var MaterialInstanceConstant MirrorMaterial;

// Export UPortalTeleporter::execTransformActor(FFrame&, void* const)
native function bool TransformActor(Actor A);

// Export UPortalTeleporter::execTransformVector(FFrame&, void* const)
native function Vector TransformVector(Vector V);

// Export UPortalTeleporter::execTransformHitLocation(FFrame&, void* const)
native function Vector TransformHitLocation(Vector HitLocation);

// Export UPortalTeleporter::execCreatePortalTexture(FFrame&, void* const)
native function TextureRenderTarget CreatePortalTexture();

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x14
    if(SisterPortal == none)
    {
        return;
    }
    InitPortal(self, SisterPortal);
    return;
}

simulated function InitPortal(PortalTeleporter Source, PortalTeleporter Dest)
{
    local MaterialInstance MirrorMaterialPrototype;

    MirrorMaterialPrototype = Source.PortalMirror.GetMaterial(0);
    MirrorMaterial = new (none) Class'MaterialInstanceConstant';    
    MirrorMaterial.SetParent(MirrorMaterialPrototype);
    Source.PortalMirror.SetMaterial(0, MirrorMaterial);
    SceneCaptureReflectComponent(Dest.SceneCapture).TextureTarget = CreatePortalTexture();
    MirrorMaterial.SetTextureParameterValue('PortalRenderTexture', SceneCaptureReflectComponent(Dest.SceneCapture).TextureTarget);
    return;
}

defaultproperties
{
    bWorldGeometry=true
    bGameRelevant=true
    bCollideActors=true
    bBlockActors=true
    // Reference: SceneCaptureReflectComponent'Default__PortalTeleporter.SceneCaptureReflectComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SceneCaptureReflectComponent'Default__SceneCaptureReflectActor.SceneCaptureReflectComponent0'
    begin object name="SceneCaptureReflectComponent0"
    end object
    Components[0]=SceneCaptureReflectComponent0
    // Reference: StaticMeshComponent'Default__PortalTeleporter.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__SceneCaptureReflectActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
    end object
    Components[1]=StaticMeshComponent0
}