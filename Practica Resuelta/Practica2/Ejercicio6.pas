{6. Se desea modelar la información necesaria para un sistema de recuentos de casos de 
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información contenida en 
los mismos es la siguiente: código de localidad, código cepa, cantidad de casos activos, cantidad de casos nuevos, 
cantidad de casos recuperados, cantidad de casos fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, nombre localidad, 
código cepa, nombre cepa, cantidad de casos activos, cantidad de casos nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles recibidos, 
se reciben 10 detalles. Todos los archivos están ordenados por código de localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:

    1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
    2. Idem anterior para los recuperados.
    3. Los casos activos se actualizan con el valor recibido en el detalle.
    4. Idem anterior para los casos nuevos hallados.
    
Realice las declaraciones necesarias, el programa principal y los procedimientos que requiera para la actualización solicitada e informe cantidad de localidades con más de 50 casos activos (las localidades pueden o no haber sido actualizadas).}


program Ejercicio6;
uses sysutils;
const
    valorAlto = '9999';
    cantArchivos = 10;
type
    infoDetalle = record
        cod: String[4];
        codCepa: String[4];
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    infoMaestro = record
        cod: String[4];
        codCepa: String[4];
        nombreLocalidad: String[20];
        nombreCepa: String[20];
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;

    vecDetalles = array [1..cantArchivos] of detalle;
    vecRegistros = array [1..cantArchivos] of infoDetalle;

    procedure leer (var archivo: detalle; var dato: infoDetalle);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.cod := valorAlto;    
    end;

    procedure minimo(var detalles: vecDetalles; var regd: vecRegistros; var min: infoDetalle);
    var
        i, posMin: integer;
    begin
        posMin := -1;
        min.cod := valorAlto; // Inicializo el minimo como muy grande
        for i := 1 to cantArchivos do begin

            // Comparo si el registro actual es menor al minimo
            if (regd[i].cod < min.cod) or ((regd[i].cod = min.cod) and (regd[i].codCepa < min.codCepa)) then begin
                 min := regd[i];    
                 posMin := i;      
                end;
        end;

        if (min.cod <> valorAlto) then
            leer(detalles[posMin], regd[posMin]);
    end;

    procedure inicializarCampos(var actual: infoDetalle);
    begin
        actual.nuevos := 0;
        actual.activos := 0;
        actual.recuperados := 0;
        actual.fallecidos := 0;
    end;

    procedure actualizarCampos (var actual: infoDetalle; min: infoDetalle);
    begin
        actual.nuevos := actual.nuevos + min.nuevos;
        actual.activos := actual.activos + min.activos;
        actual.recuperados := actual.recuperados + min.recuperados;
        actual.fallecidos := actual.fallecidos + min.fallecidos;
    end;

   procedure actualizarMaestro (var mae: maestro; var detalles: vecDetalles; var regDetalles: vecRegistros);
    var
        i, cantLocalidadesConMasDe50: integer;
        min, actual: infoDetalle;
        regm: infoMaestro;
        codLocalidadActual: string[4];
        casosActivosLocalidad: integer;
    begin
        cantLocalidadesConMasDe50 := 0;

        // Abro los archivos detalle
        for i := 1 to cantArchivos do begin
            reset(detalles[i]);
            leer(detalles[i], regDetalles[i]);
        end;

        reset(mae);
        minimo(detalles, regDetalles, min);

        while (min.codLocalidad <> valorAlto) do begin
            actual.cod := min.cod;
            casosActivosLocalidad := 0;

            // Mientras siga en la misma localidad
            while (min.cod = actual.cod) do begin
                inicializarCampos(actual);
                actual.codCepa := min.codCepa;

                while (min.cod = actual.cod) and (min.codCepa = actual.codCepa) do begin
                    actualizarCampos(actual, min);
                    minimo(detalles, regDetalles, min);
                end;

                // Buscar en el maestro el registro correspondiente
                while not eof(mae) and ((regm.codLocalidad <> actual.codLocalidad) or (regm.codCepa <> actual.codCepa)) do
                    read(mae, regm);

                if (regm.codLocalidad = actual.codLocalidad) and (regm.codCepa = actual.codCepa) then begin
                    regm.fallecidos := regm.fallecidos + actual.fallecidos;
                    regm.recuperados := regm.recuperados + actual.recuperados;
                    regm.activos := actual.activos;
                    regm.nuevos := actual.nuevos;

                    seek(mae, filepos(mae) - 1);
                    write(mae, regm);

                    casosActivosLocalidad := casosActivosLocalidad + actual.activos;
                end;
            end;

            if (casosActivosLocalidad > 50) then
                cantLocalidadesConMasDe50 := cantLocalidadesConMasDe50 + 1;
    end;

    close(mae);
    for i := 1 to cantArchivos do
        close(detalles[i]);

    writeln('Cantidad de localidades con más de 50 casos activos: ', cantLocalidadesConMasDe50);
end;

var
    mae: maestro;
    detalles: vecDetalles;
    regDetalles: vecRegistros;
    i: integer;
    nro_detalle: String;
begin
    assign(mae, 'archivo_maestro');

     for i := 1 to cantArchivos do begin
        nro_detalle := IntToStr(i);
        assign(detalles[i], 'det' + nro_detalle);
    end;

    actualizarMaestro(mae, detalles, regDetalles);  
end.