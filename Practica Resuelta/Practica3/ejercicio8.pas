program ejercicio8;
type 

    distribucion = record
        nombre: String;
        anio: integer;
        version: String;
        cantDesarrolladores: integer;
        descripcion: String;
    end;

    archivo_distribuciones = file of distribucion;

    procedure leerDistribucion(var d: distribucion);
    begin
        writeln('Ingrese el nombre de la distribución:');
        readln(d.nombre);
        
        writeln('Ingrese el año de lanzamiento:');
        readln(d.anio);
        
        writeln('Ingrese la versión:');
        readln(d.version);
        
        writeln('Ingrese la cantidad de desarrolladores:');
        readln(d.cantDesarrolladores);
        
        writeln('Ingrese una breve descripción:');
        readln(d.descripcion);
    end;

    function buscarDistribucion(var arch: archivo_distribuciones; nombre: String): integer;
    var 
        reg: distribucion;
        pos: integer;
        encontre: boolean;
    begin
        reset (arch);
        encontre:= false;
        pos := -1;

        while not eof(arch) and not(encontre)do begin 
            read(arch, reg);
            if (reg.nombre = nombre) then begin
                encontre:= true;
                pos:= FilePos(arch) - 1;
            end;
        end;
        buscarDistribucion := pos;
    end;

    procedure agregarDistribucion (var arch: archivo_distribuciones);
    var
        reg, regNuevo: distribucion;
        posCabezera: integer;
    begin
        reset(arch);
        leerDistribucion(regNuevo);

        //Verifico q la distribucion no exista
        if (buscarDistribucion(arch, regNuevo.nombre) = - 1) then begin
            read(arch, reg); // leo el registro cabezera

            if (reg.cantDesarrolladores < 0) then begin

                //Guardo la posicion del registro cabezera
                posCabezera := -reg.cantDesarrolladores;
                
                //Leo el registro eliminado
                seek(arch, posCabezera);
                read(arch, reg);

                //Escribo el nuevo registro en la posicion eliminada
                seek(arch, posCabezera);
                write(arch, regNuevo);

                //Escribo el registro eliminado en la cabezera
                seek(arch, 0);
                write(arch, reg);

            end
            else begin
                seek(arch, FileSize(arch));
                write(arch, regNuevo);
            end;

            writeln('se ha agregado la distribucion correctamente');
        end 
        else 
            writeln('Ya existe la distribucion dada');
    end;

    procedure eliminarDistribucion(var arch: archivo_distribuciones);
    var
        regEliminar, regCabezera: distribucion;
        nombre: String;
        posEliminar, posCabezera: integer;   
    begin
        reset(arch);
        writeln('Ingrese un nombre de distribucion a eliminar');
        readln(nombre);
        
        posEliminar := buscarDistribucion(arch, nombre);
        if (posEliminar <> -1) then begin
            // Leo el registro cabezera
            seek(arch, 0);
            read(arch, regCabezera); 

            //Leo el registro a eliminar
            seek(arch, posEliminar);
            read(arch, regEliminar);
            regEliminar.cantDesarrolladores:= -posEliminar;

            //Escribo el nuevo registro cabezera
            seek(arch, 0);
            write(arch, regEliminar);

            //Escribo el viejo cabezera en el eliminado
            seek(arch, posEliminar);
            write(arch, regCabezera);
        end
        else 
            writeln('Distribucion no existente');

        close(arch);        
    end;

var
    arch: archivo_distribuciones;
    opcion: byte;
begin
    assign(arch, 'archivo_distribuciones');
    repeat
        writeln('Ingrese la opcion deseada');
        writeln('1. Agregar distribucion');
        writeln('2. Eliminar distribucion');
        writeln('3. Salir');
        readln(opcion);

        case opcion of
            1: agregarDistribucion(arch);
            2: eliminarDistribucion(arch);
        end;
    until (opcion = 3);
end.