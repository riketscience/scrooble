package scrooble ;

class Bag {
	
	public var tiles:Array<Tile>;
	public var availableTiles = [];
	private static var tileImages = [ "images/A.png", "images/B.png", "images/C.png", "images/D.png", "images/E.png", "images/F.png", "images/G.png", "images/H.png", "images/I.png", "images/J.png", "images/K.png", "images/L.png", "images/M.png", "images/N.png", "images/O.png", "images/P.png", "images/Q.png", "images/R.png", "images/S.png", "images/T.png", "images/U.png", "images/V.png", "images/W.png", "images/X.png", "images/Y.png", "images/Z.png", "images/BL.png" ];

	public function new () {
		
	}
	
	public function initialize ():Void {
		
		tiles =    [new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),new Tile (tileImages[0]),	
				   new Tile (tileImages[1]), new Tile (tileImages[1]),
				   new Tile (tileImages[2]), new Tile (tileImages[2]),
				   new Tile (tileImages[3]), new Tile (tileImages[3]), new Tile (tileImages[3]), new Tile (tileImages[3]),
				   new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]), new Tile (tileImages[4]),
				   new Tile (tileImages[5]), new Tile (tileImages[5]),
				   new Tile (tileImages[6]), new Tile (tileImages[6]), new Tile (tileImages[6]),
				   new Tile (tileImages[7]), new Tile (tileImages[7]),
				   new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]), new Tile (tileImages[8]),
				   new Tile (tileImages[9]),
				   new Tile (tileImages[10]),
				   new Tile (tileImages[11]), new Tile (tileImages[11]), new Tile (tileImages[11]), new Tile (tileImages[11]),
				   new Tile (tileImages[12]), new Tile (tileImages[12]),
				   new Tile (tileImages[13]), new Tile (tileImages[13]), new Tile (tileImages[13]), new Tile (tileImages[13]), new Tile (tileImages[13]), new Tile (tileImages[13]),
				   new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]), new Tile (tileImages[14]),
				   new Tile (tileImages[15]), new Tile (tileImages[15]),
				   new Tile (tileImages[16]),
				   new Tile (tileImages[17]), new Tile (tileImages[17]), new Tile (tileImages[17]), new Tile (tileImages[17]), new Tile (tileImages[17]), new Tile (tileImages[17]),
				   new Tile (tileImages[18]), new Tile (tileImages[18]), new Tile (tileImages[18]), new Tile (tileImages[18]),
				   new Tile (tileImages[19]), new Tile (tileImages[19]), new Tile (tileImages[19]), new Tile (tileImages[19]), new Tile (tileImages[19]), new Tile (tileImages[19]),
				   new Tile (tileImages[20]), new Tile (tileImages[20]), new Tile (tileImages[20]), new Tile (tileImages[20]),
				   new Tile (tileImages[21]), new Tile (tileImages[21]),
				   new Tile (tileImages[22]), new Tile (tileImages[22]),
				   new Tile (tileImages[23]),
				   new Tile (tileImages[24]), new Tile (tileImages[24]),
				   new Tile (tileImages[25]),
				   new Tile (tileImages[26]), new Tile (tileImages[26])];
	/*		letters [name, value, occurance]
			letters = [["A",1,9],["B",3,2],["C",3,2],["D",2,4],["E",1,12],["F",4,2],["G",2,3],["H",4,2],
			["I",1,9],["J",8,1],["K",5,1],["L",1,4],["M",3,2],["N",1,6],["O",1,8],["P",3,2],["Q",10,1],["R",1,6],
	["S",1,4],["T",1,6],["U",1,4],["V",4,2],["W",4,2],["X",8,1],["Y",4,2],["Z",10,1],["_",99,2]];
*/
		resetAvailableTiles();
	}
	
	public function getTile() {
		var chosenTileId = Math.round (Math.random () * (availableTiles.length)); // 100 tiles in the game  -- bag.availableTiles.length
	
		var result = tiles[chosenTileId];
		availableTiles.splice(chosenTileId, 1);
		return result;
	}
	
	function resetAvailableTiles()
	{
		for (i in 1...101) availableTiles.push(i);
	}
}
	
	
