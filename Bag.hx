package scrooble ;

class Bag {
	
	public var tiles:Array<Tile>;
	public var availableTiles = [];
	private static var tileImages = [ "images/A.png", "images/B.png", "images/C.png", "images/D.png", "images/E.png", "images/F.png", "images/G.png", "images/H.png", "images/I.png", "images/J.png", "images/K.png", "images/L.png", "images/M.png", "images/N.png", "images/O.png", "images/P.png", "images/Q.png", "images/R.png", "images/S.png", "images/T.png", "images/U.png", "images/V.png", "images/W.png", "images/X.png", "images/Y.png", "images/Z.png", "images/BL.png" ];

	public function new () {
		
	}
	
	public function initialize ():Void {
		
		tiles = [
			new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),new Tile (tileImages[0],"A",1),	
			new Tile (tileImages[1],"B",3), new Tile (tileImages[1],"B",3),
			new Tile (tileImages[2],"C",3), new Tile (tileImages[2],"C",3),
			new Tile (tileImages[3],"D",2), new Tile (tileImages[3],"D",2), new Tile (tileImages[3],"D",2), new Tile (tileImages[3],"D",2),
			new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1), new Tile (tileImages[4],"E",1),
			new Tile (tileImages[5],"F",4), new Tile (tileImages[5],"F",4),
			new Tile (tileImages[6],"G",2), new Tile (tileImages[6],"G",2), new Tile (tileImages[6],"G",2),
			new Tile (tileImages[7],"H",4), new Tile (tileImages[7],"H",4),
			new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1), new Tile (tileImages[8],"I",1),
			new Tile (tileImages[9],"J",8),
			new Tile (tileImages[10],"K",5),
			new Tile (tileImages[11],"L",1), new Tile (tileImages[11],"L",1), new Tile (tileImages[11],"L",1), new Tile (tileImages[11],"L",1),
			new Tile (tileImages[12],"M",3), new Tile (tileImages[12],"M",3),
			new Tile (tileImages[13],"N",1), new Tile (tileImages[13],"N",1), new Tile (tileImages[13],"N",1), new Tile (tileImages[13],"N",1), new Tile (tileImages[13],"N",1), new Tile (tileImages[13],"N",1),
			new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1), new Tile (tileImages[14],"O",1),
			new Tile (tileImages[15],"P",3), new Tile (tileImages[15],"P",3),
			new Tile (tileImages[16],"Q",10),
			new Tile (tileImages[17],"R",1), new Tile (tileImages[17],"R",1), new Tile (tileImages[17],"R",1), new Tile (tileImages[17],"R",1), new Tile (tileImages[17],"R",1), new Tile (tileImages[17],"R",1),
			new Tile (tileImages[18],"S",1), new Tile (tileImages[18],"S",1), new Tile (tileImages[18],"S",1), new Tile (tileImages[18],"S",1),
			new Tile (tileImages[19],"T",1), new Tile (tileImages[19],"T",1), new Tile (tileImages[19],"T",1), new Tile (tileImages[19],"T",1), new Tile (tileImages[19],"T",1), new Tile (tileImages[19],"T",1),
			new Tile (tileImages[20],"U",1), new Tile (tileImages[20],"U",1), new Tile (tileImages[20],"U",1), new Tile (tileImages[20],"U",1),
			new Tile (tileImages[21],"V",4), new Tile (tileImages[21],"V",4),
			new Tile (tileImages[22],"W",4), new Tile (tileImages[22],"W",4),
			new Tile (tileImages[23],"X",8),
			new Tile (tileImages[24],"Y",4), new Tile (tileImages[24],"Y",4),
			new Tile (tileImages[25],"Z",10),
			new Tile (tileImages[26],"_",1), new Tile (tileImages[26],"_",1)];
				   
		for (i in 0...100) availableTiles.push(i);
	}
	
	public function takeATile() {
		var chosenTileId = Math.round (Math.random () * (availableTiles.length - 1));
		var result = tiles[chosenTileId];
		availableTiles.splice(chosenTileId, 1);
		return result;
	}
}
	
	
