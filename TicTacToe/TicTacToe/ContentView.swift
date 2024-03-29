//
//  ContentView.swift
//  TicTacToe
//
//  Created by 8FDAM on 29/11/22.
//

import SwiftUI


struct ContentView: View {
    
    //quiero 3 columnas
    let matriz: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    //Move?: no sabemos si jugador hace click en circulo, si no es nil
    //creamos array de 9 posiciones con nil y segun se hace click, se cambia a Move
    @State var turnos: [Move?] = Array(repeating: nil, count: 9)
    @State var turnoJugadorPrimero = true
    @State var scoreX : Int = 0
    @State var scoreO : Int = 0
    @State var jugadorActual: Jugador?
    @State var estaAlerta = false
    @State var mensaje: String = ""
    
    var body: some View {
        
        VStack{
            Spacer()
            
            LazyVGrid(columns: matriz){
                //cambia fila automaticamente, porque puede tener solo 3 columnas
                ForEach(0..<9){ i in
                    //quiero que en cada circulo aparece texto cuando hago click, por eso ZStack (circulo y texto)
                    ZStack{
                        Rectangle().foregroundColor(Color("Juego"))
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .padding(.all, 20)
                        //si es nill es vacio, si no pongo indicator
                        Image(systemName: turnos[i]?.indicator ?? "")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                    }.onTapGesture {
                        if comprobarBoton(turnos: turnos, index: i) == false{
                            //identiciar jugador
                            if turnoJugadorPrimero == true{
                                jugadorActual = Jugador.jugador1
                            }
                            else{
                                jugadorActual = Jugador.jugador2
                            }
                            
                            //hacer movimiento, se cambia nill a Move en posicion de array
                            turnos[i] = Move(jugador: jugadorActual ?? Jugador.jugador1, indiceTabla: i)
                            //cambio turno, boolean se cambia
                            turnoJugadorPrimero.toggle()
                            
                            //comprobar si hay ganador
                            if comprobarGanador(turnos: turnos) == true{
                                if jugadorActual == Jugador.jugador1{
                                    scoreX = scoreX + 1
                                    estaAlerta = true
                                    mensaje = "Fin de juego. Ha ganado Jugador X."
                                    limpiarTablero()

                                }
                                else{
                                    scoreO = scoreO + 1
                                    estaAlerta = true
                                    mensaje = "Fin de juego. Ha ganado Jugador O."
                                    limpiarTablero()

                                }
                            }
                            else {
                                if comprobrEmpate(turnos: turnos) == true{
                                    estaAlerta = true
                                    mensaje = "Fin de juego. Empate!"
                                    limpiarTablero()

                                }
                            }
                        }
                    }.padding(.vertical, -20)
                    
                }
                  
                Spacer()
                
                VStack{
                    
                    HStack{
                        Text(String(format: "\(scoreX)"))
                            .font(.largeTitle)
                            .foregroundColor(Color("Letras"))
                        
                        Text(String(format: "\(scoreO)"))
                            .font(.largeTitle)
                            .foregroundColor(Color("Letras"))
                    }
                    
                    HStack{
                        //de app simbolos SF
                        Image(systemName: "xmark").foregroundColor(Color("Letras"))
                        Image(systemName: "circle").foregroundColor(Color("Letras"))
                    }
                }
               
            }.padding(.horizontal, 40)
            .alert(isPresented: $estaAlerta){
                Alert(title: Text("Fin de juego"), message: Text("\(mensaje)"), dismissButton: .default(Text("OK")))
            }
            
            
            Spacer()
        }
    }
    
    func comprobarBoton(turnos: [Move?], index: Int) -> Bool{
        //si esta ocupado, devuelve true y si no, devuelve false(no esta ocupado)
        if turnos[index] == nil{
            return false
        }
        else{
            return true
        }
    }
    
    func comprobarGanador(turnos: [Move?]) -> Bool{
        //comprueba todas posibles combinaciones
        if (turnos[0]?.jugador == turnos[1]?.jugador && turnos[1]?.jugador == turnos[2]?.jugador && (turnos[0] != nil)) {
                    return true;
                }
        if (turnos[3]?.jugador == turnos[4]?.jugador && turnos[4]?.jugador == turnos[5]?.jugador && turnos[3] != nil) {
                    return true;
                }
        if (turnos[6]?.jugador == turnos[7]?.jugador && turnos[7]?.jugador == turnos[8]?.jugador && turnos[6] != nil) {
                    return true;
                }
        if (turnos[0]?.jugador == turnos[4]?.jugador && turnos[4]?.jugador == turnos[8]?.jugador && turnos[0] != nil) {
                    return true;
                }
        if (turnos[2]?.jugador == turnos[4]?.jugador && turnos[4]?.jugador == turnos[6]?.jugador && turnos[2]?.jugador != nil) {
                    return true;
                }
        if (turnos[0]?.jugador == turnos[3]?.jugador && turnos[3]?.jugador == turnos[6]?.jugador && turnos[0] != nil) {
                    return true;
                }
        if (turnos[1]?.jugador == turnos[4]?.jugador && turnos[4]?.jugador == turnos[7]?.jugador && turnos[1] != nil) {
                    return true;
                }
        if (turnos[2]?.jugador == turnos[5]?.jugador && turnos[5]?.jugador == turnos[8]?.jugador && turnos[2] != nil) {
                    return true;
                }
                return false;
    }
    
    func comprobrEmpate(turnos: [Move?]) -> Bool{
        var contador = 0
        //comprobar si hay alguna posicion vacia
        for i in turnos{
            if i != nil{
                contador = contador + 1
            }
        }
        
        if contador == 9{
            return true
        }
        else{
            return false
        }
    }
    
    func limpiarTablero(){
        turnos = []
        for _ in 0..<9{
            turnos.append(nil)
        }
    }

}

enum Jugador{
    case jugador1
    case jugador2
}

struct Move{
    let jugador: Jugador
    let indiceTabla: Int
    
    //si juega primer jugador- X, si segundo- O
    var indicator: String{
        if jugador == .jugador1{
            return "xmark"
        }
        else{
            return "circle"
        }
    }
}
extension Move: Equatable{
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
