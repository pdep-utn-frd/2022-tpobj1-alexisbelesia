import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(meteorito)
	    game.addVisual(segundoMeteorito)
	    
		keyboard.space().onPressDo{ self.jugar()}
		keyboard.alt().onPressDo{ self.comando()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		meteorito.iniciar()
		segundoMeteorito.iniciar()
	}
	method comando(){
		if (dino.estaVivo()) 
			dino.caer()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
		meteorito.detener()
		segundoMeteorito.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-3,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -3)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}
 object meteorito {
	 
	const posicionInicial = game.at(game.width()-1,2)
	var position = posicionInicial

	method image() = "meteorito.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverMeteorito",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		reloj.iniciar()
	}
    method detener(){
		game.removeTickEvent("moverMeteorito")
	}
}
 object segundoMeteorito {
	 
	const posicionInicial = game.at(game.width()-5,2)
	var position = posicionInicial

	method image() = "meteorito.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverMeteorito",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -5)
			position = posicionInicial
	}
	
	method chocar(){
		reloj.iniciar()
	}
    method detener(){
		game.removeTickEvent("moverMeteorito")
	}
}
object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			//game.schedule(velocidad*3,{self.bajar()})
		}
		}
	method caer(){
		if(position.y() == 2) {
			self.bajar()
			//game.schedule(velocidad*3,{self.bajar()})
		}	
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}