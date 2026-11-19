class PandoraCheckpointReplicator extends ReplicationInfo;

const CHECKPOINT_DATA_PACKET_SIZE = 128;

var array<byte> RawData;
var PandoraPlayerController PlayerOwner;

replication
{
    // Pos:0x000
    if(bNetDirty
        PlayerOwner;
}

reliable client simulated function ClientReceiveData(int BaseIndex, int Count, byte Data[128])
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < Count)
    {
        RawData[BaseIndex + I] = Data[I];
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    ServerSendData(BaseIndex + Count);
    //return;    
}

reliable server function ServerSendData(int BaseIndex)
{
    local int I, Count;
    local byte Data[128];

    Count = Min(128, RawData.Length - BaseIndex);
    // End:0x7C
    if(Count > 0)
    {
        I = 0;
        J0x29:

        // End:0x60 [Loop If]
        if(I < Count)
        {
            Data[I] = RawData[BaseIndex + I];
            I++;
            // [Loop Continue]
            goto J0x29;
        }
        ClientReceiveData(BaseIndex, Count, Data);        
    }
    else
    {
        ClientNotifyDataSent();
    }
    //return;    
}

reliable client simulated function ClientNotifyDataSent()
{
    // End:0x21
    if(PlayerOwner == none)
    {
        SetTimer(0.1000000, false, 'ClientNotifyDataSent');        
    }
    else
    {
        PlayerOwner.SPCM.CheckpointData = RawData;
        PlayerOwner.SPCM.SaveCheckpoint();
        ServerNotifyDataReceived();
    }
    //return;    
}

reliable server function ServerNotifyDataReceived()
{
    Destroy();
    //return;    
}

function ReplicateCheckpoint(PandoraPlayerController PC, const out array<byte> InData)
{
    RawData = InData;
    PlayerOwner = PC;
    ServerSendData(0);
    //return;    
}
