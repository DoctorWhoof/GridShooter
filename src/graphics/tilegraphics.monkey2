
'Base class used by Shapes like Tilemap and Background
Class TileGraphics Extends GameGraphics Abstract

	Protected
	
	Field tileWidth:Double
	Field tileHeight:Double

	Field viewLeft:Double
	Field viewTop:Double
	Field viewRight:Double
	Field viewBottom:Double
	
	Field tileStartX:Int
	Field tileStartY:Int
	Field tileEndX:Int
	Field tileEndY:Int
	
	Public

	Method GetVisibleTiles( x:Double, y:Double, scale:Double, camera:Rect<Double> )

		tileWidth = images[0].Width * scale
		tileHeight = images[0].Height * scale

		viewLeft = camera.Left - x
		viewRight = camera.Right - x
		viewTop = camera.Top - y
		viewBottom = camera.Bottom - y
		
		tileStartX = Floor( viewLeft / tileWidth )
		tileStartY = Floor( viewTop / tileHeight )

		tileEndX = Ceil( viewRight / tileWidth )
		tileEndY = Ceil( viewBottom / tileHeight )
	End

End