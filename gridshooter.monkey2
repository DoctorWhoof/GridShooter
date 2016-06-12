'   Copyleft notice: All code created by Leo Santos (www.leosantos.com)
'   Feel free to use it in any form, but please include a credit.
'   More importantly, do not claim to have created any of it, unless you modify it substantially.
'   Thanks!

#Import "src/gamegraphics"
#Import "src/renderwindow"
#Import "src/actor"
#Import "src/player"
#Import "src/bullet"
#Import "src/orb"

#Import "fonts/classic_sans.ttf"
#Import "images/grid.png"
#Import "images/starfield.png"
#Import "images/hero.png"
#Import "images/jet.png"
#Import "images/bullet.png"
#Import "images/orbSmall.png"

Using mojo..
Using std..

'To do: move out of collision

Class Game Extends RenderWindow

	Global scrollSpeed := 5.0
	Global scrollLimitY:Double = 60
	Global cameraSpeed := 1.0
	
	Field hero:Player
	Field jet:Actor
	Field bg:Background
	Field bgGrid:Background
	
	Field heroSprite:Sprite
	Field jetSprite:Sprite
	Field orbSprite:Sprite
	Field bulletSprite:Sprite
	Field smallFont:Font

	Field colorTint:= New Color( 0.25, 1.0, 0.5 )
	
	Method New()					
		Super.New( "Test", 420, 240, False, False )		'name, width, height, filterTextures, renderToTexture
		Layout = "letterbox-int"
	End
	
	
	Method OnStart() Override
		Actor.camera = camera
	
		'Load sprites & font
		smallFont = Font.Load( "asset::classic_sans.ttf", 10, Null )
		
		bg = New Background( "asset::starfield.png", False )
		bgGrid = New Background( "asset::grid.png", False )
		
		heroSprite = New Sprite( "asset::hero.png", 3, 32, 32, False )
		heroSprite.AddAnimationClip( "idle", New Int[]( 0 ) )
		heroSprite.AddAnimationClip( "up", New Int[]( 1 ) )
		heroSprite.AddAnimationClip( "down", New Int[]( 2 ) )
		
		jetSprite = New Sprite( "asset::jet.png", 2, 16, 16, False )
		jetSprite.AddAnimationClip( "idle", New Int[]( 0,1 ) )
		jetSprite.frameRate = 30
		
		bulletSprite = New Sprite( "asset::bullet.png", 5, 32, 32, False )
		bulletSprite.AddAnimationClip( "idle", New Int[] ( 0 ) )
		bulletSprite.AddAnimationClip( "hit", New Int[] ( 1,2,3,4 ), False )
		bulletSprite.frameRate = 15
		
		orbSprite = New Sprite( "asset::orbSmall.png", 5, 16, 16, False )
		orbSprite.AddAnimationClip( "idle", New Int[] ( 0,1,2,3 ) )
		
		'Create player sprite
		jet = New Actor( jetSprite )
		hero = New Player( heroSprite )
		hero.jet = jet
		
		'Create reusable enemy orbs
		SeedRnd( 12345 )
		Local offset:= 0
		For Local n := 0 Until 20
			Local neworb := New Orb( orbSprite )
			neworb.Reset()
			neworb.position.X += offset
			offset += 16
		Next
		
		'Pool of 10 reusable bullets
		For Local n := 0 Until 10
			Local b := New Bullet( bulletSprite )
			Actor.bulletPool.Push( b )
		Next
		Bullet.player = hero
		Bullet.cullDistance = Width
		
		ToggleDebug()
	End
	
	
	Method OnUpdate() Override
		'camera scrolls up & down a bit, 90's shooter style
		camera.X += scrollSpeed			
		If Keyboard.KeyDown( Key.Up )
			camera.Y -= cameraSpeed
		Else If Keyboard.KeyDown( Key.Down )
			camera.Y += cameraSpeed
		End
		camera.Y = Clamp( camera.Y, -scrollLimitY, scrollLimitY )
		
		'Update all actors
		Actor.UpdateAll()
		
		'Display debug info
		If Keyboard.KeyHit( Key.D ) Then ToggleDebug()
		
		'Toggle render to texture
		If Keyboard.KeyHit( Key.T ) Then renderToTexture = Not renderToTexture
	End
	
	
	Method OnDraw() Override
		canvas.Color = colorTint
		_windowCanvas.Font = smallFont
		_textureCanvas.Font = smallFont

		'Draw bg objects in three layers with different parallax
		canvas.Alpha = 1.0
		Parallax = 0.05
		bg.Draw( canvas, 0, 0, 1.0, CameraRect )
		
		canvas.Alpha = 0.5
		canvas.DrawText( "Monkey2 Side Scrolling Demo by Leo Santos. Press space to shoot, 'T' to toggle render to texture and 'D' to display debug info.", 200, 100 )
		
		canvas.Alpha = 0.25
		Parallax = 0.2
		bgGrid.Draw( canvas, 32, 32, 1.0, CameraRect )
		
		canvas.Alpha = 0.5
		Parallax = 0.75
		bgGrid.Draw( canvas, 0, 0, 1.0, CameraRect )
		
		'Draw all actors
		canvas.Alpha = 1.0
		Parallax = 1.0
		canvas.Color= Color.White
		Actor.DrawAll( canvas )
	End
	
	
	Method ToggleDebug()
		debug = Not debug
		bg.debug = debug
		bgGrid.debug = debug
		heroSprite.debug = debug
		orbSprite.debug = debug
		Bullet.debug = debug		'this one draws the collider via Bullet.OnDraw()
	End
	
End


Function Main()
	New AppInstance
	New Game()
	App.Run()
End


