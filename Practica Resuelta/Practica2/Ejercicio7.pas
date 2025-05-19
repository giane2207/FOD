program Ejercicio7;
uses sysutils;
const
    valorAlto = '9999';
type   
    alumno = record 
        cod: String[4];
        apellido: String[10];
        nombre: String[10];
        cursadasAprobadas: integer;
        finalesAprobados: integer;
    end;

    cursada = record
        cod: String[4];
        codMateria: String[4];
        anio: integer[4];
        resultado: String[15];
    end;

    final = record  
        cod: String[4];
        codMateria: String[4];
        fecha: String[8];
        nota: integer;
    end;

    maestro = file of alumno;
    detalleCursadas = file of cursada;
    detalleFinales = file of final;

    procedure leerCursada (var archivo: detalleCursadas; var dato: cursada);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.cod := valorAlto;    
    end;

    procedure leerFinal (var archivo: detalleCursadas; var dato: final);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.cod := valorAlto;    
    end;

    procedure actulizarMaestro(var mae: maestro; var detCursada: detalleCursadas; var detFinales: detalleFinales);
    var
       regCursada: cursada;
       regFinal: final;
       regMae: alumno;
       cantFinalesAprobados, cantCursadasAprobadas, codActual: integer;
    begin
        reset(mae);
        reset(detCursadas);
        reset(detFinales);

        leerCursada(detCursada, regCursada);
        leerFinal(detFinales, regFinal);

        while not eof(mae) do begin 
            read(mae, regMae);
            codActual := regMae.cod;

            cantFinalesAprobados := 0;
            cantCursadasAprobadas := 0;

            while (regCursada.cod = codActual) do begin
                if (regCursada.resultado = 'Aprobado') then
                    cantCursadasAprobadas = cantCursadasAprobadas + 1;
                leerCursada(detCursada, regCursada);
            end;

            while (regFinal.cod = codActual) do begin
                if (regFinal.nota >= 4) then
                    cantFinalesAprobados = cantFinalesAprobados + 1;
                leerFinal(detFinales, regFinal);
            end;

            regMae.cursadasAprobadas = regMae.cursadasAprobadas + cantCursadasAprobadas;
            regMae.finalesAprobados = regMae.finalesAprobados + cantFinalesAprobados;

            seek(mae, filepos(mae) - 1);
            write(mae, regMae);
        end;
        close(mae);
        close(detCursadas);
        close(detFinales);
    end;

var
    mae: maestro;
    detCursadas: detalleCursadas;
    detFinales: detalleFinales;

begin
    assign(mae, 'archivo_maestro');
    assign(detalleCursadas, 'archivo_cursadas');
    assign(detalleFinales, 'archivo_finales');
    actualizarMaestro(mae, detalleCursadas, detalleFinales);
end.