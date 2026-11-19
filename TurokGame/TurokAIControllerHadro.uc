class TurokAIControllerHadro extends TurokAIControllerHerbivore
    native
    hidecategories(Navigation);

function GotoTurnState(@NULL turnGraph)
{
    local @NULL Dino;
    local float Duration;

    Duration = turnGraph.GetPreviewDuration(Pawn.Mesh, 0);
    SetNoTurnTimer(Duration);
    TurokPawn(Pawn).PlayGraphReplicated(turnGraph, self, 0);
    Dino = TurokPawnDino(Pawn);
    // End:0x71
    if(Dino == none)
    {
        return;
    }
    // End:0x88
    if(Dino.mTailAttackEnable == false)
    {
        return;
    }
    Dino.ActivateSkeletalHurt(6, Dino.mTailAttackDamage, Dino.mTailAttackRadius, Dino.mTailAttackImpulseScale * Mass, Duration, true);
    //return;    
}

event NotifySkeletalHurtCollision(byte hurtType, @NULL collidingPawn, @NULL HitLocation)
{
    local @NULL Human, vVel;

    // End:0x0D
    if(collidingPawn == none)
    {
        return;
    }
    // End:0x21
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        return;
    }
    Human = TurokPawnHuman(collidingPawn);
    // End:0x1A4
    if(((Human != none) && !Human.IsMauling()) || Human == none)
    {
        // End:0x1A4
        if((Human == none) || !Human.IsInKnockdown())
        {
            vVel = collidingPawn.Location - Pawn.Location;
            vVel.Z = 1.0000000;
            vVel = Normal(vVel);
            vVel *= 300.0000000;
            collidingPawn.Velocity = vVel;
            collidingPawn.Acceleration = vVel;
            // End:0x161
            if((TurokPawnPlayer(collidingPawn) != none) && collidingPawn.Controller != none)
            {
                collidingPawn.SetPhysics(2);
                TurokPlayerController(collidingPawn.Controller).GotoImpulseState(0.2500000, vVel);
            }
            // End:0x1A4
            if(collidingPawn.IsA('TurokVehicle'))
            {
                collidingPawn.CollisionComponent.AddImpulse(vect(0.0000000, 0.0000000, 10000.0000000), HitLocation);
            }
        }
    }
    //return;    
}

defaultproperties
{
    mFleeMessage="HADRO_Flee"
    mFoodMessage="HADRO_FoundFood"
    mControllerType=2
    // Reference: SpriteComponent'Default__TurokAIControllerHadro.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}