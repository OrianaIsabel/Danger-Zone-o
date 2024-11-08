class Empleado {
  var salud
  method salud() = salud
  method saludCritica()
  
  const habilidades
  method habilidades() = habilidades
  method puedeUsar(habilidadReq) = habilidades.contains(habilidadReq) && !(self.estaIncapacitado())
  method poseeHabilidades(requeridas) = requeridas.all({habilidadReq => self.puedeUsar(habilidadReq)})

  method estaIncapacitado() = salud < self.saludCritica()

  method recibirDanio(danio) {
    salud = salud - danio
  }
  
  method registrarMision(mision)
  method finalizarMision(mision) {
    if (salud > 0) self.registrarMision(mision)
  }
}

class Espia inherits Empleado {
  override method saludCritica() = 15

  override method registrarMision(mision) {
    habilidades.addAll(mision.requerido())
    habilidades.asSet()
  }
}

class Oficinista inherits Espia {
  var estrellas
  method estrellas() = estrellas
  
  method puedeSerEspia() = estrellas >= 3

  override method saludCritica() = if (self.puedeSerEspia()) super() else {40 - 5 * estrellas}

  override method registrarMision(mision) {
    if (self.puedeSerEspia()) 
      {super(mision)
      return null} 
    else 
      {estrellas = estrellas + 1 
      return null}
  }
}

class Equipo {
  const integrantes = []

  method poseeHabilidades(requeridas) = integrantes.any({integrante => integrante.poseeHabilidades(requeridas)})

  method recibirDanio(danio) {
    integrantes.forEach({integrante => integrante.recibirDanio(danio/3)})
  }

  method finalizarMision(mision) {
    integrantes.forEach({integrante => integrante.finalizarMision(mision)})
  }
}

class EspiaJefe inherits Espia {
  const subordinados

  override method puedeUsar(habilidadReq) = super(habilidadReq) && subordinados.any({subordinado => subordinado.puedeUsar(habilidadReq)})
}

class OficinistaJefe inherits Oficinista {
  const subordinados

  override method puedeUsar(habilidadReq) = super(habilidadReq) && subordinados.any({subordinado => subordinado.puedeUsar(habilidadReq)})
}

class Mision {
  const requerido
  method requerido() = requerido
  const peligrosidad

  method puedeCumplir(alguien) = alguien.poseeHabilidades(requerido)

  method serCumplida(alguien) {
    if (self.puedeCumplir(alguien))
    {alguien.recibirDanio(peligrosidad)
    alguien.finalizarMision(self)
    } 
    else {}
  }
}

const jim = new Oficinista(salud = 20, habilidades = [leer, escribir], estrellas = 0)
const pam = new Oficinista(salud = 18, habilidades = [leer, escribir, dibujar], estrellas = 2)
const dwigth = new Espia(salud = 60, habilidades = [leer, disparar])
const michael = new EspiaJefe(salud = 30, habilidades = [disparar], subordinados = [jim, pam, dwigth])
const ryan = new Oficinista(salud = 40, habilidades = [leer, disparar], estrellas = 2)

object leer {}
object escribir {}
object dibujar {}
object disparar {}

const laOficina = new Mision(requerido = [disparar], peligrosidad = 10)

const equipo1 = new Equipo(integrantes = [michael, jim ,pam])