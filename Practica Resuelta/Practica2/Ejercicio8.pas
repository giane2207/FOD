program Ejercicio8;
const
    valorAlto = '9999';
    cantArchivos = 16;
type 
    infoMaestro = record
        codProvincia: String[4];
        nombreProvincia: String[20];
        habitantes: integer;
        totalYerbaConsumida: integer;
    end;

    infoDetalle = record
        codProvincia: String[4];
        yerbaConsumida: integer;
    end;

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;

    vecDetalles = array [1..cantArchivos] of detalle;
    regDetalles = array [1..cantArchivos] of infoDetalle;

    procedure leer (var archivo: detalle; var dato: infoDetalle);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.codProvincia := valorAlto;    
    end;

    procedure minimo(var dets: vecDetalles; var regs: regDetalles; var min: infoDetalle);
    var
      i, pos: integer;
    begin
        min.codProvincia := valorAlto;

        for i := 1 to cantArchivos do
            if regs[i].codProvincia < min.codProvincia then begin
                min := regs[i];
                pos := i;
            end;
            
        if min.codProvincia <> valorAlto then
            leer(dets[pos], regs[pos]);
    end;

    procedure actualizarMaestro (var mae: maestro, var vecDet: vecDetalles, var regDet: regDetalles);
    var
        min: infoDetalle;
        regMae: infoMaestro;
        provActual: String[4];
        yerbaConsumida, i: integer;
    begin
        for i := 1 to cantArchivos do begin
            reset(vecDet[i]);
            leer(vecDet[i], regDet[i]);
        end;
        reset(mae);

        minimo(vecDet, regDet, min);
        
        while (min.codProvincia <> valorAlto) do begin  
            provActual := min.codProvincia;
            yerbaConsumida := 0;

            while (min.codProvincia = provActual) do begin  
                yerbaConsumida := yerbaConsumida + min.yerbaConsumida;
                minimo(vecDet, regDet, min);
            end;

            read(mae, regMae);
            while (regMae.codProvincia <> provActual) do 
                read(mae, regMae);
            
            regMae.totalYerbaConsumida := regMae.totalYerbaConsumida + yerbaConsumida;
            seek(mae, filepos(mae) - 1);
            write(mae, regMae);
        end;

        close(mae);
        for i := 1 to cantArchivos do
            close(vecDet[i]);
    end;

    procedure informar (var mae: maestro);
    var 
        regMae: infoMaestro;
        promedio: real;
    begin
        reset(mae);
        while not eof(mae) do begin 
            read(mae, regMae);
            if (regMae.totalYerbaConsumida > 10000) then begin      
                promedio := regMae.totalYerbaConsumida / regMae.habitantes;
                writeln('Codigo provincia: ', regMae.codProvincia);
                writeln('Nombre provincia: ', regMae.nombreProvincia);
                writeln('Promedio de yerba consumida', promedio:0:1);
            end;
        end;
        close(mae);
    end;

var
    mae: maestro;
    vecDet: vecDetalles;
    regDet: regDetalles;
    i: integer;
    nro_detalle: String;
begin
    assign(mae, 'archivo_maestro');
    
     for i := 1 to cantArchivos do begin
        nro_detalle := IntToStr(i);
        assign(vecDet[i], 'det' + nro_detalle);
    end;

    actualizarMaestro(mae, vecDet, regDet);
    informar(mae);
end.