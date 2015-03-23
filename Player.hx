package scrooble;

class Player
{
	public var name:String;
	public var id:Int;
	public var isPlayersGo:Bool;
	public var score:Int;
	public var tiles:Array<Tile>;
	
	public function new() {}
	
	public function initialize (idIn:Int, nameIn:String, playing:Bool):Void {
		name = nameIn;
		id = idIn;
		isPlayersGo = playing;
		score = 0;
		tiles = [];
	}
}