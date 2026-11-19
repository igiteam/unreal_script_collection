class SkyProj_DwellerLauncher extends SkyProjectile
    native;

var(HitReaction) name TargetsReactionName;

// Export USkyProj_DwellerLauncher::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);
