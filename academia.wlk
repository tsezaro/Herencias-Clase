class Mueble{ 
	const property coleccionCosas = []
	
	method volumenDeCosas() = coleccionCosas.sum({ cosa => cosa.volumen() })
	
	method agregarCosa(unaCosa){
		coleccionCosas.add(unaCosa)
	}
	
	
	method identificarCosaEnMueble(unaCosa) = coleccionCosas.contains(unaCosa)
	
	method puedeEntrar(unaCosa) = not coleccionCosas.contains(unaCosa) 
	
	method utilidad() = coleccionCosas.sum({ cosa => cosa.utilidad()}) / self.precio()
	
	method precio()
	
	method cosaMenosUtil() = coleccionCosas.min({ cosa => cosa.utilidad() })  
	
	method marcaMenosUtil() = self.cosaMenosUtil().marca()
	
	method removerCosasMenosUtiles(listaDeCosas){
		  coleccionCosas.removeAll(listaDeCosas)
	}
}


class Baul inherits Mueble{
	
	var property volumenMaximo
	
	method superaCapacidad(unaCosa) = self.volumenDeCosas() + unaCosa.volumen() <= volumenMaximo
	
	override method agregarCosa(unaCosa){
		if(self.superaCapacidad(unaCosa)){
			super(unaCosa)
		}
		
	}
	
	override method puedeEntrar(unaCosa) = self.superaCapacidad(unaCosa) and super(unaCosa)
	
	override method precio() = volumenMaximo + 2
	
	override method utilidad(){
		if (self.sonTodasReliquias()){
			return super() + 2
		}
		else{
			return super()
		}
	}
	
	method sonTodasReliquias() = coleccionCosas.all({ cosa => cosa.reliquia() }) 
	
}

class BaulMagico inherits Baul{
	override method utilidad() = super() + coleccionCosas.count({ unaCosa => unaCosa.magico() })
	
	override method precio() = super() * 2 
	
}

class GabineteMagico inherits Mueble{
	
	var property precio
	
	override method agregarCosa(unaCosa){
		if(unaCosa.magico()){
			super(unaCosa)
		}
	}
	
	override  method puedeEntrar(unaCosa) = unaCosa.magico() and super(unaCosa)
	
	
	 
}

class ArmarioConvencional inherits Mueble{
	
	var property cantidadMaxima
	
	override method agregarCosa(unaCosa){
		if (self.superaCantidad()){
			super(unaCosa)
		}
	}
	
	method superaCantidad() = coleccionCosas.size() < cantidadMaxima
	
	override method puedeEntrar(unaCosa) = self.superaCantidad() and super(unaCosa)
	
	override method precio() = cantidadMaxima * 5
}




class Cosa{
	var property volumen
	var property magico 
	var property reliquia
	var property marca
	
	method utilidad() = volumen + self.esMagico() + self.esReliquita() + marca.aporte(self)  
	
	method esMagico(){
		if(magico){
			return 3
		}
		else{
			return 0
		}
	}
	
	method esReliquita(){
		if(reliquia){
			return 5
		}
		else{
			return 0
		}
	}
	
}

class Academia{
	const muebles = []
	
	method agregarMueble(unMueble){
		muebles.add(unMueble)
	} 
	
	method identificarCosas(unaCosa) = muebles.any({ mueble => mueble.identificarCosaEnMueble(unaCosa)})

	method identificarMueble(unaCosa) = muebles.find({ mueble => mueble.identificarCosaEnMueble(unaCosa) })
	
	method sePuedeGuardar(unaCosa) = muebles.any({ mueble => mueble.puedeEntrar(unaCosa) }) and not self.identificarCosas(unaCosa)
	
	method guardarCosas(unaCosa){
		if(self.sePuedeGuardar(unaCosa)){
			const mueble = muebles.find({  mueble => mueble.puedeEntrar(unaCosa) })
			mueble.agregarCosa(unaCosa)
		}
		else{
			self.error("No se puede guardar")
		}
	}
	
	method cosasMenosUtiles() = muebles.map({ mueble => mueble.cosaMenosUtil() }).asSet()
	
	method marcaMenosUtil(){
		const marcaMenosUtil = self.cosasMenosUtiles().min({ cosa => cosa.utilidad() })
		
		return marcaMenosUtil.marca()
	}
	
	method removerCosas(){
		if(muebles.size() >= 3){
			const cosaMenosUtil = self.cosasMenosUtiles().filter({ cosa => not cosa.magico() })
			muebles.forEach({ mueble => mueble.removerCosasMenosUtiles(cosaMenosUtil)  })
		}
		else{
			self.error("No se puede removar.")
		}
	} 
	
	method removerMueble(unMueble){
		muebles.remove(unMueble)
	}
}


object cuchuflito{
	method aporte(unaCosa) = 0 
}

object acme{
	method aporte(unaCosa) = unaCosa.volumen() / 2
	
}

object fenix{
	method aporte(unaCosa){
		if(unaCosa.reliquia()){
			return 3
		}
		else{
			return 0
		} 
	}  
}