class BombGoBoomInteraction extends Interaction
	within GameViewportClient
    abstract
	transient;

function GetPlayerController(TPPlayerController PlayerController);
function Initialized();
function NotifyGameSessionEnded();
function PostRender(Canvas Canvas);
function StartGame();
