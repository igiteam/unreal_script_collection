class CoreObject extends Object within CoreSystem
	native(Core);

struct native WaittillElement
{
	var init array<name> note;
	var CoreThread thread;
};

struct native WaittillMatchElement
{
	var name note;
	var name data;
	var CoreThread thread;
};

var const array<WaittillElement> WaittillList;
var const array<WaittillMatchElement> WaittillMatchList;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function Construct();

native function notify(name note, optional CoreNotify data);
native function endon(name note);

native latent function waittill(name note);
native latent function waittill_any(array<name> notes);
native latent function waittillmatch(name note, name data);
