package scrooble ;

import openfl.Assets;

class Board {	
	
	public var column:Int;
	public var row:Int;
	public var squarePositions:Array<Dynamic>;
	public var letters:Array<Dynamic>;
	public var boardsquares:Array<Dynamic>;
	public var squares:Array <Array <GameSquare>>;
	
	public function new () {
		initialize ();		
	}
					   
	public function initialize ():Void {
	
		squares = new Array <Array <GameSquare>> ();

		var letters = new Array<Dynamic> (); 
		letters = [
			["A",1,9],["B",3,2],["C",3,2],["D",2,4],["E",1,12],["F",4,2],["G",2,3],
			["H",4,2],["I",1,9],["J",8,1],["K",5,1],["L",1,4],["M",3,2],["N",1,6],
			["O",1,8],["P",3,2],["Q",10,1],["R",1,6],["S",1,4],["T",1,6],["U",1,4],
			["V",4,2],["W",4,2],["X",8,1],["Y",4,2],["Z",10,1],["_",99,2]];
	}
	
	public function getSquareValue(x:Int, y:Int) {
		var letterValue = squares[x][y].current_tile_value;
		var multiplier = squares[x][y].multipler_value;
		return letterValue * multiplier;
	}
	
	public function setSquareValue(x:Int, y:Int, val:Int, let:String) {
		squares[x][y].current_tile_value = val;
		squares[x][y].current_tile_letter = let;
	}
}
