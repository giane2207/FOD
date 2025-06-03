program ejercicio6;
const
    valorAlto= '9999';
type
    str4 = String[4];
    str20 = String[20];
    prenda = record
        cod: str4;
        descripcion: str20;
        colores: str20;
        tipo: str20;
        stock: integer;
        precio: real;
    end;

    maestro = file of prenda;
    detalle = file of str4;

    procedure leer(var det: detalle; var dato: str4);
    begin
        if not eof(det) then
            read(det, dato)
        else
            dato:= valorAlto;
    end;

    procedure eliminarPrendas(var mae: maestro; var det: detalle);
    var
        regMae: prenda;
        regDet: str4;
    begin
        reset(mae);
        reset(det);
        leer(det, regDet);

        while(regDet <> valorAlto) do begin
            seek(mae, 0);

            read(mae, regMae);
            while(regMae.cod <> regDet) do 
                read(mae, regMae);
            
            regMae.stock := -regMae.stock;
            seek(mae, FilePos(mae) - 1);
            write(mae, regMae);

            leer(det, regDet);
        end;

        close(mae);
        close(det);
    end;

    procedure crearNuevo (var mae, nue: maestro);
    var
        reg: prenda;
    begin
        reset(mae);
        rewrite(nue);
         
        while not eof(mae) do begin
            read(mae, reg);
            if (reg.stock > 0) then 
                write(nue, reg);
        end;
        close(mae);
        close(nue);

        rename(mae, 'archivo_maestro_old');
        rename(nue, 'archivo_maestro');
    end;


var
    nue, mae: maestro;
    det: detalle;
begin
    assign(mae,'archivo_maestro');
    assign(det, 'archivo_detalle');
    assign(nue, 'nuevo_maestro');

    eliminarPrendas(mae, det);
    crearNuevo(mae, nue);
end.