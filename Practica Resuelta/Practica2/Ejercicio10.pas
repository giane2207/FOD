program Ejercicio10;

const 
    valorAlto = '9999';
type

    infoMaestro = record
        codProvincia: String[4];
        codLocalidad: String[4];
        numMesa: integer;
        cantVotos: integer;
    end;

    maestro = file of infoMaestro;

    procedure leer(var mae: maestro; var dato: infoMaestro);
    begin
        if not EOF(mae) then
            read(mae, dato)
        else 
            dato.codProvincia := valorAlto;    
    end;

    procedure obtenerReporte(var mae: maestro);
    var 
        regMae: infoMaestro;
        provinciaActual: String[4];
        localidadActual: String[4];
        totalVotos, totalProvincia, totalLocalidad: integer;
    begin
        reset(mae);
        leer(mae, regMae);
        totalVotos := 0;
        
        while (regMae.codProvincia <> valorAlto) do begin
            provinciaActual := regMae.codProvincia;
            totalProvincia := 0;
            writeln('---------------------------------------')
            writeln('Codigo de provincia: ', provinciaActual);

            while (provinciaActual = regMae.codProvincia) do begin
                localidadActual := regMae.codLocalidad;
                totalLocalidad := 0;
                writeln('Codigo de localidad: ', localidadActual);

                while (provinciaActual = regMae.codProvincia) and (localidadActual = regMae.codLocalidad) do begin
                    totalLocalidad := totalLocalidad + regMae.cantVotos;
                    leer(mae, regMae);
                end;

                writeln ('Total votos de la localidad: ', totalLocalidad);
                totalProvincia := totalProvincia + totalLocalidad;
            end;

            writeln ('Total votos de la provincia: ', totalProvincia);
            totalVotos := totalVotos + totalProvincia;
        end;

        writeln('Total de votos general: ', totalVotos);
        close(mae);
    end;

var
    mae: maestro;
begin
    assign(mae, 'archivo_maestro');
    obtenerReporte(mae);
end.
