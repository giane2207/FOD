program ejercicio4;
type
    str45 = String[45];
    reg_flor = record
        nombre: str45;
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

    {Abre el archivo y agrega una flor, recibida como parámetro 
    manteniendo la política descrita anteriormente}
    procedure agregarFlor (var arch: tArchFlores ; nombre: string; codigo:integer);
    var
        reg, regNuevo: reg_flor;
        posCabezera: integer;
    begin
        reset(arch);
        regNuevo.nombre:= nombre;
        regNuevo.codigo := codigo;

        read(arch, reg); //leo la cabezera
        
        //Verifico si hay espacio libre
        if (reg.codigo < 0) then begin 
            // me guardo la posicion almacenada en el registro cabezera
            posCabezera := -reg.codigo;

            //Leo el registro borrado que sera el nuevo cabezera
            seek(arch, posCabezera);
            read(arch, reg);

            //Escribo el registro nuevo en la posicion libre
            seek(arch, posCabezera);
            write(arch, regNuevo);

            ///Escribo el registro borrado en la cabezera
            seek(arch, 0);
            write(arch, reg);
            
            writeln('Se ha agregado con exito!');
        end
        else begin
            seek(arch, FileSize(arch));
            write(arch, regNuevo);
        end;

        close(arch);
    end;

    {Abre el archivo y elimina la flor recibida como parámetro 
    manteniendo la política descripta anteriormente}
    procedure eliminarFlor (var arch: tArchFlores; flor:reg_flor);
    var
        reg, regCabezera: reg_flor;
        posLibre: integer;
        encontre: boolean;
    begin
        reset(arch);
        encontre:= false;
        
        while not eof(arch) and not(encontre) do begin
            read(arch, reg);
            if(reg.codigo = flor.codigo) then 
                encontre:= true;
        end;

        if(encontre) then begin
            // Guardo la posicion que va a ser eliminada
            posLibre := FilePos(arch) - 1;
            reg.codigo := -posLibre;

            // Leo el registro cabezera
            seek(arch, 0);
            read(arch, regCabezera);

            // Escribo el nuevo registro cabezera
            seek(arch, 0);
            write(arch, reg);

            // Escribo el registro cabezera en la posicion libre
            seek(arch, posLibre);
            write(arch, regCabezera);

            writeln('Se ha eliminado con exito');
        end
        else    
            writeln('No se encontro el codigo');

        close(arch);
    end;

    procedure listarFlores(var arch: tArchFlores);
    var 
        reg: reg_flor;
        txt: Text;
    begin
        reset(arch);
        assign(txt, 'listado_flores');
        rewrite(txt);
        writeln(txt, '|     Nombre     |    Codigo    |');

        while not eof(arch) do begin
            read(arch, reg);
            if (reg.codigo > 0) then
                writeln(txt, reg.nombre, '   |   ', reg.codigo);
        end;

        close(arch);
        close(txt);
    end;
var
    arch: tArchFlores;
    flor: reg_flor;
begin
    assign(arch, 'archivo_flores.dat');

    agregarFlor(arch, 'Rosa', 101);
    agregarFlor(arch, 'Tulipan', 102);
    agregarFlor(arch, 'Margarita', 103);
    agregarFlor(arch, 'Lirio', 104);
    agregarFlor(arch, 'Girasol', 105);
    flor.nombre := 'Tulipan';
    flor.codigo := 102;
    listarFlores(arch);
end.