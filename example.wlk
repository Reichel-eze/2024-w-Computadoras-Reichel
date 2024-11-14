class SuperComputadora {    // no hereda de la clase equipo, porque ya cumple con todo lo necesario para ser "conectable", por ejemplo la superComputadora NO tiene modos
  const equipos = []

  method estaActivo() = true   // que siempre se consideran activas!!
  
  // 1.a) equipos activos: son los equipos conectados a la SC que no están quemados y tienen una capacidad de cómputo mayor a cero.
  method equiposActivos() = equipos.filter({ equipo => equipo.estaActivo() })  

  // 1.b) capacidad de computo y consumo: este es el total de computo y consumo de todos los equipos activos
  method consumo() = self.equiposActivos().sum({equipo => equipo.consumo()})
  method computo() = self.equiposActivos().sum({equipo => equipo.computo()})

  // 1.c) malConfigurada: esto ocurre cuando el equipo de la SC que más consume NO es el que más computa.
  method malConfigurada() = self.equipoQueMasConsume() != self.equipoQueMasComputa() 

  method equipoQueMasConsume() = self.equiposActivos().max({equipo => equipo.consumo()}) 
  method equipoQueMasComputa() = self.equiposActivos().max({equipo => equipo.conputo()}) 

  // metodo mas general para que no haya repeticion de logica
  // method equipoActivoQueMas(criterio) = self.equiposActivos().max(criterio) 

  // 2)
  method computarProblema(n) {
    self.equiposActivos().forEach({equipo => equipo.computarSub_problema(n/self.cantidadEquiposActivos())})
  } 

  method cantidadEquiposActivos() = self.equiposActivos().size()



}

class Equipo {
  var property modo = standard // "El modo de cada equipo puede cambiarse a gusto en cualquier momento para adecuar a la super-computadora a una nueva tarea"
  var property estaQuemado = false 
  
  method estaActivo() = !estaQuemado and self.capacidadDeComputoPositiva()

  method capacidadDeComputoPositiva() = self.computo() > 0 

  method consumo() = modo.consumoDe(self)
  method computo() = modo.computoDe(self)
  
  method consumoBase() // metodo abstracto
  method computoBase() // metodo abstracto 
  
  method extraComputoPorOverclock()  

  method computarSub_problema(complejidad) {
    if(complejidad > self.computo()){
      throw new DomainException(message="El equipo falla porque intenta computar más que su capacidad de cómputo")
    }
    modo.computarSub_problema()
  }

}

class A105 inherits Equipo {
  override method consumoBase() = 300   // consumo base
  override method computoBase() = 600   // computo base

  override method extraComputoPorOverclock()  = self.computoBase() * 0.3 // Los A105 incrementan su capacidad un 30% (30% es el adicional, luego se lo sumo abajo)

  override method computarSub_problema(complejidad){
    super(complejidad)
    if(complejidad < 5){
      throw new DomainException(message="Los equipos A105 no pueden computar problemas de complejidad menor a 5. hacen mal el cálculo y fallan.")
    }
  }

}

class B2 inherits Equipo {
  var cantidadMicros    // La cantidad de micros que cada equipo tiene instalado puede variar y, como se fabrican a pedido, depende de cada equipo.

  override method consumoBase() = 50 * cantidadMicros + 10         // consumo base
  override method computoBase() = 800.min(100 * cantidadMicros)    // (100 * cantidadMicros).min(800)  // computo base

  override method extraComputoPorOverclock() = 20 * cantidadMicros     // los B2 la incrementan en 20 unidades por micro

}

// -----------------------------------------------------------------------------------------------------------
// MODOS
// -----------------------------------------------------------------------------------------------------------

object standard {
  method consumoDe(equipo) = equipo.consumoBase()
  method computoDe(equipo) = equipo.computoBase()
}

class Overclock {
  var property cantVecesAntesDeQuemarse      // al pasar a modo overclock un equipo sólo podrá usarse cierta cantidad de veces antes de quemarse (el número exacto es arbitrario y varía cada vez se overclockea)
  
  method consumoDe(equipo) = equipo.consumoBase() * 2  // consumen el doble de energía
  method computoDe(equipo) = equipo.computoBase() + equipo.extraComputoPorOverclock()  

  method computarSub_problema(complejidad) {
    
  }
}

object ahorroDeEnergia {
  method consumoDe(equipo) = 200    // no importa su tipo, sólo consuma 200 watts
  method computoDe(equipo) = (equipo.consumo() / equipo.consumoBase()) * equipo.computoBase() // ((200 / 400) * computoBase)
}