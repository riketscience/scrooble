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
				   
		for (i in 0...100) availableTiles.push(i);
	}
	
	public function takeATile() {
		var chosenTileId = Math.round (Math.random () * (availableTiles.length - 1)); // 100 tiles in the game  -- bag.availableTiles.length
	
		var result = tiles[chosenTileId];
		availableTiles.splice(chosenTileId, 1);
		return result;
	}
}
	
	
