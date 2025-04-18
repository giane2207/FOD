program Ejercicio3;
const
    valorAlto = '9999';
type
    provincia = record
        nombre: String[4];
        cantAlfabetizados: integer;
        totalEncuestados: integer;
    end;

    agencia = record
        nombre: String[4];
        cod: integer;
        cantAlfabetizados: integer;
        totalEncuestados: integer;
    end;

    maestro = file of provincia;
    detalle = file of agencia;

    procedure leer (var archivo: detalle; var dato: agencia);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.nombre := valorAlto;    
    end;

    procedure minimo(var det1, det2: detalle; var reg1, reg2, min: agencia);
    begin
        if (reg1.nombre <= reg2.nombre) then begin
            min := reg1;
            leer(det1, reg1);
        end
        else begin
            min := reg2;
            leer(det2, reg2);
        end;
    end;

    procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle);
    var
        regm, aux: provincia;
        reg1, reg2, min: agencia;
    begin
        reset(mae);
        reset(det1);
        reset(det2);

        read(mae, regm);
        leer(det1, reg1);
        leer(det2, reg2);
        minimo(det1, det2, reg1, reg2, min);

        while(min.nombre <> valorAlto) do begin 
            aux.nombre := min.nombre;
            aux.cantAlfabetizados := 0;
            aux.totalEncuestados := 0;

            while (aux.nombre = min.nombre) do begin    
                aux.cantAlfabetizados := aux.cantAlfabetizados + min.cantAlfabetizados;
                aux.totalEncuestados := aux.totalEncuestados + min.totalEncuestados;
                minimo(det1, det2, reg1, reg2, min);
            end;

            while (aux.nombre <> regm.nombre) do
                read(mae, regm);
            
            regm.cantAlfabetizados := aux.cantAlfabetizados;
            regm.totalEncuestados := aux.totalEncuestados;

            seek(mae, FilePos(mae)-1);
            write(mae, regm);

            if not (eof(mae)) then
                read(mae, regm);
        end;
        close(mae);
        close(det1);
        close(det2);
    end;

var
    mae: maestro;
    det1, det2: detalle;
begin
    assign(mae, 'archivo_maestro');
    assign(det1, 'archivo_detalle1');
    assign(det2, 'archivo_detalle2');
  
    actualizarMaestro(mae, det1,det2);
end.