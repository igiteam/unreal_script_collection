class TPPostureVolume extends Volume
    placeable;

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    local PlayerPawn player;

    player = PlayerPawn(Other);

    if (player != None)
    {
        if (player.bIsCrouched)
        {
            player.ChangePosture();
        }

        player.bInPostureVolume = true;
    }
}

event Untouch(Actor Other)
{
    local PlayerPawn player;

    player = PlayerPawn(Other);

    if (player != None)
    {
        player.bInPostureVolume = false;
    }
}

