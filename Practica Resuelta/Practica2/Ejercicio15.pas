Program Ejercicio15;
const 
    valorAlto = '9999';
    cantArchivos= 10;
type
    str4 = String[4];

    infoMae = record  
        codProvincia: str4;
        nombreProvincia: string;
        codLocalidad: str4;
        nombreLocalidad: string;
        cantSinLuz:integer;
        cantSinGas:integer;
        cantDeChapa:integer;
        cantSinAgua:integer;
        cantSinSanitario:integer;
    end;

    infoDet = record
        codProvincia: str4;
        codLocalidad: str4;
        cantConLuz: integer;
        cantConstruidas:integer;
        cantConAgua:integer;
        cantConGas:integer;
    end;

    maestro = file of infoMae;
    detalle = file of infoDet;

    vecDetalle = array [1..cantArchivos] of detalle;
    regDetalle = array [1..cantArchivos] of infoDet;
    
    procedure leer (var det: detalle, var dato: infoDet);
    begin
        if not EOF(det) then
            read(det, dato)
        else 
            dato.codProvincia := valorAlto;    
    end;

    procedure minimo (var detalles: vecDetalle; var regd: regDetalle; var min: infoDet);
    var 
        i, posMin: integer;
    begin
        posMin := 1;
        for i := 1 to cantArchivos do begin
            if (regd[i].cod <= regd[posMin].cod) then begin
                min := regd[i];
                posMin := i;
            end;
        end;

        leer(detalles[posMin], regd[posMin]);
    end;
   
    procedure actualizarMaestro(var mae: maestro; var dets: vecDetalle; var regs: regDetalle);
    var
        min: infoDet;
        regMae: infoMae;
        i: integer;
    begin
        reset(mae);
        for i := 1 to cantArchivos do begin
            reset(dets[i]);
            leer(dets[i], regs[i]);
        end;

        read(mae, regMae);
        minimo(dets, regs, min);

        while (min.codProvincia <> valorAlto) do begin
            // Avanzamos en el maestro hasta encontrar la localidad correspondiente
            while (regMae.codProvincia <> min.codProvincia) or (regMae.codLocalidad <> min.codLocalidad) do
                read(mae, regMae);

            // Coincidencia encontrada, actualizamos
            regMae.cantSinLuz := regMae.cantSinLuz - min.cantConLuz;
            regMae.cantSinAgua := regMae.cantSinAgua - min.cantConAgua;
            regMae.cantSinGas := regMae.cantSinGas - min.cantConGas;
            regMae.cantSinSanitario := regMae.cantSinSanitario - min.cantSanitarios;
            regMae.cantDeChapa := regMae.cantDeChapa - min.cantConstruidas;

            // Volver a escribir el registro actualizado
            seek(mae, filepos(mae) - 1);
            write(mae, regMae);

            minimo(dets, regs, min);
        end;        

        close(mae);
        for i := 1 to cantArchivos do
            close(dets[i]);
    end;
        
    procedure contabilizar (var mae: maestro);
    var
        localidadSinChapa: integer;
    begin
        reset(mae);
        localidadSinChapa:= 0;
        reset(mae);
        
        while not eof(mae) do begin
            read(mae, regMae);
            if regMae.cantDeChapa = 0 then
                localidadSinChapa := localidadSinChapa + 1;
        end;
        writeln('Cantidad de localidades sin viviendas de chapa: ', localidadSinChapa);

        close(mae);
    end;

var

    mae: maestro;
    vecDet: vecDetalle;
    regDet: regDetalle;
    nro_detalle: string;
begin
    assign(mae, 'archivo_maestro');
    for i := 1 to cantArchivos do begin
        nro_detalle := IntToStr(i);
        assign(detalles[i], 'det' + nro_detalle);
    end;

    actualizarMaestro(mae, vecDet, regDet);


end.