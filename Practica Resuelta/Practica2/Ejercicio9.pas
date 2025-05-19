program Ejercicio9;

const 
    valorAlto = '9999';
type
    cliente = record
        cod: String[4];
        nombre: String[20];
        apellido: String[20];
    end;

    infoMaestro = record
        cli: cliente;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    maestro = file of infoMaestro;

procedure leer(var mae: maestro; var dato: infoMaestro);
begin
    if not EOF(mae) then
        read(mae, dato)
    else 
        dato.cli.cod := valorAlto;    
end;

procedure obtenerReporte(var mae: maestro);
var 
    cliActual: cliente;
    regMae: infoMaestro;
    totalVentas, totalMes, totalAnio: real;
    anioActual, mesActual: integer;
begin
    reset(mae);
    leer(mae, regMae);
    totalVentas := 0;
    
    while (regMae.cli.cod <> valorAlto) do
    begin
        cliActual := regMae.cli;
        writeln('----------------------------------------');
        writeln('Cliente: ', cliActual.cod, ' - ', cliActual.nombre, ' ', cliActual.apellido);
        
        totalAnio := 0;
        while (regMae.cli.cod = cliActual.cod) do begin
            anioActual := regMae.anio;
            writeln('  Año: ', anioActual);
            
            while (regMae.cli.cod = cliActual.cod) and (regMae.anio = anioActual) do begin
                mesActual := regMae.mes;
                totalMes := 0;

                while (regMae.cli.cod = cliActual.cod) and (regMae.anio = anioActual) and (regMae.mes = mesActual) do begin
                    totalMes := totalMes + regMae.monto;
                    leer(mae, regMae);
                end;

                writeln('    Mes ', mesActual, ': $', totalMes:0:2);
                totalAnio := totalAnio + totalMes;
                totalVentas := totalVentas + totalMes;
            end;

            writeln('  Total anual: $', totalAnio:0:2);
        end;
    end;

    writeln('----------------------------------------');
    writeln('TOTAL VENTAS DE LA EMPRESA: $', totalVentas:0:2);
    close(mae);
end;

var
    mae: maestro;
begin
    assign(mae, 'archivo_maestro');
    obtenerReporte(mae);
end.
