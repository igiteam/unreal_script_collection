class MOHADecalComponent extends DecalComponent
    editinlinenew
    hidecategories(Collision,Object,Physics,PrimitiveComponent);

static simulated function MOHADecalComponent AddDecal(Actor HitActor, MaterialInstance myDecalMaterial, Vector myDecalLocation, Rotator myDecalOrientation, float myDecalRotation, float myWidth, float MyHeight, float myThickness, bool mybNoClip, PrimitiveComponent myHitComponent, DecalLifetimeData myLifetimeData, optional MOHADecalComponent oldDecal)
{
    local editinline MOHADecalComponent Decal;

    // End:0x2A2
    if((int(HitActor.WorldInfo.NetMode) != int(NM_DedicatedServer)) && !HitActor.bDeleteMe)
    {
        // End:0x16B
        if(oldDecal != none)
        {
            oldDecal.Location = myDecalLocation;
            oldDecal.Orientation = myDecalOrientation;
            oldDecal.DecalRotation = myDecalRotation;
            oldDecal.Width = myWidth;
            oldDecal.Height = MyHeight;
            oldDecal.Thickness = myThickness;
            oldDecal.FarPlane = oldDecal.Thickness * 0.5000000;
            oldDecal.NearPlane = -oldDecal.FarPlane;
            oldDecal.bNoClip = mybNoClip;
            oldDecal.HitComponent = myHitComponent;
            oldDecal.LifetimeData = myLifetimeData;
            oldDecal.DecalMaterial = myDecalMaterial;
            HitActor.AttachComponent(oldDecal);
            return oldDecal;
        }
        Decal = new Class'MOHADecalComponent';
        Decal.Location = myDecalLocation;
        Decal.Orientation = myDecalOrientation;
        Decal.DecalRotation = myDecalRotation;
        Decal.Width = myWidth;
        Decal.Height = MyHeight;
        Decal.Thickness = myThickness;
        Decal.FarPlane = Decal.Thickness * 0.5000000;
        Decal.NearPlane = -Decal.FarPlane;
        Decal.bNoClip = mybNoClip;
        Decal.HitComponent = myHitComponent;
        Decal.LifetimeData = myLifetimeData;
        Decal.DecalMaterial = myDecalMaterial;
        HitActor.AttachComponent(Decal);
        return Decal;
    }
    //return ReturnValue;    
}

defaultproperties
{
    bAcceptsLights=true
    bAcceptsDynamicLights=true
}