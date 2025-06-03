Program Ejercicio14;
const 
    valorAlto = '9999';
type
    str4 = String[4];

    infoMae = record  
        destino: str4;
        fecha: str4;
        horaSalida: integer;
        asientosDisponibles: integer;
    end;

    infoDet = record
        destino: str4;
        fecha: str4;
        horaSalida: integer;
        asientosComprados: integer;
    end;

    infoLista = record  
        destino: str4;
        fecha: str4;
        horaSalida: integer;
    end;

    lista = ^nodo;
    nodo = record
        dato: infoLista;
        sig: lista;
    end;

    maestro = file of infoMae;
    detalle = file of infoDet;

    procedure agregarAdelante(var L: lista; valor: infoLista);
    var
      nuevo: lista;
    begin
        new(nuevo);           
        nuevo^.dato := valor; 
        nuevo^.sig := L;      
        L := nuevo;           
    end;

    procedure leer (var det: detalle, var dato: infoDet);
    begin
        if not EOF(det) then
            read(det, dato)
        else 
            dato.destino := valorAlto;    
    end;

    procedure minimo(var reg1, reg2, min: infoDet; var det1, det2: detalle);
    begin
        if (reg1.destino < reg2.destino) or
        ((reg1.destino = reg2.destino) and (reg1.fecha < reg2.fecha)) or
        ((reg1.destino = reg2.destino) and (reg1.fecha = reg2.fecha) and (reg1.horaSalida <= reg2.horaSalida)) then
        begin
            min := reg1;
            leer(det1, reg1);
        end
        else begin
            min := reg2;
            leer(det2, reg2);
        end;
    end;

   
    procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle; var L: lista; asientos: integer);
    var
        regMae: infoMae;
        regDet1, regDet2, min: infoDet;
        regLista: infoLista;
        totalComprados: integer;
    begin
        reset(mae);
        reset(det1);
        reset(det2);

        leer(det1, regDet1);
        leer(det2, regDet2);
        minimo(regDet1, regDet2, min, det1, det2);

        while not EOF(mae) do begin
            read(mae, regMae);

            totalComprados := 0;
            while (min.destino = regMae.destino) and (min.fecha = regMae.fecha) and (min.horaSalida = regMae.horaSalida) do begin
                totalComprados := totalComprados + min.asientosComprados;
                minimo(regDet1, regDet2, min, det1, det2);
            end;

            regMae.asientosDisponibles := regMae.asientosDisponibles - totalComprados;
            seek(mae, filePos(mae) - 1);
            write(mae, regMae);

            if regMae.asientosDisponibles < asientos then begin
                regLista.destino := regMae.destino;
                regLista.fecha := regMae.fecha;
                regLista.horaSalida := regMae.horaSalida;
                agregarAdelante(L, regLista);
            end;
        end;

        close(mae);
        close(det1);
        close(det2);
    end;
    

var

    mae: maestro;
    det1, det2: detalle;
    asientos: integer;
    L: lista;
begin
    assign(mae, 'archivo_maestro');
    assign(det1, 'archivo_detalle1');
    assign(det2, 'archivo_detalle2');
    L:= nil;

    writeln('Ingrese una cantidad de asientos');
    readln(asientos);
    actualizarMaestro(mae, det1,det2, L,, asientos);



end.