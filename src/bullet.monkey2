
Class Bullet Extends Actor
	
	Global debug := False
	
	Method New( sprite:Sprite )
		Super.New( sprite )
		OnReset()
		visible = False
		speed = 15
		name = "bullet"
	End	
	
	Method OnUpdate() Override
		position.X += speed
		collider.Position( position.X, position.Y )
		If position.X > ( player.position.X + cullDistance ) Then visible = False
   		
		For Local other := Eachin Actor.catalog
			If detectCollision
				If other.visible And Not ( other.name = "bullet" ) And Not ( other = player )
					If collider.Overlaps( other.collider )
						speed = 0
						anim = "hit"
						detectCollision = False
						sprite.Reset()
						Hide( 200 )
						other.Reset()
					End
				End
			End
		End
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		If debug
			GameGraphics.DrawRectOutline( canvas, collider.Left, collider.Top, collider.Width, collider.Height )
		End
	End
	
	
	Method OnReset() Override
		collider.Size( 8, 8 )
		speed = 8
		anim = "idle"
	End
	
End