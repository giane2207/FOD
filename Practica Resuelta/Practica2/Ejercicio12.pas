Program Ejercicio11;
const 
    valorAlto = '9999';
type
    acceso = record 
        anio: String[4];
        mes: integer;
        dia: integer;
        idUser: integer;
        tiempoAcceso: real;
    end;

    maestro = file of acceso;


    procedure leer (var mae: maestro, var dato: acceso);
    begin
        if not EOF(mae) then
            read(mae, dato)
        else 
            dato.anio := valorAlto;    
    end;

    procedure informar (var mae: maestro, anio: String[4]);
    var
       regMae: acceso;
       totalDia, totalMes, totalAnio, totalUser: real;
       anioActual: String[4];
       diaActual, mesActual, idUser: integer;
    begin
        reset(mae);
        leer(mae,regMae);
        while (regMae.anio <> valorAlto) and (regMae.anio <> anio) do
            leer(mae, regMae);

        if regMae.anio <> valorAlto then begin
            seek(mae, filePos(mae)-1);
            
            writeln('Anio: ', anio);
            totalAnio:= 0;
            while (regMae.anio <> valorAlto) and (regMae.anio = anio) do begin
                mesActual := regMae.mes;
                totalMes:= 0;
                writeln('Mes: ', mesActual);

                while (regMae.anio = anio) and (mesActual = regMae.mes) do begin
                    totalDia := 0;
                    diaActual := regMae.dia;
                    writeln('Dia: ', diaActual);

                    while (regMae.anio = anio) and (mesActual = regMae.mes) and (diaActual = regMae.dia) do begin
                        totalUser:= 0;
                        idUser := regMae.idUser;

                        while (regMae.anio = anio) and (mesActual = regMae.mes) and (diaActual = regMae.dia) and (idUser = regMae.idUser) do begin
                            totalUser := totalUser + regMae.tiempoAcceso;
                            leer(mae, regMae);
                        end;

                        writeln('IdUsuario: ', idUser, 'Tiempo total de acceso en el dia: ', totalUser, 'mes ', mesActual);
                        totalDia:= totalDia + totalUser;
                    end;

                    writeln('Tiempo total de acceso en el dia ', diaActual, 'mes ', mesActual, 'es ', totalDia );
                    totalMes:= totalMes + totalDia;
                end;

                writeln('Tiempo total de acceso mes ', mesActual, 'es ', totalMes);
                totalAnio:= totalAnio + totalMes;
            end;

            writeln('Tiempo total de acceso al anio ', anio, ': ', totalAnio);
        end
        else writeln('No se encontro el anio');

        close(mae);
    end;

var
    mae: maestro;
    anio: String[4];
begin
    assign(mae, 'archivo_maestro');
    writeln('Ingrese un año');
    readln(anio);
    informar(mae, anio);
end.